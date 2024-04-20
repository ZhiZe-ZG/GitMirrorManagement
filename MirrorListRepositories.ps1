# Mirror all the repositories in the list
param (
    [string]$targetPath
)

$URLList = @(
    "https://github.com/ZhiZe-ZG/zhize-zg.github.io",
    "https://github.com/ZhiZe-ZG/GitMirrorManagement",
    "https://github.com/ZhiZe-ZG/FFmpegCompressionScript",
    "https://github.com/ZhiZe-ZG/sin-activator-paper"
)

# Get current location
$originalLocation = Get-Location

# Change to the target path
Set-Location $targetPath

# Clone all the repositories
$URLList | ForEach-Object {
    git clone --mirror $_
}

# Return to the original location
Set-Location -Path $originalLocation
