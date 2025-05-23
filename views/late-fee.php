<?php
require_once 'layouts/page-header.php';
require_once 'layouts/navbar.php';
?>

<style>
    th {
        font-weight: bold;
        font-size: 13px;
    }

    @media print {
        body * {
            visibility: hidden;
        }

        #printableArea, #printableArea * {
            visibility: visible;
        }

        #printableArea {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
        }

        .no-print {
            display: none !important;
        }
    }
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<div class="container-fluid mt-4">
    <div class="row mt-4">

        <?php require_once 'layouts/sidebar.php'; ?>

        <div class="col-md-9">
            <div class="card shadow-sm">
                <div class="card-body" id="printableArea">
                    <div class="d-flex justify-content-between align-items-center mb-3 no-print">
                        <h6 class="mb-0">Customer Late Fees List</h6>
                        <button class="btn btn-primary btn-sm" id="print">Print</button>
                    </div>

                    <?php if (!empty($error)) : ?>
                        <div class="alert alert-danger" role="alert">
                            <?= htmlspecialchars($error); ?>
                        </div>
                    <?php endif; ?>

                    <?php if (!empty($getLateFee)) : ?>
                        <?php
                        $total_fine_amount = 0;
                        foreach ($getLateFee as $row) {
                            $total_fine_amount += $row->total_fine_amount;
                        }
                        ?>
                        <p>Total Fine Amount: <b><?= number_format($total_fine_amount, 2) ?> ৳</b></p>

                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead class="table-success">
                                    <tr>
                                        <th>ID</th>
                                        <th>Member Name</th>
                                        <th>Transaction ID</th>
                                        <th>Book Name</th>
                                        <th>Issue Date</th>
                                        <th>Due Date</th>
                                        <th>Return Date</th>
                                        <th>Total Due Days</th>
                                        <th>Total Fine Amount</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($getLateFee as $subs) : ?>
                                        <tr>
                                            <td><?= htmlspecialchars($subs->id) ?></td>
                                            <td><?= htmlspecialchars($subs->member_name) ?></td>
                                            <td><?= htmlspecialchars($subs->transaction_id) ?></td>
                                            <td><?= htmlspecialchars($subs->book_name) ?></td>
                                            <td><?= htmlspecialchars($subs->issue_date) ?></td>
                                            <td><?= htmlspecialchars($subs->due_date) ?></td>
                                            <td><?= htmlspecialchars($subs->return_date) ?></td>
                                            <td><?= htmlspecialchars($subs->total_due_days ?? 0) ?></td>
                                            <td><?= number_format($subs->total_fine_amount, 2) ?> ৳</td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    <?php else : ?>
                        <div class="alert alert-info">No Customer late fees found.</div>
                    <?php endif; ?>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    $("#print").on("click", function () {
        const printContents = document.getElementById("printableArea").innerHTML;
        const originalContents = document.body.innerHTML;
        document.body.innerHTML = printContents;
        window.print();
        document.body.innerHTML = originalContents;
        location.reload(); // Optional: refresh after printing
    });
</script>

<?php require_once 'layouts/page-footer.php'; ?>
