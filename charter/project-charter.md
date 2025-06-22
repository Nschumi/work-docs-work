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

- Development of a multi-tenant eCommerce Service
- Integration with downstream provisioning systems
- Support for distinct product offerings, pricing, and branding per partner
- Centralized product management for brand partners
- Development and delivery of whitelabel frontend capabilities enabling brand partners to customize storefront branding, layout, and product presentation
- Integration of the whitelabel frontend with backend modules (Catalog, Channel, Order, Payment) to provide a seamless end-to-end customer experience
- Support for responsive design and multi-channel access (web, mobile, app) within the whitelabel frontend
- First-delivery components (see **3.3 Modules Overview**):
  - Channel Module
  - Catalog Module
  - MVP Administration Portal (covering Channel and Catalog Module)

### 3.2 Scope Exclusions

- Defining the API interface towards downstream provisioning systems

### 3.2.1 Out of Scope / Future Work

- **Reporting & Analytics Module**: Planned for version 2, this module will provide advanced reporting and analytics capabilities, including dashboards for sales trends, customer behavior, and operational insights.
- Additional payment providers

### 3.3 Modules Overview

#### Catalog Module Scope

The **Catalog Module** is responsible for managing product items and their associated metadata while ensuring tenant isolation.

- Maintains product items by storing only a legacy subscription ID for provisioning purposes, decoupling business logic from legacy data structures.
- Enriches each catalog entry with variant metadata—such as pricing, promotional campaigns, and binding periods—to support multiple variants of the same subscription ID.
- Enforces tenant isolation by partitioning product namespaces and related metadata per brand partner, ensuring no data leakage across tenants.
- Exposes RESTful CRUD APIs for catalog item management and integrates with downstream Product Service to fetch subscription details based solely on the legacy ID.
- Includes information from the underlying subscription, such as:
  - Available datacards and their potential amount limits
  - Available SIM types
  - Available modules (e.g., 5G) with their price setup as defined in the legacy system.

#### Channel Module Scope

The **Channel Module** defines and manages digital sales channels, enabling brand partners to configure product visibility across multiple customer touchpoints.

- Defines and manages digital sales channels (e.g., web front pages, subpages, mobile apps, ecare upsale pages) as discrete entities representing customer touchpoints.
- Configures visibility of catalog items per channel via a many-to-many association table, incorporating `visible_from` and `visible_to` time-range fields for scheduling item exposure.
- Supports creation, update, and removal of channel configurations, enabling brand partners to tailor which products appear on which channels.
- Provides RESTful query APIs that return active catalog items for a given channel, filtering by current timestamp and channel context.

#### Number Management Module Scope

The **Number Management Module** handles the lifecycle of telephone numbers, ensuring availability and compliance with regulatory requirements.

- Manages the inventory, reservation, assignment, and lifecycle of telephone numbers, including both new number allocation and number port-in (MNP) processes.
- Maintains number pools and ranges per brand partner, ensuring only available numbers are offered at checkout.
- Provides APIs to the Ordering & Checkout Module for real-time number selection, validation, reservation, and release.
- Supports integration with legacy systems for number status updates and regulatory compliance.
- Tracks number statuses (available, reserved, assigned, ported, etc.) and maintains audit trails for all number transactions.

#### Basket Module Scope

The **Basket Module** facilitates the shopping basket experience, ensuring seamless management of products and tenant-specific configurations.

- Facilitates the addition, removal, and modification of products in a customer's basket.
- Tracks product quantities, pricing, and applicable discounts or promotions in real-time.
- Supports multi-tenant configurations to ensure tenant-specific rules for basket behavior, such as maximum item limits or promotional eligibility.
- Provides RESTful APIs for managing basket actions, including adding items, updating quantities, and clearing the basket.
- Integrates seamlessly with the Ordering & Checkout Module to transition basket contents into orders.
- Ensures basket persistence across sessions, allowing customers to resume shopping without losing their selections.
- Handles subscription products by treating each added quantity as a separate line item in the basket, ensuring unique tracking and management for each subscription instance.

#### Payment Module Scope

The **Payment Module** manages payment processing, ensuring secure and reliable transactions for customer orders.

- Manages payment processing for customer orders, supporting multiple payment methods and gateways.
- Handles payment authorization, capture, settlement, and refunds in coordination with the Order Module.
- Provides payment status updates to the Order Module and triggers order progression based on successful payment events.
- Supports transaction logging, reconciliation, and reporting for financial transparency.

#### Order Module Scope

The **Order Module** orchestrates the entire order lifecycle, ensuring compliance with business rules and seamless integration with other modules.

- Orchestrates the entire order lifecycle, coordinating interactions between catalog, channel, number management, payment, and provisioning modules.
- Handles order creation, validation, and updates, ensuring all business rules and dependencies are respected.
- Tracks order status from initiation through fulfillment, including cancellations, returns, and modifications.
- Integrates with inventory and number management to allocate resources (e.g., available numbers) as part of the order process.
- Communicates with the Payment Module to initiate, confirm, or cancel payment transactions as required.
- Provides real-time order status and notifications to customers and stakeholders.
- Ensures auditability and traceability for all order-related actions.

#### Whitelabel Frontend Module Scope

The **Whitelabel Frontend Module** provides customizable storefront templates allowing brand partners to apply their logos, color schemes, and domain configurations.

- Supports dynamic product display and filtering based on channel configurations and catalog data.
- Enables flexible layout adjustments and content management to accommodate partner-specific marketing campaigns.
- Integrates with backend APIs for real-time product, pricing, availability, and order status information.
- Ensures accessibility, responsive design, and performance optimization across devices and platforms.
- Facilitates seamless user journeys from product discovery through checkout within the partner’s branded environment.

### Administration Portal

- Provides a secure, web-based interface for brand partners and internal staff to manage all aspects of their eCommerce operations.
- Allows partners to create, update, and organize products in the catalog.
- Enables management of digital channels, including assigning and scheduling product visibility.
- Offers real-time order monitoring and detailed order history, with search and filtering options.
- Supports access to payment status, transaction details, and refund management.
- Facilitates user and role management for partner organizations, including permissions and branding settings.
- Includes dashboards and analytics for sales, inventory, and operational KPIs.
- Ensures audit trails and activity logs for compliance and transparency.
- Designed for ease of use.

---

## 4. Project Goals, Objectives, and Success Criteria

### 4.1 Goals & Objectives

- Enable multi-tenant support for telecom brand partners
- Empower partners to manage products, pricing, and campaigns
- Deliver a seamless, intuitive shopping experience
- Ensure high performance and scalability

### 4.2 Completion Criteria

- At least one brand partner migrated and using the service with whitelabel frontend
- All core features and integrations operational

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

Eesy - whom is a known brand partner that will be the first customer using the pure API capabilities of the eCommerce Service.

---

## 7. Project Milestones & Checkpoints

### 7.1 Key Milestones

| Milestone ID | Description                                                                       | Timing         |
| ------------ | --------------------------------------------------------------------------------- | -------------- |
| M1           | Requirements gathering and analysis complete                                      | August 2025    |
| M2           | Initial general technical design and architecture planning                        | September 2025 |
| M2.1         | Delivery of channel and catalog modules for digital channels and API availability | October 2025   |
| M3           | Complete technical design and architecture planning                               | November 2025  |
| M4           | Development for Open Pages Project features complete                              | December 2025  |
| M5           | eCom module version 0.5                                                           | January 2026   |
| M6           | Whitelabel frontend capabilities delivered                                        | April 2026     |
| M7           | eCom module version 1.0 (full feature set)                                        | May 2026       |

### 7.2 Timeline

- Phase 1 (August-September): Technical design including architecture for channel and catalog modules.
- Phase 2 (September–May 2025): Development & integration.

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

- **Legacy TCM system**: Required for product, pricing, and MSISDN data. Any delays in accessing this system may impact the integration timeline and overall project delivery.
- **Open Pages project**: Provides frontend capabilities for whitelabel solutions. Delays or changes in this project could affect the user interface and customer experience.
- **Customer/subscriber provisioning systems**: Essential for provisioning and managing customer subscriptions. Integration challenges or unavailability could delay the go-live timeline.
- **Partner engagement**: Timely feedback and collaboration from brand partners are critical for ensuring the solution meets their requirements.
- **Infrastructure readiness**: Availability of scalable infrastructure to support multi-tenant operations is necessary for deployment and performance.

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
- **Slack channel:** Regular status updates and immediate issue resolution and ad-hoc discussions
- **Bi-weekly meetings:** Project progress reviews with stakeholders during feature development

---

## 11. Charter Acceptance & Approvals

- **Project Sponsor:** Lars Vieland Grasberger
- **Project Manager:** Bjørn Alsted Nielsen
- **Core Project Team:** [Signatures as appropriate]

**Prepared by:** [Your Name]  
**Date:** June 20, 2025
