# ESU configuration
$ESU_MAK  = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"  # Enter ESU product key
$ESU_Year = 1                               # 1, 2 or 3

# ESU Activation IDs by year
$ActivationIDs = @{
    1 = "f520e45e-7413-4a34-a497-d2765967d094"
    2 = "1043add5-23b1-4afb-9a0f-64343c8f3f8d"
    3 = "83d49986-add3-41d7-ba33-87c7bfb5c0fb"
}

$ActivationID = $ActivationIDs[$ESU_Year]

# Install ESU MAK
Write-Output "Installing ESU MAK key..."
cscript.exe $env:windir\system32\slmgr.vbs /ipk $ESU_MAK

# Activate ESU MAK
Write-Output "Activating ESU MAK key for Year $ESU_Year..."
cscript.exe $env:windir\system32\slmgr.vbs /ato $ActivationID

# Retry logic for ESU activation detection
$maxRetries   = 6
$retryDelay   = 10   # seconds between retries
$attempt      = 0
$ESU          = $null

do {
    $attempt++
    Write-Output "Checking ESU activation status (attempt $attempt of $maxRetries)..."

    $ESU = Get-CimInstance -ClassName SoftwareLicensingProduct |
           Where-Object { $_.LicenseStatus -eq 1 -and $_.Name -like "*ESU*" }

    if (-not $ESU) {
        if ($attempt -lt $maxRetries) {
            Write-Output "ESU not activated yet, retrying in $retryDelay seconds..."
            Start-Sleep -Seconds $retryDelay
        }
        else {
            Write-Output "ESU still not activated after $maxRetries attempts."
        }
    }
} while (-not $ESU -and $attempt -lt $maxRetries)

# Shared registry path
$RegPath = "HKLM:\Software\Company\ESUStatus"

if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

if ($ESU) {
    # ESU is activated
    Set-ItemProperty -Path $RegPath -Name "Activated" -Value 1 -Type DWord
    Set-ItemProperty -Path $RegPath -Name "ESUName"  -Value $ESU.Name
    Write-Output "ESU license detected and registry updated."
}
else {
    # ESU is not activated
    Set-ItemProperty -Path $RegPath -Name "Activated" -Value 0 -Type DWord
    Write-Output "No active ESU license detected. Registry updated."
}
