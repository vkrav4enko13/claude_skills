# Snapshot: PowerShell 5.1 commands

Read only on Windows.

The same names: `$Root`, `$Snap`, `$Agents`, `$M`, `$Topic`, `$Wiki`, `$F`, `$Stage`, `$Cmd`, `$N`.

```powershell
# whether the project is under git; the list at the start; the marker
git -C $Root rev-parse --is-inside-work-tree 2>$null
git -C $Root status --porcelain | Set-Content "$Snap\dirty-at-start.txt"
# the marker of this agent; then ONE of the two commands: a new agent creates it, a continuing agent adopts the oldest (a legacy root .swork-marker counts)
$Id = (bash $Agents id).Split("`t")[0]; $M = Join-Path $Snap "agents\$Id\marker"
New-Item -ItemType Directory -Force (Split-Path $M) | Out-Null
New-Item -ItemType File -Force $M | Out-Null
Get-ChildItem "$Snap\agents\*\marker", "$Root\.swork-marker" -Force -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime | Select-Object -First 1 | Copy-Item -Destination $M

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
$t = (Get-Item $M).LastWriteTime
Get-ChildItem $Root -Recurse -File -Force |
    Where-Object { $_.LastWriteTime -gt $t -and $_.FullName -notlike "$Snap\*" -and
                   $_.FullName -notlike "$Wiki\*" -and $_.FullName -notlike "$Root\.agents\*" -and
                   $_.FullName -notlike "$Root\.swork-*" -and
                   $_.FullName -notlike '*\.git\*' } |
    ForEach-Object FullName
bash $Agents others --since $M   # paths from the root to subtract too

# under git: whether it is ignored, whether it is tracked (after each — $LASTEXITCODE, 0 — yes)
git -C $Root check-ignore -q $F
git -C $Root ls-files --error-unmatch $F 2>$null | Out-Null

# under git: restore a tracked one (keeping the changed one, the time — as this agent's marker's) / remove a new untracked one
$rm = Join-Path $Snap "removed\$F"
New-Item -ItemType Directory -Force (Split-Path $rm) | Out-Null
Copy-Item (Join-Path $Root $F) $rm; git -C $Root checkout -- $F; (Get-Item (Join-Path $Root $F)).LastWriteTime = $t
Move-Item (Join-Path $Root $F) $rm

# the work is accepted: ONE of the two lines — a topic snapshot only when no live claim is left in the topic (busy: code 1) / the .swork-<id>\ of a small change
bash $Agents busy --topic $Topic; if ($LASTEXITCODE -eq 1) { Remove-Item -Recurse -Force $Snap, "$Root\.swork-marker" -ErrorAction SilentlyContinue }
Remove-Item -Recurse -Force $Snap
```
