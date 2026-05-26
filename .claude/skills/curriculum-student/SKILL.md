---
name: curriculum-student
description: >
  Simulate a student working through a Ruby Schoolyard assignment to validate it
  before publishing. Use whenever Jeff says "test assignment X", "validate this
  assignment", "run the student agent on X", "check if assignment 01 works",
  "does this assignment work", "simulate a student", or any variant of wanting
  to verify a curriculum assignment is correct and well-formed. Works on exactly
  one assignment per run. Produces a quality report covering completability,
  README clarity, spec error message quality, difficulty calibration, and concept
  scope (including flagging specs that require knowledge not yet covered in the
  curriculum at that phase).
---

# Curriculum Student

You are simulating a junior Rails developer working through a Ruby Schoolyard
assignment cold — no prior knowledge of the solution. Your job is twofold:
(1) complete the assignment exactly as a student would, and (2) assess its
quality as a curriculum piece so the author can improve it before publishing.

The tension to hold: be a fair, earnest student (don't cheat by over-reasoning
about what the "right" answer must be), but also observe everything a real
student would struggle with.

---

## Setup

**Repo root:** `/Users/jeffprice/git/ruby_schoolyard`

Parse the target assignment from the user's message. Accept any of:
- A number: `"01"` or `"1"` → find `assignments/01-*`
- A slug: `"01-building-the-schema"` → `assignments/01-building-the-schema`
- A full path: `assignments/01-building-the-schema`

If the user names more than one assignment, ask which to run first — this skill
handles one at a time.

---

## What NOT to read

Do not read `.teacher_notes.md`. You are a student — that file is invisible to
you. Read only what a real student has access to: `README.md`, spec files, and
the model skeletons in `app/models/`.

Do not look at any `solution/*` branch.

---

## Step 1: Understand the curriculum context

Before touching the assignment, read:

```
/Users/jeffprice/git/ruby_schoolyard/activerecord_curriculum.md
```

Find this assignment's phase, its stated concepts, and — critically — the full
list of concepts covered in *all earlier phases*. You'll need this for the scope
check at the end. The rule is: a spec may rely on concepts from earlier phases
(that's fine and expected), but must not require concepts from *later* phases.

---

## Step 2: Create a test branch

```bash
git -C /Users/jeffprice/git/ruby_schoolyard checkout -b student/test-<slug>
```

---

## Step 3: Verify the starting state

From inside the assignment directory:

```bash
bundle install
bundle exec rspec
```

**If `bundle install` fails:** stop immediately and report — this is a
curriculum infrastructure bug, not a student problem.

**If any specs already pass** before you write any code: flag them as
"pre-passing specs" in your report. A spec that passes against an empty skeleton
is testing the wrong thing.

Record the total number of specs.

---

## Step 4: Read the assignment as a student

Read in order:
1. `README.md` — your instructions
2. All files in `spec/models/` and `spec/requests/`
3. Model skeletons in `app/models/` (these show what is *given* vs. what you must write)

While reading, note:
- Any instruction in the README that is vague or incomplete
- Any spec whose initial failure message is cryptic or doesn't point toward a fix
- Any spec that seems to require knowledge outside this assignment's stated concepts

---

## Step 5: Implement the solution (max 3 attempts)

Write only what the specs require — migrations, model methods, scopes, callbacks,
etc. Don't implement concepts beyond what's needed to make the specs pass.

After each attempt, run:

```bash
rails db:migrate 2>&1
bundle exec rspec 2>&1
```

Each write → migrate → test cycle counts as one attempt. On failure, read the
error output carefully and adjust. If `rails db:migrate` itself errors, that
counts as a failed attempt.

Stop after 3 attempts regardless of outcome.

---

## Step 6: Commit the solution

Whether passing or not, commit what you have:

```bash
git -C /Users/jeffprice/git/ruby_schoolyard add assignments/<slug>/
git -C /Users/jeffprice/git/ruby_schoolyard commit -m "student attempt: <slug>"
```

---

## Step 7: Write the quality report

Use the format below. Be specific — vague observations ("the README could be
clearer") aren't useful. Quote the spec or the README line you're commenting on.

---

## Report format

```
# Student Simulation Report — Assignment [N]: [Title]

## Outcome
[✅ All N specs passing — completed in X attempt(s)]
[⚠️  X of N specs passing after 3 attempts — see attempt log]

## Attempt log
Attempt 1: [What you wrote. What passed. What failed and why.]
Attempt 2: [What you changed. Result.]
Attempt 3: [What you changed. Result.]

---

## Quality Assessment

### README clarity
Rating: Clear | Needs work | Unclear

[Were the getting-started steps complete? Could a junior dev follow them without
guessing? Quote any instruction that was missing, ambiguous, or misleading.]

### Spec failure message quality
Rating: Helpful | Adequate | Confusing

[When a spec fails, does the error message tell the student what to do? For any
confusing failure, quote the message and explain what's missing. Good messages
point toward the solution; bad ones leave the student staring at a stack trace.]

### Difficulty calibration
Rating: Too easy | About right | Too hard — for Phase [N]

[Justify based on: how many attempts it took, how much reasoning was required,
and whether the difficulty feels right for where this assignment sits in the
curriculum. If too hard or too easy, suggest what would fix it.]

### Concept scope

**Stated concepts with specs:**
[List each concept from the README/curriculum that has at least one spec testing it.]

**Stated concepts with no spec:**
[List any concept the README teaches but no spec exercises. These are taught but
untested — a student could skip them and still go green.]

**Concepts required by specs that haven't been taught yet:**
[For each out-of-scope spec, quote the spec and name the future concept it
requires and which phase/assignment introduces it. This is the most important
flag — it breaks the progressive nature of the curriculum.]

**Prior-phase concepts reused:**
[Note any — this is expected and fine.]

---

## Recommendation
Publish as-is | Minor revisions needed | Needs significant work

[One paragraph: the most important thing to fix, if anything. Be direct.]
```

---

## Step 8: Ask about the branch

After delivering the report, ask the author:

> "The solution is committed to `student/test-<slug>`. Want to inspect it, or
> shall I delete the branch and clean up?"

On "delete" or similar:
```bash
git -C /Users/jeffprice/git/ruby_schoolyard checkout main
git -C /Users/jeffprice/git/ruby_schoolyard branch -D student/test-<slug>
```
