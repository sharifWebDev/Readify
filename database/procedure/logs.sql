-- Drop if exists
DROP PROCEDURE IF EXISTS CreateLog;
DROP PROCEDURE IF EXISTS ViewLog;
DROP PROCEDURE IF EXISTS ListLogs;
DROP PROCEDURE IF EXISTS DeleteLog;

DELIMITER $$

-- Procedure: CreateLog
CREATE PROCEDURE CreateLog(
    IN p_action VARCHAR(255),
    IN p_user_type VARCHAR(20),
    IN p_user_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong while creating log' AS message;
    END;

    -- Validation
    IF p_action IS NULL OR TRIM(p_action) = '' THEN
        SELECT 'error' AS status, 'Action is required' AS message;
        LEAVE proc;
    END IF;

    IF p_user_type IS NULL OR TRIM(p_user_type) = '' THEN
        SELECT 'error' AS status, 'User type is required' AS message;
        LEAVE proc;
    END IF;

    IF p_user_id IS NULL OR p_user_id <= 0 THEN
        SELECT 'error' AS status, 'User ID is invalid' AS message;
        LEAVE proc;
    END IF;

    -- Optional: Check if admin exists (optional validation)
    IF NOT EXISTS (SELECT 1 FROM admins WHERE id = p_user_id) THEN
        SELECT 'error' AS status, 'User not found in admins table' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO logs (action, user_type, user_id)
    VALUES (p_action, p_user_type, p_user_id);

    COMMIT;

    SELECT 'success' AS status, 'Log created successfully' AS message;
END$$


-- Procedure: View Single Log
CREATE PROCEDURE ViewLog(
    IN p_id INT
)
BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid ID' AS message;
    ELSE
        IF NOT EXISTS (SELECT 1 FROM logs WHERE id = p_id) THEN
            SELECT 'error' AS status, 'Log not found' AS message;
        ELSE
            SELECT * FROM logs WHERE id = p_id;
        END IF;
    END IF;
END$$


-- Procedure: List All Logs
CREATE PROCEDURE ListLogs()
BEGIN
    IF (SELECT COUNT(*) FROM logs) = 0 THEN
        SELECT 'error' AS status, 'No logs found' AS message;
    ELSE
        SELECT * FROM logs ORDER BY timestamp DESC;
    END IF;
END$$


-- Procedure: Delete Log
CREATE PROCEDURE DeleteLog(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong while deleting log' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM logs WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Log not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM logs WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Log deleted successfully' AS message;
END$$

DELIMITER ;
