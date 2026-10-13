# Фразы строк проверки темы chain-cleanup: данные, не карточка. Строка проверки берёт фразу по имени переменной.
# Над переменной назван файл, в котором фраза ищется. Перевёл этот файл — замени значение тем же текстом из перевода.
# Значение — регулярное выражение grep или программа awk; одинарных кавычек внутри нет.
# 3: tests/chain/collect.sh
p3_1='- **Phase:** requirements confirmed — 2026-10-11\n'
# 6: tests/chain/verdict.sh
p6_1='rule\tsplan-1\tyes\t-\nseed\tseed-1\tfound\treview\n'
# 6: tests/chain/verdict.sh
p6_2='rule\tsplan-1\tno\t-\nseed\tseed-1\tnot found\t-\n'
# 12: splan/references/approval.md
p12_1='Show a plan in cards in the chat in full'
# 13: splan/references/plan-format.md
p13_1='^### Overview — .plan-overview.md.'
# 13: splan/references/plan-format.md
p13_2='is rewritten in full after every edit of the plan cards'
# 14: splan/references/plan-format.md
p14_1='The plan as one file for reading; the source is the slice cards'
# 15: splan/SKILL.md
p15_1='rebuild it from the cards: where they differ, the slice card is right'
# 16: swork/references/entry.md
p16_1='act by the slice card'
# 17: swork/SKILL.md
p17_1='set the same status in the overview'
# 18: swork/references/executor.md
p18_1='The path to the topic folder, the overview .plan-overview.md., the cards of other slices'
# 20: sbrain/references/wiki-rules.md
p20_1='the plan overview .plan-overview.md. have no limit on the number of lines or on the total size'
# 21: splan/references/plan-format.md
p21_1='not as a reference to the requirement number'
# 21: splan/references/plan-format.md
p21_2='the text from R4'
# 22: splan/SKILL.md
p22_1='read all the cards named in its index'
# 23: splan/references/plan-format.md
p23_1='^## Assumptions'
# 23: splan/SKILL.md
p23_2='in the "Assumptions" section of the plan header'
# 24: swork/references/entry.md
p24_1='**Assumptions.** A slice is named in a line of the plan section'
# 24: swork/references/entry.md
p24_2='**Deferred questions.**'
# 25: splan/SKILL.md
p25_1='independent plan review: go to step 8'
# 25: splan/references/approval.md
p25_2='the next step "independent plan review"'
# 25: splan/references/approval.md
p25_3='The review is passed — write the next step into'
# 26: splan/references/plan-format.md
p26_1='plan-s<N>-<name>-2.md.: the slice fields stay in the first part'
# 27: swork/references/entry.md
p27_1='and its parts .plan-2.md.'
# 27: swork/references/entry.md
p27_2='together with its parts'
# 27: swork/references/executor.md
p27_3='with all its parts'
# 28: splan/references/plan-format.md
p28_1='**Marks:** no behavior change'
# 28: splan/references/slicing.md
p28_2='Mark such a slice in the card'
# 29: swork/references/slices.md
p29_1='does not count as a stop'
# 29: swork/SKILL.md
p29_2='it has no .no behavior change. mark'
# 30: swork/SKILL.md
p30_1='S<N>: stopped — expected'
# 31: splan/SKILL.md
p31_1='read "Progress log" — .progress.md. and its parts'
# 32: swork/references/report.md
p32_1='declined: <what was proposed>'
# 32: swork/references/report.md
p32_2='left untouched: <what>'
# 33: swork/references/entry.md
p33_1='show the report from the records of "Progress log"'
# 34: saway/SKILL.md
p34_1='and other slices depend on it'
# 34: saway/SKILL.md
p34_2='is not a stop: .swork. goes on'
# 36: splan/references/approval.md
p36_1='do not advise a new session'
# 36: sbrain/references/handoff.md
p36_2='do not advise a new session'
# 37: splan/references/plan-format.md
p37_1='Status is written by .swork.'
# 37: splan/references/plan-format.md
p37_2='Status is written by the executor'
# 37: splan/references/plan-format.md
p37_3='written by the executor:'
# 37: splan/SKILL.md
p37_4='forward to the executor'
# 38: splan/references/plan-format.md
p38_1='the slice card is fixed by .swork., not by you'
# 38: splan/references/plan-format.md
p38_2='fix it in place and note it in the plan'
# 38: swork/references/executor.md
p38_3='the slice card is fixed by whoever started you'
# 39: swork/references/small.md
p39_1='the prohibitions and rules of each task apply only inside it'
# 40: swork/references/small.md
p40_1='This list replaces the "Files" block of a slice'
# 41: swork/references/small.md
p41_1='^For a plan from the chat and a task without a plan'
# 41: swork/references/small.md
p41_2='do not explore the project more widely'
# 42: swork/references/report.md
p42_1='a repeated start will begin as the first one'
# 42: swork/references/report.md
p42_2='add a line about the rollback'
# 43: swork/SKILL.md
p43_1='When continuing interrupted work it also asks'
# 44: swork/references/slices.md
p44_1='the slice files changed after that check'
# 45: swork/references/executor.md
p45_1='^PITFALLS: '
# 45: swork/references/slices.md
p45_2='from the PITFALLS field of the executor.s reply'
# 46: sbrain/references/context.md
p46_1='name a hypothesis about the task in one sentence'
# 46: sbrain/references/context.md
p46_2='Offer your own solution options only after'
# 47: sbrain/references/synthesis.md
p47_1='there is one consent — the menu of step 8'
# 48: sbrain/SKILL.md
p48_1='While there is no topic folder, there is nothing from it in the wiki'
# 48: sbrain/SKILL.md
p48_2='The rule applies only when the topic folder already exists'
# 49: sbrain/references/handoff.md
p49_1='name how to start what was chosen and do not start it yourself'
# 49: sbrain/references/handoff.md
p49_2='then do what was chosen'
# 50: splan/references/slicing.md
p50_1='The count of lines that you name at step 6 is final'
# 50: splan/references/approval.md
p50_2='the final count, which includes the lines of "Check focus"'
# 51: splan/references/approval.md
p51_1='decide yourself and show the decision as a line'
# 51: splan/references/approval.md
p51_2='A gap is only a case whose answer changes the scope'
# 52: splan/references/approval.md
p52_1='approves everything shown at it: the slicing, the check points and the decisions'
# 52: splan/SKILL.md
p52_2='Consent to the slicing does not approve the plan'
# 53: splan/references/recon.md
p53_1='this is not a stop, do not wait for an answer'
# 54: splan/references/plan-format.md
p54_1='a command that prints the result of the scenario'
# 54: splan/references/review.md
p54_2='The command together with "Expected" would show a breakage'
# 55: splan/references/slicing.md
p55_1='Take the goal from the confirmed goal of the topic'
# 55: splan/references/slicing.md
p55_2='only if the user themselves decided to accept the result by eye'
# 56: splan/references/plan-format.md
p56_1='the result of the scenarios depends on its choice'
# 57: splan/references/plan-format.md
p57_1='(created in S<N>)'
# 58: splan/references/plan-format.md
p58_1='when the slices edit one file'
# 59: sbrain/SKILL.md, splan/SKILL.md, swork/SKILL.md
p59_1='"wait for a .yes.", "wait for an answer" or "wait for a choice"'
# 60: sbrain/references/wiki-rules.md
p60_1='^## The wiki is not kept'
# 60: sbrain/references/context.md
p60_2='section "The wiki is not kept"'
# 60: splan/references/recon.md
p60_3='section "The wiki is not kept"'
# 60: swork/references/slices.md
p60_4='section "The wiki is not kept"'
# 61: sbrain/references/wiki-rules.md
p61_1='it is kept from a temporary folder too'
# 61: splan/references/recon.md
p61_2='the session was started in the home folder or in a temporary folder'
# 62: sbrain/SKILL.md, splan/SKILL.md, swork/SKILL.md
p62_1='not in advance and not from memory'
# 62: sbrain/SKILL.md, splan/SKILL.md, swork/SKILL.md
p62_2='^Read the stage file in full when you reach the stage — not in advance'
# 63: sbrain/references/wiki-rules.md
p63_1='The archive is set up when the first line is moved into it'
# 64: swork/SKILL.md
p64_1='cut the block out with a command into a temporary file'
# 64: splan/references/review.md
p64_2='cut the block out with a command into a temporary file'
# 64: splan/references/review.md
p64_3='in your own words to fit the project'
# 65: все скилы — меняет срез второго прохода S46
p65_1='\*\*Verified:'
# 65: все скилы — меняет срез второго прохода S46
p65_2='\*\*Requirements confirmed:'
# 65: все скилы — меняет срез второго прохода S46
p65_3='without sbrain'
# 65: все скилы — меняет срез второго прохода S46
p65_4='\*\*Path:'
# 65: все скилы — меняет срез второго прохода S46
p65_5='\*\*Path\*\*'
# 66: swork/references/snapshot.md
p66_1='Read once per run'
# 66: swork/references/slices.md
p66_2='Read .references/executor.md. before the first slice'
# 67: swork/references/snapshot.md
p67_1='read it only on Windows'
# 68: splan/references/recon.md
p68_1='Start them in one message'
# 69: sbrain/references/survey.md
p69_1='in one batch, in one message'
# 69: sbrain/references/approaches.md
p69_2='a question per section'
# 83: tests/chain/collect.sh
p83_1='- **Phase:** done — 2026-10-12\n'
# 83: tests/chain/collect.sh
p83_2='- **Status:** done\n'
# 83: tests/chain/collect.sh
p83_3='- **Status:** stopped\n'
# 83: tests/chain/collect.sh
p83_4='- 2026-10-12 · stage 7 finished\n'
