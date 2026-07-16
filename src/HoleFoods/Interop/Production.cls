Class HoleFoods.Interop.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="HoleFoods.Interop.Production" LogGeneralTraceEvents="false">
  <Description>Order processing with email confirmation</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="FromWeb" Category="" ClassName="HoleFoods.Interop.BS.OrderService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Router" Category="" ClassName="HoleFoods.Interop.BP.OrderRouter" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="ToOrderProcessor" Category="" ClassName="HoleFoods.Interop.BO.ToOrderProcessor" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>

</Production>
}

}
