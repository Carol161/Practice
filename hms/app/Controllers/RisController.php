<?php
namespace App\Controllers; use App\Core\Controller;

class RisController extends Controller {
    public function index(){ return $this->view("radiology/index", ["title"=>"Radiology"]); }
}

