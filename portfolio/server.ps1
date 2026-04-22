$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$envFile = Join-Path $scriptDir ".env"

$hostValue = "127.0.0.1"
$portValue = "5500"

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        $line = $_.Trim()
        if (-not $line -or $line.StartsWith("#")) { return }
        if ($line -notmatch "=") { return }

        $parts = $line.Split("=", 2)
        $key = $parts[0].Trim()
        $value = $parts[1].Trim()

        if ($key -eq "HOST" -and $value) { $hostValue = $value }
        if ($key -eq "PORT" -and $value) { $portValue = $value }
    }
}

Set-Location $scriptDir

$url = "http://{0}:{1}" -f $hostValue, $portValue
Write-Host "Starting preview server at $url"
Write-Host "Press Ctrl+C to stop."

python -m http.server $portValue --bind $hostValue
