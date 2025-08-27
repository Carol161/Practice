<?php
namespace App\Controllers; use App\Core\Controller;

class EhrController extends Controller {
    public function index(){ return $this->view("ehr/dashboard", ["title"=>"EHR"]); }
}

