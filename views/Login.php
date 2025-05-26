<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Readify | Admin </title>
    <!-- Bootstrap 5.1 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style> 
        .login-wrapper {
            height: 100vh;
        }
        .login-card {
            max-width: 400px;
            width: 100%;
            border-radius: 1rem;
            padding: 2rem;
        }

        .bg-info,  .list-group-item.active {
            background-color:rgb(19, 11, 73) !important;
        }
 
    </style>
</head>
<body>


<?php

require_once __DIR__ . '/../core/MakeUrl.php';

$url = new MakeUrl();
  
if (isset($_SESSION['admin'])) {
    header('Location: ' . $url->url('admin-dashboard'));
    
}

?>

<?php if (!empty($message)): ?>
    <div class="alert alert-success" role="alert">
        <?= htmlspecialchars($message); ?>
    </div>
<?php endif; ?>

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
                <label for="email" class="form-label">Email</label>
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


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
 
</body>
</html>