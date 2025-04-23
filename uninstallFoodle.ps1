# Set paths
$clonePath = "$env:USERPROFILE\Foodle"
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "Foodle.lnk"

# Remove the shortcut
if (Test-Path $shortcutPath) {
    Remove-Item $shortcutPath -Force
    Write-Host "Removed shortcut: $shortcutPath"
} else {
    Write-Host "Shortcut not found: $shortcutPath"
}

# Remove the cloned repository folder
if (Test-Path $clonePath) {
    Remove-Item $clonePath -Recurse -Force
    Write-Host "Removed cloned repo: $clonePath"
} else {
    Write-Host "Cloned repo not found: $clonePath"
}

# Check if Git is installed
function Is-GitInstalled {
    return (Get-Command git -ErrorAction SilentlyContinue) -ne $null
}

# Prompt user to uninstall Git if installed
if (Is-GitInstalled) {
    Write-Host "Git is installed."
    $userResponse = Read-Host "Do you want to uninstall Git? (y/n)"
    
    if ($userResponse -eq 'y' -or $userResponse -eq 'Y') {
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            Write-Host "Attempting to uninstall Git via winget..."
            winget uninstall --id Git.Git -e --source winget
        } else {
            Write-Warning "winget is not available. Please uninstall Git manually."
        }
    } else {
        Write-Host "Skipped uninstallation of Git."
    }
} else {
    Write-Host "Git is not currently installed."
}

Pause

