<?php

require_once '../core/Controller.php';
require_once '../controllers/AuthController.php';

class AuthCheck
{
    protected $auth;

    public function __construct()
    {
        $this->auth = new AuthController();

        if (!isset($_SESSION['admin'])) {
            $this->auth->adminLogin();
            exit;
        }

        if (!isset($_SESSION['token'])) {
             $this->auth->adminLogin();
        }

        if (!CSRF::validateToken($_SESSION['token'])) {
             $this->auth->adminLogin();
        }
    } 
}
