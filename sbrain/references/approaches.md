# Approaches. Design by parts (the "Large" path)

Read at step 5 — when the survey is finished — and at step 6, when the approach is chosen.

## 5. Approaches

If several plausible directions remain, offer 2–3. **First show all of them, then recommend**: a recommendation made before the user has seen the alternatives anchors them to the first one. About each: the essence in 2–3 sentences, the pros and cons, the main risk, when it is appropriate, and what it is — a repeat of something ready-made in the project, an extension of what exists or something new.

- At least one approach is non-obvious: do the opposite, remove a constraint, take a solution from another field.
- When appropriate — one option "with benefit to spare": a neighbouring addition or a different framing that noticeably increases the benefit without a disproportionate price. It is a contender, not the default choice.
- An approach that fits any project of this kind — sharpen it for this one or throw it out.
- Distinguish approaches by the mechanism and by what the user will get ("a pause is a property of the rule" versus "a pause is a separate entity"), not by the names of tables and files.
- For a new product the approaches differ in **what** we build (the shape of the product, who it is for, how it differs from the neighbouring ones), not in how it is made.

Recommend the one that reaches the goal with the smallest addition. If there is one direction, name it plainly; do not invent alternatives for the sake of the count.

Cut the excess: the simplest thing that gives a real benefit. The price is not the effort of writing but what will have to be maintained afterwards.

## 6. Design by parts (the "Large" path)

Show the design in sections in one message and ask for consent with one request — a question per section; if a section has been corrected, show it again and ask about it alone. In the sections: what the user gets, what parts it consists of, how the data flows, what happens on errors, how we will check. A simple section is a couple of sentences, a complex one — up to 200–300 words.

Split into parts with one clear job and clear boundaries: of each it must be possible to say what it does, how to use it and what it depends on. In existing code follow its structure; edits to neighbouring code — only those needed for this goal.

The approved sections go into the `design.md` card of the topic folder — in the form in which they were approved.

The "show, not describe" rule from step 4 applies here too.
