# Google OAuth Login Setup Guide

## Architecture Overview

The Google Login feature integrates **OAuth 2.0** authentication with your HRM system. Users can authenticate using their Google account instead of traditional email/password.

### Components:

1. **GoogleLogin.java** - OAuth token exchange
2. **AuthHelper.java** - OAuth URL builder & session management
3. **LoginServlet.java** - Login page + OAuth callback handler
4. **login.jsp** - UI with "Sign in with Google" button
5. **Configuration** - google_key.properties

---

## Step 1: Set Up Google Cloud Project

### 1.1 Create a Project in Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click the project dropdown and select **NEW PROJECT**
3. Name it: `SWP391-HRM`
4. Click **CREATE**

### 1.2 Enable Google+ API

1. In the Google Cloud Console, go to **APIs & Services** → **Enabled APIs & services**
2. Click **+ ENABLE APIS AND SERVICES**
3. Search for **Google+ API**
4. Click it and select **ENABLE**

---

## Step 2: Create OAuth 2.0 Credentials

### 2.1 Create OAuth 2.0 Client ID

1. Go to **APIs & Services** → **Credentials**
2. Click **+ CREATE CREDENTIALS** → **OAuth client ID**
3. If prompted, configure the OAuth consent screen first:
   - **User Type**: External
   - **App name**: SWP391 HRM System
   - **User support email**: admin@hrm.local
   - **Scopes**: 
     - Add `https://www.googleapis.com/auth/userinfo.email`
     - Add `https://www.googleapis.com/auth/userinfo.profile`
   - **Authorized domains**: Add your domain (e.g., localhost)

### 2.2 Configure OAuth Client

In the OAuth client ID creation dialog:

- **Application type**: Web application
- **Name**: SWP391 HRM Web App
- **Authorized redirect URIs**: Add these:
  - `http://localhost:8080/swp391/login` (development)
  - `http://yourdomain.com/swp391/login` (production)
  - `http://your-server-ip:8080/swp391/login` (if using IP)

Click **CREATE**

### 2.3 Save Your Credentials

You'll see your credentials with:
- **Client ID** (something like: `123456789-abcdefghijk.apps.googleusercontent.com`)
- **Client Secret** (a long string - keep this private!)

---

## Step 3: Configure Application

### 3.1 Update google_key.properties

1. Open `src/main/resources/google_key.properties`
2. Fill in your credentials:

```properties
google.client.id=YOUR_CLIENT_ID_HERE
google.client.secret=YOUR_CLIENT_SECRET_HERE
google.redirect.uri=http://localhost:8080/swp391/login
google.grant.type=authorization_code
google.token.link=https://oauth2.googleapis.com/token
google.userinfo.link=https://www.googleapis.com/oauth2/v1/userinfo?access_token=
```

Replace:
- `YOUR_CLIENT_ID_HERE` → Your Google Client ID
- `YOUR_CLIENT_SECRET_HERE` → Your Google Client Secret
- `redirect.uri` → Must exactly match the authorized redirect URI in Google Console

### 3.2 Ensure Database Employee Records Exist

The Google login requires the user's email to exist in your `employee` table:

```sql
-- Example: Add a test user
INSERT INTO employee (emp_code, email, first_name, last_name, status, email_verified, failed_login_count) 
VALUES ('EMP001', 'user@gmail.com', 'John', 'Doe', 1, 1, 0);
```

**Important**: The `email_verified` flag must be `1` (true) for the user to login.

---

## Step 4: Test Google Login

### 4.1 Rebuild & Deploy

```powershell
cd D:\SWP391_G1_Summer26\swp391
# Run the deploy script
.\deploy\deploy.ps1
```

### 4.2 Test Login Flow

1. Open `http://localhost:8080/swp391/login`
2. Click **"Sign in with Google"** button
3. You'll be redirected to Google login
4. After Google authentication, you'll be redirected back to `/login` with a code
5. The system will:
   - Exchange the code for an access token
   - Fetch user info from Google
   - Find matching employee record
   - Create session and redirect to dashboard

### 4.3 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Google login is not configured" | Check google_key.properties is filled and readable |
| Redirect URI mismatch error | Verify redirect URI matches exactly in both Google Console and config |
| User not found (MSG09) | Ensure employee email exists in database with email_verified=1 |
| Account locked (MSG13) | Check failed_login_count and locked_until fields |
| Account inactive (MSG12) | Ensure employee status=1 |

---

## Step 5: Security Best Practices

### 5.1 Protect Secrets

❌ **DO NOT** commit `google_key.properties` with real credentials to Git

✅ **DO** use `.gitignore`:
```gitignore
src/main/resources/google_key.properties
src/main/resources/app.properties
```

### 5.2 HTTPS in Production

- Always use `https://` in production redirect URIs
- Update google_key.properties for production endpoints

### 5.3 Token Security

- Access tokens are short-lived (handled by Google)
- Session tokens are stored in HttpSession (secure)
- Implement CSRF protection if needed

---

## Step 6: Production Deployment

### 6.1 Update Configuration for Production

```properties
google.redirect.uri=https://your-domain.com/swp391/login
```

### 6.2 Add Production URI to Google Console

1. Go to Google Cloud Console → Credentials
2. Edit OAuth client
3. Add production redirect URI
4. Save

### 6.3 Environment-Specific Configuration

Option: Use separate properties files:
- `google_key.properties` - development (localhost)
- `google_key_prod.properties` - production

Or use environment variables via Docker/Kubernetes.

---

## API Reference

### GoogleLogin.java

```java
// Get access token from authorization code
String token = GoogleLogin.getToken(code);

// Get user info using access token
GoogleAccount user = GoogleLogin.getUserInfo(token);
```

### GoogleAccount Model

```java
public class GoogleAccount {
    String id;              // Google user ID
    String email;           // User email
    boolean verified_email; // Email verified flag
    String name;            // Full name
    String given_name;      // First name
    String family_name;     // Last name
    String picture;         // Profile picture URL
    String locale;          // User's locale
}
```

### LoginServlet Flow

**GET `/login` with code parameter:**
1. Gets authorization code from query string
2. Calls `GoogleLogin.getToken(code)`
3. Calls `GoogleLogin.getUserInfo(token)`
4. Looks up employee by email
5. Validates account status
6. Creates session
7. Logs activity
8. Redirects to dashboard

---

## Related Files

- `src/main/java/api/GoogleLogin.java` - OAuth implementation
- `src/main/java/controller/LoginServlet.java` - Login logic
- `src/main/java/helper/AuthHelper.java` - Session management
- `src/main/java/model/GoogleAccount.java` - Data model
- `src/main/webapp/WEB-INF/views/login.jsp` - Login UI
- `src/main/resources/messages.properties` - Error messages

---

## Support

For issues or questions about Google OAuth integration, refer to:
- [Google OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)
- [Google Sign-In for Web](https://developers.google.com/identity/sign-in/web)
- Project's Google+ API documentation
