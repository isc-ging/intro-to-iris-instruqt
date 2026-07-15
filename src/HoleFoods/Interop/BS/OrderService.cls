Class HoleFoods.Interop.BS.OrderService Extends Ens.BusinessService
{

Method OnProcessInput(pInput As Ens.StringRequest, Output pOutput As Ens.StringResponse) As %Status
{
    set tSC = $$$OK
    try {
        set body = ##class(%DynamicObject).%FromJSON(pInput.StringValue)
        set msg = ##class(HoleFoods.Interop.Msg.OrderRequest).%New()
        set msg.SKU = body.SKU
        set msg.Quantity = body.Quantity
        set msg.Email = body.Email
        set msg.City = body.City

        set tSC = ..SendRequestSync("Router", msg, .pOutput)
    } catch ex {
        set tSC = ex.AsStatus()
    }
    quit tSC
}

}
