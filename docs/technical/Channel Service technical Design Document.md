# Channel Service Technical Design Document

## 1. Purpose and Overview

The **Channel Service** is a backend component responsible for managing the availability and presentation rules of telecom products across digital channels. It supports ATL (Above The Line) and BTL (Below The Line) product strategies, enabling precise control over which products appear on the website front page, subpages, eCare portal, and mobile app.

This service centralizes channel logic, allowing business stakeholders to manage product placement and visibility without code changes, and integrates with Contentful for dynamic content management.

---

## 2. Business Context

- **ATL Products:** High-visibility, often featured on front pages or major campaigns.
- **BTL Products:** Niche or targeted, typically on subpages, eCare, or app.
- **Channel Types:**
  - **Website (Public):** Front page, subpages, campaign pages (via Contentful).
  - **eCare Portal:** Customer self-service portal.
  - **Mobile App:** Native app experience.
  - **Other Channels:** For future integrations (e.g., partner portals).

The Channel Service ensures product visibility aligns with marketing and channel-specific requirements.

---

## 3. Key Responsibilities

- **Channel Definition:** Registry of all digital channels and their properties.
- **Product-Channel Mapping:** Define which catalog items are available on which channels and under what conditions.
- **Placement Rules:** Specify placement (e.g., front page, subpage, app section) for each product within a channel.
- **Integration with Contentful:** Support dynamic, content-driven placement and visibility rules.
- **API for Consumers:** Expose APIs for the Catalog Service, frontend apps, and admin tools to query channel availability and placement.
- **Admin Interface:** (Optional) Management endpoints for business stakeholders to update channel rules.

---

## 4. High-Level Architecture

+----------------+ +----------------+ +----------------------+
| Contentful CMS | ---> | Channel Service| ---> | Catalog Service |
| (Page Layouts) | | (Placement API)| | (Catalog Items, etc.)|
+----------------+ +----------------+ +----------------------+
|
v
+----------------------+
| Frontend Applications|
| (Web, eCare, App) |
+----------------------+

- **Contentful:** Manages page layouts and content blocks.
- **Channel Service:** Manages product availability and placement.
- **Catalog Service:** Provides product details and variations.
- **Frontend:** Queries Channel Service to determine what to display and where.

---

## 5. Data Model

### Entities

- **Channel**

  - `ChannelId`: GUID
  - `Name`: string (e.g., "Website", "eCare", "App")
  - `Type`: enum (ATL, BTL, etc.)
  - `Metadata`: JSON (for extensibility, e.g., Contentful integration keys)

- **Placement**

  - `PlacementId`: GUID
  - `ChannelId`: FK
  - `Name`: string (e.g., "FrontPage", "SubPage", "OffersSection")
  - `ContentfulBlockId`: string (optional, for mapping to Contentful blocks)

- **ChannelProductMapping**
  - `MappingId`: GUID
  - `ChannelId`: FK
  - `PlacementId`: FK
  - `CatalogItemId`: FK (from Catalog Service)
  - `Visibility`: enum (Visible, Hidden, Scheduled)
  - `StartDate`/`EndDate`: datetime (for scheduling)
  - `Priority`: int (for ordering)

#### Example Table

| Channel | Placement | Product          | Visibility | Priority |
| ------- | --------- | ---------------- | ---------- | -------- |
| Website | FrontPage | 5G Unlimited     | Visible    | 1        |
| Website | SubPage   | Student Discount | Visible    | 2        |
| eCare   | Offers    | Loyalty Upgrade  | Visible    | 1        |
| App     | AppMain   | App-Only Deal    | Visible    | 1        |

---

## 6. API Design

### Endpoints

- `GET /channels`: List all channels.
- `GET /channels/{channelId}/placements`: List placements for a channel.
- `GET /channels/{channelId}/placements/{placementId}/products`: List products for a specific placement.
- `GET /channels/{channelId}/products`: List all products available on a channel.
- `POST /channels/{channelId}/placements/{placementId}/products`: Add product to placement.
- `PATCH /channels/{channelId}/placements/{placementId}/products/{productId}`: Update visibility, scheduling, etc.
- `DELETE /channels/{channelId}/placements/{placementId}/products/{productId}`: Remove product from placement.

### Contentful Integration

- Placements can be mapped to Contentful block IDs.
- When rendering a page, the frontend:
  1. Fetches the page layout from Contentful.
  2. For each block/section, queries Channel Service for products assigned to that placement.

---

## 7. Example Flow

1. **Brand manager** wants “Student Discount” to appear only on the website subpage and in the app.
2. In the admin tool (or via API), they:
   - Assign “Student Discount” to the Website channel, SubPage placement.
   - Assign “Student Discount” to the App channel, AppMain placement.
3. When a user visits the website front page, the frontend queries Channel Service for products in the FrontPage placement—“Student Discount” is not returned.
4. On the subpage or in the app, “Student Discount” is displayed as configured.

---

## 8. Integration with Contentful

- **Contentful** provides structure and content for open/public pages.
- **Channel Service** provides dynamic product assignments for each block/section.
- The frontend combines both: renders the Contentful page and populates product blocks by querying the Channel Service.

**Example:**

- Contentful block `homepage-featured-products` is mapped to Placement `FrontPage` in Channel Service.
- Frontend fetches the block from Contentful, then requests products for that placement from Channel Service.

---

## 9. Jira Epics & Tasks Outline

**Epic: Channel Service Foundation**

- Define data model and database migrations
- Implement Channel and Placement CRUD endpoints
- Integrate with Catalog Service for product references

**Epic: Placement & Visibility Rules**

- Implement product-channel-placement mapping logic
- Add scheduling and priority support
- Implement visibility toggling

**Epic: Contentful Integration**

- Support mapping placements to Contentful block IDs
- Document integration pattern for frontend teams

**Epic: Admin & API Management**

- Build admin endpoints for managing mappings
- Implement RBAC for sensitive operations

**Epic: Testing & QA**

- Unit and integration tests for all endpoints
- Mock integration with Contentful and Catalog Service

**Epic: Documentation**

- API documentation (Swagger/OpenAPI)
- Integration guides for frontend and content teams

---

## 10. Summary

The Channel Service enables dynamic, channel-aware product placement in a modern telecom digital stack. By centralizing channel and placement logic, and integrating with Contentful and the Catalog Service, it empowers business users to drive marketing strategies while allowing developers to build flexible, maintainable frontends.

---

## Diagram: Channel Service in Context

+----------------------+
| Contentful |
| (Page Layouts/Blocks)|
+----------+-----------+
|
v
+----------+-----------+
| Channel Service |
| (Placement & Rules) |
+----------+-----------+
|
v
+----------+-----------+
| Catalog Service |
| (Product Details) |
+----------+-----------+
|
v
+----------+-----------+
| Frontend Applications|
+----------------------+
