Class HoleFoods.Interop.REST.OrderDispatch Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/order" Method="POST" Call="PlaceOrder"/>
  <Route Url="/outlets" Method="GET" Call="GetOutlets"/>
  <Route Url="/products" Method="GET" Call="GetProducts"/>
  <Route Url="/quizcheck" Method="POST" Call="CheckQuiz"/>
</Routes>
}

ClassMethod GetOutlets() As %Status
{
    set %response.ContentType = "application/json"
    set rs = ##class(%SQL.Statement).%ExecDirect(,
        "SELECT ID, City, Country->Name AS CountryName FROM HoleFoods.Outlet ORDER BY City")
    set arr = []
    while rs.%Next() {
        do arr.%Push({"id": (rs.ID), "city": (rs.City), "country": (rs.CountryName)})
    }
    write arr.%ToJSON()
    quit $$$OK
}

ClassMethod GetProducts() As %Status
{
    set %response.ContentType = "application/json"
    set rs = ##class(%SQL.Statement).%ExecDirect(,
        "SELECT SKU, Name, Price FROM HoleFoods.Product ORDER BY Name")
    set arr = []
    while rs.%Next() {
        do arr.%Push({"sku": (rs.SKU), "name": (rs.Name), "price": (rs.Price)})
    }
    write arr.%ToJSON()
    quit $$$OK
}

ClassMethod PlaceOrder() As %Status
{
    set tSC = $$$OK
    try {
        set %response.ContentType = "application/json"
        set rawJSON = %request.Content.ReadLine(32768)

        set msg = ##class(Ens.StringRequest).%New()
        set msg.StringValue = rawJSON

        set tSC = ##class(Ens.Director).CreateBusinessService("FromWeb", .svc)
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

ClassMethod CheckQuiz() As %Status
{
    set %response.ContentType = "application/json"
    try {
        set rawJSON = %request.Content.ReadLine(32768)
        set obj = ##class(%DynamicObject).%FromJSON(rawJSON)
        set answer = obj.answer

        if answer = 42 {
            set ^HoleFoodsQuiz = 1
            write "{""correct"":true,""message"":""42 units of pasta were sold in Rome, Italy.""}"
        } else {
            write "{""correct"":false,""message"":""Take a closer look at the data!""}"
        }
    } catch ex {
        set %response.Status = "500 Internal Server Error"
        write "{""correct"":false,""message"":""Internal error""}"
    }
    quit $$$OK
}

}
