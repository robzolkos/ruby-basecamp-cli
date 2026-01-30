---
name: basecamp
description: Interact with Basecamp projects and card tables via CLI. List projects, browse Kanban boards, view cards with comments, and move cards between columns. Use when the user mentions Basecamp, card tables, Kanban boards, or wants to check project status.
---

# Basecamp CLI

Interact with Basecamp projects and card tables using the `basecamp` command.

## Prerequisites

The CLI must be installed and authenticated:

```bash
basecamp version  # Verify installation
basecamp projects  # Verify authentication
```

If not authenticated, the user needs to run `basecamp auth`.

## Commands

### List projects

```bash
basecamp projects
```

Output:
```
Projects
============================================================
[*] 12345678  Website Redesign
    Project description here
[*] 23456789  Mobile App

[*] = active
```

### List boards in a project

```bash
basecamp boards <project_id>
```

Output:
```
Card Tables in: Website Redesign
============================================================
87654321  Development Tasks

Columns:
  - Backlog (12 cards)
  - In Progress (3 cards)
  - Done (45 cards)
```

### List cards

```bash
basecamp cards <project_id> <board_id>
basecamp cards <project_id> <board_id> --column "In Progress"
```

Output:
```
Cards: Development Tasks
======================================================================

In Progress (3)
----------------------------------------
  44444444  Implement dark mode
           by John Doe
  55555555  Refactor authentication
           by Jane Smith
```

### View card details

```bash
basecamp card <project_id> <card_id>
basecamp card <project_id> <card_id> --comments
```

Output:
```
Card: Implement dark mode
======================================================================

ID:       44444444
Creator:  John Doe
Created:  2025-01-15T09:30:00.000Z
Updated:  2025-01-20T14:22:00.000Z
URL:      https://3.basecamp.com/.../cards/44444444
Assigned: Jane Smith

Description:
----------------------------------------
Add dark mode support to the application.

Comments (2):
----------------------------------------

Jane Smith (2025-01-16T10:00:00.000Z):
Started on the color palette.

John Doe (2025-01-17T09:15:00.000Z):
Looks great!
```

### Move a card

```bash
basecamp move <project_id> <board_id> <card_id> --to "Done"
```

Output:
```
Card 44444444 moved to 'Done'
```

## Workflow example

To check what's being worked on and move a completed card:

```bash
# Find the project
basecamp projects

# Find the board
basecamp boards 12345678

# See cards in progress
basecamp cards 12345678 87654321 --column "Progress"

# View details of a specific card
basecamp card 12345678 44444444 --comments

# Move it to Done
basecamp move 12345678 87654321 44444444 --to "Done"
```

## Error handling

If you see "Not authenticated", the user needs to run:
```bash
basecamp auth
```

If you see "Token expired", same fix applies.
