<?php

// File: controllers/AuthController.php
require_once 'core/Controller.php';
require_once 'models/Admin.php';

class AuthController extends Controller {
    public function login() {
        if ($_SERVER['REQUEST_METHOD'] === 'POST' && CSRF::validateToken($_POST['token'])) {
            $admin = new Admin();
            $admin->setUsername($_POST['username']);
            $admin->setPassword($_POST['password']);

            if ($admin->login()) {
                header("Location: /dashboard");
                exit;
            } else {
                $this->view('login', ['error' => 'Invalid credentials.']);
            }
        } else {
            $this->view('login');
        }
    }

    public function dashboard() {
        if (!isset($_SESSION['admin'])) {
            header("Location: /");
            exit;
        }
        $this->view('dashboard');
    }
}
