-- Full Categories Table Stored Procedures (Advanced Version)

DELIMITER $$

-- Create Category
CREATE PROCEDURE CreateCategory(
    IN p_name VARCHAR(50),
    IN p_slug VARCHAR(60),
    IN p_parent_category_id INT,
    IN p_is_active BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during category creation' AS message;
    END;

    IF TRIM(p_name) = '' OR TRIM(p_slug) = '' THEN
        SELECT 'error' AS status, 'Name and Slug are required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_name) > 50 OR CHAR_LENGTH(p_slug) > 60 THEN
        SELECT 'error' AS status, 'One or more fields exceed allowed length' AS message;
        LEAVE proc;
    END IF;

    IF EXISTS (SELECT 1 FROM categories WHERE slug = p_slug) THEN
        SELECT 'error' AS status, 'Slug already exists' AS message;
        LEAVE proc;
    END IF;

    IF p_parent_category_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM categories WHERE id = p_parent_category_id) THEN
            SELECT 'error' AS status, 'Parent Category does not exist' AS message;
            LEAVE proc;
        END IF;
    END IF;

    START TRANSACTION;

    INSERT INTO categories (name, slug, parent_category_id, is_active, created_at, updated_at)
    VALUES (p_name, p_slug, p_parent_category_id, p_is_active, NOW(), NOW());

    COMMIT;

    SELECT 'success' AS status, 'Category created successfully' AS message;
END$$


-- Update Category
CREATE PROCEDURE UpdateCategory(
    IN p_id INT,
    IN p_name VARCHAR(50),
    IN p_slug VARCHAR(60),
    IN p_parent_category_id INT,
    IN p_is_active BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during category update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Category ID' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_name) = '' OR TRIM(p_slug) = '' THEN
        SELECT 'error' AS status, 'Name and Slug are required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_name) > 50 OR CHAR_LENGTH(p_slug) > 60 THEN
        SELECT 'error' AS status, 'One or more fields exceed allowed length' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM categories WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Category not found' AS message;
        LEAVE proc;
    END IF;

    IF EXISTS (SELECT 1 FROM categories WHERE slug = p_slug AND id != p_id) THEN
        SELECT 'error' AS status, 'Slug already exists for another category' AS message;
        LEAVE proc;
    END IF;

    IF p_parent_category_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM categories WHERE id = p_parent_category_id) THEN
            SELECT 'error' AS status, 'Parent Category does not exist' AS message;
            LEAVE proc;
        END IF;
    END IF;

    START TRANSACTION;

    UPDATE categories
    SET 
        name = p_name,
        slug = p_slug,
        parent_category_id = p_parent_category_id,
        is_active = p_is_active,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Category updated successfully' AS message;
END$$


-- View Category (Single)
CREATE PROCEDURE ViewCategory(
    IN p_category_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SELECT 'error' AS status, 'Something went wrong while fetching category' AS message;
    END;

    IF p_category_id IS NULL OR p_category_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Category ID' AS message;
    ELSE
        IF (SELECT COUNT(*) FROM categories WHERE id = p_category_id) = 0 THEN
            SELECT 'error' AS status, 'No result found' AS message;
        ELSE
            SELECT 
                id, name, slug, parent_category_id, is_active, created_at, updated_at
            FROM 
                categories
            WHERE 
                id = p_category_id;
        END IF;
    END IF;
END$$


-- List Categories (All)
CREATE PROCEDURE ListCategories()
BEGIN
    DECLARE total_categories INT;

    SELECT COUNT(*) INTO total_categories FROM categories;

    IF total_categories = 0 THEN
        SELECT 'error' AS status, 'No categories found' AS message;
    ELSE
        SELECT 
            id, name, slug, parent_category_id, is_active, created_at, updated_at
        FROM 
            categories
        ORDER BY id DESC;
    END IF;
END$$


-- Delete Category
CREATE PROCEDURE DeleteCategory(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during category deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Category ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM categories WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Category not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM categories WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Category deleted successfully' AS message;
END$$

DELIMITER ;
