---
name: assignment-generator
description: >
  Generate a new Ruby Schoolyard assignment from a filled-in brief. Creates the
  full assignment directory from the template, writes migration, model skeletons,
  specs, factories, README, and teacher notes, then verifies all specs fail before
  committing on a dedicated branch. Use whenever the user provides an assignment
  brief or says "generate assignment", "create assignment", "new assignment",
  "build assignment", or pastes a filled-in brief.
---

# Assignment Generator

## Paths

- **Repo root:** `/Users/jeffprice/git/ruby_schoolyard`
- **Template:** `/Users/jeffprice/git/ruby_schoolyard/assignments/_template`
- **Spec rules:** `/Users/jeffprice/git/ruby_schoolyard/spec_generation_prompt.md`
- **Curriculum:** `/Users/jeffprice/git/ruby_schoolyard/activerecord_curriculum.md`

---

## Brief format

The user provides a brief in this format. **Number**, **Title**, **Phase**,
**Core concept**, **Models**, **Migration**, and **Anti-pattern** are required.
**Scaffolding override** and **Notes** are optional.

```
## Assignment Brief

- **Number:** 04
- **Title:** Connecting the Dots
- **Phase:** 1
- **Core concept:** belongs_to, has_many — basic associations between Product and Category
- **Models:** Product (add category_id), Category (given, no changes)
- **Migration:** add_column :products, :category_id, :integer, null: false
- **Anti-pattern:** no
- **Scaffolding override:** (leave blank to use curriculum default)
- **Notes:** Category is already covered in assignment 02 — keep specs on Product side only
```

---

## Step 1: Parse the brief

Derive these values before touching the filesystem:

- **`number`** — zero-padded string, e.g. `"04"`
- **`title`** — as given, e.g. `"Connecting the Dots"`
- **`slug`** — `"04-connecting-the-dots"` (number + hyphenated lowercase title)
- **`module_name`** — CamelCase of the title words, e.g. `"ConnectingTheDots"`
- **`phase`** — integer
- **`scaffolding_level`** — from the table below unless overridden:

  | Assignment numbers | Scaffolding level |
  |--------------------|-------------------|
  | 01–06A             | FULL HINTS        |
  | 07–09              | HINTS FADING      |
  | 10–46              | NO HINTS          |

- **`time_target`** — from phase:

  | Phase | Target     |
  |-------|------------|
  | 1–4   | 10–20 min  |
  | 5     | 15–25 min  |
  | 6     | 20–25 min  |
  | 7–10  | 20–30 min  |

---

## Step 2: Create the branch

```bash
git -C /Users/jeffprice/git/ruby_schoolyard checkout -b assignment/<slug>
```

---

## Step 3: Copy template and substitute module name

```bash
cp -r /Users/jeffprice/git/ruby_schoolyard/assignments/_template \
       /Users/jeffprice/git/ruby_schoolyard/assignments/<slug>
```

Then edit `assignments/<slug>/config/application.rb`: replace
`MODULE_NAME_PLACEHOLDER` with the derived `module_name`.

---

## Step 4: Read the spec rules and curriculum

Read both of these files in full before writing any creative content:

1. `/Users/jeffprice/git/ruby_schoolyard/spec_generation_prompt.md` — all spec
   design rules, scaffolding requirements, and pattern guidelines. Apply every
   rule in it.
2. `/Users/jeffprice/git/ruby_schoolyard/activerecord_curriculum.md` — confirm
   the assignment's phase and which concepts have already been covered in earlier
   assignments. Specs must not require knowledge from later phases.

---

## Step 5: Write the creative files

Produce these files under `assignments/<slug>/`:

### `db/migrate/<timestamp>_<migration_name>.rb`
Use timestamp `2024<zero-padded-number>000001` (e.g. assignment 04 →
`20240400000001`). Match the migration name to the brief.

### `app/models/<name>.rb` — one per model
Skeleton only: class definition, given associations/validations, NO implementation
of the concept under test. For anti-pattern assignments, pre-write the broken
code as specified in `spec_generation_prompt.md`.

**`optional: true` rule:** If a foreign key column is nullable in the migration,
the corresponding `belongs_to` declaration in the model AND every code example
in the README must use `optional: true`. Rails 5+ requires associations by
default — omitting `optional: true` on a nullable foreign key causes
`ActiveRecord::RecordInvalid` errors whenever a record is created without that
association, including in factory-created control records in unrelated specs.
This produces deeply confusing failures that point nowhere near the real fix.

### `spec/factories/<name>.rb` — one per model
FactoryBot with Faker. Minimal — only attributes the specs need.

### `spec/models/<name>_spec.rb`
Failing specs applying all rules from `spec_generation_prompt.md`. Every spec
must fail against the empty skeleton. No spec may pre-pass.

### `README.md`
- **FULL HINTS:** concept explanation, doc links, worked example from a different
  domain, task description.
- **HINTS FADING:** brief concept description and doc links only. No worked example.
- **NO HINTS:** omit the README entirely — specs only.

### `.teacher_notes.md`
What the learner must implement (method/validation table), common mistakes,
spec count, SQLite notes if relevant. Never duplicate README content here.

---

## Step 6: Install dependencies and migrate

```bash
cd /Users/jeffprice/git/ruby_schoolyard/assignments/<slug> && bundle install 2>&1
cd /Users/jeffprice/git/ruby_schoolyard/assignments/<slug> && bundle exec rails db:migrate 2>&1
```

If `bundle install` fails: stop and report as an infrastructure bug — do not proceed.

---

## Step 7: Verify all specs fail

```bash
cd /Users/jeffprice/git/ruby_schoolyard/assignments/<slug> && bundle exec rspec 2>&1
```

**Required outcome:** N examples, N failures — nothing passing.

**If any spec pre-passes:** abort. Report which spec passed and why the skeleton
accidentally satisfied it. This must be fixed before committing — a pre-passing
spec is testing the wrong thing.

Note the failure messages: are they clear and actionable? If any are cryptic,
fix the spec before committing.

---

## Step 8: Commit on the branch

```bash
git -C /Users/jeffprice/git/ruby_schoolyard add assignments/<slug>/
git -C /Users/jeffprice/git/ruby_schoolyard commit -m "Add assignment <number>: <Title>

<one sentence describing what the assignment teaches>"
```

Do NOT include Co-Authored-By or any attribution in the commit message.

---

## Step 9: Report and ask to merge

Report:
- Assignment path and branch name
- Spec count and a brief summary of what each spec group targets
- Scaffolding level applied and why
- Failure message quality — are they clear?
- Any notable design decisions (why a spec was structured a certain way,
  any deliberate paired specs, etc.)

Then ask:

> "Assignment committed to `assignment/<slug>`. Ready to merge into main and
> clean up the branch, or would you like to inspect first?"

**On merge:**
```bash
git -C /Users/jeffprice/git/ruby_schoolyard checkout main
git -C /Users/jeffprice/git/ruby_schoolyard merge --ff-only assignment/<slug>
git -C /Users/jeffprice/git/ruby_schoolyard branch -d assignment/<slug>
```

**On inspect:** leave the branch as-is and wait for the user's next instruction.
