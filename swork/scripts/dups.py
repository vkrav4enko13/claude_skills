#!/usr/bin/env python3
"""Lists candidate duplicates among the changed files against the whole project.

    python3 -I dups.py <project root> <changed path>...

Paths are relative to the root. Stdout lines:
    <kind>\t<name>\t<path>:<line>\t<path>:<line>
with kind name | similar | key | value | resource; "skipped: <path> — <reason>"
for a changed file that cannot be read; at most one "not installed: <tools>";
the last line "dups: none" or "dups: <n> candidates".
Kinds: name — a definition also made elsewhere; similar — a 6-line window
(spaces dropped, names declared inside it replaced by _) found elsewhere;
key — a JSON key twice in one object, or a key of a key-value file given again
with the same value; value — the same with a different value; resource — a
JSON path string listed twice in one array or object.
ast-grep and jscpd are used only when installed.
Code 0; code 2 on wrong arguments. Changes no file.
"""
import functools
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile

MAX_SIZE = 1024 * 1024
WINDOW = 6
JS_EXT = {".js", ".jsx", ".ts", ".tsx"}
PY_EXT = {".py"}
SH_EXT = {".sh"}
KV_EXT = {".str", ".lconf", ".properties"}
KINDS = ["name", "similar", "key", "value", "resource"]

JS_FUNC = re.compile(r"^function\s+([A-Za-z_$][\w$]*)")
JS_CLASS = re.compile(r"^class\s+([A-Za-z_$][\w$]*)")
JS_VAR = re.compile(r"^(?:const|let|var)\s+([A-Za-z_$][\w$]*)\s*=")
PY_DEF = re.compile(r"^(?:def|class)\s+([A-Za-z_]\w*)")
SH_DEF = re.compile(r"^([A-Za-z_][\w.:-]*)\s*\(\)\s*\{")

DECL = re.compile(r"\b(?:let|const|var)\s+([A-Za-z_$][\w$]*)")
PARAMS = [
    re.compile(r"\bfunction\b\s*\*?\s*[\w$]*\s*\(([^)]*)\)"),
    re.compile(r"\(([^()]*)\)\s*=>"),
    re.compile(r"\bdef\s+\w+\s*\(([^)]*)\)"),
]
ARROW_ONE = re.compile(r"([A-Za-z_$][\w$]*)\s*=>")
IDENT = re.compile(r"[A-Za-z_$][\w$]*")
COMMENT = ("//", "#", "/*", "*", "<!--")
KV_LINE = re.compile(r"^\s*([^\s=:][^=:]*?)\s*[=:]\s*(.*?)\s*$")
KV_COMMENT = ("#", "!", ";", "//")
PATHLIKE = re.compile(r"/.*\.[A-Za-z0-9]{1,5}$")


def usage(msg):
    print("dups: " + msg, file=sys.stderr)
    print("usage: python3 -I dups.py <project root> <changed path>...", file=sys.stderr)
    sys.exit(2)


def rel_to_root(root, x):
    return os.path.normpath(os.path.relpath(os.path.join(root, x), root))


def wiki_folder(root):
    try:
        with open(os.path.join(root, ".wiki-path"), encoding="utf-8") as f:
            first = f.readline().strip()
    except OSError:
        first = ""
    if not first or first == "off":
        return "docs"
    return rel_to_root(root, first)


def kept(rel, wiki):
    """False for paths under .git/, node_modules/ or a dot-folder other than the wiki folder."""
    parts = rel.split("/")[:-1]
    for i, p in enumerate(parts):
        if p in (".git", "node_modules"):
            return False
        if p.startswith("."):
            prefix = "/".join(parts[: i + 1])
            if not (wiki == prefix or wiki.startswith(prefix + "/")):
                return False
    return True


def project_files(root, wiki):
    files = None
    if shutil.which("git"):
        r = subprocess.run(["git", "-C", root, "ls-files", "-z", "-co", "--exclude-standard"],
                           capture_output=True)
        if r.returncode == 0:
            files = [p for p in r.stdout.decode("utf-8", "surrogateescape").split("\0") if p]
    if files is None:
        files = []
        for d, dirs, names in os.walk(root):
            reld = os.path.relpath(d, root)
            reld = "" if reld == "." else reld + "/"
            dirs[:] = [x for x in dirs if kept(reld + x + "/x", wiki)]
            files.extend(reld + n for n in names)
    out = []
    for rel in files:
        if not kept(rel, wiki):
            continue
        full = os.path.join(root, rel)
        if os.path.isfile(full) and not os.path.islink(full) and os.path.getsize(full) <= MAX_SIZE:
            out.append(rel)
    return out


@functools.lru_cache(maxsize=None)
def read_text(root, rel):
    """(text, None) or (None, reason)."""
    full = os.path.join(root, rel)
    if not os.path.isfile(full):
        return None, "not found"
    if os.path.getsize(full) > MAX_SIZE:
        return None, "over 1 MB"
    with open(full, "rb") as f:
        data = f.read()
    if b"\0" in data[:8192]:
        return None, "binary"
    try:
        return data.decode("utf-8"), None
    except UnicodeDecodeError:
        return None, "not UTF-8"


def ext(rel):
    return os.path.splitext(rel)[1].lower()


# --- names -------------------------------------------------------------------

def ast_grep_defs(root, files):
    """{path: [(name, line)]} from ast-grep, or None when its output is unreadable."""
    defs = {}
    patterns = ["function $NAME($$$) { $$$ }", "class $NAME { $$$ }"]
    for pattern in patterns:
        for i in range(0, len(files), 200):
            chunk = files[i:i + 200]
            r = subprocess.run(["ast-grep", "run", "--pattern", pattern, "--json"] + chunk,
                               cwd=root, capture_output=True, text=True)
            try:
                matches = json.loads(r.stdout or "[]")
            except ValueError:
                return None
            for m in matches if isinstance(matches, list) else []:
                try:
                    path = rel_to_root(root, m["file"])
                    line = m["range"]["start"]["line"] + 1
                    col = m["range"]["start"]["column"]
                    name = m["metaVariables"]["single"]["NAME"]["text"]
                except (KeyError, TypeError):
                    continue
                lead = (m.get("lines") or "").split("\n")[0][:col]
                if not lead:
                    defs.setdefault(path, []).append((name, line))
    return defs


def definitions(rel, text, ast_defs):
    e = ext(rel)
    found = []
    if e in JS_EXT:
        pats = [JS_VAR] if ast_defs is not None else [JS_FUNC, JS_CLASS, JS_VAR]
    elif e in PY_EXT:
        pats = [PY_DEF]
    elif e in SH_EXT:
        pats = [SH_DEF]
    else:
        return found
    for n, line in enumerate(text.split("\n"), 1):
        for p in pats:
            m = p.match(line)
            if m:
                found.append((m.group(1), n))
                break
    if e in JS_EXT and ast_defs is not None:
        found.extend(ast_defs.get(rel, []))
    return found


# --- similar -----------------------------------------------------------------

def code_lines(text):
    """[(line number, text)] without empty and comment-only lines."""
    out = []
    for n, line in enumerate(text.split("\n"), 1):
        s = line.strip()
        if s and not s.startswith(COMMENT):
            out.append((n, line))
    return out


def declared(lines):
    names = set()
    for line in lines:
        names.update(DECL.findall(line))
        names.update(ARROW_ONE.findall(line))
        for p in PARAMS:
            for group in p.findall(line):
                for piece in group.split(","):
                    m = IDENT.match(piece.strip().lstrip(".*"))
                    if m:
                        names.add(m.group(0))
    return names


def window_key(lines):
    names = sorted(declared(lines), key=len, reverse=True)
    out = []
    for line in lines:
        for name in names:
            line = re.sub(r"(?<![\w$])" + re.escape(name) + r"(?![\w$])", "_", line)
        out.append(re.sub(r"\s+", "", line))
    return "\n".join(out)


def windows(text):
    lines = code_lines(text)
    return lines, [window_key([t for _, t in lines[i:i + WINDOW]])
                   for i in range(len(lines) - WINDOW + 1)]


def jscpd_pairs(root, files):
    pairs = []
    with tempfile.TemporaryDirectory() as tmp:
        subprocess.run(["jscpd", "--reporters", "json", "--output", tmp] + files,
                       cwd=root, capture_output=True)
        try:
            with open(os.path.join(tmp, "jscpd-report.json"), encoding="utf-8") as f:
                report = json.load(f)
        except (OSError, ValueError):
            return pairs
        for d in report.get("duplicates", []) if isinstance(report, dict) else []:
            try:
                a, b = d["firstFile"], d["secondFile"]
                places = []
                for side in (a, b):
                    path = rel_to_root(root, side["name"])
                    places.append((path, int(side["start"])))
                lines = d.get("lines") or (int(a["end"]) - int(a["start"]) + 1)
            except (KeyError, TypeError, ValueError):
                continue
            pairs.append(("%s lines" % lines, places[0], places[1]))
    return pairs


# --- data --------------------------------------------------------------------

def pathlike(v):
    return isinstance(v, str) and bool(PATHLIKE.search(v))


def repeated(values):
    seen, out = set(), []
    for v in values:
        if v in seen:
            out.append(v)
        seen.add(v)
    return out


def json_events(text):
    """[(kind, name)] of duplicates; raises ValueError on invalid JSON."""
    events = []

    def hook(pairs):
        seen = set()
        for k, _ in pairs:
            if k in seen:
                events.append(("key", k))
            seen.add(k)
        events.extend(("resource", v) for v in repeated(v for _, v in pairs if pathlike(v)))
        return dict(pairs)

    def walk(node):
        if isinstance(node, list):
            events.extend(("resource", v) for v in repeated(v for v in node if pathlike(v)))
            for x in node:
                walk(x)
        elif isinstance(node, dict):
            for x in node.values():
                walk(x)

    walk(json.loads(text, object_pairs_hook=hook))
    return events


def match_lines(text, regex):
    return [text.count("\n", 0, m.start()) + 1 for m in re.finditer(regex, text)]


def kv_entries(text):
    out = []
    for n, line in enumerate(text.split("\n"), 1):
        if line.strip().startswith(KV_COMMENT):
            continue
        m = KV_LINE.match(line)
        if m:
            out.append((m.group(1), n, m.group(2)))
    return out


# --- main --------------------------------------------------------------------

def main(argv):
    if len(argv) < 3:
        usage("need a project root and at least one changed path")
    root = os.path.abspath(argv[1])
    if not os.path.isdir(root):
        usage("no folder " + argv[1])
    changed = []
    for p in argv[2:]:
        rel = rel_to_root(root, p)
        if rel == ".." or rel.startswith("../"):
            usage("outside the root: " + p)
        if rel not in changed:
            changed.append(rel)

    wiki = wiki_folder(root)
    files = project_files(root, wiki)
    file_set = set(files)
    files.extend(c for c in changed if c not in file_set and os.path.isfile(os.path.join(root, c)))

    skipped = []
    ok = []
    events = {}  # changed .json path -> its json_events
    for c in changed:
        text, reason = read_text(root, c)
        if text is None:
            skipped.append((c, reason))
            continue
        if ext(c) == ".json":
            try:
                events[c] = json_events(text)
            except ValueError as err:
                skipped.append((c, "invalid JSON: %s" % err))
                continue
        ok.append(c)
    ok_set = set(ok)

    missing = [t for t in ("ast-grep", "jscpd") if not shutil.which(t)]
    found = {}  # (kind, name, frozenset of places) -> line

    def add(kind, name, a, b):
        if a == b:
            return
        key = (kind, name, frozenset((a, b)))
        if key in found:
            return
        if a[0] not in ok_set and b[0] in ok_set:
            a, b = b, a
        found[key] = (KINDS.index(kind), "%s\t%s\t%s:%d\t%s:%d" % (kind, name, a[0], a[1], b[0], b[1]))

    texts = {}
    for f in files:
        text, _ = read_text(root, f)
        if text is not None:
            texts[f] = text

    # names
    ast_defs = None
    if "ast-grep" not in missing:
        js = [f for f in texts if ext(f) in JS_EXT]
        if js:
            ast_defs = ast_grep_defs(root, js)
    places = {}
    for f, text in texts.items():
        for name, line in definitions(f, text, ast_defs):
            places.setdefault(name, []).append((f, line))
    for c in ok:
        for name, line in definitions(c, texts[c], ast_defs):
            for other in places.get(name, []):
                add("name", name, (c, line), other)

    # similar
    index = {}
    wins = {}
    for f, text in texts.items():
        lines, keys = windows(text)
        wins[f] = (lines, keys)
        for i, k in enumerate(keys):
            index.setdefault(k, []).append((f, i))
    hits = set()
    for c in ok:
        for i, k in enumerate(wins[c][1]):
            for f, j in index[k]:
                if f == c and abs(i - j) < WINDOW:
                    continue
                hits.add(min((c, i, f, j), (f, j, c, i)))
    for a, i, b, j in sorted(hits):
        if (a, i - 1, b, j - 1) in hits:
            continue
        n = 0
        while (a, i + n + 1, b, j + n + 1) in hits:
            n += 1
        la, lb = wins[a][0], wins[b][0]
        span = la[i + n + WINDOW - 1][0] - la[i][0] + 1
        add("similar", "%d lines" % span, (a, la[i][0]), (b, lb[j][0]))
    if "jscpd" not in missing and ok:
        for name, a, b in jscpd_pairs(root, ok):
            add("similar", name, a, b)

    # data
    for c in ok:
        text = texts[c]
        if ext(c) == ".json":
            cursor = {}
            for kind, name in events[c]:
                if kind == "key":
                    lines = match_lines(text, '"' + re.escape(name) + r'"\s*:')
                else:
                    lines = match_lines(text, '"' + re.escape(name) + '"')
                n = cursor.get((kind, name), 0)
                cursor[(kind, name)] = n + 1
                if len(lines) >= 2:
                    n = min(n, len(lines) - 2)
                    add(kind, name, (c, lines[n]), (c, lines[n + 1]))
        elif ext(c) in KV_EXT:
            mine = kv_entries(text)
            for x, (k, line, v) in enumerate(mine):
                for k2, line2, v2 in mine[x + 1:]:
                    if k2 == k:
                        add("key" if v2 == v else "value", k, (c, line), (c, line2))
            for f, other in texts.items():
                if f == c or ext(f) != ext(c):
                    continue
                theirs = {}
                for k2, line2, v2 in kv_entries(other):
                    theirs.setdefault(k2, []).append((line2, v2))
                for k, line, v in mine:
                    for line2, v2 in theirs.get(k, []):
                        add("key" if v2 == v else "value", k, (c, line), (f, line2))

    if missing:
        print("not installed: " + ", ".join(missing))
    for path, reason in skipped:
        print("skipped: %s — %s" % (path, reason))
    lines = [line for _, line in sorted(found.values())]
    for line in lines:
        print(line)
    print("dups: none" if not lines else "dups: %d candidates" % len(lines))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
