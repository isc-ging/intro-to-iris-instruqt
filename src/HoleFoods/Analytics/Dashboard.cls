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
  <rowLevel spec="[DateTimeOfSale].[H1].[DaySold].Members" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="true" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
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
  <rowLevel spec="[DateTimeOfSale].[H1].[MonthSold].Members" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="true" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </rowLevel>
  <columnLevel spec="[Measures].[AmountOfSale]" key="" value="" text="Revenue" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnLevel>
  <columnLevel spec="[Measures].[UnitsSold]" key="" value="" text="Units Sold" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false">
  </columnLevel>
</pivot>

<dashboard xmlns="http://www.intersystems.com/deepsee/library" name="SalesDash" folderName="HoleFoods" title="SalesDashboard" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="2026-07-13T16:46:25.824Z" createdBy="UnknownUser" category="" bookCover="" scheme="" worklistCount="0" snapTo="true" snapGrid="true" gridRows="12" gridCols="10" canResize="true" canModify="true" showTitleBar="true" titleBarOpacity="" titleBarColor="" selectedTitleBarOpacity="" selectedTitleBarColor="" titleBarTextColor="" selectedTitleBarTextColor="" titleBarFont="" companyName="" companyLogo="" companyStyle="" backgroundColor="white" backgroundImage="none" backgroundRepeat="no-repeat" backgroundSize="100% 100%" backgroundOpacity="1" widgetBorders="1px solid #F0F0F0" widgetBordersSwitch="edit" widgetBordersColor="#F0F0F0" widgetBordersStyle="solid" widgetBordersWidth="1" widgetBordersToggle="true">
  <widget name="Sales KPIs" type="scoreCardWidget" subtype="regular" subtypeClass="" title="Live Sales KPIs" dataSource="HoleFoods/SalesKPI.kpi" dataLink="" drillDownDataSource="" top="0" left="6" width="4" height="6" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="0" colSpanL="4" rowSpanL="2" showToolbar="true" showToolbarBottomBorder="true" showToolbarOnlyWhenMaximized="false" colorToolbar="#F0F0F0" opacityToolbar="1" backgroundColor="#F0F0F0" opacity="1" theme="" dataColorList="">
    <dataProperty name="RecentRevenue" label="Revenue (7 days)" width="" align="" subtype="" style="" display="" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="RecentRevenue" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <dataProperty name="RecentUnits" label="Units Sold (7 days)" width="" align="" subtype="" style="" display="" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="RecentUnits" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <dataProperty name="TotalOrders" label="Orders (7 days)" width="" align="" subtype="" style="" display="" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="TotalOrders" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
  </widget>
  <widget name="TransactionsByWeek" type="pivot" subtype="lineChart" subtypeClass="lineChart" title="Revenue By Week" dataSource="HoleFoods/TransactionsByDay.kpi" dataLink="" drillDownDataSource="" width="200" height="200" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="4" colSpanL="6" rowSpanL="7" showToolbar="true" showToolbarBottomBorder="true" showToolbarOnlyWhenMaximized="false" colorToolbar="#F0F0F0" opacityToolbar="1" backgroundColor="#F0F0F0" opacity="1" theme="" dataColorList="">
    <property name="legendPos">none</property>
    <override name="legend">{hidden:true,legendLabels:'TotalRevenue',legendPosition:'right',_type:'chartLegend'}</override>
  </widget>
  <widget name="Product Sales By Month" type="pivot" subtype="barChart" subtypeClass="barChart" title="Product Sales and Revenue by Month" dataSource="HoleFoods/ProductsByMonthKPI.kpi" dataLink="" drillDownDataSource="" width="200" height="200" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="7" homeColL="0" colSpanL="10" rowSpanL="5" showToolbar="true" showToolbarBottomBorder="true" showToolbarOnlyWhenMaximized="false" colorToolbar="#F0F0F0" opacityToolbar="1" backgroundColor="#F0F0F0" opacity="1" theme="" dataColorList="">
    <control name="" action="refresh" target="*" targetProperty="" location="dashboard" type="timer" controlClass="" timeout="5" label="" title="" value="" text="" readOnly="false" valueList="" displayList="" activeWhen="">
      <valueRequired>false</valueRequired>
    </control>
  </widget>
  <widget name="RecentTransactions" type="pivot" subtype="pivot" subtypeClass="lineChart" title="Recent Transactions" dataSource="HoleFoods/RecentTransactionsKPI.kpi" dataLink="" drillDownDataSource="" width="200" height="200" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="2" homeColL="0" colSpanL="4" rowSpanL="5" showToolbar="true" showToolbarBottomBorder="true" showToolbarOnlyWhenMaximized="false" colorToolbar="#F0F0F0" opacityToolbar="1" backgroundColor="#F0F0F0" opacity="1" theme="" dataColorList="">
    <control name="" action="refresh" target="*" targetProperty="" location="dashboard" type="timer" controlClass="" timeout="5" label="" title="" value="" text="" readOnly="false" valueList="" displayList="" activeWhen="">
      <valueRequired>false</valueRequired>
    </control>
  </widget>
</dashboard>

</items>
}

}
