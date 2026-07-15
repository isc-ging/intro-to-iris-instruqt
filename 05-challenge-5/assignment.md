---
slug: challenge-5
id: ofe2j9b7mnet
type: challenge
title: Real Time Analytics
notes:
- type: text
  contents: |
    # Real Time Insight
    IRIS includes a powerful built-in business intelligence engine, allowing you to visualise data and generate insights directly from the source.

    Because analysis happens in-place, insights are available in real time, with no need to move or duplicate data. This enables faster decisions and eliminates delays typically introduced by separate analytics pipelines.

    IRIS also integrates seamlessly with external BI tools such as Power BI and Tableau, giving you the flexibility to present your data using your favourite tools.
tabs:
- id: hy0qinalp1iq
  title: IRIS
  type: service
  hostname: iris
  path: /csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=HoleFoods/SalesDash.dashboard
  port: 52773
- id: 9hibrbjwdyma
  title: IRIS2
  type: service
  hostname: iris
  path: /csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=HoleFoods/ExploratoryDashboard.dashboard
  port: 52773
difficulty: ""
enhanced_loading: null
---
# A live dashboard
Welcome to an IRIS BI dashboard. The charts and tables provide a look at our shops' sales. These are all based on queries against our dataset which have been configured to refresh every 5s. This ensures our dashboard is truly real time and up-to-date.

Lets see this in action. Make a note of the current top product, and how the wekekly revenue is looking. Now lets return to our [Orders tab](tab-1) and submit another order. How about 50 units of Gummy Rings; that should make a dent in our weekly target!

Submit the order, and return to the Analytics dashboard. You might need to wait a couple of seconds before the next refresh, but you should see our Gummy rings move right up the leaderboard of top products!

This demonstrates an important capability of InterSystems IRIS: transactions and analytics can operate on the same data platform. The order is written to IRIS and is then immediately available to applications and SQL queries. For this dashboard, there is no separate export, reporting database or scheduled ETL operation between placing the order and analysing it.

# Complex data models

Direct SQL is useful when we want fast access to operational data or already know the questions that the application needs to answer. However, IRIS also supports richer analytical models through InterSystems IRIS Business Intelligence. IRIS BI models organise data into reusable measures and dimensions. For example, sales could be analysed by product, shop, customer or time period, while measures could include revenue, order quantity and average order value. Users can then apply filters, create pivot tables and drill from a high-level total into the records behind it.

Let's take a look at our second dashboard. Click the Home link at the top of the page to return to the user dashboard, then open the Exploritory data dashboard.

This dashboard example is build upon analytics Cubes and Pivot tables, which means the data is less immediately provided as the cube needs to be re-built for the data to be updated. It does however mean more complex data models can be built. Lets see this in action.

Our top chart is a chart of Sale by Region. Click on any of the bars, and then click the `Drill Down` button.

![alt text](..\assets\DrillDownButton.png)

You should see the chart go from Sales by Region, to Sales by Country. Repeat this by clicking on another bar and pressing the down arrow again. You will now see the Sales by City. Pretty neat right?

Click the Up arrow to return to the regional sales.

Let's also filter by Category from the menu in the far left of the Screen:

![alt text](..\assets\CategoryFilter.png)

Choose a category and see how this affects the plot.

# Challenge

Now we're going to make this into a challenge!

You're task is to work out **how many Units of Pasta was sold in Rome, Italy (Europe)**. It might help if you change to the table view using this button:

![alt text](..\assets\TableViewButton.png)

# Conclusions

As mentioned in the introduction, IRIS BI is far from the only analytics tool available. There are also integrations with other major Business Analytics providers, and advanced tools for further use-cases.


