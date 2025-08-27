<?php
namespace App\Controllers; use App\Core\Controller;

class PharmacyController extends Controller {
    public function index(){ return $this->view("pharmacy/index", ["title"=>"Pharmacy"]); }
}

