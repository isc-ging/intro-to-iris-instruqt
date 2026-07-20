---
slug: challenge-2
id: nbcghntewzn3
type: challenge
title: Data Platform
notes:
- type: text
  contents: |-
    # The Database

    At the core of InterSystems IRIS is a highly efficient, high-performance database designed to scale to demanding workloads — supporting database sizes of up to 8 petabytes.

    InterSystems IRIS natively supports multiple data models within a single system. Alongside traditional relational storage (SQL), you can work with document (JSON), object, key-value, columnar, and even vector data, all within the same environment, without needing separate technologies.

    This flexibility allows you to model and access data in the way that best fits your application, while keeping everything unified and consistent.

    To explore this further, see the Data Models in InterSystems IRIS tutorial linked at the end of this guide. For now, we will start with a simple example.
tabs:
- id: dhdjss1vlojq
  title: IRIS
  type: service
  hostname: iris
  path: /csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen?$NAMESPACE=USER
  port: 52773
difficulty: ""
enhanced_loading: null
---
The most common type of database is the relational database, these are tabular databases - think giant, interlinked spreadsheets. InterSystems IRIS can be used as a standard relational database.

**Copy this command into the text box in the middle of the page:**

```sql
SELECT
SKU, Category, Name, Price, Stock
FROM HoleFoods.Product
```

**Then click Execute**

This command selects several columns from our HoleFoods.Products table, a list of products sold by our fictional retailer; HoleFoods. This is a shop which sells foods with holes in them.

The *relational* part of the name refers to the tables being related to each other, meaning the data in one table might reference data from another table. Let's take a look at our table of transactions:

**Now try running this command:**

```sql
SELECT
AmountOfSale, DateTimeOfSale, Product,  UnitsSold
FROM HoleFoods.SalesTransaction
```

We can see the transaction details and the Product ID (SKU) sold. In InterSystems IRIS it is very easy to find values from linked tables.

**Let's re-run the above command with a small change to show the Product Name:**

```sql
SELECT
AmountOfSale, DateTimeOfSale, Product->Name,  UnitsSold
FROM HoleFoods.SalesTransaction
```
This command uses `->` to implicitly join the Transactions and Products table to fetch the product name.

These queries use SQL, or Structured Query Language, which is the universal way to query relational data.

## Adding a new Product

Before moving on from the Relational Table view, let's add one new product to the dataset.

**Execute the insert command to enter a new product item:**

```sql
INSERT INTO HoleFoods.Product
(Category, Name, Price, SKU, Stock)
VALUES
('Snack', 'Gummy Rings', 2.99, 'SKU-976', 200)
```

**And just to double-check it's been added, run:**

```sql
SELECT
SKU, Category, Name, Price, Stock
FROM HoleFoods.Product
```

You should be able to spot our new product in the list!

So far, we have run SQL through the Management Portal, but you can execute it from many other environments, including applications written in Python, Java, C++, and more. InterSystems IRIS also supports industry-standard ODBC and JDBC connections, making it easy to integrate with almost any existing application.