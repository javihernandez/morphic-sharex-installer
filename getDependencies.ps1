<#
  This script creates the wix merge module for gpii-wix-installer.
#>

Push-Location (Split-Path -parent $PSCommandPath)

## get dependencies
mkdir deps

## Download ffmpeg
$ffmpegDownloadUrl = "https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-4.1.1-win64-static.zip"
Write-Output "Downloading ffmpeg from $ffmpegDownloadUrl"
try {
    $r1 = iwr $ffmpegDownloadUrl -OutFile deps/ffmpeg-4.1.1-win64-static.zip
} catch {
    Write-Error "ERROR: Couldn't download ffmpeg. Error was $_"
    exit 1
}

## Unzip ffmpeg
Expand-Archive deps/ffmpeg-4.1.1-win64-static.zip -DestinationPath deps

## Download nodejs
$nodeDownloadUrl = "https://nodejs.org/dist/v10.15.3/win-x86/node.exe"
Write-Output "Downloading Node.js from $nodeDownloadUrl"
try {
    $r1 = iwr $nodeDownloadUrl -OutFile deps/node.exe
} catch {
    Write-Error "ERROR: Couldn't download Node.js. Error was $_"
    exit 1
}

## Download Microsoft Visual C++ 2010 Redistributable Package (x64)
$vcredistx64DownloadUrl = "https://download.microsoft.com/download/3/2/2/3224B87F-CFA0-4E70-BDA3-3DE650EFEBA5/vcredist_x64.exe"
Write-Output "Downloading MS Visual C++ 2010 Redistributable Package (x64) from $vcredistx64DownloadUrl"
try {
    $r1 = iwr $vcredistx64DownloadUrl -OutFile deps/vcredist_x64.exe
} catch {
    Write-Error "ERROR: Couldn't download Visual C++ Redistributable. Error was $_"
    exit 1
}
