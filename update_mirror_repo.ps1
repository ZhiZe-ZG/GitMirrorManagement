# Update all mirror git repositories in the specified directory
param (
    [string]$workPath
)

$currentLocation = Get-Location

Set-Location $workPath

Get-ChildItem -Path $workPath -Directory | # Get all sub-directories
Where-Object {$_.Name -Match "\.git$"} | # End with ".git" 
ForEach-Object{
    $repoPath = $_.FullName
    Set-Location -Path $repoPath
    $nowPath = Get-Location
    Write-Output "Now update $nowPath"
    git fetch --all
    Set-Location -Path $workPath # return $workPath
}

Set-Location -Path $currentLocation # return start location
