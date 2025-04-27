<nav class="navbar navbar-expand-lg navbar-light bg-light px-4">
    <a class="navbar-brand" href="#">📘 Readify Admin</a>
    <div class="ms-auto">
        <span class="navbar-text text-white me-3">
            Welcome, <?= htmlspecialchars($_SESSION['admin']['email'] ?? '') ?>
        </span>
        <form action="/logout" method="POST" class="d-inline"> 
            <button type="submit" class="btn btn-outline-danger">Logout</button>
        </form>  
    </div> 
</nav>