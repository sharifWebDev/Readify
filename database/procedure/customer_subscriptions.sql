DELIMITER $$

-- Create Customer Subscription
CREATE PROCEDURE CreateCustomerSubscription(
    IN p_member_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_payment_status VARCHAR(20),
    IN p_payable_amount DECIMAL(10,2),
    IN p_payment_date DATE
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during subscription creation' AS message;
    END;

    IF p_member_id IS NULL OR p_member_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Member ID' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_payment_status) = '' THEN
        SELECT 'error' AS status, 'Payment status is required' AS message;
        LEAVE proc;
    END IF;

    IF p_payable_amount < 0 THEN
        SELECT 'error' AS status, 'Payable amount must be non-negative' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO customer_subscriptions (member_id, start_date, end_date, payment_status, payable_amount, payment_date, created_at, updated_at)
    VALUES (p_member_id, p_start_date, p_end_date, p_payment_status, p_payable_amount, p_payment_date, NOW(), NOW());

    COMMIT;

    SELECT 'success' AS status, 'Customer subscription created successfully' AS message;
END$$


-- Update Customer Subscription
CREATE PROCEDURE UpdateCustomerSubscription(
    IN p_id INT,
    IN p_member_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_payment_status VARCHAR(20),
    IN p_payable_amount DECIMAL(10,2),
    IN p_payment_date DATE
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during subscription update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Subscription ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM customer_subscriptions WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Subscription not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE customer_subscriptions
    SET 
        member_id = p_member_id,
        start_date = p_start_date,
        end_date = p_end_date,
        payment_status = p_payment_status,
        payable_amount = p_payable_amount,
        payment_date = p_payment_date,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Customer subscription updated successfully' AS message;
END$$


-- Delete Customer Subscription
CREATE PROCEDURE DeleteCustomerSubscription(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during subscription deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Subscription ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM customer_subscriptions WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Subscription not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM customer_subscriptions WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Customer subscription deleted successfully' AS message;
END$$


-- List All Customer Subscriptions
CREATE PROCEDURE ListCustomerSubscriptions()
BEGIN
    DECLARE total_subscriptions INT;

    SELECT COUNT(*) INTO total_subscriptions FROM customer_subscriptions;

    IF total_subscriptions = 0 THEN
        SELECT 'error' AS status, 'No subscriptions found' AS message;
    ELSE
        SELECT 
            id, 
            member_id, 
            start_date, 
            end_date, 
            payment_status, 
            payable_amount, 
            payment_date, 
            created_at, 
            updated_at
        FROM customer_subscriptions
        ORDER BY id DESC;
    END IF;
END$$

DELIMITER ;
