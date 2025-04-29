-- Full Authors Table Stored Procedures (Advanced Version)

DELIMITER $$

-- Create Author
CREATE PROCEDURE CreateAuthor(
    IN p_name VARCHAR(50),
    IN p_slug VARCHAR(60),
    IN p_is_active BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during author creation' AS message;
    END;

    IF TRIM(p_name) = '' OR TRIM(p_slug) = '' THEN
        SELECT 'error' AS status, 'Name and Slug are required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_name) > 50 OR CHAR_LENGTH(p_slug) > 60 THEN
        SELECT 'error' AS status, 'One or more fields exceed allowed length' AS message;
        LEAVE proc;
    END IF;

    IF EXISTS (SELECT 1 FROM authors WHERE slug = p_slug) THEN
        SELECT 'error' AS status, 'Slug already exists' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO authors (name, slug, is_active, created_at, updated_at)
    VALUES (p_name, p_slug, p_is_active, NOW(), NOW());

    COMMIT;

    SELECT 'success' AS status, 'Author created successfully' AS message;
END$$


-- Update Author
CREATE PROCEDURE UpdateAuthor(
    IN p_id INT,
    IN p_name VARCHAR(50),
    IN p_slug VARCHAR(60),
    IN p_is_active BOOLEAN
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during author update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Author ID' AS message;
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

    IF NOT EXISTS (SELECT 1 FROM authors WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Author not found' AS message;
        LEAVE proc;
    END IF;

    IF EXISTS (SELECT 1 FROM authors WHERE slug = p_slug AND id != p_id) THEN
        SELECT 'error' AS status, 'Slug already exists for another author' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE authors
    SET 
        name = p_name,
        slug = p_slug,
        is_active = p_is_active,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Author updated successfully' AS message;
END$$


-- View Author (Single)
CREATE PROCEDURE ViewAuthor(
    IN p_author_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SELECT 'error' AS status, 'Something went wrong while fetching author' AS message;
    END;

    IF p_author_id IS NULL OR p_author_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Author ID' AS message;
    ELSE
        IF (SELECT COUNT(*) FROM authors WHERE id = p_author_id) = 0 THEN
            SELECT 'error' AS status, 'No result found' AS message;
        ELSE
            SELECT 
                id, name, slug, is_active, created_at, updated_at
            FROM 
                authors
            WHERE 
                id = p_author_id;
        END IF;
    END IF;
END$$


-- List Authors (All)
CREATE PROCEDURE ListAuthors()
BEGIN
    DECLARE total_authors INT;

    SELECT COUNT(*) INTO total_authors FROM authors;

    IF total_authors = 0 THEN
        SELECT 'error' AS status, 'No authors found' AS message;
    ELSE
        SELECT 
            id, name, slug, is_active, created_at, updated_at
        FROM 
            authors
        ORDER BY id DESC;
    END IF;
END$$


-- Delete Author
CREATE PROCEDURE DeleteAuthor(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during author deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Author ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM authors WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Author not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM authors WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Author deleted successfully' AS message;
END$$

DELIMITER ;
