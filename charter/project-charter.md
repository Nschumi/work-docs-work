# Project Charter: SAGA Telecom eCommerce Module

---

## 1. About the Project Charter

### 1.1 Description

This charter formally authorizes the SAGA Telecom eCommerce Module project, establishing its objectives, scope, key stakeholders, deliverables, and governance structure.

### 1.2 Disclaimer

This document may be updated as the project progresses to reflect new information or changes in direction.

---

## 2. Executive Summary

### 2.1 Business Need or Problem

Modernize the telecom eCommerce platform by enabling a whitelabel, multi-tenant solution that supports multiple brand partners with distinct configurations and branding, replacing the legacy TCM system.

### 2.2 Proposed Solution

Develop and deploy a scalable, multi-tenant eCommerce module as part of the SAGA platform, supporting both API and whitelabel customer models.

### 2.3 Business Benefits

- Improved operational efficiency
- Faster product launches
- Enhanced customer experience
- Increased partner engagement

### 2.4 Strategic Alignment

Supports Nuuday Mobile Partners’ strategy to deliver flexible, modular eCommerce solutions for multiple telecom brands.

---

## 3. Project Scope

### 3.1 Scope Inclusions

- Development of a multi-tenant eCommerce module
- Integration with downstream provisioning systems
- Support for distinct product offerings, pricing, and branding per partner
- Centralized product management for brand partners
- First-delivery components (see **3.1.1 Modules Overview**):
  - Channel Module
  - Catalog Module
  - Ordering & Checkout Module

### 3.2 Scope Exclusions

- Defining the API interface towards downstream provisioning systems

### 3.3 Modules Overview

#### Catalog Module Scope

- Maintains product items by storing only a legacy subscription ID for provisioning purposes, decoupling business logic from legacy data structures.
- Enriches each catalog entry with variant metadata—such as pricing tiers, promotional campaigns, and binding periods—to support multiple variants of the same subscription ID.
- Enforces tenant isolation by partitioning product namespaces and related metadata per brand partner, ensuring no data leakage across tenants.
- Exposes RESTful CRUD APIs for catalog item management and integrates with downstream provisioning systems to fetch subscription details based solely on the legacy ID.

#### Channel Module Scope

- Defines and manages digital sales channels (e.g., web front pages, subpages, mobile apps) as discrete entities representing customer touchpoints.
- Configures visibility of catalog items per channel via a many-to-many association table, incorporating `visible_from` and `visible_to` time-range fields for scheduling item exposure.
- Supports creation, update, and removal of channel configurations, enabling brand partners to tailor which products appear on which channels.
- Provides RESTful query APIs that return active catalog items for a given channel, filtering by current timestamp and channel context.

#### Number Management Module

- Manages the inventory, reservation, assignment, and lifecycle of telephone numbers, including both new number allocation and number port-in (MNP) processes.
- Maintains number pools and ranges per brand partner, ensuring only available numbers are offered at checkout.
- Provides APIs to the Ordering & Checkout Module for real-time number selection, validation, reservation, and release.
- Supports integration with legacy systems for number status updates and regulatory compliance.
- Tracks number statuses (available, reserved, assigned, ported, etc.) and maintains audit trails for all number transactions.

#### Cart Module Scope

- Facilitates the addition, removal, and modification of products in a customer's cart or basket.
- Tracks product quantities, pricing, and applicable discounts or promotions in real-time.
- Supports multi-tenant configurations to ensure tenant-specific rules for cart behavior, such as maximum item limits or promotional eligibility.
- Provides RESTful APIs for managing cart actions, including adding items, updating quantities, and clearing the cart.
- Integrates seamlessly with the Ordering & Checkout Module to transition cart contents into orders.
- Ensures cart persistence across sessions, allowing customers to resume shopping without losing their selections.
- Handles subscription products by treating each added quantity as a separate line item in the cart, ensuring unique tracking and management for each subscription instance.

#### Order Module Scope

- Orchestrates the entire order lifecycle, coordinating interactions between catalog, channel, number management, payment, and provisioning modules.
- Handles order creation, validation, and updates, ensuring all business rules and dependencies are respected.
- Tracks order status from initiation through fulfillment, including cancellations, returns, and modifications.
- Integrates with inventory and number management to allocate resources (e.g., available numbers) as part of the order process.
- Communicates with the Payment Module to initiate, confirm, or cancel payment transactions as required.
- Provides real-time order status and notifications to customers and stakeholders.
- Ensures auditability and traceability for all order-related actions.

#### Payment Module

- Manages payment processing for customer orders, supporting multiple payment methods and gateways.
- Handles payment authorization, capture, settlement, and refunds in coordination with the Order Module.
- Provides payment status updates to the Order Module and triggers order progression based on successful payment events.
- Supports transaction logging, reconciliation, and reporting for financial transparency.

---

## 4. Project Goals, Objectives, and Success Criteria

### 4.1 Goals & Objectives

- Enable multi-tenant support for telecom brand partners
- Empower partners to manage products, pricing, and campaigns
- Deliver a seamless, intuitive shopping experience
- Ensure high performance and scalability

### 4.2 Completion Criteria

- At least one brand partner migrated and using the module with whitelabel frontend
- All core features and integrations operational, including channel and catalog modules

### 4.3 Success Criteria

- System performance (response time, uptime, transaction volume) meets agreed SLAs
- Positive feedback from partners and customers on usability and performance
- Decreased support tickets post-launch

---

## 5. Business Case

### 5.1 Costs

Budget to be defined; will include development, infrastructure, and potential third-party services.

### 5.2 Benefits

- Increased revenue and partner satisfaction
- Platform scalability for future growth

---

## 6. Project Team

### 6.1 Project Sponsor

Lars Vieland Grasberger, Head of IT, Nuuday Mobile Partners.

### 6.2 Project Manager

Bjørn Alsted Nielsen, Product Owner, Nuuday Mobile Partners.

### 6.3 Key Stakeholders

- Nichlas Bruselius, Head of Brand Partners
- Katrine Grøn Iversen, Commercial Manager
- Katrine Blicher Christensen, Commercial Manager
- Niclas Schumacher, IT Lead

### 6.4 Core Project Team

Infrastructure & Platform team (responsible for building the module)

### 6.5 External Partners/Vendors

None currently; may be added as the project progresses.

---

## 7. Project Milestones & Checkpoints

### 7.1 Key Milestones

| Milestone ID | Description                                                                       | Timing         |
| ------------ | --------------------------------------------------------------------------------- | -------------- |
| M1           | Requirements gathering and analysis complete                                      | August 2025    |
| M1.1         | Delivery of channel and catalog modules for digital channels and API availability | September 2025 |
| M2           | Technical design and architecture planning complete                               | October 2025   |
| M3           | Development for Open Pages Project features complete                              | November 2025  |
| M4           | eCom module version 0.5                                                           | December 2025  |
| M5           | Whitelabel frontend capabilities delivered                                        | January 2026   |
| M6           | eCom module version 1.0 (full feature set)                                        | February 2026  |

### 7.2 Timeline

- Phase 1 (August): Technical design including architecture for channel and catalog modules.
- Phase 2 (September–December): Development & integration.

### 7.3 Go/No-Go Checkpoints

Dependencies on legacy TCM system, Open Pages project, and provisioning systems may impact go/no-go decisions.

---

## 8. Assumptions, Constraints & Dependencies

### 8.1 Assumptions

- Timely availability of resources for design and development
- Continued access to legacy TCM system for product, pricing, and MSISDN data

### 8.2 Constraints

Flexible to adapt to changing requirements or priorities

### 8.3 Dependencies

- Legacy TCM system for product, pricing, and MSISDN data
- Open Pages project for frontend capabilities
- Customer/subscriber provisioning systems

---

## 9. Risks and Opportunities

### 9.1 Risks

- Integration challenges with legacy and downstream systems may delay delivery
- Dependencies on other projects could cause resource conflicts
- Scope creep due to evolving partner requirements
- Competing priorities within Nuuday Mobile Partners may affect focus

### 9.2 Opportunities

- Strengthened relationships with brand partners through early engagement
- Foundation for future eCommerce innovation and feature expansion

---

## 10. Communication Plan

- **Jira dashboard:** Real-time project status, milestones, and key metrics
- **Slack channel:** Regular status updates and immediate issue resolution
- **Bi-weekly meetings:** Project progress reviews with stakeholders during feature development

---

## 11. Charter Acceptance & Approvals

- **Project Sponsor:** Lars Vieland Grasberger
- **Project Manager:** Bjørn Alsted Nielsen
- **Core Project Team:** [Signatures as appropriate]

**Prepared by:** [Your Name]  
**Date:** June 20, 2025
