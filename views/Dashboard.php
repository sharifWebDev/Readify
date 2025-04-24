
<!-- // File: views/dashboard.php -->
 
<h1>Welcome, <?= $_SESSION['admin']->email ?></h1>
<a href="/">Logout</a>

<ul>
        <li><a href="books">Books</a></li>
        <li><a href="members">Members</a></li>
        <li><a href="subscriptions">Subscriptions</a></li>
        <li><a href="logout">Logout</a></li>
    </ul>
