Class HoleFoods.BO.RejectOperation Extends Ens.BusinessOperation
{

Method OnMessage(pRequest As HoleFoods.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set pResponse = ##class(Ens.StringResponse).%New()
    set pResponse.StringValue = "Invalid quantity"
    quit $$$OK
}

}
