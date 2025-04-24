<?php

// File: core/Controller.php

abstract class Controller {
    protected function view($view, $data = []) {
        extract($data);
        require_once "views/{$view}.php";
    }
}