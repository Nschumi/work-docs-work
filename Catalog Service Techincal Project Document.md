# Catalog Service Technical Project Document

## 1. Purpose and Overview

The **Catalog Service** is a backend service responsible for exposing telecom subscription products to various digital channels. It enables brand managers to create catalog items that reference underlying products, with channel-specific variations such as binding periods, campaigns, and display names. The service supports flexible product presentation, dynamic marketing strategies, and real-time updates across all customer touchpoints.

---

## 2. Business Context

- **Telecom Subscription Products:** The core products are subscription-based offerings.
- **Catalog Items:** Each catalog item references an underlying product and can include:
  - Binding period
  - Campaign (e.g., 50% off)
  - Channel-specific display name
  - Channel-specific pricing or presentation
- **Brand Managers:** Can create multiple catalog items from the same product, each with variations as needed for different channels or campaigns.
- **Channels:** Website, eCare portal, mobile app, and others.

---

## 3. Key Responsibilities

- **Expose Products:** Make catalog items available to various digital channels.
- **Support Variations:** Allow channel-specific and campaign-specific variations of products.
- **Integrate with Other Services:** Work with Channel Service, Campaign Service, and Product Service.
- **Provide Real-Time Updates:** Ensure changes are reflected instantly across all channels.
- **Audit and Compliance:** Maintain a history of changes for regulatory and business transparency.

---

## 4. High-Level Architecture

+----------------+ +----------------+ +----------------------+
| Channel Service| ---> | Catalog Service| ---> | Product Service |
| (Placement API)| | (Catalog API) | | (Product Details) |
+----------------+ +----------------+ +----------------------+
|
v
+----------------------+
| Frontend Applications|
| (Web, eCare, App) |
+----------------------+

- **Channel Service:** Determines where products are shown.
- **Catalog Service:** Manages catalog items and exposes them to channels.
- **Product Service:** Source of truth for underlying product data.

---

## 5. Data Model

### Entities

- **CatalogItem**

  - `CatalogItemId`: GUID
  - `ProductId`: GUID (FK to Product Service)
  - `BrandId`: GUID
  - `Name`: string (channel-specific display name)
  - `Description`: string
  - `BindingPeriodMonths`: int
  - `CampaignId`: GUID (optional, FK to Campaign Service)
  - `ChannelAvailability`: list of channel IDs
  - `Price`: decimal (optional, channel-specific)
  - `Status`: enum (Active, Inactive, Archived)
  - `CreatedAt`/`UpdatedAt`: datetime

- **Brand**

  - `BrandId`: GUID
  - `Name`: string

- **ChannelAvailability**

  - `CatalogItemId`: GUID
  - `ChannelId`: GUID

- **Campaign**
  - `CampaignId`: GUID
  - `Name`: string
  - `DiscountPercent`: decimal
  - `StartDate`/`EndDate`: datetime

---

## 6. API Design

### Endpoints

- `GET /catalog/items`: List catalog items (with filtering by channel, brand, status)
- `GET /catalog/items/{id}`: Get details for a catalog item
- `POST /catalog/items`: Create a new catalog item
- `PUT /catalog/items/{id}`: Update a catalog item
- `DELETE /catalog/items/{id}`: Archive a catalog item
- `GET /catalog/items/{id}/channels`: List channels where the item is available
- `PATCH /catalog/items/{id}/campaign`: Assign or update campaign for a catalog item

### Example: Create Catalog Item (Request Body)

{
"productId": "guid",
"brandId": "guid",
"name": "Premium Unlimited 5G",
"description": "Best value 5G subscription",
"bindingPeriodMonths": 24,
"campaignId": "guid",
"channelAvailability": ["web", "app"],
"price": 299.00
}

---

## 7. Integration Patterns

- **Product Service:** Fetch base product data.
- **Campaign Service:** Apply campaign details and discounts.
- **Channel Service:** Determine channel-specific availability and placement.
- **Authentication Service:** Secure admin and API access (OAuth2/JWT).

---

## 8. Technology Stack

- **.NET 8, C# 12**
- **ASP.NET Core Web API**
- **Entity Framework Core**
- **SQL Server or PostgreSQL**
- **Docker/Kubernetes for containerization**
- **Serilog for logging**
- **Redis for caching (optional)**
- **Swagger/OpenAPI for documentation**

---

## 9. Project Implementation Phases & Jira Epics

### Epic 1: Foundation Setup

- Project repo and CI/CD pipeline
- Database schema and migrations
- Basic API scaffolding
- Authentication integration

### Epic 2: Core Catalog API

- CatalogItem CRUD endpoints
- Repository and service layer
- Input validation and error handling
- Swagger documentation

### Epic 3: Business Logic & Variations

- Channel-specific logic
- Campaign integration
- Brand manager workflows

### Epic 4: Integration

- Product, Campaign, and Channel Service integration
- Event publishing for catalog changes

### Epic 5: Advanced Features

- Search and filtering
- Bulk operations
- Audit logging

### Epic 6: Testing & QA

- Unit and integration tests
- Performance and security testing

---

## 10. Deployment & Operations

- **Zero-downtime deployments** via Kubernetes
- **Automated database migrations**
- **Health checks** and monitoring (Application Insights, Prometheus, etc.)
- **Structured logging** and correlation IDs
- **Backup and disaster recovery**

---

## 11. Risks & Mitigation

- **Performance bottlenecks:** Use caching and database indexing.
- **Integration failures:** Circuit breakers, retries, and graceful degradation.
- **Data consistency:** Strong validation and transactional updates.
- **Regulatory compliance:** Comprehensive audit trails and approval workflows.

---

## 12. Summary

The Catalog Service is a central, flexible, and robust component for managing and exposing telecom subscription products across multiple channels. It supports dynamic marketing, channel-specific variations, and real-time updates, while integrating cleanly with other core services and modern content management systems.

---

## Diagram: Catalog Service in Context

+----------------------+
| Channel Service |
| (Placement & Rules) |
+----------+-----------+
|
v
+----------+-----------+
| Catalog Service |
| (Catalog Items, API) |
+----------+-----------+
|
v
+----------+-----------+
| Product Service |
| (Product Details) |
+----------------------+
