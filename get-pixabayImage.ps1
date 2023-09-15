function get-pixabayImage {
    <#
    .SYNOPSIS
    Uses Pixabay REST API to download an image from the Pixabay.com site
    .DESCRIPTION
    Uses Pixabay REST API to download an image from the Pixabay.com site. The script also saves the image's user for attribution.
    .PARAMETER Query
    Mandatory string parameter to use for the Pixabay image query
    .PARAMETER Category
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
    .PARAMETER Color
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
    .PARAMETER apikey
    Optional string parameter used to send your user apikey to Pixbay.
    See https://pixabay.com/api/docs/
    .EXAMPLE
    get-pixabayImage -query computer -category computer -color green -Verbose
    Query Pixabay with 'computer' and use the category computer and color green with additional feedback.
    .INPUTS
    None
    .OUTPUTS
    Image file (jpeg) from Pixabay and text file with image user for attribution.
    .NOTES
    NAME: get-pixabayImage.ps1
    VERSION: 1.0.2
    CHANGE LOG - Version - When - What - Who
    1.0.0 - 09/12/2023 - Initial script - Alain Assaf
    1.0.1 - 09/15/2023 - Add more params to API query - Alain Assaf
    1.0.2 - 09/15/2023 - Add error check if less than 50 results - Alain Assaf
    AUTHOR: Alain Assaf
    LASTEDIT: September 15, 2023
    .LINK
    https://pixabay.com/api/docs/
    http: //www.linkedin.com/in/alainassaf/
    #>
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
            per_page    = 50
            order       = "popular"
        }
    } else {
        $Body = @{
            key         = $apikey
            q           = $URLSearch
            category    = $category
            lang        = "en"
            image_type  = "photo"
            orientation = "horizontal"
            safesearch  = $true
            color       = $color
            per_page    = 50
            order       = "popular"
        }
    }

    $splat = @{
        URI    = "https://pixabay.com/api/"
        Method = "Get"
        Body   = $Body
    }

    try {
        $pixabay_query = Invoke-RestMethod @splat
    } catch {
        Write-Warning "Failed to query Pixabay"
        break
    }
     
    if ($pixabay_query.totalHits -eq 0) {
        Write-Warning "No query results"
        Break
    } else {
        # Limiting query to 50 at a time. Choose a random number to pick an image.
        if ($pixabay_query.totalHits -lt 50) {
            $randomHit = Get-Random -Minimum 1 -Maximum $pixabay_query.totalHits
        } else {
            $randomHit = Get-Random -Minimum 1 -Maximum 50
        }
        $img = $pixabay_query.hits[$randomHit]
        
        #Image Info
        Write-Verbose "Filepath: [$PSScriptRoot]"
        $tmpURL = $img.pageURL
        Write-Verbose "Pixabay url = [$tmpURL]"
        $tmpTags = $img.tags
        write-verbose "Tags: [$tmpTags]"
        $tmpuser = $img.user
        $tmpuserid = $img.user_id
        Write-Verbose "Pixabay User URL = [https://pixabay.com/users/$tmpuser-$tmpuserid]"
        
        #Get image and save user info for attribution
        Invoke-WebRequest -Uri $img.webformatUrl -OutFile .\$picFileName
        $tmpPixabayUser = $picFilename.split('.')[0] + "_pixabayUser.txt"
        "https://pixabay.com/users/$tmpuser-$tmpuserid" | Out-File -FilePath .\$tmpPixabayUser -Append
        & ".\$picFileName"
    }   
    #End Script info
    Write-Verbose "SCRIPT NAME: $scriptName"
    Write-Verbose "SCRIPT PATH: $scriptPath"
    Write-Verbose "SCRIPT RUNTIME: $datetime"
    Write-Verbose "SCRIPT USER: $ScriptRunner"
    Write-Verbose "SCRIPT SYSTEM: $compname.$domain"
}