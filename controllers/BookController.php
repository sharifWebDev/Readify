<?php
// File: controllers/BookController.php

require_once '../core/Controller.php';
require_once '../models/Book.php';

class BookController extends Controller {

    public function index() { 
        try {
            $bookModel = new Book();

            $books = $bookModel->getBooks();
            $authors = $bookModel->getAuthors();
            $categories = $bookModel->getCategories();

            return $this->view('Books', [
                'books' => $books,
                'authors' => $authors,
                'categories' => $categories
            ]);

        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while loading the page.";
        }
    }

    public function store() {
        try {
            $bookModel = new Book();

            $data = [
                'title' => $_POST['title'] ?? '',
                'author_id' => $_POST['author_id'] ?? null,
                'isbn' => $_POST['isbn'] ?? '',
                'code' => $_POST['code'] ?? '',
                'category_id' => $_POST['category_id'] ?? null,
                'quantity' => $_POST['quantity'] ?? 0
            ];

            if ($bookModel->createBook($data)) {
                echo "Book added successfully!";
                return $this->redirect('/books');
                exit;
            } else {
                echo "Failed to add book.";
                return $this->redirect('/books');
                exit;
            }

        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while saving the book.";
        }
    }
    //delete

    public function destroy() {
        try { 

            $id = $_GET['id'];
            $bookModel = new Book();
            $bookModel->deleteBook($id);
            return $this->redirect('/books');
            exit;
        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while deleting the book.";
        }
    }
}
