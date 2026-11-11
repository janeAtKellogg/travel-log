# travel-log

A journal of trips you have already taken: the places you've been, and what happened at each
one. Every entry is something that happened, on the day it happened. It is not a list of places
you want to go or things you plan to do.

The app has two tables and no pages yet. You build the pages one ticket at a time: write the
ticket, let your agent build it, check its work, land it with a pull request. Four stories, four
tickets, four pull requests.

## Getting started

1. On this repo's GitHub page, choose **Use this template**, then **Create a new repository**.
   Make the copy in your own account, name it `travel-log`, and choose **Private**. Then add
   the graders (see "Private, with collaborators" below).
2. On your copy, choose **Code**, then **Codespaces**, then **Create codespace on main**. The
   first start takes a few minutes: it installs the gems and the agent CLIs and creates the
   database with three places and five entries.
3. In the terminal, start the app:

       bin/rails server

   Leave that terminal running; open a second one for everything else. When the Codespace
   offers to open port 3000 in the browser, take it (or find it later under **Ports**). The
   home page has two links. **Data** shows the tables and their rows. **Places** shows a
   routing error, because no route matches it yet; that's the first ticket.
4. Start your agent in the second terminal (`claude`, `codex` or `agy`) and sign in. The
   `agent-setup` repo's README has the details.

If the server isn't running, the browser shows "connection refused" or a 502. Start it again
with `bin/rails server`.

## The stories

The app is for you alone; several users come later.

1. As me, I want to see a list of the places I've been, so I can remember them and find their
   entries.
2. As me, I want to add a place I've been, with its name, so it shows up in the list.
3. As me, I want to click a place and see its entries, so I remember what I did there.
4. As me, I want to log an entry for a place (a title, a description, and the day it
   happened), so I keep track of what I did in each place.

The tables are already there: `places` has a `name`; `entries` has a `title`, a
`description`, an `occurred_on` date, and a `place_id`, the `id` of the place it happened at.
Nothing in `db/` needs to change.

## The shape of a ticket

A ticket is a GitHub issue. Its title is the feature. Its body is the story, then a heading
**Definition of done**, then three to five sentences that say when the feature is finished.
Each sentence is something a test can check: what the page shows, what submitting the form
creates, where the user lands afterwards. Written for the person using the page, not for the
code.

A sentence a test can check:

- The place's page lists each of its entries with its title and the day it happened.
- Submitting the form creates an entry for that place with the title, description and date
  that were entered.
- After submitting, the user lands on the place's page and sees the new entry there.

A sentence nobody can test: "the page is easy to use", "the form looks good", "entries work".
If you can't say what a test would look at, rewrite the sentence until you can.

An entry, for the sentences and the tests: "Grilled sardines in Alfama", on 2026-03-15, in
Lisbon. Something that happened.

## The loop, once per story

1. **Write the ticket.** On your repo's GitHub page: **Issues**, **New issue**. Title, story,
   **Definition of done**, the sentences. **Create**. Note its number. Issues and pull
   requests share one sequence of numbers, so after the first PR your second ticket is `#3`,
   not `#2`; the number is in the issue's title on GitHub.
2. **Branch.** In the bottom-left corner of the Codespace, click `main`, choose **Create new
   branch**, type a name for the feature (`places-list`), Enter. The corner now says the
   branch's name. Never build on `main`.
3. **Prompt.** In your agent:

       Read issue #1 and build it.

   Use the ticket's own number. If you give the agent a pull request's number by mistake, it
   reads the PR and builds from that instead. `AGENTS.md` tells the agent the rest: the code rules, one test per sentence named with the
   sentence, no `git`. The agent does not run the tests for you.
4. **Check.** Run the tests yourself:

       bin/rails test

   Open `test/integration/` and read the test names against your sentences: one per sentence,
   word for word. Then read each test's body (see "Reading a test" below). Then use the page in
   the browser: do what the story says a user does, and see whether what the sentences promised
   happened. A sentence with no test, or a test that doesn't check its sentence, goes back to
   the agent now, before anything is committed.
5. **Commit and publish.** In Source Control, stage everything, write a message that says what
   changed ("Add the places list page, with tests"), **Commit**, then **Publish Branch**.
6. **Open the pull request.** On your repo's GitHub page a banner offers **Compare & pull
   request**. Title: the ticket's title. Body: `closes #1` (the issue number) and a sentence
   on what was built. **Create pull request**.
7. **Review it, then merge or send it back.** On the PR: **Files changed**, read the diff, then
   **Review changes**. In the review, walk the chain for this story, one line each:

   - Does the ticket say only what the story needs?
   - Does every sentence have a test named for it?
   - Does each test check its sentence? Say what you read in the test body.
   - Does the page do it when you use it?
   - Did the agent build anything the story didn't ask for?

   GitHub won't let you approve your own pull request, so choose **Comment** and **Submit
   review**. If every answer holds, **Merge pull request**, **Confirm merge**, **Delete
   branch**. If one doesn't, say which, go back to your agent on the same branch, commit and
   sync; the PR updates on its own, and you review again.

Then the next story. When all four are merged, `main` has the app and the **Issues** tab has
four closed tickets. The URL of your repo is what you turn in.

## Reading a test

A test's name is a sentence from your ticket. Its body has to check that sentence, not
something easier. A test proves its sentence when it asserts the thing the sentence named:
the place's name in the list, the entry on its place's page, the address the user landed on.
A test that visits the page and asserts only that it loaded, or asserts a heading where the
sentence promised a new row, has a good name and proves nothing. Read for the line that
checks the promise; if it isn't there, the sentence isn't done.

Here is a test that proves "After submitting, the user lands on the place's page and sees the
new entry there":

```ruby
test "After submitting, the user lands on the place's page and sees the new entry there." do
  place = Place.new
  place["name"] = "Lisbon"
  place.save

  post("/entries", :params => { "title" => "Grilled sardines in Alfama", "description" => "Six of them.", "occurred_on" => "2026-03-15", "place_id" => place["id"] })

  assert_redirected_to("/places/#{place["id"]}")
  follow_redirect!
  assert_select("li", /Grilled sardines in Alfama/)
end
```

The redirect is checked to a specific address, and the entry is looked for on the page it
landed on. Without those two assertions the test would pass for a page that did neither.

## The pattern

Every resource gets the same seven actions. One line in `config/routes.rb` makes all seven
routes: `resources("places")`.

| Action | What it does | Method | Path | Has a view? |
|---|---|---|---|---|
| `index` | list every place | GET | `/places` | yes |
| `show` | one place | GET | `/places/7` | yes |
| `new` | the form for a new place | GET | `/places/new` | yes |
| `create` | save the form, then redirect | POST | `/places` | no |
| `edit` | the form for an existing place | GET | `/places/7/edit` | yes |
| `update` | save the form, then redirect | PATCH | `/places/7` | no |
| `destroy` | delete it, then redirect | DELETE | `/places/7` | no |

The four stories need `index`, `show`, `new` and `create` for places, and `new` and `create`
for entries. The other actions exist in the routes once the line is there; nobody asked for
their pages. `bin/rails routes` prints every route the app has.

A page needs three files: a line in `config/routes.rb`, a method in
`app/controllers/<resource>_controller.rb`, and the view
`app/views/<resource>/<action>.html.erb`. An action that redirects has no view. `@name` in an
action is how a value gets to the view.

## The data

`scripts/create_data.rb` creates the rows. Change it and run it again any time:

    bin/rails runner scripts/create_data.rb

It deletes the places and entries first, so it always ends with exactly the rows in the file.
`bin/rails runner scripts/show_data.rb` prints every table in the terminal, and `/data` shows
them in the browser. `bin/reset-db` rebuilds the empty tables from `db/migrate/` when the
database is in a state you can't explain.

The tests make their own rows and never see these.

## Working with an agent

`AGENTS.md` tells your agent how work happens here: one test per sentence, the code rules it
points at in `docs/code-style.md` (plain forms, `params` as strings, hash-style columns, one
`resources` line per resource), and that it never runs `git`. You commit, you publish, you open
the pull request, you decide whether to merge.

Every conversation with your agent here is copied into `agent-log/`; leave that folder alone.
It is there in case a grader has a question the pull request doesn't answer.

## Private, with collaborators

Your copy is private, so nobody can see it until you add them, the way you would on any real
project. When you click **Use this template**, choose **Private**. Then, on your new
repository's page on github.com:

1. **Settings** (the tab at the top), then **Collaborators** in the left bar. GitHub may ask
   for your password.
2. **Add people**. Type `bjblock`, pick it from the list, **Add to repository**.
3. Again for `mrjonesbot`, and again for `emplumb`.

All three show as pending until they accept, and that's fine. Already made your copy public?
**Settings**, scroll to the bottom, **Change visibility**, **Private**.

If you'd like a second pair of eyes on a pull request, add a classmate the same way; they can
approve or request changes, which you can't on your own PR. Their review is welcome and not
required.
