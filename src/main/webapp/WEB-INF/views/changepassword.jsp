<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>HRM - Change Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets1/css/assets.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets1/css/style.css">
    <style>
        .auth-alert { padding: 10px 14px; border-radius: 6px; margin-bottom: 12px; }
        .auth-alert-error { background: #ffe6e6; color: #b30000; }
        .auth-alert-success { background: #e8f8ee; color: #0b6b2f; }
    </style>
</head>
<body id="bg">
<div class="page-wraper">
    <div class="account-form">
        <div class="account-form-inner">
            <div class="account-container">
                <div class="heading-bx left">
                    <h2 class="title-head">Change <span>Password</span></h2>
                    <p><a href="${pageContext.request.contextPath}/dashboard">Back to home</a></p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="auth-alert auth-alert-error">${errorMessage}</div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="auth-alert auth-alert-success">${successMessage}</div>
                </c:if>
                <c:if test="${not empty passwordGuideline}">
                    <p class="text-muted small">${passwordGuideline}</p>
                </c:if>

                <form class="contact-bx" action="${pageContext.request.contextPath}/changepassword" method="post">
                    <div class="form-group">
                        <label>Current password</label>
                        <input type="password" name="currentPassword" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>New password</label>
                        <input type="password" name="newPassword" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Confirm new password</label>
                        <input type="password" name="confirmPassword" class="form-control" required>
                    </div>
                    <button type="submit" class="btn button-md">Save changes</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
