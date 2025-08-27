<?php
namespace App\Core;
use PDO;use PDOException;

class DB {
    private static ?PDO $pdo = null;
    public static function pdo(): PDO {
        if (self::$pdo) return self::$pdo;
        $cfg = require __DIR__ . '/../../config/app.php';
        $dsn = 'mysql:host=' . $cfg['DB_HOST'] . ';dbname=' . $cfg['DB_NAME'] . ';charset=utf8mb4';
        try {
            self::$pdo = new PDO($dsn, $cfg['DB_USER'], $cfg['DB_PASS'], [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            ]);
        } catch (PDOException $e) {
            http_response_code(500);
            echo 'Database connection failed.';
            exit;
        }
        return self::$pdo;
    }
}

