<?php

require_once '../controllers/UserController.php';
 

$userController = new UserController();

if ($path === '/users' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    $userController->index();
} elseif ($path === '/users/create' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    $userController->create();
} elseif ($path === '/users/store' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $userController->store();
} elseif ($path === '/users/edit' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    $userController->edit();
} elseif ($path === '/users/update' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $userController->update();
} elseif ($path === '/users/delete' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $userController->destroy();
}
