---
slug: untitled-challenge-p21wz7
id: l0dri1ti6x0h
type: challenge
title: Real Time Analytics
notes:
- type: text
  contents: |
    # Real Time Insight
    IRIS includes a powerful built-in business intelligence engine, allowing you to visualise data and generate insights directly from the source.

    Because analysis happens in-place, insights are available in real time, with no need to move or duplicate data. This enables faster decisions and eliminates delays typically introduced by separate analytics pipelines.

    IRIS also integrates seamlessly with external BI tools such as Power BI and Tableau, giving you flexibility in how you explore and present your data.
tabs:
- id: 1ypvbwsyjymi
  title: IRIS
  type: service
  hostname: iris
  path: /csp/user/_DeepSee.UI.Analyzer.zen?$NAMESPACE=USER&PIVOT=KPIs%20%26%20Plugins%2FHoleFoods.pivot
  port: 52773
- id: dgs7jwzlggmo
  title: IRIS2
  type: service
  hostname: iris
  path: /csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=Widget%20Examples/All%20Charts.dashboard
  port: 52773
difficulty: ""
enhanced_loading: null
---
Welcome to the built-in analytics solution, IRIS BI. This is the Analyzer portal, it is used to create pivot tables. This portal makes it easy to create custom pivot tables, showing exactly the data you want to see. At the moment, the Rows of the data is the Product name, which is selected in the Rows box at the centre of the page.

> Lets remove this by pressing the X button next to where it says Product Name. Instead, from the left hand-panel, navigate to Dimensions -> Product, then click and drag Product Category into the Rows column.

You'll see the pivot table is now grouped by category instead of product.

> Now drag the Product Name to the Down-right pointing arrow next to Product Category in the Row Box.

You should see the Product Name appear as a sub-variable of Product Category. We'll be using this later.

> Finally, lets remove Median Revenue and 90th Percentile revenue from the Columns box in the middle - again press the X to do so.

> To replace it, lets drag the Units Sold to this column, so we can now see revenue and Units sold for each product.

# Dashboards
Now we have a basic pivot table, lets move on to Building a dashboard in the next step. If you'd like to navigate there yourself, you can press `Home` at the top of the screen, then choose `Analytics -> User Portal -> Go` and select the __ Dashboard form the list of examples. Or to skip this, just switch to the [IRIS2 Tab](tab-1).

This is an example of a dashboard built with IRIS-BI, the in-build analytics engine, so we can quickly see the same data in our underlying database, without having to export or move the data. If you want more advanced analytics tools, there are plenty of connectors and support for existing tools like PowerBI or Tableau, but IRIS-BI is included directly within IRIS, runs close to the data making it very fast, and is powerful enough for most basic tasks.


