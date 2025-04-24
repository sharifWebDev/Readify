<?php require_once 'layouts/page-header.php'; ?>

<div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
    <div class="card shadow p-4" style="width: 100%; max-width: 500px;">
        <h3 class="text-center mb-3">📚 Readify</h3>
        <h6 class="text-center text-muted mb-4">Database Connection Setup</h6>
        

        <?php if (!empty($message)): ?>
            <div class="alert alert-info text-center"><?= htmlspecialchars($message); ?></div>
        <?php endif; ?>

        <form method="POST" action="db-setup" class="d-grid gap-2">
            <button type="submit" name="action" value="setup" class="btn btn-primary">
                Create Database, Run Migrations, Seed Database
            </button>
        </form>

    </div>
</div>

<?php require_once './layouts/page-footer.php'; ?>
