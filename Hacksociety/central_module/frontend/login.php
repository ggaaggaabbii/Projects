<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="css/bootstrap.min.css" >
		<link rel="stylesheet" href="css/bootstrap-theme.min.css">
		<script src="js/bootstrap.min.js"></script>
		<link href="css/style.css" rel="stylesheet">
		<meta charset="utf-8">
	<title>Login</title>
</head>
<body>
<div class="container">
<form action="submit_login.php" method="POST">
		<br>
		<div class="jumbotron">
		<br>
		<div class="input-group">
			<span class="input-group-addon">Username</span>
			<input type="text" name="Username" class="form-control" required>
		</div>
<div class="input-group">
			<span class="input-group-addon">Password</span>
			<input type="password" name="Password" class="form-control" required>
			</div>
			<br>
		<input type="submit" class="btn btn-success" value="Trimite">
		<br>
		<a href="register.php">Don't have an account? Register now!
		</a>
		</form>
		</div>
		</div>
		</div>
<br>
</body>
</html>