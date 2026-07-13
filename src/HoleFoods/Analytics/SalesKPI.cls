Class HoleFoods.Analytics.SalesKPI Extends %DeepSee.KPI
{

XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi xmlns="http://www.intersystems.com/deepsee/kpi"
  name="HoleFoods/SalesKPI"
  sourceType="sql"
  caption="HoleFoods Sales KPIs"
  sql="SELECT SUM(AmountOfSale), SUM(UnitsSold), COUNT(*) FROM HoleFoods.SalesTransaction WHERE DateOfSale >= (CURRENT_DATE - 7)"
>
<property name="RecentRevenue" columnNo="1" />
<property name="RecentUnits"   columnNo="2" />
<property name="TotalOrders"   columnNo="3" />
</kpi>
}

}
