<!-- File: views/dashboard.php -->
<?php 
if (!isset($_SESSION['admin'])) {
    header("Location: /");
    exit;
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Readify</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-color: #f4f6f9;">

<nav class="navbar navbar-expand-lg navbar-success bg-success px-4">
    <a class="navbar-brand" href="#">📘 Readify Admin</a>
    <div class="ms-auto">
        <span class="navbar-text text-white me-3">
            Welcome, <?= htmlspecialchars($_SESSION['admin']->email) ?>
        </span>
        <a href="/logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
</nav>

<div class="container-fluid mt-4">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3">
            <div class="list-group bg-white"  style="min-height: 88vh;">
                <a href="/dashboard" class="list-group-item list-group-item-action active">🏠 Dashboard</a>
                <a href="/books" class="list-group-item list-group-item-action">📚 Manage Books</a>
                <a href="/members" class="list-group-item list-group-item-action">👤 Manage Members</a>
                <a href="/subscriptions" class="list-group-item list-group-item-action">💳 Manage Subscriptions</a>
                <a href="/admin-logs" class="list-group-item list-group-item-action">📝 Admin Logs</a>
            </div>
        </div>

        <!-- Content Area -->
        <div class="col-md-9">
            <div class="card shadow-sm" style="min-height: 88vh;">
                <div class="card-body">
                    <h4 class="card-title mb-4">📊 Admin Dashboard</h4> 
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <div class="card border-primary shadow-sm">
                                <div class="card-body text-center">
                                    <h5 class="card-title">📚 Books</h5>
                                    <p class="card-text">Add, edit, or remove books.</p>
                                    <a href="/books" class="btn btn-primary">Manage</a>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 mb-3">
                            <div class="card border-success shadow-sm">
                                <div class="card-body text-center">
                                    <h5 class="card-title">👤 Members</h5>
                                    <p class="card-text">Manage library members.</p>
                                    <a href="/members" class="btn btn-success">Manage</a>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 mb-3">
                            <div class="card border-warning shadow-sm">
                                <div class="card-body text-center">
                                    <h5 class="card-title">💳 Subscriptions</h5>
                                    <p class="card-text">Track subscriptions and billing.</p>
                                    <a href="/subscriptions" class="btn btn-warning">Manage</a>
                                </div>
                            </div>
                        </div>
                    </div>
 
                    <a href="/admin-logs" class="btn btn-outline-secondary bottom-0">View Admin Logs</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle (Optional for interactivity) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
