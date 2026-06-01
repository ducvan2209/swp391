# Google Login Implementation Guide

## Executive Summary

This document provides a complete overview of the Google Login feature implementation in the SWP391 HRM System. The feature allows employees to authenticate using their Google account.

---

## Feature Overview

### What Users Can Do

1. **Traditional Login**: Email + Password authentication
2. **Google OAuth Login**: Sign in with Google account
3. **Account Security**: Failed login tracking, account locking, email verification
4. **Session Management**: Remember me functionality, session timeout

### Technology Stack

- **OAuth 2.0 Protocol**: Authorization framework
- **Google+ API**: User profile information retrieval
- **Apache HTTP Client**: API communication
- **GSON**: JSON parsing
- **Jakarta Servlet**: Request/response handling
- **JSP**: Server-side view rendering

---

## Architecture

### Component Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Web Browser                          │
└──────────────────┬──────────────────────────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
    ┌───▼────────┐        ┌──▼──────────┐
    │ Traditional│        │   Google    │
    │   Login    │        │  OAuth 2.0  │
    └───┬────────┘        └──┬──────────┘
        │                    │
        │         ┌──────────┴─────────┐
        │         │                    │
    ┌───▼─────────▼──────┐    ┌────────▼─────┐
    │  LoginServlet      │    │  GoogleLogin │
    │  (Controller)      │    │  (API Client)│
    └───┬────────────────┘    └────────┬─────┘
        │                             │
        │      ┌──────────────────────┘
        │      │
    ┌───▼──────▼─────────┐
    │  EmployeeDAO       │
    │  (Database Layer)  │
    └───┬────────────────┘
        │
    ┌───▼──────────────────┐
    │  Employee Database   │
    └──────────────────────┘
```

### Data Flow: Google Login

```
1. User clicks "Sign in with Google"
   ↓
2. Browser redirected to Google OAuth consent screen
   ↓
3. User approves permissions
   ↓
4. Google redirects to: /login?code=AUTH_CODE&state=...
   ↓
5. LoginServlet.doGet() receives code
   ↓
6. GoogleLogin.getToken(code) → Access Token
   ↓
7. GoogleLogin.getUserInfo(token) → User Profile
   ↓
8. EmployeeDAO.getEmployeeByEmailForAuth(email) → Employee Record
   ↓
9. Validate account state (active, email verified, not locked)
   ↓
10. AuthHelper.establishSession() → HttpSession
    ↓
11. Redirect to Dashboard
```

---

## Files & Their Roles

### Core Implementation Files

| File | Purpose |
|------|---------|
| `api/GoogleLogin.java` | OAuth token exchange & user info retrieval |
| `controller/LoginServlet.java` | Request handler for login (traditional & Google) |
| `helper/AuthHelper.java` | OAuth URL builder, session management |
| `helper/KeyLoader.java` | Load Google credentials from properties file |
| `model/GoogleAccount.java` | Google user profile data model |
| `dal/EmployeeDAO.java` | Database queries for employee authentication |

### Configuration Files

| File | Purpose |
|------|---------|
| `src/main/resources/google_key.properties` | Google OAuth credentials |
| `src/main/resources/messages.properties` | Error messages (MSG09-MSG14) |
| `src/main/resources/app.properties` | Application config (SMTP, base URL) |

### View Files

| File | Purpose |
|------|---------|
| `WEB-INF/views/login.jsp` | Login form + Google OAuth button |

### Documentation

| File | Purpose |
|------|---------|
| `docs/AUTH_SETUP.md` | Basic authentication setup |
| `docs/GOOGLE_LOGIN_SETUP.md` | Detailed Google OAuth configuration |
| `docs/GOOGLE_LOGIN_IMPLEMENTATION.md` | This file |

---

## Setup Instructions

### Phase 1: Google Cloud Console Configuration

**Time Required**: 10-15 minutes

1. Create Google Cloud Project
2. Enable Google+ API
3. Create OAuth 2.0 Client ID (Web application)
4. Add Authorized Redirect URIs:
   - `http://localhost:8080/swp391/login` (development)
   - `https://yourdomain.com/swp391/login` (production)
5. Save Client ID and Client Secret

**Result**: Two credential strings (Client ID & Secret)

### Phase 2: Application Configuration

**Time Required**: 5 minutes

1. Copy credentials to `src/main/resources/google_key.properties`:
   ```properties
   google.client.id=YOUR_CLIENT_ID
   google.client.secret=YOUR_CLIENT_SECRET
   google.redirect.uri=http://localhost:8080/swp391/login
   ```

2. Ensure employee records exist in database:
   ```sql
   SELECT * FROM Employee WHERE email = 'user@gmail.com' AND email_verified = 1;
   ```

### Phase 3: Build & Deploy

**Time Required**: 5-10 minutes

```powershell
cd D:\SWP391_G1_Summer26\swp391
.\deploy\deploy.ps1
```

### Phase 4: Testing

**Time Required**: 10 minutes

1. Open `http://localhost:8080/swp391/login`
2. Click "Sign in with Google"
3. Follow Google authentication flow
4. Verify successful login and session

---

## Key Features

### 1. OAuth 2.0 Authentication

**Standards Compliance**: Uses standard OAuth 2.0 authorization code flow

**Scopes Requested**:
- `email` - Access user's email
- `profile` - Access basic profile info (name, picture)
- `openid` - OpenID Connect support

**Code Exchange**:
```java
// 1. User provides authorization code
String code = request.getParameter("code");

// 2. Exchange code for access token
String token = GoogleLogin.getToken(code);

// 3. Use token to get user info
GoogleAccount user = GoogleLogin.getUserInfo(token);
```

### 2. Account Validation

**Business Rules Enforced**:

```java
// Employee must exist
if (employee == null) 
    → Error: "Invalid email or password" (MSG09)

// Email must be verified
if (!employee.isEmailVerified())
    → Error: "Email not verified" (MSG11)

// Account must be active
if (!employee.isStatus())
    → Error: "Account blocked or inactive" (MSG12)

// Account must not be locked
if (isLocked(employee))
    → Error: "Account locked for 30 minutes" (MSG13)
```

### 3. Security Features

#### Session Management
- HttpSession created after successful login
- Employee object stored in session
- Password not stored in session

#### Account Locking
- Tracks failed login attempts (max 5)
- Locks account for 30 minutes after threshold
- Automatic unlock after timeout

#### Email Verification
- Users cannot login if email not verified
- Prevents unauthorized access

#### Remember Me
- Optional "Remember me" checkbox
- Email stored in HttpOnly cookie (7-day expiry)
- Auto-filled on next visit

---

## API Reference

### GoogleLogin.java

```java
/**
 * Exchange OAuth authorization code for access token
 * @param code Authorization code from Google
 * @return Access token string
 * @throws IOException If token exchange fails
 */
public static String getToken(String code) throws IOException

/**
 * Fetch user profile information using access token
 * @param accessToken Access token from getToken()
 * @return GoogleAccount with user info
 * @throws IOException If API call fails
 */
public static GoogleAccount getUserInfo(String accessToken) throws IOException
```

### AuthHelper.java

```java
/**
 * Build OAuth consent screen URL
 * @return Full URL to Google OAuth consent screen
 */
public static String buildGoogleAuthUrl()

/**
 * Establish user session after login
 * @param request HttpServletRequest
 * @param employee Employee object
 */
public static void establishSession(HttpServletRequest request, Employee employee)

/**
 * Resolve home page URL based on employee role
 * @param employee Employee object
 * @return Relative URL to dashboard/homepage
 */
public static String resolveHomeUrl(Employee employee)
```

### LoginServlet.java

**URL Routes**:
- `GET /login` - Display login form or handle OAuth callback
- `POST /login` - Handle email/password login
- `GET /login?code=ABC123` - Handle Google OAuth callback

**Request Parameters**:
- `code` - OAuth authorization code (GET)
- `email` - User email (POST)
- `password` - User password (POST)
- `remember` - Remember email checkbox (POST)

---

## Error Handling & Messages

### Error Message Mapping

| Code | Message | Scenario |
|------|---------|----------|
| MSG09 | Invalid email or password | User not found OR password wrong OR Google account not linked |
| MSG10 | Please enter email and password | Empty email or password field |
| MSG11 | Email not verified | Employee exists but email_verified = 0 |
| MSG12 | Account blocked or inactive | Employee status = 0 |
| MSG13 | Account locked (30 minutes) | Too many failed login attempts |
| MSG14 | Session expired | Session timeout, need to relogin |

### Exception Handling

**In GoogleLogin.getToken()**:
```java
if (jobj.has("error") || !jobj.has("access_token")) {
    throw new IOException("Google token error: " + errorDesc);
}
```

**In LoginServlet.doGet() Google flow**:
```java
try {
    GoogleAccount googleAcc = GoogleLogin.getUserInfo(...);
    // Process login
} catch (Exception ex) {
    // Display error, ask user to try again
    request.setAttribute("errorMessage", MessageUtil.get("MSG09"));
    ViewForward.forward(request, response, "login.jsp");
}
```

---

## Database Schema (Authentication-Related)

### Employee Table (Relevant Columns)

```sql
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_code VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255),  -- NULL if using Google OAuth only
    fullname VARCHAR(200),
    status BIT DEFAULT 1,   -- 1 = active, 0 = inactive
    email_verified BIT DEFAULT 0,  -- 1 = verified
    failed_login_count INT DEFAULT 0,
    locked_until TIMESTAMP NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Queries Used

**Get employee for authentication**:
```sql
SELECT e.*, d.dep_name, r.role_name
FROM Employee e
LEFT JOIN Department d ON e.dep_id = d.dep_id
LEFT JOIN Role r ON e.role_id = r.role_id
WHERE e.email = ? AND e.status = 1
```

**Reset failed logins**:
```sql
UPDATE Employee SET failed_login_count = 0, locked_until = NULL 
WHERE emp_code = ?
```

**Record failed login**:
```sql
UPDATE Employee SET failed_login_count = ?, locked_until = ? 
WHERE emp_code = ?
```

---

## Configuration Examples

### Development Environment

```properties
# Local development
google.client.id=123456789-abcdefghijklmnop.apps.googleusercontent.com
google.client.secret=GOCSPX-1234567890abcdefghijk
google.redirect.uri=http://localhost:8080/swp391/login
```

### Production Environment

```properties
# Production
google.client.id=987654321-zyxwvutsrqponmlk.apps.googleusercontent.com
google.client.secret=GOCSPX-zyxwvutsrqponmlk9876543
google.redirect.uri=https://hrm.company.com/swp391/login
```

### Containerized Deployment (Docker)

Use environment variables instead of file:
```dockerfile
ENV GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
ENV GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}
ENV GOOGLE_REDIRECT_URI=https://hrm.company.com/swp391/login
```

---

## Testing Checklist

### Unit Tests

- [ ] `GoogleLogin.getToken()` with valid code
- [ ] `GoogleLogin.getToken()` with invalid code (error handling)
- [ ] `GoogleLogin.getUserInfo()` with valid token
- [ ] `AuthHelper.buildGoogleAuthUrl()` with valid config
- [ ] `AuthHelper.buildGoogleAuthUrl()` with missing config

### Integration Tests

- [ ] Google OAuth callback returns valid user
- [ ] Non-existent user shown error (MSG09)
- [ ] Inactive employee cannot login (MSG12)
- [ ] Unverified email cannot login (MSG11)
- [ ] Locked account cannot login (MSG13)
- [ ] Successful login creates session
- [ ] Session contains employee object

### Manual Tests

- [ ] Login page displays correctly
- [ ] "Sign in with Google" button works
- [ ] Google redirect flow works
- [ ] Session persists across requests
- [ ] Logout clears session
- [ ] Remember me works

### Security Tests

- [ ] Cannot manually set session without login
- [ ] Session token not in URL
- [ ] Credentials not logged
- [ ] CSRF protection enabled (if needed)

---

## Troubleshooting Guide

### "Google login is not configured"

**Cause**: google_key.properties is empty or not found

**Solution**:
1. Check file exists: `src/main/resources/google_key.properties`
2. File has content (not empty)
3. Rebuild: `mvn clean package`

### Redirect URI mismatch error

**Cause**: OAuth redirect URI doesn't match Google Console configuration

**Solution**:
1. Note exact URL in error message
2. Go to Google Cloud Console → Credentials
3. Edit OAuth client
4. Add the exact URL to "Authorized redirect URIs"
5. Click Save

### "User not found" (MSG09)

**Cause**: Employee email doesn't exist in database

**Solution**:
```sql
INSERT INTO Employee (emp_code, email, fullname, status, email_verified)
VALUES ('EMP001', 'user@gmail.com', 'John Doe', 1, 1);
```

### User locked after login attempts

**Cause**: More than 5 failed attempts

**Solution**:
```sql
UPDATE Employee SET failed_login_count = 0, locked_until = NULL 
WHERE email = 'user@gmail.com';
```

### Session not persisting

**Cause**: HttpSession not created or expired

**Solution**:
1. Check browser cookies enabled
2. Check session timeout in `web.xml`:
   ```xml
   <session-config>
       <cookie-config>
           <http-only>true</http-only>
       </cookie-config>
       <tracking-mode>COOKIE</tracking-mode>
   </session-config>
   ```

---

## Performance Considerations

### Network Latency

OAuth flow involves 3 network calls:
1. Browser → Google (user authenticate)
2. Server → Google token endpoint (exchange code)
3. Server → Google userinfo endpoint (get profile)

**Typical time**: 1-2 seconds

### Database Queries

**Per login**:
- 1 query to fetch employee by email
- Up to 2 additional queries for failed login handling

**Optimization**: Use indexes on `email` column

### Caching

**Cached by browser**:
- Google client ID (part of OAuth URL)
- OAuth UI components

**Not cached**:
- User profile (fetched fresh each login)
- Employee data (fetched fresh each login)

---

## Security Best Practices

### Do's ✅

- ✅ Use HTTPS in production
- ✅ Keep Client Secret private (git-ignored)
- ✅ Validate email verification before login
- ✅ Implement account locking
- ✅ Log all authentication attempts
- ✅ Use HttpOnly cookies for session
- ✅ Implement CSRF protection
- ✅ Refresh user data periodically

### Don'ts ❌

- ❌ Commit google_key.properties to Git
- ❌ Display access token in logs
- ❌ Store passwords in plain text
- ❌ Skip email verification check
- ❌ Allow unlimited login attempts
- ❌ Use HTTP in production
- ❌ Log sensitive user data
- ❌ Store credentials in source code

---

## Migration Guide (From Custom Auth to Google)

### For Existing Users

1. **Option A: Parallel Login**
   - Keep email/password login enabled
   - Allow users to add Google account later

2. **Option B: Gradual Migration**
   - Enable Google login for new employees only
   - Migrate existing employees over time

3. **Option C: Forced Migration**
   - Require Google account linkage
   - Provide account recovery process

### Implementation

```java
// Check if user has password
if (employee.getPassword() == null) {
    // Google-only account
    authenticationMethod = "GOOGLE_OAUTH";
} else {
    // Can login with either method
    authenticationMethod = "DUAL";
}
```

---

## Support & Maintenance

### Regular Maintenance

- [ ] Monitor failed login attempts weekly
- [ ] Check Google API quota usage monthly
- [ ] Review session logs quarterly
- [ ] Update Google OAuth scopes as needed
- [ ] Rotate credentials annually

### Monitoring

**Metrics to track**:
- Total logins per day
- Google OAuth usage %
- Failed login attempts
- Session timeout rate
- Error rates by message code

### Resources

- [Google OAuth 2.0 Docs](https://developers.google.com/identity/protocols/oauth2)
- [Google Sign-In Web Documentation](https://developers.google.com/identity/sign-in/web)
- [Jakarta Servlet API](https://jakarta.ee/specifications/servlet/)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
