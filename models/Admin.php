
<?php

// File: models/Admin.php
require_once 'config/Database.php';
require_once 'core/Model.php';

class Admin extends Model {
    private $username;
    private $password;

    public function setUsername($username) {
        $this->username = trim($username);
    }

    public function setPassword($password) {
        $this->password = trim($password);
    }

    public function login() {
        try {
            $this->beginTransaction();

            $stmt = $this->db->prepare("SELECT id, username, password FROM admins WHERE username = ?");
            $stmt->bind_param("s", $this->username);
            $stmt->execute();
            $result = $stmt->get_result();
            $admin = $result->fetch_object();

            if ($admin && password_verify($this->password, $admin->password)) {
                $_SESSION['admin'] = $admin;
                $this->commit();
                return true;
            }

            $this->rollback();
            return false;
        } catch (Exception $e) {
            $this->rollback();
            error_log($e->getMessage());
            return false;
        }
    }
}