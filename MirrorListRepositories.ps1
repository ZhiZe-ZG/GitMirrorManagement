# Mirror all the repositories in the list
param (
    [string]$targetPath
)

$URLList = @(
    "https://github.com/ZhiZe-ZG/zhize-zg.github.io",
    "https://github.com/ZhiZe-ZG/GitMirrorManagement.git",
    "https://github.com/ZhiZe-ZG/FFmpegCompressionScript",
    "https://github.com/ZhiZe-ZG/sin-activator-paper"
)

# Clone all the repositories
$URLList | ForEach-Object {
    # get the last part of the URL as the name of the repository
    $repoName = $_ -split "/" | Select-Object -Last 1
    # check if the repoName ends with ".git"
    if ($repoName -notmatch "\.git$") {
        $repoName += ".git"
    }
    $localPath = Join-Path -Path $targetPath -ChildPath $repoName
    git clone --mirror $_ $localPath
}

