# Simplification

Read at step 5 by `references/finish.md`, section 5.

Header of both tasks:

```
Project root: <path>. Reply in English. Changed files: <paths>; before the work: <the path to base/>.
New files: <paths>. The plan: <the path to the topic folder or the text>.
Look only at the code of this work. Change nothing — only read.
Delete nothing outside the project folder, temporary folders included.
```

## Reuse

```
Find new code that repeats something equal in behaviour:

1. This project's functions and helpers — search by meaning, not by name.
2. The standard library, the language and the runtime.
3. Guarantees of the platform, framework or nearby code redone by hand: a check made above,
   a conversion already done.

Search the whole project, not only the changes.

Propose a replacement only if the behaviour is the same for the values here,
locale, order, sort stability, serialization and error text included.

Return the findings as a list:
- kind: reuse
- place: file:line
- what: what is repeated
- instead of: what to take, with the path and the name

Nothing to name — say so.
READ: <the paths of the files you opened and read> — as one line after all the findings.
```

## What is redundant

```
Find code without which the result is the same; per piece take the first rung that fits:

1. Delete — nobody asked for it or calls it.
2. Reuse — the project already has the same thing.
3. Take it from the standard library or the runtime.
4. Simplify in place — needed, but can be smaller.

What to look for:
- dead code: not called, unreachable, commented out. "Not called" only after searching the
  whole project, calls by a name in a string included (scripts, settings, tables, reflection);
  not sure — do not name it;
- wrappers, classes and parameters with one place of use and one value;
- checks of values the caller or the type guarantees;
- try/except and the like around code that does not throw;
- single-use variables, types and re-exports;
- comments that retell the code.

Leave and do not name: checks at the system boundaries (user input, external calls, file I/O,
network, database), protection against data loss, security checks, what the plan says to do
exactly this way.

Return the findings as a list:
- kind: redundant
- place: file:line
- what: what is superfluous and why the result stays the same
- guarantee: for a superfluous check — file:line where the value is already checked
  or guaranteed; for dead code — where you searched for calls
- instead of: "delete" or what to replace it with

Nothing to name — say so.
READ: <the paths of the files you opened and read> — as one line after all the findings.
```

## What not to touch

A simplification edit:

- **does not change the behaviour** — outputs, errors, side effects and their order stay;
- **does not remove checks at the boundaries of the system**, protection against data loss and security checks;
- **does not cancel the plan's "Technical decisions"**, deliberate duplication or separation included;
- **does not go beyond the changes of this work**.

Skip a finding whose kept behaviour cannot be established, and a superfluous-check or dead-code finding without a named guarantee.

Goal: nothing superfluous, not fewer lines.
