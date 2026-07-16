Include %DeepSee

/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// Utility methods for the DeepSee "HoleFoods" demo.
/// To create data for this DeepSee model, the easiest thing to do is to
/// use the <method>BuildData</method>:<br/>
/// From the command line:<br/>
/// <example language="cache">
/// do ##class(HoleFoods.Utils).BuildData(1000000,1,1)
/// </example>
/// The first argument is the number of records to create, 
/// the second argument indicates that index building should be done in parallel,
/// the third is a verbose flag; if true, then progress is displayed as the data is built.
Class HoleFoods.Utils Extends %RegisteredObject
{

// Stop Journalling in the database to speed up data generation and cube building

ClassMethod StopJournalling(db As %String) As %Status
{
  Set sc = $$$OK
  // disable journalling
  set ns=$ZNSPACE
  zn "%SYS"
  set path = ##class(Config.Databases).Open(db).Directory
  set database = ##class(SYS.Database).%OpenId($get(path))
  if $IsObject(database)  {
    do database.DisableJournaling() 
    set sc = database.%Save()
    }
  else { 
    set sc=$$$ERROR($$$GeneralError,"Custom error message")}
  zn ns
  Return sc
}

/// Add this alias so that each DeepSee sample has a Setup() method
ClassMethod Setup(pCount As %Integer = 2000, pASync As %Boolean = 1, pVerbose As %Boolean = 1)
{
	
	// Enable DeepSee in the default app of the current namespace
	set namespace = $ZNspace
	set app = $System.CSP.GetDefaultApp(namespace) _ "/"

	try {
		do EnableDeepSee^%SYS.cspServer(app)
	} catch (ex) {
		write !,"WARNING: failed to enable DeepSee for "_namespace_" namespace."
	}
	
	do ..BuildData(pCount,pASync,pVerbose)
}

/// Build the transactional data that will provide data for the DeepSee model.
/// Any old records will be deleted.<br/>
/// <var>pCount</var> is the number of records to create.<br/>
/// <var>pAsync</var> if true, indicates that parallel processing should be used to build the cube.<br/>
/// <var>pVerbose</var> if true, indicates that status messages should be written to the console.<br/>
ClassMethod BuildData(pCount As %Integer = 1000, pASync As %Boolean = 1, pVerbose As %Boolean = 1)
{
	// Delete cube if present
	if ##class(%DeepSee.Utils).%CubeExists("HOLEFOODS") {
		do ##class(%DeepSee.Utils).%KillCube("HOLEFOODS")
	}

	// kill old data
	do ##class(Region).%KillExtent()
	do ##class(Country).%KillExtent()
	do ##class(Outlet).%KillExtent()
	do ##class(Product).%KillExtent()
	do ##class(Transaction).%KillExtent()

	// build new data
	do ..CreateRecords(1,pCount,pVerbose)

	// update cube(s)
	if ##class(%DeepSee.Utils).%CubeExists("HOLEFOODS") {
		set tSC = ##class(%DeepSee.Utils).%BuildCube("HOLEFOODS",pASync,pVerbose)
		if $$$ISERR(tSC) {
			write !,"Error in BuildCube:"
			do $System.Status.DisplayError(tSC)
		}
	}

	if ##class(%DeepSee.Utils).%CubeExists("HOLEFOODSBUDGET") {
		set tSC = ##class(%DeepSee.Utils).%BuildCube("HOLEFOODSBUDGET",pASync,pVerbose)
		if $$$ISERR(tSC) {
			write !,"Error in BuildCube:"
			do $System.Status.DisplayError(tSC)
		}
	}

	if ##class(%DeepSee.Utils).%CubeExists("HoleFoodSales") {
		set tSC = ##class(%DeepSee.Utils).%BuildCube("HoleFoodSales",pASync,pVerbose)
		if $$$ISERR(tSC) {
			write !,"Error in BuildCube:"
			do $System.Status.DisplayError(tSC)
		}
	}

    //define pivot variables
    do ..SetupVariables()

	do $system.SQL.TuneTable("HoleFoods.Region")
	do $system.SQL.TuneTable("HoleFoods.Country")
	do $system.SQL.TuneTable("HoleFoods.Outlet")
	do $system.SQL.TuneTable("HoleFoods.Product")
	do $system.SQL.TuneTable("HoleFoods.Transaction")
}

/// Add new records to the transactional data that will provide data for the DeepSee model.
/// <var>pCount</var> is the number of records to create.<br/>
/// <var>pAsync</var> if true, indicates that parallel processing should be used to build the cube.<br/>
/// <var>pVerbose</var> if true, indicates that status messages should be written to the console.<br/>
ClassMethod AddData(pCount As %Integer = 100, pASync As %Boolean = 1, pVerbose As %Boolean = 1)
{
	// build new data
	do ..CreateRecords(0,pCount,pVerbose)
}

/// Update existing records to the transactional data that will provide data for the DeepSee model.
/// <var>pCount</var> is the number of records to create.<br/>
/// <var>pVerbose</var> if true, indicates that status messages should be written to the console.<br/>
ClassMethod UpdateData(pCount As %Integer = 100, pVerbose As %Boolean = 1)
{
	set tChangeCount = 0
	set tRecordCount = 100000
	for n=1:1:pCount {
		set tID = $R(tRecordCount) + 1
		set tRecord = ##class(HoleFoods.Transaction).%OpenId(tID)
		if $IsObject(tRecord) {
			set tRecord.UnitsSold = $S($R(10)<8:1,1:$R(8)+1)
			set tRecord.Discount = $S($R(10)<6:0,$R(10)<7:0.1,$R(10)<7:0.2,1:0.5)
			set tRecord.AmountOfSale = tRecord.UnitsSold * tRecord.Product.Price * (1 - tRecord.Discount)
			set tSC = tRecord.%Save()
			if $$$ISOK(tSC) {
				set tChangeCount = tChangeCount + 1
				if (pVerbose) write $C(13,27)_"[0J"_$FN(+$G(tChangeCount),",",0)_" record(s) updated"
			}
		}
	}
	if (pVerbose) write $C(13,27)_"[0J"_$FN(+$G(tChangeCount),",",0)_" record(s) updated"
}

/// Delete a record in the transactional data that provides data for the DeepSee model.
/// <var>pStart</var> is the starting Id of the source record to delete.<br/>
/// <var>pVerbose</var> if true, indicates that status messages should be written to the console.<br/>
ClassMethod DeleteRecords(pStartId As %Integer, pEndId As %Integer = "", pVerbose As %Boolean = 1)
{
	set:pEndId="" pEndId=pStartId
	for id=pStartId:1:pEndId {
		set tSC = ##class(HoleFoods.Transaction).%DeleteId(id)
		if $$$ISERR(tSC) {
			do:pVerbose $System.Status.DisplayError(tSC)
		}
	}

	if ##class(%DeepSee.Utils).%CubeExists("HOLEFOODS") {
		do ##class(%DeepSee.Utils).%SynchronizeCube("HOLEFOODS",pVerbose)
	}
}

/// does the actual work of creating new records in the source data.
/// <var>pCount</var> is the number of records to create.<br/>
/// <var>pAsync</var> if true, indicates that parallel processing should be used to build the cube.<br/>
/// <var>pVerbose</var> if true, indicates that status messages should be written to the console.<br/>
ClassMethod CreateRecords(pNewBuild As %Boolean, pCount As %Integer = 100, pVerbose As %Boolean = 1) [ Private ]
{
	set tSC = $$$OK
	try {
		// build new data

		if (pNewBuild) {
			// $LB(population,lat,long)
			set tRegionList("Asia","Japan","Tokyo") = $LB(12369000,35.623,139.703)
			set tRegionList("Asia","Japan","Osaka") = $LB(8817166,34.652,135.485)
			set tRegionList("Asia","China","Beijing") = $LB(17400000,39.860,116.412)
			set tRegionList("Asia","China","Shanghai") = $LB(16738000,31.224,121.466)
			set tRegionList("Asia","India","Mumbai") = $LB(12778721,18.96,72.819)
			set tRegionList("Asia","India","Bangalore") = $LB(6200000,12.963,77.587)
			set tRegionList("Europe","England","London") = $LB(7287555,51.503,-0.145)
			set tRegionList("Europe","England","Manchester") = $LB(2240230,53.470,-2.237)
			set tRegionList("Europe","France","Paris") = $LB(11174000,48.844,2.355)
			set tRegionList("Europe","France","Nice") = $LB(347100,43.709,7.266)
			set tRegionList("Europe","Spain","Madrid") = $LB(7061748,40.415,-3.709)
			set tRegionList("Europe","Spain","Barcelona") = $LB(1673075,41.387,2.169)
			set tRegionList("Europe","Germany","Berlin") = $LB(5000000,52.527,13.402)
			set tRegionList("Europe","Germany","Munich") = $LB(5203738,48.142,11.578)
			set tRegionList("Europe","Germany","Frankfurt") = $LB(5600000,50.097,8.678)
			set tRegionList("Europe","Belgium","Antwerp") = $LB(461496,51.212,4.393)
			set tRegionList("Europe","Belgium","Brussels") = $LB(1830000,50.845,4.338)
			set tRegionList("Europe","Netherlands","Amsterdam") = $LB(2158372,52.360,4.877)
			set tRegionList("Europe","Italy","Rome") = $LB(2743796,41.879,12.473)
			set tRegionList("Europe","Italy","Milan") = $LB(1310320,45.438,9.178)
			set tRegionList("N. America","USA","Boston") = $LB(3406829,42.3612,-71.5)
			set tRegionList("N. America","USA","New York") = $LB(19306183,40.785,-73.9639)
			set tRegionList("N. America","USA","Los Angeles") = $LB(9948081,34.027,-118.264)
			set tRegionList("N. America","USA","Seattle") = $LB(3263497,47.585,-122.350)
			set tRegionList("N. America","USA","Atlanta") = $LB(5278904,33.757,-84.354)
			set tRegionList("N. America","USA","Houston") = $LB(5628101,29.766,-95.390)
			set tRegionList("N. America","USA","Chicago") = $LB(9785747,41.867,-87.639)
			set tRegionList("N. America","Canada","Toronto") = $LB(5555912,43.638,-79.406)
			set tRegionList("N. America","Canada","Montreal") = $LB(3635571,45.501,-73.562)
			set tRegionList("N. America","Canada","Vancouver") = $LB(2524113,49.248,-123.109)
			set tRegionList("S. America","Brasil","Sao Paolo") = $LB(11150249,-23.544,-46.635)
			set tRegionList("S. America","Brasil","Rio De Janeiro") = $LB(7145472,-22.894,-43.228)
			set tRegionList("S. America","Brasil","Brasilia") = $LB(2455903,-15.779,-47.932)
			set tRegionList("S. America","Chile","Santiago") = $LB(7200000,-31.428,-70.562)

			set tTotalPopulation = 0

			// create regions, countries, outlets
			set r = $O(tRegionList(""))
			while (r '= "") {
				set tRegion = ##class(Region).%New()
				set tRegion.Name = r
				set tSC = tRegion.%Save()
				if $$$ISERR(tSC) quit

				set c = $O(tRegionList(r,""))
				while (c '= "") {
					set tCountry = ##class(Country).%New()
					set tCountry.Name = c
					set tCountry.Region = tRegion
					set tSC = tCountry.%Save()
					if $$$ISERR(tSC) quit

					set ct = $O(tRegionList(r,c,""))
					while (ct '= "") {
						set tOutlet = ##class(Outlet).%New()
						set tOutlet.City = ct
						set tOutlet.Country = tCountry
						set tPopulation = $LG(tRegionList(r,c,ct),1)
						set tOutlet.Population = tPopulation
						set tOutlet.Latitude = $LG(tRegionList(r,c,ct),2)
						set tOutlet.Longitude = $LG(tRegionList(r,c,ct),3)
						set tSC = tOutlet.%Save()
						if $$$ISERR(tSC) quit

						set tTotalPopulation = tTotalPopulation + tPopulation
						set tCityDistribution(tTotalPopulation) = tOutlet.%Id()

						set ct = $O(tRegionList(r,c,ct))
					}
					if $$$ISERR(tSC) quit
					set c = $O(tRegionList(r,c))
				}
				if $$$ISERR(tSC) quit
				set r = $O(tRegionList(r))
			}
			if $$$ISERR(tSC) quit

			// certain products are not sold in certain regions
			set tSkipProduct("Asia","SKU-101") = ""
			set tSkipProduct("Asia","SKU-712") = ""
			set tSkipProduct("Europe","SKU-195") = ""
			set tSkipProduct("N. America","SKU-204") = ""

			// Products: $LB(name,sku,price,type)
			kill tList
			set tList($I(tList)) = $LB("Bagels (dozen)","SKU-101",2.95,"Snack")
			set tList($I(tList)) = $LB("Donuts (dozen)","SKU-192",2.95,"Snack")
			set tList($I(tList)) = $LB("Pretzels (bag)","SKU-203",3.95,"Snack")
			set tList($I(tList)) = $LB("Unsalted Pretzels (bag)","SKU-204",4.25,"Snack")
			set tList($I(tList)) = $LB("Free-range Donuts (dozen)","SKU-195",12.95,"Snack")
			set tList($I(tList)) = $LB("Bundt Cake","SKU-199",19.95,"Snack")
			set tList($I(tList)) = $LB("Ziti (box)","SKU-296",1.95,"Pasta")
			set tList($I(tList)) = $LB("Penne (box)","SKU-287",1.95,"Pasta")
			set tList($I(tList)) = $LB("Tortellini (frozen)","SKU-928",6.95,"Pasta")
			set tList($I(tList)) = $LB("Cheerios (box)","SKU-709",3.95,"Cereal")
			set tList($I(tList)) = $LB("Fruit Loops (box)","SKU-708",4.95,"Fruit")
			set tList($I(tList)) = $LB("Pineapple Rings (can)","SKU-900",8.95,"Fruit")
			set tList($I(tList)) = $LB("Lifesavers (roll)","SKU-451",1.15,"Candy")
			set tList($I(tList)) = $LB("Swiss Cheese (sliced)","SKU-712",5.95,"Dairy")
			set tList($I(tList)) = $LB("Onion ring","SKU-222",5.95,"Vegetable")
			set tList($I(tList)) = $LB("Calamari (frozen)","SKU-601",22.95,"Seafood")

			set tProductCount = 0
			set n = $O(tList(""))
			while (n '= "") {
				set tProduct = ##class(Product).%New()
				set tProduct.Name = $LG(tList(n),1)
				set tProduct.SKU = $LG(tList(n),2)
				set tProduct.Price = $LG(tList(n),3)
				set tProduct.Category = $LG(tList(n),4)
				set tProduct.Stock = $R(151) + 50
                set tSC = tProduct.%Save()
                if $$$ISERR(tSC) quit
                if tProduct.SKU = "SKU-296" {
                        set tDefaultProduct = tProduct
                }

				// build random distribution of products
				set c = $R(10)+1
				for k = 1:1:c {
					set tProducts($I(tProductCount)) = tProduct
				}
				set n = $O(tList(n))
			}
			if $$$ISERR(tSC) quit

		}
		else {
			// use existing star tables

			// outlets
			set tStatement = ##class(%SQL.Statement).%New()
			set tSC = tStatement.%Prepare("SELECT ID FROM HoleFoods.Outlet")
			if $$$ISERR(tSC) quit
			set tSC = tStatement.%Execute()
			if $$$ISERR(tSC) quit

			while (tRS.Next()) {
				set tID = tRS.Data("ID")
				set tCity = ##class(Outlet).%OpenId(tID)
				if $IsObject(tCity) {
					set tCities($I(tCityCount)) = tCity
				}
			}

			// products
			set tStatement = ##class(%SQL.Statement).%New()
			set tSC = tStatement.%Prepare("SELECT ID FROM HoleFoods.Product")
			if $$$ISERR(tSC) quit
			set tSC = tRS.%Execute()
			if $$$ISERR(tSC) quit

			while (tRS.Next()) {
				set tID = tRS.Data("ID")
				set tProduct = ##class(Product).%OpenId(tID)
				if $IsObject(tProduct) {
					// build random distribution of products
					set c = $R(10)+1
					for k = 1:1:c {
						set tProducts($I(tProductCount)) = tProduct
					}
				}
			}
		}

		// distribution of dates increasing with time
		// last 5 full years, plus part of current year
		set tCurrYear = +$E($ZDT($H,3),1,4)
		set tStartYear = tCurrYear - 5
		set tCurrMonth = +$E($ZDT($H,3),6,7)
		set tMonthSeed = 1000
		set tMonthTotal = tMonthSeed
		set tMonths = 60 + tCurrMonth
		for m = 1:1:tMonths {
			set tMonthTotal = (tMonthTotal * 1.01)\1
			set tMonthDist(tMonthTotal) = m
		}

		// now build main table
		set tCount = pCount
		set tRows = 0
		set tYesterday = $piece($H,",",1) - 1

		// Track Rome pasta sales to ensure exactly 42 units
		set tRomePastaUnits = 0
		set tRomePastaTarget = 42

		for n = 1:1:tCount {
			set tRecord = ##class(Transaction).%New()

			// last 5 full years plus part of current year, with distribution increasing with time
			set tMonth = 1
			set mr = $R(tMonthTotal - tMonthSeed) + tMonthSeed
			set mi = $O(tMonthDist(mr))
			set:mi'="" tMonth = $G(tMonthDist(mi),1)

			set tYear = tStartYear + ((tMonth-1)\12)
			set tMonth = ((tMonth-1)#12) + 1
			set tDay = $R($$$iscDaysInMonth(tYear,tMonth)) + 1
			set tH = +$ZDTH(tYear_"-"_$$$iscPadZero(tMonth,2)_"-"_$$$iscPadZero(tDay,2),3)
			if tH > tYesterday { set tH = tYesterday }

			set tRecord.DateTimeOfSale = $ZDT(tH_","_$R(86400), 3)

			// product
			set tProduct = tProducts($R(tProductCount)+1)
			set tRecord.Product = tProduct

			set tRecord.UnitsSold = $S($R(10)<8:1,1:$R(8)+1)
			set tRecord.Discount = $S($R(10)<6:0,$R(10)<7:0.1,$R(10)<7:0.2,1:0.5)
			set tRecord.AmountOfSale = tRecord.UnitsSold * tProduct.Price * (1 - tRecord.Discount)

			// slowly change channel distribution
			set tRecord.Channel = $S($R(18000)<(tH-50000):2,1:1)

			// some are null
			if ($R(10) < 1) set tRecord.Channel = ""

			// assign outlet weighted by population
			if (pNewBuild) {
				if ($R(100)<2) {
					set tRecord.Comment = ..CreateComment()
				}

				set tOutletId = 1
				set lr = $R(tTotalPopulation)
				set li = $O(tCityDistribution(lr))
				set:li'="" tOutletId = $G(tCityDistribution(li),1)
				set tRecord.Outlet = ##class(Outlet).%OpenId(tOutletId)

				// test for skipped products
				if ($IsObject(tRecord.Outlet) && $IsObject(tRecord.Product)) {
					set tRegionName = tRecord.Outlet.Country.Region.Name
					set tSKU = tRecord.Product.SKU
					if ((tRegionName'="")&&(tSKU'="")) {
						if $D(tSkipProduct(tRegionName,tSKU)) {
							set tRecord.Product = tDefaultProduct
						}
					}
				}

				// Track Rome pasta sales
				if ($IsObject(tRecord.Outlet) && $IsObject(tRecord.Product)) {
					if (tRecord.Outlet.City = "Rome") && (tRecord.Product.Category = "Pasta") {
						set tRomePastaUnits = tRomePastaUnits + tRecord.UnitsSold
					}
				}
			}
			else {
				set tRecord.Outlet = tCities($R(tCityCount)+1)
			}

   			set tSC = tRecord.%Save()
			if $$$ISERR(tSC) {
				do $System.Status.DisplayError(tSC)
			}
			else {
				set tRows = tRows + 1
			}
			if (pVerbose&&('(tRows#1000))) write $C(13,27)_"[0J"_$FN(tRows,",",0)_" rows created"
		}

		// Adjust Rome pasta sales to exactly 42 units
		if (pNewBuild) {
			do ..AdjustRomePastaSales(tRomePastaUnits, tRomePastaTarget, pVerbose)
		}

		if (pVerbose) write $C(13,27)_"[0J"_$FN(+$G(tRows),",",0)_" row(s) created"
	}
	catch(ex) {
		set tSC = ex.AsStatus()
	}

	if $$$ISERR(tSC) {
		do $System.Status.DisplayError(tSC)
	}
}

/// Adjust Rome pasta sales to exactly the target amount
ClassMethod AdjustRomePastaSales(pCurrentUnits As %Integer, pTargetUnits As %Integer, pVerbose As %Boolean = 1) [ Private ]
{
	set tSC = $$$OK
	try {
		// Find Rome outlet ID
		set tRomeId = ""
		set tRS = ##class(%ResultSet).%New()
		set tSC = tRS.Prepare("SELECT ID FROM HoleFoods.Outlet WHERE City = 'Rome'")
		if $$$ISERR(tSC) quit
		set tSC = tRS.Execute()
		if $$$ISERR(tSC) quit
		if tRS.Next() {
			set tRomeId = tRS.Data("ID")
		}
		if tRomeId = "" quit

		// Find pasta product IDs
		kill tPastaProducts
		set tRS = ##class(%ResultSet).%New()
		set tSC = tRS.Prepare("SELECT ID FROM HoleFoods.Product WHERE Category = 'Pasta'")
		if $$$ISERR(tSC) quit
		set tSC = tRS.Execute()
		if $$$ISERR(tSC) quit
		while tRS.Next() {
			set tPastaProducts(tRS.Data("ID")) = ""
		}

		set tDiff = pTargetUnits - pCurrentUnits

		if tDiff > 0 {
			// Need to add more pasta sales in Rome
			if (pVerbose) write !,"Adding ",tDiff," pasta units to Rome sales"
			for i = 1:1:tDiff {
				set tRecord = ##class(Transaction).%New()
				set tRecord.Outlet = ##class(Outlet).%OpenId(tRomeId)
				// Pick random pasta product
				set tPastaId = $O(tPastaProducts(""))
				set tRecord.Product = ##class(Product).%OpenId(tPastaId)
				set tRecord.UnitsSold = 1
				set tRecord.Discount = 0
				set tRecord.AmountOfSale = tRecord.Product.Price
				set tRecord.Channel = 1
				// Recent date
				set tYesterday = $piece($H,",",1) - 1
				set tRecord.DateTimeOfSale = $ZDT(tYesterday_","_$R(86400), 3)
				set tSC = tRecord.%Save()
				if $$$ISERR(tSC) quit
			}
		}
		elseif tDiff < 0 {
			// Need to remove pasta sales from Rome or adjust quantities
			set tToRemove = -tDiff
			if (pVerbose) write !,"Reducing Rome pasta sales by ",tToRemove," units"

			set tRS = ##class(%ResultSet).%New()
			set tSC = tRS.Prepare("SELECT ID, UnitsSold FROM HoleFoods.Transaction WHERE Outlet = ? AND Product->Category = 'Pasta' ORDER BY ID")
			if $$$ISERR(tSC) quit
			set tSC = tRS.Execute(tRomeId)
			if $$$ISERR(tSC) quit

			while (tRS.Next() && (tToRemove > 0)) {
				set tTxnId = tRS.Data("ID")
				set tUnits = tRS.Data("UnitsSold")
				set tTxn = ##class(Transaction).%OpenId(tTxnId)
				if $IsObject(tTxn) {
					if tUnits <= tToRemove {
						// Delete entire transaction
						set tSC = ##class(Transaction).%DeleteId(tTxnId)
						set tToRemove = tToRemove - tUnits
					}
					else {
						// Reduce units
						set tTxn.UnitsSold = tUnits - tToRemove
						set tTxn.AmountOfSale = tTxn.UnitsSold * tTxn.Product.Price * (1 - tTxn.Discount)
						set tSC = tTxn.%Save()
						set tToRemove = 0
					}
					if $$$ISERR(tSC) quit
				}
			}
		}
		else {
			if (pVerbose) write !,"Rome pasta sales already at target: ",pTargetUnits," units"
		}
	}
	catch(ex) {
		set tSC = ex.AsStatus()
	}

	if $$$ISERR(tSC) {
		do $System.Status.DisplayError(tSC)
	}
}

/// Return a random comment for a transaction.
ClassMethod CreateComment() As %String
{
	set tComment = ""

	set tSubject($I(tSubject)) = "Customer"
	set tSubject($I(tSubject)) = "Shopper"

	set tVerb($I(tVerb)) = " complained about"
	set tVerb($I(tVerb)) = " complained about"
	set tVerb($I(tVerb)) = " complained about"
	set tVerb($I(tVerb)) = " ranted about"
	set tVerb($I(tVerb)) = " was happy about"
	set tVerb($I(tVerb)) = " commented on"

	set tObject($I(tObject)) = " prices"
	set tObject($I(tObject)) = " high prices"
	set tObject($I(tObject)) = " outrageous prices"
	set tObject($I(tObject)) = " ridiculous prices"
	set tObject($I(tObject)) = " freshness"
	set tObject($I(tObject)) = " quality"
	set tObject($I(tObject)) = " service"
	set tObject($I(tObject)) = " coupons"
	set tObject($I(tObject)) = " advertising"
	set tObject($I(tObject)) = " cashier"
	set tObject($I(tObject)) = " appearance of store"
	set tObject($I(tObject)) = " availability of items"

	set tComment = tSubject($R(tSubject)+1) _ tVerb($R(tVerb)+1) _ tObject($R(tObject)+1)
	quit tComment
}

/// Change the (display) name of the specified product.
ClassMethod ChangeProductName(pProductID As %String, pNewName As %String)
{
	set tProduct = ##class(Product).%OpenId(pProductID)
	if $IsObject(tProduct) {
		set tProduct.Name = pNewName
		set tSC = tProduct.%Save()
		if $$$ISERR(tSC) {
			do $System.Status.DisplayError(tSC)
			quit
		}
	}
	else {
		write "Product not found: ",pProductID,!
	}
}

/// Add a new product and update the cube.
ClassMethod AddProduct(pRecordID As %String, pSKU As %String, pNewName As %String)
{
	set tRecord = ##class(Transaction).%OpenId(pRecordID)
	if $IsObject(tRecord) {
		set tProduct = ##class(Product).%New()
		set tProduct.SKU = pSKU
		set tProduct.Name = pNewName
		set tProduct.Price = 2.95
		set tSC = tProduct.%Save()
		if $$$ISERR(tSC) {
			do $System.Status.DisplayError(tSC)
			quit
		}
		set tRecord.Product = tProduct
		set tSC = tRecord.%Save()
		if $$$ISERR(tSC) {
			do $System.Status.DisplayError(tSC)
			quit
		}
		// Update cube
		set tSC = ##class(%DeepSee.Utils).%SynchronizeCube("HOLEFOODS")
		if $$$ISERR(tSC) {
			do $System.Status.DisplayError(tSC)
			quit
		}
	}
	else {
		write "Record not found: ",pRecordID,!
	}
}

/// Add a new product and update the cube.
ClassMethod ChangeMeasure(pRecordID As %String, pUnitsSold As %Integer)
{
	set tRecord = ##class(Transaction).%OpenId(pRecordID)
	if $IsObject(tRecord) {
		set tRecord.UnitsSold = pUnitsSold
		set tRecord.AmountOfSale = pUnitsSold * tRecord.Product.Price
		write "Product: ",tRecord.Product.Name,!
		set tSC = tRecord.%Save()
		if $$$ISERR(tSC) {
			do $System.Status.DisplayError(tSC)
			quit
		}
		// Update cube
		set tSC = ##class(%DeepSee.Utils).%SynchronizeCube("HOLEFOODS")
		if $$$ISERR(tSC) {
			do $System.Status.DisplayError(tSC)
			quit
		}
	}
	else {
		write "Record not found: ",pRecordID,!
	}
}



/// Purely for demo purposes, this method defines pivot variables used by this sample.
ClassMethod SetupVariables()
{
	// Cannot assume the following will work from release to release; replace with use of API when available

	write "Defining COMMISSIONPERCENTAGE pivot variable for HOLEFOODS cube",!
	kill ^DeepSee.Variables("HOLEFOODS","COMMISSIONPERCENTAGE")
	set ^DeepSee.Variables("HOLEFOODS","COMMISSIONPERCENTAGE")=$lb("CommissionPercentage","Commission Percentage","","0","literal","integer","manual","","0,5,10,11,12,13,14,15","")

	write "Defining YEAR pivot variable for HOLEFOODS cube",!
	kill ^DeepSee.Variables("HOLEFOODS","YEAR")
	set ^DeepSee.Variables("HOLEFOODS","YEAR")=$lb("Year","Year","","NOW","literal","string","kpi","HoleFoodsYears.kpi","","")
}

}
