Class HoleFoods.Analytics.ProductsByMonthKPI Extends %DeepSee.KPI
{
    XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
    {
    <kpi xmlns="http://www.intersystems.com/deepsee/kpi"
    name="HoleFoods/ProductsByMonthKPI"
    sourceType="sql"
    caption="Product Sales By Month"
    sql="SELECT
    Product->Name AS ProductName,
    SUM(AmountOfSale) AS TotalAmountOfSale
FROM HoleFoods.SalesTransaction
WHERE DateOfSale >= DATEADD('month', -1, CURRENT_DATE)
GROUP BY Product->Name
ORDER BY TotalAmountOfSale DESC"
    >

    <property name="Total Revenue"   columnNo="2" />
    </kpi>
    }

}
