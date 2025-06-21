$UiSourceUrl = "https://github.com/Gethe/wow-ui-source"
$UiSourceDir = "wow-ui-source"
$UiBranches  = @("ptr2")

if (-not (Test-Path $UiSourceDir)) {
    & git clone $UiSourceUrl $UiSourceDir
}

foreach ($Branch in $UiBranches) {
    Write-Output "Checking out UI source for $Branch..."
    & git -C $UiSourceDir clean -fdx
    & git -C $UiSourceDir checkout --force $Branch

    Write-Output "Generating LoD addons..."
    Select-String -Path $UiSourceDir\Interface\AddOns\*\*.toc -Pattern "## LoadOnDemand: 1" | ForEach-Object {
        [IO.Path]::GetFileNameWithoutExtension($_.Filename)
    } | Sort-Object | Out-File -FilePath ".\LoD_${Branch}.txt"
}
