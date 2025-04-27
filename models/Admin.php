<?php

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
            $stmt = $this->db->prepare("SELECT id, email, password FROM admins WHERE email = :email");
            $stmt->bindValue(':email', $this->email, PDO::PARAM_STR);
            $stmt->execute();
            $admin = $stmt->fetch(PDO::FETCH_OBJ);

            if ($admin && password_verify($this->password, $admin->password)) {
                $_SESSION['admin'] = $admin;
                return true;
            }

            return false;
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return false;
        }
    }
}
