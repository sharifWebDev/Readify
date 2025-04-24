<?php

// File: core/CSRF.php

class CSRF {
    public static function generateToken() {
        if (!isset($_SESSION['token'])) {
            $_SESSION['token'] = bin2hex(random_bytes(32));
        }
        return $_SESSION['token'];
    }

    public static function validateToken($token) {
        return isset($_SESSION['token']) && hash_equals($_SESSION['token'], $token);
    }
}