/// Analytics cube for holefood sales
Class HoleFoods.Analytics.SalesCube Extends %DeepSee.CubeDefinition [ DependsOn = HoleFoods.Transaction, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="HoleFoodSales" displayName="HoleFood Sales" disabled="false" abstract="false" sourceClass="HoleFoods.Transaction" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Product" disabled="false" hasAll="false" allCaption="All Product" allDisplayName="Product" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Product Category" disabled="false" sourceProperty="Product.Category" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
      <level name="Product Name" disabled="false" sourceProperty="Product.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Outlet" disabled="false" hasAll="false" allCaption="All Outlet" allDisplayName="Outlet" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Region" disabled="false" sourceProperty="Outlet.Country.Region.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
      <level name="Country" disabled="false" sourceProperty="Outlet.Country.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
      <level name="City" disabled="false" sourceProperty="Outlet.City" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DateOfSale" disabled="false" hasAll="false" allCaption="All DateOfSale" allDisplayName="DateOfSale" sourceProperty="DateOfSale" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="YearSold" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="7">
      </level>
      <level name="MonthSold" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="8">
      </level>
      <level name="DaySold" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="9">
      </level>
    </hierarchy>
  </dimension>
  <measure name="AmountOfSale" disabled="false" sourceProperty="AmountOfSale" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="1">
  </measure>
  <measure name="Discount" disabled="false" sourceProperty="Discount" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="2">
  </measure>
  <measure name="UnitsSold" disabled="false" sourceProperty="UnitsSold" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="3">
  </measure>
  <listing name="Transaction Detail" disabled="false" listingType="table" fieldList="DateOfSale,Product->Name,Product->Category,Outlet->City,Channel,UnitsSold,AmountOfSale" orderBy="DateOfSale DESC">
  </listing>
</cube>
}

Parameter DOMAIN;

}
