Class HoleFoods.Analytics.Dashboard Extends %DeepSee.UserLibrary.Container
{

XData Contents [ XMLNamespace = "http://www.intersystems.com/deepsee/library" ]
{
<items>

<pivot xmlns="http://www.intersystems.com/deepsee/library" name="ProductSalesByDay" folderName="HoleFoods" title="" description="" keywords="" owner="UnknownUser" shared="true" public="false" locked="false" resource="" timeCreated="2026-07-15T08:34:45.888Z" createdBy="UnknownUser" category="" bookCover="" mdx="" cellWidth="120" columnHeaderStyle="" rowHeaderStyle="" cellStyle="" rowLabelSpan="true" columnLabelSpan="true" cellHeight="22" showEmptyRows="false" showEmptyColumns="false" cubeName="HoleFoodsSales" caption="" listing="" listingRows="" showStatus="true" canDrillDown="true" pageSize="100" colorScale="" rowTotals="false" columnTotals="false" rowTotalAgg="sum" columnTotalAgg="sum" rowTotalSource="page" showZebra="false" showRowCaption="true" printTitle="" printSubtitle="" printSubtitleOn="" showUser="" printPageSize="" printOrientation="1" printMarginTop="" printMarginLeft="" printMarginRight="" printMarginBottom="" printLabelWidth="" printCellWidth="" autoExecute="true" previewMode="false" manualMode="false" userMDX="" chartMarginTop="" chartMarginLeft="" chartMarginRight="" chartMarginBottom="" maxRows="" borderLeftCell="" borderRightCell="" borderTopCell="" borderBottomCell="" borderLeftCol="" borderRightCol="" borderTopCol="" borderBottomCol="" borderLeftRow="" borderRightRow="" borderTopRow="" borderBottomRow="" fontFamilyCell="" fontSizeCell="" fontFamilyCol="" fontSizeCol="" fontFamilyRow="" fontSizeRow="" showFilters="" showListingFilters="" showDate="" listingFontSize="" showZebraStripes="" filterTableStyle="" filterTableCaptionStyle="" filterTableItemStyle="" nowDisplayFormat="" measureLocation="columns" hideMeasures="1" backgroundImage="" backgroundOpacity=".12">
  <rowAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </rowAxisOptions>
  <columnAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </columnAxisOptions>
  <rowLevel spec="[DateTimeOfSale].[H1].[YearSold].Members" key="" value="" text="DateTimeOfSale" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </rowLevel>
  <columnLevel spec="[Product].[H1].[Product Category].Members" key="" value="" text="Product Category" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </columnLevel>
  <filter spec="[Outlet].[H1].[Region].Members" key="" value="" text="Outlet" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </filter>
  <sqlRestriction></sqlRestriction>
  <measure spec="[Measures].[AmountOfSale]" key="" value="" text="AmountOfSale" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </measure>
</pivot>

<pivot xmlns="http://www.intersystems.com/deepsee/library" name="SalesByCity" folderName="HoleFoods" title="" description="" keywords="" owner="UnknownUser" shared="true" public="false" locked="false" resource="" timeCreated="2026-07-15T08:16:37.755Z" createdBy="UnknownUser" category="" bookCover="" mdx="" cellWidth="120" columnHeaderStyle="" rowHeaderStyle="" cellStyle="" rowLabelSpan="true" columnLabelSpan="true" cellHeight="22" showEmptyRows="false" showEmptyColumns="false" cubeName="HoleFoodsSales" caption="" listing="" listingRows="" showStatus="true" canDrillDown="true" pageSize="100" colorScale="" rowTotals="false" columnTotals="false" rowTotalAgg="sum" columnTotalAgg="sum" rowTotalSource="page" showZebra="false" showRowCaption="true" printTitle="" printSubtitle="" printSubtitleOn="" showUser="" printPageSize="" printOrientation="1" printMarginTop="" printMarginLeft="" printMarginRight="" printMarginBottom="" printLabelWidth="" printCellWidth="" autoExecute="true" previewMode="false" manualMode="false" userMDX="" chartMarginTop="" chartMarginLeft="" chartMarginRight="" chartMarginBottom="" maxRows="" borderLeftCell="" borderRightCell="" borderTopCell="" borderBottomCell="" borderLeftCol="" borderRightCol="" borderTopCol="" borderBottomCol="" borderLeftRow="" borderRightRow="" borderTopRow="" borderBottomRow="" fontFamilyCell="" fontSizeCell="" fontFamilyCol="" fontSizeCol="" fontFamilyRow="" fontSizeRow="" showFilters="" showListingFilters="" showDate="" listingFontSize="" showZebraStripes="" filterTableStyle="" filterTableCaptionStyle="" filterTableItemStyle="" nowDisplayFormat="" measureLocation="columns" hideMeasures="1" backgroundImage="" backgroundOpacity=".12">
  <rowAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </rowAxisOptions>
  <columnAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </columnAxisOptions>
  <rowLevel spec="[Outlet].[H1].[Region].Members" key="" value="" text="Region" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </rowLevel>
  <columnLevel spec="[Measures].[AmountOfSale]" key="" value="" text="AmountOfSale" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </columnLevel>
  <columnLevel spec="[Measures].[UnitsSold]" key="" value="" text="UnitsSold" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </columnLevel>
  <sqlRestriction></sqlRestriction>
</pivot>

<pivot xmlns="http://www.intersystems.com/deepsee/library" name="RegionalSalesByTime" folderName="HoleFoods" title="" description="" keywords="" owner="" shared="true" public="false" locked="false" resource="" timeCreated="2026-07-17T08:43:26.282Z" createdBy="instruqt" category="" bookCover="" mdx="" cellWidth="120" columnHeaderStyle="" rowHeaderStyle="" cellStyle="" rowLabelSpan="true" columnLabelSpan="true" cellHeight="22" showEmptyRows="false" showEmptyColumns="false" cubeName="HOLEFOODSSALES" caption="" listing="" listingRows="" showStatus="true" canDrillDown="true" pageSize="100" colorScale="" rowTotals="false" columnTotals="false" rowTotalAgg="sum" columnTotalAgg="sum" rowTotalSource="page" showZebra="false" showRowCaption="true" printTitle="" printSubtitle="" printSubtitleOn="" showUser="" printPageSize="" printOrientation="1" printMarginTop="" printMarginLeft="" printMarginRight="" printMarginBottom="" printLabelWidth="" printCellWidth="" autoExecute="true" previewMode="false" manualMode="false" userMDX="" chartMarginTop="" chartMarginLeft="" chartMarginRight="" chartMarginBottom="" maxRows="" borderLeftCell="" borderRightCell="" borderTopCell="" borderBottomCell="" borderLeftCol="" borderRightCol="" borderTopCol="" borderBottomCol="" borderLeftRow="" borderRightRow="" borderTopRow="" borderBottomRow="" fontFamilyCell="" fontSizeCell="" fontFamilyCol="" fontSizeCol="" fontFamilyRow="" fontSizeRow="" showFilters="" showListingFilters="" showDate="" listingFontSize="" showZebraStripes="" filterTableStyle="" filterTableCaptionStyle="" filterTableItemStyle="" nowDisplayFormat="" measureLocation="columns" hideMeasures="1" backgroundImage="" backgroundOpacity=".12">
  <rowAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </rowAxisOptions>
  <columnAxisOptions spec="" key="" value="" text="" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </columnAxisOptions>
  <rowLevel spec="[DateTimeOfSale].[H1].[YearSold].Members" key="" value="" text="DateTimeOfSale" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </rowLevel>
  <columnLevel spec="[Outlet].[H1].[Region].Members" key="" value="" text="Outlet" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </columnLevel>
  <sqlRestriction></sqlRestriction>
  <measure spec="[Measures].[AmountOfSale]" key="" value="" text="AmountOfSale" headEnabled="false" headCount="" filterEnabled="false" filterExpression="" orderEnabled="false" orderExpression="" orderDirection="BDESC" aggEnabled="false" aggFunction="" aggFunctionParm="" levelCaption="Revenue" levelFormat="" levelSummary="" levelType="" drillLevel="0" advanced="false" levelStyle="" levelHeaderStyle="" suppress8020="false" drilldownSpec="" enabled="true">
  </measure>
</pivot>

<dashboard xmlns="http://www.intersystems.com/deepsee/library" name="SalesDashboard" folderName="HoleFoods" title="Sales Dashboard" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="2026-07-16T17:24:29.994Z" createdBy="instruqt" category="" bookCover="" scheme="" worklistCount="2" snapTo="true" snapGrid="true" gridRows="10" gridCols="10" canResize="true" canModify="true" showTitleBar="true" titleBarOpacity="" titleBarColor="" selectedTitleBarOpacity="" selectedTitleBarColor="" titleBarTextColor="" selectedTitleBarTextColor="" titleBarFont="" companyName="" companyLogo="" companyStyle="" backgroundColor="white" backgroundImage="none" backgroundRepeat="no-repeat" backgroundSize="100% 100%" backgroundOpacity="1" widgetBorders="1px solid #F0F0F0" widgetBordersSwitch="edit" widgetBordersColor="#F0F0F0" widgetBordersStyle="solid" widgetBordersWidth="1" widgetBordersToggle="true">
  <widget name="Top products this month" type="pivot" subtype="barChart" subtypeClass="barChart" title="Top Products By Revenue This Month" dataSource="HoleFoods/ProductsByMonthKPI.kpi" dataLink="" drillDownDataSource="" width="200" height="200" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="0" colSpanL="10" rowSpanL="5" showToolbar="true" showToolbarBottomBorder="true" showToolbarOnlyWhenMaximized="false" colorToolbar="#F0F0F0" opacityToolbar="1" backgroundColor="#F0F0F0" opacity="1" theme="" dataColorList="">
    <control name="" action="refresh" target="*" targetProperty="" location="dashboard" type="timer" controlClass="" timeout="10" label="" title="" value="" text="" readOnly="false" valueList="" displayList="" activeWhen="">
      <valueRequired>false</valueRequired>
    </control>
    <property name="analyzer">0</property>
    <property name="chartToggle">chart</property>
    <property name="contentPreview">0</property>
    <property name="csv">0</property>
    <property name="excel">1</property>
    <property name="print">1</property>
    <property name="showDimensions">0</property>
  </widget>
  <widget name="RecentTransactions" type="pivot" subtype="pivot" subtypeClass="lineChart" title="Recent Transactions" dataSource="HoleFoods/RecentTransactionsKPI.kpi" dataLink="" drillDownDataSource="" width="200" height="200" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="5" homeColL="0" colSpanL="5" rowSpanL="5" showToolbar="true" showToolbarBottomBorder="true" showToolbarOnlyWhenMaximized="false" colorToolbar="#F0F0F0" opacityToolbar="1" backgroundColor="#F0F0F0" opacity="1" theme="" dataColorList="">
  </widget>
  <widget name="TransactionsByWeek" type="pivot" subtype="lineChart" subtypeClass="lineChart" title="Transactions By Week" dataSource="HoleFoods/TransactionsByDay.kpi" dataLink="" drillDownDataSource="" width="200" height="200" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="5" homeColL="5" colSpanL="5" rowSpanL="5" showToolbar="true" showToolbarBottomBorder="true" showToolbarOnlyWhenMaximized="false" colorToolbar="#F0F0F0" opacityToolbar="1" backgroundColor="#F0F0F0" opacity="1" theme="" dataColorList="">
  </widget>
</dashboard>

<dashboard xmlns="http://www.intersystems.com/deepsee/library" name="ExploratoryDashboard" folderName="HoleFoods" title="Exploratory Dashboard" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="2026-07-15T08:07:41.875Z" createdBy="UnknownUser" category="" bookCover="" scheme="" worklistCount="1" snapTo="true" snapGrid="true" gridRows="10" gridCols="10" canResize="true" canModify="true" showTitleBar="true" titleBarOpacity="" titleBarColor="" selectedTitleBarOpacity="" selectedTitleBarColor="" titleBarTextColor="" selectedTitleBarTextColor="" titleBarFont="" companyName="HoleFoods" companyLogo="covers/10946124_s.jpg" companyStyle="" backgroundColor="white" backgroundImage="none" backgroundRepeat="no-repeat" backgroundSize="100% 100%" backgroundOpacity="1" widgetBorders="1px solid #F0F0F0" widgetBordersSwitch="edit" widgetBordersColor="#F0F0F0" widgetBordersStyle="solid" widgetBordersWidth="1" widgetBordersToggle="true">
  <widget name="Widget1" type="pivot" subtype="columnChart" subtypeClass="barChart" title="SalesByRegion" dataSource="HoleFoods/SalesByCity.pivot" dataLink="" drillDownDataSource="Region" width="200" height="200" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="0" colSpanL="10" rowSpanL="5" showToolbar="true" showToolbarBottomBorder="true" showToolbarOnlyWhenMaximized="false" colorToolbar="#F0F0F0" opacityToolbar="1" backgroundColor="#F0F0F0" opacity="1" theme="" dataColorList="">
    <control name="" action="applyFilter" target="*" targetProperty="[Product].[H1].[Product Category]" location="dashboard" type="dropdown" controlClass="" label="Product Category" title="" value="" text="" readOnly="false" valueList="" displayList="" activeWhen="">
      <valueRequired>false</valueRequired>
    </control>
    <property name="analyzer">1</property>
    <property name="chartToggle">chart</property>
    <property name="contentPreview">0</property>
    <property name="drillDown">1</property>
    <property name="pivotSelect"></property>
    <property name="print">0</property>
    <property name="showDimensions">0</property>
    <override name="barChart">{legendVisible:'false',seriesColorScheme:'pastel',xAxis:{_type:'axis'},yAxisList:[{_type:'axis'}],_type:'barChart'}</override>
  </widget>
  <widget name="Widget2" type="pivot" subtype="lineChart" subtypeClass="lineChart" title="Regional Sales By Time" dataSource="HoleFoods/RegionalSalesByTime.pivot" dataLink="" drillDownDataSource="YearSold" width="200" height="200" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="5" homeColL="0" colSpanL="10" rowSpanL="5" showToolbar="true" showToolbarBottomBorder="true" showToolbarOnlyWhenMaximized="false" colorToolbar="#F0F0F0" opacityToolbar="1" backgroundColor="#F0F0F0" opacity="1" theme="" dataColorList="">
    <property name="analyzer">1</property>
    <property name="chartToggle">chart</property>
    <property name="csv">0</property>
    <property name="drillDown">1</property>
    <property name="excel">0</property>
    <property name="legendPos">right</property>
    <property name="print">1</property>
    <property name="showDimensions">1</property>
    <override name="legend">{legendLabels:'Asia,Europe,N. America,S. America',legendPosition:'right',_type:'chartLegend'}</override>
    <override name="lineChart">{hasZoom:true,legendVisible:'false',lineStyle:'stroke-width:6;',seriesColorScheme:'pastel',xAxis:{_type:'axis'},yAxisList:[{_type:'axis'}],_type:'lineChart'}</override>
  </widget>
</dashboard>

</items>
}

}
