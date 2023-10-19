$targetPath = "C:\Program Files\Roberts Space Industries\StarCitizen"

$foldersToCheck = @("PTU", "LIVE")

foreach ($folder in $foldersToCheck) {
    $userFolderPath = Join-Path -Path $targetPath -ChildPath "$folder\USER"
    
    if (Test-Path -Path $userFolderPath) {
        Write-Host "Folder $userFolderPath exists. Deleting..."       
        Remove-Item -Path $userFolderPath -Recurse -Force
        Write-Host "Deleted $userFolderPath successfully."
    } else {
        Write-Host "Folder $userFolderPath does not exist. Skipping."
    }
}

$localAppDataPath = [System.Environment]::ExpandEnvironmentVariables("%localappdata%\Star Citizen")

if (Test-Path -Path $localAppDataPath) {
    Write-Host "Folder $localAppDataPath exists. Clearing contents..."    
    Get-ChildItem -Path $localAppDataPath | Remove-Item -Recurse -Force    
    Write-Host "Cleared contents of $localAppDataPath successfully."
} else {
    Write-Host "Folder $localAppDataPath does not exist. Skipping."
}
