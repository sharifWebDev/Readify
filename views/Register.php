

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
                    
                <h3 class="text-center mb-4">📚 Readify</h3>
                <h6 class="text-center mb-4">Admin Registration</h6>

                <!-- Display error message if any -->
                <?php if (!empty($error)): ?>
                    <div class="alert alert-danger" role="alert">
                        <?= htmlspecialchars($error); ?>
                    </div>
                <?php endif; ?>

                <!-- Registration Form -->
                <form id="registrationForm" method="POST" >
                <input type="hidden" name="token" value="<?= CSRF::generateToken(); ?>">
                    <div class="mb-3">
                        <input type="text" name="username" placeholder="Username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <input type="email" name="email" placeholder="Email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <input type="password" name="password" placeholder="Password" class="form-control" required>
                    </div>
                    

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-primary w-100 mt-3">Register</button>
                </form>
      
 
                </div>
            </div>
        </div>
    </div>
</div>

<?php
require_once 'layouts/page-footer.php';
?>


 
<script>
    // Basic form validation using HTML5
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
 