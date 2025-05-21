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
                        <h6 class="mb-0">Revenue Report List</h6>
                        <button class="btn btn-primary btn-sm" id="print">Print</button>
                    </div>

                    <?php if (!empty($error)): ?>
                        <div class="alert alert-danger" role="alert">
                            <?= htmlspecialchars($error); ?>
                        </div>
                    <?php endif; ?>

                    <?php if (!empty($getRevenue)) : ?>
                        <?php
                        $totalRevenueAmount = 0;
                        foreach ($getRevenue as $row) {
                            $totalRevenueAmount += $row->total_revenue;
                        }
                        ?>
                        <p>Total Revenue Amount: <b><?= number_format($totalRevenueAmount, 2) ?> ৳</b></p>

                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead class="table-success">
                                    <tr>
                                        <th>S/L</th>
                                        <th>Member Name</th>
                                        <th>Total Subscriptions</th>
                                        <th>Total Paid Amount</th>
                                        <th>Total Fine Amount</th>
                                        <th>Total Revenue</th>
                                        <th>First Subscription Date</th>
                                        <th>Last Subscription Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($getRevenue as $i => $subs) : ?>
                                        <tr>
                                            <td><?= htmlspecialchars($i + 1) ?></td>
                                            <td><?= htmlspecialchars($subs->member_name) ?></td>
                                            <td><?= htmlspecialchars($subs->total_subscriptions) ?></td>
                                            <td><?= htmlspecialchars($subs->total_paid_amount) ?></td>
                                            <td><?= htmlspecialchars($subs->total_fine_amount) ?></td>
                                            <td><?= htmlspecialchars($subs->total_revenue) ?></td>
                                            <td><?= htmlspecialchars($subs->first_subscription_date) ?></td>
                                            <td><?= htmlspecialchars($subs->last_subscription_date) ?></td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    <?php else : ?>
                        <div class="alert alert-info">No Revenue Report found.</div>
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
        location.reload(); // Optional: reload after printing
    });
</script>

<?php require_once 'layouts/page-footer.php'; ?>
