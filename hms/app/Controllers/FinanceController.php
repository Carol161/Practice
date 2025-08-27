<?php
namespace App\Controllers; use App\Core\Controller;

class FinanceController extends Controller {
    public function index(){ return $this->view("finance/index", ["title"=>"Finance"]); }
}

