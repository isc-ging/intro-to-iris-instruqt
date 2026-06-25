Class HoleFoods.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="HoleFoods.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="OrderService" Category="" ClassName="HoleFoods.BS.OrderService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Router" Category="" ClassName="HoleFoods.BP.OrderRouter" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="OrderProcessor" Category="" ClassName="HoleFoods.BO.OrderProcessor" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="AuditLogger" Category="" ClassName="HoleFoods.BO.AuditLogger" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
