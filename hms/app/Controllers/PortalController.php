<?php
namespace App\Controllers; use App\Core\Controller;

class PortalController extends Controller {
    public function index(){ return $this->view("portal/index", ["title"=>"Patient Portal"]); }
}

