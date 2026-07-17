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
%ODBCOUT(DATE(DateTimeOfSale)), Product, Product->Name As ProductName, UnitsSold, AmountOfSale, Outlet->City
FROM HoleFoods.SalesTransaction
ORDER BY DateTimeOfSale DESC"
>

<property name="ProductID"   columnNo="2" />
<property name="ProductName"   columnNo="3" />
<property name="UnitsSold"   columnNo="4" />
<property name="AmountOfSale"   columnNo="5" />
<property name="City"   columnNo="6" />
</kpi>
}

}
