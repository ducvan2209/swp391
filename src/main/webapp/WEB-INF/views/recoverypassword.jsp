<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>HRM - Reset Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets1/css/assets.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets1/css/style.css">
    <style>
        .auth-alert { padding: 10px 14px; border-radius: 6px; margin-bottom: 12px; }
        .auth-alert-error { background: #ffe6e6; color: #b30000; }
    </style>
</head>
<body id="bg">
<div class="page-wraper">
    <div class="account-form">
        <div class="account-form-inner">
            <div class="account-container">
                <div class="heading-bx left">
                    <h2 class="title-head">Reset <span>Password</span></h2>
                    <p><a href="${pageContext.request.contextPath}/login">Back to login</a></p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="auth-alert auth-alert-error">${errorMessage}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/recovery" method="post">
                    <input type="hidden" name="token" value="${resetToken}">
                    <div class="form-group">
                        <label>New password</label>
                        <input name="newPassword" type="password" required class="form-control">
                    </div>
                    <div class="form-group">
                        <label>Confirm password</label>
                        <input name="confirmPassword" type="password" required class="form-control">
                    </div>
                    <button type="submit" class="btn button-md">Reset password</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
