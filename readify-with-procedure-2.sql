-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 21, 2025 at 04:43 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `readify`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateAdmin` (IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), IN `p_email` VARCHAR(100), IN `p_verified_at` TIMESTAMP)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateAuthor` (IN `p_name` VARCHAR(50), IN `p_slug` VARCHAR(60), IN `p_is_active` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateBook` (IN `p_title` VARCHAR(255), IN `p_author_id` INT, IN `p_isbn` VARCHAR(20), IN `p_code` VARCHAR(20), IN `p_category_id` INT, IN `p_quantity` INT, IN `p_available_quantity` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateCategory` (IN `p_name` VARCHAR(50), IN `p_slug` VARCHAR(60), IN `p_parent_category_id` INT, IN `p_is_active` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateCustomerSubscription` (IN `p_member_id` INT, IN `p_start_date` DATE, IN `p_end_date` DATE, IN `p_payment_status` VARCHAR(20), IN `p_payable_amount` DECIMAL(10,2), IN `p_payment_date` DATE)   proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during subscription creation' AS message;
    END;

    IF p_member_id IS NULL OR p_member_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Member ID' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_payment_status) = '' THEN
        SELECT 'error' AS status, 'Payment status is required' AS message;
        LEAVE proc;
    END IF;

    IF p_payable_amount < 0 THEN
        SELECT 'error' AS status, 'Payable amount must be non-negative' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    INSERT INTO customer_subscriptions (member_id, start_date, end_date, payment_status, payable_amount, payment_date, created_at, updated_at)
    VALUES (p_member_id, p_start_date, p_end_date, p_payment_status, p_payable_amount, p_payment_date, NOW(), NOW());

    COMMIT;

    SELECT 'success' AS status, 'Customer subscription created successfully' AS message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateLateFee` (IN `p_key_name` VARCHAR(50), IN `p_charge` DECIMAL(10,2), IN `p_is_active` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateLog` (IN `p_action` VARCHAR(255), IN `p_user_type` VARCHAR(20), IN `p_user_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateMember` (IN `p_first_name` VARCHAR(50), IN `p_last_name` VARCHAR(50), IN `p_email` VARCHAR(100), IN `p_password` VARCHAR(255), IN `p_phone` VARCHAR(15), IN `p_address` VARCHAR(255), IN `p_verified_at` TIMESTAMP)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreatePayment` (IN `p_subscription_id` INT, IN `p_transaction_id` VARCHAR(50), IN `p_payment_method` VARCHAR(20), IN `p_total_payable_amount` DECIMAL(10,2), IN `p_fine_amount` DECIMAL(10,2), IN `p_total_due_amount` DECIMAL(10,2), IN `p_paid_amount` DECIMAL(10,2), IN `p_total_paid_amount` DECIMAL(10,2), IN `p_payment_status` ENUM('success','failed'))   proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during payment creation' AS message;
    END;

    -- Validate input parameters
    IF p_subscription_id IS NULL OR p_subscription_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Subscription ID' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_transaction_id) = '' THEN
        SELECT 'error' AS status, 'Transaction ID is required' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_payment_method) = '' THEN
        SELECT 'error' AS status, 'Payment Method is required' AS message;
        LEAVE proc;
    END IF;

    IF p_total_payable_amount < 0 OR p_paid_amount < 0 THEN
        SELECT 'error' AS status, 'Amount must be non-negative' AS message;
        LEAVE proc;
    END IF;

    IF p_total_paid_amount < 0 THEN
        SELECT 'error' AS status, 'Total paid amount must be non-negative' AS message;
        LEAVE proc;
    END IF;

    -- Start Transaction
    START TRANSACTION;

    -- Insert Payment
    INSERT INTO payments (
        subscription_id, transaction_id, payment_method, 
        total_payable_amount, fine_amount, total_due_amount, 
        paid_amount, total_paid_amount, payment_status, created_at, updated_at
    )
    VALUES (
        p_subscription_id, p_transaction_id, p_payment_method, 
        p_total_payable_amount, p_fine_amount, p_total_due_amount, 
        p_paid_amount, p_total_paid_amount, p_payment_status, NOW(), NOW()
    );

    COMMIT;

    SELECT 'success' AS status, 'Payment created successfully' AS message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateSubscriptionPackage` (IN `p_package_name` VARCHAR(50), IN `p_price` DECIMAL(10,2), IN `p_discount` DECIMAL(10,2), IN `p_is_active` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateSubscriptionPackageDetail` (IN `p_package_id` INT, IN `p_feature` VARCHAR(100), IN `p_is_active` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateTransaction` (IN `p_transaction_id` VARCHAR(255), IN `p_member_id` INT, IN `p_book_id` INT, IN `p_issue_date` DATE, IN `p_due_date` DATE, IN `p_fine_amount` DECIMAL(10,2), IN `p_status` VARCHAR(20))   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteAdmin` (IN `p_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteAuthor` (IN `p_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteBook` (IN `p_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteCategory` (IN `p_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteCustomerSubscription` (IN `p_id` INT)   proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during subscription deletion' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Subscription ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM customer_subscriptions WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Subscription not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    DELETE FROM customer_subscriptions WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Customer subscription deleted successfully' AS message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteLateFee` (IN `p_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteLog` (IN `p_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteMember` (IN `p_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletePayment` (IN `p_id` INT)   proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during payment deletion' AS message;
    END;

    -- Validate Payment ID
    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Payment ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM payments WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Payment not found' AS message;
        LEAVE proc;
    END IF;

    -- Start Transaction
    START TRANSACTION;

    -- Delete Payment
    DELETE FROM payments WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Payment deleted successfully' AS message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteSubscriptionPackage` (IN `p_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteSubscriptionPackageDetail` (IN `p_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteTransaction` (IN `p_id` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerLateFees` ()   BEGIN
    SELECT 
        m.first_name AS `Member Name`,
        t.transaction_id AS `Transaction ID`,
        b.title AS `Book Name`,
        t.issue_date AS `Issue Date`,
        t.due_date AS `Due Date`,
        t.return_date AS `Return Date`,
        DATEDIFF(t.return_date, t.due_date) AS `Total Due Days`,
        (DATEDIFF(t.return_date, t.due_date) * lf.charge) AS `Total Fine Amount`
    FROM 
        transactions t
    INNER JOIN members m ON t.member_id = m.id
    INNER JOIN books b ON t.book_id = b.id
    INNER JOIN late_fees lf ON lf.key_name = 'daily_late_fee' AND lf.is_active = 1
    WHERE 
        t.return_date IS NOT NULL
        AND t.return_date > t.due_date;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_late_fee_report` ()   BEGIN
    SELECT 
        t.id AS id,
        m.first_name AS member_name,
        t.transaction_id,
        b.title AS book_name,
        t.issue_date,
        t.due_date,
        t.return_date,
        DATEDIFF(t.return_date, t.due_date) AS total_due_days,
        (DATEDIFF(t.return_date, t.due_date) * lf.charge) AS total_fine_amount
    FROM 
        transactions t
    INNER JOIN members m ON t.member_id = m.id
    INNER JOIN books b ON t.book_id = b.id
    INNER JOIN late_fees lf ON lf.key_name = 'daily_late_fee' AND lf.is_active = 1
    WHERE 
        t.return_date IS NOT NULL
        AND t.return_date > t.due_date;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListAdmins` ()   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListAuthors` ()   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListBooks` ()   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListCategories` ()   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListCustomerSubscriptions` ()   BEGIN
    DECLARE total_subscriptions INT;

    SELECT COUNT(*) INTO total_subscriptions FROM customer_subscriptions;

    IF total_subscriptions = 0 THEN
        SELECT 'error' AS status, 'No subscriptions found' AS message;
    ELSE
        SELECT 
            id, 
            member_id, 
            start_date, 
            end_date, 
            payment_status, 
            payable_amount, 
            payment_date, 
            created_at, 
            updated_at
        FROM customer_subscriptions
        ORDER BY id DESC;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListLateFees` ()   BEGIN
    IF (SELECT COUNT(*) FROM late_fees) = 0 THEN
        SELECT 'error' AS status, 'No late fee records found' AS message;
    ELSE
        SELECT 
            id, key_name, charge, is_active, created_at, updated_at
        FROM late_fees
        ORDER BY id DESC;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListLogs` ()   BEGIN
    IF (SELECT COUNT(*) FROM logs) = 0 THEN
        SELECT 'error' AS status, 'No logs found' AS message;
    ELSE
        SELECT * FROM logs ORDER BY timestamp DESC;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListMembers` ()   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListPackageFeatures` (IN `p_package_id` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListPayments` ()   BEGIN
    DECLARE total_payments INT;

    -- Count Payments
    SELECT COUNT(*) INTO total_payments FROM payments;

    -- Check if no payments found
    IF total_payments = 0 THEN
        SELECT 'error' AS status, 'No payments found' AS message;
    ELSE
        SELECT 
            id, 
            subscription_id, 
            transaction_id, 
            payment_method, 
            total_payable_amount, 
            fine_amount, 
            total_due_amount, 
            paid_amount, 
            total_paid_amount, 
            payment_status, 
            payment_date, 
            created_at, 
            updated_at
        FROM payments
        ORDER BY id DESC;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListSubscriptionPackages` ()   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListTransactions` ()   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_subscription_revenue_report` ()   BEGIN
    SELECT 
        m.first_name AS member_name,
        COUNT(cs.id) AS total_subscriptions,
        COALESCE(SUM(p.paid_amount), 0) AS total_paid_amount,
        COALESCE(SUM(p.fine_amount), 0) AS total_fine_amount,
        COALESCE(SUM(p.paid_amount + p.fine_amount), 0) AS total_revenue,
        MIN(cs.start_date) AS first_subscription_date,
        MAX(cs.end_date) AS last_subscription_date
    FROM customer_subscriptions cs
    JOIN members m ON cs.member_id = m.id
    LEFT JOIN payments p ON p.subscription_id = cs.id
    GROUP BY cs.member_id
    ORDER BY total_revenue DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateAdmin` (IN `p_id` INT, IN `p_username` VARCHAR(50), IN `p_email` VARCHAR(100))   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateAuthor` (IN `p_id` INT, IN `p_name` VARCHAR(50), IN `p_slug` VARCHAR(60), IN `p_is_active` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBook` (IN `p_id` INT, IN `p_title` VARCHAR(255), IN `p_author_id` INT, IN `p_isbn` VARCHAR(20), IN `p_code` VARCHAR(20), IN `p_category_id` INT, IN `p_quantity` INT, IN `p_available_quantity` INT)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateCategory` (IN `p_id` INT, IN `p_name` VARCHAR(50), IN `p_slug` VARCHAR(60), IN `p_parent_category_id` INT, IN `p_is_active` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateCustomerSubscription` (IN `p_id` INT, IN `p_member_id` INT, IN `p_start_date` DATE, IN `p_end_date` DATE, IN `p_payment_status` VARCHAR(20), IN `p_payable_amount` DECIMAL(10,2), IN `p_payment_date` DATE)   proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during subscription update' AS message;
    END;

    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Subscription ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM customer_subscriptions WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Subscription not found' AS message;
        LEAVE proc;
    END IF;

    START TRANSACTION;

    UPDATE customer_subscriptions
    SET 
        member_id = p_member_id,
        start_date = p_start_date,
        end_date = p_end_date,
        payment_status = p_payment_status,
        payable_amount = p_payable_amount,
        payment_date = p_payment_date,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Customer subscription updated successfully' AS message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateLateFee` (IN `p_id` INT, IN `p_key_name` VARCHAR(50), IN `p_charge` DECIMAL(10,2), IN `p_is_active` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateMember` (IN `p_id` INT, IN `p_first_name` VARCHAR(50), IN `p_last_name` VARCHAR(50), IN `p_phone` VARCHAR(15), IN `p_address` VARCHAR(255))   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePayment` (IN `p_id` INT, IN `p_subscription_id` INT, IN `p_transaction_id` VARCHAR(50), IN `p_payment_method` VARCHAR(20), IN `p_total_payable_amount` DECIMAL(10,2), IN `p_fine_amount` DECIMAL(10,2), IN `p_total_due_amount` DECIMAL(10,2), IN `p_paid_amount` DECIMAL(10,2), IN `p_total_paid_amount` DECIMAL(10,2), IN `p_payment_status` ENUM('success','failed'))   proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status, 'Something went wrong during payment update' AS message;
    END;

    -- Validate input parameters
    IF p_id IS NULL OR p_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Payment ID' AS message;
        LEAVE proc;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM payments WHERE id = p_id) THEN
        SELECT 'error' AS status, 'Payment not found' AS message;
        LEAVE proc;
    END IF;

    IF p_subscription_id IS NULL OR p_subscription_id <= 0 THEN
        SELECT 'error' AS status, 'Invalid Subscription ID' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_transaction_id) = '' THEN
        SELECT 'error' AS status, 'Transaction ID is required' AS message;
        LEAVE proc;
    END IF;

    IF TRIM(p_payment_method) = '' THEN
        SELECT 'error' AS status, 'Payment Method is required' AS message;
        LEAVE proc;
    END IF;

    IF p_total_payable_amount < 0 OR p_paid_amount < 0 THEN
        SELECT 'error' AS status, 'Amount must be non-negative' AS message;
        LEAVE proc;
    END IF;

    IF p_total_paid_amount < 0 THEN
        SELECT 'error' AS status, 'Total paid amount must be non-negative' AS message;
        LEAVE proc;
    END IF;

    -- Start Transaction
    START TRANSACTION;

    -- Update Payment
    UPDATE payments
    SET 
        subscription_id = p_subscription_id,
        transaction_id = p_transaction_id,
        payment_method = p_payment_method,
        total_payable_amount = p_total_payable_amount,
        fine_amount = p_fine_amount,
        total_due_amount = p_total_due_amount,
        paid_amount = p_paid_amount,
        total_paid_amount = p_total_paid_amount,
        payment_status = p_payment_status,
        updated_at = NOW()
    WHERE id = p_id;

    COMMIT;

    SELECT 'success' AS status, 'Payment updated successfully' AS message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateSubscriptionPackage` (IN `p_id` INT, IN `p_package_name` VARCHAR(50), IN `p_price` DECIMAL(10,2), IN `p_discount` DECIMAL(10,2), IN `p_is_active` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateSubscriptionPackageDetail` (IN `p_id` INT, IN `p_package_id` INT, IN `p_feature` VARCHAR(100), IN `p_is_active` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateTransaction` (IN `p_id` INT, IN `p_transaction_id` VARCHAR(255), IN `p_member_id` INT, IN `p_book_id` INT, IN `p_issue_date` DATE, IN `p_due_date` DATE, IN `p_fine_amount` DECIMAL(10,2), IN `p_status` VARCHAR(20), IN `p_is_approved` BOOLEAN)   proc: BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewAdmin` (IN `p_admin_id` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewAuthor` (IN `p_author_id` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewBook` (IN `p_id` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewCategory` (IN `p_category_id` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewLateFee` (IN `p_id` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewLog` (IN `p_id` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewMember` (IN `p_member_id` INT)   BEGIN
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

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `password`, `email`, `verified_at`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$2y$10$OQKFcsLNoGUDCDKNCNEtAeZtP1GQSW5XHOegsUfyET7AL6mui36jq', 'admin@readify.com', NULL, '2025-04-26 17:24:36', '2025-04-26 17:24:36'),
(2, 'admin@gmail.com', '$2y$10$b/lWSpNoAt2GyRGHFs5Zn.vuJt5wezAThap4M/LRBEuqr3VjzCvPi', 'admin@gmail.com', NULL, '2025-04-27 14:07:08', '2025-04-27 14:07:08'),
(3, 'jekepami', '$2y$10$rWrHJ8YrqH/L62ifSvj0Ne6i.flfYMlm0yrsXUtvpOGaN6SZ0eK7W', 'mavytijufa@mailinator.com', NULL, '2025-04-27 15:02:44', '2025-04-27 15:02:44'),
(4, 'timyka', '$2y$10$h75tbjucw4Cob4ngsACjN.kuHbi8uqbMpOw4lOvd9PP6spY0lxeja', 'cuvopop@mailinator.com', NULL, '2025-04-27 15:51:46', '2025-04-27 15:51:46'),
(5, 'bedosyh', '$2y$10$Ea5HBd4haUS5/1yliAYuP.DX9oaZAHzpa8ndD5.PJBNklsCINVjw6', 'wugipas@mailinator.com', NULL, '2025-04-27 16:10:34', '2025-04-27 16:10:34'),
(6, 'qemys', '$2y$10$qc2mFSaE1w8.cAJGPohLX.ZnqCgrAJZ9t7wsBIxCig21tWwop8Ixe', 'hudik@mailinator.com', NULL, '2025-04-27 16:12:21', '2025-04-27 16:12:21'),
(7, 'gylaz', '$2y$10$pnpMFF2cpkPQXCvvVMnRyePBqHtDYo8cFHqTLKQXToYCRlrEub.Hu', 'tuqyduti@mailinator.com', NULL, '2025-04-27 16:13:23', '2025-04-27 16:13:23'),
(8, 'japuwyryfe', '$2y$10$6fhybYQqO1o3GmTamyJ5S.qtnXu9blQxysGJNvab384DlNJSqvrcW', 'xaciw@mailinator.com', NULL, '2025-04-27 16:22:13', '2025-04-27 16:22:13'),
(10, 'rodexulo', '$2y$10$iXL7p4Dju3klTzrbNZNHo.huy1s5QBH17gVDkHd31rZ.MBm2cs.RS', 'qozequzo@mailinator.com', NULL, '2025-05-21 01:09:38', '2025-05-21 01:09:38');

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE `authors` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `slug` varchar(60) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`id`, `name`, `slug`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'J.K. Rowling', 'jk-rowling', 1, '2025-04-26 17:24:36', '2025-04-26 17:24:36'),
(2, 'George R.R. Martin', 'george-rr-martin', 1, '2025-04-26 17:24:36', '2025-04-26 17:24:36');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `isbn` varchar(20) DEFAULT NULL,
  `code` varchar(20) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `available_quantity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `title`, `author_id`, `isbn`, `code`, `category_id`, `quantity`, `available_quantity`, `created_at`, `updated_at`) VALUES
(1, 'Harry Potter', 1, '9780439136365', 'HP001', 1, 10, 10, '2025-04-26 17:24:36', '2025-04-26 17:24:36'),
(2, 'Game of Thrones', 2, '9780553103540', 'GOT001', 1, 5, 5, '2025-04-26 17:24:36', '2025-04-26 17:24:36'),
(3, 'Dolores do ex volupt', 1, 'Eum aliquam quia ape', 'Vero sunt do unde om', 2, 442, 0, '2025-05-21 00:51:27', '2025-05-21 00:51:27'),
(4, 'Nostrud laborum In ', 1, 'Doloremque magnam qu', 'Nulla maiores sint a', 2, 79, 0, '2025-05-21 00:53:17', '2025-05-21 00:53:17'),
(6, 'Excepteur minus recu', 1, 'Temporibus ullamco v', 'Non corporis laboris', 2, 545, 0, '2025-05-21 00:55:14', '2025-05-21 00:55:14');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `slug` varchar(60) NOT NULL,
  `parent_category_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `parent_category_id`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Fantasy', 'fantasy', NULL, 1, '2025-04-26 17:24:36', '2025-04-26 17:24:36'),
(2, 'Thriller', 'thriller', NULL, 1, '2025-04-26 17:24:36', '2025-04-26 17:24:36');

-- --------------------------------------------------------

--
-- Table structure for table `customer_subscriptions`
--

CREATE TABLE `customer_subscriptions` (
  `id` int(11) NOT NULL,
  `member_id` int(11) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `payment_status` varchar(20) NOT NULL,
  `payable_amount` decimal(10,2) NOT NULL,
  `payment_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customer_subscriptions`
--

INSERT INTO `customer_subscriptions` (`id`, `member_id`, `start_date`, `end_date`, `payment_status`, `payable_amount`, `payment_date`, `created_at`, `updated_at`) VALUES
(2, 2, '2025-04-22', '2029-04-18', '1', 2000.00, '2025-04-23', '2025-04-22 15:11:17', '2025-04-17 15:12:02'),
(3, 3, '2025-05-07', '2026-05-23', '1', 300.00, '2025-05-07', '2025-05-21 01:48:38', '2025-05-05 01:53:07');

-- --------------------------------------------------------

--
-- Table structure for table `late_fees`
--

CREATE TABLE `late_fees` (
  `id` int(11) NOT NULL,
  `key_name` varchar(50) NOT NULL,
  `charge` decimal(10,2) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `late_fees`
--

INSERT INTO `late_fees` (`id`, `key_name`, `charge`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'daily_late_fee', 1.50, 1, '2025-04-26 17:24:37', '2025-04-26 17:24:37');

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `user_type` varchar(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `action`, `user_type`, `user_id`, `timestamp`) VALUES
(1, 'Admin login', 'admin', 1, '2025-04-26 17:24:37');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`id`, `first_name`, `last_name`, `email`, `password`, `phone`, `address`, `verified_at`, `created_at`, `updated_at`) VALUES
(2, 'Sumon', 'Mia', 'qwer@gmail.com', 'qwfgfdsa', '23455432', 'asd', '0000-00-00 00:00:00', '2025-04-28 17:59:00', '2025-05-05 01:12:19'),
(3, 'Abdul ', 'Kader', 'abk@gmail.com', '2121212', '01978786767', 'dhaka', '2025-05-05 01:12:24', '2025-05-08 01:12:24', '2025-05-05 01:13:06'),
(4, 'Karleigh', 'Blair', 'pinozeh@mailinator.com', '$2y$10$GNa9EsfQbX/aVoeIRLmKgOnbaC53t4iemfJaw1YSgjUYpBSnoKRBe', '+1 (492) 945-98', 'Sed dignissimos aut ', '1998-10-10 04:31:00', '2025-05-21 02:32:31', '2025-05-21 02:32:31'),
(5, 'Whilemina', 'Montgomery', 'katax@mailinator.com', '$2y$10$7FXGgiE0wpKlnNkILWwNuOTkN7KRFZoXVmihChr7aGl7S74fiaOcG', '+1 (344) 148-71', 'Commodi laboris quae', '2018-01-15 06:00:00', '2025-05-21 02:32:55', '2025-05-21 02:32:55');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `subscription_id` int(11) DEFAULT NULL,
  `transaction_id` varchar(50) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `total_payable_amount` decimal(10,2) NOT NULL,
  `fine_amount` decimal(10,2) DEFAULT 0.00,
  `total_due_amount` decimal(10,2) DEFAULT 0.00,
  `paid_amount` decimal(10,2) NOT NULL,
  `total_paid_amount` decimal(10,2) NOT NULL,
  `payment_status` varchar(50) NOT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `subscription_id`, `transaction_id`, `payment_method`, `total_payable_amount`, `fine_amount`, `total_due_amount`, `paid_amount`, `total_paid_amount`, `payment_status`, `payment_date`, `created_at`, `updated_at`) VALUES
(2, 2, 'RE-2025-00004', 'Cash', 2000.00, 0.00, 100.00, 1900.00, 1900.00, '2', '2025-04-22 15:12:16', '2025-04-22 15:12:16', '2025-04-29 15:13:38'),
(3, 3, 'RE-2025-00005', 'Cash', 200.00, 0.00, 0.00, 200.00, 200.00, '1', '2025-05-12 01:50:48', '2025-05-05 01:50:48', '2025-05-05 01:51:35');

-- --------------------------------------------------------

--
-- Table structure for table `subscription_packages`
--

CREATE TABLE `subscription_packages` (
  `id` int(11) NOT NULL,
  `package_name` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) DEFAULT 0.00,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscription_packages`
--

INSERT INTO `subscription_packages` (`id`, `package_name`, `price`, `discount`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Monthly', 9.99, 1.00, 1, '2025-04-26 17:24:37', '2025-04-26 17:24:37'),
(2, 'Yearly', 99.99, 10.00, 1, '2025-04-26 17:24:37', '2025-04-26 17:24:37');

-- --------------------------------------------------------

--
-- Table structure for table `subscription_package_details`
--

CREATE TABLE `subscription_package_details` (
  `id` int(11) NOT NULL,
  `package_id` int(11) DEFAULT NULL,
  `feature` varchar(100) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscription_package_details`
--

INSERT INTO `subscription_package_details` (`id`, `package_id`, `feature`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'Borrow 2 Books', 1, '2025-04-26 17:24:37', '2025-04-26 17:24:37'),
(2, 2, 'Borrow 10 Books', 1, '2025-04-26 17:24:37', '2025-04-26 17:24:37');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `member_id` int(11) DEFAULT NULL,
  `book_id` int(11) DEFAULT NULL,
  `issue_date` date NOT NULL,
  `due_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `fine_amount` decimal(10,2) DEFAULT 0.00,
  `status` varchar(20) NOT NULL,
  `is_approved` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `transaction_id`, `member_id`, `book_id`, `issue_date`, `due_date`, `return_date`, `fine_amount`, `status`, `is_approved`, `created_at`, `updated_at`) VALUES
(2, 'RE-2025-001234', 2, 1, '2025-04-22', '2025-04-27', '2025-04-30', 3.00, '1', 1, '2025-04-22 15:13:55', '2025-05-05 01:15:03'),
(3, 'RE-2025-001235', 3, 2, '2025-05-01', '2025-05-08', '2025-05-15', 0.00, '1', 1, '2025-05-15 01:13:31', '2025-05-05 01:14:34');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `isbn` (`isbn`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `author_id` (`author_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `parent_category_id` (`parent_category_id`);

--
-- Indexes for table `customer_subscriptions`
--
ALTER TABLE `customer_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `late_fees`
--
ALTER TABLE `late_fees`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subscription_id` (`subscription_id`);

--
-- Indexes for table `subscription_packages`
--
ALTER TABLE `subscription_packages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subscription_package_details`
--
ALTER TABLE `subscription_package_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `package_id` (`package_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_id` (`transaction_id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `book_id` (`book_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `authors`
--
ALTER TABLE `authors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `customer_subscriptions`
--
ALTER TABLE `customer_subscriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `late_fees`
--
ALTER TABLE `late_fees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `subscription_packages`
--
ALTER TABLE `subscription_packages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `subscription_package_details`
--
ALTER TABLE `subscription_package_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `books_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `customer_subscriptions`
--
ALTER TABLE `customer_subscriptions`
  ADD CONSTRAINT `customer_subscriptions_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`subscription_id`) REFERENCES `customer_subscriptions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subscription_package_details`
--
ALTER TABLE `subscription_package_details`
  ADD CONSTRAINT `subscription_package_details_ibfk_1` FOREIGN KEY (`package_id`) REFERENCES `subscription_packages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
