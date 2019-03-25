# ShareX-Portable installer merge module for Morphic

This produces `sharex.msm`, which is used by gpii-wix-installer to bundle ShareX-Portable with Morphic. This will make the
Morphic installer to install ShareX-Portable.

## Content of this repo:

* sharex-portable
* sharex-configurator

We also pull the following dependencies:

* ffmpeg
* Node.js
* Microsoft Visual C++ 2010 Redistributable Package (x64)

## Usage

* Run the [getDependencies.ps1](getDependencies.ps1) script to grab the dependencies. This only needs to be run once unless you need to grab the dependencies again.
* Run the [build.ps1](build.ps1) script to build the merge module. This will generate a `sharex.msm` file into the output folder.
