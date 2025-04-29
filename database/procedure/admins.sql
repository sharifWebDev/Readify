DELIMITER $$

-- Create Admin
CREATE PROCEDURE CreateAdmin(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100),
    IN p_verified_at TIMESTAMP
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during admin creation' AS message;
    END;

    IF TRIM(p_username) = '' OR TRIM(p_password) = '' OR TRIM(p_email) = '' THEN
        SELECT 'error' AS status, 'Required fields are missing' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_username) > 50 OR CHAR_LENGTH(p_email) > 100 THEN
        SELECT 'error' AS status, 'One or more fields exceed allowed length' AS message;
        LEAVE proc;
    END IF;

    IF NOT LOCATE('@', p_email) THEN
        SELECT 'error' AS status, 'Invalid email format' AS message;
        LEAVE proc;
    END IF;

    IF EXISTS (SELECT 1 FROM admins WHERE email = p_email OR username = p_username) THEN
        SELECT 'error' AS status, 'Email or Username already exists' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO admins (username, password, email, verified_at, created_at, updated_at)
    VALUES (p_username, p_password, p_email, p_verified_at, NOW(), NOW());

    COMMIT;

    SELECT 'success' AS status, 'Admin created successfully' AS message;
END$$

-- Update Admin
CREATE PROCEDURE UpdateAdmin(
    IN p_id INT,
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100)
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during admin update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Admin ID' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_username) = '' OR TRIM(p_email) = '' THEN
        SELECT 'error' AS status, 'Username and Email are required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_username) > 50 OR CHAR_LENGTH(p_email) > 100 THEN
        SELECT 'error' AS status, 'One or more fields exceed allowed length' AS message;
        LEAVE proc;
    END IF;

    IF NOT LOCATE('@', p_email) THEN
        SELECT 'error' AS status, 'Invalid email format' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM admins WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Admin not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE admins
    SET username = p_username,
        email = p_email,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Admin updated successfully' AS message;
END$$

-- View Admin (Single)
CREATE PROCEDURE ViewAdmin(
    IN p_admin_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SELECT 'error' AS status, 'Something went wrong while fetching admin' AS message;
    END;

    IF p_admin_id IS NULL OR p_admin_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Admin ID' AS message;
    ELSE
        IF (SELECT COUNT(*) FROM admins WHERE id = p_admin_id) = 0 THEN
            SELECT 'error' AS status, 'No result found' AS message;
        ELSE
            SELECT 
                id, username, email, verified_at, created_at, updated_at
            FROM 
                admins
            WHERE 
                id = p_admin_id;
        END IF;
    END IF;
END$$

-- List Admins (All)
CREATE PROCEDURE ListAdmins()
BEGIN
    DECLARE total_admins INT;

    SELECT COUNT(*) INTO total_admins FROM admins;

    IF total_admins = 0 THEN
        SELECT 'error' AS status, 'No admins found' AS message;
    ELSE
        SELECT 
            id, username, email, verified_at, created_at, updated_at
        FROM 
            admins
        ORDER BY id DESC;
    END IF;
END$$

-- Delete Admin
CREATE PROCEDURE DeleteAdmin(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during admin deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Admin ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM admins WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Admin not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM admins WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Admin deleted successfully' AS message;
END$$

DELIMITER ;
