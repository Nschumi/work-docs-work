# Catalog Module - Detailed Requirements

**Module:** Catalog Module  
**Priority:** Phase 1 - Foundation  
**Owner:** Infrastructure & Platform Team  
**Stakeholders:** Brand Partners, Product Managers, API Consumers  

---

## 1. Module Overview

### 1.1 Purpose
The Catalog Module manages product items and their associated metadata while ensuring complete tenant isolation. It serves as the central repository for telecom product offerings across multiple brand partners.

### 1.2 Key Users

- **Brand Partner Administrators**: Manage product catalogs and pricing
- **API Consumers** (e.g., Eesy): Integrate products into external systems
- **Internal Staff**: Configure and maintain product offerings

### 1.3 Core Responsibilities

- Maintain product items with legacy subscription ID references via SAGA Product Service
- Support multiple product variants for same subscription
- Enforce tenant isolation for all product data
- Provide RESTful APIs for catalog management
- Integrate with legacy TCM system through SAGA Product Service adapter

---

## 2. Functional Requirements

### 2.1 Product Item Management

#### 2.1.1 Create Product Items
**As a** brand partner administrator  
**I want to** create new product items  
**So that** I can offer telecom products to my customers  

**Acceptance Criteria:**
- [ ] Can create product item with legacy subscription ID reference
- [ ] Can add campaign metadata (discount, promotion details)
- [ ] Can set binding period information
- [ ] Can configure tenant-specific pricing
- [ ] System validates subscription ID exists in legacy TCM system
- [ ] Product item is automatically isolated to current tenant

**Business Rules:**
- Legacy subscription ID must be valid in TCM system (via SAGA Product Service)
- Product name must be unique within tenant
- Pricing can only be modified indirectly through campaigns
- Pricing and binding period are optional (may be derived from subscription)
- Binding period must be valid telecom standard (1, 6, 12, 24, 36 months)

#### 2.1.2 Manage Product Variants
**As a** brand partner administrator  
**I want to** create multiple variants of the same subscription  
**So that** I can offer different campaigns and pricing for the same product  

**Acceptance Criteria:**
- [ ] Can create multiple variants for same legacy subscription ID
- [ ] Each variant can have different campaigns
- [ ] Each variant can have different binding periods
- [ ] Each variant can have different pricing structures
- [ ] Can activate/deactivate variants independently

**Business Rules for Variants:**
- Variants differ by campaigns, binding periods, and pricing structures
- No specific limit on variants per subscription
- Variants can have different campaigns applied
- Pricing modifications handled through campaign system

### 2.2 Product Information Management

#### 2.2.1 Legacy System Integration
**As a** system  
**I need to** retrieve product details from legacy TCM system  
**So that** product information stays current and accurate  

**Acceptance Criteria:**
- [ ] System fetches subscription details using only subscription ID
- [ ] Retrieves available datacards with amount limits
- [ ] Retrieves available SIM types
- [ ] Retrieves available modules (e.g., 5G) with pricing
- [ ] Caches responses to reduce TCM system load
- [ ] Handles TCM system unavailability gracefully

**Integration Notes:**
- Catalog Item controls which TCM properties are optional for end users
- Product subscription price from TCM is customer-facing price
- Price modifications must be done through campaigns, not direct overrides
- Products have both subscription price and initial price (often 0)
- SAGA Product Service provides abstraction layer for TCM integration

#### 2.2.2 Product Enrichment
**As a** brand partner administrator  
**I want to** enrich products with marketing information  
**So that** customers see relevant and branded product details  

**Acceptance Criteria:**
- [ ] Can add custom product descriptions
- [ ] Can upload product images
- [ ] Can add marketing copy and features
- [ ] Can set SEO metadata (title, description, keywords)
- [ ] Can configure product categories and tags

**Content Management Notes:**
- Marketing content and branding handled through Contentful CMS
- Product images managed via Contentful templates, not individual catalog items
- Flexible content structure to support Contentful integration
- Single language support (Danish only) initially

### 2.3 Catalog Organization

#### 2.3.1 Product Categories
**As a** brand partner administrator  
**I want to** organize products into categories  
**So that** customers can easily find relevant products  

**Acceptance Criteria:**
- [ ] Can create custom product categories
- [ ] Can assign products to multiple categories
- [ ] Can create hierarchical category structures
- [ ] Categories are tenant-specific
- [ ] Can reorder categories and subcategories

**Category Structure:**
- Currently two main product types: mobile and mobile broadband
- Categories can be customized per tenant
- Support for hierarchical category structures
- Products can belong to multiple categories

#### 2.3.2 Product Search and Filtering
**As a** API consumer  
**I want to** search and filter products efficiently  
**So that** I can present relevant products to end customers  

**Acceptance Criteria:**
- [ ] Can search products by name, description, category
- [ ] Can filter by price range, binding period, features
- [ ] Can sort by price, popularity, date added
- [ ] Search results are tenant-isolated
- [ ] Support pagination for large catalogs

**Search Requirements:**
- Structured filtering sufficient (not full-text search)
- Limited search requirements due to smaller catalog sizes
- Focus on basic filtering by price, category, binding period
- Simple search implementation appropriate for catalog scale

---

## 3. Business Rules & Validation

### 3.1 Data Validation Rules

- **Legacy Subscription ID**: Must exist in TCM system via SAGA Product Service
- **Product Name**: Required, 2-100 characters, unique within tenant
- **Pricing**: Must be positive decimal values with max 2 decimal places
- **Currency**: Always DKK (Danish Kroner)
- **Binding Period**: Must be one of: 1, 6, 12, 24, 36 months
- **Campaign Integration**: Campaigns managed by separate Campaign Service

### 3.2 Business Logic Rules

- Products can only be edited by users in the same tenant
- Deactivated products cannot be added to new orders
- Price changes require audit trail for compliance
- Campaign discounts can be any amount (including 100% for promotional offers)
- Products with active orders cannot be deleted
- Pricing modifications only through campaign attachments

### 3.3 Tenant Isolation Rules
- All catalog queries must include tenant_id filtering
- Cross-tenant product access is strictly prohibited
- Product exports only include current tenant's products
- API responses never include other tenants' data

---

## 4. API Requirements

### 4.1 REST API Endpoints

#### 4.1.1 Product Management APIs
```
GET    /api/v1/catalog/products              # List products with filtering
POST   /api/v1/catalog/products              # Create new product
GET    /api/v1/catalog/products/{id}         # Get product details
PUT    /api/v1/catalog/products/{id}         # Update product
DELETE /api/v1/catalog/products/{id}         # Soft delete product
PATCH  /api/v1/catalog/products/{id}/status  # Activate/deactivate product
```

#### 4.1.2 Product Variant APIs
```
GET    /api/v1/catalog/products/{id}/variants     # List product variants
POST   /api/v1/catalog/products/{id}/variants     # Create variant
PUT    /api/v1/catalog/products/{id}/variants/{vid} # Update variant
DELETE /api/v1/catalog/products/{id}/variants/{vid} # Delete variant
```

#### 4.1.3 Category Management APIs
```
GET    /api/v1/catalog/categories            # List categories
POST   /api/v1/catalog/categories            # Create category
PUT    /api/v1/catalog/categories/{id}       # Update category
DELETE /api/v1/catalog/categories/{id}       # Delete category
```

### 4.2 Request/Response Examples

#### Create Product Request
```json
{
  "name": "Mobile Plus 10GB",
  "description": "Premium mobile plan with 10GB data",
  "legacy_subscription_id": "SUB12345",
  "base_price": 29.99,
  "currency": "DKK",
  "binding_period_months": 12,
  "category_ids": ["cat_001", "cat_002"],
  "campaign": {
    "name": "Summer Sale",
    "discount_percent": 20,
    "start_date": "2025-06-01",
    "end_date": "2025-08-31"
  },
  "metadata": {
    "data_allowance": "10GB",
    "voice_minutes": "Unlimited",
    "sms_included": "Unlimited"
  }
}
```

**API Design Notes:**
- Support for campaign attachment to catalog items
- Pricing structure includes subscription price and initial price
- Metadata fields flexible to support various product attributes
- Bulk operations deprioritized (not current requirement)

---

## 5. Data Requirements

### 5.1 Core Data Entities

#### 5.1.1 Product_Item
```sql
Product_Item {
  item_id: UUID (PK)
  tenant_id: UUID (FK, required)
  legacy_subscription_id: String (required)
  name: String (required, unique per tenant)
  description: Text
  base_price: Decimal
  currency: String (3 chars)
  binding_period_months: Integer
  status: Enum (active, inactive, draft)
  created_at: DateTime
  updated_at: DateTime
  created_by: UUID
  updated_by: UUID
}
```

#### 5.1.2 Product_Variant
```sql
Product_Variant {
  variant_id: UUID (PK)
  product_item_id: UUID (FK)
  tenant_id: UUID (FK, required)
  variant_name: String
  price_override: Decimal (nullable)
  campaign_id: UUID (FK, nullable)
  binding_period_override: Integer (nullable)
  status: Enum (active, inactive)
  created_at: DateTime
  updated_at: DateTime
}
```

#### 5.1.3 Campaign
```sql
Campaign {
  campaign_id: UUID (PK)
  tenant_id: UUID (FK, required)
  name: String (required)
  description: Text
  discount_type: Enum (percentage, fixed_amount)
  discount_value: Decimal
  start_date: DateTime
  end_date: DateTime
  status: Enum (active, inactive, scheduled)
  created_at: DateTime
  updated_at: DateTime
}
```

### 5.2 Data Relationships
- Product_Item → Product_Variant (1:N)
- Product_Item → Campaign (N:N via Product_Campaign)
- Product_Item → Category (N:N via Product_Category)
- All entities → Tenant (N:1)

**Data Architecture Notes:**
- Price history tracking for audit compliance
- Product images handled through Contentful CMS integration
- Campaign reusability managed by separate Campaign Service
- Metadata fields support telecom-specific attributes (data allowance, voice minutes, etc.)

---

## 6. Integration Points

### 6.1 Legacy TCM System
- **Purpose**: Retrieve subscription details and pricing
- **Method**: SOAP adapter service
- **Data**: Subscription info, datacards, SIM types, modules
- **Frequency**: On-demand with caching
- **Fallback**: Cached data when TCM unavailable

### 6.2 Channel Module

- **Purpose**: Product visibility configuration
- **Method**: Internal API calls
- **Data**: Product-channel associations, visibility rules
- **Timing**: Real-time when products added to channels

### 6.3 Order Module

- **Purpose**: Product validation during order creation
- **Method**: Internal API calls
- **Data**: Product availability, pricing, constraints
- **Timing**: Real-time during order processing

### 6.4 Campaign Service Integration

- **Purpose**: Campaign attachment and pricing modifications
- **Method**: Internal API calls
- **Data**: Campaign associations, discount applications
- **Timing**: Real-time for campaign-based pricing

---

## 7. Performance Requirements

### 7.1 Response Time Targets
- Product list API: < 200ms for up to 1000 products
- Product detail API: < 100ms
- Product search: < 300ms with full-text search
- Product creation: < 500ms including TCM validation

### 7.2 Throughput Requirements
- Support 100 concurrent catalog management operations
- Handle 1000+ product queries per minute
- Support bulk operations for up to 100 products

### 7.3 Scalability Targets

- Support 5-200 products per tenant (typical: 5-100)
- Maximum 200 products per tenant
- Handle 20+ tenants concurrently
- Database queries optimized for smaller catalog sizes
- 2-5 admin users per tenant for catalog management

---

## 8. Security Requirements

### 8.1 Access Control
- Tenant-based isolation for all product data
- Role-based permissions (admin, editor, viewer)
- API authentication via OAuth 2.0 JWT tokens
- Audit logging for all product modifications

### 8.2 Data Protection
- Encrypt sensitive pricing information
- Mask pricing data in non-production environments
- Secure API endpoints with rate limiting
- Validate all input data to prevent injection attacks

---

## 9. User Experience Requirements

### 9.1 Administration Interface

- Intuitive product creation wizard
- Visual product preview with pricing
- Real-time validation feedback
- Desktop-optimized interface (no mobile support required)
- Campaign management interface integration
- Category organization tools

### 9.2 API Consumer Experience

- Comprehensive API documentation with examples
- Consistent error messages and status codes
- Pagination support for datasets
- Structured filtering capabilities (not full-text search)
- No notification system required

---

## 10. Future Considerations

### 10.1 Potential Enhancements

- Advanced pricing rules and calculations
- Product bundling capabilities
- Multi-language product descriptions (beyond Danish)
- Enhanced analytics and reporting
- Advanced campaign integration features

### 10.2 Integration Opportunities

- CRM system integration for customer insights
- Marketing automation platform connections
- Analytics and reporting dashboard
- Enhanced Contentful CMS integration features

---

## 11. Open Questions & Decisions Needed

### 11.1 Business Decisions (Resolved)

1. **Product Lifecycle**: No approval process required - brand partners can publish immediately
2. **Pricing Strategy**: Complex pricing handled through Campaign Service integration
3. **Cross-Tenant Features**: Complete tenant isolation required
4. **Product Versioning**: Catalog service only represents purchasable items, not order history

### 11.2 Technical Decisions (Resolved)

1. **Caching Strategy**: 1+ hour cache duration with manual invalidation via TCM system
2. **Search Implementation**: Structured filtering sufficient for catalog scale
3. **Image Storage**: Handled through Contentful CMS templates
4. **Data Synchronization**: One-way integration from TCM (no sync back to TCM)

### 11.3 Implementation Details

1. **TCM Integration**: Via SAGA Product Service abstraction layer
2. **Cache Invalidation**: Manual purge requests from TCM system
3. **Bulk Operations**: Removed from requirements (not needed)
4. **Mobile Support**: Desktop-only administration interface

---

## 12. Success Criteria

### 12.1 Functional Success
- [ ] Brand partners can create and manage products independently
- [ ] API consumers can integrate and retrieve product data
- [ ] Complete tenant isolation verified through testing
- [ ] TCM system integration working reliably

### 12.2 Performance Success
- [ ] All API response time targets met
- [ ] System handles target concurrent load
- [ ] Database queries optimized for tenant filtering

### 12.3 User Success
- [ ] Brand partners can onboard and create first product within 30 minutes
- [ ] API consumers can integrate within planned timeframes
- [ ] Zero critical issues in first month of production use

---

**Next Steps:**
1. Review and complete open questions
2. Validate business rules with stakeholders
3. Finalize API specifications
4. Create detailed technical design
5. Begin development planning for Phase 1