---
slug: challenge-3
id: xybfziqqhu7u
type: challenge
title: Execution Engine
notes:
- type: text
  contents: |-
    # Execution Engine

    InterSystems IRIS is not just a SQL database.

    Like other enterprise databases, it supports server-side logic, but InterSystems IRIS distinguishes itself by integrating a broader runtime directly into the platform, including ObjectScript and Embedded Python running in the same process as the database engine.

    Executing workflows and procedures inside the platform reduces the need to move data and improves efficiency for data-intensive tasks. This is one of the many features that makes InterSystems IRIS such an efficient data platform.
tabs:
- id: cmjfuvm3hbxl
  title: VS Code
  type: service
  hostname: vscode
  path: /?folder=/opt/intersystems/src/challenge-3/
  port: 8080
- id: cojcqvwdgnwj
  title: IRIS
  type: service
  hostname: iris
  path: /csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen?$NAMESPACE=USER
  port: 52773
- id: zpc4etchbw9t
  title: Terminal
  type: terminal
  hostname: iris
difficulty: ""
enhanced_loading: null
---
This is VS Code, a standard Integrated Development Environment, or fancy code editor for the non-technical. VS Code is the recommended IDE for IRIS, and there are several extensions that supercharge the VS Code-IRIS connection.

**From the explorer menu on the left, open the HoleFoods/ProductChanges.cls file**

This is an InterSystems IRIS class. We won't go into detail about the code at the moment, although there are plenty more tutorials available if you would like to find out more. Instead, we are going to use the two functions inside the class to demonstrate how to run code in InterSystems IRIS.

**Switch to the [Terminal Tab](tab-2) and run the following command**

```objectscript,run
do ##class(HoleFoods.ProductChanges).PrintProductDetails("SKU-976")
```

You should see the properties of our new product printed out. If don't see the command being run, try refreshing the window and running it again.

This function retrieves the product details from the database by SKU ID and prints them to the terminal. The method is defined in the file we were looking at in [VS Code](tab-0) and is written in ObjectScript. 

To confirm it is reading live data from the database, **try running it with a different ID:**

```objectscript,run
do ##class(HoleFoods.ProductChanges).PrintProductDetails("SKU-199")
```

Let's try the other method in the file, which is used to restock a product in the database. We've just had a shipment of 100 new bags of Gummy Rings!

**In the terminal, run the following command**

```objectscript,run
do ##class(HoleFoods.ProductChanges).Restock("SKU-976", 100)
```

This function is contained in the same file as the PrintProductDetails function but is written in a different language! This time we are accessing the data directly with Python.

Since 2022, InterSystems IRIS has included Python as an embedded language. This innovation means that the latency-saving gains of running code next to the data can also be accessed with Python, the most popular programming language in the world.

**Just to double-check our restock worked — let's run the first command again:**

```objectscript,run
do ##class(HoleFoods.ProductChanges).PrintProductDetails("SKU-976")
```

Finally, let's return to the Management Portal to see the change from there.

**Open the [IRIS tab](tab-1), then paste the following command into the command box, and click execute**

```sql
SELECT SKU, Category, Name, Price, Stock FROM HoleFoods.Product WHERE ID='SKU-976'
```

We have restocked the Gummy Rings! Here we have seen how we can access the same data using SQL, ObjectScript and Python. This gives us flexibility to read, write, and use data from across many different application contexts.

Let's continue to see how we can use InterSystems IRIS to integrate systems.