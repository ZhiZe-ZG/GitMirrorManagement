function Sync-Repositories (
    [string[]]$urlList,
    [string]$mirrorRootPath,
    [bool]$enableGitLFS = $true
) {
    Write-Host "Starting to mirror all the repositories in the list..."
    # Mirror all the repositories in the list
    # If the repository already exists, update it

    # Check if the git lfs is installed
    if ($enableGitLFS) {
        $gitLFSPath = Get-Command git-lfs -ErrorAction SilentlyContinue
        if ($null -eq $gitLFSPath) {
            Write-Host -ForegroundColor Red "Git LFS is not installed, please install it first"
            return
        }
    }

    $FailedList = @()

    # Clone all the repositories
    $urlList | ForEach-Object {
        # get the last part of the URL as the name of the repository
        $repoName = $_ -split "/" | Select-Object -Last 1
        # check if the repoName ends with ".git"
        if ($repoName -notmatch "\.git$") {
            $repoName += ".git"
        }
        $localPath = Join-Path -Path $mirrorRootPath -ChildPath $repoName
        # check if the localPath exists
        try {
            if (Test-Path $localPath) {
                Write-Host -ForegroundColor Yellow "$repoName already exists, now updating"
                $originalPath = Get-Location
                Set-Location -Path $localPath
                git fetch --all
                if ($LASTEXITCODE -ne 0) {
                    throw "git fetch failed with exit code $LASTEXITCODE"
                }
                if ($enableGitLFS) {
                    git lfs fetch --all
                    if ($LASTEXITCODE -ne 0) {
                        throw "git lfs fetch failed with exit code $LASTEXITCODE"
                    }
                }
                Set-Location -Path $originalPath
            }
            else {
                Write-Host -ForegroundColor Yellow "Cloning $repoName to $localPath"
                git clone --mirror $_ $localPath
                if ($LASTEXITCODE -ne 0) {
                    throw "git clone failed with exit code $LASTEXITCODE"
                }
                if ($enableGitLFS) {
                    $originalPath = Get-Location
                    Set-Location -Path $localPath
                    git lfs fetch --all
                    if ($LASTEXITCODE -ne 0) {
                        throw "git lfs fetch failed with exit code $LASTEXITCODE"
                    }
                    Set-Location -Path $originalPath
                }
            }
        }
        catch {
            # add the URL to FailedList
            $FailedList += $repoName
        }
    }

    # Show all failed
    # check if the FailedList is empty
    if ($FailedList.Count -eq 0) {
        Write-Host -ForegroundColor Green "All repositories are cloned or updated successfully" 
    }
    else {
        Write-Host -ForegroundColor Red "Failed to clone or update the following repositories:" 
        $FailedList | ForEach-Object {
            Write-Output $_
        }
    }
}