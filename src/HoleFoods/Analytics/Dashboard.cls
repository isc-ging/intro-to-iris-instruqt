Class HoleFoods.Analytics.Dashboard Extends %DeepSee.UserLibrary.Container
{

XData Contents [ XMLNamespace = "http://www.intersystems.com/deepsee/library" ]
{
<items>

<pivot xmlns="http://www.intersystems.com/deepsee/library" name="Revenue and Units by Day" folderName="HoleFoods Overview" title="" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="" bookCover="" mdx="" cellWidth="120" columnHeaderStyle="" rowHeaderStyle="" cellStyle="" rowLabelSpan="true" columnLabelSpan="true" cellHeight="22" showEmptyRows="false" showEmptyColumns="false" cubeName="HoleFoodSales" caption="" listing="" listingRows="" showStatus="true" pageSize="100" colorScale="" rowTotals="false" columnTotals="false" rowTotalAgg="sum" columnTotalAgg="sum" rowTotalSource="page" showZebra="false" showRowCaption="true" printTitle="" printSubtitle="" printPageSize="" printOrientation="" printMarginTop="" printMarginLeft="" printMarginRight="" printMarginBottom="" printLabelWidth="" printCellWidth="" autoExecute="true" manualMode="false" userMDX="" chartMarginTop="" chartMarginLeft="" chartMarginRight="" chartMarginBottom="">
  <rowAxisOptions spec="" key="" value="" text="" headEnabled="true" headCount="30" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </rowAxisOptions>
  <columnAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnAxisOptions>
  <rowLevel spec="[DateOfSale].[H1].[DaySold].Members" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="true" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </rowLevel>
  <columnLevel spec="[Measures].[AmountOfSale]" key="" value="" text="Revenue" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnLevel>
  <columnLevel spec="[Measures].[UnitsSold]" key="" value="" text="Units Sold" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnLevel>
</pivot>

<pivot xmlns="http://www.intersystems.com/deepsee/library" name="Sales by Month" folderName="HoleFoods Overview" title="" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="" bookCover="" mdx="" cellWidth="120" columnHeaderStyle="" rowHeaderStyle="" cellStyle="" rowLabelSpan="true" columnLabelSpan="true" cellHeight="22" showEmptyRows="false" showEmptyColumns="false" cubeName="HoleFoodSales" caption="" listing="" listingRows="" showStatus="true" pageSize="100" colorScale="" rowTotals="false" columnTotals="false" rowTotalAgg="sum" columnTotalAgg="sum" rowTotalSource="page" showZebra="false" showRowCaption="true" printTitle="" printSubtitle="" printPageSize="" printOrientation="" printMarginTop="" printMarginLeft="" printMarginRight="" printMarginBottom="" printLabelWidth="" printCellWidth="" autoExecute="true" manualMode="false" userMDX="" chartMarginTop="" chartMarginLeft="" chartMarginRight="" chartMarginBottom="">
  <rowAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </rowAxisOptions>
  <columnAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnAxisOptions>
  <rowLevel spec="[DateOfSale].[H1].[MonthSold].Members" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="true" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </rowLevel>
  <columnLevel spec="[Measures].[AmountOfSale]" key="" value="" text="Revenue" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnLevel>
  <columnLevel spec="[Measures].[UnitsSold]" key="" value="" text="Units Sold" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnLevel>
</pivot>

<dashboard xmlns="http://www.intersystems.com/deepsee/library" name="Sales Overview" folderName="HoleFoods Overview" title="HoleFoods Sales Overview" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="" bookCover="" gridRows="12" gridCols="10" snapTo="true" snapGrid="true">
  <widget type="pivot" subtype="barChart" name="Revenue by Day" title="Revenue by Day (last 30)" dataSource="HoleFoods Overview/Revenue and Units by Day.pivot" dataLink="" drillDownDataSource="" width="6" height="6" top="0" left="0" showSidebar="false" sidebarContent="" homeRowL="0" homeColL="0" colSpanL="6" rowSpanL="6">
  </widget>
  <widget type="scoreCardWidget" subtype="regular" name="Sales KPIs" title="Live Sales KPIs" dataSource="HoleFoods/SalesKPI.kpi" dataLink="" drillDownDataSource="" width="4" height="6" top="0" left="6" showSidebar="false" sidebarContent="" homeRowL="0" homeColL="6" colSpanL="4" rowSpanL="6">
    <dataProperty name="RecentRevenue" label="Revenue (7 days)" dataValue="RecentRevenue" showAs="value" />
    <dataProperty name="RecentUnits" label="Units Sold (7 days)" dataValue="RecentUnits" showAs="value" />
    <dataProperty name="TotalOrders" label="Orders (7 days)" dataValue="TotalOrders" showAs="value" />
  </widget>
  <widget type="pivot" subtype="" name="Sales by Month" title="Revenue and Units by Month" dataSource="HoleFoods Overview/Sales by Month.pivot" dataLink="" drillDownDataSource="" width="10" height="3" top="6" left="0" showSidebar="false" sidebarContent="" homeRowL="6" homeColL="0" colSpanL="10" rowSpanL="3">
  </widget>
  <widget type="pivot" subtype="" name="Recent Transactions" title="Recent Transactions" dataSource="HoleFoods Overview/Revenue and Units by Day.pivot" listing="Transaction Detail" dataLink="" drillDownDataSource="" width="10" height="3" top="9" left="0" showSidebar="false" sidebarContent="" homeRowL="9" homeColL="0" colSpanL="10" rowSpanL="3">
  </widget>
</dashboard>

</items>
}

}
