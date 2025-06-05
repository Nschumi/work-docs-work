# Catalog Service Technical Project Document

## 1. Purpose and Overview

The **Catalog Service** is a backend module in a modular monolith, exposing telecom subscription products to digital channels. It enables brand managers to create catalog items referencing underlying products, with channel-specific variations (binding periods, campaigns, display names). The service supports flexible product presentation, dynamic marketing, and real-time updates across all customer touchpoints.

---

## 2. Business Context

- **Telecom Subscription Products:** Core offerings are subscription-based.
- **Catalog Items:** Reference products and include:
  - Binding period
  - Campaign (e.g., 50% off)
  - Channel-specific display name/pricing
- **Brand Managers:** Can create multiple catalog items per product for different channels/campaigns.
- **Channels:** Web, eCare portal, mobile app, etc.

---

## 3. Key Responsibilities

- Expose catalog items to digital channels.
- Support channel/campaign-specific product variations.
- Integrate with Channel, Campaign, and Product modules.
- Provide real-time updates.
- Maintain audit history for compliance.

---

## 4. Modular Monolith Architecture

flowchart TD
ChannelService["Channel Service
(Placement & Rules)"]
CatalogService["Catalog Service
(Catalog Items, API)"]
ProductService["Product Service
(Product Details)"]
Frontends["Frontend Applications
(Web, eCare, App)"]

text
ChannelService --> CatalogService
CatalogService --> ProductService
CatalogService --> Frontends
text

**Module Boundaries:**

- Each service is a distinct module with internal types and explicit contracts for inter-module communication, avoiding direct repository access.
- Use interfaces and DTOs in a shared contracts project to prevent circular dependencies.

---

## 5. Data Model

### Entities (C# 12 Example)

public sealed record CatalogItem(
Guid CatalogItemId,
Guid ProductId,
Guid BrandId,
string Name,
string Description,
int BindingPeriodMonths,
Guid? CampaignId,
IReadOnlyList<Guid> ChannelAvailability,
decimal? Price,
CatalogItemStatus Status,
DateTimeOffset CreatedAt,
DateTimeOffset UpdatedAt
);

public enum CatalogItemStatus { Active, Inactive, Archived }

text

- **Anti-pattern:** Avoid anemic models—encapsulate business logic (e.g., price calculation, campaign application) in domain entities, not just in services.

---

## 6. API Design

- `GET /catalog/items`
- `GET /catalog/items/{id}`
- `POST /catalog/items`
- `PUT /catalog/items/{id}`
- `DELETE /catalog/items/{id}`
- `GET /catalog/items/{id}/channels`
- `PATCH /catalog/items/{id}/campaign`

**Implementation Steps:**

- Use ASP.NET Core Minimal APIs or Controllers for endpoints.
- Apply MediatR for CQRS (Command/Query separation).
- Use FluentValidation for input validation.

---

## 7. Integration Patterns

- **Product Module:** Fetch base product data via public interfaces.
- **Campaign Module:** Apply campaign details/discounts via events or service calls.
- **Channel Module:** Determine channel availability and placement.
- **Authentication:** Secure admin/API access with OAuth2/JWT.

**Avoid:** Direct access to other modules' repositories or internal types—always use public contracts/interfaces.

---

## 8. Technology Stack

- .NET 8, C# 12
- ASP.NET Core Web API
- Entity Framework Core
- SQL Server/PostgreSQL
- Docker/Kubernetes
- Serilog for logging
- Redis for caching (optional)
- Swagger/OpenAPI

---

## 9. Implementation Phases & Jira Epics

### Epic 1: Foundation Setup

- Project repo, CI/CD, database schema, migrations, API scaffolding, authentication

### Epic 2: Core Catalog API

- CRUD endpoints, repository/service layer, validation, Swagger

### Epic 3: Business Logic & Variations

- Channel/campaign logic, brand manager workflows

### Epic 4: Integration

- Product, Campaign, Channel integration; event publishing

### Epic 5: Advanced Features

- Search/filtering, bulk ops, audit logging

### Epic 6: Testing & QA

- Unit/integration tests, performance/security

#### Example Jira Tasks

- Implement CatalogItem entity with encapsulated business logic
  - **Acceptance:** CatalogItem enforces business invariants (e.g., no negative price)
- Expose `GET /catalog/items` with filtering by channel/brand/status
  - **Acceptance:** Endpoint returns filtered results, validated by integration tests
- Integrate with Product module via interface, not direct repository
  - **Acceptance:** No direct references to Product module internals

---

## 10. Anti-Patterns to Avoid

- **Big Ball of Mud:** Eroded module boundaries due to shortcut dependencies.
- **Anemic Domain Model:** All business logic in services, not entities.
- **Direct Repository Access:** One module accessing another's data layer directly.

**Mitigation:** Enforce boundaries with internal types, public contracts, and code reviews.

---

## 11. ADR Template Recommendation

**Architecture Decision Record (ADR) Template:**

[Title]
Status
Accepted/Proposed/Deprecated

Context
[Background and why this decision is needed]

Decision
[What is being decided and why]

Consequences
[Impacts, trade-offs, and follow-up actions]

text

**Key ADRs to capture:**

- Module boundary definitions
- Integration patterns (sync/async, contracts)
- Data ownership and consistency

---

## 12. Summary

The Catalog Service module is a robust, flexible component in a modular monolith, supporting dynamic telecom product presentation and channel-specific variations. By following modular boundaries, encapsulating business logic, and integrating via public contracts, the system avoids common telecom anti-patterns and remains maintainable and scalable.

---
