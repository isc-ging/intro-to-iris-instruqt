Class HoleFoods.Interop.Msg.OrderRequest Extends Ens.Request
{

Property SKU As %String;

Property Quantity As %Integer;

Property Email As %String(MAXLEN = 200);

Storage Default
{
<Data name="OrderRequestDefaultData">
<Subscript>"OrderRequest"</Subscript>
<Value name="1">
<Value>SKU</Value>
</Value>
<Value name="2">
<Value>Quantity</Value>
</Value>
<Value name="3">
<Value>Email</Value>
</Value>
</Data>
<DefaultData>OrderRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
