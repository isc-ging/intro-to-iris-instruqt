Class HoleFoods.ProductChanges Extends %RegisteredObject
{

/// Prints the details of a product in the database
ClassMethod PrintProductDetails(pId As %String) As %Status
{
        // Open product by ID 
        set product = ##class(HoleFoods.Product).%OpenId(pId)

        // Write properties to terminal
        write !,!
        write "Product SKU: "_product.SKU, !
        write "Product Name: "_product.Name, !
        write "Product Category: "_product.Category,!
        write "Product Price: "_product.Price ,! 
        write !
}

/// Changes the current price of the product
ClassMethod ChangeProductPrice(pId As %String, pPrice As %Numeric) As %Status [ Language = python ]
{
        import iris #Embedded Python IRIS module

        # Open Product by ID
        product = iris.HoleFoods.Product._OpenId(pId)

        old_price = product.Price

        print(f"Changing product price from {old_price} to {pPrice}")

        # Set product price to new price
        product.Price = pPrice
        
        # Save the product to database
        out = product._Save()
}

}