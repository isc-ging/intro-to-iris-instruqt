Class HoleFoods.Setup Extends %RegisteredObject
{

ClassMethod Run() As %Status
{
    set tSC = $$$OK
    try {
        write "Adding Stock column to HoleFoods.Product...",!
        set tSC = ..AddStockColumn()
        quit:$$$ISERR(tSC)

        write "Seeding out-of-stock product...",!
        set tSC = ..SeedOutOfStock()
        quit:$$$ISERR(tSC)

        write "Registering REST web application...",!
        set tSC = ..RegisterWebApp()
        quit:$$$ISERR(tSC)

        write "Copying order page to /csp/user/...",!
        set tSC = ..CopyOrderPage()
        quit:$$$ISERR(tSC)

        write "Starting production...",!
        set tSC = ..StartProduction()
        quit:$$$ISERR(tSC)

        write "Setup complete.",!
    } catch ex {
        set tSC = ex.AsStatus()
        do $system.Status.DisplayError(tSC)
    }
    quit tSC
}

ClassMethod AddStockColumn() As %Status
{
    set tSC = $$$OK
    try {
        // Reload the updated Product class (which includes the Stock property)
        set tSC = ##class(%SYSTEM.OBJ).Load("/tmp/src/HoleFoods/Product.cls", "cuk-d")
        quit:$$$ISERR(tSC)

        // Populate Stock=100 for any existing rows that have no value yet
        &sql(UPDATE HoleFoods.Product SET Stock = 100 WHERE Stock IS NULL)

        write "Stock column added.",!
    } catch ex {
        set tSC = ex.AsStatus()
    }
    quit tSC
}

ClassMethod SeedOutOfStock() As %Status
{
    set tSC = $$$OK
    try {
        // Pick a product that is not SKU-976 and set its stock to 0
        set rs = ##class(%SQL.Statement).%ExecDirect(,
            "SELECT TOP 1 ID FROM HoleFoods.Product WHERE SKU <> 'SKU-976' AND Stock > 0 ORDER BY SKU")
        if rs.%Next() {
            set product = ##class(HoleFoods.Product).%OpenId(rs.ID, , .tSC)
            quit:$$$ISERR(tSC)
            set product.Stock = 0
            set tSC = product.%Save()
            quit:$$$ISERR(tSC)
            write "Set SKU="_product.SKU_" (ID="_rs.ID_") to Stock=0",!
        } else {
            write "No eligible product found for out-of-stock demo.",!
        }
    } catch ex {
        set tSC = ex.AsStatus()
    }
    quit tSC
}

ClassMethod RegisterWebApp() As %Status
{
    set tSC = $$$OK
    try {
        // REST endpoint for the production service

        new $NAMESPACE
        set $NAMESPACE="%SYS"

        set appName = "/api/holeFoods"
        set props("AutheEnabled") = 64
        set props("DispatchClass") = "HoleFoods.REST.OrderDispatch"
        set props("MatchRoles") = ":%All"
        set props("NameSpace") = "USER"
        set props("Recurse") = 1
        set props("Type") = 2
        if ##class(Security.Applications).Exists(appName) {
            set tSC = ##class(Security.Applications).Modify(appName, .props)
            quit:$$$ISERR(tSC)
            write "Updated web app "_appName,!
        } else {
            set tSC = ##class(Security.Applications).Create(appName, .props)
            quit:$$$ISERR(tSC)
            write "Registered web app "_appName,!
        }
    } catch ex {
        set tSC = ex.AsStatus()
    }
    quit tSC
}

ClassMethod CopyOrderPage() As %Status
{
    set tSC = $$$OK
    try {
        set src = "/tmp/src/order.html"
        set dest = "/usr/irissys/csp/user/order.html"
        set tSC = ##class(%File).CopyFile(src, dest, 1, .copied)
        quit:$$$ISERR(tSC)
        write "Copied order.html to /csp/user/order.html",!
    } catch ex {
        set tSC = ex.AsStatus()
    }
    quit tSC
}

ClassMethod StartProduction() As %Status
{
    set tSC = $$$OK
    try {
        set currentProd = ##class(Ens.Director).GetActiveProductionName()
        if currentProd = "HoleFoods.Production" {
            write "Production already running.",!
            quit
        }
        if currentProd '= "" {
            write "Stopping current production: "_currentProd,!
            set tSC = ##class(Ens.Director).StopProduction(10, 1)
            quit:$$$ISERR(tSC)
        }
        set tSC = ##class(Ens.Director).StartProduction("HoleFoods.Production")
        quit:$$$ISERR(tSC)
        write "Production started.",!
    } catch ex {
        set tSC = ex.AsStatus()
    }
    quit tSC
}

}
