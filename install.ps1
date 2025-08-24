# ----- התקנת Git בשקט (ללא אתחול/פופ-אפים) -----
$ErrorActionPreference = 'Stop'
$installer = Join-Path $PSScriptRoot 'Git-<version>-64-bit.exe'

# דגלים שקטים של Inno Setup; אפשר להוסיף /LOG="C:\git-install.log" לטרבלשוטינג
$args = '/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS'
Start-Process -FilePath $installer -ArgumentList $args -Wait

# ----- מציאת git.exe -----
# Git for Windows רושם בחלונות HKLM\SOFTWARE\GitForWindows את ה-InstallPath (בהתקנה מערכתית).
# אם PATH כבר מעודכן, מספיק לקרוא git ישירות.
function Resolve-Git {
  $candidates = @(
    "git.exe",
    "C:\Program Files\Git\bin\git.exe",
    "C:\Program Files\Git\cmd\git.exe",
    "C:\Program Files (x86)\Git\bin\git.exe",
    "C:\Program Files (x86)\Git\cmd\git.exe"
  )
  foreach ($p in $candidates) {
    $g = (Get-Command $p -ErrorAction SilentlyContinue)
    if ($g) { return $g.Source }
  }
  # ניסיון דרך הרישום (אם הותקן לכל המחשב)
  $reg = 'HKLM:\SOFTWARE\GitForWindows'
  if (Test-Path $reg) {
    $installPath = (Get-ItemProperty -Path $reg -ErrorAction SilentlyContinue).InstallPath
    if ($installPath) {
      foreach ($sub in @('bin\git.exe','cmd\git.exe')) {
        $cand = Join-Path $installPath $sub
        if (Test-Path $cand) { return $cand }
      }
    }
  }
  throw "git.exe not found on this session PATH or standard locations."
}
$gitExe = Resolve-Git

# ----- קונפיגורציות GLOBAL בהקשר המשתמש -----
# הסרות (מתעלם משגיאה אם הערך לא קיים)
& $gitExe config --global --unset-all credential.helper 2>$null
& $gitExe config --global --unset-all credential.useHttpPath 2>$null

# הוספת helper מותנה-URL (מצטט את המפתח כדי למנוע בעיות עם * ו-: ב-PowerShell)
& $gitExe config --global "credential.https://*.*.p.sourcemanager.dev.helper" gcloud.cmd

# ----- סימון הצלחה לזיהוי ב-Intune -----
$marker = "$env:LOCALAPPDATA\MyCompany\git-postinstall.ok"
New-Item -ItemType Directory -Force -Path (Split-Path $marker) | Out-Null
"OK $(Get-Date -Format s)" | Set-Content -Path $marker -Encoding UTF8

exit 0
