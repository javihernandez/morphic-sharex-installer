<#
  This script creates the wix merge module for gpii-wix-installer.
#>

Push-Location (Split-Path -parent $PSCommandPath)

function Clean {
    rm temp\*.wixobj, temp\*.wxs, output\*.wixpdb
}

Clean

## create a fragment (.wxs file) with the "sharex" folder that contains sharex-portable
mkdir temp
heat dir sharex -dr ShareXDirectory -ke -srd -cg ShareXDirectory -gg -var var.buildFolder -out temp\ShareXDirectory.wxs

Remove-Item -Recurse output
mkdir output

## create the .wixobj files
candle sharex.wxs temp\ShareXDirectory.wxs -dbuildFolder=sharex -out temp\

## build the merge module
light temp\sharex.wixobj temp\ShareXDirectory.wixobj  -sacl -o output/sharex.msm

Clean
Pop-Location
