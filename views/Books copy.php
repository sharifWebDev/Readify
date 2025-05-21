<?php
// Database connection and functions
require_once './../config/database.php';

class Books {
    private $db;
    
    public function __construct() {
        $this->db = new Database();
    }
    
    public function getAllBooks() {
        try {
            $stmt = $this->db->connect()->prepare("CALL ListBooks()");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            return ['error' => $e->getMessage()];
        }
    }
  
    public function getBookById($id) {
        try {
            $conn = $this->db->connect();
            $stmt = $conn->prepare("CALL GetBookById(?)");
            $stmt->execute([$id]);
            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getBookById: " . $e->getMessage());
            return null;
        }
    }
    
    public function addBook($data) {
        try {
            $conn = $this->db->connect();
            $stmt = $conn->prepare("INSERT INTO books (title, author_id, isbn, code, category_id, quantity) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([
                $data['title'],
                $data['author_id'],
                $data['isbn'],
                $data['code'],
                $data['category_id'],
                $data['quantity']
            ]);
            return true;
        } catch (PDOException $e) {
            error_log("Database error in addBook: " . $e->getMessage());
            return false;
        }
    }

    
    public function updateBook($id, $data) {
        try {
            $conn = $this->db->connect();
            $stmt = $conn->prepare("CALL UpdateBook(?, ?, ?, ?, ?, ?, ?)");
            $stmt->execute([
                $id,
                $data['title'],
                $data['author_id'],
                $data['isbn'],
                $data['code'],
                $data['category_id'],
                $data['quantity']
            ]);
            return true;
        } catch (PDOException $e) {
            error_log("Database error in updateBook: " . $e->getMessage());
            return false;
        }
    }
    
    public function deleteBook($id) {
        try {
            $conn = $this->db->connect();
            $stmt = $conn->prepare("CALL DeleteBook(?)");
            $stmt->execute([$id]);
            return true;
        } catch (PDOException $e) {
            error_log("Database error in deleteBook: " . $e->getMessage());
            return false;
        }
    }
    
    public function getAuthors() {
        try {
            $conn = $this->db->connect();
            $stmt = $conn->prepare("CALL ListAuthors()");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getAuthors: " . $e->getMessage());
            return [];
        }
    }
    
    public function getCategories() {
        try {
            $conn = $this->db->connect();
            $stmt = $conn->prepare("CALL ListCategories()");
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Database error in getCategories: " . $e->getMessage());
            return [];
        }
    }
} 

// Initialize Book class
$book = new Books();
$books = $book->getAllBooks();
$authors = $book->getAuthors();
$categories = $book->getCategories();

// Handle form submissions
$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['add_book'])) {
        // Add new book
        $data = [
            'title' => $_POST['title'],
            'author_id' => $_POST['author_id'],
            'isbn' => $_POST['isbn'],
            'code' => $_POST['code'],
            'category_id' => $_POST['category_id'],
            'quantity' => $_POST['quantity']
        ];
        
        if ($book->addBook($data)) {
            $success = 'Book added successfully!';
            header("Refresh:1");
        } else {
            $error = 'Failed to add book.';
        }
    } elseif (isset($_POST['edit_book'])) {
        // Update book
        $id = $_POST['id'];
        $data = [
            'title' => $_POST['title'],
            'author_id' => $_POST['author_id'],
            'isbn' => $_POST['isbn'],
            'code' => $_POST['code'],
            'category_id' => $_POST['category_id'],
            'quantity' => $_POST['quantity']
        ];
        
        if ($book->updateBook($id, $data)) {
            $success = 'Book updated successfully!';
            header("Refresh:1"); // Refresh to show updated data
        } else {
            $error = 'Failed to update book.';
        }
    }
}

if (isset($_GET['delete_id'])) {
    // Delete book
    $id = $_GET['delete_id'];
    if ($book->deleteBook($id)) {
        $success = 'Book deleted successfully!';
        header("Refresh:1"); // Redirect to avoid resubmission
    } else {
        $error = 'Failed to delete book.';
    }
}

// Get book data for edit modal
$editBook = null;
if (isset($_GET['edit_id'])) {
    $editBook = $book->getBookById($_GET['edit_id']);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <?php require_once 'layouts/page-header.php'; ?>
    <title>Book Management System</title>
</head>
<body>
    <?php require_once 'layouts/navbar.php'; ?>

    <div class="container-fluid mt-4">
        <div class="row mt-4">
            <?php require_once 'layouts/sidebar.php'; ?>

            <div class="col-md-9">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="mb-0">Books List</h6>
                            <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addBookModal">
                                Add Book
                            </button>
                        </div>

                        <?php if (!empty($error)): ?>
                            <div class="alert alert-danger" role="alert">
                                <?= htmlspecialchars($error); ?>
                            </div>
                        <?php endif; ?>

                        <?php if (!empty($success)): ?>
                            <div class="alert alert-success" role="alert">
                                <?= htmlspecialchars($success); ?>
                            </div>
                        <?php endif; ?>

                        <?php if (!empty($books)) : ?>
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover align-middle">
                                    <thead class="table-success">
                                        <tr>
                                            <th>ID</th>
                                            <th>Title</th>
                                            <th>Author</th>
                                            <th>ISBN</th>
                                            <th>Code</th>
                                            <th>Category</th>
                                            <th>Quantity</th>
                                            <th>Available</th>
                                            <th>Created At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if (count($books) > 0) : ?>
                                            <?php foreach ($books as $bookItem) : ?>
                                                <tr>
                                                    <td><?= isset($bookItem['id']) ? htmlspecialchars($bookItem['id']) : '' ?></td>
                                                    <td><?= isset($bookItem['title']) ? htmlspecialchars($bookItem['title']) : '' ?></td>
                                                    <td><?= isset($bookItem['author_name']) ? htmlspecialchars($bookItem['author_name']) : '' ?></td>
                                                    <td><?= isset($bookItem['isbn']) ? htmlspecialchars($bookItem['isbn']) : '' ?></td>
                                                    <td><?= isset($bookItem['code']) ? htmlspecialchars($bookItem['code']) : '' ?></td>
                                                    <td><?= isset($bookItem['category_name']) ? htmlspecialchars($bookItem['category_name']) : '' ?></td>
                                                    <td><?= isset($bookItem['quantity']) ? htmlspecialchars($bookItem['quantity']) : '' ?></td>
                                                    <td><?= isset($bookItem['available_quantity']) ? htmlspecialchars($bookItem['available_quantity']) : '' ?></td>
                                                    <td>
                                                        <?= isset($bookItem['created_at']) && strtotime($bookItem['created_at']) ? 
                                                            htmlspecialchars(date('M d, Y', strtotime($bookItem['created_at']))) : '' ?>
                                                    </td>
                                                    <td>
                                                        <a href="?edit_id=<?= isset($bookItem['id']) ? htmlspecialchars($bookItem['id']) : '' ?>" class="btn btn-warning btn-sm my-1" data-bs-toggle="modal" data-bs-target="#editBookModal">Edit</a>
                                                        <a href="?delete_id=<?= isset($bookItem['id']) ? htmlspecialchars($bookItem['id']) : '' ?>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this book?');">Delete</a>
                                                    </td>
                                                </tr>
                                            <?php endforeach; ?>
                                        <?php else: ?>
                                            <tr>
                                                <td colspan="10" class="text-center">No books found.</td>
                                            </tr>
                                        <?php endif; ?>

                                    </tbody>
                                </table>
                            </div>
                        <?php else : ?>
                            <div class="alert alert-info">No books found.</div>
                        <?php endif; ?>
                    </div>
                </div>
            </div>
        </div>
    </div>


</body>
</html>