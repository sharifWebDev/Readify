-- Full Members Table Stored Procedures (Advanced Version)

DELIMITER $$

-- Create Member
CREATE PROCEDURE CreateMember(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_phone VARCHAR(15),
    IN p_address VARCHAR(255),
    IN p_verified_at TIMESTAMP
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during member creation' AS message;
    END;

    IF TRIM(p_first_name) = '' OR TRIM(p_last_name) = '' OR TRIM(p_email) = '' OR TRIM(p_password) = '' THEN
        SELECT 'error' AS status, 'Required fields are missing' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_first_name) > 50 OR CHAR_LENGTH(p_last_name) > 50 OR CHAR_LENGTH(p_email) > 100 OR CHAR_LENGTH(p_phone) > 15 OR CHAR_LENGTH(p_address) > 255 THEN
        SELECT 'error' AS status, 'One or more fields exceed allowed length' AS message;
        LEAVE proc;
    END IF;

    IF NOT LOCATE('@', p_email) THEN
        SELECT 'error' AS status, 'Invalid email format' AS message;
        LEAVE proc;
    END IF;

    IF EXISTS (SELECT 1 FROM members WHERE email = p_email) THEN
        SELECT 'error' AS status, 'Email already exists' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO members (first_name, last_name, email, password, phone, address, verified_at, created_at, updated_at)
    VALUES (p_first_name, p_last_name, p_email, p_password, p_phone, p_address, p_verified_at, NOW(), NOW());

    COMMIT;

    SELECT 'success' AS status, 'Member created successfully' AS message;
END$$

-- Update Member
CREATE PROCEDURE UpdateMember(
    IN p_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_phone VARCHAR(15),
    IN p_address VARCHAR(255)
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during member update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Member ID' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_first_name) = '' OR TRIM(p_last_name) = '' THEN
        SELECT 'error' AS status, 'First Name and Last Name are required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_first_name) > 50 OR CHAR_LENGTH(p_last_name) > 50 OR CHAR_LENGTH(p_phone) > 15 OR CHAR_LENGTH(p_address) > 255 THEN
        SELECT 'error' AS status, 'One or more fields exceed allowed length' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM members WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Member not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE members
    SET first_name = p_first_name,
        last_name = p_last_name,
        phone = p_phone,
        address = p_address,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Member updated successfully' AS message;
END$$

-- View Member (Single) 
CREATE PROCEDURE ViewMember(
    IN p_member_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SELECT 'error' AS status, 'Something went wrong while fetching member' AS message;
    END;

    IF p_member_id IS NULL OR p_member_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Member ID' AS message;
    ELSE
        IF (SELECT COUNT(*) FROM members WHERE id = p_member_id) = 0 THEN
            SELECT 'error' AS status, 'No result found' AS message;
        ELSE
            SELECT 
                id, first_name, last_name, email, phone, address, verified_at, created_at, updated_at
            FROM 
                members
            WHERE 
                id = p_member_id;
        END IF;
    END IF;
END$$


-- List Members (All)
CREATE PROCEDURE ListMembers()
BEGIN
    DECLARE total_members INT;

    SELECT COUNT(*) INTO total_members FROM members;

    IF total_members = 0 THEN
        SELECT 'error' AS status, 'No members found' AS message;
    ELSE
        SELECT 
            id, first_name, last_name, email, phone, address, verified_at, created_at, updated_at
        FROM 
            members
        ORDER BY id DESC;
    END IF;
END$$

-- Delete Member
CREATE PROCEDURE DeleteMember(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during member deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Member ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM members WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Member not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM members WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Member deleted successfully' AS message;
END$$

DELIMITER ;
