/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// Instances of this class represent specific sales transactions within the HoleFoods demo.
Class HoleFoods.Transaction Extends %Persistent [ SqlTableName = SalesTransaction ]
{

/// Track changes to this class.
Parameter DSTIME = "auto";

Index DateOfSale On DateOfSale;

Index Product On Product [ Type = bitmap ];

Index Outlet On Outlet [ Type = bitmap ];

/// Date of this sale.
Property DateOfSale As %Date;

/// Product sold.
Property Product As Product;

/// Store or other outlet in which the sale occurred.
Property Outlet As Outlet;

/// Channel product was sold through: "Retail" or "Online".
Property Channel As %String(DISPLAYLIST = ",Retail,Online", VALUELIST = ",1,2");

/// Amount of this sale.
Property AmountOfSale As %Numeric(SCALE = 2);

/// Units sold.
Property UnitsSold As %Integer;

/// Discount amount.
Property Discount As %Numeric(SCALE = 2);

/// Customer comment on this transaction (if any).
Property Comment As %String(MAXLEN = 500);

Storage Default
{
<Data name="TransactionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfSale</Value>
</Value>
<Value name="3">
<Value>Product</Value>
</Value>
<Value name="4">
<Value>Outlet</Value>
</Value>
<Value name="5">
<Value>Channel</Value>
</Value>
<Value name="6">
<Value>AmountOfSale</Value>
</Value>
<Value name="7">
<Value>UnitsSold</Value>
</Value>
<Value name="8">
<Value>Discount</Value>
</Value>
<Value name="9">
<Value>Comment</Value>
</Value>
</Data>
<DataLocation>^HoleFoods.TransactionD</DataLocation>
<DefaultData>TransactionDefaultData</DefaultData>
<IdLocation>^HoleFoods.TransactionD</IdLocation>
<IndexLocation>^HoleFoods.TransactionI</IndexLocation>
<StreamLocation>^HoleFoods.TransactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
