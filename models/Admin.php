<?php

require_once '../config/Database.php';
require_once '../core/Model.php';

class Admin extends Model {
    private $email;
    private $password;

    public function setEmail($email) {
        $this->email = trim($email);
    }

    public function setPassword($password) {
        $this->password = trim($password);
    }

    public function login() {
        try {
            $stmt = $this->db->prepare("SELECT id, email, password, email FROM admins WHERE email = ?");
            $stmt->bind_param("s", $this->email);
            $stmt->execute();
            $result = $stmt->get_result();
            $admin = $result->fetch_object();

            if ($admin && password_verify($this->password, $admin->password)) {
                $_SESSION['admin'] = $admin;
                return true;
            }

            return false;
        } catch (Exception $e) {
            error_log($e->getMessage());
            return false;
        }
    }
}
