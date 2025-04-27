<?php

// File: core/Controller.php

abstract class Controller {
    protected function view($view, $data = []) {
        extract($data);
        require_once "../views/{$view}.php";
    }

protected function redirect($url = '') {
    session_write_close();
    
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
    
    $baseUrl = $protocol . '://' . $_SERVER['HTTP_HOST'];
     
    $currentPath = $_SERVER['REQUEST_URI'];
     
    if ($url) {
        $newUrl = $baseUrl . '/readify/public' . $url;
    } else {
        $newUrl = $baseUrl . $currentPath;
    }

    // Redirect to the new URL
    header("Location: {$newUrl}");
    exit;
}

    
}