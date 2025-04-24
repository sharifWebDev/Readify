<?php
// File: config/Database.php
class Database {
    private $host = 'localhost';
    private $db = 'readify';
    private $user = 'root';
    private $pass = '';
    private $conn;

    public function connect() {
        if (!$this->conn) {
            $this->conn = new mysqli($this->host, $this->user, $this->pass, $this->db);
            if ($this->conn->connect_error) {
                die("Connection failed: " . $this->conn->connect_error);
            }
            $this->conn->autocommit(false);
        }
        return $this->conn;
    }
}