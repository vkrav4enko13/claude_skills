#!/bin/bash
# Раскладывает личные скилы из этой папки по всем профилям Claude Code и Codex
# на Маке и на Windows-ПК (ssh pc). Повторный запуск безопасен: папка каждого
# скила заменяется целиком, чужие скилы не трогаются.
#
#   install.sh            — разложить
#   install.sh --uninstall — убрать разложенные скилы
#   install.sh --mac      — только Мак (ПК не трогать)
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"

MAC_TARGETS=(
    "$HOME/claude/personal/skills"
    "$HOME/claude/work/skills"
    "$HOME/.codex/skills"
)
# Относительно домашней папки на ПК (C:\Users\vkravchenko).
PC_TARGETS=(.claude-personal/skills .claude-work/skills .codex/skills)

uninstall=0
pc=1
for arg in "$@"; do
    case "$arg" in
        --uninstall) uninstall=1 ;;
        --mac) pc=0 ;;
        *) echo "неизвестный параметр: $arg" >&2; exit 2 ;;
    esac
done

skills=()
for dir in "$SRC"/*/; do
    [ -f "$dir/SKILL.md" ] && skills+=("$(basename "$dir")")
done
[ ${#skills[@]} -gt 0 ] || { echo "в $SRC нет скилов" >&2; exit 1; }

for target in "${MAC_TARGETS[@]}"; do
    for skill in "${skills[@]}"; do
        rm -rf "${target:?}/$skill"
        if [ $uninstall -eq 0 ]; then
            mkdir -p "$target"
            cp -R "$SRC/$skill" "$target/$skill"
        fi
    done
    echo "Мак: $target"
done

[ $pc -eq 1 ] || exit 0

if ! ssh -o ConnectTimeout=5 -o BatchMode=yes pc exit 2>/dev/null; then
    echo "ПК не отвечает — на него не разложено (wake-pc и повторить)" >&2
    exit 3
fi

for target in "${PC_TARGETS[@]}"; do
    for skill in "${skills[@]}"; do
        ssh pc "Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"\$HOME/$target/$skill\"; if ($uninstall -eq 0) { New-Item -ItemType Directory -Force \"\$HOME/$target\" | Out-Null }"
        [ $uninstall -eq 1 ] || scp -qr "$SRC/$skill" "pc:$target/"
    done
    echo "ПК: ~/$target"
done
