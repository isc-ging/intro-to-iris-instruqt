# Intro to IRIS - Instruqt Track

## What this is

A work-in-progress Instruqt tutorial track giving a whistle-stop tour of InterSystems IRIS as a data platform. The target audience is technically literate but IRIS-naive — developers, architects, or evaluators who want a quick feel for what IRIS can do.

The track runs on the `iris-data-platform` sandbox preset. IRIS runs at `http://iris:52773`, credentials `SuperUser`/`SYS`. VS Code runs at `http://vscode:8080`.

---

## Narrative thread

A single data point — a fictional product "Gummy Rings" (SKU `SKU-976`) — is followed across four IRIS surfaces to show that SQL, code, interoperability, and analytics all operate on the same live data, not separate silos.

1. **SQL** (challenge 2): Insert Gummy Rings at $2.99, explore the HoleFoods relational schema
2. **Code** (challenge 3): Drop the price to $1.99 using ObjectScript + Embedded Python, verify via SQL
3. **Interop** (challenge 4): Submit a web order form, watch it route through an IRIS production, get a status response back
4. **Analytics** (challenge 5): View the HoleFoods BI dashboard; the sale from step 3 is live in the data

---

## Track structure

```
track.yml                                  # sandbox preset: iris-data-platform
01-untitled-challenge-wbobj4/              # Challenge 1: Welcome / Management Portal tour
  assignment.md
  setup-iris                               # bash setup script (runs as irisowner)
02-untitled-challenge-izn5ts/              # Challenge 2: SQL / Data Platform
  assignment.md
03-untitled-challenge-ntemu4/              # Challenge 3: Execution Engine (VS Code + ObjectScript + Python)
  assignment.md
  setup-vscode                             # bash setup script — writes ProductChanges.cls, VS Code settings
04-untitled-challenge-5q6n6x/             # Challenge 4: Integration Layer — STUB, needs building
  assignment.md
05-untitled-challenge-p21wz7/             # Challenge 5: Real Time Analytics (IRIS BI / DeepSee)
  assignment.md
06-untitled-challenge-8zgvwv/             # Challenge 6: Well Done / links to further tutorials
  assignment.md
introp_plan.md                             # Spec for the interop challenge (challenge 4)
docker-compose.yml                         # Local dev: iris-community:latest-cd on port 52773
```

---

## HoleFoods dataset

Pre-loaded sample data from the InterSystems SamplesBI project. Key tables (all in the `USER` namespace):

- `HoleFoods.Product` — products with `SKU`, `Name`, `Category`, `Price`. A `Stock` column needs adding for the interop challenge.
- `HoleFoods.SalesTransaction` — sales records linked to Product and Outlet
- `HoleFoods.Outlet`, `HoleFoods.Country`, `HoleFoods.Region` — geography
- `HoleFoods.Cube` / `HoleFoods.BudgetCube` — DeepSee BI cube definitions
- Dashboards and pivots are defined in `HoleFoods.DashboardsEtc`

The setup script for challenge 1 (`setup-iris`) writes all HoleFoods `.cls` files from scratch into `/home/irisowner/src/HoleFoods/` and imports them into IRIS.

---

## Challenge 3 — what exists

`setup-vscode` writes `/opt/intersystems/src/challenge-3/Intro/ProductChanges.cls` with two methods:
- `PrintProductDetails(pId)` — ObjectScript, reads and prints a product by SKU
- `ChangeProductPrice(pId, pPrice)` — Embedded Python, updates the price and saves

The learner imports and compiles the class via the VS Code ObjectScript extension, then calls both methods from the terminal.

---

## Challenge 4 — what needs building (see introp_plan.md)

The interop challenge is a stub. The spec calls for:

- A minimal web form (`/csp/user/order.csp`) with SKU + Quantity fields, pre-filled with `SKU-976`
- REST endpoint `POST /api/holeFoods/order`
- IRIS production `HoleFoods.Production` containing:
  - `HoleFoods.BS.OrderService` — REST Business Service, dispatches synchronously
  - `EnsLib.MsgRouter.RoutingEngine` — routes bad quantity to RejectOperation, else to OrderProcessor
  - `HoleFoods.BO.OrderProcessor` — looks up SKU, checks stock, writes SalesTransaction
  - `HoleFoods.BO.RejectOperation` — handles qty <= 0
- Message class `HoleFoods.Msg.OrderRequest` with `SKU` and `Quantity`
- `Stock INTEGER DEFAULT 100` added to `HoleFoods.Product`; one product pre-set to Stock=0

The form should display the response string inline so learners get immediate feedback without leaving the page. The Message Viewer in the production portal is then used to show the message trace.

---

## Key conventions

- Setup scripts are bash, run as `irisowner` (challenge 1) or `coder` (challenge 3). Use `su - <user> <<'EOSU' ... EOSU` pattern.
- IRIS classes are written inline in setup scripts using heredocs, then imported via `iris session IRIS` or the ObjectScript extension.
- Challenges are numbered by directory prefix; the slug values in `assignment.md` frontmatter are the Instruqt identifiers — do not change them.
- The `introp_plan.md` file is the working spec for challenge 4; update it as decisions are made.
