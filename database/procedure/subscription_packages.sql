DELIMITER $$

-- Create Subscription Package
CREATE PROCEDURE CreateSubscriptionPackage(
    IN p_package_name VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_discount DECIMAL(10,2),
    IN p_is_active BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during package creation' AS message;
    END;

    IF TRIM(p_package_name) = '' THEN
        SELECT 'error' AS status, 'Package name is required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_package_name) > 50 THEN
        SELECT 'error' AS status, 'Package name exceeds maximum length' AS message;
        LEAVE proc;
    END IF;

    IF p_price < 0 THEN
        SELECT 'error' AS status, 'Price must be non-negative' AS message;
        LEAVE proc;
    END IF;

    IF p_discount < 0 THEN
        SELECT 'error' AS status, 'Discount must be non-negative' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO subscription_packages (package_name, price, discount, is_active, created_at, updated_at)
    VALUES (p_package_name, p_price, p_discount, p_is_active, NOW(), NOW());

    COMMIT;

    SELECT 'success' AS status, 'Subscription package created successfully' AS message;
END$$


-- Update Subscription Package
CREATE PROCEDURE UpdateSubscriptionPackage(
    IN p_id INT,
    IN p_package_name VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_discount DECIMAL(10,2),
    IN p_is_active BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during package update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Package ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM subscription_packages WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Package not found' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_package_name) = '' THEN
        SELECT 'error' AS status, 'Package name is required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_package_name) > 50 THEN
        SELECT 'error' AS status, 'Package name exceeds maximum length' AS message;
        LEAVE proc;
    END IF;

    IF p_price < 0 THEN
        SELECT 'error' AS status, 'Price must be non-negative' AS message;
        LEAVE proc;
    END IF;

    IF p_discount < 0 THEN
        SELECT 'error' AS status, 'Discount must be non-negative' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE subscription_packages
    SET 
        package_name = p_package_name,
        price = p_price,
        discount = p_discount,
        is_active = p_is_active,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Subscription package updated successfully' AS message;
END$$


-- Delete Subscription Package
CREATE PROCEDURE DeleteSubscriptionPackage(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during package deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Package ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM subscription_packages WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Package not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM subscription_packages WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Subscription package deleted successfully' AS message;
END$$


-- List All Subscription Packages
CREATE PROCEDURE ListSubscriptionPackages()
BEGIN
    DECLARE total_packages INT;

    SELECT COUNT(*) INTO total_packages FROM subscription_packages;

    IF total_packages = 0 THEN
        SELECT 'error' AS status, 'No packages found' AS message;
    ELSE
        SELECT 
            id, 
            package_name, 
            price, 
            discount,
            is_active, 
            created_at, 
            updated_at
        FROM subscription_packages
        ORDER BY id DESC;
    END IF;
END$$

DELIMITER ;
