$UiSourceUrl = "https://github.com/Gethe/wow-ui-source"
# $UiSourceUrl = "https://github.com/BigWigsMods/WoWUI"
$UiSourceDir = "wow-ui-source"
# $UiBranches  = @("live", "ptr", "classic", "classic_beta", "classic_tbc_beta")
$UiBranches  = @("ptr")

if (-not (Test-Path $UiSourceDir)) {
    & git clone $UiSourceUrl $UiSourceDir
}

foreach ($Branch in $UiBranches) {
    Write-Output "Checking out UI source for $Branch..."
    & git -C $UiSourceDir clean -fdx
    & git -C $UiSourceDir checkout --force $Branch

    Write-Output "Stripping UTF8 BOM from files..."
    Get-ChildItem -Path $UiSourceDir -Recurse -Filter "*.lua" | ForEach-Object {
        (Get-Content $_) | ForEach-Object { $_ -replace "\xEF\xBB\xBF", "" } | Set-Content $_
    }

    Write-Output "Generating globals..."
    Get-ChildItem -Path $UiSourceDir -Recurse -Filter "*.lua" | ForEach-Object {
        luac5.1 -l -p $_ | lua5.1 D:\Ready\findglobals\globals.lua $_
    } | Sort-Object -Unique | Out-File -Path ".\API_${Branch}.txt"

    Write-Output "Generating LoD addons..."
    Select-String -Path .\wow-ui-source\Interface\AddOns\*\*.toc -Pattern "## LoadOnDemand: 1" | ForEach-Object {
        [IO.Path]::GetFileNameWithoutExtension($_.Filename)
    } | Sort-Object | Out-File -Path ".\LoD_${Branch}.txt"
}
