 DELIMITER $$

-- Create Transaction
CREATE PROCEDURE CreateTransaction(
    IN p_transaction_id VARCHAR(255),
    IN p_member_id INT,
    IN p_book_id INT,
    IN p_issue_date DATE,
    IN p_due_date DATE,
    IN p_fine_amount DECIMAL(10,2),
    IN p_status VARCHAR(20)
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during transaction creation' AS message;
    END;

    IF TRIM(p_transaction_id) = '' THEN
        SELECT 'error' AS status, 'Transaction ID is required' AS message;
        LEAVE proc;
    END IF;

    IF p_member_id IS NULL OR p_member_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Member ID' AS message;
        LEAVE proc;
    END IF;

    IF p_book_id IS NULL OR p_book_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Book ID' AS message;
        LEAVE proc;
    END IF;

    IF p_fine_amount < 0 THEN
        SELECT 'error' AS status, 'Fine amount must be non-negative' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO transactions (transaction_id, member_id, book_id, issue_date, due_date, fine_amount, status, is_approved, created_at, updated_at)
    VALUES (p_transaction_id, p_member_id, p_book_id, p_issue_date, p_due_date, p_fine_amount, p_status, 0, NOW(), NOW());

    COMMIT;

    SELECT 'success' AS status, 'Transaction created successfully' AS message;
END$$


-- Update Transaction
CREATE PROCEDURE UpdateTransaction(
    IN p_id INT,
    IN p_transaction_id VARCHAR(255),
    IN p_member_id INT,
    IN p_book_id INT,
    IN p_issue_date DATE,
    IN p_due_date DATE,
    IN p_fine_amount DECIMAL(10,2),
    IN p_status VARCHAR(20),
    IN p_is_approved BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during transaction update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Transaction ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM transactions WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Transaction not found' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_transaction_id) = '' THEN
        SELECT 'error' AS status, 'Transaction ID is required' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE transactions
    SET 
        transaction_id = p_transaction_id,
        member_id = p_member_id,
        book_id = p_book_id,
        issue_date = p_issue_date,
        due_date = p_due_date,
        fine_amount = p_fine_amount,
        status = p_status,
        is_approved = p_is_approved,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Transaction updated successfully' AS message;
END$$


-- Delete Transaction
CREATE PROCEDURE DeleteTransaction(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during transaction deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Transaction ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM transactions WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Transaction not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM transactions WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Transaction deleted successfully' AS message;
END$$


-- List All Transactions
CREATE PROCEDURE ListTransactions()
BEGIN
    DECLARE total_transactions INT;

    SELECT COUNT(*) INTO total_transactions FROM transactions;

    IF total_transactions = 0 THEN
        SELECT 'error' AS status, 'No transactions found' AS message;
    ELSE
        SELECT 
            id, 
            transaction_id, 
            member_id, 
            book_id, 
            issue_date, 
            due_date, 
            return_date, 
            fine_amount, 
            status, 
            is_approved, 
            created_at, 
            updated_at
        FROM transactions
        ORDER BY id DESC;
    END IF;
END$$

DELIMITER ;
