<?php
namespace App\Controllers; use App\Core\Controller;

class SchedulingController extends Controller {
    public function index(){ return $this->view("scheduling/index", ["title"=>"Scheduling"]); }
}

