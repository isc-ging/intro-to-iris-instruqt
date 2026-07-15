---
slug: challenge-2
id: nbcghntewzn3
type: challenge
title: Data Platform
notes:
- type: text
  contents: |-
    # The Database

    At the core of IRIS is a highly efficient, high-performance database designed to scale to demanding workloads - supporting database sizes of up to 8 petabytes.

    IRIS natively supports multiple data models within a single system. Alongside traditional relational storage (SQL), you can work with document (JSON), object, key-value, columnar, and even vector data, all within the same environment, without needing separate technologies.

    This flexibility allows you to model and access data in the way that best fits your application, while keeping everything unified and consistent.

    To explore this further, see the Data Models in IRIS tutorial linked at the end of this guide, for now though, we will start with a simple example.
tabs:
- id: dhdjss1vlojq
  title: IRIS
  type: service
  hostname: iris
  path: /csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen?$NAMESPACE=USER
  port: 52773
- id: voulgi1au7zo
  title: term
  type: terminal
  hostname: iris
- id: ysjywvao8tly
  title: bash
  type: terminal
  hostname: iris
  cmd: /bin/bash
difficulty: ""
enhanced_loading: null
---
The most common type of databases is relational databases, these are tabular databases - think giant, interlinked spreadsheets. IRIS can be used as a standard relational database.

**Copy this command into the text box in the middle of the page:**

```sql
SELECT
SKU, Category, Name, Price
FROM HoleFoods.Product
```

**Then click Execute**

You'll see a table of products from our fictional retailer of foods with Holes in them.

The *relational* part of the name, refers to the tables being related to each other. For example, our table of shop sales (HoleFood.Transactions), only details the product ID.

**Now try running this command:**

```sql
SELECT
 AmountOfSale, DateTimeOfSale, Product,  UnitsSold
FROM HoleFoods.SalesTransaction
```

We can see the transaction details the Product ID sold. In IRIS it is very easy to find values from linked tables.

**Lets re-run the above command with a small change to show the Product Name**

```sql
SELECT
AmountOfSale, DateOfSale, Product->Name,  UnitsSold
FROM HoleFoods.SalesTransaction
```
This command uses `->` to implicitly join the Transactions and Products table to fetch the product name.

Before moving on from the Relational Table view, lets add one custom product to the dataset.

**Execute the insert command to enter a new product item:**

```sql
INSERT INTO HoleFoods.Product
(Category, Name, Price, SKU)
VALUES
('Snack', 'Gummy Rings', 2.99, 'SKU-976')
```

**And just to double check its been added, run:**

```sql
SELECT
ID, Category, Name, Price, SKU
FROM HoleFoods.Product
```