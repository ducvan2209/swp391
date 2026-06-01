<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>HRM - Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets1/css/style.css">
    <style>
        .home-card { max-width: 640px; margin: 48px auto; padding: 32px; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,.08); }
        .home-actions a { margin-right: 12px; }
    </style>
</head>
<body id="bg">
<div class="home-card">
    <h2>Welcome, ${user.fullname}</h2>
    <p>Email: ${user.email}</p>
    <p>Role: <c:out value="${user.role != null ? user.role.roleName : 'N/A'}"/></p>
    <p>Employee code: ${user.empCode}</p>
    <div class="home-actions m-t20">
        <a class="btn button-md" href="${pageContext.request.contextPath}/changepassword">Change password</a>
        <a class="btn button-md" href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</div>
</body>
</html>
