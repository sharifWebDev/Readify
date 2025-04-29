DELIMITER $$

-- Create Subscription Package Detail
CREATE PROCEDURE CreateSubscriptionPackageDetail(
    IN p_package_id INT,
    IN p_feature VARCHAR(100),
    IN p_is_active BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during feature creation' AS message;
    END;

    IF p_package_id IS NULL OR p_package_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Package ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM subscription_packages WHERE id = p_package_id) THEN
        SELECT 'error' AS status, 'Subscription package not found' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_feature) = '' THEN
        SELECT 'error' AS status, 'Feature description is required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_feature) > 100 THEN
        SELECT 'error' AS status, 'Feature description exceeds maximum length' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO subscription_package_details (package_id, feature, is_active, created_at, updated_at)
    VALUES (p_package_id, p_feature, p_is_active, NOW(), NOW());

    COMMIT;

    SELECT 'success' AS status, 'Package feature created successfully' AS message;
END$$


-- Update Subscription Package Detail
CREATE PROCEDURE UpdateSubscriptionPackageDetail(
    IN p_id INT,
    IN p_package_id INT,
    IN p_feature VARCHAR(100),
    IN p_is_active BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during feature update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Feature ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM subscription_package_details WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Feature not found' AS message;
        LEAVE proc;
    END IF;

    IF p_package_id IS NULL OR p_package_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Package ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM subscription_packages WHERE id = p_package_id) THEN
        SELECT 'error' AS status, 'Subscription package not found' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_feature) = '' THEN
        SELECT 'error' AS status, 'Feature description is required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_feature) > 100 THEN
        SELECT 'error' AS status, 'Feature description exceeds maximum length' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE subscription_package_details
    SET 
        package_id = p_package_id,
        feature = p_feature,
        is_active = p_is_active,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Package feature updated successfully' AS message;
END$$


-- Delete Subscription Package Detail
CREATE PROCEDURE DeleteSubscriptionPackageDetail(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during feature deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Feature ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM subscription_package_details WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Feature not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM subscription_package_details WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Package feature deleted successfully' AS message;
END$$


-- List All Features by Package ID
CREATE PROCEDURE ListPackageFeatures(
    IN p_package_id INT
)
BEGIN
    DECLARE feature_count INT;

    IF p_package_id IS NULL OR p_package_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Package ID' AS message;
    ELSE
        SELECT COUNT(*) INTO feature_count FROM subscription_package_details WHERE package_id = p_package_id;

        IF feature_count = 0 THEN
            SELECT 'error' AS status, 'No features found for this package' AS message;
        ELSE
            SELECT 
                id, 
                package_id, 
                feature, 
                is_active, 
                created_at, 
                updated_at
            FROM subscription_package_details
            WHERE package_id = p_package_id
            ORDER BY id DESC;
        END IF;
    END IF;
END$$

DELIMITER ;
