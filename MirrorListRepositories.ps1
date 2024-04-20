# Mirror all the repositories in the list
# If the repository already exists, update it
param (
    [string]$targetPath
)

$URLList = @(
    "https://github.com/ZhiZe-ZG/zhize-zg.github.io",
    "https://github.com/ZhiZe-ZG/GitMirrorManagement",
    "https://github.com/ZhiZe-ZG/FFmpegCompressionScript",
    "https://github.com/ZhiZe-ZG/sin-activator-paper"
)

$FailedList = @()

# Clone all the repositories
$URLList | ForEach-Object {
    # get the last part of the URL as the name of the repository
    $repoName = $_ -split "/" | Select-Object -Last 1
    # check if the repoName ends with ".git"
    if ($repoName -notmatch "\.git$") {
        $repoName += ".git"
    }
    $localPath = Join-Path -Path $targetPath -ChildPath $repoName
    # check if the localPath exists
    if (Test-Path $localPath) {
        Write-Output "$repoName already exists, now updating"
        $originalPath = Get-Location
        Set-Location -Path $localPath
        git fetch --all
        Set-Location -Path $originalPath
    }
    else {
        try {
            Write-Output "Cloning $repoName to $localPath"
            git clone --mirror $_ $localPath
            if ($LastExitCode -ne 0) {
                throw "Command failed with exit code $LastExitCode"
            }
        }
        catch {
            # add the URL to FailedList
            $FailedList += $repoName
        }
    }
}

# Show all failed
# check if the FailedList is empty
if ($FailedList.Count -eq 0) {
    Write-Host -ForegroundColor Green "All repositories are cloned successfully" 
    exit 0
}
else {
    Write-Host -ForegroundColor Red "Failed to clone the following repositories:" 
    $FailedList | ForEach-Object {
        Write-Output $_
    }
    exit 1
}
