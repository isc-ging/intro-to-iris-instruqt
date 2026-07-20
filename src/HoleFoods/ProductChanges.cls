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
        write "Product in Stock: "_product.Stock
        write !
}

/// Restock the product with new stock
ClassMethod Restock(id As %String, newStock As %Numeric) As %Status [ Language = python ]
{
        import iris #Embedded Python IRIS module

        # Open Product by ID
        product = iris.HoleFoods.Product._OpenId(id)

        # Add the new stock to the existing value
        product.Stock = product.Stock + newStock

        print(f"Restocking product, there are now {product.Stock} of {product.Name} units in stock")

        # Save the changes to the database
        out = product._Save()
}

}