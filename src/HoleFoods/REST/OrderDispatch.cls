Class HoleFoods.REST.OrderDispatch Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/order" Method="POST" Call="PlaceOrder"/>
</Routes>
}

ClassMethod PlaceOrder() As %Status
{
    set tSC = $$$OK
    try {
        set rawJSON = %request.Content.ReadLine(32768)
        set msg = ##class(Ens.StringRequest).%New()
        set msg.StringValue = rawJSON

        set tSC = ##class(Ens.Director).CreateBusinessService("OrderService", .svc)
        quit:$$$ISERR(tSC)

        set tSC = svc.ProcessInput(msg, .response)
        quit:$$$ISERR(tSC)

        set responseText = $select($isObject(response): response.StringValue, 1: "No response")
        set %response.ContentType = "text/plain"
        write responseText

    } catch ex {
        set tSC = ex.AsStatus()
        set %response.Status = "500 Internal Server Error"
        write $system.Status.GetErrorText(tSC)
    }
    quit tSC
}

}
