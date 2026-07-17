Class HoleFoods.Interop.BO.ToOrderProcessor Extends Ens.BusinessOperation
{

Method OnMessage(pRequest As HoleFoods.Interop.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK
    set pResponse = ##class(Ens.StringResponse).%New()

    try {
        if pRequest.Quantity <= 0 {
            set pResponse.StringValue = "ERROR:Invalid quantity"
            quit
        }

        set product = ##class(HoleFoods.Product).%OpenId(pRequest.SKU)
        if '$isObject(product) {
            set pResponse.StringValue = "ERROR:Product not found"
            quit
        }

        if product.Stock < pRequest.Quantity {
            set pResponse.StringValue = "ERROR:Out of stock"
            quit
        }

        set tx = ##class(HoleFoods.Transaction).%New()
        set tx.Product = product
        set tx.DateTimeOfSale = $ZDT($H, 3)
        set tx.UnitsSold = pRequest.Quantity
        set tx.AmountOfSale = product.Price * pRequest.Quantity
        if pRequest.OutletId '= "" {
            set tx.Outlet = ##class(HoleFoods.Outlet).%OpenId(pRequest.OutletId)
        }
        set tSC = tx.%Save()
        quit:$$$ISERR(tSC)

        set product.Stock = product.Stock - pRequest.Quantity
        set tSC = product.%Save()
        quit:$$$ISERR(tSC)

        set pResponse.StringValue = "OK:Order accepted"

    } catch ex {
        set tSC = ex.AsStatus()
    }

    quit tSC
}

}
