Class HoleFoods.BO.AuditLogger Extends Ens.BusinessOperation
{

Method OnMessage(pRequest As HoleFoods.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK
    set pResponse = ##class(Ens.StringResponse).%New()

    try {
        set log = ##class(HoleFoods.RejectionLog).%New()
        set log.SKU = pRequest.SKU
        set log.Quantity = pRequest.Quantity
        set log.Timestamp = $zdatetime($horolog, 3)
        set tSC = log.%Save()
        quit:$$$ISERR(tSC)

        set pResponse.StringValue = "Rejected: quantity must be positive"
    } catch ex {
        set tSC = ex.AsStatus()
    }

    quit tSC
}

}
