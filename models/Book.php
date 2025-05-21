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

    //get getIssueBook
    public function getIssueBook() {
        try {
            $stmt = $this->db->prepare("
                CALL ListTransactions()
            ");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_OBJ);
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return [];
        }
    }

    public function storeIssue($data) {
    try {
        $now = date('Y-m-d H:i:s');
        $issueData = [
            'transaction_id' => uniqid('TXN'),
            'member_id'      => $data['member_id'],
            'book_id'        => $data['book_id'],
            'issue_date'     => $data['issue_date'],
            'due_date'       => $data['due_date'] ?? null,
            'return_date'    => $data['return_date'],
            'fine_amount'    => $data['fine_amount'] ?? 0,
            'status'         => $data['status'] ?? '0',
            'is_approved'    => $data['is_approved'] ?? 1,
            'created_at'     => $data['created_at'] ?? $now,
        ];

        $stmt = $this->db->prepare("
            INSERT INTO transactions (
                transaction_id, member_id, book_id, issue_date, due_date, return_date,
                fine_amount, status, is_approved, created_at
            ) VALUES (
                :transaction_id, :member_id, :book_id, :issue_date, :due_date, :return_date,
                :fine_amount, :status, :is_approved, :created_at
            )
        ");

        $stmt->execute($issueData);

        return true;
    } catch (PDOException $e) {
        error_log($e->getMessage());
        return false;
    }
}
// updateIssue
public function updateIssue(array $data): bool
{
    try {
        $sql = "
            UPDATE transactions SET
                due_date = :due_date,
                fine_amount = :fine_amount,
                status = :status,
                is_approved = :is_approved,
                updated_at = :updated_at
            WHERE transaction_id = :transaction_id
        ";

        $stmt = $this->db->prepare($sql);

        // Use bindValue for flexibility and clarity
        $stmt->bindValue(':due_date', $data['due_date']);
        $stmt->bindValue(':fine_amount', $data['fine_amount']);
        $stmt->bindValue(':status', $data['status']);
        $stmt->bindValue(':is_approved', $data['is_approved']);
        $stmt->bindValue(':updated_at', $data['updated_at']);
        $stmt->bindValue(':transaction_id', $data['id']);

        return $stmt->execute();
    } catch (PDOException $e) {
        error_log("Database Error in updateIssue: " . $e->getMessage());
        return false;
    }
}




    //storeIssue 
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
