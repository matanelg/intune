# intune

## wrap fit installation with configuration setup
powershell.exe -ExecutionPolicy Bypass -File .\install.ps1

## update wsl
IntuneWinAppUtil.exe
- Source folder:  C:\Pkg\UpdateWSL
- Setup file:     install.cmd
- Output folder:  C:\Pkg\Out
