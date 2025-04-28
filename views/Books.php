<?php
    require_once 'layouts/page-header.php';
    require_once 'layouts/navbar.php';
?>

<div class="container-fluid mt-4">
    <div class="row mt-4">

        <?php require_once 'layouts/sidebar.php'; ?>

        <div class="col-md-9">
            <div class="card shadow-sm">
                <div class="card-body">
                     
                    <h6 class="mb-4">Books List</h6>
 
                    <?php if (!empty($error)): ?>
                        <div class="alert alert-danger" role="alert">
                            <?= htmlspecialchars($error); ?>
                        </div>
                    <?php endif; ?>
  
                    <?php if (!empty($books)) : ?>
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead class="table-success">
                                    <tr>
                                        <th>ID</th>
                                        <th>Title</th>
                                        <th>Author ID</th>
                                        <th>ISBN</th>
                                        <th>Code</th>
                                        <th>Category ID</th>
                                        <th>Quantity</th>
                                        <th>Available Quantity</th>
                                        <th>Created At</th>
                                        <th>Updated At</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($books as $book) : ?>
                                        <tr>
                                            <td><?= htmlspecialchars($book->id) ?></td>
                                            <td><?= htmlspecialchars($book->title) ?></td>
                                            <td><?= htmlspecialchars($book->author_id) ?></td>
                                            <td><?= htmlspecialchars($book->isbn) ?></td>
                                            <td><?= htmlspecialchars($book->code) ?></td>
                                            <td><?= htmlspecialchars($book->category_id) ?></td>
                                            <td><?= htmlspecialchars($book->quantity) ?></td>
                                            <td><?= htmlspecialchars($book->available_quantity) ?></td>
                                            <td><?= htmlspecialchars(date('M d, Y', strtotime($book->created_at))) ?></td>
                                            <td><?= htmlspecialchars(date('M d, Y', strtotime($book->updated_at))) ?></td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    <?php else : ?>
                        <div class="alert alert-info">No books found.</div>
                    <?php endif; ?>
            
                </div>
            </div>
        </div>
    </div>
</div>

<?php require_once 'layouts/page-footer.php'; ?>
