<?php
require_once 'layouts/page-header.php';

    if (!isset($_SESSION['admin'])) {
        header('Location: /login');
        exit;
    }
    require_once 'layouts/navbar.php';
?>



<div class="container-fluid mt-4">
    <div class="row mt-4">
        <!-- Sidebar -->
        <?php
        require_once 'layouts/sidebar.php';
        ?>

        <!-- Content Area -->
        <div class="col-md-9">
            <div class="card shadow-sm">
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

                    <a href="/admin-logs" class="btn btn-outline-secondary mt-3">View Admin Logs</a>
                </div>
            </div>
        </div>
    </div>
</div>

<?php
require_once 'layouts/page-footer.php';
?>
