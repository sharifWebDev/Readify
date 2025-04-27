<?php
require_once 'layouts/page-header.php';

if (isset($_SESSION['admin'])) {
    header('Location: /dashboard');
    exit;
}
?>

<div class="container-fluid login-wrapper d-flex justify-content-center align-items-center">
    <div class="card shadow login-card">
        <h3 class="text-center mb-4">📚 Readify</h3>
        <h6 class="text-center mb-4">Admin Login</h6>

        <?php if (!empty($error)): ?>
            <div class="alert alert-danger" role="alert">
                <?= htmlspecialchars($error); ?>
            </div>
        <?php endif; ?>

        <form id="loginForm" method="POST" novalidate>
            <input type="hidden" name="token" value="<?= CSRF::generateToken(); ?>">

            <div class="mb-3">
                <label for="email" class="form-label">email</label>
                <input type="email" class="form-control" id="email" name="email" placeholder="Enter email" required>
                <div class="invalid-feedback">
                    Please enter your email.
                </div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required>
                <div class="invalid-feedback">
                    Please enter your password.
                </div>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-info">Login</button>
            </div>
        </form>
        <br>
        <br>
        <h6>Admin Login</h6>
        <p>Email: admin@readify.com</p>
        <p>Password: admin123</p>
    </div>
</div>
 
<script>
    (function () {
        const form = document.getElementById('loginForm');
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    })();
</script>

<?php
require_once './layouts/page-footer.php';
?>