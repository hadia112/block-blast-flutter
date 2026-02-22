# Push Block Blast Flutter app to GitHub
# Run in PowerShell from this folder.

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (-not (Test-Path .git)) {
    git init
    git add .
    git commit -m "Initial commit: Block Blast Flutter frontend - modern blocks UI"
}

$repoName = "block-blast-flutter"
Write-Host "To push to GitHub:"
Write-Host "1. Create a new repository named '$repoName' at https://github.com/new"
Write-Host "2. Run:"
Write-Host "   git remote add origin https://github.com/YOUR_USERNAME/$repoName.git"
Write-Host "   git branch -M main"
Write-Host "   git push -u origin main"
Write-Host ""
Write-Host "Or with GitHub CLI (gh):"
Write-Host "   gh repo create $repoName --private --source=. --push"
