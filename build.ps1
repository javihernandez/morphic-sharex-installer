<#
  This script creates the wix merge module for gpii-wix-installer.
  It assumes that the dependencies are already in place under deps folder.
#>

Push-Location (Split-Path -parent $PSCommandPath)

function Clean {
    rm -r temp, output, build
}

Clean

Write-Output "Prepare build folder"
mkdir build

## sharex folder content
cp -r sharex\* build\

## copy deps
# ffmpeg.exe
mkdir build\ffmpeg
cp deps\ffmpeg-4.1.1-win64-static\bin\ffmpeg.exe build\ffmpeg\

# node.exe
cp deps\node.exe build\sharex-configurator\

# vcredist_x64.exe
#cp deps\vcredist_x64.exe build\sharex-portable\

Write-Output "Generate fragment (.wxs file) with build folder"
mkdir temp
heat dir build -dr ShareXDirectory -ke -srd -cg ShareXDirectory -gg -var var.buildFolder -out temp\ShareXDirectory.wxs

Write-Output "Generating .wixobj files"
candle sharex.wxs temp\ShareXDirectory.wxs -dbuildFolder=build -out temp\

Write-Output "Building merge module"
mkdir output
light temp\sharex.wixobj temp\ShareXDirectory.wixobj  -sacl -o output/sharex.msm

Pop-Location
