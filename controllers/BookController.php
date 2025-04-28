<?php

// File: controllers/BookController.php

require_once '../core/Controller.php';
require_once '../models/Book.php';

class BookController extends Controller {

    public function index() { 
        try {
            $admin = new Book();

            $books = $admin->getBooks();

            return $this->view('Books', ['books' => $books]);
        } catch (\Expeption $e) {

            error_log($e->getMessage());
            echo $e->getMessage();
            
        }

    }

}
