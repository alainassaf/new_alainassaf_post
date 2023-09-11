function get-pixabayImage {
    [CmdletBinding()]
    param (
        [parameter(Position = 0, Mandatory = $True )] 	
        [ValidateNotNullOrEmpty()]
        [string]$query,

        [Parameter(Mandatory = $true)]
        [ValidateSet("backgrounds", "fashion", "nature", "science", "education", "feelings", "health", "people", "religion", "places", "animals", "industry", "computer", "food", "sports", "transportation", "travel", "buildings", "business", "music")]
        $category,

        [Parameter(Mandatory = $false)]
        [ValidateSet("grayscale", "transparent", "red", "orange", "yellow", "green", "turquoise", "blue", "lilac", "pink", "white", "gray", "black", "brown")]
        $color,

        #Pixabay apikey - alainassaf
        [parameter(Mandatory = $false)]
        [string]$apikey = "16095181-874ece02ee0c7869c6579cc63"
    )
    
    #region variables
    $datetime = Get-Date -Format "MM-dd-yyyy_HH-mm"
    $ScriptRunner = (Get-ChildItem env:username).value
    $compname = (Get-ChildItem env:COMPUTERNAME).value
    $scriptName = $MyInvocation.MyCommand.Name
    $scriptpath = $MyInvocation.MyCommand.Path
    $error.clear()
    #endregion

    $picFilename = (Get-Date).tostring("yyyy-MM-dd-hh-mm-ss")
    $picFilename = $picFilename + ".jpg"

    #Reform query to URL encoded search term
    $URLSearch = $query.Replace(" ", "+")

    if ($null -ne $color) {
        $Body = @{
            key         = $apikey
            q           = $URLSearch
            category    = $category
            lang        = "en"
            image_type  = "photo"
            orientation = "horizontal"
            safesearch  = $true
        }
    }
    else {
        $Body = @{
            key         = $apikey
            q           = $URLSearch
            category    = $category
            lang        = "en"
            image_type  = "photo"
            orientation = "horizontal"
            safesearch  = $true
            color       = $color
        }
    }

    $splat = @{
        URI    = "https://pixabay.com/api/"
        Method = "Get"
        Body   = $Body
    }

    try {
        $pixabay_query = Invoke-RestMethod @splat
    }
    catch {
        Write-Warning "Failed to query Pixabay"
        break
    }
     
    if ($pixabay_query.totalHits -eq 0) {
        Write-Warning "No query results"
        Break
    }
    else {
        $picPath = Split-Path -parent $PSCommandPath
        Write-Verbose "Filepath: [$PSScriptRoot]"
        # Default items per page from pixabay is 20
        $randomHit = Get-Random -Minimum 1 -Maximum 20
        $img = $pixabay_query.hits[$randomHit]
        #Invoke-WebRequest -Uri $img.webformatUrl -OutFile $picPath\$picFilename
        Invoke-WebRequest -Uri $img.webformatUrl -OutFile .\$picFileName
        & ".\$picFileName"
    }   
    #End Script info
    Write-Verbose "SCRIPT NAME: $scriptName"
    Write-Verbose "SCRIPT PATH: $scriptPath"
    Write-Verbose "SCRIPT RUNTIME: $datetime"
    Write-Verbose "SCRIPT USER: $ScriptRunner"
    Write-Verbose "SCRIPT SYSTEM: $compname.$domain"
}