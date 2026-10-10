#!/bin/bash
# Раскладывает личные скилы из этой папки по всем профилям Claude Code и Codex
# на Маке и на Windows-ПК (ssh pc). Повторный запуск безопасен: папка каждого
# скила заменяется целиком, чужие скилы не трогаются.
#
# Ещё кладёт копии правил вики и скрипта проверки в splan и swork
# и пишет блок правил вики в общие инструкции каждого профиля — между метками
# project-wiki; текст вне меток не трогает. Метки хоть в одном файле стоят
# не парой — ничего не пишет и завершается с ошибкой. Файл инструкций ПК
# правится на Маке: скачивается scp и заливается обратно.
#
#   install.sh            — разложить
#   install.sh --uninstall — убрать разложенные скилы и блок
#   install.sh --mac      — только Мак (ПК не трогать)
#   install.sh --pc       — только ПК (Мак не трогать)
#
# WIKI_PC_PREFIX — путь от домашней папки ПК к подставному дому, внутри
# которого лежат профили; нужен только проверкам.
export LC_ALL=C.UTF-8
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"

MAC_TARGETS=(
    "$HOME/claude/personal/skills"
    "$HOME/claude/work/skills"
    "$HOME/.codex/skills"
)
# Файлы общих инструкций тех же профилей, в том же порядке.
MAC_FILES=(
    "$HOME/claude/personal/CLAUDE.md"
    "$HOME/claude/work/CLAUDE.md"
    "$HOME/.codex/AGENTS.md"
)
# Относительно домашней папки на ПК (C:\Users\vkravchenko); с WIKI_PC_PREFIX —
# внутри подставного дома.
prefix=${WIKI_PC_PREFIX:-}
[ -z "$prefix" ] || prefix="${prefix%/}/"
PC_TARGETS=(
    "${prefix}.claude-personal/skills"
    "${prefix}.claude-work/skills"
    "${prefix}.codex/skills"
)
# Файлы общих инструкций тех же профилей, в том же порядке.
PC_FILES=(
    "${prefix}.claude-personal/CLAUDE.md"
    "${prefix}.claude-work/CLAUDE.md"
    "${prefix}.codex/AGENTS.md"
)

BEGIN='<!-- project-wiki:begin -->'
END='<!-- project-wiki:end -->'

# Читает файл $1 целиком в text, вместе с переводами строк в конце;
# файла нет — text пуст.
slurp() {
    text=""
    if [ -f "$1" ]; then
        text=$(cat "$1" && printf x)
        text=${text%x}
    fi
}

# Метки блока в файле $1 стоят одной парой, либо их нет вовсе.
marks_paired() {
    slurp "$1"
    case "$text" in
        *"$BEGIN"*"$BEGIN"* | *"$END"*"$END"* | *"$END"*"$BEGIN"*) return 1 ;;
        *"$BEGIN"*"$END"*) return 0 ;;
        *"$BEGIN"* | *"$END"*) return 1 ;;
    esac
}

# Пишет блок вики в файл инструкций $1. Подставляет: $2 — путь к правилам вики,
# $3 — команду скрипта проверки, $4 — примечание к ней. Файла нет — создаёт его
# с одним блоком; метки есть — заменяет текст от метки до метки; меток нет —
# дописывает блок в конец через одну пустую строку.
write_block() {
    local block
    block=$(cat "$SRC/sbrain/references/wiki-block.md")
    block=${block//'{{RULES}}'/"$2"}
    block=${block//'{{CHECK}}'/"$3"}
    block=${block//'{{NOTE}}'/"$4"}
    slurp "$1"
    case "$text" in
        *"$BEGIN"*) text="${text%%"$BEGIN"*}$block${text#*"$END"}" ;;
        "") text="$block"$'\n' ;;
        *$'\n') text="$text"$'\n'"$block"$'\n' ;;
        # Файл кончался без перевода строки — и после блока его нет:
        # по этому remove_block вернёт файл побайтно.
        *) text="$text"$'\n\n'"$block" ;;
    esac
    printf '%s' "$text" > "$1"
}

# Убирает блок вики из файла инструкций $1 вместе с пустой строкой перед ним.
# Файл, в котором после этого не осталось ни одного знака, удаляет.
remove_block() {
    local pre post
    slurp "$1"
    case "$text" in
        *"$BEGIN"*) ;;
        *) return 0 ;;
    esac
    pre=${text%%"$BEGIN"*}
    post=${text#*"$END"}
    if [ -z "$post" ]; then
        # Блок дописан к файлу без перевода строки в конце — см. write_block.
        pre=${pre%$'\n\n'}
    else
        post=${post#$'\n'}
        case "$pre" in
            $'\n' | *$'\n\n') pre=${pre%$'\n'} ;;
        esac
    fi
    if [ -z "$pre$post" ]; then
        rm -f "$1"
    else
        printf '%s' "$pre$post" > "$1"
    fi
}

uninstall=0
mac=1
pc=1
for arg in "$@"; do
    case "$arg" in
        --uninstall) uninstall=1 ;;
        --mac) pc=0 ;;
        --pc) mac=0 ;;
        *) echo "неизвестный параметр: $arg" >&2; exit 2 ;;
    esac
done
if [ $mac -eq 0 ] && [ $pc -eq 0 ]; then
    echo "--mac и --pc вместе не ставятся: обе машины — без этих ключей" >&2
    exit 2
fi

skills=()
for dir in "$SRC"/*/; do
    [ -f "$dir/SKILL.md" ] && skills+=("$(basename "$dir")")
done
[ ${#skills[@]} -gt 0 ] || { echo "в $SRC нет скилов" >&2; exit 1; }

# ПК отвечает — узнать его домашнюю папку и скачать во временную папку файлы
# инструкций, какие есть: метки в них проверяются вместе с файлами Мака.
pc_up=0
if [ $pc -eq 1 ] && ssh -o ConnectTimeout=5 -o BatchMode=yes pc exit 2>/dev/null; then
    pc_up=1
    pc_home=$(ssh pc 'Write-Output $HOME' | tr -d '\r')
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    for i in "${!PC_FILES[@]}"; do
        found=$(ssh pc "Test-Path \"\$HOME/${PC_FILES[$i]}\"" | tr -d '\r')
        [ "$found" != True ] || scp -q "pc:${PC_FILES[$i]}" "$tmp/$i"
    done
fi

# До первой записи: метка без пары хоть в одном файле останавливает всё.
unpaired=0
if [ $mac -eq 1 ]; then
    for file in "${MAC_FILES[@]}"; do
        if ! marks_paired "$file"; then
            echo "$file: метка project-wiki без пары — исправь файл; ничего не записано" >&2
            unpaired=1
        fi
    done
fi
if [ $pc_up -eq 1 ]; then
    for i in "${!PC_FILES[@]}"; do
        if ! marks_paired "$tmp/$i"; then
            echo "ПК, ~/${PC_FILES[$i]}: метка project-wiki без пары — исправь файл; ничего не записано" >&2
            unpaired=1
        fi
    done
fi
[ $unpaired -eq 0 ] || exit 4

if [ $mac -eq 1 ]; then
    for i in "${!MAC_TARGETS[@]}"; do
        target=${MAC_TARGETS[$i]}
        for skill in "${skills[@]}"; do
            rm -rf "${target:?}/$skill"
            if [ $uninstall -eq 0 ]; then
                mkdir -p "$target"
                cp -R "$SRC/$skill" "$target/$skill"
            fi
        done
        if [ $uninstall -eq 0 ]; then
            # splan и swork держат свои копии правил вики и скрипта проверки.
            for skill in splan swork; do
                mkdir -p "$target/$skill/references" "$target/$skill/scripts"
                cp "$SRC/sbrain/references/wiki-rules.md" "$target/$skill/references/"
                cp "$SRC/sbrain/scripts/check.sh" "$target/$skill/scripts/"
            done
            write_block "${MAC_FILES[$i]}" "$target/sbrain/references/wiki-rules.md" \
                "bash \"$target/sbrain/scripts/check.sh\"" ""
        else
            remove_block "${MAC_FILES[$i]}"
        fi
        echo "Мак: $target"
    done
fi

[ $pc -eq 1 ] || exit 0

if [ $pc_up -eq 0 ]; then
    echo "ПК не отвечает — на него не разложено (wake-pc и повторить)" >&2
    exit 3
fi

for i in "${!PC_TARGETS[@]}"; do
    target=${PC_TARGETS[$i]}
    for skill in "${skills[@]}"; do
        ssh pc "Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"\$HOME/$target/$skill\"; if ($uninstall -eq 0) { New-Item -ItemType Directory -Force \"\$HOME/$target\" | Out-Null }"
        [ $uninstall -eq 1 ] || scp -qr "$SRC/$skill" "pc:$target/"
    done
    if [ $uninstall -eq 0 ]; then
        for skill in splan swork; do
            ssh pc "New-Item -ItemType Directory -Force \"\$HOME/$target/$skill/references\", \"\$HOME/$target/$skill/scripts\" | Out-Null"
            scp -q "$SRC/sbrain/references/wiki-rules.md" "pc:$target/$skill/references/"
            scp -q "$SRC/sbrain/scripts/check.sh" "pc:$target/$skill/scripts/"
        done
        # В блоке пути записаны так, как их пишет Windows.
        win="$pc_home\\${target//\//\\}"
        write_block "$tmp/$i" "$win\\sbrain\\references\\wiki-rules.md" \
            "\"C:\\Program Files\\Git\\bin\\bash.exe\" \"$win\\sbrain\\scripts\\check.sh\"" \
            " (в PowerShell — со знаком & перед командой)"
        scp -q "$tmp/$i" "pc:${PC_FILES[$i]}"
    elif grep -qF "$BEGIN" "$tmp/$i" 2>/dev/null; then
        remove_block "$tmp/$i"
        if [ -f "$tmp/$i" ]; then
            scp -q "$tmp/$i" "pc:${PC_FILES[$i]}"
        else
            ssh pc "Remove-Item -Force \"\$HOME/${PC_FILES[$i]}\""
        fi
    fi
    echo "ПК: ~/$target"
done
