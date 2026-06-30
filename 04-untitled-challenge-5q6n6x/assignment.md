---
slug: untitled-challenge-5q6n6x
id: dmxgfrflyt3h
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
- id: tubhhnqj21nb
  title: IRIS
  type: service
  hostname: iris
  path: /csp/user/EnsPortal.ProductionConfig.zen?$NAMESPACE=USER&
  port: 52773
difficulty: ""
enhanced_loading: null
---
HoleFoods is opening an online shop! We've already created a nice web page to send orders, and, because we are using InterSystems IRIS, an interoperability production. At the start, this production is just going to be a way to log downstream event which happens when an order is sent. 

Lets start by submitting an order. **In the [Shop](tab-0), find our Gummy Rings (SKU-976) and hit "Submit Order".**

And we get redirected to a thank you page. Seems pretty standard. Let's take a look at the back-end 

**Open [IRIS](tab-1)**. You will see the Interoperability Portal. Click {{SOMEWHERE}} to view the Message Trace. 

This trace shows that the order enters the Production from the `OrderService`, passes through a `Router` and goes to `OrderProcessor`. The Order Processor in this case just handles updating the database. Don't worry too much about the details. 

This production is just getting started. The next thing we are going to do is to add an email operation, so we can send an Order Confirmation. We've already made this component for another production so we can simply plant it straight in here. 

**Press the `+` button next to Business Operations** to add a new component. The new component form should be pre-filled, so you can press ok and see our new component appear in the production. 

**Return to the Shop Page and Submit another order.**

**This time, open the [Mail tab](tab-3) and take a look at the inbox.** You should see a new email with an order confirmation. 

Finally, lets take a look at this message trace. Should see the message goes to the `OrderOperation`, back to the `Router`, then to the `EmailOperation` before returning to the sender with confirmation. 

## Conclusions 

Here, we've seen how systems can be connected in a traceable, auditable, and modular way in IRIS Interoperability Productions. 

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

