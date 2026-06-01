
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>HRM System - Login</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets1/css/assets.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets1/css/typography.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets1/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets1/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets1/css/color/color-1.css">
        <style>
            .auth-alert { padding: 10px 14px; border-radius: 6px; margin-bottom: 12px; }
            .auth-alert-error { background: #ffe6e6; color: #b30000; }
            .auth-alert-success { background: #e8f8ee; color: #0b6b2f; }
        </style>
    </head>
    <body id="bg">
        <div class="page-wraper">
            <div class="account-form">
                <div class="account-head" style="background-image:url(${pageContext.request.contextPath}/assets1/images/background/bg2.jpg);">
                    <a href="${pageContext.request.contextPath}/login">
                        <img src="${pageContext.request.contextPath}/assets1/images/logo-white.png" width="400" height="100" alt="HRM">
                    </a>
                </div>
                <div class="account-form-inner">
                    <div class="account-container">
                        <div class="heading-bx left">
                            <h2 class="title-head">Login to your <span>Account</span></h2>
                            <p>Human Resource Management System</p>
                        </div>

                        <c:if test="${not empty errorMessage}">
                            <div class="auth-alert auth-alert-error">${errorMessage}</div>
                        </c:if>
                        <c:if test="${not empty successMessage}">
                            <div class="auth-alert auth-alert-success">${successMessage}</div>
                        </c:if>

                        <form class="contact-bx" action="${pageContext.request.contextPath}/login" method="post">
                            <div class="row placeani">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Email</label>
                                        <input name="email" type="email" required class="form-control"
                                               placeholder="name@company.com"
                                               value="${rememberEmail}">
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Password</label>
                                        <input name="password" type="password" class="form-control" required="">
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group form-forget">
                                        <div class="custom-control custom-checkbox">
                                            <input name="remember" type="checkbox" class="custom-control-input" id="rememberMe"
                                                   <c:if test="${not empty rememberEmail}">checked</c:if>>
                                            <label class="custom-control-label" for="rememberMe">Remember me</label>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/forgetpassword" class="ml-auto">Forgot Password?</a>
                                    </div>
                                </div>
                                <div class="col-lg-12 m-b30">
                                    <button type="submit" class="btn button-md">Login</button>
                                </div>
                                <c:if test="${not empty googleAuthUrl}">
                                    <div class="col-lg-12">
                                        <h6>Login with Google</h6>
                                        <a class="btn flex-fill m-l5 google-plus" href="${googleAuthUrl}">
                                            <i class="fa fa-google"></i> Login with Google
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/assets1/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets1/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets1/js/functions.js"></script>
    </body>
</html>
