<?php
return [
    'DB_HOST' => env('DB_HOST', "127.0.0.1"),
    'DB_NAME' => env('DB_NAME', "hms"),
    'DB_USER' => env('DB_USER', "root"),
    'DB_PASS' => env('DB_PASS', ""),
];

function env($key, $default = null){
    $val = getenv($key);
    return $val === false ? $default : $val;
}

