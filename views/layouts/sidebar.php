
<div class="col-md-3">
    <div class="list-group bg-white">
        <a href="<?php echo $url->url('admin-dashboard'); ?>" class="list-group-item list-group-item-action active">🏠 Dashboard</a>
        <a href="<?php echo $url->url('issue-books'); ?>" class="list-group-item list-group-item-action">📚 Get Books To Members</a>
        <a href="<?php echo $url->url('books'); ?>" class="list-group-item list-group-item-action">📚 Manage Books</a>
        <a href="<?php echo $url->url('members'); ?>" class="list-group-item list-group-item-action">👤 Manage Members</a>
        <a href="<?php echo $url->url('customer-subscriptions'); ?>" class="list-group-item list-group-item-action">💳 Manage Subscriptions</a>
        <a href="<?php echo $url->url('users'); ?>" class="list-group-item list-group-item-action">👤 Admin Users List</a>
        
        <p class="mt-3">Reports</p>
        <a href="<?php echo $url->url('late-fee'); ?>" class="list-group-item list-group-item-action">💳 Late Fee Report</a>
        <a href="<?php echo $url->url('revenue'); ?>" class="list-group-item list-group-item-action">💳 Revenue Report</a>
      
        <p class="mt-3">Settings</p>
        <a href="<?php echo $url->url('authors'); ?>" class="list-group-item list-group-item-action">👤 Manage Book Authors</a>
        <a href="<?php echo $url->url('categories'); ?>" class="list-group-item list-group-item-action">📚 Manage Book Categories</a>
    </div>
</div>