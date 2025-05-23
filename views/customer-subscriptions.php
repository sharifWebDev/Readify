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
                    <h6 class="mb-0">Customer Subscriptions List</h6>
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addCusSubsModal">
                        Add Subscription
                    </button>
                </div>

                    <?php if (!empty($error)): ?>
                        <div class="alert alert-danger" role="alert">
                            <?= htmlspecialchars($error); ?>
                        </div>
                    <?php endif; ?>

                    <?php if (!empty($getSubscriptions)) : ?>
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead class="table-success">
                                    <tr> 
                                        <th>ID</th>
                                        <th>Stat Date</th>
                                        <th>End Date</th>
                                        <th>Payment Status</th>
                                        <th>Payable Amount</th>
                                        <th>Member ID</th>
                                        <th>Payment Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($getSubscriptions as $subs) : ?>
                                        <tr>
                                            <td><?= htmlspecialchars($subs->id) ?></td>
                                            <td><?= htmlspecialchars($subs->start_date) ?></td>
                                            <td><?= htmlspecialchars($subs->end_date) ?></td>
                                            <td><?= htmlspecialchars($subs->payment_status==1?'Paid':'Unpaid') ?></td>
                                            <td><?= htmlspecialchars($subs->payable_amount) ?></td>
                                            <td><?= htmlspecialchars($subs->member_id) ?></td>
                                            <td><?= htmlspecialchars($subs->payment_date) ?></td>
                                            <td>
                                                <!-- <a href="view-CusSubs.php?id=" class="btn btn-info btn-sm">View</a>
                                                <a href="edit-CusSubs.php?id=" class="btn btn-warning btn-sm my-1">Edit</a> --> 
                                                <form method="GET" action="<?php echo $url->url('CusSubss/delete'); ?>">
                                                    <input type="hidden" name="id" value="<?= $subs->id ?>">
                                                    <button type="submit" name="delete_CusSubs" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this CusSubs?')">Delete</button>
                                                </form>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    <?php else : ?>
                    <div class="alert alert-info">No Customer Subscriptions found.</div>
                        <?php endif; ?>
                    </div>

                </div>
        </div>
        
   
        <!-- Add CusSubs Modal -->
<div class="modal fade" id="addCusSubsModal" tabindex="-1" aria-labelledby="addCusSubsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="addCusSubsModalLabel">Add New Customer Subscription</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <form method="POST" action="<?php echo $url->url('customer-subscriptions/store'); ?>">
    
                    <div class="mb-3">
                        <label for="subscription_id" class="form-label">Subscription Package <span class="text-danger">*</span></label>
                        <select class="form-select" id="subscription_id" name="subscription_id" required>
                            <option value="">Select Subscription Package</option>
                            <?php foreach ($getSubscriptionsPackage ?? [] as $package): ?>
                                <option value="<?= htmlspecialchars($package->id) ?>"
                                        data-price="<?= htmlspecialchars($package->price - $package->discount) ?>">
                                    <?= htmlspecialchars($package->package_name) ?> — Payable Amount: <?= htmlspecialchars($package->price) ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <input type="hidden" id="payable_amount" name="payable_amount" value="">

                    <div class="mb-3">
                        <label for="member_id" class="form-label">Member <span class="text-danger">*</span></label>
                        <select class="form-select" id="member_id" name="member_id" required>
                            <option value="">Select Member</option>
                            <?php foreach ($members ?? [] as $member): ?>
                                <option value="<?= htmlspecialchars($member->id) ?>">
                                    <?= htmlspecialchars($member->first_name . ' ' . $member->last_name) ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>

                    <!-- Start Date -->
                    <div class="mb-3">
                        <label for="start_date" class="form-label">Start Date <span class="text-danger">*</span></label>
                        <input type="date" min="<?php echo date('Y-m-d'); ?>" value="<?php echo date('Y-m-d'); ?>" class="form-control" id="start_date" name="start_date" required>
                    </div>

                    <!-- End Date -->
                    <div class="mb-3">
                        <label for="end_date" class="form-label">End Date <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" min="<?php echo date('Y-m-d'); ?>" id="end_date" name="end_date" required>
                    </div>
              
                    <!-- Payment Date -->
                    <div class="mb-3">
                        <label for="payment_date" class="form-label">Payment Date</label>
                        <input type="date" class="form-control" min="<?php echo date('Y-m-d'); ?>" value="<?php echo date('Y-m-d'); ?>" id="payment_date" name="payment_date">
                    </div>

                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" name="add_CusSubs" class="btn btn-primary">Save Subscription</button>
                </form>
            </div>

        </div>
    </div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
    const subscriptionSelect = document.getElementById('subscription_id');
    const payableInput = document.getElementById('payable_amount');

    subscriptionSelect.addEventListener('change', function () {
        const selectedOption = this.options[this.selectedIndex];
        const price = selectedOption.getAttribute('data-price') || '';
        payableInput.value = price;
    });
});
</script>



</div>

</div>
 
<?php require_once 'layouts/page-footer.php'; ?>
 