<?php 
require_once '../core/Controller.php';
require_once '../models/Category.php';

class CategoryController extends Controller {

    public function index() { 
        try {
            $bookModel = new Category();

            $category = $bookModel->index();

            return $this->view('category', [
                'category' => $category, 
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
                throw new Exception("Category name is required.");
            }

            $slug = $this->generateSlug($name); 

            $data = [
                'name' => $name,
                'slug' => $slug,
                'parent_category_id' => $_POST['parent_category_id'] ?? null,
                'is_active' => 1,
                'created_at' => $_POST['created_at'] ?? date('Y-m-d H:i:s')
            ];

            $memberModel = new Category();
            $memberModel->store($data);

            return $this->redirect('/categories');
        } catch (Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while saving the category.";
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
