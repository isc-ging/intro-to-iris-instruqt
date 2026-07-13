Class HoleFoods.Analytics.RecentTransactionsKPI Extends %DeepSee.KPI
{
    XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi xmlns="http://www.intersystems.com/deepsee/kpi"
  name="HoleFoods/RecentTransactionsKPI"
  sourceType="sql"
  caption="Recent Transactions"
  sql="
SELECT TOP 100
%ODBCOUT(DATE(DateOfSale)), Product, Product->Name As ProductName, UnitsSold, AmountOfSale
FROM HoleFoods.SalesTransaction
ORDER BY DateOfSale DESC"
>
<property name="DateOfSale" columnNo="1" />
<property name="ProductID"   columnNo="2" />
<property name="ProductName"   columnNo="3" />
<property name="UnitsSold"   columnNo="4" />
<property name="AmountOfSale"   columnNo="5" />

</kpi>
}

}
