. $PSScriptRoot/BackupDriver.ps1
. $PSScriptRoot/CompressionOperations.ps1
. $PSScriptRoot/ConfigurationFileOperations.ps1
. $PSScriptRoot/GitOperations.ps1

$exportModuleMemberParams = @{
    Function = @(
        "Backup-GitRepositories",
        "Compress-Repositories",
        "Read-MirrorListFile",
        "Sync-Repositories"
    )
}

Export-ModuleMember @exportModuleMemberParams