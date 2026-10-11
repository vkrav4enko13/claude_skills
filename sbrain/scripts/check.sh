#!/bin/bash
# Проверяет вики проекта и называет нарушения. Сам ничего не меняет.
#
#   bash check.sh <папка вики>
#
# Нарушений нет — строка «вики в порядке», код 0.
# Есть — по строке «<путь от папки вики>[:<номер строки>]: <нарушение>», код 1.
# Нет аргумента или в папке нет 00-index.md — сообщение и код 2.
#
# Видит только пять частей вики: 00-index.md, rules.md, journal/, work/, notes/.
# Папки с точкой в начале имени не видит на любой глубине.
# Как исправить каждое нарушение — references/wiki-rules.md, раздел «Проверка».
export LC_ALL=C.UTF-8
set -euo pipefail

if [ -z "${1:-}" ]; then
    echo "запуск: bash check.sh <папка вики>" >&2
    exit 2
fi
W="${1%/}"
if [ ! -f "$W/00-index.md" ]; then
    echo "$1: это не вики — нет 00-index.md" >&2
    exit 2
fi

bad=0
say() {
    printf '%s: %s\n' "$1" "$2"
    bad=1
}

# Файлы вики, полными путями.
wiki_files() {
    local part
    echo "$W/00-index.md"
    if [ -f "$W/rules.md" ]; then echo "$W/rules.md"; fi
    for part in journal notes work; do
        if [ -d "$W/$part" ]; then
            find "$W/$part" -name '.*' -prune -o -type f -name '*.md' -print
        fi
    done
}

link_re='\[[^]]*\]\(([^)]*)\)'
scheme_re='^[A-Za-z][A-Za-z0-9+.-]*:'

# Цели ссылок [текст](цель) строки $1 — в массив targets: без схемы, до «#».
# Код ссылкой не считается: ни в обратных кавычках, ни в блоке между строками
# из трёх обратных кавычек. Перед каждым файлом fence сбрасывается в 0.
bt='`'
fence=0
links() {
    local rest="$1" m t
    targets=()
    case "${rest#"${rest%%[! ]*}"}" in
        "$bt$bt$bt"*)
            fence=$((1 - fence))
            return 0
            ;;
    esac
    if [ $fence -eq 1 ]; then return 0; fi
    while [[ $rest == *"$bt"*"$bt"* ]]; do
        rest=${rest%%"$bt"*}' '${rest#*"$bt"*"$bt"}
    done
    while [[ $rest =~ $link_re ]]; do
        m=${BASH_REMATCH[0]}
        t=${BASH_REMATCH[1]}
        rest=${rest#*"$m"}
        if [[ $t =~ $scheme_re ]]; then continue; fi
        t=${t%%#*}
        if [ -n "$t" ]; then targets+=("$t"); fi
    done
}

# Папка файла $1 от папки вики, с косой чертой в конце; для корня — пусто.
dir_of() {
    case "$1" in
        */*) dir="${1%/*}/" ;;
        *) dir="" ;;
    esac
}

files=$(wiki_files | sort)

# Первый проход: что названо в индексах и архивах. Индекс называет карточки
# своей папки и индексы папок уровнем ниже — больше ничего.
named=$'\n'
while IFS= read -r file; do
    rel=${file#"$W/"}
    case "$rel" in
        00-index.md | */00-index.md | */00-archive.md) ;;
        *) continue ;;
    esac
    dir_of "$rel"
    fence=0
    while IFS= read -r line || [ -n "$line" ]; do
        links "$line"
        if [ ${#targets[@]} -eq 0 ]; then continue; fi
        for t in "${targets[@]}"; do
            case "${t%/00-index.md}" in
                */* | 00-index.md) ;;
                *) named="$named$dir$t"$'\n' ;;
            esac
        done
    done < "$file"
done <<< "$files"

# Второй проход: пределы, ссылки, заголовок и суть, строка в индексе.
while IFS= read -r file; do
    rel=${file#"$W/"}
    dir_of "$rel"
    lines=$(($(wc -l < "$file")))
    kind=list
    case "$rel" in
        00-index.md)
            if [ $lines -gt 40 ]; then say "$rel" "корневой индекс длиннее 40 строк"; fi
            ;;
        rules.md)
            if [ $lines -gt 30 ]; then say "$rel" "правил больше 30 строк"; fi
            ;;
        journal/* | */00-archive.md) ;;
        */00-index.md)
            kind=folder
            if [ $lines -gt 50 ]; then say "$rel" "индекс длиннее 50 строк"; fi
            ;;
        *)
            kind=card
            if [ $lines -gt 30 ]; then say "$rel" "карточка длиннее 30 строк"; fi
            if [ $(($(wc -m < "$file"))) -gt 3000 ]; then say "$rel" "карточка длиннее 3000 знаков"; fi
            ;;
    esac

    n=0
    title=0
    hook=0
    fence=0
    while IFS= read -r line || [ -n "$line" ]; do
        n=$((n + 1))
        if [ $kind != card ] && [ ${#line} -gt 200 ]; then
            say "$rel:$n" "строка длиннее 200 знаков"
        fi
        case "$line" in
            '# '*) title=1 ;;
            '> '*) hook=1 ;;
        esac
        links "$line"
        if [ ${#targets[@]} -eq 0 ]; then continue; fi
        for t in "${targets[@]}"; do
            if [ ! -e "$W/$dir$t" ]; then say "$rel:$n" "битая ссылка $t"; fi
        done
    done < "$file"

    if [ $kind = card ] && { [ $title -eq 0 ] || [ $hook -eq 0 ]; }; then
        say "$rel" "нет заголовка или строки сути"
    fi
    if [ $kind = folder ]; then dir_of "${dir%/}"; fi
    if [ $kind != list ]; then
        case "$named" in
            *$'\n'"$rel"$'\n'*) ;;
            *) say "$rel" "нет строки в индексе ${dir}00-index.md" ;;
        esac
    fi
done <<< "$files"

if [ $bad -eq 1 ]; then exit 1; fi
echo "вики в порядке"
