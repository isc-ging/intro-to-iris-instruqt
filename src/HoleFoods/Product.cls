Class HoleFoods.Product Extends %Persistent
{

Index KEY On SKU [ IdKey ];

Property Category As %String(MAXLEN = 100);

Property Name As %String(MAXLEN = 120);

Property SKU As %String(MAXLEN = 22);

Property Price As %Numeric(MINVAL = 0);

Property Stock As %Integer [ InitialExpression = 100 ];

Storage Default
{
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Category</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Price</Value>
</Value>
<Value name="5">
<Value>Stock</Value>
</Value>
</Data>
<DataLocation>^HoleFoods.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<IdLocation>^HoleFoods.ProductD</IdLocation>
<IndexLocation>^HoleFoods.ProductI</IndexLocation>
<StreamLocation>^HoleFoods.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
