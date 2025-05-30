#!/usr/bin/env pwsh

<#
    .SYNOPSIS
    Compiles TeX project into PDF document.

    .DESCRIPTION
    This script can be used to compile the LaTeX project.
    The main TeX file, the build directory and the name of the document can be specified.
    If parameters are omitted, useful defaults are taken (see parameter description).
    Even sub folders can be compiled into separate PDF file by specifying 
    the sub folders's TeX file.
    If the build path is not specified, a build folder named "build" will be created next to the
    TeX file.

    .INPUTS
    None. You cannot pipe objects into this script.

    .OUTPUTS
    None. The output is undefined.

    .LINK
    https://github.com/ixik-melissa/maya-decipherment
#>

[CmdletBinding()]
param (
    [string]
    # The TeX file to be compiled.
    [Parameter(HelpMessage="Enter LaTeX file to compile.")]
    $TexPath = "main.tex",

    [string]
    # The path to the output directory. The final document will be placed there, too.
    [Parameter(HelpMessage="Enter path in which output files can be stored.")]
    $BuildPath="build",

    [string]
    # The file name of the PDF document.
    [Parameter(HelpMessage="Enter name of the final PDF document.")]
    $DocumentName="$((Get-Item $TexPath).BaseName)"
)

function Write-Summary {
    Write-Output "Compiling to $BuildPath/$DocumentName.pdf"
    Write-Output ""
    Write-Output "Settings:"
    Write-Output "  Name of document: $DocumentName"
    Write-Output "  Tex file:         $TexPath"
    Write-Output "  Build path:       $BuildPath"
    Write-Output ""
    Write-Output "Invoking latexmk..."
    Write-Output ""
}

function Invoke-LaTeX {
    if (!(Test-Path $TexPath -PathType Leaf)) {
        Write-Error "Tex file $TexPath doesn't exist"
        Exit 1
    }

    $SourcePath = (Get-Item $TexPath).Directory

    Set-Location -Path "$SourcePath"
    latexmk `
        -cd `
        -synctex=1 `
        -interaction=nonstopmode `
        -file-line-error `
        -pdf `
        -Werror `
        -jobname="$DocumentName" `
        -outdir="$BuildPath" `
        "$TexPath"
}

Write-Summary
Invoke-LaTeX
