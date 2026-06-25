# Interop Production Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the pointless order-routing production with a web-form-to-email flow that demonstrates IRIS connecting three systems (browser, database, SMTP) through one traceable production.

**Architecture:** REST endpoint receives order JSON, Business Service creates a message, Business Process routes to OrderProcessor (validates stock, writes sale, decrements stock) then on success to EmailOperation (sends SMTP to Mailpit). Static HTML form submits orders; thank-you page confirms success. Mailpit provides a real SMTP inbox with web UI.

**Tech Stack:** InterSystems IRIS (ObjectScript), EnsLib.EMail.OutboundAdapter, Mailpit (SMTP mock), Docker Compose, static HTML/JS.

---

## File Map

| File | Action | Responsibility |
|------|--------|----------------|
| `docker-compose.yml` | Modify | Add Mailpit service, expose port 8025 |
| `src/HoleFoods/Msg/OrderRequest.cls` | Modify | Add Email property |
| `src/HoleFoods/BO/OrderProcessor.cls` | Modify | Add quantity validation, keep stock/sale logic |
| `src/HoleFoods/BO/EmailOperation.cls` | Create | Send confirmation email via SMTP adapter |
| `src/HoleFoods/BP/OrderRouter.cls` | Rewrite | Call OrderProcessor, then EmailOperation on success |
| `src/HoleFoods/BS/OrderService.cls` | Modify | Pass Email field through |
| `src/HoleFoods/REST/OrderDispatch.cls` | Modify | Return JSON responses, pass email |
| `src/HoleFoods/Production.cls` | Modify | Remove old items, add EmailOperation |
| `src/HoleFoods/Setup.cls` | Modify | Copy thankyou.html, remove RejectionLog refs |
| `src/order.html` | Rewrite | Add disabled email field, redirect on success |
| `src/thankyou.html` | Create | Thank-you page with order details and link back |
| `src/HoleFoods/BO/AuditLogger.cls` | Delete | No longer needed |
| `src/HoleFoods/BO/RejectOperation.cls` | Delete | No longer needed |
| `src/HoleFoods/RejectionLog.cls` | Delete | No longer needed |

---

### Task 1: Add Mailpit to Docker Compose

**Files:**
- Modify: `docker-compose.yml`

- [ ] **Step 1: Update docker-compose.yml**

Replace the entire file with:

```yaml
services:
  iris:
    image: intersystems/iris-community:latest-em
    ports:
      - "52773:52773"
    volumes:
      - ./:/tmp/
    depends_on:
      - mailpit
  mailpit:
    image: axllent/mailpit:latest
    ports:
      - "8025:8025"
      - "1025:1025"
```

- [ ] **Step 2: Verify containers start**

Run: `docker compose up -d`
Expected: Both `iris` and `mailpit` containers running. Mailpit UI accessible at http://localhost:8025.

- [ ] **Step 3: Commit**

```bash
git add docker-compose.yml
git commit -m "Add Mailpit SMTP mock to docker-compose"
```

---

### Task 2: Delete Obsolete Files

**Files:**
- Delete: `src/HoleFoods/BO/AuditLogger.cls`
- Delete: `src/HoleFoods/BO/RejectOperation.cls`
- Delete: `src/HoleFoods/RejectionLog.cls`

- [ ] **Step 1: Remove files**

```bash
rm src/HoleFoods/BO/AuditLogger.cls
rm src/HoleFoods/BO/RejectOperation.cls
rm src/HoleFoods/RejectionLog.cls
```

- [ ] **Step 2: Commit**

```bash
git add -A
git commit -m "Remove AuditLogger, RejectOperation, and RejectionLog"
```

---

### Task 3: Add Email Property to OrderRequest

**Files:**
- Modify: `src/HoleFoods/Msg/OrderRequest.cls`

- [ ] **Step 1: Add Email property**

Replace the full file contents with:

```objectscript
Class HoleFoods.Msg.OrderRequest Extends Ens.Request
{

Property SKU As %String;

Property Quantity As %Integer;

Property Email As %String(MAXLEN = 200);

}
```

- [ ] **Step 2: Commit**

```bash
git add src/HoleFoods/Msg/OrderRequest.cls
git commit -m "Add Email property to OrderRequest message"
```

---

### Task 4: Update OrderProcessor with Quantity Validation

**Files:**
- Modify: `src/HoleFoods/BO/OrderProcessor.cls`

The processor already handles stock checks. Add explicit quantity validation (qty <= 0) and adjust the stock check to compare against requested quantity.

- [ ] **Step 1: Rewrite OrderProcessor**

Replace the full file contents with:

```objectscript
Class HoleFoods.BO.OrderProcessor Extends Ens.BusinessOperation
{

Method OnMessage(pRequest As HoleFoods.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK
    set pResponse = ##class(Ens.StringResponse).%New()

    try {
        if pRequest.Quantity <= 0 {
            set pResponse.StringValue = "ERROR:Invalid quantity"
            quit
        }

        set product = ##class(HoleFoods.Product).%OpenId(pRequest.SKU)
        if '$isObject(product) {
            set pResponse.StringValue = "ERROR:Product not found"
            quit
        }

        if product.Stock < pRequest.Quantity {
            set pResponse.StringValue = "ERROR:Out of stock"
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

        set pResponse.StringValue = "OK:Order accepted"

    } catch ex {
        set tSC = ex.AsStatus()
    }

    quit tSC
}

}
```

Note: Response strings use a `STATUS:Message` format. Prefix `OK:` means success, `ERROR:` means failure. The Router uses this to decide whether to send email.

- [ ] **Step 2: Commit**

```bash
git add src/HoleFoods/BO/OrderProcessor.cls
git commit -m "Add quantity validation and status prefixes to OrderProcessor"
```

---

### Task 5: Create EmailOperation

**Files:**
- Create: `src/HoleFoods/BO/EmailOperation.cls`

- [ ] **Step 1: Write EmailOperation**

Create `src/HoleFoods/BO/EmailOperation.cls`:

```objectscript
Class HoleFoods.BO.EmailOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter SETTINGS = "SMTPServer:Basic,SMTPPort:Basic,From:Basic";

Property From As %String [ InitialExpression = "orders@holeFoods.com" ];

Method OnMessage(pRequest As HoleFoods.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK
    set pResponse = ##class(Ens.StringResponse).%New()

    try {
        set msg = ##class(%Net.MailMessage).%New()
        set msg.From = ..From
        do msg.To.Insert(pRequest.Email)
        set msg.Subject = "Order Confirmed - "_pRequest.SKU
        set msg.IsBinary = 0
        set msg.IsHTML = 0
        do msg.TextData.WriteLine("Your order has been confirmed.")
        do msg.TextData.WriteLine("")
        do msg.TextData.WriteLine("SKU: "_pRequest.SKU)
        do msg.TextData.WriteLine("Quantity: "_pRequest.Quantity)
        do msg.TextData.WriteLine("")
        do msg.TextData.WriteLine("Thank you for shopping with HoleFoods!")

        set tSC = ..Adapter.SendMail(msg)
        quit:$$$ISERR(tSC)

        set pResponse.StringValue = "Email sent"
    } catch ex {
        set tSC = ex.AsStatus()
    }

    quit tSC
}

}
```

- [ ] **Step 2: Commit**

```bash
git add src/HoleFoods/BO/EmailOperation.cls
git commit -m "Add EmailOperation business operation using SMTP adapter"
```

---

### Task 6: Rewrite OrderRouter Business Process

**Files:**
- Modify: `src/HoleFoods/BP/OrderRouter.cls`

The router calls OrderProcessor. If the response starts with "OK:", it also calls EmailOperation. Otherwise it passes the error through.

- [ ] **Step 1: Rewrite OrderRouter**

Replace the full file contents with:

```objectscript
Class HoleFoods.BP.OrderRouter Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As HoleFoods.Msg.OrderRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tSC = $$$OK

    set tSC = ..SendRequestSync("OrderProcessor", pRequest, .tOrderResponse)
    quit:$$$ISERR(tSC)

    set result = tOrderResponse.StringValue

    if $piece(result, ":", 1) = "OK" {
        set tSC = ..SendRequestSync("EmailOperation", pRequest, .tEmailResponse)
        quit:$$$ISERR(tSC)
    }

    set pResponse = tOrderResponse
    quit tSC
}

}
```

- [ ] **Step 2: Commit**

```bash
git add src/HoleFoods/BP/OrderRouter.cls
git commit -m "Rewrite OrderRouter to call EmailOperation on success"
```

---

### Task 7: Update Business Service to Pass Email

**Files:**
- Modify: `src/HoleFoods/BS/OrderService.cls`

- [ ] **Step 1: Add Email field handling**

Replace the full file contents with:

```objectscript
Class HoleFoods.BS.OrderService Extends Ens.BusinessService
{

Method OnProcessInput(pInput As Ens.StringRequest, Output pOutput As Ens.StringResponse) As %Status
{
    set tSC = $$$OK
    try {
        set body = ##class(%DynamicObject).%FromJSON(pInput.StringValue)
        set msg = ##class(HoleFoods.Msg.OrderRequest).%New()
        set msg.SKU = body.SKU
        set msg.Quantity = body.Quantity
        set msg.Email = body.Email

        set tSC = ..SendRequestSync("Router", msg, .pOutput)
    } catch ex {
        set tSC = ex.AsStatus()
    }
    quit tSC
}

}
```

- [ ] **Step 2: Commit**

```bash
git add src/HoleFoods/BS/OrderService.cls
git commit -m "Pass Email field through BusinessService"
```

---

### Task 8: Update REST Dispatch to Return JSON

**Files:**
- Modify: `src/HoleFoods/REST/OrderDispatch.cls`

The dispatch now returns JSON `{"status":"success"}` or `{"status":"error","message":"..."}`. It also passes the email field.

- [ ] **Step 1: Rewrite OrderDispatch**

Replace the full file contents with:

```objectscript
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
        set message = $piece(result, ":", 2, *)

        if prefix = "OK" {
            write "{""status"":""success"",""message"":"""_message_"""}"
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
```

- [ ] **Step 2: Commit**

```bash
git add src/HoleFoods/REST/OrderDispatch.cls
git commit -m "Return JSON responses from REST dispatch"
```

---

### Task 9: Rewrite Order Form HTML

**Files:**
- Modify: `src/order.html`

- [ ] **Step 1: Rewrite order.html**

Replace the full file contents with:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>HoleFoods Order</title>
  <style>
    body { font-family: sans-serif; max-width: 420px; margin: 60px auto; padding: 0 16px; }
    h2 { margin-bottom: 24px; }
    label { display: block; margin-top: 14px; font-weight: 500; }
    input { width: 100%; padding: 8px; margin-top: 4px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
    input:disabled { background: #f5f5f5; color: #666; }
    button { margin-top: 20px; padding: 10px 28px; font-size: 1rem; cursor: pointer; background: #2a7ae2; color: #fff; border: none; border-radius: 4px; }
    button:hover { background: #1a5bb5; }
    #error { margin-top: 16px; color: #c00; font-weight: bold; display: none; }
  </style>
</head>
<body>
  <h2>Place an Order</h2>
  <form id="orderForm">
    <label>SKU
      <input type="text" name="sku" value="SKU-976" required>
    </label>
    <label>Quantity
      <input type="number" name="quantity" value="1" min="1" required>
    </label>
    <label>Confirmation Email
      <input type="email" name="email" value="customer@example.com" disabled>
    </label>
    <button type="submit">Submit Order</button>
  </form>
  <div id="error"></div>

  <script>
    document.getElementById('orderForm').addEventListener('submit', async function(e) {
      e.preventDefault();
      var errorDiv = document.getElementById('error');
      errorDiv.style.display = 'none';

      var sku = this.sku.value.trim();
      var quantity = parseInt(this.quantity.value, 10);
      var email = this.email.value.trim();

      try {
        var resp = await fetch('/api/holeFoods/order', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ SKU: sku, Quantity: quantity, Email: email })
        });
        var data = await resp.json();

        if (data.status === 'success') {
          window.location.href = '/csp/user/thankyou.html?sku=' + encodeURIComponent(sku) + '&qty=' + quantity;
        } else {
          errorDiv.textContent = data.message || 'Order failed';
          errorDiv.style.display = 'block';
        }
      } catch (err) {
        errorDiv.textContent = 'Connection error: ' + err.message;
        errorDiv.style.display = 'block';
      }
    });
  </script>
</body>
</html>
```

- [ ] **Step 2: Commit**

```bash
git add src/order.html
git commit -m "Rewrite order form with email field and JSON handling"
```

---

### Task 10: Create Thank-You Page

**Files:**
- Create: `src/thankyou.html`

- [ ] **Step 1: Write thankyou.html**

Create `src/thankyou.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Order Confirmed</title>
  <style>
    body { font-family: sans-serif; max-width: 480px; margin: 60px auto; padding: 0 16px; text-align: center; }
    .card { background: #f0f9f0; border: 1px solid #b2d8b2; border-radius: 8px; padding: 32px; margin-top: 20px; }
    h1 { color: #2a7a2a; }
    .details { margin: 20px 0; font-size: 1.1rem; }
    .email-note { color: #555; margin-top: 16px; font-style: italic; }
    .btn { display: inline-block; margin-top: 28px; padding: 12px 32px; font-size: 1rem; background: #2a7ae2; color: #fff; text-decoration: none; border-radius: 4px; }
    .btn:hover { background: #1a5bb5; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Thank You!</h1>
    <p class="details">Your order for <strong><span id="qty"></span>x <span id="sku"></span></strong> has been confirmed.</p>
    <p class="email-note">A confirmation email has been sent to customer@example.com</p>
    <a href="/csp/user/order.html" class="btn">Place Another Order</a>
  </div>

  <script>
    var params = new URLSearchParams(window.location.search);
    document.getElementById('sku').textContent = params.get('sku') || 'Unknown';
    document.getElementById('qty').textContent = params.get('qty') || '?';
  </script>
</body>
</html>
```

- [ ] **Step 2: Commit**

```bash
git add src/thankyou.html
git commit -m "Add thank-you page for successful orders"
```

---

### Task 11: Update Production Configuration

**Files:**
- Modify: `src/HoleFoods/Production.cls`

- [ ] **Step 1: Rewrite Production class**

Replace the full file contents with:

```objectscript
Class HoleFoods.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="HoleFoods.Production" LogGeneralTraceEvents="false">
  <Description>Order processing with email confirmation</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="OrderService" Category="" ClassName="HoleFoods.BS.OrderService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Router" Category="" ClassName="HoleFoods.BP.OrderRouter" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="OrderProcessor" Category="" ClassName="HoleFoods.BO.OrderProcessor" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="EmailOperation" Category="" ClassName="HoleFoods.BO.EmailOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SMTPServer">mailpit</Setting>
    <Setting Target="Adapter" Name="SMTPPort">1025</Setting>
  </Item>
</Production>
}

}
```

Note: `SMTPServer` is set to `mailpit` — the Docker Compose service name, which resolves via Docker's internal DNS.

- [ ] **Step 2: Commit**

```bash
git add src/HoleFoods/Production.cls
git commit -m "Update Production: remove old items, add EmailOperation with SMTP config"
```

---

### Task 12: Update Setup Class

**Files:**
- Modify: `src/HoleFoods/Setup.cls`

Add copying of `thankyou.html`, remove any references to RejectionLog.

- [ ] **Step 1: Rewrite Setup class**

Replace the full file contents with:

```objectscript
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

        write "Copying web pages to /csp/user/...",!
        set tSC = ..CopyWebPages()
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
        set tSC = ##class(%SYSTEM.OBJ).Load("/tmp/src/HoleFoods/Product.cls", "cuk-d")
        quit:$$$ISERR(tSC)

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

ClassMethod CopyWebPages() As %Status
{
    set tSC = $$$OK
    try {
        set dest = "/usr/irissys/csp/user/"

        set tSC = ##class(%File).CopyFile("/tmp/src/order.html", dest_"order.html", 1)
        quit:$$$ISERR(tSC)
        write "Copied order.html",!

        set tSC = ##class(%File).CopyFile("/tmp/src/thankyou.html", dest_"thankyou.html", 1)
        quit:$$$ISERR(tSC)
        write "Copied thankyou.html",!
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
```

- [ ] **Step 2: Commit**

```bash
git add src/HoleFoods/Setup.cls
git commit -m "Update Setup: copy thankyou.html, remove RejectionLog references"
```

---

### Task 13: Integration Test — Full Flow Locally

- [ ] **Step 1: Start the environment**

```bash
docker compose up -d
```

Wait for IRIS to be healthy (check `docker compose logs iris` for "SuperServer started").

- [ ] **Step 2: Import and compile all classes**

Connect to IRIS terminal and load the source:

```bash
docker compose exec iris iris session IRIS -U USER
```

Then inside the IRIS terminal:

```objectscript
do $system.OBJ.LoadDir("/tmp/src/HoleFoods/", "cuk-d", , 1)
do ##class(HoleFoods.Setup).Run()
```

- [ ] **Step 3: Test happy path**

Open http://localhost:52773/csp/user/order.html in a browser. Submit the form with SKU-976 and quantity 1. Verify:
- Redirects to thankyou.html with correct SKU and quantity in the page
- http://localhost:8025 shows a new email from orders@holeFoods.com to customer@example.com with subject "Order Confirmed - SKU-976"

- [ ] **Step 4: Test error path**

Go back to order form. Change quantity to 9999 (exceeds stock). Submit. Verify:
- Error message "Out of stock" appears on the form
- No new email appears in Mailpit

- [ ] **Step 5: Test invalid quantity**

Change quantity to 0. Submit. Verify:
- Error message "Invalid quantity" appears on the form
- No new email appears in Mailpit

- [ ] **Step 6: Verify message trace**

Open http://localhost:52773/csp/healthshare/USER/EnsPortal.ProductionConfig.zen and click on Messages tab. Verify:
- The successful order shows messages flowing: OrderService -> Router -> OrderProcessor -> EmailOperation
- The failed order shows messages flowing: OrderService -> Router -> OrderProcessor (stops there)

- [ ] **Step 7: Commit all (if any fixes were needed)**

```bash
git add -A
git commit -m "Integration verified: full order-to-email flow working"
```
