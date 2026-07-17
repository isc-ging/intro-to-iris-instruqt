---
slug: challenge-5
id: ofe2j9b7mnet
type: challenge
title: Real Time Analytics
notes:
- type: text
  contents: |
    # Real Time Insight
    InterSystems IRIS includes a powerful built-in business intelligence engine, allowing you to visualise data and generate insights directly from the source.

    Because analysis happens in-place, insights are available in real time, with no need to move or duplicate data. This enables faster decisions and eliminates delays typically introduced by separate analytics pipelines.

    InterSystems IRIS also integrates seamlessly with external BI tools such as Power BI and Tableau, giving you the flexibility to present your data using your favourite tools.
tabs:
- id: hy0qinalp1iq
  title: IRIS
  type: service
  hostname: iris
  path: /dsw/index.html#/USER/HoleFoods/SalesDashboard.dashboard
  port: 52773
- id: ng7utkii6ieo
  title: Shop
  type: service
  hostname: iris
  path: /csp/user/order.html
  port: 52773
- id: eeqwk2aoursi
  title: Quiz
  type: service
  hostname: iris
  path: /csp/user/quiz.html
  port: 52773
difficulty: ""
enhanced_loading: null
---
# A live dashboard
Welcome to an InterSystems IRIS BI dashboard. The charts and tables provide a look at our shops' sales. These are all based on queries against our dataset which have been configured to refresh every 5s. This ensures our dashboard is truly real time and up-to-date.

Let's see this in action. **Make a note of the current top product, and how the weekly revenue is looking.**

**Now lets return to our [Orders tab](tab-1) and submit another order**. How about 100 units of Gummy Rings; that should make a pretty visible dent in our weekly revenue!

Submit the order, and return to the Analytics dashboard. You might need to wait a couple of seconds before the next refresh, but you should see our Gummy rings move right up the leaderboard of top products!

This demonstrates an important capability of InterSystems IRIS: transactions and analytics can operate on the same data platform. The order is written to InterSystems IRIS and is then immediately available to applications and SQL queries. For this dashboard, there is no separate export, reporting database or scheduled ETL operation between placing the order and analysing it.

# Complex data models

Direct SQL is useful when we want fast access to operational data or already know the questions that the application needs to answer. However, InterSystems IRIS also supports richer analytical models through InterSystems IRIS Business Intelligence. IRIS BI models organise data into reusable measures and dimensions. For example, sales could be analysed by product, shop, customer or time period, while measures could include revenue, order quantity and average order value. Users can then apply filters, create pivot tables and drill from a high-level total into the records behind it.

Let's take a look at our second dashboard. **Click the "HoleFoods" link at the top of the page to see our other Dashboards, then open the Exploratory Dashboard.**
![The HoleFoods link at the top of the dashboard page for navigating to other dashboards](..\assets\HoleFoodsButtonHint.png)

This dashboard example is built upon analytics Cubes and Pivot tables, which means the data is not updated instantly — the cube needs to be rebuilt first. It does however allow more complex data models to be built. Let's see this in action.

Our top chart is a chart of Sale by Region.

**Click on any of the Continent labels below the bars.**


You should see the chart go from Sales by Region, to Sales by Country within that region. Repeat this by clicking on one of the country labels. You will now see the Sales by City. Pretty neat right?

**Click the Back button above the chart twice to return to the regional view.**

Let's also filter by Category from the menu in the far right of the Screen:

![The Category filter menu on the right side of the Exploratory Dashboard](..\assets\CategoryFilter.png)

**Choose a category and see how this affects the plot.**

# Challenge

Now we're going to make this into a challenge!

Your task is to work out **how many units of Pasta were sold in Rome, Italy (Europe)**.


When you think you have the right answer, **switch to the [Quiz tab](tab-2) to see if you are right!**

# Conclusions

Let's recap. Here we have seen how IRIS BI has built in analytics tools to explore and visualise data. These tools can allow quick access to Key Performance Indicators through SQL, or more sophisticated analysis through user-defined analytical data models.

And if you'd prefer to use the tools you know? You can always connect external tools to InterSystems IRIS as well.

