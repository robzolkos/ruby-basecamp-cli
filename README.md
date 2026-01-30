# Basecamp CLI

A simple command-line interface for Basecamp. List projects, browse card tables (Kanban boards), view cards, and move cards between columns.

## Features

- **List projects** - See all projects in your Basecamp account
- **Browse boards** - View card tables and their columns within a project
- **List cards** - See all cards in a board, optionally filtered by column
- **View card details** - See full card info including description and comments
- **Move cards** - Move cards between columns

## Installation

### From RubyGems

```bash
gem install basecamp-cli
```

### From source

```bash
git clone https://github.com/robzolkos/ruby-basecamp-cli.git
cd ruby-basecamp-cli
bundle install
```

Then either:
- Run directly: `./bin/basecamp`
- Add to PATH: `export PATH="$PATH:/path/to/basecamp-cli/bin"`
- Install as gem: `rake install`

### Requirements

- Ruby 3.0+

## Setup

### 1. Register your application with Basecamp

Go to [launchpad.37signals.com/integrations](https://launchpad.37signals.com/integrations) and register a new application.

You'll need to provide:
- **Name**: e.g., "Basecamp CLI"
- **Redirect URI**: `http://localhost:3002/callback`

After registering, you'll receive:
- **Client ID**
- **Client Secret**

You'll also need your **Account ID**, which is the number in your Basecamp URL:
```
https://3.basecamp.com/YOUR_ACCOUNT_ID/...
```

### 2. Configure the CLI

Run the init command and enter your credentials:

```bash
./bin/basecamp init
```

This saves your configuration to `~/.basecamp.json`.

### 3. Authenticate

```bash
./bin/basecamp auth
```

This opens your browser for OAuth authorization. After approving, the token is saved to `~/.basecamp_token.json`.

## Commands

### `basecamp projects`

List all projects in your account.

```
$ basecamp projects
Projects
============================================================
[*] 12345678  Website Redesign
    Main company website overhaul
[*] 23456789  Mobile App
    iOS and Android development
[ ] 34567890  Old Project
    Archived project

[*] = active
```

**Output:**
- `[*]` indicates active projects, `[ ]` indicates inactive
- Project ID and name on each line
- Description (if set) indented below

---

### `basecamp boards <project_id>`

List card tables (Kanban boards) in a project, with column summary.

```
$ basecamp boards 12345678
Card Tables in: Website Redesign
============================================================
87654321  Development Tasks

Columns:
  - Backlog (12 cards)
  - In Progress (3 cards)
  - Review (2 cards)
  - Done (45 cards)
```

**Output:**
- Board ID and title
- List of columns with card counts

---

### `basecamp cards <project_id> <board_id> [--column <name>]`

List cards in a board. Use `--column` to filter by column name (partial match).

```
$ basecamp cards 12345678 87654321
Cards: Development Tasks
======================================================================

Backlog (12)
----------------------------------------
  11111111  Fix login validation
           by Jane Smith
  22222222  Add password reset flow
           by John Doe
  33333333  Update API documentation
           by Jane Smith

In Progress (3)
----------------------------------------
  44444444  Implement dark mode
           by John Doe
```

With column filter:

```
$ basecamp cards 12345678 87654321 --column "Progress"
Cards: Development Tasks
======================================================================

In Progress (3)
----------------------------------------
  44444444  Implement dark mode
           by John Doe
  55555555  Refactor authentication
           by Jane Smith
  66666666  Add unit tests
           by John Doe
```

**Output:**
- Cards grouped by column
- Card ID and title
- Creator name

---

### `basecamp card <project_id> <card_id> [--comments]`

View full details of a single card. Use `--comments` to include comments.

```
$ basecamp card 12345678 44444444 --comments
Card: Implement dark mode
======================================================================

ID:       44444444
Creator:  John Doe
Created:  2025-01-15T09:30:00.000Z
Updated:  2025-01-20T14:22:00.000Z
URL:      https://3.basecamp.com/12345678/buckets/.../cards/44444444
Assigned: Jane Smith, Bob Wilson

Description:
----------------------------------------
Add dark mode support to the application. Should respect system
preferences and allow manual toggle. See design specs in Figma.

Comments (2):
----------------------------------------

Jane Smith (2025-01-16T10:00:00.000Z):
I've started on the color palette. Will share preview tomorrow.

John Doe (2025-01-17T09:15:00.000Z):
Looks great! Let's also add a toggle in the settings menu.
```

**Output:**
- Card metadata (ID, creator, timestamps, URL, assignees)
- Full description text (HTML stripped)
- Comments with author and timestamp (when `--comments` flag used)

---

### `basecamp move <project_id> <board_id> <card_id> --to <column>`

Move a card to a different column.

```
$ basecamp move 12345678 87654321 44444444 --to "Review"
Card 44444444 moved to 'Review'
```

**Output:**
- Confirmation message with card ID and target column

---

## Configuration Files

| File | Purpose |
|------|---------|
| `~/.basecamp.json` | Client credentials and account ID |
| `~/.basecamp_token.json` | OAuth access token (auto-generated) |

### `~/.basecamp.json` format

```json
{
  "client_id": "your_client_id",
  "client_secret": "your_client_secret",
  "account_id": "12345678",
  "redirect_uri": "http://localhost:3002/callback"
}
```

## API Coverage

Progress towards full [Basecamp API](https://github.com/basecamp/bc3-api) implementation.

### Projects & Structure
- [x] Projects - list
- [ ] Projects - create, update, delete
- [ ] Basecamps (workspaces)
- [ ] Templates

### Card Tables (Kanban)
- [x] Card tables - list, get
- [x] Card table cards - list, get, move
- [ ] Card table cards - create, update, delete
- [ ] Card table columns - list, create, update, delete
- [ ] Card table steps

### To-dos
- [ ] Todosets
- [ ] Todolists
- [ ] Todolist groups
- [ ] Todos - list, create, update, complete, delete

### Communication
- [ ] Message boards
- [ ] Messages
- [ ] Message types
- [x] Comments - list (on cards)
- [ ] Comments - create, update, delete
- [ ] Campfires (chat)
- [ ] Chatbots

### Documents & Files
- [ ] Vaults (folders)
- [ ] Documents
- [ ] Uploads
- [ ] Attachments

### Schedule
- [ ] Schedules
- [ ] Schedule entries

### Check-ins
- [ ] Questionnaires
- [ ] Questions
- [ ] Question answers

### Email
- [ ] Inboxes
- [ ] Inbox replies
- [ ] Forwards

### Client Portal
- [ ] Client visibility
- [ ] Client approvals
- [ ] Client correspondences
- [ ] Client replies

### People & Permissions
- [ ] People - list, get
- [ ] Subscriptions

### Other
- [ ] Events
- [ ] Recordings
- [ ] Reports
- [ ] Search
- [ ] Timeline
- [ ] Lineup markers
- [ ] Rich text
- [ ] Webhooks

## License

MIT
