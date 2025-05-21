<?php 
require_once '../core/Controller.php';
require_once '../models/Members.php';

class MemberController extends Controller {

    public function index() { 
        try {
            $bookModel = new Members();

            $members = $bookModel->index();

            return $this->view('members', [
                'members' => $members, 
            ]);

        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while loading the page.";
        }
    }
    //store
    public function store() {
        try {
            $data = [
                'first_name' => $_POST['first_name'],
                'last_name' => $_POST['last_name'],
                'email' => $_POST['email'],
                'password' => password_hash($_POST['password'], PASSWORD_DEFAULT),
                'phone' => $_POST['phone'],
                'address' => $_POST['address'],
                'verified_at' => $_POST['verified_at'] ?? null,
            ];

            $memberModel = new Members();
            $memberModel->store($data);

            return $this->redirect('/members');
        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while saving the member.";
        }
    }

 
}
