# E-Commerce Module Project Documentation – Whitelabel Telecom

## Overview

The e-commerce module is a critical component in the transformation of the telecom platform from a legacy, single-tenant system to a scalable, whitelabel solution. The current system operates as separate website instances built on a legacy platform (TCM), which is slated for replacement. The objective is to decouple the e-commerce functionality from TCM, enabling its use as a flexible, multi-tenant module within a future-proof, whitelabel telecom system.

This module will be the last of three major pillars to migrate to the new architecture. It is designed to support multiple telecom brand partners, each with unique branding and configurations, all while sharing a common codebase. The module must handle diverse product offerings and pricing strategies, ensuring flexibility, scalability, and operational efficiency across the telecom e-commerce landscape.

## Vision & Objectives

### Vision

- **Purpose:** Transform the e-commerce experience for both telecom customers and brand partners by providing a seamless, intuitive, and personalized shopping journey across all digital channels.
- **Business Transformation:** Centralize and streamline product management, pricing, and promotions for brand partners, enabling rapid adaptation to market changes and customer needs.
- **Long-Term Impact:** Expand market reach by supporting multiple tenants, reduce time-to-market for new brands and products, and enhance operational efficiency through shared, reusable components.
- **Strategic Alignment:** Empower brand partners to manage their offerings independently via self-service tools, aligning with the company’s mission to improve efficiency and accelerate product launches.

### Objectives

- Enable multi-tenant support with distinct branding and configurations for each brand partner.
- Allow flexible management of product offerings and pricing strategies across tenants.
- Design the module as a modular monolith for seamless integration and scalability.
- Ensure high performance and reliability to support significant transaction volumes.
- Centralize product management, enabling rapid response to market and customer demands.

### Users & Needs

- **Primary Users:** Telecom brand partners and their end customers.
  - **Brand Partners:** Require self-service capabilities for managing products, pricing, and campaigns without IT involvement, primarily via the CMS (e.g., Contentful) and the e-commerce module.
  - **Customers:** Expect a seamless, intuitive shopping experience with personalized offerings across channels.

### Business Problems & Opportunities

- Modernize the e-commerce platform to address the rigidity and scalability issues of the legacy TCM system.
- Enable faster onboarding of new brands and products.
- Enhance customer experience through personalization and streamlined operations.
- Improve scalability and agility in managing multiple brands.

### Success Criteria

- **KPIs & Metrics:**
  - System performance (response time, uptime, transaction volume).
  - Proactive monitoring and alerting for error rates and system health.
  - Positive feedback from customers and brand partners.
  - Successful onboarding of pilot and subsequent brand partners.
- **Compliance:**
  - Adherence to telecom regulations, data protection (e.g., GDPR), payment standards (e.g., PCI DSS), and accessibility requirements.

## Scope

- **In Scope:**

  - Development of a multi-tenant e-commerce module with support for distinct branding and configurations.
  - Centralized product management for brand partners.
  - Integration with existing services such as Contentful CMS.
  - High-performance, modular architecture supporting high traffic and transaction volumes.
  - Compliance with relevant regulatory and industry standards.

- **Out of Scope:**

  - Technical implementation details and low-level design.
  - Migration of other pillars outside the e-commerce module.
  - Custom development for individual brand partners beyond configuration and branding.

- **Must-Have Features for Launch:**

  - Multi-tenant support
  - Centralized product management
  - Seamless CMS integration
  - High-performance architecture

- **Nice-to-Have Enhancements:**
  - Advanced analytics and reporting
  - Enhanced personalization features
  - Additional third-party integrations (e.g., CRM, marketing automation)

## Stakeholders

### Primary Stakeholders

#### Brand Partners

Telecom companies and partners who will operate their own branded storefronts using the e-commerce module.
Needs: Self-service management, brand differentiation, rapid product and pricing updates.

#### End Customers

Consumers purchasing telecom products and services through the e-commerce platform.
Needs: Seamless, intuitive, and reliable shopping experience across all channels.

### Internal Stakeholders

#### Product Management

Responsible for defining requirements, prioritizing features, and ensuring alignment with business goals.

#### Engineering & Development Teams

Charged with designing, building, and maintaining the e-commerce module.

## high-level architecture

The e-commerce module is architected to provide robust, flexible support for telecom subscription products across multiple digital channels, while ensuring operational efficiency, regulatory compliance, and a seamless user experience for both brand partners and end customers.

### Core Services and Responsibilities

#### Basket Service

- Manages the user’s shopping basket, supporting complex subscription configurations (e.g., campaign pricing, binding periods, SIM type selection).
- Validates product eligibility, binding period acceptance, and campaign rules before checkout.
- Ensures only compatible options (e.g., data sharing cards) are selectable based on product and channel context.
- Integrates with the Number Management Service to reserve (lock) a phone number (MSISDN) for a given period during the shopping session, reducing allocation conflicts.

#### Catalog Service

- Acts as the central source of truth for all product definitions and configuration rules.
- Maintains channel-specific product display names, visibility settings, and eligibility for features (such as SIM types or add-ons).
- Supports “Shift Left” by allowing brand partners to define how products should appear and behave in different channels during product setup.

#### Promotion Engine

- Applies dynamic, time-bound campaign pricing and manages channel-specific price modifications.
- Ensures correct pricing precedence when multiple campaigns or promotions overlap.
- Validates promotion compatibility with binding periods and product eligibility rules.

#### OrderService

- Handles order finalization, payment processing, and orchestration of downstream fulfillment steps.
- Triggers downstream systems for all provisioning and activation after successful payment and compliance checks (e.g., CPR validation via MitID).

#### Number Management Service

- Provides real-time access to available phone numbers (MSISDNs) for new subscriptions.
- Allows the Basket Service to lock (reserve) a selected number for a defined period, ensuring it cannot be allocated to another customer during the active basket session.
- Automatically releases the lock if the basket is abandoned or the reservation expires.
- Does not handle fulfillment, provisioning, or activation—these are managed by downstream telecom systems post-order.

#### Identity & Authentication Service

- Provides secure user authentication and session management, including MitID integration for CPR verification.
- Supports both guest and authenticated user journeys, allowing seamless migration of basket contents upon login.

### Channel Management and Product Visibility

- Channel-specific product visibility and display logic are governed by the Catalog Service in close coordination with a Channel Management Service.
- Brand partners can configure which products are shown in which channels (e.g., front page, subpages, app, outbound sales system) and define channel-specific naming and pricing.
- The Channel Management Service applies these rules in real time, ensuring that each user sees the correct products, names, and offers based on their entry point and context.
- This approach enables differentiated experiences and targeted promotions across digital touchpoints, supporting both operational agility and marketing effectiveness.

### Service Interaction Overview

```
[Frontend]
  → (Channel Context) → [Channel Management Service]
  → (Product Config) → [Catalog Service]
  → (Add to Basket) → [Basket Service]
      ↔ (Lock/Release Number) ↔ [Number Management Service]
  → (Checkout) → [OrderService]
  → (Provisioning) → [Downstream Telecom Systems]
```

### Rationale

- Separating number management (locking and retrieval) into its own service ensures the e-commerce module can reliably support number selection and reservation, while all fulfillment and provisioning remain out of scope and are handled by downstream systems.
- Centralizing product and channel management enables brand partners to quickly adapt offerings and campaigns without IT intervention, supporting the project’s “Shift Left” vision.
- The architecture is designed for extensibility, allowing new channels, product types, or campaign mechanisms to be added with minimal disruption.
