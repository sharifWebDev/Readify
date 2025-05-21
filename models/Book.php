<?php
require_once '../core/Model.php';

class Book extends Model {

    public function getBooks() {
        try {
            $stmt = $this->db->prepare("
                SELECT books.*, authors.name AS author_name, categories.name AS category_name
                FROM books
                LEFT JOIN authors ON books.author_id = authors.id
                LEFT JOIN categories ON books.category_id = categories.id
            ");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_OBJ);
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return [];
        }
    }

    public function getAuthors() {
        try {
            $stmt = $this->db->prepare("SELECT * FROM authors");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_OBJ);
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return [];
        }
    }

    public function getCategories() {
        try {
            $stmt = $this->db->prepare("SELECT * FROM categories");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_OBJ);
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return [];
        }
    }

    public function createBook($data) {
        try {
            $stmt = $this->db->prepare("
                INSERT INTO books (title, author_id, isbn, code, category_id, quantity)
                VALUES (:title, :author_id, :isbn, :code, :category_id, :quantity)
            ");

            $stmt->bindParam(':title', $data['title']);
            $stmt->bindParam(':author_id', $data['author_id']);
            $stmt->bindParam(':isbn', $data['isbn']);
            $stmt->bindParam(':code', $data['code']);
            $stmt->bindParam(':category_id', $data['category_id']);
            $stmt->bindParam(':quantity', $data['quantity']);

            return $stmt->execute();
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return false;
        }
    }

    public function deleteBook($id) {
        try {
            $stmt = $this->db->prepare("DELETE FROM books WHERE id = :id");
            $stmt->bindParam(':id', $id);
            return $stmt->execute();
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return false;
        }
    }
}
?>
