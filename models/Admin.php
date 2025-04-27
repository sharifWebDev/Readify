<?php

require_once '../core/Model.php';

class Admin extends Model {
    private $email;
    private $password;
    private $username;
  
    public function setUsername($username) {
        $this->username = trim($username); 
    }

    public function setEmail($email) {
        $this->email = trim($email); 
    }

    public function setPassword($password) {
        $this->password = trim($password); 
    }

    public function login() {
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        try {
            if (empty($this->email) || empty($this->password)) {
                throw new Exception("Email and Password cannot be empty.");
            }
 
            $stmt = $this->db->prepare("SELECT id, email, password, username, verified_at FROM admins WHERE email = :email");
            $stmt->bindValue(':email', $this->email, PDO::PARAM_STR);
            $stmt->execute();

            $admin = $stmt->fetch(PDO::FETCH_OBJ);
  
            if ($admin && password_verify($this->password, $admin->password)) {
                
                $_SESSION['admin'] = [
                    'id' => $admin->id,
                    'email' => $admin->email,
                    'username' => $admin->username,
                    'verified_at' => $admin->verified_at  
                ];
                return true;
            }

            return false; 
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return false;  
        } catch (Exception $e) {
            error_log($e->getMessage());
            return false;  
        }
    }

    

    public function register() {
        if (empty($this->email) || empty($this->password) || empty($this->username)) {
            throw new Exception("Username, Email, and Password cannot be empty.");
        }

        if (!filter_var($this->email, FILTER_VALIDATE_EMAIL)) {
            throw new Exception("Invalid email format.");
        }

        try { 
            $stmt = $this->db->prepare("SELECT id FROM admins WHERE email = :email");
            $stmt->bindValue(':email', $this->email, PDO::PARAM_STR);
            $stmt->execute();
            if ($stmt->rowCount() > 0) {
                throw new Exception("Email is already registered.");
            }
 
            $hashedPassword = password_hash($this->password, PASSWORD_DEFAULT);
 
            $stmt = $this->db->prepare("INSERT INTO admins (email, password, username, verified_at) VALUES (:email, :password, :username, :verified_at)");
            $stmt->bindValue(':email', $this->email, PDO::PARAM_STR);
            $stmt->bindValue(':password', $hashedPassword, PDO::PARAM_STR);
            $stmt->bindValue(':username', $this->username, PDO::PARAM_STR);
            $stmt->bindValue(':verified_at', null, PDO::PARAM_NULL);  
 
            $stmt->execute();
  
            return true;
        } catch (PDOException $e) {
            error_log($e->getMessage());
            throw new Exception("Database error: " . $e->getMessage());
        } catch (Exception $e) {
            error_log($e->getMessage());
            throw new Exception($e->getMessage());
        }
    }
}
?>
