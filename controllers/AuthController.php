<?php

// File: controllers/AuthController.php
require_once '../core/Controller.php';
require_once '../config/DatabaseSeeder.php';
require_once '../models/Admin.php';

class AuthController extends Controller {

    public function adminLogin() {

         $this->redirect('/login');
    }

    public function loginPage() {

          $this->view('Login');
    }

    public function login() {

        if ($_SERVER['REQUEST_METHOD'] === 'POST' && CSRF::validateToken($_POST['token'])) {

            $admin = new Admin();

            $admin->setEmail($_POST['email']);

            $admin->setPassword($_POST['password']);
    
            if ($admin->login()) {

                return $this->redirect('/admin-dashboard');

                exit;

            }
            
            return $this->view('Login', ['error' => 'Invalid credentials.']);
            
        }
    }

    public function adminRegister() {
        
        return $this->view('Register');
    }

    public function register() {
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST' && CSRF::validateToken($_POST['token'])) {
             
            $admin = new Admin();
             
            $admin->setUsername(trim($_POST['username']));
            $admin->setEmail(trim($_POST['email']));
            $admin->setPassword(trim($_POST['password']));
            
            try { 
                if ($admin->register()) { 
                    return $this->redirect('/users');
                }
            } catch (Exception $e) { 
                $_SESSION['error_message'] = $e->getMessage();
            }
        }
    }


    public function users() {

        $admin = new Admin();

        $users = $admin->getUsers();

        return $this->view('Users', ['users' => $users]);
    }
    
 
 
    public function logout() {

        session_destroy();

        return $this->view('Login');

        exit;
    }

   

    public function dashboard() {
        return $this->view('Admin-Dashboard', ['success' => 'You are logged in.']);
    }

    public function findDb()
    {
        if (!$this->checkDb()) {
           return false;
        }
        return true;
    }

    public function checkDb(): bool
    {
        $host = 'localhost';   
        $username = 'root';  
        $password = '';      
        $database = 'readify'; 

        try {
            $pdo = new PDO("mysql:host=$host", $username, $password);
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            $stmt = $pdo->prepare("SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = :dbname");
            $stmt->bindParam(':dbname', $database);
            $stmt->execute();

            return $stmt->rowCount() > 0;
        } catch (PDOException $e) { 
            return false;
        }
    }

    public function setupDb()
    {
    try{
            $this->createDB();
            $this->dbMigrate();
            $this->dbSeed();
            
        $message = urlencode('✅ Setup completed successfully!');
        header("Location: /login?message=$message");

        } catch (PDOException $e) {
            echo "Error creating database operations: " . $e->getMessage();
        }
    }

    public function createDB()
    {
        $host = 'localhost';
        $username = 'root';
        $password = '';
        $database = 'readify';

        try {
            $pdo = new PDO("mysql:host=$host", $username, $password);
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            $pdo->exec("CREATE DATABASE `$database` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            echo "✅ Database '$database' created successfully.<br>";
        } catch (PDOException $e) {
            echo "Error creating database: " . $e->getMessage();
        }
    }

    public function dbMigrate()
    {
        $host = 'localhost';
        $username = 'root';
        $password = '';
        $database = 'readify';
    
        try {
            $pdo = new PDO("mysql:host=$host;dbname=$database", $username, $password);
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
            $sqlFilePath = realpath(__DIR__ . '/../readify.sql');
            
            if (!$sqlFilePath || !file_exists($sqlFilePath)) {
                throw new Exception("❌ SQL file not found or not accessible at: " . __DIR__ . '/../readify.sql');
            }
    
            $sql = file_get_contents($sqlFilePath);
    
            if (empty(trim($sql))) {
                throw new Exception("❌ SQL file is empty.");
            }
    
            $pdo->exec($sql);
            echo "✅ Database migration completed successfully.";
        } catch (PDOException $e) {
            echo "❌ Migration failed: " . $e->getMessage();
        } catch (Exception $e) {
            echo "❌ Error: " . $e->getMessage();
        }
    }
    

    public function dbSeed()
    {
        $host = 'localhost';
        $username = 'root';
        $password = '';
        $database = 'readify';
    
        try {
            $pdo = new PDO("mysql:host=$host;dbname=$database", $username, $password);
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
            $seeder = new DatabaseSeeder();
            $seeder->run($pdo);  // Pass PDO instance
    
            echo "✅ Database seeded successfully.<br>";
        } catch (PDOException $e) {
            echo "❌ Seeding failed: " . $e->getMessage();
        }
    }
    

}
