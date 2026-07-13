Class HoleFoods.Interop.REST.OrderDispatch Extends %CSP.REST
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
        set %response.ContentType = "application/json"
        set rawJSON = %request.Content.ReadLine(32768)

        set msg = ##class(Ens.StringRequest).%New()
        set msg.StringValue = rawJSON

        set tSC = ##class(Ens.Director).CreateBusinessService("OrderService", .svc)
        if $$$ISERR(tSC) {
            write "{""status"":""error"",""message"":""Service unavailable""}"
            quit
        }

        set tSC = svc.ProcessInput(msg, .response)
        if $$$ISERR(tSC) {
            write "{""status"":""error"",""message"":""Processing failed""}"
            quit
        }

        set result = $select($isObject(response): response.StringValue, 1: "")
        set prefix = $piece(result, ":", 1)
        set message = $piece(result, ":", 2)
        set emailSent = $piece(result, ":", 3)

        if prefix = "OK" {
            write "{""status"":""success"",""message"":"""_message_""",""emailSent"":"_(emailSent = "1")_"}"
        } else {
            write "{""status"":""error"",""message"":"""_message_"""}"
        }

    } catch ex {
        set %response.Status = "500 Internal Server Error"
        write "{""status"":""error"",""message"":""Internal error""}"
    }
    quit $$$OK
}

}
