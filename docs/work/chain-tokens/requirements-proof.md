# Requirements of topic chain-tokens: proof and result

> How each kind of edit is accepted, what the final numbers are, and what the edits must leave in place.

## Proof

- R23. A deletion of a duplicate or of dead text is accepted by a blind reading: a reader without hints walks the scenarios on the new text and reaches the same actions as on the old one.
- R24. Edits that change behaviour go in batches by lever group, and each batch is accepted by a three-run series that passes the quality gate of R6; if a batch fails the gate, then the whole batch is reverted.
- R25. The context levers R21 and R22 are accepted when a stand run reaches the handoff menu with the new option and the next skill starts from the topic cards alone.

## Result

- R26. The final series emits at least 10 % fewer output tokens per run than the baseline series of R5 and passes the quality gate of R6.
- R27. The final report gives the saving against the baseline series, the saving against series `en`, and cache write and cache read per run for all three series.
- R28. If the final series saves less than 10 %, then the topic closes with the achieved number marked "threshold not met", and the batches that passed the gate stay.

## Left in place

- R29. The edits leave in place: the next step mirrored in the root index, the notes after each slice, the small-path ritual, `created.txt`, support of earlier formats, the layers of consent, the confidence percent and the tree counter, the trap tables, the set of reviewers and the model.
