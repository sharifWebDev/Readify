<div class="container-fluid bg-info">
<nav class="navbar navbar-expand-lg">
    <a class="navbar-brand text-white" href="#">📘 Readify Admin</a>
    <div class="ms-auto">
        <span class="navbar-info text-white me-3">
            Welcome, <?= htmlspecialchars($_SESSION['admin']['email'] ?? '') ?>
        </span>
        <form action="/logout" method="POST" class="d-inline"> 
            <button type="submit" class="btn btn-outline-danger">Logout</button>
        </form>  
    </div> 
</nav>
</div>