function Read-MirrorListFile {
    param (
        [string]$mirrorListFilePath
    )
    # Read the list of repositories from the file
    # Each line of this file is a URL of a repository
    # ignore blank lines
    $urlList = Get-Content -Path $mirrorListFilePath | Where-Object { $_ -match '\S' }
    return $urlList
}