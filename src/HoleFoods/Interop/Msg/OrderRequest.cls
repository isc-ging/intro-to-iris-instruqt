Class HoleFoods.Interop.Msg.OrderRequest Extends Ens.Request
{

Property SKU As %String;

Property Quantity As %Integer;

Property Email As %String(MAXLEN = 200);

Property City As %String(MAXLEN = 100);

Property OutletId As %Integer;

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
<Value name="4">
<Value>City</Value>
</Value>
<Value name="5">
<Value>OutletId</Value>
</Value>
</Data>
<DefaultData>OrderRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
