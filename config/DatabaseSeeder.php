<?php

class DatabaseSeeder {
    public function run($pdo) {  // Accept PDO connection as a parameter
        // 1. Seed Admins
        $admins = [
            ['username' => 'admin', 'password' => password_hash('admin123', PASSWORD_BCRYPT), 'email' => 'admin@readify.com']
        ];
        $this->insert($pdo, 'admins', $admins);

        // 2. Seed Members
        $members = [
            ['first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com', 'password' => password_hash('password', PASSWORD_BCRYPT), 'phone' => '0123456789', 'address' => '123 Main St']
        ];
        $this->insert($pdo, 'members', $members);

        // 3. Seed Authors
        $authors = [
            ['name' => 'J.K. Rowling', 'slug' => 'jk-rowling'],
            ['name' => 'George R.R. Martin', 'slug' => 'george-rr-martin']
        ];
        $this->insert($pdo, 'authors', $authors);

        // 4. Seed Categories
        $categories = [
            ['name' => 'Fantasy', 'slug' => 'fantasy'],
            ['name' => 'Thriller', 'slug' => 'thriller']
        ];
        $this->insert($pdo, 'categories', $categories);

        // 5. Seed Books
        $books = [
            ['title' => 'Harry Potter', 'author_id' => 1, 'isbn' => '9780439136365', 'code' => 'HP001', 'category_id' => 1, 'quantity' => 10, 'available_quantity' => 10],
            ['title' => 'Game of Thrones', 'author_id' => 2, 'isbn' => '9780553103540', 'code' => 'GOT001', 'category_id' => 1, 'quantity' => 5, 'available_quantity' => 5]
        ];
        $this->insert($pdo, 'books', $books);

        // 6. Seed Subscription Packages
        $packages = [
            ['package_name' => 'Monthly', 'price' => 9.99, 'discount' => 1.00],
            ['package_name' => 'Yearly', 'price' => 99.99, 'discount' => 10.00]
        ];
        $this->insert($pdo, 'subscription_packages', $packages);

        // 7. Seed Subscription Package Details
        $packageDetails = [
            ['package_id' => 1, 'feature' => 'Borrow 2 Books'],
            ['package_id' => 2, 'feature' => 'Borrow 10 Books']
        ];
        $this->insert($pdo, 'subscription_package_details', $packageDetails);

        // 8. Seed Customer Subscriptions
        $subscriptions = [
            ['member_id' => 1, 'start_date' => '2025-01-01', 'end_date' => '2025-12-31', 'payment_status' => 'paid', 'payable_amount' => 99.99, 'payment_date' => '2025-01-01']
        ];
        $this->insert($pdo, 'customer_subscriptions', $subscriptions);

        // 9. Seed Transactions
        $transactions = [
            ['transaction_id' => 'TRX1001', 'member_id' => 1, 'book_id' => 1, 'issue_date' => '2025-04-01', 'due_date' => '2025-04-10', 'status' => 'issued']
        ];
        $this->insert($pdo, 'transactions', $transactions);

        // 10. Seed Payments
        $payments = [
            ['subscription_id' => 1, 'transaction_id' => 'TRX1001', 'payment_method' => 'card', 'total_payable_amount' => 99.99, 'paid_amount' => 99.99, 'total_paid_amount' => 99.99, 'payment_status' => 'success']
        ];
        $this->insert($pdo, 'payments', $payments);

        // 11. Seed Late Fees
        $lateFees = [
            ['key_name' => 'daily_late_fee', 'charge' => 1.50]
        ];
        $this->insert($pdo, 'late_fees', $lateFees);

        // 12. Seed Logs
        $logs = [
            ['action' => 'Admin login', 'user_type' => 'admin', 'user_id' => 1]
        ];
        $this->insert($pdo, 'logs', $logs);

        echo "✅ All tables seeded successfully!";
    }

    private function insert($pdo, $table, $rows) {
        if (empty($rows)) return;

        $columns = implode(', ', array_keys($rows[0]));
        $placeholders = implode(', ', array_map(fn($col) => ":$col", array_keys($rows[0])));
        $stmt = $pdo->prepare("INSERT INTO $table ($columns) VALUES ($placeholders)");

        foreach ($rows as $row) {
            $stmt->execute($row);
        }
    }
}
