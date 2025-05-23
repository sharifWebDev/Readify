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
                    <h6 class="mb-0">Book Author List</h6>
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addAuthorsModal">
                        Add Author
                    </button>
                </div>

                    <?php if (!empty($error)): ?>
                        <div class="alert alert-danger" role="alert">
                            <?= htmlspecialchars($error); ?>
                        </div>
                    <?php endif; ?>

                    <?php if (!empty($Author)) : ?>
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead class="table-success">
                                    <tr> 
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Slug</th> 
                                        <th>Active Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($Author as $aut) : ?>
                                        <tr>
                                            <td><?= htmlspecialchars($aut->id) ?></td>
                                            <td><?= htmlspecialchars($aut->name ?? '-') ?></td>
                                            <td><?= htmlspecialchars($aut->slug ?? '-') ?></td>
                                            <td><?= htmlspecialchars($aut->is_active == 1 ? 'Active' : 'Inactive') ?></td>
                                            <td>
                                                <form method="GET" action="<?php echo $url->url('CusSubss/delete'); ?>">
                                                    <input type="hidden" name="id" value="<?= $aut->id ?>">
                                                    <button type="submit" name="delete_CusSubs" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this CusSubs?')">Delete</button>
                                                </form>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    <?php else : ?>
                    <div class="alert alert-info">No Authors found.</div>
                        <?php endif; ?>
                    </div>

                </div>
        </div>
   
        
<!-- Add Author Modal -->
<div class="modal fade" id="addAuthorsModal" tabindex="-1" aria-labelledby="addAuthorsModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-md">
    <div class="modal-content">
    
      <div class="modal-header">
        <h5 class="modal-title" id="addAuthorsModalLabel">Add New Author</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body">
        <form method="POST" action="<?= $url->url('author/store'); ?>">

          <!-- First Name -->
          <div class="mb-3">
            <label for="name" class="form-label"> Name <span class="text-danger">*</span></label>
            <input type="text" class="form-control" id="name" name="name" required>
          </div>
 
          <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">Close</button>
            <button type="submit" name="add_CusSubs" class="btn btn-primary">Save Author</button>
          </div>
        </form>
      </div>

    </div>
  </div>
</div>


</div>

</div>
 
<?php require_once 'layouts/page-footer.php'; ?>
 