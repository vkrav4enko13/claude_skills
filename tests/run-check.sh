#!/bin/bash
# Проверяет скрипт проверки вики на стендах из make-wiki.sh.
#
#   bash tests/run-check.sh <путь к check.sh> <папка стендов>
#
# Три утверждения: clean/docs и big/docs дают код 0; broken/docs даёт код 1
# и вывод, равный после LC_ALL=C sort файлу expected-broken.txt рядом.
# Всё сошлось — «скрипт в порядке», код 0. Иначе — первое несовпадение и код 1.
export LC_ALL=C.UTF-8
set -uo pipefail

if [ $# -ne 2 ]; then
    echo "запуск: bash run-check.sh <путь к check.sh> <папка стендов>" >&2
    exit 2
fi
check="$1"
stands="${2%/}"

for stand in clean big; do
    out=$("$BASH" "$check" "$stands/$stand/docs" 2>&1)
    code=$?
    if [ $code -ne 0 ]; then
        echo "$stand/docs: ожидался код 0, получен $code"
        printf '%s\n' "$out"
        exit 1
    fi
done

out=$("$BASH" "$check" "$stands/broken/docs" 2>&1)
code=$?
if [ $code -ne 1 ]; then
    echo "broken/docs: ожидался код 1, получен $code"
    printf '%s\n' "$out"
    exit 1
fi
if ! printf '%s\n' "$out" | LC_ALL=C sort | diff - "$(dirname "$0")/expected-broken.txt"; then
    echo "broken/docs: вывод не равен expected-broken.txt"
    exit 1
fi

echo "скрипт в порядке"
