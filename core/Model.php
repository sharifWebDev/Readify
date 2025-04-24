<?php

// File: core/Model.php

abstract class Model {
    protected $db;

    public function __construct() {
        $this->db = (new Database())->connect();
    }

    protected function beginTransaction() {
        $this->db->begin_transaction();
    }

    protected function commit() {
        $this->db->commit();
    }

    protected function rollback() {
        $this->db->rollback();
    }
}