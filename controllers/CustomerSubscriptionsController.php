<?php 
require_once '../core/Controller.php';
require_once '../models/CustomerSubscriptions.php';
require_once '../models/Members.php';
require_once '../models/Book.php';

class CustomerSubscriptionsController extends Controller {

    public function index() { 
        try {
            $subscriptions = new CustomerSubscriptions();
            $getMembers = new Members();

            $getSubscriptionsPackage = $subscriptions->getSubscriptionsPackage();
            $getSubscriptions = $subscriptions->getSubscriptions();

            return $this->view('customer-subscriptions', [
                'getSubscriptions' => $getSubscriptions, 
                'getSubscriptionsPackage' => $getSubscriptionsPackage, 
                'members' => $getMembers->index(),
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
                'member_id' => $_POST['member_id'],
                'subscription_id' => $_POST['subscription_id'],
                'start_date' => $_POST['start_date'],
                'end_date' => $_POST['end_date'],
                'payment_status' => $_POST['payable_amount'] > 0 ? 1 : 0,
                'payable_amount' => $_POST['payable_amount'],
                'payment_date' => $_POST['payment_date'],
            ];

            $customerSubsModel = new CustomerSubscriptions();
            $customerSubsModel->store($data);

            return $this->redirect('/customer-subscriptions');
        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while saving the subscription.";
        }
    }

    //issue book

    public function issueBook() {
        try {
            $getMembers = new Members();
            $books = new Book();

            $getIssuedBooks = $books->getIssueBook();
            
            return $this->view('issue-book', [
                'members' => $getMembers->index(),
                'books' => $books->getBooks(),
                'getIssuedBooks' => $getIssuedBooks
            ]);

        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while loading the page.";
        }
    }

    //storeIssue
    public function storeIssue() {
        try {
            $bookModel = new Book();
            $data = [
                'member_id' => $_POST['member_id'],
                'book_id' => $_POST['book_id'],
                'issue_date' => $_POST['issue_date'],
                'due_date' => $_POST['due_date'] ?? null,
                'return_date' => $_POST['return_date'],
                'fine_amount' => $_POST['fine_amount'] ?? 0,
                'status' => $_POST['status'] ?? '0',
                'is_approved' => $_POST['is_approved'] ?? 1,
                'created_at' => $_POST['created_at'] ?? date('Y-m-d H:i:s'),
            ];
            $bookModel->storeIssue($data);
            return $this->redirect('/issue-books');
        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while saving the subscription.";
        }
    }

    //updateIssue
  public function updateIssue()
{
    try {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            throw new \Exception('Invalid request method.');
        }

        // Sanitize and validate inputs
        $id = isset($_POST['id']) ? (int) $_POST['id'] : null;
        $due_date = $_POST['due_date'] ?? null;
        $return_date = isset($_POST['return_date']) ? $_POST['return_date'] : null;
        $fine_amount = isset($_POST['fine_amount']) ? floatval($_POST['fine_amount']) : 0;
        $status = isset($_POST['status']) && $_POST['status'] == 1 ? '1' : '0';
        $is_approved = isset($_POST['is_approved']) ? ($_POST['is_approved'] == 1 ? '1' : '0') : '0';

        if (!$id || !$due_date) {
            throw new \Exception('Missing required fields.');
        }

        $bookModel = new Book();

        $data = [
            'id' => $id,
            'due_date' => $due_date,
            'return_date' => $return_date,
            'fine_amount' => $fine_amount,
            'status' => $status,
            'is_approved' => $is_approved,
            'updated_at' => date('Y-m-d H:i:s'),
        ];

        $bookModel->updateIssue($data);

        return $this->redirect('/issue-books');

    } catch (\Exception $e) {
        error_log('Issue update error: ' . $e->getMessage());
        echo "An error occurred while updating the book issue. Please try again later.";
        // Optionally: redirect to error page or show flash message
    }
}


    public function lateFee() {
        try {
            $bookModel = new CustomerSubscriptions();

            $getLateFee = $bookModel->getLateFee();

            return $this->view('late-fee', [
                'getLateFee' => $getLateFee, 
            ]);

        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while loading the page.";
        }
    }
    public function revenue() {
        try {
            $bookModel = new CustomerSubscriptions();

            $getRevenue = $bookModel->getRevenue();

            return $this->view('revenue', [
                'getRevenue' => $getRevenue, 
            ]);

        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while loading the page.";
        }
    }
 
}
