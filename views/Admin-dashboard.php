<?php
    require_once 'layouts/page-header.php';
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
                <div class="card-body px-4">
                    <h4 class="card-title mb-4">📊 Admin Dashboard</h4> 
                    <div class="row">
                        
                        <div class="col-md-4 mb-3">
                            <div class="card border-success shadow-sm">
                                <div class="card-body text-center">
                                    <h5 class="card-title">📚 Get Books</h5>
                                    <p class="card-text">issued books.</p>
                                    <a href="<?php echo $url->url('issue-books'); ?>" class="btn btn-success">Issue</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card border-success shadow-sm">
                                <div class="card-body text-center">
                                    <h5 class="card-title">📚 Books</h5>
                                    <p class="card-text">Add, edit, or remove books.</p>
                                    <a href="<?php echo $url->url('books'); ?>" class="btn btn-success">Manage</a>
                                </div>
                            </div>
                        </div>
                        
                         <div class="col-md-4 mb-3">
                            <div class="card border-success shadow-sm">
                                <div class="card-body text-center">
                                    <h5 class="card-title">👤 Members</h5>
                                    <p class="card-text">Manage library members.</p>
                                    <a href="<?php echo $url->url('members'); ?>" class="btn btn-success">Manage</a>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4 mb-3">
                            <div class="card border-success shadow-sm">
                                <div class="card-body text-center">
                                    <h5 class="card-title">💳 Subscriptions</h5>
                                    <p class="card-text">Track subscriptions and billing.</p>
                                    <a href="<?php echo $url->url('customer-subscriptions'); ?>" class="btn btn-success">Manage</a>
                                </div>
                            </div>
                        </div>
                        
                       
                        <div class="col-md-4 mb-3">
                            <div class="card border-success shadow-sm">
                                <div class="card-body text-center">
                                    <h5 class="card-title">👤 admin Users</h5>
                                    <p class="card-text">Track admin Users.</p>
                                    <a href="<?php echo $url->url('users'); ?>" class="btn btn-success">Manage</a>
                                </div>
                            </div>
                        </div> 

                         <div class="col-md-4 mb-3">
                            <div class="card border-success shadow-sm">
                                <div class="card-body text-center">
                                    <h5 class="card-title">💳 Late Fee Report</h5>
                                    <p class="card-text">Track Late Fee Report.</p>
                                    <a href="<?php echo $url->url('late-fee'); ?>" class="btn btn-success">Manage</a>
                                </div>
                            </div>
                        </div>

                         <div class="col-md-4 mb-3">
                            <div class="card border-success shadow-sm">
                                <div class="card-body text-center">
                                    <h5 class="card-title">💳 Revenue Report</h5>
                                    <p class="card-text">Track Revenue Report.</p>
                                    <a href="<?php echo $url->url('revenue'); ?>" class="btn btn-success">Manage</a>
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
