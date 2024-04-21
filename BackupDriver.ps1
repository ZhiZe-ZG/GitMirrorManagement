. $PSScriptRoot/CompressionOperations.ps1
. $PSScriptRoot/ConfigurationFileOperations.ps1
. $PSScriptRoot/GitOperations.ps1

function Backup-GitRepositories {
    param (
       [string]$mirrorListFilePath,
       [string]$mirrorRootPath,
       [string]$archiveRootPath,
       [bool]$enableGitLFS = $true
    )
    # Read the list of repositories from the file
    $urlList = Read-MirrorListFile -mirrorListFilePath $mirrorListFilePath
    # Sync all the repositories
    Sync-Repositories -urlList $urlList -mirrorRootPath $mirrorRootPath -enableGitLFS $enableGitLFS
    # Compress all the repositories
    Compress-Repositories -inPath $mirrorRootPath -outPath $archiveRootPath
}