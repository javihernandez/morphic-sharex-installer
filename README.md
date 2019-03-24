# ShareX-Portable installer merge module for Morphic

This produces `sharex.msm`, which is used by gpii-wix-installer to bundle ShareX-Portable with Morphic. This will make the
Morphic installer to install ShareX-Portable.

## Content of this repo:
 * sharex-portable
 * sharex-configurator

We also pull the following dependencies:
 * ffmpeg
 * node.js
 * Microsoft Visual C++ 2010 Redistributable Package (x64)
 https://download.microsoft.com/download/3/2/2/3224B87F-CFA0-4E70-BDA3-3DE650EFEBA5/vcredist_x64.exe

## Usage

* Run [build.ps1](build.ps1)
* Take `output/filebeat.msm`.
