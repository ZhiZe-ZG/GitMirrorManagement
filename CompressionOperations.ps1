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