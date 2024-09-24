param (
    [Parameter(Mandatory = $true)]
    [string]$FolderPath,
    
    [Parameter(Mandatory = $false)]
    [int]$FilesToKeep = 5
)

# Ensure the folder path exists
if (-not (Test-Path -Path $FolderPath -PathType Container)) {
    Write-Error "The specified folder path does not exist: $FolderPath"
    exit 1
}

# Get all log files in the folder, sorted by last write time descending
$logFiles = Get-ChildItem -Path $FolderPath -Filter "*.log" | Sort-Object LastWriteTime -Descending

# Calculate the number of files to delete
$filesToDelete = $logFiles.Count - $FilesToKeep

if ($filesToDelete -le 0) {
    Write-Output "No files to delete. There are $($logFiles.Count) log files, which is less than or equal to the specified number to keep ($FilesToKeep)."
    exit 0
}

# Skip the n most recent files and delete the rest
$logFiles | Select-Object -Skip $FilesToKeep | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Output "Deleted file: $($_.Name)"
}

Write-Output "Deleted $filesToDelete log files. Kept the $FilesToKeep most recent files."