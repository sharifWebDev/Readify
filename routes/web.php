<?php
// File: routes/web.php
require_once '../controllers/AuthController.php';
require_once '../core/CSRF.php';

$path = $_SERVER['REQUEST_URI'];
$rootPath = str_replace('/Readify/public/', '/', $path);
 
$rootPath = rtrim($rootPath, '/');
if ($rootPath === '') {
    $rootPath = '/';
}

$auth = new AuthController();

if ($rootPath === '/' && $_SERVER['REQUEST_METHOD'] === 'GET') 
{ 
    if(!$auth->findDb()) {
        $auth->page('conn-setup');
        exit;
    }

    $auth->login();
} 
elseif ($rootPath === '/' && $_SERVER['REQUEST_METHOD'] === 'POST') 
{
    $auth->login();
} 
elseif ($rootPath === '/dashboard') 
{ 
    $auth->dashboard();
}

if ($rootPath === '/db-setup' && $_SERVER['REQUEST_METHOD'] === 'POST')
{
    $auth->setupDb();
}
