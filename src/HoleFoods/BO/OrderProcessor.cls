Class HoleFoods.BO.OrderProcessor Extends Ens.BusinessOperation
{

Method OnMessage(pRequest As HoleFoods.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK
    set pResponse = ##class(Ens.StringResponse).%New()

    try {
        set product = ##class(HoleFoods.Product).%OpenId(pRequest.SKU)
        if '$isObject(product) {
            set pResponse.StringValue = "Invalid SKU"
            quit
        }

        if product.Stock = 0 {
            set pResponse.StringValue = "Out of stock"
            quit
        }

        set tx = ##class(HoleFoods.Transaction).%New()
        set tx.Product = product
        set tx.Actual = 1
        set tx.DateOfSale = +$horolog
        set tx.UnitsSold = pRequest.Quantity
        set tx.AmountOfSale = product.Price * pRequest.Quantity
        set tx.Channel = 2
        set tSC = tx.%Save()
        quit:$$$ISERR(tSC)

        set product.Stock = product.Stock - pRequest.Quantity
        set tSC = product.%Save()
        quit:$$$ISERR(tSC)

        set pResponse.StringValue = "Order accepted"

    } catch ex {
        set tSC = ex.AsStatus()
    }

    quit tSC
}

}
