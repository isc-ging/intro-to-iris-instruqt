Class HoleFoods.Interop.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="HoleFoods.Interop.Production" LogGeneralTraceEvents="false">
  <Description>Order processing with email confirmation</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="OrderService" Category="" ClassName="HoleFoods.Interop.BS.OrderService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Router" Category="" ClassName="HoleFoods.Interop.BP.OrderRouter" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="OrderProcessor" Category="" ClassName="HoleFoods.Interop.BO.OrderProcessor" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="EmailOperation" Category="" ClassName="HoleFoods.Interop.BO.EmailOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SMTPServer">mailpit</Setting>
    <Setting Target="Adapter" Name="SMTPPort">1025</Setting>
  </Item>
</Production>
}

}
