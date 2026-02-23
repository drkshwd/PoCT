param(
    [string]$Username,
    [string]$Password
)

Write-Output "=== PoC-Win-App Setup ==="

# --- Create DB table and insert default user ---
$connStr = "Server=localhost;Database=poct;User Id=$Username;Password=$Password;"
$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$conn.Open()
$cmd = $conn.CreateCommand()

# Create users table
$cmd.CommandText = @"
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(100) NOT NULL,
    password NVARCHAR(100) NOT NULL
)
"@
$cmd.ExecuteNonQuery()
Write-Output "Table 'users' created"

# Insert admin user if not exists
$cmd.CommandText = @"
IF NOT EXISTS (SELECT * FROM users WHERE username='admin')
INSERT INTO users (username, password) VALUES ('admin', 'admin')
"@
$cmd.ExecuteNonQuery()
Write-Output "Admin user inserted"

$conn.Close()
Write-Output "Setup complete"