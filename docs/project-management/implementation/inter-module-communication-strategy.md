# Inter-Module Communication Strategy

## Overview

This document presents communication strategy options for the SAGA Telecom eCommerce modular monolith, considering your requirements for in-process communication while maintaining clean module boundaries and testability.

## Key Requirements from Questionnaire

- **In-process communication** (single deployment unit)
- **Modular monolith architecture** with clear boundaries
- **4-developer team** with varying TDD preferences
- **FastEndpoints** for external APIs
- **Prototype first, iterate** development approach
- **Multi-tenant context** must flow through all communications

## Communication Strategy Options

### Option 1: Hybrid Approach (Recommended)

**Pattern:** Direct injection for queries, MediatR for commands and events

```csharp
// Query (read operations) - Direct service injection
public class ProductController 
{
    private readonly IProductService _productService;
    
    public async Task<ProductDto> GetProduct(Guid id)
    {
        return await _productService.GetProductAsync(id);
    }
}

// Command (write operations) - MediatR
public class CreateOrderController
{
    private readonly IMediator _mediator;
    
    public async Task<OrderDto> CreateOrder(CreateOrderCommand command)
    {
        return await _mediator.Send(command);
    }
}

// Cross-module events - MediatR notifications
public class OrderCreatedHandler : INotificationHandler<OrderCreatedEvent>
{
    public async Task Handle(OrderCreatedEvent notification, CancellationToken cancellationToken)
    {
        // Update inventory, send notifications, etc.
    }
}
```

**Pros:**
- Simple queries with direct injection (fast, easy to debug)
- Structured commands with validation and business logic
- Loose coupling for cross-module events
- Easy to test and mock
- Gradual adoption path

**Cons:**
- Mixed patterns to learn
- Requires discipline to follow conventions

### Option 2: MediatR-First Approach

**Pattern:** All inter-module communication through MediatR

```csharp
// All operations go through MediatR
public class ProductController 
{
    private readonly IMediator _mediator;
    
    public async Task<ProductDto> GetProduct(Guid id)
    {
        return await _mediator.Send(new GetProductQuery(id));
    }
    
    public async Task<ProductDto> CreateProduct(CreateProductCommand command)
    {
        return await _mediator.Send(command);
    }
}
```

**Pros:**
- Consistent communication pattern
- Built-in validation and behavior pipeline
- Easy cross-cutting concerns (logging, caching, authorization)
- Excellent for CQRS
- Strong decoupling

**Cons:**
- Overhead for simple queries
- More complex for straightforward operations
- Steeper learning curve

### Option 3: Service Layer with Events

**Pattern:** Direct service injection with domain events

```csharp
// Service layer with events
public class OrderService : IOrderService
{
    private readonly IOrderRepository _repository;
    private readonly IDomainEventDispatcher _eventDispatcher;
    
    public async Task<Order> CreateOrderAsync(CreateOrderRequest request)
    {
        var order = Order.Create(request);
        await _repository.SaveAsync(order);
        
        // Dispatch events for cross-module communication
        await _eventDispatcher.DispatchAsync(new OrderCreatedEvent(order.Id));
        
        return order;
    }
}
```

**Pros:**
- Simple, direct communication
- Domain-driven design aligned
- Easy to understand and debug
- Minimal overhead

**Cons:**
- Tighter coupling between modules
- Manual event management
- Less standardized validation/pipeline

## Recommended Architecture: Hybrid Approach

### Communication Rules

1. **Queries (Read Operations)**
   - Use direct service injection
   - Return DTOs, never domain entities
   - Keep interfaces in shared contracts

2. **Commands (Write Operations)**
   - Use MediatR commands
   - Include validation and business rules
   - Return operation results or DTOs

3. **Cross-Module Events**
   - Use MediatR notifications
   - Async processing
   - Fire-and-forget or eventual consistency

4. **Internal Module Operations**
   - Direct service calls within same module
   - Domain services and repositories

### Module Structure

```
src/
├── Shared/
│   ├── SagaEcom.SharedKernel/
│   │   ├── Abstractions/         # Common interfaces
│   │   ├── Events/               # Domain events
│   │   └── Communication/        # Communication contracts
│   └── SagaEcom.Infrastructure/
│       ├── Communication/        # MediatR setup, event dispatcher
│       └── MultiTenancy/         # Tenant context flow
├── Modules/
│   ├── Catalog/
│   │   ├── Domain/               # Entities, value objects
│   │   ├── Application/
│   │   │   ├── Queries/          # Direct service calls
│   │   │   ├── Commands/         # MediatR commands
│   │   │   └── Events/           # Event handlers
│   │   ├── Infrastructure/       # Repositories, external services
│   │   └── Api/                  # FastEndpoints
│   └── [Other Modules]/
```

### Implementation Examples

#### 1. Query Service (Direct Injection)

```csharp
// Shared contract
public interface IProductQueryService
{
    Task<ProductDto?> GetProductAsync(Guid productId);
    Task<PagedResult<ProductDto>> GetProductsAsync(ProductFilter filter);
}

// Implementation in Catalog module
public class ProductQueryService : IProductQueryService
{
    private readonly IProductRepository _repository;
    private readonly ITenantContext _tenantContext;
    
    public async Task<ProductDto?> GetProductAsync(Guid productId)
    {
        var product = await _repository.GetByIdAsync(productId);
        return product?.ToDto();
    }
}

// Usage in other modules
public class BasketService
{
    private readonly IProductQueryService _productQuery;
    
    public async Task AddItemAsync(Guid productId, int quantity)
    {
        var product = await _productQuery.GetProductAsync(productId);
        // Add to basket logic
    }
}
```

#### 2. Command with MediatR

```csharp
// Command
public record CreateProductCommand(
    string Name,
    string Description,
    decimal Price,
    string Category
) : IRequest<ProductDto>;

// Handler
public class CreateProductHandler : IRequestHandler<CreateProductCommand, ProductDto>
{
    private readonly IProductRepository _repository;
    private readonly ITenantContext _tenantContext;
    private readonly IMediator _mediator;
    
    public async Task<ProductDto> Handle(CreateProductCommand request, CancellationToken cancellationToken)
    {
        var product = Product.Create(
            request.Name, 
            request.Description, 
            request.Price, 
            request.Category,
            _tenantContext.TenantId
        );
        
        await _repository.SaveAsync(product);
        
        // Publish event for other modules
        await _mediator.Publish(new ProductCreatedEvent(product.Id, product.Name));
        
        return product.ToDto();
    }
}
```

#### 3. Cross-Module Event

```csharp
// Event
public record ProductCreatedEvent(Guid ProductId, string ProductName) : INotification;

// Handler in Channel module
public class ProductCreatedHandler : INotificationHandler<ProductCreatedEvent>
{
    private readonly IChannelRepository _channelRepository;
    
    public async Task Handle(ProductCreatedEvent notification, CancellationToken cancellationToken)
    {
        // Update channel visibility rules
        await _channelRepository.UpdateProductVisibilityAsync(notification.ProductId);
    }
}
```

### Multi-Tenant Context Flow

```csharp
// Tenant-aware base handler
public abstract class TenantAwareRequestHandler<TRequest, TResponse> 
    : IRequestHandler<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
{
    protected readonly ITenantContext TenantContext;
    
    protected TenantAwareRequestHandler(ITenantContext tenantContext)
    {
        TenantContext = tenantContext;
    }
    
    public abstract Task<TResponse> Handle(TRequest request, CancellationToken cancellationToken);
}

// Usage
public class CreateProductHandler : TenantAwareRequestHandler<CreateProductCommand, ProductDto>
{
    public CreateProductHandler(ITenantContext tenantContext, IProductRepository repository) 
        : base(tenantContext)
    {
        _repository = repository;
    }
    
    public override async Task<ProductDto> Handle(CreateProductCommand request, CancellationToken cancellationToken)
    {
        // TenantContext automatically available
        var product = Product.Create(request.Name, TenantContext.TenantId);
        // ...
    }
}
```

### Configuration and Setup

```csharp
// Program.cs
builder.Services.AddMediatR(cfg => 
{
    cfg.RegisterServicesFromAssemblies(
        typeof(CatalogModule).Assembly,
        typeof(ChannelModule).Assembly,
        typeof(BasketModule).Assembly
    );
    
    // Add behaviors
    cfg.AddBehavior<ValidationBehavior>();
    cfg.AddBehavior<TenantContextBehavior>();
    cfg.AddBehavior<LoggingBehavior>();
});

// Register query services
builder.Services.AddScoped<IProductQueryService, ProductQueryService>();
builder.Services.AddScoped<IChannelQueryService, ChannelQueryService>();

// Module registration
builder.Services.AddModule<CatalogModule>();
builder.Services.AddModule<ChannelModule>();
```

### Testing Strategy

```csharp
// Testing queries (simple)
[Test]
public async Task GetProduct_ShouldReturnProduct_WhenExists()
{
    var service = new ProductQueryService(_mockRepository.Object, _mockTenantContext.Object);
    var result = await service.GetProductAsync(productId);
    
    result.Should().NotBeNull();
    result.Name.Should().Be(expectedName);
}

// Testing commands (with MediatR)
[Test]
public async Task CreateProduct_ShouldCreateAndPublishEvent()
{
    var handler = new CreateProductHandler(_mockRepository.Object, _mockTenantContext.Object, _mockMediator.Object);
    var command = new CreateProductCommand("Test Product", "Description", 10.99m, "Category");
    
    var result = await handler.Handle(command, CancellationToken.None);
    
    _mockRepository.Verify(r => r.SaveAsync(It.IsAny<Product>()), Times.Once);
    _mockMediator.Verify(m => m.Publish(It.IsAny<ProductCreatedEvent>(), It.IsAny<CancellationToken>()), Times.Once);
}
```

## Migration Path

### Phase 1: Foundation
1. Set up MediatR infrastructure
2. Create base classes and interfaces
3. Implement tenant context flow

### Phase 2: Commands First
1. Implement write operations with MediatR
2. Add validation and business logic
3. Set up cross-module events

### Phase 3: Query Services
1. Create query service interfaces
2. Implement direct injection for reads
3. Optimize performance

### Phase 4: Refinement
1. Add caching to query services
2. Optimize event handling
3. Add advanced behaviors (retry, circuit breaker)

## Performance Considerations

**Query Performance:**
- Direct injection avoids MediatR overhead
- Enable query result caching
- Use read-only database connections

**Command Performance:**
- MediatR pipeline is lightweight
- Async event processing
- Batch operations where possible

**Memory:**
- Scoped services per request
- Avoid holding large objects in handlers
- Use streaming for large data sets

## Decision Matrix

| Scenario | Recommended Pattern | Rationale |
|----------|-------------------|-----------|
| Simple data retrieval | Direct service injection | Fast, simple, easy to debug |
| Complex business operation | MediatR command | Validation, business rules, events |
| Cross-module notification | MediatR event | Loose coupling, async processing |
| Real-time queries | Direct service with caching | Performance critical |
| Bulk operations | MediatR with custom behavior | Transaction management, error handling |

## Conclusion

The hybrid approach provides the best balance for your team:

✅ **Aligns with your preferences:**
- In-process communication
- Easy to test and develop
- Supports both TDD and traditional approaches
- Clear boundaries between modules

✅ **Supports your timeline:**
- Start simple with direct injection
- Add MediatR complexity where needed
- Easy to prototype and iterate

✅ **Scales with your team:**
- Clear patterns for 4 developers
- Easy to onboard new team members
- Consistent but not overly complex

This strategy supports your October 2025 delivery timeline while maintaining the architectural flexibility needed for the full platform implementation.