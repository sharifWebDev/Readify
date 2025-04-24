<?php
// File: routes/web.php
require_once 'controllers/AuthController.php';
require_once 'core/CSRF.php';

$path = $_SERVER['REQUEST_URI'];

$auth = new AuthController();

if ($path === '/' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    $auth->login();
} elseif ($path === '/' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $auth->login();
} elseif ($path === '/dashboard') {
    $auth->dashboard();
}
