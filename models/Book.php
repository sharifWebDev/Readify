<?php

require_once '../core/Model.php';

class Book extends Model { 

    public function getBooks() {
        
        try {

            $stmt = $this->db->prepare("SELECT * FROM books");

            $stmt->execute();

            return $stmt->fetchAll(PDO::FETCH_OBJ);

        } catch (PDOException $e) {

            error_log($e->getMessage()); 
            
            return [];
        }
    }
}
?>
