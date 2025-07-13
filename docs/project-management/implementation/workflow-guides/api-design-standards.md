# API Design Standards for Multi-Tenant Platform

## Overview

This document establishes comprehensive API design standards for the SAGA eCommerce multi-tenant platform. All APIs must follow these standards to ensure consistency, tenant isolation, and maintainability across all modules.

## Core Principles

### Multi-Tenant First
- Every API endpoint must be tenant-aware
- Tenant context automatically managed via Finbuckle.MultiTenant
- No cross-tenant data exposure under any circumstances

### Consistency
- Uniform naming conventions across all modules
- Consistent error handling and response formats
- Standardized pagination, filtering, and sorting

### Developer Experience
- Self-documenting APIs with comprehensive OpenAPI documentation
- Predictable URL patterns and HTTP methods
- Clear validation messages and error responses

### Performance
- Efficient tenant-filtered queries
- Appropriate caching strategies
- Response time targets < 200ms for 95% of requests

## URL Structure and Naming

### Base URL Pattern
```
https://api.sagaecommerce.com/api/{module}/{resource}
```

### Module-Based Organization
```
/api/catalog/products          # Product catalog module
/api/catalog/categories        # Product categories
/api/channels/configurations   # Channel management
/api/tenants/settings         # Tenant management
/api/orders/purchases         # Order management (future)
```

### Resource Naming Conventions

#### Use Plural Nouns for Resources
```
✅ GET /api/catalog/products
✅ GET /api/catalog/categories
❌ GET /api/catalog/product
❌ GET /api/catalog/category
```

#### Use Kebab-Case for Multi-Word Resources
```
✅ GET /api/catalog/product-variants
✅ GET /api/channels/visibility-rules
❌ GET /api/catalog/productVariants
❌ GET /api/channels/visibilityRules
```

#### Nested Resources for Relationships
```
✅ GET /api/catalog/categories/{id}/products
✅ GET /api/channels/{id}/products
✅ GET /api/tenants/{id}/users
```

#### Action-Based Endpoints (When RESTful Verbs Insufficient)
```
✅ POST /api/catalog/products/{id}/publish
✅ POST /api/tenants/{id}/activate
✅ POST /api/orders/{id}/cancel
```

## HTTP Methods and Status Codes

### Standard HTTP Methods
```
GET    /api/catalog/products           # List resources
GET    /api/catalog/products/{id}      # Get specific resource
POST   /api/catalog/products           # Create new resource
PUT    /api/catalog/products/{id}      # Update entire resource
PATCH  /api/catalog/products/{id}      # Partial update
DELETE /api/catalog/products/{id}      # Delete resource
```

### HTTP Status Codes

#### Success Responses
```
200 OK                 # Successful GET, PUT, PATCH
201 Created            # Successful POST
204 No Content         # Successful DELETE, PATCH with no response body
```

#### Client Error Responses
```
400 Bad Request        # Invalid request data, validation errors
401 Unauthorized       # Missing or invalid authentication
403 Forbidden          # Valid auth but insufficient permissions
404 Not Found          # Resource doesn't exist (for current tenant)
409 Conflict           # Resource already exists or constraint violation
422 Unprocessable Entity # Validation errors with detailed messages
```

#### Server Error Responses
```
500 Internal Server Error # Unexpected server error
503 Service Unavailable   # Temporary service unavailability
```

## Request and Response Formats

### Content Type
```
Content-Type: application/json
Accept: application/json
```

### Request Headers

#### Required Headers
```
X-Tenant-Id: {tenant-identifier}    # Tenant context (handled by Finbuckle)
Content-Type: application/json      # For POST/PUT/PATCH requests
```

#### Optional Headers
```
Authorization: Bearer {jwt-token}    # Authentication when required
Accept-Language: en-US              # Localization preference
X-Correlation-Id: {uuid}            # Request tracing
```

### JSON Naming Convention
Use camelCase for all JSON properties to match JavaScript conventions:

```json
{
  "productId": "123",
  "productName": "Sample Product",
  "categoryInfo": {
    "categoryId": "456",
    "categoryName": "Electronics"
  },
  "priceDetails": {
    "basePrice": 29.99,
    "discountedPrice": 24.99
  }
}
```

## FastEndpoints Implementation Patterns

### Standard Endpoint Structure
```csharp
public class GetProductsEndpoint : Endpoint<GetProductsRequest, GetProductsResponse>
{
    private readonly IProductService _productService;
    private readonly IMultiTenantContextAccessor<TenantInfo> _tenantAccessor;

    public GetProductsEndpoint(
        IProductService productService,
        IMultiTenantContextAccessor<TenantInfo> tenantAccessor)
    {
        _productService = productService;
        _tenantAccessor = tenantAccessor;
    }

    public override void Configure()
    {
        Get("/api/catalog/products");
        AllowAnonymous(); // or Roles("TenantUser", "TenantAdmin")
        Summary(s => {
            s.Summary = "Get products for current tenant";
            s.Description = "Returns paginated list of products visible to the current tenant";
            s.ResponseExamples[200] = new GetProductsResponse
            {
                Products = new List<ProductDto>
                {
                    new ProductDto { Id = "123", Name = "Sample Product", Price = 29.99m }
                },
                TotalCount = 1,
                PageNumber = 1,
                PageSize = 20
            };
        });
    }

    public override async Task HandleAsync(GetProductsRequest req, CancellationToken ct)
    {
        // Tenant context automatically available via Finbuckle
        var tenantInfo = _tenantAccessor.MultiTenantContext?.TenantInfo;
        if (tenantInfo == null)
        {
            await SendErrorsAsync(ct);
            return;
        }

        var result = await _productService.GetProductsAsync(req, ct);
        await SendOkAsync(result, ct);
    }
}
```

### Request/Response DTOs
```csharp
// Request DTO with validation
public class CreateProductRequest
{
    [Required, MaxLength(100)]
    public string Name { get; set; } = null!;
    
    [Required]
    public string Description { get; set; } = null!;
    
    [Required, Range(0.01, double.MaxValue)]
    public decimal Price { get; set; }
    
    [Required]
    public string CategoryId { get; set; } = null!;
    
    public List<string>? Tags { get; set; }
}

// Response DTO
public class CreateProductResponse
{
    public string ProductId { get; set; } = null!;
    public string Name { get; set; } = null!;
    public decimal Price { get; set; }
    public DateTime CreatedAt { get; set; }
    public string TenantId { get; set; } = null!;
}
```

## Validation Standards

### Request Validation with FluentValidation
```csharp
public class CreateProductValidator : Validator<CreateProductRequest>
{
    public CreateProductValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Product name is required")
            .MaximumLength(100).WithMessage("Product name cannot exceed 100 characters");

        RuleFor(x => x.Price)
            .GreaterThan(0).WithMessage("Price must be greater than zero")
            .LessThan(1000000).WithMessage("Price cannot exceed 1,000,000");

        RuleFor(x => x.CategoryId)
            .NotEmpty().WithMessage("Category is required")
            .Must(BeValidCategory).WithMessage("Invalid category specified");
    }

    private bool BeValidCategory(string categoryId)
    {
        // Validate category exists for current tenant
        return true; // Implementation depends on service
    }
}
```

### Validation Error Response Format
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "Validation Error",
  "status": 422,
  "detail": "One or more validation errors occurred",
  "instance": "/api/catalog/products",
  "errors": {
    "name": ["Product name is required"],
    "price": ["Price must be greater than zero"]
  },
  "correlationId": "123e4567-e89b-12d3-a456-426614174000"
}
```

## Pagination Standards

### Query Parameters
```
GET /api/catalog/products?page=1&size=20&sort=name&direction=asc
```

### Pagination Request Parameters
```csharp
public class PaginatedRequest
{
    [Range(1, int.MaxValue)]
    public int Page { get; set; } = 1;
    
    [Range(1, 100)]
    public int Size { get; set; } = 20;
    
    public string? Sort { get; set; }
    
    [RegularExpression("^(asc|desc)$")]
    public string Direction { get; set; } = "asc";
}
```

### Pagination Response Format
```json
{
  "data": [
    {
      "productId": "123",
      "name": "Sample Product",
      "price": 29.99
    }
  ],
  "pagination": {
    "currentPage": 1,
    "pageSize": 20,
    "totalPages": 5,
    "totalItems": 100,
    "hasNextPage": true,
    "hasPreviousPage": false
  },
  "links": {
    "first": "/api/catalog/products?page=1&size=20",
    "last": "/api/catalog/products?page=5&size=20",
    "next": "/api/catalog/products?page=2&size=20",
    "previous": null
  }
}
```

## Filtering and Search Standards

### Query Parameter Conventions
```
# Simple filtering
GET /api/catalog/products?category=electronics&status=active

# Range filtering
GET /api/catalog/products?minPrice=10&maxPrice=100

# Text search
GET /api/catalog/products?search=laptop&searchFields=name,description

# Multiple values
GET /api/catalog/products?categories=electronics,computers&tags=featured
```

### Advanced Filtering
```csharp
public class ProductFilterRequest : PaginatedRequest
{
    public string? Search { get; set; }
    public List<string>? SearchFields { get; set; }
    public List<string>? Categories { get; set; }
    public decimal? MinPrice { get; set; }
    public decimal? MaxPrice { get; set; }
    public List<string>? Tags { get; set; }
    public ProductStatus? Status { get; set; }
    public DateTime? CreatedAfter { get; set; }
    public DateTime? CreatedBefore { get; set; }
}
```

## Error Handling Standards

### Problem Details Response Format (RFC 7807)
```csharp
public class ApiProblemDetails
{
    public string Type { get; set; } = null!;
    public string Title { get; set; } = null!;
    public int Status { get; set; }
    public string Detail { get; set; } = null!;
    public string Instance { get; set; } = null!;
    public string? CorrelationId { get; set; }
    public Dictionary<string, object>? Extensions { get; set; }
}
```

### Error Categories and Responses

#### Validation Errors (422)
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "Validation Error",
  "status": 422,
  "detail": "One or more validation errors occurred",
  "instance": "/api/catalog/products",
  "errors": {
    "name": ["Product name is required"],
    "price": ["Price must be greater than zero"]
  }
}
```

#### Resource Not Found (404)
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.4",
  "title": "Resource Not Found",
  "status": 404,
  "detail": "Product with ID '123' was not found",
  "instance": "/api/catalog/products/123"
}
```

#### Business Logic Error (409)
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.8",
  "title": "Business Rule Violation",
  "status": 409,
  "detail": "Cannot delete category that contains products",
  "instance": "/api/catalog/categories/456",
  "extensions": {
    "conflictType": "CategoryHasProducts",
    "productCount": 15
  }
}
```

## Authentication and Authorization

### JWT Token Structure
```json
{
  "sub": "user-123",
  "tenant_id": "tenant-456",
  "roles": ["TenantUser", "ProductManager"],
  "permissions": ["products:read", "products:write"],
  "iat": 1640995200,
  "exp": 1641081600
}
```

### Endpoint Authorization Patterns
```csharp
public override void Configure()
{
    Get("/api/catalog/products/{id}");
    
    // Public endpoint (rare)
    AllowAnonymous();
    
    // Authenticated users only
    Roles("TenantUser", "TenantAdmin");
    
    // Specific permissions
    Permissions("products:read");
    
    // Custom authorization
    Policies("RequireProductAccess");
}
```

## Versioning Strategy

### URL-Based Versioning (Recommended)
```
GET /api/v1/catalog/products
GET /api/v2/catalog/products
```

### Header-Based Versioning (Alternative)
```
GET /api/catalog/products
X-API-Version: 1.0
```

### Version Management
```csharp
[Route("/api/v{version:apiVersion}/catalog/products")]
[ApiVersion("1.0")]
[ApiVersion("2.0")]
public class GetProductsEndpoint : Endpoint<GetProductsRequest, GetProductsResponse>
{
    public override async Task HandleAsync(GetProductsRequest req, CancellationToken ct)
    {
        var version = HttpContext.GetRequestedApiVersion();
        
        if (version?.MajorVersion == 2)
        {
            // Handle v2 logic
        }
        else
        {
            // Handle v1 logic (default)
        }
    }
}
```

## Caching Strategies

### Response Caching Headers
```csharp
public override void Configure()
{
    Get("/api/catalog/products/{id}");
    
    // Cache for 5 minutes, but allow stale data for 1 hour if server is unavailable
    Options(x => x.WithHeaders(h => {
        h.CacheControl = "public, max-age=300, stale-while-revalidate=3600";
        h.ETag = true; // Enable ETag support
    }));
}
```

### Tenant-Aware Caching
```csharp
public async Task<ProductDto> GetProductAsync(string productId)
{
    var tenantId = _tenantAccessor.MultiTenantContext?.TenantInfo?.Id;
    var cacheKey = $"product:{tenantId}:{productId}";
    
    return await _cache.GetOrCreateAsync(cacheKey, async factory =>
    {
        factory.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(15);
        return await _repository.GetProductAsync(productId);
    });
}
```

## OpenAPI Documentation Standards

### Endpoint Documentation
```csharp
public override void Configure()
{
    Get("/api/catalog/products");
    Summary(s => {
        s.Summary = "Get products for current tenant";
        s.Description = @"
            Returns a paginated list of products visible to the current tenant.
            Results are filtered by tenant context and user permissions.
            
            **Tenant Context**: Products are automatically filtered by X-Tenant-Id header.
            **Permissions**: Requires 'products:read' permission or 'TenantUser' role.
        ";
        
        s.Params["page"] = "Page number (1-based)";
        s.Params["size"] = "Number of items per page (max 100)";
        s.Params["search"] = "Search term for product name or description";
        
        s.ResponseExamples[200] = new GetProductsResponse
        {
            Data = new List<ProductDto>
            {
                new ProductDto 
                { 
                    ProductId = "123", 
                    Name = "Sample Product", 
                    Price = 29.99m,
                    CategoryName = "Electronics"
                }
            },
            Pagination = new PaginationInfo
            {
                CurrentPage = 1,
                PageSize = 20,
                TotalPages = 5,
                TotalItems = 100
            }
        };
        
        s.ResponseExamples[400] = new ApiProblemDetails
        {
            Type = "https://tools.ietf.org/html/rfc7231#section-6.5.1",
            Title = "Bad Request",
            Status = 400,
            Detail = "Invalid pagination parameters"
        };
    });
}
```

## Performance Guidelines

### Response Time Targets
- **Simple Queries:** < 100ms (95th percentile)
- **Complex Queries:** < 200ms (95th percentile)
- **Write Operations:** < 300ms (95th percentile)

### Database Query Optimization
```csharp
// Efficient tenant-filtered queries
public async Task<List<Product>> GetProductsAsync(ProductFilterRequest request)
{
    var query = _context.Products
        .Where(p => p.IsActive) // Finbuckle automatically adds tenant filter
        .Include(p => p.Category)
        .AsQueryable();
    
    if (!string.IsNullOrEmpty(request.Search))
    {
        query = query.Where(p => 
            EF.Functions.Contains(p.Name, request.Search) ||
            EF.Functions.Contains(p.Description, request.Search));
    }
    
    if (request.Categories?.Any() == true)
    {
        query = query.Where(p => request.Categories.Contains(p.CategoryId));
    }
    
    return await query
        .OrderBy(p => p.Name)
        .Skip((request.Page - 1) * request.Size)
        .Take(request.Size)
        .ToListAsync();
}
```

## Security Standards

### Input Sanitization
```csharp
public class ProductValidator : Validator<CreateProductRequest>
{
    public ProductValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(100)
            .Must(BeValidProductName).WithMessage("Product name contains invalid characters");
    }
    
    private bool BeValidProductName(string name)
    {
        // Prevent XSS and injection attacks
        var invalidChars = new[] { '<', '>', '"', '\'', '&' };
        return !name.Any(c => invalidChars.Contains(c));
    }
}
```

### Tenant Isolation Verification
```csharp
public override async Task HandleAsync(GetProductRequest req, CancellationToken ct)
{
    var tenantInfo = _tenantAccessor.MultiTenantContext?.TenantInfo;
    if (tenantInfo == null)
    {
        await SendUnauthorizedAsync(ct);
        return;
    }
    
    var product = await _productService.GetProductAsync(req.ProductId);
    if (product == null)
    {
        // Return 404 instead of 403 to prevent tenant enumeration
        await SendNotFoundAsync(ct);
        return;
    }
    
    await SendOkAsync(product.ToDto(), ct);
}
```

## Testing API Standards

### API Test Example
```csharp
[Test]
public async Task GetProducts_WithValidTenant_ReturnsProducts()
{
    // Arrange
    var tenant = await CreateTestTenant("test-tenant");
    await CreateTestProducts(tenant.Id, count: 5);
    
    // Act
    var response = await _client.GetAsync("/api/catalog/products", 
        headers: new { "X-Tenant-Id": tenant.Id });
    
    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.OK);
    
    var result = await response.Content.ReadFromJsonAsync<GetProductsResponse>();
    result.Data.Should().HaveCount(5);
    result.Pagination.TotalItems.Should().Be(5);
    
    // Verify all products belong to correct tenant
    result.Data.Should().OnlyContain(p => p.TenantId == tenant.Id);
}
```

---

**Document Owner:** API Architecture Team  
**Created:** 2025-01-12  
**Review Schedule:** Monthly or when new modules are added  
**Compliance Required:** All new APIs must follow these standards