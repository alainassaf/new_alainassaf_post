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
.PARAMETER PathToGetPixabayFunction
Mandatory string parameter that is the full path to the get-pixabayimage.ps1 function.
This function is used to query the Pixabay website (using REST api) for an image
.PARAMETER ImageQuery
Mandatory string parameter to use for the Pixabay image query
.PARAMETER ImageCategory
Mandatory string parameter used for the Pixabay image category.
Must be one of the following values: 	backgrounds
										fashion
										nature
										science
										education
										feelings
										health
										people
										religion
										places
										animals
										industry
										computer
										food
										sports
										transportation
										travel
										buildings
										business
										music
.PARAMETER ImageColor
Optional string parameter used for the Pixabay image color.
Must be one of the following values: 	grayscale
										transparent
										red
										orange
										yellow
										green
										turquoise
										blue
										lilac
										pink
										white
										gray
										black
										brown
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

.\create-blogpost.ps1 -PlasterSplat $plaster -PathToGetPixabayFunction $pathToFunc -ImageQuery "flowers" -ImageCategory "backgrounds" -ImageColor "red" -Verbose
.INPUTS
Hashtable with Plaster manifest variables
.OUTPUTS
None
.NOTES
NAME: create-blogpost.ps1
VERSION: 1.0.2
CHANGE LOG - Version - When - What - Who
0.0.1 - 08/12/2023 - Initial script - Alain Assaf
0.0.2 - 09/11/2023 - Updated param for get-pixabayimage function - Alain Assaf
1.0.0 - 09/15/2023 - Added more comments - Alain Assaf
1.0.1 - 09/15/2023 - Made ImageColor optional param - Alain Assaf
1.0.2 - 09/18/2023 - Fixed spelling - Alain Assaf
AUTHOR: Alain Assaf
LASTEDIT: September 18, 2023
.LINK
http: //www.linkedin.com/in/alainassaf/
#>
#Requires -Modules Plaster

[CmdletBinding()]
param (
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[System.Collections.Hashtable]$PlasterSplat,

	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$PathToGetPixabayFunction,

	[parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$ImageQuery,

	[Parameter(Mandatory)]
	[ValidateSet("backgrounds", "fashion", "nature", "science", "education", "feelings", "health", "people", "religion", "places", "animals", "industry", "computer", "food", "sports", "transportation", "travel", "buildings", "business", "music")]
	$ImageCategory,

	[Parameter()]
	[ValidateSet("grayscale", "transparent", "red", "orange", "yellow", "green", "turquoise", "blue", "lilac", "pink", "white", "gray", "black", "brown")]
	$ImageColor
)

#region variables
$datetime = Get-Date -Format "MM-dd-yyyy_HH-mm"
$ScriptRunner = (Get-ChildItem env:username).value
$compname = (Get-ChildItem env:COMPUTERNAME).value
$scriptName = $MyInvocation.MyCommand.Name
$currentDir = Split-Path $MyInvocation.MyCommand.Path
#endregion

# Check paths
if (Test-Path $PathToGetPixabayFunction) {
	. $PathToGetPixabayFunction
	if (Test-Path $PlasterSplat.TemplatePath) {
		if (Test-Path $PlasterSplat.DestinationPath) {
			Write-Verbose "PlasterSplat param: $PlasterSplat"
			# Create blog post template
			Invoke-Plaster @PlasterSplat
		} else {
			Write-Warning "[$PlasterSplat.DestinationPath] not found"
			exit 1
		}
	} else {
		Write-Warning "[$PlasterSplat.TemplatePath] not found"
		exit 1
	}
} else {
	Write-Warning "[$PathToGetPixabayFunction] not found"
	exit 1
}

#Get name for main blog image
$blogImageName = $plaster.Title.replace(' ', '-').tolower() + ".jpg"
Write-Verbose "Main blog image name: [$blogImageName]"

#Query Pixabay for blog image
if ($ImageColor) {
	get-pixabayImage -query $ImageQuery -category $ImageCategory -color $ImageColor
} else {
	get-pixabayImage -query $ImageQuery -category $ImageCategory
}

Start-Sleep -Seconds 5

$BlogImage = Get-ChildItem -Path $currentDir -Filter "*.jpg"
Write-Verbose "Found image: [$BlogImage]"

#Rename and move image to blog location
$newImageName = Rename-Item -Path $BlogImage -NewName $blogImageName -PassThru
$newImagePath = $PlasterSplat.DestinationPath + "\assets\img\" + $plaster.Title.Replace(' ', '-').tolower()

if (Test-Path $newImagePath) {
	Move-Item $newImageName.FullName -Destination $newImagePath
} else {
	Write-Warning "Cannot find [$newImagePath]"
}

#End script info
Write-Verbose "SCRIPT NAME: $scriptName"
Write-Verbose "SCRIPT PATH: $currentDir"
Write-Verbose "SCRIPT RUNTIME: $datetime"
Write-Verbose "SCRIPT USER: $ScriptRunner"
Write-Verbose "SCRIPT SYSTEM: $compname.$domain"