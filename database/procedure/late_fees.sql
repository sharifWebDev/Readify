-- Drop Procedures if exists
DROP PROCEDURE IF EXISTS CreateLateFee;
DROP PROCEDURE IF EXISTS UpdateLateFee;
DROP PROCEDURE IF EXISTS ViewLateFee;
DROP PROCEDURE IF EXISTS ListLateFees;
DROP PROCEDURE IF EXISTS DeleteLateFee;

-- Create Late Fee
DELIMITER $$

CREATE PROCEDURE CreateLateFee(
    IN p_key_name VARCHAR(50),
    IN p_charge DECIMAL(10,2),
    IN p_is_active BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during creation' AS message;
    END;

    -- Validation
    IF p_key_name IS NULL OR TRIM(p_key_name) = '' THEN
        SELECT 'error' AS status, 'Key Name is required' AS message;
        LEAVE proc;
    END IF;

    IF p_charge IS NULL OR p_charge < 0 THEN
        SELECT 'error' AS status, 'Charge must be a positive value' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO late_fees (key_name, charge, is_active)
    VALUES (p_key_name, p_charge, COALESCE(p_is_active, 1));

    COMMIT;

    SELECT 'success' AS status, 'Late fee created successfully' AS message;
END$$

-- Update Late Fee
CREATE PROCEDURE UpdateLateFee(
    IN p_id INT,
    IN p_key_name VARCHAR(50),
    IN p_charge DECIMAL(10,2),
    IN p_is_active BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during update' AS message;
    END;

    -- Validation
    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM late_fees WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Late fee record not found' AS message;
        LEAVE proc;
    END IF;

    IF p_key_name IS NULL OR TRIM(p_key_name) = '' THEN
        SELECT 'error' AS status, 'Key Name is required' AS message;
        LEAVE proc;
    END IF;

    IF p_charge IS NULL OR p_charge < 0 THEN
        SELECT 'error' AS status, 'Charge must be a positive value' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE late_fees
    SET 
        key_name = p_key_name,
        charge = p_charge,
        is_active = COALESCE(p_is_active, 1),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Late fee updated successfully' AS message;
END$$

-- View Single Late Fee
CREATE PROCEDURE ViewLateFee(
    IN p_id INT
)
BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid ID' AS message;
    ELSE
        IF (SELECT COUNT(*) FROM late_fees WHERE id = p_id) = 0 THEN
            SELECT 'error' AS status, 'Late fee record not found' AS message;
        ELSE
            SELECT 
                id, key_name, charge, is_active, created_at, updated_at
            FROM late_fees
            WHERE id = p_id;
        END IF;
    END IF;
END$$

-- List All Late Fees
CREATE PROCEDURE ListLateFees()
BEGIN
    IF (SELECT COUNT(*) FROM late_fees) = 0 THEN
        SELECT 'error' AS status, 'No late fee records found' AS message;
    ELSE
        SELECT 
            id, key_name, charge, is_active, created_at, updated_at
        FROM late_fees
        ORDER BY id DESC;
    END IF;
END$$

-- Delete Late Fee
CREATE PROCEDURE DeleteLateFee(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM late_fees WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Late fee record not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM late_fees WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Late fee deleted successfully' AS message;
END$$

DELIMITER ;
