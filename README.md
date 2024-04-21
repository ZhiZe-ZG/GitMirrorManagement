# GitMirrorManagement

Some PowerShell to manage mirroring and backups of my git repository.

## Install

In your PowerShell profile (refer to [About Profiles](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.4)) add:

```powershell
Import-Module GitMirrorManagement.psm1
```

You can replace `GitMirrorManagement.psm1` with the actual path of it.

## Usage

Mirror git repositories:

```powershell
MirrorListRepositories /where/to/save/repos
```

Compress repositories:

```powershell
CompressRepositories /where/the/repos/is /where/to/save/archives
```

## Tricks

"OneDrive will automatically sync the PowerShell startup script. This can be used to automatically configure on multiple computers.
