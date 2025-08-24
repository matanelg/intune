# אופציה 1: קובץ סימון ב-LOCALAPPDATA (מומלץ בהקשר User)
if (Test-Path "$env:LOCALAPPDATA\MyCompany\git-postinstall.ok") { exit 0 } else { exit 1 }
