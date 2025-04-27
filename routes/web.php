<?php
// File: routes/web.php

require_once '../controllers/AuthController.php';
require_once '../core/CSRF.php'; 
 
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

$publicPos = strpos($path, '/public/');

if ($publicPos !== false) {
    $rootPath = substr($path, $publicPos + strlen('/public'));
} else {
    $rootPath = $path;
}

$rootPath = rtrim($rootPath, '/');
if ($rootPath === '') {
    $rootPath = '/';
}

// Routing
$auth = new AuthController();

if ($rootPath === '/' && $_SERVER['REQUEST_METHOD'] === 'GET') 
{ 
    if(!$auth->findDb()) {
        $auth->page('conn-setup');
        exit;
    }

    $auth->login();
} 

if ($rootPath === '/' && $_SERVER['REQUEST_METHOD'] === 'GET') 
{
    $auth->dashboard();
} 

if ($rootPath === '/login' && $_SERVER['REQUEST_METHOD'] === 'GET') 
{
    $auth->adminLogin();
}

if ($rootPath === '/login' && $_SERVER['REQUEST_METHOD'] === 'POST') 
{
    $auth->login();
} 

if ($rootPath === '/logout' && $_SERVER['REQUEST_METHOD'] === 'POST') 
{
    $auth->logout();
}

if ($rootPath === '/register' && $_SERVER['REQUEST_METHOD'] === 'GET') 
{
    $auth->adminRegister();
}

if ($rootPath === '/register' && $_SERVER['REQUEST_METHOD'] === 'POST') 
{
    $auth->register();
}

if ($rootPath === '/admin-dashboard') 
{ 
    $auth->dashboard();
}

if ($rootPath === '/db-setup' && $_SERVER['REQUEST_METHOD'] === 'POST')
{
    $auth->setupDb();
}
 
http_response_code(404);
echo "404 Not Found";
 