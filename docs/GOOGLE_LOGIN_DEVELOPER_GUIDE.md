# Google Login - Developer Guide with Code Examples

## Quick Code Examples

### 1. Check if Google Login is Configured

```java
// Check if Google credentials are loaded
String googleAuthUrl = AuthHelper.buildGoogleAuthUrl();

if (googleAuthUrl == null) {
    System.out.println("❌ Google login is NOT configured!");
    System.out.println("   - Check src/main/resources/google_key.properties");
    System.out.println("   - Ensure google.client.id and google.client.secret are set");
} else {
    System.out.println("✅ Google login is configured!");
    System.out.println("   - URL: " + googleAuthUrl);
}
```

### 2. Exchange Google Authorization Code for Token

```java
try {
    // Get authorization code from Google callback
    String code = request.getParameter("code");
    
    if (code == null) {
        System.out.println("❌ No authorization code received from Google");
        return;
    }
    
    System.out.println("📝 Authorization code: " + code);
    
    // Exchange code for access token
    String accessToken = GoogleLogin.getToken(code);
    System.out.println("✅ Access token obtained");
    System.out.println("   - Token: " + accessToken.substring(0, 20) + "...");
    
} catch (IOException e) {
    System.out.println("❌ Failed to exchange code for token");
    System.out.println("   - Error: " + e.getMessage());
    // This usually means:
    // - Invalid authorization code
    // - Client ID/Secret mismatch
    // - Redirect URI mismatch
}
```

### 3. Get User Info from Google

```java
try {
    String accessToken = GoogleLogin.getToken(code);
    
    // Fetch user profile from Google
    GoogleAccount googleUser = GoogleLogin.getUserInfo(accessToken);
    
    System.out.println("✅ User info retrieved from Google:");
    System.out.println("   - ID: " + googleUser.getId());
    System.out.println("   - Email: " + googleUser.getEmail());
    System.out.println("   - Name: " + googleUser.getName());
    System.out.println("   - Picture: " + googleUser.getPicture());
    System.out.println("   - Email verified: " + googleUser.isVerified_email());
    
} catch (IOException e) {
    System.out.println("❌ Failed to get user info from Google");
    System.out.println("   - Error: " + e.getMessage());
    // This usually means:
    // - Access token expired or invalid
    // - Network connectivity issue
}
```

### 4. Find Employee by Google Email

```java
String googleEmail = "user@gmail.com";
EmployeeDAO employeeDAO = new EmployeeDAO();
Employee employee = employeeDAO.getEmployeeByEmailForAuth(googleEmail);

if (employee == null) {
    System.out.println("❌ Employee not found: " + googleEmail);
    System.out.println("   - Add employee to database with this email");
    
    // SQL to add employee:
    // INSERT INTO Employee (email, fullname, status, email_verified)
    // VALUES ('user@gmail.com', 'User Name', 1, 1);
    
} else {
    System.out.println("✅ Employee found:");
    System.out.println("   - ID: " + employee.getEmpId());
    System.out.println("   - Code: " + employee.getEmpCode());
    System.out.println("   - Name: " + employee.getFullname());
    System.out.println("   - Email: " + employee.getEmail());
    System.out.println("   - Status: " + employee.isStatus());
    System.out.println("   - Email verified: " + employee.isEmailVerified());
    System.out.println("   - Failed logins: " + employee.getFailedLoginCount());
    System.out.println("   - Locked until: " + employee.getLockedUntil());
}
```

### 5. Validate Employee Account State

```java
Employee employee = employeeDAO.getEmployeeByEmailForAuth("user@gmail.com");

// Validate account before allowing login
if (!employee.isStatus()) {
    System.out.println("❌ Account is inactive");
    // User cannot login - account disabled by admin
    
} else if (!employee.isEmailVerified()) {
    System.out.println("❌ Email not verified");
    // User cannot login - email verification required
    
} else if (employee.getLockedUntil() != null && 
           employee.getLockedUntil().after(new Timestamp(System.currentTimeMillis()))) {
    System.out.println("❌ Account is locked until: " + employee.getLockedUntil());
    // User cannot login - too many failed attempts
    
} else {
    System.out.println("✅ Account is valid - can login");
}
```

### 6. Create User Session After Login

```java
Employee employee = employeeDAO.getEmployeeByEmailForAuth("user@gmail.com");

// Clear password from session (security)
employee.setPassword(null);

// Create session
AuthHelper.establishSession(request, employee);

// Verify session was created
Employee sessionUser = (Employee) request.getSession().getAttribute("user");
System.out.println("✅ Session created:");
System.out.println("   - User: " + sessionUser.getFullname());
System.out.println("   - Email: " + sessionUser.getEmail());
System.out.println("   - Session ID: " + request.getSession().getId());
```

### 7. Log Authentication Activity

```java
Employee employee = employeeDAO.getEmployeeByEmailForAuth("user@gmail.com");

// Log login activity
String details = "Successfully logged in via Google OAuth";
AuthHelper.logActivity(request, employee.getEmpId(), "LOGIN", details);

System.out.println("✅ Activity logged:");
System.out.println("   - Action: LOGIN");
System.out.println("   - Details: " + details);
System.out.println("   - IP: " + request.getRemoteAddr());
```

---

## Debugging Guide

### Scenario 1: "Google login not configured" error

**What it means**: Google credentials are not properly loaded

**Debug steps**:

```java
// Check if properties file is loaded
String clientId = KeyLoader.get("google.client.id");
String clientSecret = KeyLoader.get("google.client.secret");

System.out.println("Client ID: " + clientId);
System.out.println("Client Secret: " + (clientSecret == null ? "NULL" : clientSecret.substring(0, 10) + "..."));

if (clientId == null || clientSecret == null) {
    System.out.println("❌ Properties not loaded!");
    System.out.println("   - Check file: src/main/resources/google_key.properties");
    System.out.println("   - Ensure properties are not empty");
    System.out.println("   - Rebuild: mvn clean package");
} else {
    System.out.println("✅ Properties loaded successfully");
}
```

### Scenario 2: "Redirect URI mismatch" error from Google

**What it means**: The redirect URI in your code doesn't match Google Console configuration

**Debug steps**:

```java
String redirectUri = KeyLoader.get("google.redirect.uri");
System.out.println("Configured redirect URI: " + redirectUri);

// This must EXACTLY match the "Authorized redirect URIs" in Google Cloud Console
// Examples:
// - http://localhost:8080/swp391/login
// - https://hrm.company.com/swp391/login
// - NOT: http://localhost:8080/swp391 (missing /login)
// - NOT: https://hrm.company.com (missing /swp391/login)

System.out.println("Make sure this matches Google Cloud Console configuration");
```

### Scenario 3: User not found after Google login

**What it means**: Employee doesn't exist in database with that email

**Debug steps**:

```java
String googleEmail = googleAccount.getEmail();
System.out.println("Google email: " + googleEmail);

EmployeeDAO dao = new EmployeeDAO();
Employee emp = dao.getEmployeeByEmailForAuth(googleEmail);

if (emp == null) {
    System.out.println("❌ Employee not found!");
    System.out.println("   - Add to database:");
    System.out.println("   INSERT INTO Employee (email, fullname, status, email_verified)");
    System.out.println("   VALUES ('" + googleEmail + "', 'Name', 1, 1)");
} else {
    System.out.println("✅ Employee found: " + emp.getFullname());
}
```

### Scenario 4: User locked after failed attempts

**What it means**: User tried to login 5+ times unsuccessfully

**Debug steps**:

```java
Employee emp = dao.getEmployeeByEmailForAuth(email);

System.out.println("Failed login count: " + emp.getFailedLoginCount());
System.out.println("Locked until: " + emp.getLockedUntil());

if (emp.getLockedUntil() != null) {
    Timestamp now = new Timestamp(System.currentTimeMillis());
    if (emp.getLockedUntil().after(now)) {
        System.out.println("❌ Account is locked for: " + 
            (emp.getLockedUntil().getTime() - now.getTime()) / 1000 + " seconds");
        System.out.println("   - To unlock immediately:");
        System.out.println("   UPDATE Employee SET failed_login_count = 0, locked_until = NULL");
        System.out.println("   WHERE emp_code = '" + emp.getEmpCode() + "'");
    } else {
        System.out.println("✅ Lock period expired - account can login");
    }
}
```

---

## Testing Examples

### Unit Test: OAuth Token Exchange

```java
@Test
public void testTokenExchange() throws Exception {
    String authCode = "4/0AX4XfWi..."; // From Google callback
    
    try {
        String token = GoogleLogin.getToken(authCode);
        assertNotNull("Token should not be null", token);
        assertTrue("Token should be long string", token.length() > 50);
        System.out.println("✅ Token exchange successful");
    } catch (IOException e) {
        fail("Token exchange failed: " + e.getMessage());
    }
}
```

### Integration Test: Full Login Flow

```java
@Test
public void testGoogleLoginFlow() throws Exception {
    // Step 1: Get authorization code (usually from browser)
    String authCode = getAuthCodeFromGoogle();
    
    // Step 2: Exchange for token
    String token = GoogleLogin.getToken(authCode);
    assertNotNull(token);
    
    // Step 3: Get user info
    GoogleAccount googleUser = GoogleLogin.getUserInfo(token);
    assertNotNull(googleUser);
    assertEquals("user@gmail.com", googleUser.getEmail());
    
    // Step 4: Find employee
    EmployeeDAO dao = new EmployeeDAO();
    Employee employee = dao.getEmployeeByEmailForAuth(googleUser.getEmail());
    assertNotNull("Employee should exist", employee);
    
    // Step 5: Create session
    AuthHelper.establishSession(mockRequest, employee);
    
    // Step 6: Verify session
    Employee sessionUser = (Employee) mockRequest.getSession()
        .getAttribute("user");
    assertNotNull(sessionUser);
    assertEquals("user@gmail.com", sessionUser.getEmail());
    
    System.out.println("✅ Full login flow test passed");
}
```

---

## Configuration Variations

### Development (Local)

```properties
google.client.id=LOCAL_DEV_CLIENT_ID
google.client.secret=LOCAL_DEV_CLIENT_SECRET
google.redirect.uri=http://localhost:8080/swp391/login
```

### Staging

```properties
google.client.id=STAGING_CLIENT_ID
google.client.secret=STAGING_CLIENT_SECRET
google.redirect.uri=http://staging.company.local:8080/swp391/login
```

### Production

```properties
google.client.id=PROD_CLIENT_ID
google.client.secret=PROD_CLIENT_SECRET
google.redirect.uri=https://hrm.company.com/swp391/login
```

---

## Common Extensions

### Add Email Domain Restriction

```java
// Allow only company domain
String googleEmail = googleAccount.getEmail();

if (!googleEmail.endsWith("@company.com")) {
    throw new Exception("Only company email addresses can login");
}
```

### Add User Profile Picture

```java
GoogleAccount googleUser = GoogleLogin.getUserInfo(token);
String pictureUrl = googleUser.getPicture();

// Download and save picture
BufferedImage image = ImageIO.read(new URL(pictureUrl));
ImageIO.write(image, "jpg", new File("pictures/" + googleUser.getId() + ".jpg"));

// Store in database
employee.setImage("/pictures/" + googleUser.getId() + ".jpg");
```

### Add OAuth Scope Control

```java
// Request specific scopes
String scope = "email profile openid https://www.googleapis.com/auth/calendar";

// Build custom OAuth URL with additional scopes
String customUrl = "https://accounts.google.com/o/oauth2/auth"
    + "?scope=" + URLEncoder.encode(scope, "UTF-8")
    + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
    + "&response_type=code"
    + "&client_id=" + clientId;
```

### Add Automatic Employee Creation

```java
GoogleAccount googleUser = GoogleLogin.getUserInfo(token);

// Check if employee exists
Employee employee = employeeDAO.getEmployeeByEmailForAuth(googleUser.getEmail());

if (employee == null && isAutomaticCreationEnabled()) {
    // Create employee from Google account
    employee = new Employee();
    employee.setEmail(googleUser.getEmail());
    employee.setFullname(googleUser.getName());
    employee.setImage(googleUser.getPicture());
    employee.setStatus(true);
    employee.setEmailVerified(true);
    
    employeeDAO.insert(employee);
    System.out.println("✅ New employee created from Google account");
}
```

---

## Performance Optimization

### Cache OAuth URL

```java
private static String cachedOAuthUrl = null;

public static String buildGoogleAuthUrl() {
    if (cachedOAuthUrl != null) {
        return cachedOAuthUrl;
    }
    
    // Build URL...
    cachedOAuthUrl = /* build URL */;
    return cachedOAuthUrl;
}
```

### Rate Limit Login Attempts

```java
private static Map<String, Integer> loginAttempts = new HashMap<>();
private static final int MAX_ATTEMPTS = 5;
private static final long RATE_LIMIT_WINDOW = 15 * 60 * 1000; // 15 minutes

public static boolean isRateLimited(String email) {
    String key = email + ":" + System.currentTimeMillis() / RATE_LIMIT_WINDOW;
    int attempts = loginAttempts.getOrDefault(key, 0);
    return attempts >= MAX_ATTEMPTS;
}
```

---

## Security Best Practices in Code

### Never Log Secrets

```java
// ❌ BAD
System.out.println("Token: " + accessToken);

// ✅ GOOD
System.out.println("Token length: " + accessToken.length() + " chars");
```

### Clear Sensitive Data

```java
// ✅ Remove password from session
employee.setPassword(null);

// ✅ Clear sensitive request parameters
String password = request.getParameter("password");
// Don't log password
password = null; // Clear from memory
```

### Validate All Input

```java
// ✅ Validate email
String email = googleAccount.getEmail();
if (email == null || !email.contains("@")) {
    throw new Exception("Invalid email from Google");
}

// ✅ Validate access token
String token = GoogleLogin.getToken(code);
if (token == null || token.isEmpty()) {
    throw new Exception("Invalid token from Google");
}
```

---

## Useful SQL Queries for Debugging

```sql
-- Check all employees
SELECT emp_id, emp_code, email, status, email_verified, 
       failed_login_count, locked_until 
FROM Employee;

-- Find employee
SELECT * FROM Employee WHERE email = 'user@gmail.com';

-- Check login activity
SELECT emp_id, action, details, created_date 
FROM ActivityLog 
WHERE action = 'LOGIN' 
ORDER BY created_date DESC LIMIT 20;

-- Check failed logins
SELECT emp_code, email, failed_login_count, locked_until 
FROM Employee 
WHERE failed_login_count > 0 
OR locked_until > NOW();

-- Reset locked account
UPDATE Employee 
SET failed_login_count = 0, locked_until = NULL 
WHERE emp_code = 'EMP001';

-- Verify email
UPDATE Employee 
SET email_verified = 1 
WHERE email = 'user@gmail.com';
```

---

**Last Updated**: June 1, 2026  
**Version**: 1.0  
**For**: Developers implementing or extending Google Login
