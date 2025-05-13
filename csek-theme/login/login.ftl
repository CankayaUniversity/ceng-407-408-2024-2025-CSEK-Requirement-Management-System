<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>CSEK Login</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/login.css">
</head>
<body>
<div class="login-container">
    <img src="${url.resourcesPath}/img/logo.png" alt="CSEK Logo" class="logo">
    <h1>CSEK Requirement Management System</h1>
    <form action="${url.loginAction}" method="post">
        <input type="text" name="username" placeholder="Username" autofocus>
        <input type="password" name="password" placeholder="Password">
        <input type="submit" value="Log In">
    </form>
</div>
</body>
</html>
