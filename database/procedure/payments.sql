DELIMITER $$

CREATE PROCEDURE CreatePayment(
    IN p_subscription_id INT,
    IN p_transaction_id VARCHAR(50),
    IN p_payment_method VARCHAR(20),
    IN p_total_payable_amount DECIMAL(10,2),
    IN p_fine_amount DECIMAL(10,2),
    IN p_total_due_amount DECIMAL(10,2),
    IN p_paid_amount DECIMAL(10,2),
    IN p_total_paid_amount DECIMAL(10,2),
    IN p_payment_status VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during payment creation' AS message;
    END;

    IF p_subscription_id IS NULL OR p_subscription_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Subscription ID' AS message;
        LEAVE proc;
    END IF;

    IF p_transaction_id IS NULL OR TRIM(p_transaction_id) = '' THEN
        SELECT 'error' AS status, 'Transaction ID is required' AS message;
        LEAVE proc;
    END IF;

    IF p_payment_method IS NULL OR TRIM(p_payment_method) = '' THEN
        SELECT 'error' AS status, 'Payment method is required' AS message;
        LEAVE proc;
    END IF;

    IF p_total_payable_amount <= 0 THEN
        SELECT 'error' AS status, 'Total payable amount must be greater than zero' AS message;
        LEAVE proc;
    END IF;

    IF p_paid_amount <= 0 THEN
        SELECT 'error' AS status, 'Paid amount must be greater than zero' AS message;
        LEAVE proc;
    END IF;

    IF p_payment_status NOT IN ('success', 'failed') THEN
        SELECT 'error' AS status, 'Invalid payment status' AS message;
        LEAVE proc;
    END IF;

    -- Check if the subscription exists
    IF NOT EXISTS (SELECT 1 FROM customer_subscriptions WHERE id = p_subscription_id) THEN
        SELECT 'error' AS status, 'Subscription not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO payments (
        subscription_id, 
        transaction_id, 
        payment_method, 
        total_payable_amount, 
        fine_amount, 
        total_due_amount, 
        paid_amount, 
        total_paid_amount, 
        payment_status
    ) VALUES (
        p_subscription_id, 
        p_transaction_id, 
        p_payment_method, 
        p_total_payable_amount, 
        p_fine_amount, 
        p_total_due_amount, 
        p_paid_amount, 
        p_total_paid_amount, 
        p_payment_status
    );

    COMMIT;

    SELECT 'success' AS status, 'Payment created successfully' AS message;
END$$

DELIMITER ;


-- //update
DELIMITER $$

CREATE PROCEDURE UpdatePayment(
    IN p_id INT,
    IN p_subscription_id INT,
    IN p_transaction_id VARCHAR(50),
    IN p_payment_method VARCHAR(20),
    IN p_total_payable_amount DECIMAL(10,2),
    IN p_fine_amount DECIMAL(10,2),
    IN p_total_due_amount DECIMAL(10,2),
    IN p_paid_amount DECIMAL(10,2),
    IN p_total_paid_amount DECIMAL(10,2),
    IN p_payment_status VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during payment update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Payment ID' AS message;
        LEAVE proc;
    END IF;

    IF p_subscription_id IS NULL OR p_subscription_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Subscription ID' AS message;
        LEAVE proc;
    END IF;

    IF p_transaction_id IS NULL OR TRIM(p_transaction_id) = '' THEN
        SELECT 'error' AS status, 'Transaction ID is required' AS message;
        LEAVE proc;
    END IF;

    IF p_payment_method IS NULL OR TRIM(p_payment_method) = '' THEN
        SELECT 'error' AS status, 'Payment method is required' AS message;
        LEAVE proc;
    END IF;

    IF p_total_payable_amount <= 0 THEN
        SELECT 'error' AS status, 'Total payable amount must be greater than zero' AS message;
        LEAVE proc;
    END IF;

    IF p_paid_amount <= 0 THEN
        SELECT 'error' AS status, 'Paid amount must be greater than zero' AS message;
        LEAVE proc;
    END IF;

    IF p_payment_status NOT IN ('success', 'failed') THEN
        SELECT 'error' AS status, 'Invalid payment status' AS message;
        LEAVE proc;
    END IF;

    -- Check if the payment exists
    IF NOT EXISTS (SELECT 1 FROM payments WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Payment not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE payments
    SET 
        subscription_id = p_subscription_id,
        transaction_id = p_transaction_id,
        payment_method = p_payment_method,
        total_payable_amount = p_total_payable_amount,
        fine_amount = p_fine_amount,
        total_due_amount = p_total_due_amount,
        paid_amount = p_paid_amount,
        total_paid_amount = p_total_paid_amount,
        payment_status = p_payment_status
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Payment updated successfully' AS message;
END$$

DELIMITER ;

-- view
DELIMITER $$

CREATE PROCEDURE ViewPayment(
    IN p_payment_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SELECT 'error' AS status, 'Something went wrong while fetching payment' AS message;
    END;

    IF p_payment_id IS NULL OR p_payment_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Payment ID' AS message;
    ELSE
        IF (SELECT COUNT(*) FROM payments WHERE id = p_payment_id) = 0 THEN
            SELECT 'error' AS status, 'No result found' AS message;
        ELSE
            SELECT 
                id, subscription_id, transaction_id, payment_method, total_payable_amount, 
                fine_amount, total_due_amount, paid_amount, total_paid_amount, payment_status, payment_date
            FROM payments
            WHERE id = p_payment_id;
        END IF;
    END IF;
END$$

DELIMITER ;


-- list
DELIMITER $$

CREATE PROCEDURE ListPayments()
BEGIN
    DECLARE total_payments INT;

    SELECT COUNT(*) INTO total_payments FROM payments;

    IF total_payments = 0 THEN
        SELECT 'error' AS status, 'No payments found' AS message;
    ELSE
        SELECT 
            id, subscription_id, transaction_id, payment_method, total_payable_amount, 
            fine_amount, total_due_amount, paid_amount, total_paid_amount, payment_status, payment_date
        FROM payments
        ORDER BY id DESC;
    END IF;
END$$

DELIMITER ;


-- //delete

DELIMITER $$

CREATE PROCEDURE DeletePayment(
    IN p_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during payment deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Payment ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM payments WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Payment not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM payments WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Payment deleted successfully' AS message;
END$$

DELIMITER ;
