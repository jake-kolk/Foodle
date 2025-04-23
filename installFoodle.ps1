# Function to check if Git is installed
function Is-GitInstalled {
    return (Get-Command git -ErrorAction SilentlyContinue) -ne $null
}

# Install Git if not installed
if (-not (Is-GitInstalled)) {
    Write-Host "Git is not installed. Installing Git via winget..."

    # Ensure winget is available
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
    } else {
        Write-Error "winget is not available on this system. Please install Git manually."
        exit 1
    }

    # Attempt to update PATH in current session (not global or user-wide)
    $gitPath = "$env:ProgramFiles\Git\cmd"
    if (Test-Path $gitPath) {
        $env:PATH += ";$gitPath"
        Write-Host "Temporarily added Git to PATH for this session: $gitPath"
    } else {
        Write-Warning "Git installation path not found. You may need to restart PowerShell manually."
    }
} else {
    Write-Host "Git is already installed."
}

# Set variables
$repoUrl = "https://github.com/jake-kolk/Foodle"  
$clonePath = "$env:USERPROFILE\Foodle"
$exePath = "$clonePath\AiFoodFinder.exe"
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "Foodle.lnk"

# Debug
Write-Host "Repository URL: $repoUrl"
Write-Host "Clone path: $clonePath"
Write-Host "Expected .exe path: $exePath"

# Clone the Git repository if it doesn't exist
if (-not (Test-Path $clonePath)) {
    git clone $repoUrl $clonePath
} else {
    Write-Host "Repo already exists at $clonePath"
}

# Check if the .exe file exists before creating the shortcut
if (Test-Path $exePath) {
    Write-Host ".exe found at: $exePath"
    
    try {
        $WshShell = New-Object -ComObject WScript.Shell
        $shortcut = $WshShell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $exePath
        $shortcut.WorkingDirectory = Split-Path $exePath
        $shortcut.Save()
        Write-Host "Shortcut created on Desktop: $shortcutPath"
    } catch {
        Write-Error "Failed to create shortcut: $_"
    }
} else {
    Write-Error ".exe not found at expected path: $exePath"
}

Pause
