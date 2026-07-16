Class HoleFoods.Interop.BP.OrderRouter Extends Ens.BusinessProcess
{
    Property OrderProcessorTarget As %String [InitialExpression="ToOrderProcessor"];
    Property ToEmail As %String [InitialExpression="ToEmail"];
    Property SyncTarget As %String [InitialExpression=""];

    
    Parameter SETTINGS = "SyncTarget:SyncTarget";

Method OnRequest(pRequest As HoleFoods.Interop.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK

    set tSC = ..SendRequestSync(..ToOrderProcessor, pRequest, .tOrderResponse)
    quit:$$$ISERR(tSC) $$$OK

    set result = tOrderResponse.StringValue

    set emailSent = "0"

    if $piece(result, ":", 1) = "OK" {
        set emailSC = ..SendRequestSync(..ToEmail, pRequest, .tEmailResponse)
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
</Data>
<DefaultData>OrderRouterDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
