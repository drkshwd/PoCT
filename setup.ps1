param(
    [string]$Username,
    [string]$Password,
    [string]$AD_Username,
    [string]$AD_Password
)

Write-Output "=== PoC-Win-App Setup ==="

# --- STEP 1: Create DB table ---
# $connStr = "Server=localhost;Database=poct;User Id=$Username;Password=$Password;"
# $conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
# $conn.Open()
# $cmd = $conn.CreateCommand()

# $cmd.CommandText = @"
# IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
# CREATE TABLE users (
#     id INT IDENTITY(1,1) PRIMARY KEY,
#     username NVARCHAR(100) NOT NULL,
#     password NVARCHAR(100) NOT NULL
# )
# "@
# $cmd.ExecuteNonQuery()
# Write-Output "Table 'users' created"

# $conn.Close()

# --- STEP 2: Validate AD Authentication ---
Write-Output "Validating AD authentication..."

try {
    $ldap = New-Object System.DirectoryServices.DirectoryEntry(
        "LDAP://POCLAB",
        "POCLAB\$AD_Username",
        $AD_Password
    )
    $test = $ldap.NativeObject
    Write-Output "AD validation PASSED"
} catch {
    Write-Output "AD validation FAILED - $_"
}

Write-Output "Setup complete"