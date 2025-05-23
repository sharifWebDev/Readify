<?php 
require_once '../core/Controller.php';
require_once '../models/Author.php';

class AuthorController extends Controller {

    public function index() { 
        try {
            $authorModel = new Author();

            $Author = $authorModel->index();

            return $this->view('Author', [
                'Author' => $Author, 
            ]);

        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while loading the page.";
        }
    }
    //store
    public function store()
    {
        try { 
            $name = trim($_POST['name'] ?? '');
            if (empty($name)) {
                throw new Exception("Author name is required.");
            }

            $slug = $this->generateSlug($name); 
            $data = [
                'name' => $name,
                'slug' => $slug,
                'is_active' => 1,
                'created_at' => $_POST['created_at'] ?? date('Y-m-d H:i:s')
            ];

            $authorModel = new Author();
            $authorModel->store($data);

            return $this->redirect('/authors');
        } catch (Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while saving the Author.";
        }
    } 

    
private function generateSlug($string)
{ 
    $slug = strtolower($string); 
    $slug = preg_replace('/[^a-z0-9\s-]/', '', $slug); 
    $slug = preg_replace('/[\s_]+/', '-', $slug); 
    $slug = preg_replace('/-+/', '-', $slug); 
    $slug = trim($slug, '-');
    return $slug;
}

 
}
