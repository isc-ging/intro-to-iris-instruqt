Class HoleFoods.Interop.BP.OrderRouter Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As HoleFoods.Interop.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK

    set tSC = ..SendRequestSync("OrderProcessor", pRequest, .tOrderResponse)
    quit:$$$ISERR(tSC)

    set result = tOrderResponse.StringValue

    set emailSent = "0"

    if $piece(result, ":", 1) = "OK" {
        set emailSC = ..SendRequestSync("EmailOperation", pRequest, .tEmailResponse)
        set emailSent = $select($$$ISOK(emailSC): "1", 1: "0")
    }

    set tOrderResponse.StringValue = tOrderResponse.StringValue_":"_emailSent
    set pResponse = tOrderResponse
    quit tSC
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
