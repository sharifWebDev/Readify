<?php
require_once '../core/Model.php';

class CustomerSubscriptions extends Model {

    public function getSubscriptions() {
        try {
            $stmt = $this->db->prepare("
                SELECT * FROM customer_subscriptions
            ");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_OBJ);
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return [];
        }
    }

    // getLateFee
    public function getLateFee() {
        try {
            $stmt = $this->db->prepare("
                CALL get_late_fee_report()
            ");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_OBJ);
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return [];
        }
    }
    // getLateFee
    public function getRevenue() {
        try {
            $stmt = $this->db->prepare("
                CALL sp_subscription_revenue_report()
            ");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_OBJ);
        } catch (PDOException $e) {
            error_log($e->getMessage());
            return [];
        }
    }
 
}
?>
