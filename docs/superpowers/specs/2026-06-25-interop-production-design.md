# Challenge 4 — Integration Layer Production

## Summary

A simple IRIS production demonstrating interoperability for total beginners. A web order form submits to IRIS, which processes the order (validates stock, writes a sale, decrements stock) and sends a confirmation email via SMTP to Mailpit. The learner sees the email arrive in a real inbox UI.

The goal: show that a production connects different systems (browser, database, email) through one visual, traceable message flow.

## Narrative Connection

Continues the "Gummy Rings" (SKU-976) thread from earlier challenges. The learner ordered the product conceptually in SQL (challenge 2) and changed its price in code (challenge 3). Now they place a real web order and watch it flow through the production into two external systems: the database and an email inbox.

## Architecture

```
[Web Form] --POST JSON--> [REST Dispatch] --> [Business Service]
                                                      |
                                                      v
                                               [OrderRouter BP]
                                                 /          \
                                                v            v
                                     [OrderProcessor BO]  [EmailOperation BO]
                                        |                       |
                                        v                       v
                                   [HoleFoods DB]         [Mailpit SMTP]
```

On success: both OrderProcessor and EmailOperation fire. The REST response triggers a redirect to a thank-you page.

On failure (out of stock, invalid qty): OrderProcessor returns an error. EmailOperation does NOT fire. The error displays on the form.

## Components

### Web Layer (static files served via CSP)

**order.html**
- Fields: SKU (text, pre-filled "SKU-976"), Quantity (number, default 1), Email (text, pre-filled "customer@example.com", disabled)
- Submits POST JSON to `/api/holeFoods/order`
- On success response: redirects to thankyou.html with order details as URL params
- On error response: displays error message inline on the form

**thankyou.html**
- Shows: "Thank you for your order! [qty]x [SKU] has been confirmed."
- Shows: "A confirmation email has been sent to customer@example.com"
- Big button: "Place Another Order" linking back to order.html

### REST Layer

**HoleFoods.REST.OrderDispatch**
- Extends `%CSP.REST`
- Route: `POST /order`
- Parses JSON body: `{sku, quantity, email}`
- Instantiates the Business Service and calls ProcessInput
- Returns JSON: `{status: "success"}` or `{status: "error", message: "..."}`

### Production Components

**HoleFoods.Production**
- Production class wiring all components together
- Items: OrderService, OrderRouter, OrderProcessor, EmailOperation

**HoleFoods.BS.OrderService** (Business Service)
- Receives the OrderRequest message from REST dispatch
- Sends synchronously to OrderRouter

**HoleFoods.Msg.OrderRequest** (Message)
- Properties: SKU (String), Quantity (Integer), Email (String)

**HoleFoods.BP.OrderRouter** (Business Process / BPL)
- Calls OrderProcessor synchronously
- If OrderProcessor returns success: calls EmailOperation, then returns success
- If OrderProcessor returns error: returns the error immediately (no email)

**HoleFoods.BO.OrderProcessor** (Business Operation)
- Looks up product by SKU
- Validates: product exists, quantity > 0, stock >= quantity
- On success: creates SalesTransaction, decrements Product.Stock, returns success message
- On failure: returns error string (e.g., "Out of stock", "Product not found", "Invalid quantity")

**HoleFoods.BO.EmailOperation** (Business Operation)
- Uses `EnsLib.EMail.OutboundAdapter` configured for localhost:1025 (Mailpit)
- Sends email:
  - To: value from OrderRequest.Email
  - From: orders@holeFoods.com
  - Subject: "Order Confirmed - [SKU]"
  - Body: plain text confirmation with SKU, quantity, and a thank-you line

### Infrastructure

**Mailpit**
- Single Go binary, runs on the IRIS container (or as a sibling service in docker-compose)
- SMTP on port 1025, Web UI on port 8025
- Zero configuration needed
- docker-compose exposes port 8025 to host for the web UI

## Setup Requirements

- Mailpit running and accessible
- HoleFoods.Product table has Stock column (INTEGER DEFAULT 100)
- At least one product (SKU-976, "Gummy Rings") has Stock > 0 for the happy path
- Optionally seed another product with Stock=0 so the learner can trigger the out-of-stock path
- REST web application `/api/holeFoods` registered
- `order.html` and `thankyou.html` served from `/csp/user/`
- Production started

## Success Criteria (local dev)

1. `docker compose up` starts IRIS and Mailpit
2. Open `http://localhost:52773/csp/user/order.html` — form loads with pre-filled values
3. Submit order — redirects to thank-you page
4. Open `http://localhost:8025` — confirmation email visible in Mailpit
5. Check SQL: Stock decremented, SalesTransaction created
6. Submit order with quantity exceeding stock — error displayed on form, no email in Mailpit
7. Production portal shows message trace for both success and failure paths

## Files to Create/Modify

### New files:
- `src/HoleFoods/BO/EmailOperation.cls`
- `src/order.html` (rewrite)
- `src/thankyou.html`

### Files to modify:
- `src/HoleFoods/Production.cls` — remove AuditLogger/RejectOperation, add EmailOperation
- `src/HoleFoods/BP/OrderRouter.cls` — rewrite routing logic (success → email, failure → error return)
- `src/HoleFoods/BS/OrderService.cls` — add Email property handling
- `src/HoleFoods/Msg/OrderRequest.cls` — add Email property
- `src/HoleFoods/BO/OrderProcessor.cls` — simplify, just validate + write sale + decrement stock
- `src/HoleFoods/REST/OrderDispatch.cls` — return JSON with status, pass email through
- `src/HoleFoods/Setup.cls` — add Mailpit setup, remove RejectionLog references
- `docker-compose.yml` — add Mailpit service or port exposure

### Files to delete:
- `src/HoleFoods/BO/AuditLogger.cls`
- `src/HoleFoods/BO/RejectOperation.cls`
- `src/HoleFoods/RejectionLog.cls`
