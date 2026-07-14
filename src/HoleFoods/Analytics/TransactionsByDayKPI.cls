Class HoleFoods.Analytics.TransactionsByDayKPI Extends %DeepSee.KPI
{
    XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi xmlns="http://www.intersystems.com/deepsee/kpi"
  name="HoleFoods/TransactionsByDay"
  sourceType="sql"
  caption="Transactions By Day"
  sql="
SELECT
    %ODBCOUT(DATE(DATE_TRUNC('week', DateTimeOfSale))) AS WeekStarting,
    SUM(AmountOfSale) AS TotalRevenue
FROM HoleFoods.SalesTransaction
WHERE DateTimeOfSale >= TO_DATE(
    CONCAT(CAST(YEAR(CURRENT_DATE) AS VARCHAR(4)), '-01-01'),
    'YYYY-MM-DD'
)
GROUP BY DATE_TRUNC('week', DateTimeOfSale)
ORDER BY DATE_TRUNC('week', DateTimeOfSale)
"
>


<property name="TotalRevenue"   columnNo="2" />

</kpi>
}

}
