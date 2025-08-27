<?php
namespace App\Controllers; use App\Core\Controller;

class LisController extends Controller {
    public function index(){ return $this->view("lab/index", ["title"=>"Laboratory"]); }
}

