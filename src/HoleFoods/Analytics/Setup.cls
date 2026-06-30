Class HoleFoods.Analytics.Setup Extends %RegisteredObject
{

ClassMethod Run() As %Status
{
    set tSC = $$$OK
    try {
        write "Seeding historical transactions...",!
        set tSC = ..SeedTransactions()
        quit:$$$ISERR(tSC)

        write "Building HoleFoods cube...",!
        set tSC = ##class(%DeepSee.Utils).%BuildCube("HoleFoods")
        quit:$$$ISERR(tSC)

        write "Analytics setup complete.",!
    } catch ex {
        set tSC = ex.AsStatus()
        do $system.Status.DisplayError(tSC)
    }
    quit tSC
}

ClassMethod SeedTransactions() As %Status
{
    set tSC = $$$OK
    try {
        // Collect products by category (exclude Gummy Rings SKU-976)
        set rsProducts = ##class(%SQL.Statement).%ExecDirect(,
            "SELECT ID, Name, Category, Price FROM HoleFoods.Product WHERE SKU <> 'SKU-976' ORDER BY Category, ID")

        // Group products by category
        kill catProducts
        while rsProducts.%Next() {
            set cat = rsProducts.Category
            if '$data(catProducts(cat)) {
                set catProducts(cat) = 0
            }
            set catProducts(cat) = catProducts(cat) + 1
            set catProducts(cat, catProducts(cat)) = rsProducts.ID
            set catPrices(rsProducts.ID) = rsProducts.Price
        }

        // Collect first 4 outlets
        set rsOutlets = ##class(%SQL.Statement).%ExecDirect(,
            "SELECT TOP 4 ID FROM HoleFoods.Outlet ORDER BY ID")
        set outletCount = 0
        while rsOutlets.%Next() {
            set outletCount = outletCount + 1
            set outlets(outletCount) = rsOutlets.ID
        }

        // Distribution: 5 Snacks, 4 Dairy, 3 Beverages, 3 Frozen
        set catCounts("Snacks") = 5
        set catCounts("Dairy") = 4
        set catCounts("Beverages") = 3
        set catCounts("Frozen") = 3

        // Channels to cycle through
        set channels(1) = "Retail"
        set channels(2) = "Online"
        set channels(3) = "Wholesale"

        // Date spread: 1-3 days ago using $horolog
        set today = $piece($horolog, ",", 1)
        set dates(1) = today - 1
        set dates(2) = today - 2
        set dates(3) = today - 3

        set txCount = 0
        set cat = ""
        for {
            set cat = $order(catCounts(cat))
            quit:cat=""
            set numTx = catCounts(cat)

            // Skip if category has no products
            continue:'$data(catProducts(cat))

            for i = 1:1:numTx {
                set txCount = txCount + 1

                // Pick a product from this category (cycle through available)
                set prodIdx = ((i - 1) # catProducts(cat)) + 1
                set prodId = catProducts(cat, prodIdx)

                // Pick an outlet (cycle through 4)
                set outletIdx = ((txCount - 1) # outletCount) + 1
                set outletId = outlets(outletIdx)

                // Pick a date (spread across 1-3 days ago)
                set dateIdx = ((txCount - 1) # 3) + 1
                set dateVal = dates(dateIdx)

                // Units between 4-15
                set units = 4 + (txCount # 12)

                // Channel cycles through Retail, Online, Wholesale
                set channelIdx = ((txCount - 1) # 3) + 1
                set channel = channels(channelIdx)

                // Amount = units * price
                set amount = units * catPrices(prodId)

                // Create the transaction
                set tx = ##class(HoleFoods.Transaction).%New()
                set tx.Product = ##class(HoleFoods.Product).%OpenId(prodId)
                set tx.Outlet = ##class(HoleFoods.Outlet).%OpenId(outletId)
                set tx.DateOfSale = dateVal
                set tx.UnitsSold = units
                set tx.AmountOfSale = amount
                set tx.Channel = channel
                set tx.Actual = 1

                set tSC = tx.%Save()
                quit:$$$ISERR(tSC)
            }
            quit:$$$ISERR(tSC)
        }
        quit:$$$ISERR(tSC)

        write "Inserted "_txCount_" historical transactions.",!
    } catch ex {
        set tSC = ex.AsStatus()
    }
    quit tSC
}

}
