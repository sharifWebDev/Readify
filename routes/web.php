<?php
// File: routes/web.php

require_once '../controllers/AuthController.php';
require_once '../core/CSRF.php';


$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
 

$publicPos = strpos($path, '/public');

if ($publicPos !== false) {
    $rootPath = substr($path, $publicPos + strlen('/public'));
} else {
    $rootPath = $path;
}
 
$rootPath = '/' . ltrim($rootPath, '/'); 
$rootPath = rtrim($rootPath, '/');  

if ($rootPath === '') {
    $rootPath = '/';
}

$auth = new AuthController();

if ($rootPath === '/' && $_SERVER['REQUEST_METHOD'] === 'GET') 
{ 
    if(!$auth->findDb()) {
        $auth->dbSetup();
    }

    // echo $rootPath;
    // exit ;

    $auth->adminLogin();
}

if ($rootPath === '/' && $_SERVER['REQUEST_METHOD'] === 'GET') 
{
    $auth->dashboard();
}

if ($rootPath === '/login' && $_SERVER['REQUEST_METHOD'] === 'GET') 
{
    $auth->loginPage();
    exit;
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

if ($rootPath === '/users' && $_SERVER['REQUEST_METHOD'] === 'GET') 
{
    $auth->users();
}

if ($rootPath === '/admin-dashboard') 
{ 
    $auth->dashboard();
}

if ($rootPath === '/db-setup' && $_SERVER['REQUEST_METHOD'] === 'POST')
{
    $auth->setupDb();
}
  
if (http_response_code() === 404) {
    echo "404 Not Found";
}

//for book routes


require_once '../controllers/BookController.php';
 

$bookController = new BookController();

if ($rootPath === '/books' && $_SERVER['REQUEST_METHOD'] === 'GET') {
   $bookController->index();
} elseif ($rootPath === '/books/create' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    $bookController->create();
} elseif ($rootPath === '/books/store' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $bookController->store();
} elseif ($rootPath === '/books/edit' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    $bookController->edit();
} elseif ($rootPath === '/books/update' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $bookController->update();
} elseif ($rootPath === '/books/delete' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    $bookController->destroy($_GET['id']);
}

require_once '../controllers/CustomerSubscriptionsController.php';


$customerSubsController = new CustomerSubscriptionsController();

if ($rootPath === '/customer-subscriptions' && $_SERVER['REQUEST_METHOD'] === 'GET') {
   $customerSubsController->index();
}
if ($rootPath === '/customer-subscriptions/store' && $_SERVER['REQUEST_METHOD'] === 'POST') {
   $customerSubsController->store();
}
if ($rootPath === '/issue-books' && $_SERVER['REQUEST_METHOD'] === 'GET') {
   $customerSubsController->issueBook();
}
if ($rootPath === '/issue-books/store' && $_SERVER['REQUEST_METHOD'] === 'POST') {
   $customerSubsController->storeIssue();
}
if ($rootPath === '/issue-books/update' && $_SERVER['REQUEST_METHOD'] === 'POST') {
   $customerSubsController->updateIssue();
}



if ($rootPath === '/late-fee' && $_SERVER['REQUEST_METHOD'] === 'GET') {
   $customerSubsController->lateFee();
}
if ($rootPath === '/revenue' && $_SERVER['REQUEST_METHOD'] === 'GET') {
   $customerSubsController->revenue();
}


require_once '../controllers/MemberController.php';

$MemberController = new MemberController();

if ($rootPath === '/members' && $_SERVER['REQUEST_METHOD'] === 'GET') {
   $MemberController->index();
}
if ($rootPath === '/members/store' && $_SERVER['REQUEST_METHOD'] === 'POST') {
   $MemberController->store();
}



require_once '../controllers/CategoryController.php';
$CategoryController = new CategoryController();

if ($rootPath === '/categories' && $_SERVER['REQUEST_METHOD'] === 'GET') {
   $CategoryController->index();
}
if ($rootPath === '/category/store' && $_SERVER['REQUEST_METHOD'] === 'POST') {
   $CategoryController->store();
}



