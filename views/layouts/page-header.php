<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Readify | Admin </title>
    <!-- Bootstrap 5.1 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style> 
        .login-wrapper {
            height: 100vh;
        }
        .login-card {
            max-width: 400px;
            width: 100%;
            border-radius: 1rem;
            padding: 2rem;
        }

        .bg-info,  .list-group-item.active {
            background-color:rgb(19, 11, 73) !important;
        }
 
    </style>
</head>
<body>


<?php

require_once __DIR__ . '/../../core/MakeUrl.php';

$url = new MakeUrl();

if (!isset($_SESSION['admin'])) {
    header('Location: ' . $url->url('login'));
}
  
?>
