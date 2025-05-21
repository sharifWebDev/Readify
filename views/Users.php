

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
                <div class="card-body">
                     <div class="d-flex justify-content-between align-items-center mb-3 no-print">
                        
                        <h6 class="mb-4">Admin Users List</h6>
                        
                        <a class="btn btn-primary btn-sm" href="<?php echo $url->url('register'); ?>" class="list-group-item list-group-item-action">👤 Add New Admin User</a>
                    </div>
                     
       
 
                <?php if (!empty($error)): ?>
                    <div class="alert alert-danger" role="alert">
                        <?= htmlspecialchars($error); ?>
                    </div>
                <?php endif; ?>
  
                <?php if (!empty($users)) : ?>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle">
                            <thead class="table-success">
                                <tr>
                                    <th>ID</th>
                                    <th>Email</th>
                                    <th>Username</th>
                                    <th>Verified At</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($users as $user) : ?>
                                    <tr>
                                        <td><?= htmlspecialchars($user->id) ?></td>
                                        <td><?= htmlspecialchars($user->email) ?></td>
                                        <td><?= htmlspecialchars($user->username) ?></td>
                                        <td>
                                            <?php if ($user->verified_at) : ?>
                                                <?= htmlspecialchars(date('M d, Y', strtotime($user->verified_at))) ?>
                                            <?php else : ?>
                                                <span class="badge bg-warning text-dark">Not Verified</span>
                                            <?php endif; ?>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php else : ?>
                    <div class="alert alert-info">No users found.</div>
                <?php endif; ?>
            
            </div>
        </div>
    </div>
</div>

<?php
require_once 'layouts/page-footer.php';
?>
 
<script>
    
    (function () {
        const form = document.getElementById('registrationForm');
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    })();
</script>
 