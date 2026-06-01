# Authentication module setup (SWP391)

## Database

1. New database: run `sql/schema_task1.sql` and replace `PASSWORD_HASH` with a BCrypt hash from `helper.PasswordEncryption`.
2. Existing database from group project: run `sql/auth_migration.sql` only.

## Configuration files (copy locally, do not commit secrets)

1. `src/main/resources/google_key.properties` — copy from `google_key.properties.example`
2. `src/main/resources/app.properties` — copy from `app.properties.example` (SMTP + base URL)

## Endpoints

| Feature | URL |
|---------|-----|
| Login | `/login` |
| Logout | `/logout` |
| Change password | `/changepassword` (requires session) |
| Forgot password | `/forgetpassword` |
| Reset password | `/recovery?token=...` |

## Google OAuth

See [GOOGLE_LOGIN_SETUP.md](GOOGLE_LOGIN_SETUP.md) for detailed setup instructions.

**Quick Summary:**
1. Create OAuth 2.0 credentials in [Google Cloud Console](https://console.cloud.google.com/)
2. Add your redirect URI to "Authorized redirect URIs"
3. Copy Client ID and Secret to `src/main/resources/google_key.properties`
4. Ensure employees exist in database with `email_verified = 1`
5. Test login with "Sign in with Google" button on login page

**Key Points:**
- Redirect URI must exactly match configuration: `google.redirect.uri` (default: `http://localhost:8080/swp391/login`)
- Employees must have Google account linked to their company email in database
- Email must be verified before login is allowed

## Message codes

See `src/main/resources/messages.properties` (MSG09–MSG24).
