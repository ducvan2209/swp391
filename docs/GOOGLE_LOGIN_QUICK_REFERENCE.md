# Google Login - Quick Reference Guide

## For Developers

### Files to Know

```
📁 Core Implementation
├── api/GoogleLogin.java                          (OAuth token exchange)
├── controller/LoginServlet.java                  (Login handler)
├── helper/AuthHelper.java                        (Session & OAuth URL)
├── helper/KeyLoader.java                         (Config loader)
├── model/GoogleAccount.java                      (Google user data)
└── dal/EmployeeDAO.java                          (DB queries)

📁 Configuration
├── src/main/resources/google_key.properties      (🔐 KEEP SECRET)
├── src/main/resources/messages.properties        (Error messages)
└── src/main/resources/app.properties             (App config)

📁 UI
└── webapp/WEB-INF/views/login.jsp               (Login form)

📁 Documentation
├── docs/AUTH_SETUP.md                           (Basic setup)
├── docs/GOOGLE_LOGIN_SETUP.md                   (Detailed setup)
└── docs/GOOGLE_LOGIN_IMPLEMENTATION.md          (Architecture)
```

### Setup Checklist (5 Minutes)

- [ ] Create OAuth 2.0 app in Google Cloud Console
- [ ] Get Client ID and Client Secret
- [ ] Add redirect URI: `http://localhost:8080/swp391/login`
- [ ] Update `src/main/resources/google_key.properties`:
  ```properties
  google.client.id=YOUR_ID_HERE
  google.client.secret=YOUR_SECRET_HERE
  google.redirect.uri=http://localhost:8080/swp391/login
  ```
- [ ] Rebuild: `mvn clean package`
- [ ] Deploy: `.\deploy\deploy.ps1`
- [ ] Test: Click "Sign in with Google" on login page

### Database Setup

```sql
-- Test employee for Google login
INSERT INTO Employee (emp_code, email, fullname, status, email_verified) 
VALUES ('EMP001', 'your-google-email@gmail.com', 'Your Name', 1, 1);
```

### Login URLs

| Action | URL |
|--------|-----|
| Display login form | `GET /login` |
| Traditional login | `POST /login` (email + password) |
| Google login start | Click button on login page |
| Google login callback | `GET /login?code=ABC123` (auto handled) |

### Login Flow (Simple)

```
User clicks "Sign in with Google"
    ↓
Google authentication screen
    ↓
User approves permission
    ↓
Google redirects to /login?code=XXX
    ↓
Server exchanges code for token
    ↓
Server gets user email from Google
    ↓
Server checks if employee exists
    ↓
User logged in!
```

### Error Messages

| Error | Cause | Fix |
|-------|-------|-----|
| "Google login not configured" | Missing credentials in google_key.properties | Fill in Client ID and Secret |
| "Invalid email or password" | Employee not found in DB | Add employee with matching Google email |
| "Email not verified" | Employee exists but email_verified ≠ 1 | Run: `UPDATE Employee SET email_verified = 1 WHERE emp_code = 'EMP001'` |
| "Account blocked or inactive" | Employee status ≠ 1 | Run: `UPDATE Employee SET status = 1 WHERE emp_code = 'EMP001'` |
| Redirect URI mismatch | Config doesn't match Google Console | Check exact URL in error, update both places to match |

### Code Examples

#### Check if Google is configured
```java
String googleUrl = AuthHelper.buildGoogleAuthUrl();
if (googleUrl == null) {
    System.out.println("Google not configured!");
}
```

#### Exchange code for access token
```java
try {
    String code = request.getParameter("code");
    String token = GoogleLogin.getToken(code);
    System.out.println("Access token: " + token);
} catch (IOException e) {
    System.out.println("Token exchange failed: " + e.getMessage());
}
```

#### Get user info from Google
```java
GoogleAccount user = GoogleLogin.getUserInfo(accessToken);
System.out.println("Email: " + user.getEmail());
System.out.println("Name: " + user.getName());
System.out.println("Picture: " + user.getPicture());
```

---

## For System Administrators

### Pre-Deployment Checklist

- [ ] Google Cloud Project created
- [ ] OAuth 2.0 Client ID created
- [ ] Credentials saved securely
- [ ] Employee database initialized
- [ ] Target employee emails added with `email_verified = 1`
- [ ] `google_key.properties` configured
- [ ] `.gitignore` includes `google_key.properties`

### Production Deployment

1. **Create Production Google App**
   - New OAuth client in Google Console
   - Add production domain to authorized redirect URIs

2. **Update Configuration**
   ```properties
   google.redirect.uri=https://hrm.company.com/swp391/login
   ```

3. **Use HTTPS**
   - Update all redirect URIs to use `https://`
   - Configure Tomcat SSL certificate

4. **Test**
   - Test with production domain
   - Verify redirect URI matches exactly

### Monitoring

**Check login activity:**
```sql
SELECT * FROM ActivityLog 
WHERE action = 'LOGIN' 
ORDER BY created_date DESC 
LIMIT 10;
```

**Monitor failed logins:**
```sql
SELECT emp_code, email, failed_login_count, locked_until 
FROM Employee 
WHERE failed_login_count > 0 
OR locked_until > NOW();
```

**Reset locked accounts:**
```sql
UPDATE Employee 
SET failed_login_count = 0, locked_until = NULL 
WHERE email = 'user@gmail.com';
```

### Troubleshooting

**Issue: "Redirect URI mismatch"**
- Solution: Check exact URL in error message
- Match it in Google Console under "Authorized redirect URIs"

**Issue: "Invalid Client ID"**
- Solution: Verify Client ID in google_key.properties is correct
- Copy-paste from Google Console to avoid typos

**Issue: Users can't login**
- Solution: Verify employee email exists in database
- Check `email_verified = 1`

---

## For End Users

### How to Login with Google

1. Go to login page
2. Click **"Sign in with Google"** button
3. A Google login window will appear
4. Enter your Google email and password
5. Allow permissions when prompted
6. You'll be logged into HRM System automatically

### Troubleshooting (User Perspective)

**"Google login not working"**
- Try refreshing the page
- Clear browser cookies
- Try a different browser

**"Invalid email or password"**
- Your Google account is not linked to your company account
- Contact HR administrator

**"Account blocked"**
- Too many failed login attempts
- Wait 30 minutes and try again
- Contact HR administrator if you need immediate access

**"Email not verified"**
- Contact HR administrator to verify your email

---

## Security Notes

### What Data Does Google Provide?

✅ Email address
✅ Profile name
✅ Profile picture
✅ Unique Google ID

❌ Password (never shared)
❌ Phone number (unless user shares)
❌ Private data (Gmail content, Drive files, etc.)

### How Is Data Protected?

- ✅ OAuth 2.0 standard protocol
- ✅ No passwords stored
- ✅ Session uses secure cookies
- ✅ HTTPS required in production
- ✅ Access tokens expire quickly
- ✅ Account locking after failed attempts

### Best Practices

- Always use HTTPS in production
- Never commit credentials to Git
- Regularly rotate Client Secret
- Monitor login attempts
- Keep employee database up-to-date
- Verify email addresses
- Educate users about security

---

## Common Tasks

### Add a New Employee for Google Login

```sql
INSERT INTO Employee (emp_code, email, fullname, status, email_verified, dep_id, role_id)
VALUES ('EMP002', 'john.doe@gmail.com', 'John Doe', 1, 1, 1, 2);
```

### Reset Failed Login Attempts

```sql
UPDATE Employee SET failed_login_count = 0, locked_until = NULL WHERE emp_code = 'EMP001';
```

### Disable Google Login (Emergency)

```java
// In KeyLoader.java - comment out or return null
public static String get(String key) {
    if ("google.client.id".equals(key)) {
        return null;  // Disable Google login
    }
    return props.getProperty(key);
}
```

### Change Redirect URI (Different Environment)

```properties
# Development
google.redirect.uri=http://localhost:8080/swp391/login

# Staging
google.redirect.uri=http://staging.company.com/swp391/login

# Production
google.redirect.uri=https://hrm.company.com/swp391/login
```

---

## Further Reading

- [Complete Implementation Guide](GOOGLE_LOGIN_IMPLEMENTATION.md)
- [Detailed Setup Instructions](GOOGLE_LOGIN_SETUP.md)
- [Basic Auth Setup](AUTH_SETUP.md)
- [Google OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)

---

**Last Updated**: 2026-06-01  
**Version**: 1.0  
**Status**: Production Ready
