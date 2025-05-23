<?php
require_once '../core/Model.php';

class Author extends Model {

    public function index() {
        try {
            $stmt = $this->db->prepare("
                SELECT * FROM authors ORDER by id DESC
            ");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_OBJ);
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return [];
        }
    }

  public function store($data)
{
    try {
        $stmt = $this->db->prepare("
            INSERT INTO authors (name, slug, is_active, created_at) 
            VALUES (:name, :slug, :is_active, :created_at)
        ");

        $stmt->bindParam(':name', $data['name']);
        $stmt->bindParam(':slug', $data['slug']);
        $stmt->bindParam(':is_active', $data['is_active']);
        $stmt->bindParam(':created_at', $data['created_at']);

        $stmt->execute();
        return true;
    } catch (PDOException $e) {
        error_log($e->getMessage());
        echo "An error occurred while saving the author.";
        return false;
    }
}


}
?>
