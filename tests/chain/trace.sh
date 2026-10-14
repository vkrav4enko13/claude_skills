#!/bin/bash
# Prints where a series of the chain stand spends its tokens.
#
#   bash tests/chain/trace.sh <series> [<section>…]
#
# The sections are total stages roles kinds input efforts reads overview depth
# requests, printed in the order asked; none named — total stages roles kinds
# input. A line is words separated by one space, the first word is the section.
# A series is the folder $CHAIN_BASE/<series>, by default
# ~/Documents/my/chain-stand/<series>; its runs are the folders [0-9]*, in a
# run the stage folders brain plan work seed away, whichever exist, in a stage
# raw/*.jsonl — the main sessions, raw/subagents/agent-*.jsonl with
# agent-*.meta.json — the subagents. A request is the assistant records of one
# requestId of a file: the usage of the last record, the content blocks of all
# of them without repeats. Thinking is thinking_tokens of the usage; the rest
# of the output is split into text and tool by the UTF-8 bytes of the text
# blocks against the JSON of the tool inputs: text is rounded down, tool takes
# what is left. No series folder — "no series <name>" to stderr and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo 'usage: bash trace.sh <series> [<section>…]' >&2
    exit 2
}
[ $# -ge 1 ] || usage
series="$1"
shift
if [ $# -eq 0 ]; then set -- total stages roles kinds input; fi
for s in "$@"; do
    case "$s" in
        total | stages | roles | kinds | input | efforts | reads | overview | depth | requests) ;;
        *) echo "unknown section: $s" >&2; usage ;;
    esac
done

S="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
if [ ! -d "$S/$series" ]; then
    echo "no series $series" >&2
    exit 1
fi
# The paths below are from the series folder: <run>/<stage>/raw/…
cd "$S/$series"

# Every list starts with /dev/null: without files jq would read the input.
raws=(/dev/null)
metas=(/dev/null)
runs=0
stages=""
for r in [0-9]*; do
    [ -d "$r" ] || continue
    runs=$((runs + 1))
    for s in brain plan work seed away; do
        [ -d "$r/$s" ] || continue
        case " $stages " in *" $s "*) ;; *) stages="$stages $s" ;; esac
        for f in "$r/$s"/raw/*.jsonl "$r/$s"/raw/subagents/agent-*.jsonl; do
            if [ -f "$f" ]; then raws+=("$f"); fi
        done
        for f in "$r/$s"/raw/subagents/agent-*.meta.json; do
            if [ -f "$f" ]; then metas+=("$f"); fi
        done
    done
done

# The records the sections need, a line per record: "a" — an assistant record
# with its blocks, "p" — a user record with a prompt text, "r" — tool results.
slim() {
    jq -c '
        input_filename as $f
        | if .type == "assistant" then
            {
                f: $f, k: "a", s: .sessionId, ts: .timestamp, e: .effort,
                rid: (.requestId // .message.id // ""),
                u: (.message.usage // {} | {
                    o: (.output_tokens // 0),
                    th: (.output_tokens_details.thinking_tokens // 0),
                    i: (.input_tokens // 0),
                    cw: (.cache_creation_input_tokens // 0),
                    cr: (.cache_read_input_tokens // 0)
                }),
                b: [.message.content[]? | objects
                    | if .type == "text" then
                        {t: "text", sz: (.text | utf8bytelength), key: .text[0:40]}
                    elif .type == "tool_use" then
                        {
                            t: "tool", sz: (.input | tojson | utf8bytelength), key: .id,
                            n: .name, p: (.input.file_path? // null),
                            cmd: (if .name == "Bash" then .input.command? else null end)
                        }
                    else
                        {t: .type, sz: 0, key: (.signature // "")[0:40]}
                    end]
            }
        elif .type == "user" and .isMeta != true then
            .message.content as $c
            | if ($c | type) == "string" then {f: $f, k: "p"}
            elif ($c | type) == "array" then
                [$c[] | objects | select(.type == "tool_result") | {
                    id: .tool_use_id,
                    n: (.content
                        | if type == "string" then .
                        elif type == "array" then map(objects | .text // "") | join("")
                        else "" end
                        | utf8bytelength)
                }] as $res
                | if ($res | length) > 0 then {f: $f, k: "r", r: $res}
                elif any($c[]; objects | .type == "text") then {f: $f, k: "p"}
                else empty end
            else empty end
        else empty end
    ' "${raws[@]}"
}

slim | jq -rn --slurpfile metas <(jq -c '. + {f: input_filename}' "${metas[@]}") \
    --argjson runs "$runs" --arg stages "$stages" --arg sections "$*" '
    def role_of:
        ascii_downcase as $d
        | ($d | test("second|round 2")) as $two
        | if $d | startswith("stage ") then "stage"
        elif ($d | contains("plan review")) and $two then "plan-review-2"
        elif $d | contains("plan review") then "plan-review"
        elif $d | startswith("execute slice") then "executor"
        elif $d | startswith("fix ") then "fixer"
        elif $d | contains("conformance") then "conformance"
        elif $two then "review-2"
        elif $d | contains("review") then "review"
        else "other" end;
    def class_of:
        if test("(^|/)wiki-rules\\.md$") then "wiki-rules"
        elif test("\\.claude/skills/swork/references/(executor|conformance|simplify|review)\\.md$") then "task"
        elif test("\\.claude/skills/") then "skill"
        elif test("(^|/)docs/") then "card"
        else "other" end;
    def sum(f): [f] | add // 0;
    def per_run: if $runs > 0 then . / $runs | floor else 0 end;

    ["main", "stage", "plan-review", "plan-review-2", "executor", "fixer",
        "conformance", "review", "review-2", "other"] as $order
    | ($metas | map({key: .f, value: .}) | from_entries) as $meta
    | [$ARGS.positional[] | select(. != "/dev/null")
        | split("/") as $p
        | ($p[3] != "subagents") as $main
        | ($meta[sub("\\.jsonl$"; ".meta.json")] // {}) as $m
        | {
            f: ., run: $p[0], stage: $p[1], main: $main,
            role: (if $main then "main" else ($m.description // "" | role_of) end),
            tid: $m.toolUseId, depth: ($m.spawnDepth // 0)
        }] as $files
    | ($files | map({key: .f, value: .}) | from_entries) as $info

    # A record of a request overwrites the usage of the earlier record of the
    # same requestId: the last one stays; the blocks are gathered from all.
    | reduce inputs as $e ({n: 0, prompts: {}, reqs: {}, res: {}};
        .n += 1
        | if $e.k == "p" then .prompts[$e.f] += 1
        elif $e.k == "r" then reduce $e.r[] as $x (.; .res[$x.id] = $x.n)
        else
            .n as $n
            | (.prompts[$e.f] // 0) as $turn
            | .reqs[$e.f + "|" + $e.rid] |= (
                (. // {f: $e.f, s: $e.s, i: $n, ts: $e.ts, turn: $turn, b: []})
                | .u = $e.u
                | .e = ($e.e // .e)
                | .b = reduce $e.b[] as $b (.b;
                    if any(.[]; .t == $b.t and .sz == $b.sz and .key == $b.key) then .
                    else . + [$b] end))
        end) as $all
    | $all.res as $res
    | [$all.reqs[]
        | $info[.f] as $x
        | (.u.o - .u.th) as $rest
        | sum(.b[] | select(.t == "text") | .sz) as $tb
        | sum(.b[] | .sz) as $tot
        | (if $tot > 0 then $rest * $tb / $tot | floor else 0 end) as $text
        | . + {
            run: $x.run, stage: $x.stage, role: $x.role, main: $x.main,
            text: $text, tool: (if $tot > 0 then $rest - $text else 0 end),
            b: [.b[] | . + {tok: (if $tot > 0 then $rest * .sz / $tot else 0 end)}]
        }]
    | sort_by(.ts, .i) as $reqs
    | [$order[] | select(. as $r | any($files[]; .role == $r))] as $roles

    | def total:
        sum($reqs[] | .u.o) as $out
        | "total runs \($runs)", "total output \($out)",
            "total thinking \(sum($reqs[] | .u.th))",
            "total output_per_run \($out | per_run)";
    def stages:
        $stages | split(" ")[] | select(. != "") as $s
        | "stages \($s) \(sum($reqs[] | select(.stage == $s) | .u.o)) \(sum($reqs[] | select(.stage == $s) | .u.th))";
    def roles:
        [$reqs[] | .b[] | select(.t == "tool" and .n == "Agent")] as $launch
        | $roles[] as $r
        | [$files[] | select(.role == $r)] as $mine
        | [$mine[] | .tid | values] as $tids
        | (if $r == "main" then 0
            else sum($launch[] | select(.key as $k | any($tids[]; . == $k)) | .tok) | floor end) as $prompt
        | "roles \($r) \(sum($reqs[] | select(.role == $r) | .u.o)) \($mine | length) \($prompt)";
    def kinds:
        $roles[] as $r
        | [$reqs[] | select(.role == $r)] as $mine
        | "kinds \($r) thinking \(sum($mine[] | .u.th))",
            "kinds \($r) text \(sum($mine[] | .text))",
            "kinds \($r) tool \(sum($mine[] | .tool))";
    def input:
        (["uncached", "i"], ["cache_write", "cw"], ["cache_read", "cr"]) as [$name, $key]
        | sum($reqs[] | .u[$key]) as $n
        | "input \($name) \($n) \($n | per_run)";
    def efforts:
        [$reqs[] | {
            who: (if .main | not then "agents" elif .turn <= 1 then "first" else "later" end),
            level: (.e // "none")
        }] as $rows
        | ("first", "later", "agents") as $who
        | [$rows[] | select(.who == $who)] | group_by(.level)[]
        | "efforts \($who) \(.[0].level) \(length)";
    def reads:
        [$reqs[] | . as $q | .b[] | select(.t == "tool")
            | (if .n == "Read" then [.p // ""]
                elif .n == "Bash" and (.cmd // "" | test("^\\s*(cat|head|tail|less|sed -n)\\s")) then
                    [.cmd | match("[^\\s\"\u0027;|&<>()]*\\.claude/skills/[^\\s\"\u0027;|&<>()]+"; "g").string]
                else [] end) as $paths
            | ($res[.key] // 0) as $bytes
            | $paths | to_entries[]
            | {
                role: $q.role, s: ($q.s // ($q.run + "/" + $q.stage)),
                class: (.value | class_of), bytes: (if .key == 0 then $bytes else 0 end)
            }] as $rows
        | ($roles[] as $r
            | ("wiki-rules", "task", "skill", "card", "other") as $c
            | [$rows[] | select(.role == $r and .class == $c)]
            | select(length > 0 or ($r == "main" and ($c == "task" or $c == "skill")))
            | "reads \($r) \($c) \(length) \(sum(.[] | .bytes))"),
            "reads session-max wiki-rules \([$rows[] | select(.class == "wiki-rules")] | group_by(.s) | map(length) | max // 0)";
    def overview:
        [$files[] | select(.stage == "plan" and .main) | .run] | unique | sort_by(tonumber? // .)[] as $run
        | [$reqs[] | select(.run == $run and .stage == "plan" and .main) | .b[] | select(.t == "tool")]
        | to_entries as $calls
        | [$calls[] | select(.value.n == "Write" and (.value.p // "" | endswith("plan-overview.md")))] as $writes
        | ([$calls[] | select(.value.n == "Agent") | .key] | first) as $agent
        | (if ($writes | length) == 0 or $agent == null then "none"
            elif $writes[0].key > $agent then "after" else "before" end) as $place
        | "overview \($run) \($writes | length) \(sum($writes[] | .value.tok) | floor) \($writes[0].value.tok // 0 | floor) \($place)";
    def depth:
        [$files[] | select(.main | not)] | group_by(.depth)[]
        | "depth \(.[0].depth) \(length)";
    def requests:
        $reqs[]
        | "requests \(.run) \(.stage) \(.role) \(.u.o) \(.u.th) \(.text) \(.tool) \(.u.cw) \(.u.cr)";

    $sections | split(" ")[]
    | if . == "total" then total
    elif . == "stages" then stages
    elif . == "roles" then roles
    elif . == "kinds" then kinds
    elif . == "input" then input
    elif . == "efforts" then efforts
    elif . == "reads" then reads
    elif . == "overview" then overview
    elif . == "depth" then depth
    else requests end
' --args "${raws[@]}"
