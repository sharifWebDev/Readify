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
                    <h6 class="mb-0">Customer Issued Books</h6>
                    <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#addBookIssueModal">
                        New Issue Book
                    </button>

                </div>

                    <?php if (!empty($error)): ?>
                        <div class="alert alert-danger" role="alert">
                            <?= htmlspecialchars($error); ?>
                        </div>
                    <?php endif; ?>

                  <?php if (!empty($getIssuedBooks)) : ?>
                    <div class="card mt-4">
                        <div class="card-body">
                            <h6 class="mb-3">Issued Books</h6>
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover align-middle">
                                    <thead class="table-info">
                                        <tr>
                                            <th>ID</th>
                                            <th>Transaction ID</th>
                                            <th>Member Name</th>
                                            <th>Book Title</th>
                                            <th>Issue Date</th>
                                            <th>Due Date</th>
                                            <th>Return Date</th>
                                            <th>Fine</th>
                                            <th>Status</th>
                                            <th>Approved</th> 
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($getIssuedBooks as $txn): ?>
                                            <tr>
                                                <td><?= htmlspecialchars($txn->id) ?></td>
                                                <td><?= htmlspecialchars($txn->transaction_id) ?></td>
                                                <td><?= htmlspecialchars($txn->member_name) ?></td>
                                                <td><?= htmlspecialchars($txn->book_title) ?></td>
                                                <td><?= htmlspecialchars($txn->issue_date) ?></td>
                                                <td><?= htmlspecialchars($txn->due_date) ?></td>
                                                <td><?= htmlspecialchars($txn->return_date ?? '-') ?></td>
                                                <td><?= htmlspecialchars($txn->fine_amount ?? 0) ?></td>
                                                <td><?= htmlspecialchars($txn->status ? 'Returned' : 'Issued') ?></td>
                                                <td><?= htmlspecialchars($txn->is_approved ? 'Yes' : 'No') ?></td> 
                                                <td>
                                                   <a href="#" 
                                                    class="btn btn-success btn-sm editBookBtn"
                                                    data-id="<?= $txn->id ?>"
                                                    data-transaction_id="<?= htmlspecialchars($txn->transaction_id) ?>"
                                                    data-member_id="<?= $txn->member_id ?>"
                                                    data-book_id="<?= $txn->book_id ?>"
                                                    data-issue_date="<?= $txn->issue_date ?>"
                                                    data-due_date="<?= $txn->due_date ?>"
                                                    data-return_date="<?= $txn->return_date ?>"
                                                    data-fine_amount="<?= $txn->fine_amount ?>"
                                                    data-status="<?= $txn->status ?>"
                                                    data-is_approved="<?= $txn->is_approved ?>"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#editBookIssueModal"
                                                >
                                                   Return Book Or Update Book Issue
                                                </a>

                                                </td>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                <?php endif; ?>


                </div>
        </div>
         
        <div class="modal fade" id="addBookIssueModal" tabindex="-1" aria-labelledby="addBookIssueModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <form method="POST" action="<?= $url->url('/issue-books/store'); ?>">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addBookIssueModalLabel">Issue New Book</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">

                            <div class="mb-3">
                                <label for="member_id" class="form-label">Member</label>
                                <select class="form-select" id="member_id" name="member_id" required>
                                    <option value="">Select Member</option>
                                    <?php foreach ($members ?? [] as $member): ?>
                                        <option value="<?= $member->id ?>">
                                            <?= htmlspecialchars($member->first_name . ' ' . $member->last_name) ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="book_id" class="form-label">Book</label>
                                <select class="form-select" id="book_id" name="book_id" required>
                                    <option value="">Select Book</option>
                                    <?php foreach ($books ?? [] as $book): ?>
                                        <option value="<?= $book->id ?>">
                                            <?= htmlspecialchars($book->title) ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="issue_date" class="form-label">Issue Date</label>
                                <input type="date" class="form-control" min="<?= date('Y-m-d') ?>" id="issue_date" name="issue_date" value="<?= date('Y-m-d') ?>" required>
                            </div>

                            <div class="mb-3">
                                <label for="due_date" class="form-label">Due Date</label>
                                <input type="date" class="form-control" min="<?= date('Y-m-d') ?>" id="due_date" name="due_date" required>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" name="issue_book" class="btn btn-primary">Issue Book</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- edit book issue modal -->
        <div class="modal fade" id="editBookIssueModal" tabindex="-1" aria-labelledby="editBookIssueModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <form method="POST" action="<?= $url->url('/issue-books/update'); ?>">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editBookIssueModalLabel">Return Book / Update Book Issue</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div id="editBookIssueModalContent"></div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

</div>

</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
    const editButtons = document.querySelectorAll('.editBookBtn');

    editButtons.forEach(button => {
        button.addEventListener('click', function () {
            const modalContent = document.getElementById('editBookIssueModalContent');

            // Create dynamic form fields based on data attributes
            const formHtml = `
                <form method="POST" action="<?= $url->url('/issue-books/update'); ?>">
                <input type="hidden" name="id" value="${this.dataset.id}">
                <div class="row">
                    <div class="mb-3 col-md-6">
                        <label for="edit_member_id" class="form-label">Member</label>
                        <select class="form-select" name="member_id" id="edit_member_id" required disabled>
                            <option value="${this.dataset.member_id}" selected readonly>Selected Member ID: ${this.dataset.member_id}</option>
                        </select>
                    </div>

                    <div class="mb-3 col-md-6">
                        <label for="edit_book_id" class="form-label">Book</label>
                        <select class="form-select" name="book_id" id="edit_book_id" required disabled>
                            <option value="${this.dataset.book_id}" selected  readonly>Selected Book ID: ${this.dataset.book_id}</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="mb-3 col-md-6"> 
                        <label for="edit_issue_date" class="form-label">Issue Date</label>
                        <input type="date" class="form-control" name="issue_date" value="${this.dataset.issue_date}" disabled readonly>
                    </div>
                    <div class="mb-3 col-md-6"> 
                        <label for="edit_due_date" class="form-label">Due Date</label>
                        <input type="date" class="form-control" name="due_date" value="${this.dataset.due_date}" required>
                    </div>
                </div>
                <div class="row">
                    <div class="mb-3 col-md-6">
                        <label for="edit_return_date" class="form-label">Return Date</label>
                        <input type="date" min="<?= date('Y-m-d') ?>" class="form-control" name="return_date" value="${this.dataset.return_date}">
                    </div>

                    <div class="mb-3 col-md-6">
                        <label for="edit_fine_amount" class="form-label">Fine Amount</label>
                        <input type="number" class="form-control" name="fine_amount" value="${this.dataset.fine_amount ?? 0}">
                    </div>
                </div>
                <div class="row">
                    <div class="mb-3 col-md-6">
                        <label for="edit_status" class="form-label">Status</label>
                        <select class="form-select" name="status" id="edit_status">
                            <option value="0" ${this.dataset.status == 0 ? 'selected' : ''}>Issued</option>
                            <option value="1" ${this.dataset.status == 1 ? 'selected' : ''} selected>Returned</option>
                        </select>
                    </div>

                    <div class="mb-3 col-md-6">
                        <label for="edit_is_approved" class="form-label">Approved</label>
                        <select class="form-select" name="is_approved" id="edit_is_approved">
                            <option value="0" ${this.dataset.is_approved == 0 ? 'selected' : ''}>No</option>
                            <option value="1" ${this.dataset.is_approved == 1 ? 'selected' : ''} selected>Yes</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" name="update_issue_book" class="btn btn-primary">Update Book Issue</button>
                </div>
                </form>
            `;

            modalContent.innerHTML = formHtml;
        });
    });
});
</script>

 
<?php require_once 'layouts/page-footer.php'; ?>
 