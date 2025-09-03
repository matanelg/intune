# intune

## wrap fit installation with configuration setup
powershell.exe -ExecutionPolicy Bypass -File .\install.ps1

## update wsl
- 01
IntuneWinAppUtil.exe
- Source folder:  C:\Pkg\UpdateWSL
- Setup file:     install.cmd
- Output folder:  C:\Pkg\Out

-02 detection rule
New-ItemProperty -Path "HKLM:\SOFTWARE\Company\WSLUpdate" -Name "LastUpdate" -Value (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") -PropertyType String -Force
