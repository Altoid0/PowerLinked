
param(
    [string]$CompanyName,
    [string]$ProfileLog
)

$request = Invoke-WebRequest "https://www.google.com/search?q=site:linkedin.com/in+%22$CompanyName%22&num=100"

if ($request.StatusCode -ne 200) {
    Write-Host -ForegroundColor Red "[ERRO]: Web request failed, might be rate limited"
}
#$request.Content
$links = $request.Links | Select-Object href

$Profiles = Get-Content $ProfileLog -ErrorAction SilentlyContinue
if (-not $?) {
    Write-Host -ForegroundColor Yellow "[INFO]: Profile log does not exist"
    New-Item -Path $ProfileLog -ItemType File
}

foreach ($Link in $Links) {
    if ($Link -match "linkedin.com/in/") { 
        if ($link -match 'www\.linkedin\.com[^&]*') { 
            if ($Profiles -notcontains $Matches[0]) {
                Write-Host "[NEW]: " $Matches[0] -ForegroundColor Green
                Write-Output $Matches[0] | Out-File -FilePath $ProfileLog -Append -Encoding utf8
            }
            else {
                Write-Host "[INFO]: Nothing new =("
            }
        }
    }
}