<?php
require_once '../core/Model.php';

class Members extends Model {

    public function index() {
        try {
            $stmt = $this->db->prepare("
                SELECT * FROM members
            ");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_OBJ);
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return [];
        }
    }

    public function store($data) {
        try { 
            $stmt = $this->db->prepare("
                INSERT INTO members (first_name, last_name, email, password, phone, address, verified_at) 
                VALUES (:first_name, :last_name, :email, :password, :phone, :address, :verified_at)
            ");
            $stmt->bindParam(':first_name', $data['first_name']);
            $stmt->bindParam(':last_name', $data['last_name']);
            $stmt->bindParam(':email', $data['email']);
            $stmt->bindParam(':password', $data['password']);
            $stmt->bindParam(':phone', $data['phone']);
            $stmt->bindParam(':address', $data['address']);
            $stmt->bindParam(':verified_at', $data['verified_at']);

            $stmt->execute();
            return true;
        } catch (PDOException $e) {
            error_log($e->getMessage());
            echo "An error occurred while saving the member.";
            return false;
        }
    }

}
?>
