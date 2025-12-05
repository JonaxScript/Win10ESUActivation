## ESU Activation Script

This repository contains a PowerShell script to install and activate a Windows Extended Security Updates (ESU) Multiple Activation Key (MAK) for Windows clients or servers and to persist the activation status in the registry for later evaluation by deployment or monitoring tools.

---

## Features

- Installs a configurable ESU MAK key for ESU Year 1, 2, or 3.
- Activates the ESU key using the appropriate ESU Activation ID for the selected year.
- Implements retry logic (configurable attempts and delay) to wait for ESU activation if it takes longer on some systems.
- Detects the ESU license via `Get-CimInstance -ClassName SoftwareLicensingProduct` and filters by active ESU products.
- Writes the ESU activation status and ESU product name into the registry at `HKLM:\Software\Company\ESUStatus` for external tools to query.

---

## Requirements

- Windows version eligible for ESU with a valid ESU MAK key.
- PowerShell running with administrative privileges.
- Network connectivity to Microsoft activation servers (if online activation is required).

---

## Usage

1. Clone or download this repository.
2. Open the script in a text editor.
3. Set the following variables at the top of the script:
   - `$ESU_MAK` – your ESU Multiple Activation Key.
   - `$ESU_Year` – ESU year (1, 2, or 3) matching the ESU entitlement you want to activate.
4. Run PowerShell as Administrator.
5. Execute the script, for example:
.\Activate-ESU.ps1
6. After execution, check the registry key:
HKLM\Software\Company\ESUStatus
- `Activated` = `1` → ESU detected as activated.
- `Activated` = `0` → No active ESU license detected.

---

## Disclaimer

- Use this script at your own risk and only in environments where you are licensed to use ESU.
- Always test in a non‑production environment before deploying broadly.
