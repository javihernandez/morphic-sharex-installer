<#
  This script creates the wix merge module for gpii-wix-installer.
  It assumes that the dependencies are already in place under deps folder.
#>

Push-Location (Split-Path -parent $PSCommandPath)

function Clean {
    if (Test-Path -Path "temp"){
        rm temp -Recurse -Force
    }
    if (Test-Path -Path "output"){
        rm output -Recurse -Force
    }
    if (Test-Path -Path "build"){
        rm build -Recurse -Force
    }
}

Clean

Write-Output "Prepare build folder"
mkdir build

## sharex folder content
cp -r sharex\* build\

Write-Output "Generate fragment (.wxs file) with build folder"
mkdir temp
heat dir build -dr ShareXDirectory -ke -srd -cg ShareXDirectory -gg -var var.buildFolder -out temp\ShareXDirectory.wxs

Write-Output "Generating .wixobj files"
candle sharex.wxs temp\ShareXDirectory.wxs -dbuildFolder=build -out temp\

Write-Output "Building merge module"
mkdir output
light temp\sharex.wixobj temp\ShareXDirectory.wixobj  -sacl -o output/sharex.msm

Pop-Location
