# Фразы строк проверки темы quality-tokens: данные, не карточка. Строка проверки берёт фразу по имени переменной.
# Над переменной назван файл, в котором фраза ищется. Перевёл этот файл — замени значение тем же текстом из перевода.
# Значение — регулярное выражение grep или программа awk; одинарных кавычек внутри нет.
# 2: sbrain/SKILL.md
p2_1='/^## Ban on implementation/{a=NR} /^\*\*Confirmation and choice/{b=NR} /^\140sbrain\140 writes to the wiki only after/{d=NR} /^\*\*Before a stop — first/{e=NR} /^## Stages/{c=NR} END{exit !(a && b && c && d && e && a<c && b<c && d<c && e<c)}'
# 5: sbrain/SKILL.md
p5_1='the text of the stage file is not in the context'
# 5: sbrain/SKILL.md
p5_2='from another file, read that one too'
# 7: splan/SKILL.md
p7_1='/^## Ban on implementation/{a=NR} /^## Transitions — only by choice/{b=NR} /^\*\*Before a stop — first/{d=NR} /^## Stages/{c=NR} END{exit !(a && b && c && d && a<c && b<c && d<c)}'
# 10: splan/SKILL.md
p10_1='the text of the stage file is not in the context'
# 10: splan/SKILL.md
p10_2='from another file, read that one too'
# 12: swork/SKILL.md
p12_1='/^## What swork does not do/{a=NR} /^## 4\. Stops/{b=NR} /^\*\*How to run a check/{d=NR} /^\*\*Who writes to the plan and to the wiki/{e=NR} /^\*\*Before a stop — first/{g=NR} /^## Stages/{c=NR} END{exit !(a && b && c && d && e && g && a<c && b<c && d<c && e<c && g<c)}'
# 14: строка исключена — значение не переводится
p14_1='запусти двух проверяющих упрощения'
# 14: строка исключена — значение не переводится
p14_2='Два подагента читают изменения'
# 14: строка исключена — значение не переводится
p14_3='- **закоммитить**'
# 14: строка исключена — значение не переводится
p14_4='- **остановиться**'
# 15: swork/SKILL.md
p15_1='the text of the stage file is not in the context'
# 15: swork/SKILL.md
p15_2='from another file, read that one too'
# 16: splan/references/recon.md
p16_1='find ready-made code in the project'
# 16: splan/references/slicing.md
p16_2='Ready-made code for every slice'
# 17: splan/references/plan-format.md
p17_1='- **Reuse:**'
# 17: splan/references/plan-format.md
p17_2='the name, the signature and the file'
# 17: splan/references/plan-format.md
p17_3='Reuse — verified'
# 18: splan/references/plan-format.md
p18_1='nothing to reuse — searched:'
# 19: splan/references/review.md
p19_1='Claims about the code'
# 19: splan/references/review.md
p19_2='will have to guess'
# 19: splan/references/review.md
p19_3='A second round'
# 20: splan/references/review.md
p20_1='/^\140\140\140/{f=!f; next} !f && /with any code/{a=1} !f && /will break nearby/{b=1} !f && /the "Reuse" field filled in/{c=1} END{exit !(a && b && c)}'
# 21: swork/references/executor.md
p21_1='FUNCTIONS CREATED:'
# 22: swork/references/executor.md
p22_1='without the text of the functions'
# 23: swork/references/executor.md
p23_1='does not replace a search in the project'
# 24: swork/references/small.md
p24_1='name in the chat the ready-made code'
# 25: swork/references/executor.md
p25_1='beyond the check lines passed to you'
# 26: swork/references/executor.md
p26_1='NOTICED:'
# 27: swork/references/report.md
p27_1='Noticed by the executors'
# 27: swork/references/slices.md
p27_2='noticed outside the slice'
# 28: swork
p28_1='two simplification reviewers'
# 28: swork
p28_2='Two subagents read'
# 28: swork
p28_3='Two reviewers read'
# 28: swork/references/finish.md
p28_4='The conformance check and the simplification tasks are read by one reviewer'
# 29: swork/references/simplify.md
p29_1='not only in the changes'
# 29: swork/references/small.md
p29_2='not only in the changes'
# 30: swork/references/finish.md
p30_1='The review is read by a second reviewer — after the edits'
# 31: swork/references/conformance.md
p31_1='READ:'
# 31: swork/references/simplify.md
p31_2='READ:'
# 31: swork/references/review.md
p31_3='READ:'
# 32: swork/references/finish.md
p32_1='Not read by the reviewers'
# 32: swork/references/report.md
p32_2='Not read by the reviewers'
# 33: sbrain/SKILL.md, splan/SKILL.md, swork/SKILL.md
p33_1='the description of each option says what will happen after it'
# 34: sbrain/SKILL.md, splan/SKILL.md, swork/SKILL.md
p34_1='names what exactly is being approved'
# 35: sbrain/SKILL.md, splan/SKILL.md, swork/SKILL.md
p35_1='"Fix" and "Do nothing"'
# 35: sbrain/references/handoff.md
p35_2='Add "Do nothing" to the menu'
# 35: splan/references/approval.md
p35_3='Add "Do nothing" to the menu'
# 36: sbrain/SKILL.md, splan/SKILL.md, swork/SKILL.md
p36_1='in the last line of the message'
# 37: sbrain/references/synthesis.md
p37_1='without a menu: a menu will draw'
# 37: sbrain/references/synthesis.md
p37_2='Ask for consent to the summary with a menu'
# 38: swork/SKILL.md
p38_1='Stop menu'
# 38: swork/references/slices.md
p38_2='^## Stop menu'
# 38: swork/references/slices.md
p38_3='What happens after it'
# 39: swork/references/report.md
p39_1='- **commit**'
# 39: swork/references/report.md
p39_2='- **stop**'
# 39: swork/references/report.md
p39_3='- **do nothing**'
# 39: swork/references/report.md
p39_4='The project is under git — offer a commit as a separate menu after the work is accepted'
# 42: swork/references/finish.md
p42_1='give both tasks from'
# 42: swork/references/finish.md
p42_2='to a reviewer anew'
# 43: swork/references/finish.md
p43_1='only against the fixed files'
# 44: swork/references/slices.md
p44_1='remove the line'
# 44: swork/references/slices.md
p44_2='S<N>: name(signature)'
# 44: swork/references/snapshot.md
p44_3='S<N>: name(signature)'
# 45: swork/references/report.md
p45_1='remember it before step 6'
# 46: swork/references/small.md
p46_1='except for the task about duplicates'
# 47: swork/references/entry.md
p47_1='Start a small change by reading'
