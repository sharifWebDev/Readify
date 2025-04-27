<?php

require_once __DIR__ . '/../config/Database.php'; // Correct path to your Database class

abstract class Model {
    protected $db;

    public function __construct() {
        $database = new Database();
        $database->connect();  // Make sure the connection is established here
        $this->db = $database->pdo;  // Assign the PDO object to the class property
    }

    protected function beginTransaction() {
        $this->db->beginTransaction();  // PDO method
    }

    protected function commit() {
        $this->db->commit();  // PDO method
    }

    protected function rollback() {
        $this->db->rollBack();  // PDO method
    }
}
