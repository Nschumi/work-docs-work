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

### 4.3 Engineering Success Metrics

#### 4.3.1 Technical Performance Metrics
- **API Response Times**: 95% of API calls complete within 500ms under normal load
- **System Uptime**: 99.9% availability excluding planned maintenance windows
- **Database Performance**: Catalog queries return results within 200ms for 95% of requests
- **Frontend Performance**: Page load times under 3 seconds for initial load, under 1 second for navigation
- **Transaction Processing**: Payment authorization within 2 seconds, order processing within 10 seconds

#### 4.3.2 Quality & Reliability Metrics
- **Test Coverage**: Maintain minimum 80% unit test coverage for business logic, measured via automated tooling in CI/CD pipeline with coverage reports generated on each build
- **Code Review**: 100% of code changes reviewed before merge to main branch
- **Deployment Success Rate**: 95% successful deployments without rollback, measured as deployments that complete successfully and remain stable for 24 hours post-deployment
- **Production Incidents**: Less than 2 critical production incidents per month, where critical incidents are defined as system outages or data corruption affecting multiple tenants
- **Security Compliance**: Zero critical security vulnerabilities in production code

#### 4.3.3 Development Productivity Metrics
- **Developer Onboarding**: New developers productive within 5 business days
- **Feature Delivery Throughput**: Consistent feature delivery with average cycle time under 2 weeks for standard features, measured from development start to production deployment
- **Lead Time**: From feature request to production deployment within 2 weeks for small features
- **Documentation Coverage**: 100% of APIs documented with interactive examples
- **Code Quality Maintenance**: Address technical debt items within 1 sprint of identification, tracked via dedicated technical debt backlog items and resolution time metrics

#### 4.3.4 Business Impact Metrics
- **Tenant Onboarding Time**: Reduce from months to 2-3 weeks (target: 75% reduction)
- **Partner Feedback**: Collect and track partner feedback through regular check-ins and support interactions, with goal of proactive issue identification and resolution
- **Support Ticket Reduction**: 60% decrease in support tickets compared to legacy system
- **Order Processing Efficiency**: Process 1000+ orders per hour during peak periods
- **Multi-tenant Scalability**: Successfully support 20+ active tenants simultaneously

#### 4.3.5 Operational Excellence Metrics
- **Incident Response**: Mean Time to Recovery (MTTR) under 2 hours for critical issues
- **Monitoring Coverage**: 100% of critical system components monitored with alerting
- **Backup and Recovery**: RTO of 4 hours, RPO of 1 hour for critical data
- **Capacity Planning**: System performance maintained during 2x expected peak load
- **Change Management**: 100% of production changes follow approved change control process

#### 4.3.6 Partner and Customer Success Metrics
- **Partner Adoption Rate**: 80% of targeted brand partners migrated within 6 months
- **User Experience**: Task completion rate above 90% for common workflows
- **API Usage**: External API consumers achieve their integration goals within planned timeframes
- **White-label Effectiveness**: Partners can customize and deploy branded storefronts within 1 week
- **Revenue Impact**: Platform enables 15% increase in partner revenue within first year

#### 4.3.7 Measurement and Monitoring Strategy
- **Proactive Issue Detection**: Implement comprehensive monitoring and alerting to identify and resolve issues before they impact business operations
- **Automated Metrics Collection**: All metrics captured automatically through system monitoring, avoiding manual reporting overhead
- **Monthly Review Cadence**: Metrics reviewed monthly with stakeholders to ensure alignment and identify improvement opportunities
- **Actionable Insights**: Focus on metrics that can be measured, verified, and acted upon by the engineering team

---

## 5. Resource Planning & Business Case

### 5.1 Team Structure & Skill Requirements

#### 5.1.1 Core Development Team
- **Team Size**: 6-8 developers including technical lead
- **Backend Developers**: 3-4 developers with .NET 9, C#, and SQL Server expertise
- **Frontend Developers**: 2 developers with SvelteKit, TypeScript, and Contentful CMS experience
- **DevOps Engineer**: 1 developer with Kubernetes, GitHub Actions, and Azure infrastructure experience
- **Technical Lead/Architect**: 1 senior developer with telecom domain knowledge and system integration experience

#### 5.1.2 Specialized Skills Required
- **Legacy Integration**: Experience with SOAP webservices and XML data transformation
- **Multi-tenant Architecture**: Database design and tenant isolation patterns
- **Telecom Domain**: Understanding of MSISDN management, SIM card logistics, and subscription billing
- **Security Compliance**: Knowledge of PCI DSS, GDPR, and telecom regulatory requirements
- **Performance Optimization**: Experience with high-throughput eCommerce platforms

#### 5.1.3 Support Roles
- **Product Owner**: Bjørn Alsted Nielsen (existing)
- **QA Engineer**: 1 tester with automation and multi-tenant testing expertise
- **UX/UI Designer**: 1 designer for whitelabel frontend customization capabilities
- **Business Analyst**: Part-time role for requirements gathering and partner coordination

### 5.2 Development Environment & Tooling

#### 5.2.1 Development Infrastructure
- **Local Development**: Docker Desktop licenses and .NET Aspire tooling
- **CI/CD Pipeline**: GitHub Actions (included in existing GitHub subscription)
- **Code Repository**: GitHub Enterprise (existing organizational license)
- **Development Databases**: Local SQL Server instances and containerized services

#### 5.2.2 Testing & Quality Assurance
- **Automated Testing**: Unit testing frameworks, integration test environments
- **Performance Testing**: Load testing tools for multi-tenant scalability validation
- **Security Testing**: Vulnerability scanning and penetration testing tools
- **Browser Testing**: Cross-browser compatibility testing services

### 5.3 Cost-Benefit Analysis

#### 5.3.1 Project Investment Approach
- **Development Phases**: Multi-phase development approach over 11-month cycle
- **Resource Allocation**: Team scaling from 6 to 8 developers across phases
- **Infrastructure Scaling**: Cloud infrastructure costs scaling with tenant growth

#### 5.3.2 Expected Benefits
- **Operational Efficiency**: Significant reduction in tenant onboarding time and costs
- **Revenue Growth**: Platform enables partner revenue growth through improved capabilities
- **Support Cost Reduction**: Substantial decrease in support ticket volume through improved system design
- **Scalability Value**: Platform supports multiple tenants with shared operational overhead

#### 5.3.3 Value Realization
- **Tenant Onboarding**: Reduction from months to 2-3 weeks creates immediate value
- **Platform Capabilities**: Foundation for future eCommerce innovation and expansion
- **Operational Savings**: Automated processes and improved system reliability reduce ongoing costs
- **Strategic Value**: Modern platform enables competitive advantage and market expansion

### 5.4 Risk Mitigation & Contingency

#### 5.4.1 Project Risk Management
- **Development Scope**: Contingency planning for scope changes and requirements evolution
- **Infrastructure Scaling**: Flexible infrastructure approach to accommodate unexpected load requirements
- **Integration Complexity**: Buffer planning for legacy system integration challenges and technical complexity

#### 5.4.2 Resource Risk Mitigation
- **Key Personnel**: Cross-training and documentation to reduce single points of failure
- **Vendor Dependencies**: Alternative vendor evaluation for critical services
- **Skill Gaps**: Training budget and external consultancy for specialized requirements

---

## 7. Technical Architecture & Constraints

### 7.1 Technology Stack Decisions

#### 6.1.1 Backend Architecture
- **Framework**: .NET 9 with C# - chosen for enterprise-grade scalability, strong typing, and existing organizational expertise
- **Architecture Pattern**: Modular Monolith - balances development simplicity with service separation, avoiding microservices complexity while maintaining modularity
- **Orchestration**: .NET Aspire - provides unified debugging, service discovery, and configuration management
- **Database**: Multi-tenant SQL Server with tenant isolation via TenantId filtering
- **API Design**: RESTful APIs with OpenAPI/Swagger documentation, following REST maturity level 2

#### 6.1.2 Frontend Architecture
- **Framework**: SvelteKit - chosen for performance, developer experience, and excellent white-labeling capabilities
- **Content Management**: Contentful CMS integration for dynamic content and marketing campaigns
- **Styling**: CSS-in-JS with tenant-specific theming support
- **State Management**: Stores pattern with reactive updates

#### 6.1.3 Infrastructure & Deployment
- **Container Platform**: Kubernetes with nginx ingress for scalability and load balancing
- **Cloud Provider**: Azure (aligned with organizational standards)
- **CI/CD**: GitHub Actions with automated deployment pipelines
- **Monitoring**: Grafana and Prometheus for monitoring and observability

### 7.2 Performance Requirements & SLA Targets

#### 6.2.1 Response Time Requirements
- **API Endpoints**: < 500ms for 95% of requests under normal load
- **Database Queries**: < 200ms for catalog and product lookups
- **Frontend Pages**: < 3 seconds initial load, < 1 second subsequent navigation
- **Payment Processing**: < 2 seconds for authorization, < 10 seconds for capture

#### 6.2.2 Scalability Targets
- **Concurrent Users**: Support 1,000+ concurrent users across all tenants
- **Transaction Volume**: Process minimum 1,000 orders per hour during peak periods
- **Tenant Scaling**: Support 20+ active tenants with horizontal scaling capability
- **Database Performance**: Handle 10,000+ catalog items per tenant without degradation

#### 6.2.3 Availability & Reliability
- **System Uptime**: 99.9% availability excluding planned maintenance
- **Recovery Time Objective (RTO)**: 4 hours for critical system restoration
- **Recovery Point Objective (RPO)**: 1 hour maximum data loss tolerance
- **Error Handling**: Graceful degradation with comprehensive error logging

### 7.3 Security & Compliance Requirements

#### 6.3.1 Data Protection
- **Tenant Isolation**: Data separation using TenantId filtering in queries
- **Data Encryption**: AES-256 encryption at rest, TLS 1.3 for data in transit
- **Personal Data**: GDPR compliance with data anonymization and deletion capabilities
- **Audit Logging**: Comprehensive audit trails for all tenant data access and modifications

#### 6.3.2 Authentication & Authorization
- **Authentication**: OAuth 2.0 with self-hosted Duende Identity Server
- **Authorization**: Role-based access control (RBAC) with tenant-specific permissions
- **API Security**: JWT tokens with proper expiration and refresh mechanisms
- **Payment Security**: PCI DSS compliance for payment data handling

#### 6.3.3 Regulatory Compliance
- **Telecom Regulations**: Compliance with national numbering regulations
- **Data Privacy**: GDPR and national data protection requirements
- **Financial Compliance**: PCI DSS for payment processing
- **Industry Standards**: SOC 2 Type II compliance for service delivery

### 7.4 Integration Architecture

#### 6.4.1 Legacy System Integration
- **TCM System**: SOAP-based webservice integration with custom adapter for XML schema conversion
- **Product Service**: Proxy layer for product data with caching strategies
- **Provisioning Systems**: Asynchronous integration with message queues
- **Error Handling**: Retry mechanisms with exponential backoff

#### 6.4.2 External Service Integration
- **Payment Gateways**: Currently OnPay, with future support for tenant-specific payment providers
- **Content Delivery**: CDN integration for static assets and images
- **Email/SMS**: Notification services with template management
- **Analytics**: Integration with business intelligence tools

#### 6.4.3 API Design Standards
- **Versioning**: Semantic versioning with backward compatibility
- **Documentation**: OpenAPI 3.0 with interactive documentation
- **Rate Limiting**: Tenant-aware rate limiting with proper error responses
- **Monitoring**: Distributed tracing with correlation IDs

### 7.5 Development Standards & Quality Gates

#### 6.5.1 Code Quality Requirements
- **Test Coverage**: Minimum 80% unit test coverage for business logic
- **Code Review**: Mandatory peer review for all code changes
- **Static Analysis**: Code quality tooling to be determined based on Nuuday organizational standards
- **Documentation**: Comprehensive API documentation and architectural decision records

#### 6.5.2 Development Practices
- **Version Control**: Git with feature branch workflow and protected main branch
- **CI/CD Pipeline**: GitHub Actions with automated testing, security scanning, and deployment
- **Environment Strategy**: Development, staging, and production environments with data isolation
- **Deployment**: Blue-green deployment with automated rollback capabilities

#### 6.5.3 Monitoring & Observability
- **Application Monitoring**: Grafana dashboards with Prometheus metrics for real-time performance monitoring and alerting
- **Business Metrics**: Order volume, payment success rates, and tenant usage
- **Log Management**: Centralized logging with structured log format
- **Health Checks**: Comprehensive health endpoints for all services

### 7.6 Technical Priorities & Constraints

#### 6.6.1 Core Technical Priorities
- **Code Quality**: Well-structured and maintainable codebase architecture
- **Developer Experience**: Easy onboarding for new developers with comprehensive documentation
- **User Experience**: Easy to use for both internal tenants and external customers
- **System Reliability**: High availability and performance under load

#### 6.6.2 System Constraints
- **Legacy Dependencies**: Must maintain compatibility with existing SOAP-based TCM system
- **Limited Legacy Access**: Restricted access to legacy systems for integration and testing
- **Performance Constraints**: System must handle peak loads during product launches on shared infrastructure
- **Scalability Limits**: Database design must support efficient tenant scaling
- **Security Boundaries**: Strict tenant isolation cannot be compromised

#### 6.6.3 Compliance & Regulatory Constraints
- **Telecom Regulations**: Compliance with national numbering regulations and telecom industry standards
- **Data Privacy Laws**: GDPR and national data protection requirements
- **Financial Compliance**: PCI DSS for payment processing
- **Audit Requirements**: Comprehensive audit trails for all tenant operations

#### 6.6.4 Technical Debt Management
- **Legacy Integration**: Custom adapter development for SOAP-based legacy systems
- **Refactoring**: Planned refactoring cycles to maintain code quality
- **Documentation**: Continuous documentation updates for system changes
- **Performance Optimization**: Regular performance reviews and optimization cycles

---

## 8. Project Team

### 7.1 Project Sponsor

Lars Vieland Grasberger, Head of IT, Nuuday Mobile Partners.

### 7.2 Project Manager

Bjørn Alsted Nielsen, Product Owner, Nuuday Mobile Partners.

### 7.3 Key Stakeholders

- Nichlas Bruselius, Head of Brand Partners
- Katrine Grøn Iversen, Commercial Manager
- Katrine Blicher Christensen, Commercial Manager
- Niclas Schumacher, IT Lead

### 7.4 Core Project Team

Infrastructure & Platform team (responsible for building the module)

### 7.5 External Partners/Vendors

Eesy - whom is a known brand partner that will be the first customer using the pure API capabilities of the eCommerce Service.

---

## 9. Project Milestones & Checkpoints

### 8.1 Key Milestones

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

### 8.2 Timeline

- Phase 1 (August-September): Technical design including architecture for channel and catalog modules.
- Phase 2 (September–May 2025): Development & integration.

### 8.3 Go/No-Go Checkpoints

Dependencies on legacy TCM system, Open Pages project, and provisioning systems may impact go/no-go decisions.

---

## 10. Assumptions, Constraints & Dependencies

### 9.1 Assumptions

- Timely availability of resources for design and development
- Continued access to legacy TCM system for product, pricing, and MSISDN data

### 9.2 Constraints

Flexible to adapt to changing requirements or priorities

### 9.3 Dependencies

- **Legacy TCM system**: Required for product, pricing, and MSISDN data. Any delays in accessing this system may impact the integration timeline and overall project delivery.
- **Open Pages project**: Provides frontend capabilities for whitelabel solutions. Delays or changes in this project could affect the user interface and customer experience.
- **Customer/subscriber provisioning systems**: Essential for provisioning and managing customer subscriptions. Integration challenges or unavailability could delay the go-live timeline.
- **Partner engagement**: Timely feedback and collaboration from brand partners are critical for ensuring the solution meets their requirements.
- **Infrastructure readiness**: Availability of scalable infrastructure to support multi-tenant operations is necessary for deployment and performance.

---

## 11. Risks and Opportunities

### 10.1 Risks

- Integration challenges with legacy and downstream systems may delay delivery
- Dependencies on other projects could cause resource conflicts
- Scope creep due to evolving partner requirements
- Competing priorities within Nuuday Mobile Partners may affect focus

### 10.2 Opportunities

- Strengthened relationships with brand partners through early engagement
- Foundation for future eCommerce innovation and feature expansion

---

## 12. Communication Plan

- **Jira dashboard:** Real-time project status, milestones, and key metrics
- **Slack channel:** Regular status updates and immediate issue resolution and ad-hoc discussions
- **Bi-weekly meetings:** Project progress reviews with stakeholders during feature development

---

## 13. Charter Acceptance & Approvals

- **Project Sponsor:** Lars Vieland Grasberger
- **Project Manager:** Bjørn Alsted Nielsen
- **Core Project Team:** [Signatures as appropriate]

**Prepared by:** [Your Name]  
**Date:** June 20, 2025
