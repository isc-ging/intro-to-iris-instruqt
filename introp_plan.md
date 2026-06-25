  HoleFoods Order Interop - Brief Spec

  Goal: A simple web form that submits a product order into IRIS, routed through an
  interoperability production, returning a visible status response to the form.

  ---
  Web Form

  A minimal, lightly styled HTML page hosted on IRIS (order.html or equivalent). Fields:
  - SKU (text input, pre-filled with SKU-976)
  - Quantity (number input)
  - Submit button

  On submit, POSTs JSON to /api/holeFoods/order. Displays the response string on the
  page.

  ---
  Message

  HoleFoods.Msg.OrderRequest extends Ens.Request:
  - SKU as %String
  - Quantity as %Integer

  ---
  Production: HoleFoods.Production

  Business Service: HoleFoods.BS.OrderService
  - Extends EnsLib.REST.Service
  - Accepts POST /api/holeFoods/order
  - Builds an OrderRequest, dispatches synchronously to the Router
  - Returns the response string as the HTTP body

  Router: EnsLib.MsgRouter.RoutingEngine (built-in, config only)
  - Quantity <= 0 -> HoleFoods.BO.RejectOperation
  - default -> HoleFoods.BO.OrderProcessor

  Business Operation: HoleFoods.BO.OrderProcessor extends Ens.BusinessOperation
  1. SQL lookup HoleFoods.Product by SKU
  2. No row -> return "Invalid SKU"
  3. Product.Stock = 0 -> return "Out of stock"
  4. Otherwise: insert HoleFoods.SalesTransaction, decrement Product.Stock, return
  "Order accepted"

  Business Operation: HoleFoods.BO.RejectOperation extends Ens.BusinessOperation
  - Returns "Invalid quantity"

  ---
  Data Changes

  - Add Stock INTEGER DEFAULT 100 to HoleFoods.Product
  - Pre-set one product (not SKU-976) to Stock = 0 for the out-of-stock demo

  ---
  Demo Sequence

  1. Submit SKU-976, qty 3 -> "Order accepted"
  2. Submit SKU-FAKE, qty 1 -> "Invalid SKU"
  3. Submit anything, qty 0 -> "Invalid quantity"
  4. Submit out-of-stock SKU -> "Out of stock"
  5. Open Message Viewer to show the trace of each message through the production