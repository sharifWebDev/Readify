DELIMITER $$

-- Create Book
CREATE PROCEDURE CreateBook(
    IN p_title VARCHAR(255),
    IN p_author_id INT,
    IN p_isbn VARCHAR(20),
    IN p_code VARCHAR(20),
    IN p_category_id INT,
    IN p_quantity INT,
    IN p_available_quantity INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during book creation' AS message;
    END;

    IF TRIM(p_title) = '' THEN
        SELECT 'error' AS status, 'Title is required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_title) > 255 THEN
        SELECT 'error' AS status, 'Title exceeds maximum length' AS message;
        LEAVE proc;
    END IF;

    IF p_author_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM authors WHERE id = p_author_id) THEN
            SELECT 'error' AS status, 'Author not found' AS message;
            LEAVE proc;
        END IF;
    END IF;

    IF p_category_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM categories WHERE id = p_category_id) THEN
            SELECT 'error' AS status, 'Category not found' AS message;
            LEAVE proc;
        END IF;
    END IF;

    IF p_isbn IS NOT NULL AND EXISTS (SELECT 1 FROM books WHERE isbn = p_isbn) THEN
        SELECT 'error' AS status, 'ISBN already exists' AS message;
        LEAVE proc;
    END IF;

    IF p_code IS NOT NULL AND EXISTS (SELECT 1 FROM books WHERE code = p_code) THEN
        SELECT 'error' AS status, 'Code already exists' AS message;
        LEAVE proc;
    END IF;

    IF p_quantity < 0 OR p_available_quantity < 0 THEN
        SELECT 'error' AS status, 'Quantity values cannot be negative' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO books (title, author_id, isbn, code, category_id, quantity, available_quantity, created_at, updated_at)
    VALUES (p_title, p_author_id, p_isbn, p_code, p_category_id, p_quantity, p_available_quantity, NOW(), NOW());

    COMMIT;

    SELECT 'success' AS status, 'Book created successfully' AS message;
END$$


-- Update Book
CREATE PROCEDURE UpdateBook(
    IN p_id INT,
    IN p_title VARCHAR(255),
    IN p_author_id INT,
    IN p_isbn VARCHAR(20),
    IN p_code VARCHAR(20),
    IN p_category_id INT,
    IN p_quantity INT,
    IN p_available_quantity INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during book update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Book ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM books WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Book not found' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_title) = '' THEN
        SELECT 'error' AS status, 'Title is required' AS message;
        LEAVE proc;
    END IF;

    IF CHAR_LENGTH(p_title) > 255 THEN
        SELECT 'error' AS status, 'Title exceeds maximum length' AS message;
        LEAVE proc;
    END IF;

    IF p_author_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM authors WHERE id = p_author_id) THEN
            SELECT 'error' AS status, 'Author not found' AS message;
            LEAVE proc;
        END IF;
    END IF;

    IF p_category_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM categories WHERE id = p_category_id) THEN
            SELECT 'error' AS status, 'Category not found' AS message;
            LEAVE proc;
        END IF;
    END IF;

    IF p_isbn IS NOT NULL AND EXISTS (SELECT 1 FROM books WHERE isbn = p_isbn AND id != p_id) THEN
        SELECT 'error' AS status, 'ISBN already exists for another book' AS message;
        LEAVE proc;
    END IF;

    IF p_code IS NOT NULL AND EXISTS (SELECT 1 FROM books WHERE code = p_code AND id != p_id) THEN
        SELECT 'error' AS status, 'Code already exists for another book' AS message;
        LEAVE proc;
    END IF;

    IF p_quantity < 0 OR p_available_quantity < 0 THEN
        SELECT 'error' AS status, 'Quantity values cannot be negative' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE books
    SET 
        title = p_title,
        author_id = p_author_id,
        isbn = p_isbn,
        code = p_code,
        category_id = p_category_id,
        quantity = p_quantity,
        available_quantity = p_available_quantity,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Book updated successfully' AS message;
END$$


-- View Book (Single)
CREATE PROCEDURE ViewBook(
    IN p_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SELECT 'error' AS status, 'Something went wrong while fetching book' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Book ID' AS message;
    ELSE
        IF (SELECT COUNT(*) FROM books WHERE id = p_id) = 0 THEN
            SELECT 'error' AS status, 'No result found' AS message;
        ELSE
            SELECT 
                b.id, 
                b.title, 
                b.author_id, 
                a.name AS author_name,
                b.isbn, 
                b.code, 
                b.category_id,
                c.name AS category_name,
                b.quantity, 
                b.available_quantity, 
                b.created_at, 
                b.updated_at
            FROM 
                books b
                LEFT JOIN authors a ON b.author_id = a.id
                LEFT JOIN categories c ON b.category_id = c.id
            WHERE 
                b.id = p_id;
        END IF;
    END IF;
END$$


-- List Books (All)
CREATE PROCEDURE ListBooks()
BEGIN
    DECLARE total_books INT;

    SELECT COUNT(*) INTO total_books FROM books;

    IF total_books = 0 THEN
        SELECT 'error' AS status, 'No books found' AS message;
    ELSE
        SELECT 
            b.id, 
            b.title, 
            b.author_id, 
            a.name AS author_name,
            b.isbn, 
            b.code, 
            b.category_id,
            c.name AS category_name,
            b.quantity, 
            b.available_quantity, 
            b.created_at, 
            b.updated_at
        FROM 
            books b
            LEFT JOIN authors a ON b.author_id = a.id
            LEFT JOIN categories c ON b.category_id = c.id
        ORDER BY b.id DESC;
    END IF;
END$$


-- Delete Book
CREATE PROCEDURE DeleteBook(
    IN p_id INT
)
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during book deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Book ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM books WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Book not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM books WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Book deleted successfully' AS message;
END$$

DELIMITER ;
