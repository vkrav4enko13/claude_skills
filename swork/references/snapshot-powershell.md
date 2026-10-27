# Snapshot: PowerShell 5.1 commands

The same names: `$Root`, `$Snap`, `$F`, `$Cmd`.

```powershell
# whether the project is under git; the list at the start
git -C $Root rev-parse --is-inside-work-tree 2>$null
git -C $Root status --porcelain | Set-Content "$Snap\dirty-at-start.txt"

# a check: the exit code of the command itself, the end of the output; no output file
$out = cmd /c "$Cmd 2>&1"; $code = $LASTEXITCODE; $out | Select-Object -Last 40; "code: $code"

# a "create" file
$list = "$Snap\new-files.txt"
if (-not (Test-Path $list) -or (Get-Content $list) -notcontains $F) { Add-Content $list $F }

# the changes; the files changed now
git -C $Root diff
git -C $Root status --porcelain

# rolling a file back: a tracked file clean at the start / a new one
git -C $Root checkout -- $F
Remove-Item (Join-Path $Root $F)

# a file outside the plan: whether it is ignored ($LASTEXITCODE 0 — yes); restore a tracked one / move a new one away
git -C $Root check-ignore -q $F
$rm = Join-Path $Snap "removed\$F"
New-Item -ItemType Directory -Force (Split-Path $rm) | Out-Null
git -C $Root diff -- $F | Set-Content "$rm.diff"; git -C $Root checkout -- $F
Move-Item (Join-Path $Root $F) $rm

# the work is accepted
Remove-Item -Recurse -Force $Snap
```
