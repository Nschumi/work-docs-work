# Epic: Product Catalog Module

## Epic Overview

**Epic ID:** Phase 2 - Epic 1  
**Duration:** 4-5 weeks  
**Team Size:** 2-3 developers  
**Dependencies:** Phase 1 foundation complete  

## Business Value

The Product Catalog module provides core eCommerce functionality for the multi-tenant telecom platform, enabling:
- **Tenant-Specific Catalogs:** Each tenant manages their own product portfolio
- **Telecom Product Support:** Subscriptions, devices, SIM cards, and services
- **Product Discovery:** Search, filtering, and categorization capabilities
- **Flexible Pricing:** Support for complex telecom pricing models
- **Integration Ready:** Foundation for orders, channels, and number management

## Epic Acceptance Criteria

- [ ] Tenants can manage complete product catalogs with categories
- [ ] Support for telecom-specific product types (subscriptions, devices, SIM cards)
- [ ] Search and filtering functionality for product discovery
- [ ] Product visibility and availability rules
- [ ] Performance meets requirements (search < 200ms, catalog load < 100ms)
- [ ] Complete tenant isolation verified for all product data
- [ ] APIs follow established patterns with comprehensive documentation

## Story Breakdown

### Story 1: Product and Category Management
**As a** tenant administrator  
**I want** to manage products and categories in my catalog  
**So that** I can organize and maintain my product offerings

**Acceptance Criteria:**
- [ ] Create, read, update, and delete product categories
- [ ] Create, read, update, and delete products within categories
- [ ] Support hierarchical category structure (parent/child categories)
- [ ] Product images and media management
- [ ] Product status management (active, inactive, draft)
- [ ] Bulk product operations (import, export, bulk updates)
- [ ] All operations respect tenant isolation

**Technical Implementation:**
```csharp
// Product Entity (tenant-aware via Finbuckle)
public class Product
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public string ShortDescription { get; set; }
    public decimal BasePrice { get; set; }
    public ProductType Type { get; set; } // Subscription, Device, SIMCard, Service
    public ProductStatus Status { get; set; }
    public string CategoryId { get; set; }
    public Category Category { get; set; }
    public List<ProductImage> Images { get; set; }
    public Dictionary<string, object> Attributes { get; set; } // Flexible attributes
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

// Category Entity
public class Category
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public string? ParentCategoryId { get; set; }
    public Category? ParentCategory { get; set; }
    public List<Category> ChildCategories { get; set; }
    public List<Product> Products { get; set; }
    public int SortOrder { get; set; }
    public bool IsActive { get; set; }
}

// API Endpoints
GET    /api/catalog/categories          - List categories
POST   /api/catalog/categories          - Create category
GET    /api/catalog/categories/{id}     - Get category
PUT    /api/catalog/categories/{id}     - Update category
DELETE /api/catalog/categories/{id}     - Delete category

GET    /api/catalog/products            - List products
POST   /api/catalog/products            - Create product
GET    /api/catalog/products/{id}       - Get product
PUT    /api/catalog/products/{id}       - Update product
DELETE /api/catalog/products/{id}       - Delete product
```

**Estimate:** 13 story points

### Story 2: Telecom-Specific Product Types
**As a** telecom business  
**I want** to manage telecom-specific products (subscriptions, devices, SIM cards)  
**So that** I can offer complete telecom solutions to customers

**Acceptance Criteria:**
- [ ] Support for subscription products with billing cycles
- [ ] Device products with technical specifications
- [ ] SIM card products (pSIM/eSIM) with carrier compatibility
- [ ] Service products with feature configurations
- [ ] Product bundling capabilities (device + subscription + SIM)
- [ ] Telecom-specific attributes and validation
- [ ] Integration points for external product data

**Technical Implementation:**
```csharp
public enum ProductType
{
    Subscription,   // Monthly/yearly plans
    Device,         // Phones, tablets, routers
    SIMCard,        // Physical or eSIM
    Service,        // Add-on services
    Bundle          // Combined offerings
}

// Telecom-specific product extensions
public class SubscriptionProduct : Product
{
    public BillingCycle BillingCycle { get; set; }
    public int DataAllowanceGB { get; set; }
    public int VoiceMinutes { get; set; }
    public int SMSCount { get; set; }
    public bool IsUnlimited { get; set; }
    public List<string> IncludedServices { get; set; }
}

public class DeviceProduct : Product
{
    public string Brand { get; set; }
    public string Model { get; set; }
    public string OS { get; set; }
    public string Color { get; set; }
    public int StorageGB { get; set; }
    public string[] SupportedNetworks { get; set; } // 4G, 5G
    public bool IsUnlocked { get; set; }
}

public class SIMProduct : Product
{
    public SIMType Type { get; set; } // Physical, eSIM
    public string[] SupportedNetworks { get; set; }
    public string CarrierCode { get; set; }
    public bool SupportsNumberPortability { get; set; }
}

// Enhanced API endpoints
GET /api/catalog/products/subscriptions
GET /api/catalog/products/devices
GET /api/catalog/products/sim-cards
POST /api/catalog/products/bundles
```

**Estimate:** 8 story points

### Story 3: Product Search and Discovery
**As a** customer or tenant user  
**I want** to search and filter products effectively  
**So that** I can quickly find relevant products

**Acceptance Criteria:**
- [ ] Full-text search across product names and descriptions
- [ ] Category-based filtering
- [ ] Price range filtering
- [ ] Product type filtering
- [ ] Attribute-based filtering (brand, specifications, etc.)
- [ ] Search result ranking and relevance
- [ ] Search performance under 200ms for 95% of queries
- [ ] Search suggestions and auto-complete

**Technical Implementation:**
```csharp
public class ProductSearchRequest : PaginatedRequest
{
    public string? SearchTerm { get; set; }
    public List<string>? Categories { get; set; }
    public decimal? MinPrice { get; set; }
    public decimal? MaxPrice { get; set; }
    public List<ProductType>? ProductTypes { get; set; }
    public Dictionary<string, string>? Attributes { get; set; }
    public ProductSortBy SortBy { get; set; } = ProductSortBy.Relevance;
    public SortDirection Direction { get; set; } = SortDirection.Descending;
}

public class ProductSearchResponse : PaginatedResponse<ProductSummaryDto>
{
    public List<SearchFacet> Facets { get; set; } // For filtering UI
    public int SearchTimeMs { get; set; }
    public string? SuggestedQuery { get; set; }
}

// Search service with performance optimization
public class ProductSearchService
{
    public async Task<ProductSearchResponse> SearchAsync(ProductSearchRequest request)
    {
        var query = _context.Products.AsQueryable();
        
        // Full-text search using SQL Server full-text search or Elasticsearch
        if (!string.IsNullOrEmpty(request.SearchTerm))
        {
            query = query.Where(p => 
                EF.Functions.Contains(p.Name, request.SearchTerm) ||
                EF.Functions.Contains(p.Description, request.SearchTerm));
        }
        
        // Apply filters with indexes
        query = ApplyFilters(query, request);
        
        // Apply sorting with performance consideration
        query = ApplySorting(query, request.SortBy, request.Direction);
        
        return await ExecuteSearchAsync(query, request);
    }
}

// API endpoints
GET /api/catalog/search?q={term}&category={cat}&minPrice={min}
GET /api/catalog/search/suggestions?q={partial}
GET /api/catalog/search/facets
```

**Estimate:** 8 story points

### Story 4: Product Visibility and Availability
**As a** tenant administrator  
**I want** to control product visibility and availability  
**So that** I can manage what customers see and can purchase

**Acceptance Criteria:**
- [ ] Product visibility rules (public, private, channel-specific)
- [ ] Availability scheduling (available from/until dates)
- [ ] Stock management and inventory tracking
- [ ] Geographic availability restrictions
- [ ] Customer segment-based visibility
- [ ] Product lifecycle management (coming soon, discontinued)
- [ ] Integration with external inventory systems

**Technical Implementation:**
```csharp
public class ProductVisibility
{
    public string ProductId { get; set; }
    public VisibilityType Visibility { get; set; }
    public DateTime? AvailableFrom { get; set; }
    public DateTime? AvailableUntil { get; set; }
    public List<string>? AllowedChannels { get; set; }
    public List<string>? AllowedRegions { get; set; }
    public List<string>? AllowedCustomerSegments { get; set; }
    public bool IsActive { get; set; }
}

public class ProductInventory
{
    public string ProductId { get; set; }
    public int TotalStock { get; set; }
    public int AvailableStock { get; set; }
    public int ReservedStock { get; set; }
    public int ReorderLevel { get; set; }
    public bool TrackInventory { get; set; }
    public bool AllowBackorders { get; set; }
}

// Enhanced product queries with visibility
public async Task<List<Product>> GetVisibleProductsAsync(string? channelId = null, string? region = null)
{
    var now = DateTime.UtcNow;
    
    return await _context.Products
        .Include(p => p.Visibility)
        .Include(p => p.Inventory)
        .Where(p => p.Status == ProductStatus.Active)
        .Where(p => p.Visibility.IsActive)
        .Where(p => p.Visibility.AvailableFrom == null || p.Visibility.AvailableFrom <= now)
        .Where(p => p.Visibility.AvailableUntil == null || p.Visibility.AvailableUntil >= now)
        .Where(p => channelId == null || p.Visibility.AllowedChannels.Contains(channelId))
        .Where(p => region == null || p.Visibility.AllowedRegions.Contains(region))
        .ToListAsync();
}

// API endpoints
GET /api/catalog/products/visible?channel={id}&region={code}
PUT /api/catalog/products/{id}/visibility
GET /api/catalog/products/{id}/inventory
PUT /api/catalog/products/{id}/inventory
```

**Estimate:** 8 story points

## Task Breakdown

### Technical Tasks

#### Task 1: Product and Category Entities Setup
**Description:** Create Finbuckle-compatible product and category entities with database configuration

**Implementation Steps:**
1. Create Product and Category entities with Finbuckle multi-tenant configuration
2. Configure Entity Framework mappings and relationships
3. Set up database migrations with proper indexing
4. Implement repository pattern with tenant-aware base classes
5. Add data validation and business rules

**Acceptance Criteria:**
- [ ] Entities configured with `.IsMultiTenant()` for Finbuckle
- [ ] Database migrations create optimized table structure
- [ ] Repository implements CRUD operations with tenant filtering
- [ ] Unit tests verify tenant isolation at data layer
- [ ] Performance indexes created for search operations

**Estimate:** 5 story points

#### Task 2: Product Management APIs
**Description:** Implement FastEndpoints for product and category management

**Implementation Steps:**
1. Create CRUD endpoints for categories following API standards
2. Create CRUD endpoints for products with validation
3. Implement bulk operations (import/export, bulk updates)
4. Add image upload and management endpoints
5. Configure OpenAPI documentation with examples

**Acceptance Criteria:**
- [ ] All CRUD endpoints implemented with FastEndpoints
- [ ] Request/response DTOs with FluentValidation
- [ ] Bulk operations support CSV import/export
- [ ] Image upload with file validation and storage
- [ ] Complete OpenAPI documentation

**Estimate:** 8 story points

#### Task 3: Telecom Product Type System
**Description:** Implement telecom-specific product types and attributes

**Implementation Steps:**
1. Design flexible product type system with inheritance/composition
2. Implement subscription product type with billing attributes
3. Implement device product type with technical specifications
4. Implement SIM card product type with carrier data
5. Create product bundling system

**Acceptance Criteria:**
- [ ] Product type system supports extensibility
- [ ] Telecom-specific validation rules implemented
- [ ] Product bundling works with different product types
- [ ] API endpoints support type-specific operations
- [ ] Database schema optimized for telecom attributes

**Estimate:** 8 story points

#### Task 4: Search and Discovery Implementation
**Description:** Build high-performance product search with filtering

**Implementation Steps:**
1. Implement full-text search using SQL Server features
2. Create faceted search with dynamic filtering
3. Add search result ranking and relevance scoring
4. Implement auto-complete and search suggestions
5. Optimize search performance with caching and indexing

**Acceptance Criteria:**
- [ ] Full-text search performs under 200ms for 95% of queries
- [ ] Faceted search provides filter options dynamically
- [ ] Search ranking provides relevant results
- [ ] Auto-complete responds under 100ms
- [ ] Search results properly cached with tenant awareness

**Estimate:** 8 story points

#### Task 5: Visibility and Availability System
**Description:** Implement product visibility rules and inventory management

**Implementation Steps:**
1. Create visibility rule engine with flexible criteria
2. Implement availability scheduling system
3. Add inventory tracking with stock management
4. Create geographic and channel-based restrictions
5. Build integration points for external inventory systems

**Acceptance Criteria:**
- [ ] Visibility rules filter products correctly by context
- [ ] Availability scheduling works with date ranges
- [ ] Inventory tracking accurate and performant
- [ ] Geographic restrictions work with region codes
- [ ] External inventory integration points defined

**Estimate:** 8 story points

#### Task 6: Testing and Performance Optimization
**Description:** Comprehensive testing and performance optimization

**Implementation Steps:**
1. Write unit tests for all services and repositories
2. Create integration tests for API endpoints with tenant isolation
3. Build performance tests for search and catalog operations
4. Implement caching strategy for frequently accessed data
5. Add monitoring and metrics collection

**Acceptance Criteria:**
- [ ] Unit test coverage > 80% for catalog module
- [ ] Integration tests verify complete tenant isolation
- [ ] Performance tests meet response time requirements
- [ ] Caching improves frequently accessed data performance
- [ ] Monitoring provides insights into catalog usage

**Estimate:** 5 story points

## Dependencies and Integration Points

### External Dependencies
- **Finbuckle.MultiTenant:** Tenant resolution and data filtering
- **File Storage:** Product image and media storage
- **Search Engine:** Optional Elasticsearch for advanced search (future)

### Internal Dependencies
- **Shared Infrastructure:** Database context and common services
- **API Framework:** FastEndpoints and validation patterns
- **Authentication:** User context for permission-based visibility

### Future Integration Points
- **Channel Management:** Channel-specific product visibility
- **Order Management:** Product availability during ordering
- **Number Management:** SIM card and subscription associations
- **External Product Data:** Integration with supplier catalogs

## Performance Requirements

### API Performance
- **Product Listing:** < 100ms for catalog pages (cached)
- **Product Search:** < 200ms for 95% of search queries  
- **Product Details:** < 50ms for individual product lookup
- **Bulk Operations:** < 30 seconds for 1000 product updates

### Search Performance
- **Search Index:** Updates within 30 seconds of product changes
- **Auto-complete:** < 100ms response time
- **Faceted Search:** < 200ms with multiple filters applied
- **Search Relevance:** Configurable ranking algorithms

## Security Considerations

### Tenant Isolation
- **Product Data:** Absolute isolation using Finbuckle filtering
- **Search Results:** Tenant-specific search indexes
- **Image Storage:** Tenant-separated file storage paths
- **Bulk Operations:** Tenant context maintained throughout

### Data Protection
- **Input Validation:** Comprehensive validation for all product data
- **File Upload Security:** Image validation and virus scanning
- **API Security:** Rate limiting and abuse prevention
- **Audit Logging:** Complete audit trail for product changes

## Testing Strategy

### Unit Testing
```csharp
[Test]
public async Task CreateProduct_WithValidData_CreatesProductForCurrentTenant()
{
    // Arrange
    var tenantContext = TenantTestHelpers.CreateMockTenantContext("tenant1");
    var service = new ProductService(tenantContext.Object, _context);
    var productRequest = new CreateProductRequest 
    { 
        Name = "Test Product", 
        Price = 29.99m,
        CategoryId = "electronics"
    };

    // Act
    var result = await service.CreateProductAsync(productRequest);

    // Assert
    result.Should().NotBeNull();
    result.Name.Should().Be("Test Product");
    
    // Verify tenant isolation
    var tenant1Products = await GetProductsForTenant("tenant1");
    var tenant2Products = await GetProductsForTenant("tenant2");
    
    tenant1Products.Should().ContainSingle(p => p.Id == result.Id);
    tenant2Products.Should().BeEmpty();
}
```

### Performance Testing
```csharp
[Test]
public async Task ProductSearch_WithLargeDataset_PerformsWithinLimits()
{
    // Arrange
    await SeedProductsForTesting(tenantId: "tenant1", productCount: 10000);
    
    var searchRequest = new ProductSearchRequest 
    { 
        SearchTerm = "phone",
        ProductTypes = new[] { ProductType.Device }
    };

    // Act
    var stopwatch = Stopwatch.StartNew();
    var results = await _searchService.SearchAsync(searchRequest);
    stopwatch.Stop();

    // Assert
    stopwatch.ElapsedMilliseconds.Should().BeLessThan(200);
    results.Data.Should().NotBeEmpty();
    results.SearchTimeMs.Should().BeLessThan(200);
}
```

## Definition of Done

### Epic Completion Criteria
- [ ] All stories implemented and tested
- [ ] Complete tenant isolation verified across all operations
- [ ] Performance requirements met for all catalog operations
- [ ] API documentation complete with examples
- [ ] Search functionality working with sub-200ms response times
- [ ] Integration tests passing with multi-tenant scenarios
- [ ] Production deployment ready

### Quality Standards
- [ ] Code review completed for all changes
- [ ] Unit test coverage > 80% for catalog module
- [ ] Performance tests meet response time requirements
- [ ] Security review completed for tenant isolation
- [ ] Load testing completed with realistic data volumes
- [ ] Documentation updated with catalog usage patterns

---

**Epic Owner:** Backend Team Lead  
**Created:** 2025-01-12  
**Target Start:** Phase 1 completion (estimated Jan 15, 2025)  
**Target Completion:** February 28, 2025