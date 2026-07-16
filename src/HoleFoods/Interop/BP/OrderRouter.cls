Class HoleFoods.Interop.BP.OrderRouter Extends Ens.BusinessProcess
{
    Property OrderProcessorTarget As %String [InitialExpression="ToOrderProcessor"];
    Property ToEmailTarget As %String [InitialExpression="ToEmail"];
    Property SyncTarget As %String [InitialExpression=""];

    
    Parameter SETTINGS = "SyncTarget,ToEmailTarget,OrderProcessorTarget";

Method OnRequest(pRequest As HoleFoods.Interop.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK

    set tSC = ..SendRequestSync(..OrderProcessorTarget, pRequest, .tOrderResponse)
    quit:$$$ISERR(tSC) $$$OK

    set result = tOrderResponse.StringValue

    set emailSent = "0"

    if $piece(result, ":", 1) = "OK" {
        set emailSC = ..SendRequestSync(..ToEmailTarget, pRequest, .tEmailResponse)
        set emailSent = $select($$$ISOK(emailSC): "1", 1: "0")
    }

    set tOrderResponse.StringValue = tOrderResponse.StringValue_":"_emailSent
    set pResponse = tOrderResponse
    
    if ..SyncTarget '= "" {
        set st =  ..SendRequestAsync(..SyncTarget,##class(Ens.Request).%New(), 0)
        $$$LOGERROR(st)
    }

    quit tSC
}

Storage Default
{
<Data name="OrderRouterDefaultData">
<Subscript>"OrderRouter"</Subscript>
<Value name="1">
<Value>SyncTarget</Value>
</Value>
<Value name="2">
<Value>OrderProcessorTarget</Value>
</Value>
<Value name="3">
<Value>ToEmail</Value>
</Value>
<Value name="4">
<Value>ToEmailTarget</Value>
</Value>
</Data>
<DefaultData>OrderRouterDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
