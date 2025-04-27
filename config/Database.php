<?php

class Database {
    public $pdo;

    public function connect() {
        $host = 'localhost';        // Server name
        $db = 'readify';         // Database name
        $user = 'root';             // Database user
        $pass = '';                 // Database password (XAMPP default is empty)
        $charset = 'utf8mb4';       // Character encoding

        // DSN (Data Source Name) for PDO connection
        $dsn = "mysql:host=$host;dbname=$db;charset=$charset";

        // Attempt to connect
        try {
            $this->pdo = new PDO($dsn, $user, $pass);
            $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);  // Enable error reporting
        } catch (PDOException $e) {
            die("Connection failed: " . $e->getMessage());  // Simple error message and exit
        }
    }
}
