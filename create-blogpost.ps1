<#
.SYNOPSIS
This script takes a Plaster splat object and invokes the PlasterManifest for a new blog post to alainassaf.com.
It also grabs an image from Pixabay, renames it, and saves it the apprpriate folder as the main image of the blog post.
.DESCRIPTION
This script takes a Plaster splat object and invokes the PlasterManifest for a new blog post to alainassaf.com.
It also grabs an image from Pixabay, renames it, and saves it the apprpriate folder as the main image of the blog post.
.PARAMETER PlasterSplat
A hashtable with the Plaster manifest parameters.
Example:
$SplatExample = @{
	Title = "This Is a Test Post"
	TemplatePath ="D:\Codevault\PoSH\blog\new_alainassaf_post"
	DestinationPath = "D:\Codevault\PoSH\blog\alainassaf.github.io"
	subtitle = "Yes"
	SubTitleText = "This is a test subtitle"
	Tags = "test,post"
	Date = get-date -Format yyyy-MM-dd
}
.EXAMPLE
Create a hashtable with the Plaster manifest parameters.
$plaster = @{
	Title = "This Is a Test Post"
	TemplatePath ="D:\Codevault\PoSH\blog\new_alainassaf_post"
	DestinationPath = "D:\Codevault\PoSH\blog\alainassaf.github.io"
	subtitle = "Yes"
	SubTitleText = "This is a test subtitle"
	Tags = "test,post"
	Date = get-date -Format yyyy-MM-dd
}
.INPUTS
Hashtable with Plaster manifest variables
.OUTPUTS
None
.NOTES
NAME: create-blogpost.ps1
VERSION: 0.0.1
CHANGE LOG - Version - When - What - Who
0.0.1 - 08/12/2023 - Initial script - Alain Assaf
AUTHOR: Alain Assaf
LASTEDIT: August 12, 2023
.LINK
http: //www.linkedin.com/in/alainassaf/
#>
#Requires -Modules Plaster

[CmdletBinding()]
param (
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[System.Collections.Hashtable]$PlasterSplat
)

if (Test-Path $PlasterSplat.TemplatePath) {
	if (Test-Path $PlasterSplat.DestinationPath) {
		Write-Verbose "PlasterSplat param: $PlasterSplat"
		Invoke-Plaster @PlasterSplat
	} else {
		Write-Warning "[$PlasterSplat.DestinationPath] not found"
	}
} else {
	Write-Warning "[$PlasterSplat.TemplatePath] not found"
}
