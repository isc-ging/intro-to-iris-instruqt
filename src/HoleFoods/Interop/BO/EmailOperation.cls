Class HoleFoods.Interop.BO.ToEmail Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter SETTINGS = "SMTPServer:Basic,SMTPPort:Basic,From:Basic";

Property From As %String [ InitialExpression = "orders@holeFoods.com" ];

Method OnInit() As %Status
{
    set tSC = ##super()
    quit:$$$ISERR(tSC) tSC
    set ..Adapter.SMTPServer = "localhost"
    set ..Adapter.SMTPPort = 1025
    quit $$$OK
}

Method OnMessage(pRequest As HoleFoods.Interop.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK
    set pResponse = ##class(Ens.StringResponse).%New()

    try {
        set product = ##class(HoleFoods.Product).%OpenId(pRequest.SKU)
        set productName = $select($isObject(product): product.Name, 1: pRequest.SKU)
        set unitPrice   = $select($isObject(product): product.Price, 1: 0)
        set totalCost   = unitPrice * pRequest.Quantity

        set rs = ##class(%SQL.Statement).%ExecDirect(,
            "SELECT City FROM HoleFoods.Outlet WHERE City = ?", pRequest.City)
        set storeName = $select(rs.%Next(): rs.City, 1: pRequest.City)

        set msg = ##class(%Net.MailMessage).%New()
        set msg.From = ..From
        do msg.To.Insert(pRequest.Email)
        set msg.Subject = "Order Confirmed - "_productName
        set msg.IsBinary = 0
        set msg.IsHTML = 0
        do msg.TextData.WriteLine("Thank you for your order with HoleFoods!")
        do msg.TextData.WriteLine("")
        do msg.TextData.WriteLine("Order Details")
        do msg.TextData.WriteLine("-------------")
        do msg.TextData.WriteLine("Product:    "_productName_" ("_pRequest.SKU_")")
        do msg.TextData.WriteLine("Quantity:   "_pRequest.Quantity)
        do msg.TextData.WriteLine("Unit Price: $"_$fnumber(unitPrice, ",", 2))
        do msg.TextData.WriteLine("Total:      $"_$fnumber(totalCost, ",", 2))
        do msg.TextData.WriteLine("")
        do msg.TextData.WriteLine("Delivery Location")
        do msg.TextData.WriteLine("-----------------")
        do msg.TextData.WriteLine("Store: "_storeName)
        do msg.TextData.WriteLine("")
        do msg.TextData.WriteLine("We hope to see you again soon!")

        set tSC = ..Adapter.SendMail(msg)
        quit:$$$ISERR(tSC)

        set pResponse.StringValue = "Email sent"
    } catch ex {
        set tSC = ex.AsStatus()
    }

    quit tSC
}

}
