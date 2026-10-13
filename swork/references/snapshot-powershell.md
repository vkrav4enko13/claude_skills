# Snapshot: PowerShell 5.1 commands

Read only on Windows.

The same names: `$Root`, `$Snap`, `$Wiki`, `$F`, `$Stage`, `$Cmd`, `$N`.

```powershell
# whether the project is under git; the list at the start; the marker
git -C $Root rev-parse --is-inside-work-tree 2>$null
git -C $Root status --porcelain | Set-Content "$Snap\dirty-at-start.txt"
New-Item -ItemType File -Force "$Root\.swork-marker" | Out-Null

# a check: the full output into a file, the exit code of the command itself, the end of the output
New-Item -ItemType Directory -Force "$Snap\checks" | Out-Null
cmd /c "$Cmd > `"$Snap\checks\$N.txt`" 2>&1"; "code: $LASTEXITCODE"; Get-Content "$Snap\checks\$N.txt" -Tail 40

# a copy of a "change" file and a checkpoint (does not touch existing ones): $Dir is base or $Stage
$dst = Join-Path $Snap "$Dir\$F"
if (-not (Test-Path $dst)) {
    New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
    Copy-Item (Join-Path $Root $F) $dst
}

# a "create" file
$list = "$Snap\new-files.txt"
if (-not (Test-Path $list) -or (Get-Content $list) -notcontains $F) { Add-Content $list $F }

# the changes of one file
Compare-Object (Get-Content (Join-Path $Snap "base\$F")) (Get-Content (Join-Path $Root $F))

# rolling a file back to the state before the start or to the checkpoint ($Dir) / deleting a new one
Copy-Item (Join-Path $Snap "$Dir\$F") (Join-Path $Root $F) -Force
Remove-Item (Join-Path $Root $F)

# the files newer than the marker; subtract from the output the files of the slices already gone through, the exclusions and known.txt.
# If the project has no wiki, remove the condition with $Wiki
$m = (Get-Item "$Root\.swork-marker").LastWriteTime
Get-ChildItem $Root -Recurse -File -Force |
    Where-Object { $_.LastWriteTime -gt $m -and $_.FullName -notlike "$Snap\*" -and
                   $_.FullName -notlike "$Wiki\*" -and $_.Name -ne '.swork-marker' -and
                   $_.FullName -notlike '*\.git\*' } |
    ForEach-Object FullName

# under git: whether it is ignored, whether it is tracked (after each — $LASTEXITCODE, 0 — yes)
git -C $Root check-ignore -q $F
git -C $Root ls-files --error-unmatch $F 2>$null | Out-Null

# under git: restore a tracked one (keeping the changed one, the time — as the marker's) / remove a new untracked one
$rm = Join-Path $Snap "removed\$F"
New-Item -ItemType Directory -Force (Split-Path $rm) | Out-Null
Copy-Item (Join-Path $Root $F) $rm; git -C $Root checkout -- $F; (Get-Item (Join-Path $Root $F)).LastWriteTime = $m
Move-Item (Join-Path $Root $F) $rm

# the work is accepted
Remove-Item -Recurse -Force $Snap, "$Root\.swork-marker"
```
