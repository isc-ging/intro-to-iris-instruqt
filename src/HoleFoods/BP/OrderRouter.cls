Class HoleFoods.BP.OrderRouter Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As HoleFoods.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK
    if pRequest.Quantity <= 0 {
        set tSC = ..SendRequestSync("AuditLogger", pRequest, .pResponse)
    } else {
        set tSC = ..SendRequestSync("OrderProcessor", pRequest, .pResponse)
    }
    quit tSC
}

}
