# =========================
# Git for Windows + Config (User Context)
# =========================
$ErrorActionPreference = 'Stop'

# 1) התקנת Git בשקט
$installer = Join-Path $PSScriptRoot 'Git-2.51.0-64-bit.exe'
if (-not (Test-Path $installer)) { throw "Git installer not found: $installer" }

# פריסה שקטה (Inno Setup). ניתן לצרף /LOG לטרבלשוטינג
$args = '/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS'
Start-Process -FilePath $installer -ArgumentList $args -Wait

# 2) איתור git.exe בצורה יציבה
function Resolve-Git {
  $candidates = @(
    "git.exe",
    "C:\Program Files\Git\bin\git.exe",
    "C:\Program Files\Git\cmd\git.exe",
    "C:\Program Files (x86)\Git\bin\git.exe",
    "C:\Program Files (x86)\Git\cmd\git.exe"
  )
  foreach ($p in $candidates) {
    $cmd = Get-Command $p -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
  }
  # ניסיון דרך הרישום (בהתקנה מערכתית)
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
  throw "git.exe not found on PATH or standard locations."
}
$git = Resolve-Git

# 3) קונפיגורציה ברמת GLOBAL (משתמש)
#    (הסרות – לא ייכשלו אם לא קיים; אנו משתיקים STDERR)
& $git config --global --unset-all credential.helper 2>$null
& $git config --global --unset-all credential.useHttpPath 2>$null

#    (הוספה – מצטטים את המפתח כדי להימנע מבעיות עם * ו- :)
& $git config --global "credential.https://*.*.p.sourcemanager.dev.helper" gcloud.cmd

# 4) קונפיגורציה ללא scope (LOCAL) — תפעל רק אם הסשן נמצא בתוך ריפו.
#    מחוץ לריפו זה ייתן שגיאה; אנו משתיקים אותה כדי לא להפיל את הפריסה.
& $git config --unset-all credential.helper 2>$null
& $git config --unset-all credential.useHttpPath 2>$null

# # 5) Marker לזיהוי הצלחה (User)
# $marker = "$env:LOCALAPPDATA\MyCompany\git-postinstall.ok"
# New-Item -ItemType Directory -Force -Path (Split-Path $marker) | Out-Null
# "OK $(Get-Date -Format s)" | Set-Content -Path $marker -Encoding UTF8

exit 0
