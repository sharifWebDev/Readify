<?php

// File: core/Controller.php

abstract class Controller {

    protected function view($view, $data = []) {
        extract($data);
        require_once "../views/{$view}.php";
    }

    protected function redirect($path = '') {
        session_write_close();
        $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https://' : 'http://';
            
        $host = $_SERVER['HTTP_HOST'];
    
        $scriptDir = rtrim(str_replace(basename($_SERVER['SCRIPT_NAME']), '', $_SERVER['SCRIPT_NAME']), '/');
    
        $baseUrl = $protocol . $host . $scriptDir;
    
        $baseUrl = rtrim($baseUrl, '/');
        
        $path = ltrim($path, '/');
       
        // return $baseUrl . '/' . $path;

        header("Location: {$baseUrl}/{$path}");
        exit;
    }
   
}