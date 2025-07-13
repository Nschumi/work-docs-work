# Multi-Tenant Testing Strategy

## Overview

This document defines the comprehensive testing strategy for the SAGA eCommerce multi-tenant platform using Finbuckle.MultiTenant. The strategy ensures tenant isolation, data security, and platform reliability across all tenant operations.

## Testing Principles

### Core Principles
1. **Tenant Isolation First:** Every test must verify tenant data separation
2. **Real-World Scenarios:** Tests mirror actual tenant usage patterns  
3. **Automated Everything:** Manual testing only for exploratory scenarios
4. **Performance Awareness:** All tests include performance considerations
5. **Security by Design:** Security testing integrated throughout

### Multi-Tenant Testing Goals
- **Zero Data Leakage:** Absolute tenant data isolation in all scenarios
- **Consistent Performance:** Performance maintained regardless of tenant count
- **Scalable Testing:** Test approach scales with platform growth
- **Comprehensive Coverage:** All tenant scenarios covered

## Testing Pyramid for Multi-Tenancy

### Unit Tests (Foundation - 60%)
**Focus:** Individual components with tenant context mocking

```csharp
[Test]
public async Task ProductService_GetProducts_ReturnsOnlyCurrentTenantProducts()
{
    // Arrange
    var tenantContext = new Mock<IMultiTenantContextAccessor<TenantInfo>>();
    tenantContext.Setup(x => x.MultiTenantContext.TenantInfo.Id).Returns("tenant1");
    
    var service = new ProductService(tenantContext.Object, _mockContext.Object);
    
    // Act
    var products = await service.GetProductsAsync();
    
    // Assert
    products.Should().OnlyContain(p => p.TenantId == "tenant1");
}
```

**Coverage Requirements:**
- Repository classes with tenant filtering
- Service classes with tenant context access
- Validation logic with tenant-specific rules
- Business logic with tenant isolation

### Integration Tests (Core - 30%)
**Focus:** API endpoints and database interactions with real tenant resolution

```csharp
[Test]
public async Task CreateProduct_WithTenantHeader_CreatesProductForCorrectTenant()
{
    // Arrange
    var request = new CreateProductRequest { Name = "Test Product", Price = 10.99m };
    
    // Act
    var response = await _client.PostAsJsonAsync("/api/catalog/products", request, 
        headers: new Dictionary<string, string> { ["X-Tenant-Id"] = "tenant1" });
    
    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.Created);
    
    // Verify tenant isolation
    var tenant1Products = await GetProductsForTenant("tenant1");
    var tenant2Products = await GetProductsForTenant("tenant2");
    
    tenant1Products.Should().ContainSingle(p => p.Name == "Test Product");
    tenant2Products.Should().BeEmpty();
}
```

**Integration Test Categories:**
- **API Endpoint Tests:** Full request/response cycle with tenant headers
- **Database Tests:** Entity Framework with Finbuckle tenant filtering
- **Service Integration:** Multiple services working together with tenant context
- **External Integration:** Third-party services with tenant-specific configuration

### End-to-End Tests (Validation - 10%)
**Focus:** Complete user journeys across multiple tenants

```csharp
[Test]
public async Task TenantAdminWorkflow_CompleteProductCatalogManagement()
{
    // Multi-step workflow test
    var tenant1Admin = await CreateTenantAdmin("tenant1");
    var tenant2Admin = await CreateTenantAdmin("tenant2");
    
    // Each admin manages their catalog independently
    await tenant1Admin.CreateCategory("Electronics");
    await tenant1Admin.CreateProduct("Laptop", "Electronics");
    
    await tenant2Admin.CreateCategory("Books");
    await tenant2Admin.CreateProduct("Novel", "Books");
    
    // Verify complete isolation
    var tenant1Catalog = await tenant1Admin.GetFullCatalog();
    var tenant2Catalog = await tenant2Admin.GetFullCatalog();
    
    tenant1Catalog.Should().ContainSingle(c => c.Name == "Electronics");
    tenant2Catalog.Should().ContainSingle(c => c.Name == "Books");
}
```

## Finbuckle-Specific Testing Patterns

### Tenant Context Testing

#### Mock Tenant Context for Unit Tests
```csharp
public static class TenantTestHelpers
{
    public static Mock<IMultiTenantContextAccessor<TenantInfo>> CreateMockTenantContext(string tenantId)
    {
        var mock = new Mock<IMultiTenantContextAccessor<TenantInfo>>();
        var tenantInfo = new TenantInfo 
        { 
            Id = tenantId, 
            Identifier = tenantId, 
            Name = $"Tenant {tenantId}" 
        };
        
        var context = new MultiTenantContext<TenantInfo> { TenantInfo = tenantInfo };
        mock.Setup(x => x.MultiTenantContext).Returns(context);
        
        return mock;
    }
}

// Usage in tests
[Test]
public async Task TestWithTenant()
{
    // Arrange
    var tenantMock = TenantTestHelpers.CreateMockTenantContext("tenant1");
    var service = new ProductService(tenantMock.Object, _context);
    
    // Test implementation
}
```

#### Integration Test Setup with Real Tenant Resolution
```csharp
public class TenantIntegrationTestBase : IClassFixture<WebApplicationFactory<Program>>
{
    protected readonly WebApplicationFactory<Program> _factory;
    protected readonly HttpClient _client;

    public TenantIntegrationTestBase(WebApplicationFactory<Program> factory)
    {
        _factory = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureServices(services =>
            {
                // Configure test-specific tenant store
                services.Configure<InMemoryStoreOptions>(options =>
                {
                    options.IsCaseSensitive = false;
                });
            });
        });
        
        _client = _factory.CreateClient();
        SeedTestTenants().Wait();
    }

    private async Task SeedTestTenants()
    {
        using var scope = _factory.Services.CreateScope();
        var tenantStore = scope.ServiceProvider.GetRequiredService<IMultiTenantStore<TenantInfo>>();
        
        await tenantStore.TryAddAsync(new TenantInfo 
        { 
            Id = "tenant1", 
            Identifier = "tenant1", 
            Name = "Test Tenant 1" 
        });
        
        await tenantStore.TryAddAsync(new TenantInfo 
        { 
            Id = "tenant2", 
            Identifier = "tenant2", 
            Name = "Test Tenant 2" 
        });
    }

    protected async Task<T> GetForTenant<T>(string endpoint, string tenantId)
    {
        _client.DefaultRequestHeaders.Clear();
        _client.DefaultRequestHeaders.Add("X-Tenant-Id", tenantId);
        
        var response = await _client.GetAsync(endpoint);
        response.EnsureSuccessStatusCode();
        
        var json = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<T>(json);
    }
}
```

### Tenant Isolation Verification Patterns

#### Cross-Tenant Data Leakage Tests
```csharp
[Test]
public async Task DataOperations_AcrossMultipleTenants_MaintainIsolation()
{
    // Create data for multiple tenants
    var tenants = new[] { "tenant1", "tenant2", "tenant3" };
    var createdItems = new Dictionary<string, List<string>>();
    
    foreach (var tenant in tenants)
    {
        var items = new List<string>();
        for (int i = 0; i < 10; i++)
        {
            var item = await CreateProductForTenant(tenant, $"Product-{tenant}-{i}");
            items.Add(item.Id);
        }
        createdItems[tenant] = items;
    }
    
    // Verify isolation for each tenant
    foreach (var tenant in tenants)
    {
        var tenantProducts = await GetProductsForTenant(tenant);
        var expectedIds = createdItems[tenant];
        
        // Should only see own products
        tenantProducts.Select(p => p.Id).Should().BeEquivalentTo(expectedIds);
        
        // Should not see other tenants' products
        var otherTenantIds = createdItems
            .Where(kvp => kvp.Key != tenant)
            .SelectMany(kvp => kvp.Value);
            
        tenantProducts.Select(p => p.Id).Should().NotIntersectWith(otherTenantIds);
    }
}
```

#### Concurrent Tenant Operations Test
```csharp
[Test]
public async Task ConcurrentTenantOperations_MaintainIsolation()
{
    var tasks = new List<Task>();
    var results = new ConcurrentDictionary<string, List<Product>>();
    
    // Simulate concurrent operations across multiple tenants
    for (int tenantNum = 1; tenantNum <= 5; tenantNum++)
    {
        var tenantId = $"tenant{tenantNum}";
        
        var task = Task.Run(async () =>
        {
            var products = new List<Product>();
            
            // Create 20 products concurrently for this tenant
            var createTasks = Enumerable.Range(1, 20).Select(async i =>
            {
                var product = await CreateProductForTenant(tenantId, $"Product-{tenantId}-{i}");
                lock (products) { products.Add(product); }
            });
            
            await Task.WhenAll(createTasks);
            results[tenantId] = products;
        });
        
        tasks.Add(task);
    }
    
    await Task.WhenAll(tasks);
    
    // Verify each tenant only sees their own data
    foreach (var kvp in results)
    {
        var tenantId = kvp.Key;
        var expectedProducts = kvp.Value;
        
        var actualProducts = await GetProductsForTenant(tenantId);
        
        actualProducts.Should().HaveSameCount(expectedProducts);
        actualProducts.Select(p => p.Name).Should().OnlyContain(name => name.Contains(tenantId));
    }
}
```

## Performance Testing for Multi-Tenancy

### Tenant Scalability Tests
```csharp
[Test]
public async Task PerformanceWith_IncreasingTenantCount_RemainsConstant()
{
    var tenantCounts = new[] { 10, 50, 100, 500 };
    var performanceResults = new List<PerformanceResult>();
    
    foreach (var tenantCount in tenantCounts)
    {
        // Setup tenants with data
        await SetupTenantsWithData(tenantCount, productsPerTenant: 100);
        
        // Measure performance
        var stopwatch = Stopwatch.StartNew();
        
        var randomTenant = $"tenant{Random.Next(1, tenantCount + 1)}";
        var products = await GetProductsForTenant(randomTenant);
        
        stopwatch.Stop();
        
        performanceResults.Add(new PerformanceResult
        {
            TenantCount = tenantCount,
            ResponseTime = stopwatch.ElapsedMilliseconds,
            DataReturned = products.Count
        });
    }
    
    // Verify performance doesn't degrade significantly
    var baselineTime = performanceResults.First().ResponseTime;
    
    foreach (var result in performanceResults.Skip(1))
    {
        var degradation = (double)result.ResponseTime / baselineTime;
        degradation.Should().BeLessThan(2.0, 
            $"Performance degraded by {degradation:P} with {result.TenantCount} tenants");
    }
}
```

### Database Query Efficiency Tests
```csharp
[Test]
public async Task DatabaseQueries_WithTenantFiltering_AreOptimized()
{
    using var scope = _factory.Services.CreateScope();
    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    
    // Enable query logging
    var queries = new List<string>();
    context.Database.Log = query => queries.Add(query);
    
    // Execute tenant-filtered query
    var tenantAccessor = scope.ServiceProvider.GetRequiredService<IMultiTenantContextAccessor<TenantInfo>>();
    SetTenantContext(tenantAccessor, "tenant1");
    
    var products = await context.Products.ToListAsync();
    
    // Verify tenant filter is applied at SQL level
    var lastQuery = queries.Last();
    lastQuery.Should().Contain("TenantId = @");
    
    // Verify query uses indexes efficiently
    lastQuery.Should().NotContain("Table Scan");
}
```

## Security Testing

### Tenant Boundary Security Tests
```csharp
[Test]
public async Task AttemptCrossTenantAccess_ShouldFail()
{
    // Create product for tenant1
    var product = await CreateProductForTenant("tenant1", "Secret Product");
    
    // Attempt to access with tenant2 context
    _client.DefaultRequestHeaders.Clear();
    _client.DefaultRequestHeaders.Add("X-Tenant-Id", "tenant2");
    
    var response = await _client.GetAsync($"/api/catalog/products/{product.Id}");
    
    // Should return 404 (not found) rather than 403 (forbidden)
    // This prevents tenant enumeration attacks
    response.StatusCode.Should().Be(HttpStatusCode.NotFound);
}

[Test]
public async Task MaliciousTenantHeader_ShouldBeRejected()
{
    var maliciousHeaders = new[]
    {
        "'; DROP TABLE Products; --",
        "../../../etc/passwd",
        "<script>alert('xss')</script>",
        "tenant1' OR '1'='1",
        null,
        "",
        "   ",
        new string('a', 1000) // Too long
    };
    
    foreach (var header in maliciousHeaders)
    {
        _client.DefaultRequestHeaders.Clear();
        if (header != null)
            _client.DefaultRequestHeaders.Add("X-Tenant-Id", header);
        
        var response = await _client.GetAsync("/api/catalog/products");
        
        response.StatusCode.Should().BeOneOf(
            HttpStatusCode.BadRequest, 
            HttpStatusCode.Unauthorized,
            $"Malicious header '{header}' was not rejected");
    }
}
```

## Test Data Management

### Tenant Test Data Strategy
```csharp
public static class TenantTestDataBuilder
{
    public static async Task<TenantTestContext> CreateTenantWithData(
        string tenantId, 
        int productCount = 10,
        int categoryCount = 3)
    {
        var context = new TenantTestContext { TenantId = tenantId };
        
        // Create categories
        for (int i = 1; i <= categoryCount; i++)
        {
            var category = await CreateCategoryForTenant(tenantId, $"Category {i}");
            context.Categories.Add(category);
        }
        
        // Create products
        for (int i = 1; i <= productCount; i++)
        {
            var category = context.Categories[i % categoryCount];
            var product = await CreateProductForTenant(tenantId, $"Product {i}", category.Id);
            context.Products.Add(product);
        }
        
        return context;
    }
    
    public static async Task CleanupTenantData(string tenantId)
    {
        // Remove all data for specific tenant
        using var scope = TestServiceProvider.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        
        // Set tenant context for cleanup
        var tenantAccessor = scope.ServiceProvider.GetRequiredService<IMultiTenantContextAccessor<TenantInfo>>();
        SetTenantContext(tenantAccessor, tenantId);
        
        // Delete all tenant data
        var products = await context.Products.ToListAsync();
        context.Products.RemoveRange(products);
        
        var categories = await context.Categories.ToListAsync();
        context.Categories.RemoveRange(categories);
        
        await context.SaveChangesAsync();
    }
}
```

## Continuous Integration Testing

### GitHub Actions Workflow for Multi-Tenant Tests
```yaml
name: Multi-Tenant Tests

on: [push, pull_request]

jobs:
  multi-tenant-tests:
    runs-on: ubuntu-latest
    
    services:
      sqlserver:
        image: mcr.microsoft.com/mssql/server:2022-latest
        env:
          SA_PASSWORD: YourStrong@Passw0rd
          ACCEPT_EULA: Y
        ports:
          - 1433:1433
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: '9.0.x'
    
    - name: Run Unit Tests
      run: dotnet test --filter Category=Unit --logger trx --collect:"XPlat Code Coverage"
    
    - name: Run Integration Tests
      run: dotnet test --filter Category=Integration --logger trx
      env:
        ConnectionStrings__DefaultConnection: "Server=localhost,1433;Database=SagaEcommerceTest;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=true;"
    
    - name: Run Multi-Tenant Isolation Tests
      run: dotnet test --filter Category=TenantIsolation --logger trx
    
    - name: Run Performance Tests
      run: dotnet test --filter Category=Performance --logger trx
    
    - name: Publish Test Results
      uses: dorny/test-reporter@v1
      if: always()
      with:
        name: Multi-Tenant Test Results
        path: '**/*.trx'
        reporter: dotnet-trx
```

## Test Categories and Attributes

### Test Classification
```csharp
// Test categories for organization
[Category("Unit")]
[Category("Integration")]
[Category("TenantIsolation")]
[Category("Performance")]
[Category("Security")]

// Example test with multiple categories
[Test]
[Category("Integration")]
[Category("TenantIsolation")]
public async Task ProductCreation_WithTenantContext_MaintainsIsolation()
{
    // Test implementation
}
```

## Monitoring and Observability Testing

### Test Observability Setup
```csharp
[Test]
public async Task TenantOperations_GenerateCorrectTelemetry()
{
    // Arrange
    var telemetryCollector = new TestTelemetryCollector();
    
    // Act
    await CreateProductForTenant("tenant1", "Test Product");
    
    // Assert
    var telemetry = telemetryCollector.GetCollectedTelemetry();
    telemetry.Should().Contain(t => 
        t.Properties.ContainsKey("TenantId") && 
        t.Properties["TenantId"] == "tenant1");
}
```

## Best Practices Summary

### Do's
- ✅ Always test tenant isolation in integration tests
- ✅ Use realistic tenant data volumes in performance tests
- ✅ Mock tenant context properly in unit tests
- ✅ Test concurrent tenant operations
- ✅ Verify SQL queries include tenant filters
- ✅ Test malicious tenant header scenarios

### Don'ts
- ❌ Don't test tenant isolation only at unit level
- ❌ Don't skip performance testing with multiple tenants
- ❌ Don't use production tenant IDs in tests
- ❌ Don't ignore cross-tenant data leakage scenarios
- ❌ Don't forget to test tenant resolution failure scenarios

---

**Document Owner:** QA/Testing Team  
**Created:** 2025-01-12  
**Review Schedule:** Monthly or when Finbuckle patterns change