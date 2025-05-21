<?php 
require_once '../core/Controller.php';
require_once '../models/CustomerSubscriptions.php';
require_once '../models/Members.php';

class CustomerSubscriptionsController extends Controller {

    public function index() { 
        try {
            $subscriptions = new CustomerSubscriptions();
            $getMembers = new Members();

            $getSubscriptions = $subscriptions->getSubscriptions();

            return $this->view('customer-subscriptions', [
                'getSubscriptions' => $getSubscriptions, 
                'members' => $getMembers->index(),
            ]);

        } catch (\Exception $e) {
            error_log($e->getMessage());
            echo "An error occurred while loading the page.";
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
