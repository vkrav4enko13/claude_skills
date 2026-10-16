# Simplification

Read before the conformance check is started, if the slices added new code: both tasks go to the reviewer of the conformance check. The edits are at step 6, after the edits of the conformance check and before the review. There is no new code — the stage is skipped, the file is not needed.

Both tasks are read by the reviewer of the conformance check, and it changes nothing. You do the editing — by the "What not to touch" section.

The shared header of both tasks:

```
Project root: <path>. Reply in English. Changed files: <paths>; their state before the work is
in <the path to base/>. New files: <paths>. The plan: <the path to the topic folder or the text>.
Look only at the code that appeared in this work. Change nothing — only read.
Delete no file and no folder outside the project folder, temporary folders included.
```

## Reuse

```
Find where the new code repeats what already exists. For every new piece
look for something equal in behaviour:

1. The functions and helpers of this project. Search by meaning, not by name:
   the same action may be called differently and lie in another folder.
2. The facilities of the standard library, the language and the runtime.
3. Guarantees of the platform, the framework or the neighbouring code which the new code
   maintains by hand: a check of what is already checked above,
   a conversion of what is already converted.

Search across the whole project, not only in the changes.

Propose a replacement only if the behaviour is the same for the values that
occur here. Differences in locale, order, sort stability, serialization,
the error text are a reason not to propose it.

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
Find the code without which the result is the same. For every piece go down the ladder
from the top and stop at the first rung that fits:

1. Delete it entirely — the behaviour is not needed: nobody asked for it and nobody
   calls it.
2. Reuse — the project already has the same thing.
3. Take it from the standard library or the runtime.
4. Simplify it in place — the code is needed, but it can be smaller.

What to look for:
- dead code: what is not called, not reachable, commented out.
  Claim "not called" only after a search across the whole project, including
  calls by a name in a string: scripts, settings, tables, reflection.
  Not sure — do not name it;
- wrappers, classes and parameters that have one place of use
  and one value;
- checks of values that are guaranteed by the calling code or by the type;
- try/except and the like around code that does not throw;
- variables, types and re-exports for a single use;
- comments that retell the code.

What to leave and not name:
- checks at the boundaries of the system: user input, external calls,
  reading and writing files, the network, the database;
- protection against data loss and security checks;
- what the plan tells you to do exactly this way.

Return the findings as a list:
- kind: redundant
- place: file:line
- what: what is superfluous and why the result is the same without it
- guarantee: for a superfluous check — file:line where the value is already checked
  or guaranteed; for dead code — where you searched for calls
- instead of: "delete" or what to replace it with

Nothing to name — say so.
READ: <the paths of the files you opened and read> — as one line after all the findings.
```

## What not to touch

A simplification edit:

- **does not change the behaviour** — the outputs, the errors, the side effects and their order stay the same;
- **does not remove checks at the boundaries of the system**, protection against data loss and security checks;
- **does not cancel the plan's "Technical decisions"**, including deliberate duplication or separation;
- **does not go beyond the changes of this work**: someone else's code nearby is not edited, even if it is worse.

It cannot be established that the behaviour is preserved — the finding is skipped. A finding about a superfluous check or dead code that has no named guarantee is skipped in the same way: a check without a proven duplicate is holding something.

The goal is the absence of anything superfluous, not the number of lines: clear code of ten lines is better than clever code of three.
