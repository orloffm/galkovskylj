﻿ param (
    [string]$filter = "GalkovskyLJ_?.asc"
 )
 
 # This script builds all years.

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$outputPath = Join-Path $scriptPath "output"

$sourceAscs = dir -path $scriptPath -filter "*$filter*"

$env:KINDLEGEN =  Join-Path $scriptPath 'resources\kindlegen.exe'

ForEach($sourceAsc in $sourceAscs){
	If([System.IO.Path]::GetExtension($sourceAsc) -ne ".asc"){
		continue
	}

    " "
    "===================="
    $sourceAsc.Name
    "===================="
    " "
	$nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($sourceAsc)
    $bookFile = ($scriptPath + "\" + $sourceAsc.Name)

    # "Converting to HTML..."
    # & bundle exec asciidoctor $bookFile

    "Converting to EPub..."
    $outputEpub = Join-Path $outputPath ($nameWithoutExt + ".epub")
    & bundle exec asciidoctor-epub3 $bookFile -o "$outputEpub$"

    # "Converting to Mobi (kf8)..."
    # & bundle exec asciidoctor-epub3 -a ebook-format=kf8 $bookFile

    "Converting to PDF..."
    $outputPdf = Join-Path $outputPath ($nameWithoutExt + ".A4.pdf")
    & bundle exec asciidoctor-pdf $bookFile -o "$outputPdf" -a pdf-style=resources/themes/galkovsky-theme.yml --trace
}

$outputPath = Join-Path $scriptPath "output"
if(!(Test-Path -Path $outputPath)) {
	mkdir $outputPath
}
else{
    #Remv ($outputPath + "\*") -Recurse
}

rm ($outputPath + "\*.pdfmarks")

#Write-Host "Moving files to output folder..."
#mv -Path ($scriptPath + "\*.html") -Destination $outputPath -Force
#rm ($scriptPath + "\*-kf8.epub")
#mv -Path ($scriptPath + "\*.epub") -Destination $outputPath -Force
#mv -Path ($scriptPath + "\*.mobi") -Destination $outputPath -Force
#rm ($scriptPath + "\*.pdfmarks")
#mv -Path ($scriptPath + "\*.pdf") -Destination $outputPath -Force

Write-Host "Finished!"