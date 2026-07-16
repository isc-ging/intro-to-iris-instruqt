---
slug: challenge-4
id: 594o3smbtq8q
type: challenge
title: Integration Layer
notes:
- type: text
  contents: |
    # Integration Layer
    At the core of IRIS is a powerful interoperability engine, designed to connect systems, applications, and data sources with ease.

    IRIS provides built-in support for integrating across a wide range of protocols and formats, including REST, SOAP, messaging queues, and industry standards such as HL7 and FHIR. This allows you to exchange and transform data between systems without needing additional integration platforms.

    Because integration runs directly within the IRIS platform, data flows can be managed, monitored, and processed in real time, with full transactional support. This ensures reliability and consistency, even in complex, high-volume environments.
tabs:
- id: vl33es18zc72
  title: Shop
  type: service
  hostname: iris
  path: /csp/user/order.html
  port: 52773
- id: hezenzl4t4re
  title: IRIS
  type: service
  hostname: iris
  path: /ui/interop/interop-editor/index.html?NAMESPACE=USER&%24PRODUCTION=HoleFoods.Interop.Production
  port: 52773
  protocol: http
- id: myvbqfctfiz9
  title: Mail
  type: service
  hostname: iris
  port: 8025
difficulty: ""
enhanced_loading: null
---
HoleFoods is opening an online shop! We've already created a nice web page to send orders, a REST API to recieve data from the webpage, and an InterSystems IRIS Interoperability to ensure the data can be traced and routed through the right processes.

Lets start by submitting an order. 

**In the [Shop](tab-0), find the Gummy Rings, choose a Delivery Location and hit "Submit Order".**

And we get redirected to a thank you page. Seems pretty standard. Let's take a look at the back-end


**Open [IRIS](tab-1)**. You should see the Interoperability Portal, looking something like this:

![Interop Portal](..\assets\ProductionPortal.png)

If you don't see this, or if it has only half loaded, hit the refresh button in the top right of the screen:

![Refresh Button](..\assets\RefreshButton.png)

We have three business host, these are reusable and configurable components that perform a task.
- **Inbound host**s manage a connection to an incoming system — for example a web-form being submitted, an email arriving in an inbox or new file being placed in a watched directory.
- **Process Hosts** handle logic-based message routing.
- **Outbound hosts** handle any results or outbound calls to another systems, for example writing to a database, querying an external API or database, or sending alerts.

These components can be created from a library of pre-built connectors and added to the UI, or the components can be custom-built in ObjectScript or Python.

In our example, our production recieves an order request and sends it to the OrderProcessor function which handles the updating of the database and organisation of the shipment.

Lets add another component to send the customer a confirmation email. Hit "Create" to add a new component, and choose "Outbound Host" from the dropdown.

![alt text](..\assets\CreateButton.png)

To configure this, select:
  - Outbound Type = `General`
  - Outbound Class = `HoleFoods.Interop.BO.ToEmail` (Scroll to the bottom of the list)
  - Name = `ToEmail`
  - Tick the "Enable Now" checkbox

When you are finished, click **Create**.

Afterwards click on the new `EmailOperation` Host, then click `Start Host`
![alt text](..\assets\StartHost.png)
# Trying the Production Again

Lets see if out new component works.

**Return to the [Shop](tab-0) tab, and submit another order for some more Gummy Rings.** This time, the thank you page should say that it has sent you an email. Lets check that this is true.

**Open the [Mail tab](tab-2).** You will see an email inbox. Hopefully, you should see a new message in the inbox, open it up and take a look at the order confirmation.



## Conclusions

Here, we've seen how systems can be connected in a traceable and modular way in IRIS Interoperability Productions.

This example connects a Web Page, our database and an Email server in one basic workflow, but we could easily extend this. After all, we still need to handle payment processing, that could be a separate operation with a call to our payment provided.

We could easily have many more systems involved in this production:
- Incoming calls coming from:
  - Invoices for bulk orders arriving as files.
  - Email requests
- Outgoing calls to
  - Couriers
  - Payment Providers
  - Re-stocking warehouse if stock is low

All of these providers might communicate through different protocols and systems, but with IRIS, we could tie them together in an efficient, traceable and reusable way.

