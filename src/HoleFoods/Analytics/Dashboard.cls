Class HoleFoods.Analytics.Dashboard Extends %DeepSee.UserLibrary.Container
{

XData Contents [ XMLNamespace = "http://www.intersystems.com/deepsee/library" ]
{
<items>

<pivot xmlns="http://www.intersystems.com/deepsee/library" name="Revenue by Category" folderName="HoleFoods Overview" title="" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="" bookCover="" mdx="" cellWidth="120" columnHeaderStyle="" rowHeaderStyle="" cellStyle="" rowLabelSpan="true" columnLabelSpan="true" cellHeight="22" showEmptyRows="false" showEmptyColumns="false" cubeName="HoleFoods" caption="" listing="" listingRows="" showStatus="true" pageSize="100" colorScale="" rowTotals="false" columnTotals="false" rowTotalAgg="sum" columnTotalAgg="sum" rowTotalSource="page" showZebra="false" showRowCaption="true" printTitle="" printSubtitle="" printPageSize="" printOrientation="" printMarginTop="" printMarginLeft="" printMarginRight="" printMarginBottom="" printLabelWidth="" printCellWidth="" autoExecute="true" manualMode="false" userMDX="" chartMarginTop="" chartMarginLeft="" chartMarginRight="" chartMarginBottom="">
  <rowAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </rowAxisOptions>
  <columnAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnAxisOptions>
  <rowLevel spec="[Product].[P1].[Product Category].Members" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </rowLevel>
  <columnLevel spec="[Measures].[Amount Sold]" key="" value="" text="Revenue" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnLevel>
  <columnLevel spec="[Measures].[Units Sold]" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnLevel>
</pivot>

<pivot xmlns="http://www.intersystems.com/deepsee/library" name="Recent Sales" folderName="HoleFoods Overview" title="" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="" bookCover="" mdx="" cellWidth="120" columnHeaderStyle="" rowHeaderStyle="" cellStyle="" rowLabelSpan="true" columnLabelSpan="true" cellHeight="22" showEmptyRows="false" showEmptyColumns="false" cubeName="HoleFoods" caption="" listing="Listing" listingRows="10" showStatus="true" pageSize="100" colorScale="" rowTotals="false" columnTotals="false" rowTotalAgg="sum" columnTotalAgg="sum" rowTotalSource="page" showZebra="false" showRowCaption="true" printTitle="" printSubtitle="" printPageSize="" printOrientation="" printMarginTop="" printMarginLeft="" printMarginRight="" printMarginBottom="" printLabelWidth="" printCellWidth="" autoExecute="true" manualMode="false" userMDX="" chartMarginTop="" chartMarginLeft="" chartMarginRight="" chartMarginBottom="">
  <rowAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </rowAxisOptions>
  <columnAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnAxisOptions>
  <rowLevel spec="[DateOfSale].[Actual].[DaySold].Members" key="" value="" text="" headEnabled="true" headCount="10" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </rowLevel>
  <columnLevel spec="[Measures].[Amount Sold]" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnLevel>
  <columnLevel spec="[Measures].[Units Sold]" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnLevel>
</pivot>

<dashboard xmlns="http://www.intersystems.com/deepsee/library" name="Sales Overview" folderName="HoleFoods Overview" title="HoleFoods Sales Overview" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="" bookCover="" gridRows="10" gridCols="10" snapTo="true" snapGrid="true">
  <widget type="barChart" subtype="bar" name="Revenue by Category" title="" dataSource="HoleFoods Overview/Revenue by Category.pivot" top="0" left="0" width="6" height="6">
  </widget>
  <widget type="scoreCard" subtype="" name="Total Units Sold" title="" dataSource="HoleFoods Overview/Revenue by Category.pivot" top="0" left="6" width="4" height="3">
  </widget>
  <widget type="scoreCard" subtype="" name="Snacks Revenue" title="" mdx="SELECT [Measures].[Amount Sold] ON 0 FROM [HoleFoods] WHERE [Product].[P1].[Product Category].&amp;[Snacks]" top="3" left="6" width="4" height="3">
  </widget>
  <widget type="pivot" subtype="" name="Recent Transactions" title="" dataSource="HoleFoods Overview/Recent Sales.pivot" top="6" left="0" width="10" height="4">
  </widget>
</dashboard>

</items>
}

}
