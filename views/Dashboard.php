
<!-- // File: views/dashboard.php -->
<?php session_start(); ?>
<h1>Welcome, <?= $_SESSION['admin']->username ?></h1>
<a href="/">Logout</a>
