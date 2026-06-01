<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>HRM System - Forgot Password</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets1/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets1/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets1/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets1/css/style.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets1/css/color/color-1.css">
    <style>
        .auth-alert { padding: 10px 14px; border-radius: 6px; margin-bottom: 12px; text-align: center; }
        .auth-alert-error { background: #ffe6e6; color: #b30000; }
        .auth-alert-success { background: #e8f8ee; color: #0b6b2f; }
    </style>
</head>
<body id="bg">
<div class="page-wraper">
    <div class="account-form">
        <div class="account-head" style="background-image:url(${pageContext.request.contextPath}/assets1/images/background/bg2.jpg);">
            <a href="${pageContext.request.contextPath}/login">
                <img src="${pageContext.request.contextPath}/assets1/images/logo-white.png" alt="HRM">
            </a>
        </div>
        <div class="account-form-inner">
            <div class="account-container">
                <div class="heading-bx left">
                    <h2 class="title-head">Forgot <span>Password</span></h2>
                    <p>Enter your registered email. We will send a reset link valid for 24 hours.</p>
                    <p><a href="${pageContext.request.contextPath}/login">Back to login</a></p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="auth-alert auth-alert-error">${errorMessage}</div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="auth-alert auth-alert-success">${successMessage}</div>
                </c:if>

                <form class="contact-bx" action="${pageContext.request.contextPath}/forgetpassword" method="post">
                    <div class="form-group">
                        <label>Your Email Address</label>
                        <input name="email" type="email" required class="form-control" placeholder="name@company.com">
                    </div>
                    <div class="col-lg-12 m-b30 text-center">
                        <button type="submit" class="btn button-md">Send reset link</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets1/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets1/vendors/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
