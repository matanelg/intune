if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Err. Need to run as admin"
    exit 1
}

Write-Host "Update WSL..."
wsl --update


Write-Host "WSL is updated"
exit 0
