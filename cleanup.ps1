# Function to perform cleanup tasks based on client (LIVE or PTU)
function PerformCleanup {
    param (
        [string]$client
    )

    $targetPath = "C:\Program Files\Roberts Space Industries\StarCitizen"
    $userFolderPath = Join-Path -Path $targetPath -ChildPath "$client\USER"
    
    if (Test-Path -Path $userFolderPath) {
        Write-Host "Folder $userFolderPath exists. Deleting..."       
        Remove-Item -Path $userFolderPath -Recurse -Force
        Write-Host "Deleted $userFolderPath successfully."
    } else {
        Write-Host "Folder $userFolderPath does not exist. Skipping."
    }

    $localAppDataPath = [System.Environment]::ExpandEnvironmentVariables("%localappdata%\Star Citizen")

    if (Test-Path -Path $localAppDataPath) {
        Write-Host "Folder $localAppDataPath exists. Clearing contents..."    
        Get-ChildItem -Path $localAppDataPath | Remove-Item -Recurse -Force    
        Write-Host "Cleared contents of $localAppDataPath successfully."
    } else {
        Write-Host "Folder $localAppDataPath does not exist. Skipping."
    }
}

# Example usage for LIVE and PTU
# PerformCleanup -client "LIVE"
# PerformCleanup -client "PTU"

# Function to check Data.p4k file and take action based on client (LIVE or PTU)
function CheckDataP4k {
    param (
        [string]$client,
        [switch]$force = $false
    )

    $dataP4kPath = "C:\Program Files\Roberts Space Industries\StarCitizen\$client\Data.p4k"
    $timestampFile = "LastDataP4kTimestamp_$client.txt"

    if (Test-Path -Path $dataP4kPath) {
        $currentTimestamp = (Get-Item $dataP4kPath).LastWriteTime.ToString("o")

        if (Test-Path -Path $timestampFile) {
            $storedTimestamp = Get-Content $timestampFile

            if ($storedTimestamp -eq $currentTimestamp -and !$force) {
                Write-Host "No new patch detected for $client. Use -force to override."
                return
            }
        }

        # Call PerformCleanup function
        PerformCleanup -client $client

        # Update timestamp file
        $currentTimestamp | Out-File $timestampFile
    } else {
        Write-Host "Data.p4k not found for $client. Exiting."
    }
}

# Example usage for LIVE and PTU
CheckDataP4k -client "LIVE"
CheckDataP4k -client "PTU" -force
