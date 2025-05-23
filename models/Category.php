<?php
require_once '../core/Model.php';

class Category extends Model {

    public function index() {
        try {
            $stmt = $this->db->prepare("
                SELECT * FROM categories ORDER by id DESC
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
            INSERT INTO categories (name, slug, parent_category_id, is_active, created_at) 
            VALUES (:name, :slug, :parent_category_id, :is_active, :created_at)
        ");

        $stmt->bindParam(':name', $data['name']);
        $stmt->bindParam(':slug', $data['slug']);
        $stmt->bindParam(':parent_category_id', $data['parent_category_id']);
        $stmt->bindParam(':is_active', $data['is_active']);
        $stmt->bindParam(':created_at', $data['created_at']);

        $stmt->execute();
        return true;
    } catch (PDOException $e) {
        error_log($e->getMessage());
        echo "An error occurred while saving the category.";
        return false;
    }
}


}
?>
