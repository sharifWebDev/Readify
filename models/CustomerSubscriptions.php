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

    //store
    public function store($data) {
    try { 
        $stmt = $this->db->prepare("
            INSERT INTO customer_subscriptions (member_id, subscription_id, start_date, end_date, payment_status, payable_amount, payment_date)
            VALUES (:member_id, :subscription_id, :start_date, :end_date, :payment_status, :payable_amount, :payment_date)
        ");
        $stmt->execute($data);
 
        $subscriptionId = $this->db->lastInsertId();
 
        $paymentData = [
            'subscription_id'      => $subscriptionId,  
            'transaction_id'       => uniqid('TXN'),
            'payment_method'       => $data['payment_method'] ?? 'Cash',
            'total_payable_amount' => $data['payable_amount'],
            'fine_amount'          => $data['fine_amount'] ?? 0,
            'total_due_amount'     => $data['payable_amount'],
            'paid_amount'          => $data['payable_amount'],
            'total_paid_amount'    => $data['payable_amount'],
            'payment_status'       => $data['payment_status'],
        ];
 
        $stmt2 = $this->db->prepare("
            INSERT INTO payments (
                subscription_id, transaction_id, payment_method,
                total_payable_amount, fine_amount, total_due_amount,
                paid_amount, total_paid_amount, payment_status
            ) VALUES (
                :subscription_id, :transaction_id, :payment_method,
                :total_payable_amount, :fine_amount, :total_due_amount,
                :paid_amount, :total_paid_amount, :payment_status
            )
        ");
        $stmt2->execute($paymentData);

        return true;
    } catch (PDOException $e) {
        error_log($e->getMessage());
        return false;
    }
}


    //getSubscriptionsPackage
    public function getSubscriptionsPackage() {
        try {
            $stmt = $this->db->prepare("
                SELECT * FROM subscription_packages  ORDER by id DESC
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
