# Updated Software Requirements Specification (SRS)

## SAGA Telecom eCommerce Module - Whitelabel Frontend Integration

**Document Version:** 1.1  
**Date:** June 22, 2025  
**Prepared by:** Niclas Schumacher  
**Project Sponsor:** Lars Vieland Grasberger, Head of IT, Nuuday Mobile Partners  
**Project Manager:** Bjørn Alsted Nielsen, Product Owner, Nuuday Mobile Partners

---

---

## 1. Introduction

### 1.1 Purpose

This Software Requirements Specification (SRS) describes the functional and non-functional requirements for the SAGA Telecom eCommerce Module, a Tier 3 component of the broader SAGA platform. This document serves as the foundation for system design, development, testing, and validation activities, translating the high-level project charter objectives into detailed technical specifications.

### 1.2 Document Conventions

- **REQ-[MODULE]-[NUMBER]**: Functional requirement identifier format (e.g., REQ-CAT-001)
- **NFR-[NUMBER]**: Non-functional requirement identifier format (e.g., NFR-001)
- **Bold text**: Indicates critical requirements or key terms
- **Italics**: Used for emphasis on important concepts
- Priority levels: High, Medium, Low

### 1.3 Intended Audience and Reading Suggestions

This document is intended for:

- **Infrastructure & Platform Team**: Focus on sections 4-6 for detailed technical requirements
- **Project Manager (Bjørn Alsted Nielsen)**: Review all sections for comprehensive understanding
- **Brand Partners and Stakeholders**: Focus on sections 2-4 for business functionality understanding
- **Testing Team**: Concentrate on sections 4-6 for test case development [2]

### 1.4 Project Scope

The SAGA Telecom eCommerce Module will modernize the telecom eCommerce platform by enabling a whitelabel, multi-tenant solution that supports multiple brand partners with distinct configurations and branding, replacing the legacy TCM system. The system will support both API consumers and whitelabel customers while maintaining seamless integration with existing SAGA platform components, including comprehensive frontend capabilities for brand partner customization.

### 1.5 References

- Project Charter: SAGA Telecom eCommerce Module
- SAGA Platform Architecture Documentation

---

## 2. Overall Description

### 2.1 Product Perspective

The SAGA Telecom eCommerce Module operates as a Tier 3 component within the SAGA platform architecture. It interfaces with multiple systems including the legacy TCM system (Via Product Service) for product data and MSISDN availability, SAGA Tier 2 core services for centralized platform functionality, downstream provisioning systems for subscription activation, payment gateways for transaction processing, and the Open Pages project for frontend product visualization capabilities.

### 2.2 Product Functions

The system provides comprehensive eCommerce functionality including multi-tenant management with complete isolation of brand partner data and configurations, product catalog management for creating telecom product offerings, digital channel management for configuring product visibility, order processing with end-to-end lifecycle management, payment processing with secure handling of (potential) multiple payment methods, number management for telephone number inventory, administration through a comprehensive partner management interface, and whitelabel frontend capabilities enabling brand partners to customize storefront branding, layout, and product presentation.

### 2.3 User Classes and Characteristics

**Brand Partner Administrators** (e.g., Katrine Grøn Iversen, Katrine Blicher Christensen) manage product catalogs and pricing for their brands, configure channel visibility and promotional campaigns, customize whitelabel storefronts, and monitor order status with medium technical expertise and daily usage frequency. **API Consumers** integrate telecom products into their applications, access product catalogs programmatically, require high technical expertise, and use the system continuously. **End Customers** browse and purchase telecom products through whitelabel storefronts, manage orders and account information, have low to medium technical expertise, and use the system occasionally. **System Administrators** manage tenant onboarding and system configuration, monitor performance, resolve issues, require high technical expertise, and use the system daily.

### 2.4 Operating Environment

The system operates on a C#/.NET modular monolith architecture with multi-tenant database architecture ensuring tenant isolation. It deploys on scalable cloud infrastructure supporting multiple availability zones, uses REST APIs and message queues for integration protocols, and implements OAuth 2.0, role-based access control, and data encryption for security.

### 2.5 Design and Implementation Constraints

The system must maintain compatibility with legacy TCM system interfaces via Product Service, requires strict tenant data isolation for compliance and security, must support horizontal scaling for growth accommodation, has integration dependencies on Open Pages project timeline, must comply with telecom industry regulations and data privacy standards, and must ensure responsive design across web and mobile platforms for whitelabel storefronts.

### 2.6 Assumptions and Dependencies

**Assumptions** include that the legacy TCM system will remain available for data retrieval during transition, brand partners will provide necessary branding assets and configuration requirements, Infrastructure & Platform team resources will be consistently available, payment gateway integrations will meet industry security standards, and brand partners will actively engage in frontend customization processes. **Dependencies** include the legacy TCM system via Product Service for product and MSISDN data availability, Open Pages project for frontend whitelabel capabilities, downstream provisioning systems for subscription activation, and SAGA Tier 2 core services for platform-wide functionality.

---

## 3. External Interface Requirements

### 3.1 User Interfaces

**Administration Portal** provides a web-based responsive interface supporting desktop and tablet access, role-based dashboards with customizable widgets, real-time data updates and notifications, and comprehensive frontend customization tools allowing brand partners to configure logos, color schemes, domain settings, and layout preferences. **Whitelabel Customer Storefronts** offer fully customizable, responsive web interfaces that reflect each brand partner's visual identity, support dynamic product display based on channel configurations, enable seamless customer journeys from product discovery through checkout, and ensure accessibility compliance across devices and platforms. **API Interfaces** offer RESTful API endpoints with comprehensive documentation, OAuth 2.0 authentication, standardized error responses and status codes, API versioning support for backward compatibility, and frontend configuration APIs for programmatic customization.

### 3.2 Hardware Interfaces

The system is compatible with standard cloud computing platforms, supports high-availability load balancing configurations, uses multi-tenant database deployment with backup systems, integrates with infrastructure monitoring tools including CCCoE maintained Grafana visualization, and supports content delivery networks (CDNs) for optimal frontend performance across geographic regions.

### 3.3 Software Interfaces

**Legacy TCM System Integration** is proxied by SAGA Product Service which secures REST API for needed data availability, system-to-system authentication tokens, and functions for product data retrieval, pricing information, and MSISDN availability. **Payment Gateway Integration** uses REST APIs with webhook support, PCI DSS compliant communication, supports credit cards and digital wallets, with functions for authorization, capture, refund, and recurring payments. **SAGA Tier 2 Integration** uses internal API calls and message queues with JSON over HTTPS, internal service authentication, and functions for user management, audit logging, and system configuration [1]. **Content Management Integration** supports dynamic content updates, branding asset management, and real-time configuration changes for whitelabel storefronts.

### 3.4 Communication Interfaces

All external communications are encrypted with HTTPS and TLS 1.3, message queues handle asynchronous processing for order fulfillment, webhooks provide real-time notifications for payment and order status updates, email/SMS deliver customer notifications and administrative alerts, and real-time APIs support dynamic frontend updates and configuration changes.

---

## 4. System Features by Module

### 4.1 Catalog Module

#### 4.1.1 Product Item Management

**REQ-CAT-001: Multi-Tenant Product Creation**  
The system shall allow brand partners to create product items that reference legacy subscription IDs while maintaining complete tenant isolation. Each product item shall include campaign metadata, binding period information, tenant-specific pricing, and information from the underlying subscription including available datacards with amount limits, available SIM types, and available modules with pricing as defined in the legacy system.

**REQ-CAT-002: Product Variant Support**  
The system shall support multiple product variants for the same legacy subscription ID, allowing different campaigns, binding periods, and pricing structures for the same underlying telecom service [1].

**REQ-CAT-003: Legacy System Integration**  
The system shall retrieve product details, pricing information, and availability data from the legacy TCM system using only the subscription ID as a reference [2].

#### 4.1.2 Data Management

**REQ-CAT-004: Tenant Data Isolation**  
The system shall ensure complete data isolation between tenants using schema or row-level isolation patterns, preventing any cross-tenant data access or visibility [1].

**REQ-CAT-005: Catalog API Operations**  
The system shall provide RESTful APIs for catalog CRUD operations, supporting bulk operations and advanced filtering capabilities [2].

### 4.2 Channel Module

#### 4.2.1 Channel Configuration

**REQ-CHN-001: Digital Channel Creation**  
The system shall allow creation and configuration of digital sales channels representing different customer touchpoints including web front pages, subpages, mobile apps, and ecare upsale pages [1].

**REQ-CHN-002: Product-Channel Association**  
The system shall support many-to-many associations between catalog items and channels using a dedicated association table with visible_from and visible_to time-range fields for scheduling item exposure [2].

**REQ-CHN-003: Time-Based Visibility**  
The system shall implement time-based visibility rules using configurable timestamps for each product-channel association, allowing products to be automatically shown or hidden based on current time [1].

#### 4.2.2 Channel Operations

**REQ-CHN-004: Active Product Queries**  
The system shall provide APIs to query active catalog items for specific channels, filtering by current timestamp and channel context [2].

**REQ-CHN-005: Channel Management APIs**  
The system shall support complete channel lifecycle management through RESTful APIs [1].

### 4.3 Basket Module

#### 4.3.1 Basket Management

**REQ-BAS-001: Product Addition and Modification**  
The system shall facilitate the addition, removal, and modification of products in a customer's basket, tracking product quantities, pricing, and applicable discounts or promotions in real-time [1].

**REQ-BAS-002: Multi-Tenant Configuration Support**  
The system shall support multi-tenant configurations ensuring tenant-specific rules for basket behavior, such as maximum item limits or promotional eligibility [2].

**REQ-BAS-003: Subscription Product Handling**  
The system shall handle subscription products by treating each added quantity as a separate line item in the basket, ensuring unique tracking and management for each subscription instance [1].

#### 4.3.2 Basket Persistence and Integration

**REQ-BAS-004: Session Persistence**  
The system shall ensure basket persistence across sessions, allowing customers to resume shopping without losing their selections [2].

**REQ-BAS-005: Order Module Integration**  
The system shall integrate seamlessly with the Order Module to transition basket contents into orders [1].

### 4.4 Number Management Module

#### 4.4.1 Number Inventory Management

**REQ-NUM-001: Number Pool Management**  
The system shall manage telephone number inventory including number pools and ranges per brand partner, ensuring only available numbers are offered during order processing [1].

**REQ-NUM-002: Real-time Availability**  
The system shall provide real-time number availability checking and reservation capabilities during order processing [2].

**REQ-NUM-003: Number Lifecycle Tracking**  
The system shall track number statuses including available, reserved, assigned, and ported states with comprehensive audit trails for all number transactions [1].

#### 4.4.2 Number Portability Support

**REQ-NUM-004: Port-in Process Support**  
The system shall support mobile number portability (MNP) processes including validation, authorization, and status tracking [2].

**REQ-NUM-005: Regulatory Compliance**  
The system shall ensure compliance with national numbering regulations and reporting requirements [1].

### 4.5 Order Module

#### 4.5.1 Order Orchestration

**REQ-ORD-001: Order Creation and Validation**  
The system shall orchestrate the complete order lifecycle, coordinating interactions between catalog validation, number management, payment processing, and provisioning systems [1].

**REQ-ORD-002: Order Status Tracking**  
The system shall track order status from initiation through fulfillment, including intermediate states for validation, payment, and provisioning with real-time status updates and notifications [2].

**REQ-ORD-003: Order Modification Support**  
The system shall support order modifications, cancellations, and returns according to business rules and order lifecycle state [1].

#### 4.5.2 Integration Coordination

**REQ-ORD-004: Payment Integration**  
The system shall activate payment processing through the Payment Module after order validation and coordinate with payment status updates [2].

**REQ-ORD-005: Number Assignment Coordination**  
The system shall coordinate with the Number Management Module for telephone number allocation during order processing [1].

### 4.6 Payment Module

#### 4.6.1 Payment Processing

**REQ-PAY-001: Multiple Payment Methods**  
The system shall support multiple payment methods including credit cards, digital wallets, and bank transfers with appropriate gateway integrations [1].

**REQ-PAY-002: PCI DSS Compliance**  
The system shall implement PCI DSS compliant payment processing with secure handling of sensitive payment information using encryption and secure transmission protocols [2].

**REQ-PAY-003: Transaction Lifecycle Management**  
The system shall manage payment authorization, capture, settlement, and refunds in coordination with the Order Module [1].

#### 4.6.2 Payment Status and Reporting

**REQ-PAY-004: Real-time Status Updates**  
The system shall provide real-time payment status updates to the Order Module and trigger order progression based on successful payment events [2].

**REQ-PAY-005: Transaction Logging**  
The system shall maintain comprehensive transaction logs for reconciliation, reporting, and audit purposes ensuring financial transparency [1].

### 4.7 Administration Portal

#### 4.7.1 Multi-Tenant Administration

**REQ-ADM-001: Comprehensive Management Interface**  
The system shall provide a secure, web-based interface for brand partners and internal staff to manage all aspects of their eCommerce operations [1].

**REQ-ADM-002: Product and Channel Management**  
The system shall allow partners to create, update, and organize products in catalogs and manage digital channel configurations [2].

**REQ-ADM-003: Order and Payment Monitoring**  
The system shall provide real-time order monitoring with detailed order history, search and filtering options, and access to payment status and transaction details [1].

#### 4.7.2 User and Analytics

**REQ-ADM-004: User and Role Management**  
The system shall support user and role management for partner organizations with configurable permissions, access controls, and branding settings [2].

**REQ-ADM-005: Analytics and Reporting**  
The system shall include dashboards and analytics for sales, inventory, and operational KPIs with audit trails and activity logs for compliance and transparency [1].

### 4.8 Whitelabel Frontend Module

#### 4.8.1 Branding and Customization

**REQ-WHL-001: Brand Identity Configuration**  
The system shall provide customizable storefront templates allowing brand partners to apply their logos, color schemes, typography, and domain configurations through a self-service administration interface [1].

**REQ-WHL-002: Layout Customization**  
The system shall enable flexible layout adjustments and content management to accommodate partner-specific marketing campaigns, promotional banners, and featured product sections [2].

**REQ-WHL-003: Multi-Domain Support**  
The system shall support custom domain configuration for each brand partner, enabling complete white-label branding with partner-owned URLs and SSL certificate management [1].

#### 4.8.2 Product Display and Navigation

**REQ-WHL-004: Dynamic Product Presentation**  
The system shall support dynamic product display and filtering based on channel configurations and catalog data, with real-time updates reflecting product availability and pricing changes [2].

**REQ-WHL-005: Responsive Design Implementation**  
The system shall ensure accessibility, responsive design, and performance optimization across devices and platforms including desktop, tablet, and mobile interfaces [1].

**REQ-WHL-006: Search and Navigation**  
The system shall provide intuitive search functionality, product categorization, and navigation features that can be customized per brand partner's product organization preferences [2].

#### 4.8.3 Customer Experience Features

**REQ-WHL-007: Seamless User Journey**  
The system shall facilitate seamless user journeys from product discovery through checkout within the partner's branded environment, maintaining consistent branding throughout the entire customer experience [1].

**REQ-WHL-008: Real-time Integration**  
The system shall integrate with backend APIs for real-time product, pricing, availability, and order status information, ensuring customers always see current data [2].

**REQ-WHL-009: Checkout Process Customization**  
The system shall support customizable checkout processes that maintain brand consistency while integrating with the Order and Payment modules for transaction processing [1].

#### 4.8.4 Performance and Accessibility

**REQ-WHL-010: Performance Optimization**  
The system shall implement performance optimization techniques including lazy loading, content caching, and CDN integration to ensure fast loading times across all customer touchpoints [2].

**REQ-WHL-011: Accessibility Compliance**  
The system shall comply with web accessibility standards (WCAG 2.1 AA) to ensure inclusive access for users with disabilities across all whitelabel storefronts [1].

**REQ-WHL-012: Cross-Browser Compatibility**  
The system shall ensure consistent functionality and appearance across major web browsers and mobile platforms [2].

---

## 5. Non-Functional Requirements

### 5.1 Performance Requirements

**NFR-001: API Response Time**  
The system shall maintain API response times under 500ms for 95% of requests under normal load conditions [1].

**NFR-002: Concurrent User Support**  
The system shall support a minimum of 10,000 concurrent users across all tenants without performance degradation [2].

**NFR-003: Transaction Throughput**  
The system shall process a minimum of 1,000 orders per hour during peak operation periods [1].

**NFR-004: Frontend Performance**  
The whitelabel storefronts shall achieve page load times under 3 seconds for initial page loads and under 1 second for subsequent navigation on standard broadband connections [2].

### 5.2 Security Requirements

**NFR-005: Tenant Data Isolation**  
The system shall implement complete tenant data isolation at the database level using schema or row-level security patterns, preventing any cross-tenant data access [1].

**NFR-006: Authentication and Authorization**  
The system shall implement OAuth 2.0 authentication with role-based access control for all user interfaces and APIs [2].

**NFR-007: Data Encryption**  
The system shall encrypt all sensitive data at rest and in transit using industry-standard encryption protocols [1].

### 5.3 Scalability and Reliability Requirements

**NFR-008: Tenant Scaling**  
The system shall support a minimum of 50 active tenants with horizontal scaling capabilities [2].

**NFR-009: System Availability**  
The system shall maintain 99.9% availability excluding planned maintenance windows with comprehensive error handling and graceful degradation [1].

**NFR-010: Backup and Recovery**  
The system shall support automated backup and disaster recovery with Recovery Time Objective (RTO) of 4 hours [2].

---

## 6. Data Requirements

### 6.1 Multi-Tenant Data Architecture

The system shall implement a multi-tenant data model ensuring complete isolation between tenants using either schema-based or row-level security patterns [1]. Each tenant entity includes tenant_id, name, configuration, branding_settings, and created_date fields [2].

### 6.2 Core Data Models

**Catalog Data Model** includes Product_Item with item_id, tenant_id, legacy_subscription_id, name, description, and created_date; Campaign with campaign_id, tenant_id, name, discount_percent, start_date, and end_date; and Binding_Period with binding_id, tenant_id, duration_months, and penalty_amount [1].

**Channel Data Model** includes Channel with channel_id, tenant_id, name, type, configuration, and created_date; and Channel_Item_Assignment with channel_id, item_id, visible_from, visible_to, and priority [2].

**Order Data Model** includes Order with order_id, tenant_id, customer_id, status, total_amount, and created_date; Order_Item with order_item_id, order_id, product_item_id, quantity, and unit_price; and Order_Status_History with status_id, order_id, status, timestamp, and notes [1].

**Number Management Data Model** includes Number_Pool with pool_id, tenant_id, range_start, range_end, and status; and Number_Assignment with assignment_id, number, tenant_id, customer_id, status, and assigned_date [2].

**Whitelabel Frontend Data Model** includes Brand_Configuration with tenant_id, logo_url, primary_color, secondary_color, custom_css, domain_configuration, and last_updated; Theme_Template with template_id, tenant_id, layout_configuration, component_settings, and creation_date [1].

---

## 7. Questions for Further Clarification

### 1. Multi-Tenancy Architecture Details

- Should each tenant have a separate database schema, or should we implement row-level security in a shared database? What are the specific compliance requirements that might influence this decision [1]?
- What level of customization should tenants have over their data models and business rules?

### 2. Legacy TCM System Integration

- What is the exact API specification for the legacy TCM system? Are there rate limits, availability windows, or specific authentication mechanisms we need to consider [2]?
- How should the system handle legacy system unavailability or degraded performance?

### 3. Number Management Specifications

- What are the specific regulatory requirements for number management in your operating regions? Do we need to support number portability between different operators [1]?
- How should number reservation timeouts be handled, and what are the business rules for number release?

### 4. Payment Processing Requirements

- What specific payment methods are required for launch? Are there regional payment preferences or regulatory requirements we should prioritize [2]?
- Should the system support recurring billing or subscription-based payment models?

### 5. Performance and Scaling Expectations

- What are the expected peak load scenarios? How many orders per tenant per hour should we design for?
- Are there specific geographic regions or markets that require special performance considerations?

### 6. Security and Compliance

- Are there specific telecom industry compliance requirements beyond PCI DSS that we need to address [1]?
- What are the data retention and audit requirements for different types of transactions and user activities?

### 7. API Consumer Integration

- What level of API customization should be available to different API consumers? Should there be different API tiers or access levels [2]?
- How should API versioning and backward compatibility be managed for existing integrations?

### 8. Administration Portal Features

- What specific analytics, reporting, and dashboard requirements do brand partners have? Should we integrate with existing business intelligence platforms [1]?
- What level of self-service configuration should be available to brand partners versus requiring administrator intervention?

### 9. Basket and Order Workflow

- Are there specific business rules for basket expiration, item reservation, or inventory allocation that need to be implemented [2]?
- How should the system handle complex order scenarios like partial fulfillment or backordered items?

### 10. International and Localization Requirements

- What languages, currencies, and regional variations need to be supported for the initial launch and future expansion [1]?
- Are there specific regulatory or business requirements for different markets or regions?

### 11. Whitelabel Frontend Customization

- What level of CSS and JavaScript customization should be allowed for brand partners? Should there be restrictions for security or performance reasons [2]?
- How should theme updates and version control be managed when partners have made customizations?

### 12. Frontend Performance and SEO

- Are there specific SEO requirements for whitelabel storefronts? Should the system support server-side rendering or other SEO optimization techniques [1]?
- What analytics and tracking capabilities should be built into the whitelabel storefronts for brand partners to monitor customer behavior?

---

**References**

[1] Project Charter: SAGA Telecom eCommerce Module  
[2] SAGA Platform Architecture Documentation

[1] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/52483632/b0e3c636-7e8a-4a58-87fa-e8fa5c8b9209/project-charter.md
[2] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/52483632/b958c91d-5664-459a-b428-9ae6c9b99aa0/ecom-srs.md
