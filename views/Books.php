<?php
    require_once 'layouts/page-header.php';
    require_once 'layouts/navbar.php';
?>
<style>
    th{
        font-weight: bold;
        font-size: 13px;
    }
</style> 
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<div class="container-fluid mt-4">
    <div class="row mt-4">

    <?php require_once 'layouts/sidebar.php'; ?>

    <div class="col-md-9">
        <div class="card shadow-sm">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="mb-0">Books List</h6>
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addBookModal">
                        Add Book
                    </button>
                </div>

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
                                        <th>Actions</th>
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
                                            <td>
                                                <!-- <a href="view-book.php?id=" class="btn btn-info btn-sm">View</a>
                                                <a href="edit-book.php?id=" class="btn btn-warning btn-sm my-1">Edit</a> --> 
                                                <form method="GET" action="<?php echo $url->url('books/delete'); ?>">
                                                    <input type="hidden" name="id" value="<?= $book->id ?>">
                                                    <button type="submit" name="delete_book" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this book?')">Delete</button>
                                                </form>
                                            </td>
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
        
    <!-- Add Book Modal -->
    <div class="modal fade" id="addBookModal" tabindex="-1" aria-labelledby="addBookModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
        
        <div class="modal-header">
            <h5 class="modal-title" id="addBookModalLabel">Add New Book</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body">
            <form method="POST" action="<?php echo $url->url('books/store'); ?>">
            
            <!-- Title -->
            <div class="mb-3">
                <label for="title" class="form-label">Title <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="title" name="title" required>
            </div>

            <!-- Author -->
            <div class="mb-3">
                <label for="author_id" class="form-label">Author <span class="text-danger">*</span></label>
                <select class="form-select" id="author_id" name="author_id" required>
                <option value="">Select Author</option>
                <?php foreach($authors ?? [] as $author){
                    $author = (array) $author;
                ?>
                    <option value="<?= htmlspecialchars($author['id']) ?>">
                    <?= htmlspecialchars($author['name']) ?>
                    </option>
                <?php } ?>
                </select>
            </div>

            <!-- ISBN -->
            <div class="mb-3">
                <label for="isbn" class="form-label">ISBN <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="isbn" name="isbn" required>
            </div>

            <!-- Code -->
            <div class="mb-3">
                <label for="code" class="form-label">Code <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="code" name="code" required>
            </div>

            <!-- Category -->
            <div class="mb-3">
                <label for="category_id" class="form-label">Category <span class="text-danger">*</span></label>
                <select class="form-select" id="category_id" name="category_id" required>
                <option value="">Select Category</option>
                <?php foreach($categories ?? [] as $category){
                    $category = (array) $category;
                ?>
                    <option value="<?= htmlspecialchars($category['id']) ?>">
                    <?= htmlspecialchars($category['name']) ?>
                    </option>
                <?php } ?>
                
                </select>
            </div>

            <!-- Quantity -->
            <div class="mb-3">
                <label for="quantity" class="form-label">Quantity <span class="text-danger">*</span></label>
                <input type="number" class="form-control" id="quantity" name="quantity" min="1" required>
            </div>
    
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" name="add_book" class="btn btn-primary">Save Book</button>
            </form>
            </div>

        </div>
    </div>
    </div>
</div>

</div>
 
<?php require_once 'layouts/page-footer.php'; ?>
 