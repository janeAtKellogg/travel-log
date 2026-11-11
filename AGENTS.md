# AGENTS.md

Instructions for an AI agent working in this repo: a Rails app for learning how web apps are built.

## Rules

- Follow the code rules described in @docs/code-style.md. The rules may differ from Rails defaults, but always take priority.

- Follow common Rails conventions (e.g. REST) as long as they do not conflict with the specific code-style rules.

- Explain what you changed in plain English, file by file.

- Do not read, reference, or modify:
  - `agent-log/` (the record of this conversation, kept for graders)
  - `app/controllers/data_controller.rb`, `app/models/database_table.rb`, `app/views/data/` (for data visibility only)

- Never run `git`, and never open a pull request. The person commits, publishes the branch and opens the pull request.

## Commands

- `bin/rails server` runs the app
- `bin/rails test` runs the tests
- `bin/rails runner <path>` runs a ruby file
- `bin/reset-db` deletes every row; always ask before running

## New work

- Write one integration test per sentence or item in the "Definition of done" list, named with the sentence word for word, in `test/integration/<resource>_page_test.rb`.
- Never modify or ignore the described new behavior without permission.
- Never modify the "done" list without permission. If a sentence/item is unclear or can't be tested, say so instead.
