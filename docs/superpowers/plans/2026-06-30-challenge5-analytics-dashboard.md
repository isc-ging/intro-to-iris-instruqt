# Challenge 5: Real-Time Analytics Dashboard - Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the current challenge 5 (Analyzer tutorial) with a focused dashboard experience where the learner submits a large order and immediately sees the analytics update — proving IRIS BI operates on live data with no ETL delay.

**Architecture:** A custom DeepSee dashboard with 3 widgets (Revenue by Category bar chart, Units Sold scorecard, Recent Transactions table). A setup script seeds ~15 historical transactions so the dashboard has visual weight. The learner submits a bulk order (qty 50) from the order form, then refreshes the dashboard to see the spike appear instantly.

**Tech Stack:** DeepSee dashboard/pivot XML definitions, ObjectScript setup class, Instruqt assignment markdown, bash setup script.

---

## Design Decisions

### Dashboard Widgets

| Widget | Type | MDX/Data | Purpose |
|--------|------|----------|---------|
| Revenue by Category | Bar chart | `[Product].[P1].[Product Category].Members` on rows, `[Measures].[Amount Sold]` on columns | Shows overall data shape; Snacks bar will visibly jump after bulk order |
| Units Sold Today | Scorecard/pivot | Filter `[DateOfSale].[Actual].[DaySold].&[NOW]`, measure `[Measures].[Units Sold]` | Shows count that directly changes when order lands |
| Recent Transactions | Listing/table pivot | `[DateOfSale].[Actual].[DaySold].Members` with listing showing Product, Units, Revenue | Learner spots their "Gummy Rings x50" row |

### Seed Data Strategy

- 15 transactions seeded with dates spread over last 3 days (NOT today)
- Mix of categories: 5 Snacks, 4 Dairy, 3 Beverages, 3 Frozen
- No Gummy Rings in seed data so the learner's order is unambiguous
- "Units Sold Today" scorecard shows 0 until learner acts — then jumps to 50

### Narrative Flow

1. Open dashboard — see historical data across categories
2. Note "Units Sold Today" = 0 (or shows the order from step 4 if they did one)
3. Assignment says: "Let's see how fast analytics update. Submit a BULK order."
4. Submit qty 50 of Gummy Rings via the order form (same form from challenge 4)
5. Return to dashboard, hit refresh — scorecard jumps, Snacks bar grows, transaction visible in table
6. Narrative wrap: same data, zero latency, no pipelines

---

## File Structure

```
05-untitled-challenge-p21wz7/
  assignment.md              -- MODIFY: complete rewrite
  setup-iris                 -- CREATE: seeds data, builds cube, registers dashboard

src/HoleFoods/Analytics/
  Dashboard.cls              -- CREATE: DeepSee dashboard + pivot definitions (HoleFoods.Analytics.Dashboard)
  Setup.cls                  -- CREATE: ObjectScript class to seed transactions and build cube (HoleFoods.Analytics.Setup)
```

---

### Task 1: Create the Analytics Seed Data Class

**Files:**
- Create: `src/HoleFoods/Analytics/Setup.cls`

This class seeds historical transactions and rebuilds the cube.

- [ ] **Step 1: Write Analytics/Setup.cls**

```objectscript
Class HoleFoods.Analytics.Setup Extends %RegisteredObject
{

ClassMethod Run() As %Status
{
    set tSC = $$$OK
    try {
        write "Seeding historical transactions...",!
        set tSC = ..SeedTransactions()
        quit:$$$ISERR(tSC)

        write "Building HoleFoods cube...",!
        set tSC = ##class(%DeepSee.Utils).%BuildCube("HoleFoods")
        quit:$$$ISERR(tSC)

        write "Analytics setup complete.",!
    } catch ex {
        set tSC = ex.AsStatus()
        do $system.Status.DisplayError(tSC)
    }
    quit tSC
}

ClassMethod SeedTransactions() As %Status
{
    set tSC = $$$OK
    try {
        // Get product IDs for seeding (exclude Gummy Rings / SKU-976)
        set stmt = ##class(%SQL.Statement).%New()
        set tSC = stmt.%Prepare("SELECT ID, Category, Price FROM HoleFoods.Product WHERE SKU <> 'SKU-976' ORDER BY Category")
        quit:$$$ISERR(tSC)
        set rs = stmt.%Execute()

        // Collect products by category
        kill products
        while rs.%Next() {
            set cat = rs.Category
            set $list(products(cat), $listlength($get(products(cat)))+1) = $listbuild(rs.ID, rs.Price)
        }

        // Seed transactions: 15 total, spread over last 3 days
        // Each gets a random outlet (pick first few)
        set outletRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT TOP 4 ID FROM HoleFoods.Outlet")
        kill outlets
        set oidx = 0
        while outletRS.%Next() {
            set oidx = oidx + 1
            set outlets(oidx) = outletRS.ID
        }
        set numOutlets = oidx

        // Define seed data: category, product index within category, units, daysAgo
        // Format: $lb(category, productListIndex, units, daysAgo)
        set seeds(1)  = $lb("Snacks", 1, 8, 3)
        set seeds(2)  = $lb("Snacks", 1, 12, 2)
        set seeds(3)  = $lb("Snacks", 2, 5, 2)
        set seeds(4)  = $lb("Snacks", 2, 15, 1)
        set seeds(5)  = $lb("Snacks", 1, 7, 1)
        set seeds(6)  = $lb("Dairy", 1, 10, 3)
        set seeds(7)  = $lb("Dairy", 1, 6, 2)
        set seeds(8)  = $lb("Dairy", 2, 9, 2)
        set seeds(9)  = $lb("Dairy", 2, 4, 1)
        set seeds(10) = $lb("Beverages", 1, 11, 3)
        set seeds(11) = $lb("Beverages", 1, 8, 2)
        set seeds(12) = $lb("Beverages", 2, 14, 1)
        set seeds(13) = $lb("Frozen", 1, 6, 3)
        set seeds(14) = $lb("Frozen", 1, 9, 2)
        set seeds(15) = $lb("Frozen", 2, 7, 1)

        set today = +$horolog

        for i = 1:1:15 {
            set data = seeds(i)
            set cat = $list(data, 1)
            set pidx = $list(data, 2)
            set units = $list(data, 3)
            set daysAgo = $list(data, 4)

            // Get product from category
            if '$data(products(cat)) continue
            set plist = products(cat)
            set actualIdx = ((pidx - 1) # $listlength(plist)) + 1
            set prodData = $list(plist, actualIdx)
            set prodId = $list(prodData, 1)
            set price = $list(prodData, 2)

            // Create transaction
            set txn = ##class(HoleFoods.Transaction).%New()
            set txn.Product = ##class(HoleFoods.Product).%OpenId(prodId)
            set txn.Outlet = ##class(HoleFoods.Outlet).%OpenId(outlets(((i - 1) # numOutlets) + 1))
            set txn.DateOfSale = $zdateh(today - daysAgo, 3)
            set txn.UnitsSold = units
            set txn.AmountOfSale = units * price
            set txn.Channel = $case(i#3, 0:"Retail", 1:"Online", :"Wholesale")
            set txn.Actual = 1
            set tSC = txn.%Save()
            quit:$$$ISERR(tSC)
        }
        quit:$$$ISERR(tSC)

        write "Seeded 15 historical transactions.",!
    } catch ex {
        set tSC = ex.AsStatus()
    }
    quit tSC
}

}
```

- [ ] **Step 2: Verify the class compiles**

Test via MCP or docker exec:
```
iris session IRIS -U USER "do $system.OBJ.Load(\"/tmp/src/HoleFoods/Analytics/Setup.cls\",\"cuk-d\")"
```
Expected: compilation successful, no errors.

- [ ] **Step 3: Commit**

```bash
git add src/HoleFoods/Analytics/Setup.cls
git commit -m "feat: add analytics seed data class for challenge 5"
```

---

### Task 2: Create the Custom Dashboard Definition

**Files:**
- Create: `src/HoleFoods/Analytics/Dashboard.cls`

This class defines the custom dashboard with 3 widgets plus the supporting pivot definitions.

- [ ] **Step 1: Write Analytics/Dashboard.cls**

```objectscript
Class HoleFoods.Analytics.Dashboard Extends %DeepSee.UserLibrary.Container
{

XData Contents [ XMLNamespace = "http://www.intersystems.com/deepsee/library" ]
{
<items>

<!-- HoleFoods Overview/Revenue by Category.pivot -->
<pivot xmlns="http://www.intersystems.com/deepsee/library"
 name="Revenue by Category"
 folderName="HoleFoods Overview"
 title="Revenue by Category"
 description=""
 keywords=""
 owner=""
 shared="true"
 public="true"
 locked="false"
 resource=""
 cubeName="HoleFoods"
 cellWidth="120"
 cellHeight="22"
 showEmptyRows="false"
 showEmptyColumns="false"
 showStatus="true"
 pageSize="100"
 rowTotals="true"
 columnTotals="false"
 rowTotalAgg="sum"
 autoExecute="true">
  <rowAxisOptions spec="" headEnabled="false" filterEnabled="false" orderEnabled="false" aggEnabled="false" drillLevel="0" advanced="false">
  </rowAxisOptions>
  <columnAxisOptions spec="" headEnabled="false" filterEnabled="false" orderEnabled="false" aggEnabled="false" drillLevel="0" advanced="false">
  </columnAxisOptions>
  <rowLevel spec="[Product].[P1].[Product Category].Members" text="Product Category" headEnabled="false" filterEnabled="false" orderEnabled="false" aggEnabled="false" drillLevel="0" advanced="false">
  </rowLevel>
  <columnLevel spec="[Measures].[Amount Sold]" text="Revenue" headEnabled="false" filterEnabled="false" orderEnabled="false" aggEnabled="false" drillLevel="0" advanced="false">
  </columnLevel>
  <columnLevel spec="[Measures].[Units Sold]" text="Units Sold" headEnabled="false" filterEnabled="false" orderEnabled="false" aggEnabled="false" drillLevel="0" advanced="false">
  </columnLevel>
</pivot>

<!-- HoleFoods Overview/Recent Sales.pivot -->
<pivot xmlns="http://www.intersystems.com/deepsee/library"
 name="Recent Sales"
 folderName="HoleFoods Overview"
 title="Recent Sales"
 description=""
 keywords=""
 owner=""
 shared="true"
 public="true"
 locked="false"
 resource=""
 cubeName="HoleFoods"
 cellWidth="120"
 cellHeight="22"
 showEmptyRows="false"
 showEmptyColumns="false"
 showStatus="true"
 pageSize="10"
 autoExecute="true"
 listing="Listing"
 listingRows="10">
  <rowAxisOptions spec="" headEnabled="false" filterEnabled="false" orderEnabled="false" aggEnabled="false" drillLevel="0" advanced="false">
  </rowAxisOptions>
  <columnAxisOptions spec="" headEnabled="false" filterEnabled="false" orderEnabled="false" aggEnabled="false" drillLevel="0" advanced="false">
  </columnAxisOptions>
  <rowLevel spec="[DateOfSale].[Actual].[DaySold].Members" text="Day" headEnabled="true" headCount="10" filterEnabled="false" orderEnabled="false" aggEnabled="false" drillLevel="0" advanced="false">
  </rowLevel>
  <columnLevel spec="[Measures].[Amount Sold]" text="Revenue" headEnabled="false" filterEnabled="false" orderEnabled="false" aggEnabled="false" drillLevel="0" advanced="false">
  </columnLevel>
  <columnLevel spec="[Measures].[Units Sold]" text="Units Sold" headEnabled="false" filterEnabled="false" orderEnabled="false" aggEnabled="false" drillLevel="0" advanced="false">
  </columnLevel>
</pivot>

<!-- HoleFoods Overview/Sales Overview.dashboard -->
<dashboard xmlns="http://www.intersystems.com/deepsee/library"
 name="Sales Overview"
 folderName="HoleFoods Overview"
 title="HoleFoods Sales Overview"
 description="Live analytics dashboard showing revenue, units sold, and recent transactions"
 keywords=""
 owner=""
 shared="true"
 public="true"
 locked="false"
 resource=""
 scheme=""
 worklistCount="0"
 snapTo="true"
 snapGrid="true"
 gridRows="10"
 gridCols="10">

<widget name="Revenue by Category" title="Revenue by Category"
 type="barChart"
 subtype="bar"
 dataSource="HoleFoods Overview/Revenue by Category.pivot"
 top="0" left="0" width="6" height="6">
  <override name="chartToggle" value="0" />
  <override name="legendVisible" value="true" />
  <override name="seriesColorScheme" value="cocoberry" />
</widget>

<widget name="Units Sold (All Time)" title="Total Units Sold"
 type="scoreCard"
 subtype=""
 dataSource="HoleFoods Overview/Revenue by Category.pivot"
 top="0" left="6" width="4" height="3">
  <override name="valuePlotBox" value="background:none;" />
  <override name="targetValue" value="" />
  <override name="label" value="Units" />
  <override name="scoreCardDataProperty" value="Units Sold" />
</widget>

<widget name="Recent Transactions" title="Recent Transactions"
 type="pivot"
 subtype=""
 dataSource="HoleFoods Overview/Recent Sales.pivot"
 top="6" left="0" width="10" height="4">
</widget>

<widget name="Snacks Revenue" title="Snacks Category Revenue"
 type="scoreCard"
 subtype=""
 mdx="SELECT [Measures].[Amount Sold] ON 0 FROM [HoleFoods] WHERE [Product].[P1].[Product Category].&amp;[Snacks]"
 top="3" left="6" width="4" height="3">
  <override name="valuePlotBox" value="background:none;" />
  <override name="label" value="Snacks $" />
</widget>

</dashboard>

</items>
}

}
```

Note: The exact XML structure may need adjustment based on DeepSee version. The key elements are correct — widget types, dataSource references, and MDX queries follow the pattern established in the existing `DashboardsEtc.cls`.

- [ ] **Step 2: Verify the class compiles**

```
iris session IRIS -U USER "do $system.OBJ.Load(\"/tmp/src/HoleFoods/Analytics/Dashboard.cls\",\"cuk-d\")"
```
Expected: compilation successful.

- [ ] **Step 3: Verify the dashboard appears in the portal**

Navigate to: `http://iris:52773/csp/user/_DeepSee.UserPortal.Home.zen?$NAMESPACE=USER`

Look for "HoleFoods Overview / Sales Overview" in the dashboard list.

- [ ] **Step 4: Commit**

```bash
git add src/HoleFoods/Analytics/Dashboard.cls
git commit -m "feat: add custom analytics dashboard for challenge 5"
```

---

### Task 3: Create the Challenge 5 Setup Script

**Files:**
- Create: `05-untitled-challenge-p21wz7/setup-iris`

This script runs between challenges 4 and 5. It imports the analytics classes, seeds data, and builds the cube.

- [ ] **Step 1: Write setup-iris**

```bash
#!/bin/bash

# Challenge 5 setup: seed analytics data and build cube
# Runs as irisowner on the iris host

set -euo pipefail

SRC_DIR="/tmp/src/HoleFoods"

# Import and compile the analytics classes
iris session IRIS -U USER <<'EOSQL'
do $system.OBJ.Load("/tmp/src/HoleFoods/Analytics/Dashboard.cls","cuk-d")
do $system.OBJ.Load("/tmp/src/HoleFoods/Analytics/Setup.cls","cuk-d")
EOSQL

# Run the seed + cube build
iris session IRIS -U USER <<'EOSQL'
set sc = ##class(HoleFoods.Analytics.Setup).Run()
if $$$ISERR(sc) { do $system.Status.DisplayError(sc) halt }
halt
EOSQL

echo "Challenge 5 setup complete."
```

- [ ] **Step 2: Make script executable**

```bash
chmod +x 05-untitled-challenge-p21wz7/setup-iris
```

- [ ] **Step 3: Commit**

```bash
git add 05-untitled-challenge-p21wz7/setup-iris
git commit -m "feat: add setup script for challenge 5 analytics"
```

---

### Task 4: Integration Testing

- [ ] **Step 1: Run docker-compose up and verify full flow**

```bash
docker compose up -d
```

Wait for IRIS to be healthy.

- [ ] **Step 2: Run challenge 1 setup (imports HoleFoods base data)**

Verify that `HoleFoods.Cube` exists and the cube builds successfully with sample data.

- [ ] **Step 3: Run challenge 4 setup (starts production, registers REST app)**

```bash
docker exec -it iris iris session IRIS -U USER "do ##class(HoleFoods.Setup).Run()"
```

Verify order form works at `http://localhost:52773/csp/user/order.html`.

- [ ] **Step 4: Run challenge 5 setup**

```bash
docker exec -it iris iris session IRIS -U USER "do $system.OBJ.Load(\"/tmp/src/HoleFoods/Analytics/Setup.cls\",\"cuk-d\")"
docker exec -it iris iris session IRIS -U USER "do $system.OBJ.Load(\"/tmp/src/HoleFoods/Analytics/Dashboard.cls\",\"cuk-d\")"
docker exec -it iris iris session IRIS -U USER "do ##class(HoleFoods.Analytics.Setup).Run()"
```

Verify: "Seeded 15 historical transactions" and "Building HoleFoods cube" messages appear.

- [ ] **Step 5: Open dashboard and verify widgets render**

Navigate to: `http://localhost:52773/csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=HoleFoods%20Overview/Sales%20Overview.dashboard`

Verify:
- Bar chart shows 4 categories with data
- Snacks Revenue scorecard shows a dollar value
- Recent Transactions shows rows

- [ ] **Step 6: Submit bulk order and verify dashboard updates**

```bash
curl -X POST http://localhost:52773/api/holeFoods/order \
  -H "Content-Type: application/json" \
  -d '{"sku":"SKU-976","quantity":50}'
```

Expected response: `"Order accepted"`

Refresh dashboard. Verify Snacks revenue increased.

- [ ] **Step 7: Commit any fixes from testing**

```bash
git add -A
git commit -m "fix: adjustments from integration testing"
```

---

## Notes

- The `%BuildCube` call in setup may take a few seconds depending on data volume. The existing HoleFoods sample data from challenge 1 (generated by `HoleFoods.Utils.BuildData`) will already be in the cube — the 15 seeded transactions add recent activity on top.
- If the cube build is too slow for the Instruqt setup timeout, consider using `%SynchronizeCube` instead (incremental sync).
- The dashboard XML structure follows the exact pattern from `DashboardsEtc.cls`. If widgets don't render, check that pivot `folderName` matches the dashboard `dataSource` path exactly.
- The "Snacks Revenue" widget uses inline MDX rather than a pivot reference — simpler for a single-value scorecard.
