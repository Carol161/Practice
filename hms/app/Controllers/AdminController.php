<?php
namespace App\Controllers; use App\Core\Controller;

class AdminController extends Controller {
    public function index(){ return $this->view("admin/index", ["title"=>"Administration"]); }
}

