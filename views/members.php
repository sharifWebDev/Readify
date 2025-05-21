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
                    <h6 class="mb-0">Members List</h6>
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addMembersModal">
                        Add Members
                    </button>
                </div>

                    <?php if (!empty($error)): ?>
                        <div class="alert alert-danger" role="alert">
                            <?= htmlspecialchars($error); ?>
                        </div>
                    <?php endif; ?>

                    <?php if (!empty($members)) : ?>
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead class="table-success">
                                    <tr> 
                                        <th>ID</th>
                                        <th>First Name</th>
                                        <th>Last Name</th>
                                        <th>Email</th>
                                        <th>Password</th>
                                        <th>Phone</th>
                                        <th>Address</th>
                                        <th>Verified At</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($members as $subs) : ?>
                                        <tr>
                                            <td><?= htmlspecialchars($subs->id) ?></td>
                                            <td><?= htmlspecialchars($subs->first_name) ?></td>
                                            <td><?= htmlspecialchars($subs->last_name) ?></td>
                                            <td><?= htmlspecialchars($subs->email) ?></td>
                                            <td style="word-break: break-all; width: 100px"><?= htmlspecialchars($subs->password) ?></td>
                                            <td><?= htmlspecialchars($subs->phone) ?></td>
                                            <td><?= htmlspecialchars($subs->address) ?></td>
                                            <td><?= htmlspecialchars($subs->verified_at) ?></td>
                                            <td><?= htmlspecialchars($subs->created_at) ?></td>
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
                    <div class="alert alert-info">No Members found.</div>
                        <?php endif; ?>
                    </div>

                </div>
        </div>
   
        
<!-- Add Member Modal -->
<div class="modal fade" id="addMembersModal" tabindex="-1" aria-labelledby="addMembersModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-md">
    <div class="modal-content">
    
      <div class="modal-header">
        <h5 class="modal-title" id="addMembersModalLabel">Add New Member</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body">
        <form method="POST" action="<?= $url->url('members/store'); ?>">

          <!-- First Name -->
          <div class="mb-3">
            <label for="first_name" class="form-label">First Name <span class="text-danger">*</span></label>
            <input type="text" class="form-control" id="first_name" name="first_name" required>
          </div>

          <!-- Last Name -->
          <div class="mb-3">
            <label for="last_name" class="form-label">Last Name <span class="text-danger">*</span></label>
            <input type="text" class="form-control" id="last_name" name="last_name" required>
          </div>

          <!-- Email -->
          <div class="mb-3">
            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
            <input type="email" class="form-control" id="email" name="email" required>
          </div>

          <!-- Password -->
          <div class="mb-3">
            <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
            <input type="password" class="form-control" id="password" name="password" required>
          </div>

          <!-- Phone -->
          <div class="mb-3">
            <label for="phone" class="form-label">Phone <span class="text-danger">*</span></label>
            <input type="text" class="form-control" id="phone" name="phone" required>
          </div>

          <!-- Address -->
          <div class="mb-3">
            <label for="address" class="form-label">Address <span class="text-danger">*</span></label>
            <textarea class="form-control" id="address" name="address" rows="2" required></textarea>
          </div>

          <!-- Verified At -->
          <div class="mb-3">
            <label for="verified_at" class="form-label">Verified At (Optional)</label>
            <input type="datetime-local" class="form-control" id="verified_at" name="verified_at">
          </div> 

          <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">Close</button>
            <button type="submit" name="add_CusSubs" class="btn btn-primary">Save Member</button>
          </div>
        </form>
      </div>

    </div>
  </div>
</div>


</div>

</div>
 
<?php require_once 'layouts/page-footer.php'; ?>
 