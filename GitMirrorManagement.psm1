function MirrorListRepositories (
    [string]$mirrorListFile,
    [string]$mirrorRootPath
) {
    Write-Host "Starting to mirror all the repositories in the list..."
    # Mirror all the repositories in the list
    # If the repository already exists, update it

    # Read the list of repositories from the file
    # Each line of this file is a URL of a repository
    $URLList = Get-Content -Path $mirrorListFile

    $FailedList = @()

    # Clone all the repositories
    $URLList | ForEach-Object {
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
                    throw "Command failed with exit code $LASTEXITCODE"
                }
                Set-Location -Path $originalPath
            }
            else {
                Write-Host -ForegroundColor Yellow "Cloning $repoName to $localPath"
                git clone --mirror $_ $localPath
                if ($LASTEXITCODE -ne 0) {
                    throw "Command failed with exit code $LASTEXITCODE"
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

function CompressRepositories(
    [string]$InPath,
    [string]$OutPath,
    [string]$7zPath = "7z"
) {
    # Get all child folders in the specified path
    $folders = Get-ChildItem -Path $InPath -Directory

    # Loop through each folder
    foreach ($folder in $folders) {

        if ($folder.Name -match "\.git$") {
            # Define the name of the archive (folder name + .zip)
            $archiveName = $folder.Name + ".7z"
            $archivePath = Join-Path -Path $OutPath -ChildPath $archiveName
            $files = Get-ChildItem -Path $folder.FullName

            # Use 7-Zip to compress the folder
            & $7zPath a -t7z  -sccUTF-8 -scsUTF-8 $archivePath $files
        }
    }
        
}

Export-ModuleMember -Function 'MirrorListRepositories'
Export-ModuleMember -Function 'CompressRepositories'
