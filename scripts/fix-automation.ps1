# Fix Buddhist healing daily automation trigger
# Run: powershell -ExecutionPolicy Bypass -File scripts\fix-automation.ps1

Write-Host ""
Write-Host "=== Buddhist Healing Daily - Automation Fix ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Issue A: Trigger is Pull Request -> set Schedule 08:00 GMT+8" -ForegroundColor Yellow
Write-Host "Issue B: Report stuck in Draft PR -> paste AUTOMATION-PROMPT.md (direct push to main)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Steps in Cursor (about 30 seconds):" -ForegroundColor Green
Write-Host "  1. Left sidebar -> Automations"
Write-Host "  2. Click: Buddhist healing daily report"
Write-Host "  3. Settings -> Trigger: remove Pull Request, set Schedule"
Write-Host "  4. Every day at 08:00 GMT+8"
Write-Host "  5. Repository: op9bot-commits/buddhist-healing-daily / main"
Write-Host "  6. Instructions: paste AUTOMATION-PROMPT.md"
Write-Host "  7. Save, then Run to test"
Write-Host ""

$cursorPath = "D:\cursor new\resources\app\bin\cursor.cmd"
$repoPath = "d:\CURSOR\buddhist-healing-daily"

if (Test-Path $cursorPath) {
    Write-Host "Opening Cursor repo..." -ForegroundColor Gray
    & $cursorPath $repoPath
}

Start-Process "https://cursor.com/dashboard?tab=automations"
Write-Host "Opened Cursor and Automations dashboard." -ForegroundColor Cyan
Write-Host ""
