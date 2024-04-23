function Read-MirrorListFile {
    param (
        [string]$mirrorListFilePath
    )
    # Read the list of repositories from the file
    # Each line of this file is a URL of a repository
    # ignore blank lines and lines start with `#`
    $urlList = Get-Content -Path $mirrorListFilePath | Where-Object { $_ -match '\S' } | Where-Object { $_ -notmatch '^#' }
    return $urlList
}