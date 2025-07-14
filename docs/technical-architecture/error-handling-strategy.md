# Error Handling Strategy for SAGA eCommerce Platform

## Overview

This document outlines the error handling approach for the SAGA eCommerce platform using the **Result Pattern** for explicit, functional error handling without exceptions for business logic and expected errors.

## Core Principles

1. **Explicit Error Handling**: Use Result<T> pattern instead of exceptions
2. **Railway-Oriented Programming**: Chain operations with clear success/failure paths
3. **Type Safety**: Errors are part of the method signature
4. **No Hidden Control Flow**: No unexpected exceptions for business logic
5. **Exceptions for Exceptional Cases Only**: Infrastructure/truly unexpected errors

## Result Pattern Implementation

### Base Result Types
```csharp
// Shared/Domain/Results/Result.cs
public readonly record struct Result<T>
{
    public T? Value { get; }
    public Error? Error { get; }
    public bool IsSuccess { get; }
    public bool IsFailure => !IsSuccess;

    private Result(T? value, Error? error, bool isSuccess)
    {
        Value = value;
        Error = error;
        IsSuccess = isSuccess;
    }

    public static Result<T> Success(T value) => new(value, null, true);
    public static Result<T> Failure(Error error) => new(default, error, false);
    
    // Functional methods
    public Result<TNew> Map<TNew>(Func<T, TNew> mapper)
        => IsSuccess ? Result<TNew>.Success(mapper(Value!)) : Result<TNew>.Failure(Error!);
        
    public Result<TNew> Bind<TNew>(Func<T, Result<TNew>> binder)
        => IsSuccess ? binder(Value!) : Result<TNew>.Failure(Error!);
}

// For operations with no return value
public readonly record struct Result
{
    public Error? Error { get; }
    public bool IsSuccess { get; }
    public bool IsFailure => !IsSuccess;
    
    private Result(Error? error, bool isSuccess)
    {
        Error = error;
        IsSuccess = isSuccess;
    }
    
    public static Result Success() => new(null, true);
    public static Result Failure(Error error) => new(error, false);
}
```

### Error Type
```csharp
// Shared/Domain/Results/Error.cs
public record Error(string Code, string Message, ErrorType Type = ErrorType.Business)
{
    public static Error NotFound(string resource, object id) 
        => new($"{resource.ToUpper()}_NOT_FOUND", $"{resource} with ID {id} not found", ErrorType.NotFound);
        
    public static Error Validation(string field, string message) 
        => new($"VALIDATION_{field.ToUpper()}", message, ErrorType.Validation);
        
    public static Error Unauthorized(string message = "Unauthorized access") 
        => new("UNAUTHORIZED", message, ErrorType.Authorization);
        
    public static Error Conflict(string code, string message) 
        => new(code, message, ErrorType.Conflict);
}

public enum ErrorType
{
    Business,
    Validation,
    NotFound,
    Authorization,
    Conflict,
    Infrastructure
}
```

## Error Categories

### 1. Domain Errors (Business Logic)
Business rule violations are returned as Result failures, not exceptions.

```csharp
// Domain method returns Result
public Result Publish()
{
    if (Status == ProductStatus.Published)
        return Result.Failure(Error.Conflict("PRODUCT_ALREADY_PUBLISHED", 
            "Product is already published and cannot be modified"));
    
    if (!HasRequiredImages())
        return Result.Failure(Error.Validation("Images", 
            "Product must have at least 2 images"));
    
    Status = ProductStatus.Published;
    PublishedAt = DateTime.UtcNow;
    
    return Result.Success();
}
```

### 2. Validation Errors
Still handled by FastEndpoints, but can also be returned as Results for complex validation.

```csharp
// Simple validation - let FastEndpoints handle
public class CreateProductValidator : Validator<CreateProductRequest>
{
    public CreateProductValidator()
    {
        RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
        RuleFor(x => x.Price).GreaterThan(0);
    }
}

// Complex business validation - use Result
public Result<Product> CreateProduct(string name, Money price, CategoryId categoryId)
{
    var validationResult = ValidateProductCreation(name, price, categoryId);
    if (validationResult.IsFailure)
        return Result<Product>.Failure(validationResult.Error!);
        
    var product = new Product(name, price, categoryId);
    return Result<Product>.Success(product);
}
```

### 3. Infrastructure Errors
These still use exceptions but are caught and converted to Results at the boundary.

```csharp
// Repository method converts exceptions to Results
public async Task<Result<Product>> GetByIdAsync(ProductId id)
{
    try
    {
        var product = await _db.Products.FindAsync(id);
        return product is null 
            ? Result<Product>.Failure(Error.NotFound("Product", id))
            : Result<Product>.Success(product);
    }
    catch (DbUpdateException ex)
    {
        _logger.LogError(ex, "Database error retrieving product {ProductId}", id);
        return Result<Product>.Failure(new Error("DATABASE_ERROR", 
            "Failed to retrieve product", ErrorType.Infrastructure));
    }
}
```

## API Error Response Format

### Standard Error Response
```json
{
  "type": "https://datatracker.ietf.org/doc/html/rfc7807",
  "title": "Validation Failed",
  "status": 400,
  "detail": "One or more validation errors occurred",
  "instance": "/api/products",
  "traceId": "00-4bf92f3577b34da6a3ce8d22e7c3af32-00",
  "errors": {
    "name": ["Product name is required"],
    "price": ["Price must be greater than zero"]
  }
}
```

### Business Error Response
```json
{
  "type": "https://saga-ecom.com/errors/product-already-published",
  "title": "Product Already Published",
  "status": 409,
  "detail": "Product with ID 12345 is already published and cannot be modified",
  "instance": "/api/products/12345/publish",
  "traceId": "00-4bf92f3577b34da6a3ce8d22e7c3af32-00",
  "code": "PRODUCT_ALREADY_PUBLISHED"
}
```

## Implementation in FastEndpoints

### 1. Result-Aware Base Endpoint
```csharp
// Shared/Infrastructure/Endpoints/ResultEndpoint.cs
public abstract class ResultEndpoint<TRequest, TResponse> : Endpoint<TRequest, TResponse>
{
    protected async Task SendResultAsync(Result<TResponse> result, CancellationToken ct = default)
    {
        if (result.IsSuccess)
        {
            await SendOkAsync(result.Value!, ct);
        }
        else
        {
            await SendErrorAsync(result.Error!, ct);
        }
    }
    
    protected async Task SendResultAsync(Result result, CancellationToken ct = default)
    {
        if (result.IsSuccess)
        {
            await SendNoContentAsync(ct);
        }
        else
        {
            await SendErrorAsync(result.Error!, ct);
        }
    }
    
    private async Task SendErrorAsync(Error error, CancellationToken ct)
    {
        var statusCode = error.Type switch
        {
            ErrorType.NotFound => 404,
            ErrorType.Validation => 400,
            ErrorType.Authorization => 403,
            ErrorType.Conflict => 409,
            _ => 400
        };
        
        AddError(error.Code, error.Message);
        await SendErrorsAsync(statusCode, ct);
    }
}
```

### 2. Using Results in Endpoints
```csharp
public class PublishProductEndpoint : ResultEndpoint<PublishProductRequest, EmptyResponse>
{
    private readonly CatalogDbContext _db;
    
    public override async Task HandleAsync(PublishProductRequest req, CancellationToken ct)
    {
        var productResult = await GetProductAsync(ProductId.From(req.Id));
        if (productResult.IsFailure)
        {
            await SendResultAsync(productResult, ct);
            return;
        }
        
        var product = productResult.Value!;
        var publishResult = product.Publish();
        
        if (publishResult.IsFailure)
        {
            await SendResultAsync(publishResult, ct);
            return;
        }
        
        await _db.SaveChangesAsync(ct);
        await SendNoContentAsync(ct);
    }
    
    private async Task<Result<Product>> GetProductAsync(ProductId id)
    {
        var product = await _db.Products
            .Where(p => p.Id == id && p.TenantId == TenantId)
            .FirstOrDefaultAsync();
            
        return product is null
            ? Result<Product>.Failure(Error.NotFound("Product", id))
            : Result<Product>.Success(product);
    }
}
```

### 3. Railway-Oriented Programming
```csharp
public class CreateOrderEndpoint : ResultEndpoint<CreateOrderRequest, CreateOrderResponse>
{
    public override async Task HandleAsync(CreateOrderRequest req, CancellationToken ct)
    {
        var result = await ValidateCustomer(req.CustomerId)
            .BindAsync(customer => ValidateProducts(req.Items))
            .BindAsync(products => CheckInventory(products))
            .BindAsync(products => CalculatePricing(products, req.DiscountCode))
            .BindAsync(pricing => CreateOrder(req, pricing))
            .MapAsync(order => new CreateOrderResponse(order.Id));
            
        await SendResultAsync(result, ct);
    }
}
```

### 4. Global Exception Handler (Only for True Exceptions)
```csharp
// Since we use Result pattern, this only catches infrastructure failures
public class GlobalExceptionHandler : IGlobalPostProcessor
{
    public Task PostProcessAsync(IPostProcessorContext context, CancellationToken ct)
    {
        if (context.HasExceptionOccurred)
        {
            var ex = context.ExceptionDispatchInfo.SourceException;
            
            // Log the exception
            context.HttpContext.Resolve<ILogger<GlobalExceptionHandler>>()
                .LogError(ex, "Unhandled exception in {Endpoint}", context.Request?.GetType().Name);
            
            // Return generic error (don't leak details in production)
            context.HttpContext.Response.StatusCode = 500;
            context.MarkExceptionAsHandled();
            
            return context.HttpContext.Response.WriteAsJsonAsync(new
            {
                type = "https://datatracker.ietf.org/doc/html/rfc7807",
                title = "Internal Server Error",
                status = 500,
                detail = context.HttpContext.Resolve<IWebHostEnvironment>().IsDevelopment() 
                    ? ex.Message 
                    : "An unexpected error occurred"
            }, ct);
        }
        
        return Task.CompletedTask;
    }
}
```

## Error Codes and HTTP Status Mapping

| Error Type | HTTP Status | Example |
|------------|-------------|---------|
| Validation Error | 400 Bad Request | Invalid input format |
| Authentication Error | 401 Unauthorized | Missing/invalid token |
| Authorization Error | 403 Forbidden | Insufficient permissions |
| Not Found | 404 Not Found | Resource doesn't exist |
| Business Rule Violation | 409 Conflict | State conflict |
| Rate Limit | 429 Too Many Requests | Rate limit exceeded |
| Server Error | 500 Internal Server Error | Unhandled exception |

## Multi-Tenant Considerations

### Tenant-Specific Errors
```csharp
public class TenantNotFoundException : ApplicationException
{
    public TenantNotFoundException(string tenantId) 
        : base("TENANT_NOT_FOUND", $"Tenant '{tenantId}' not found", 404)
    {
    }
}

public class CrossTenantAccessException : ApplicationException
{
    public CrossTenantAccessException() 
        : base("CROSS_TENANT_ACCESS", "Access to other tenant's data is forbidden", 403)
    {
    }
}
```

## Logging Strategy

### What to Log
```csharp
// Log all domain exceptions (business rule violations)
_logger.LogWarning(ex, "Domain error occurred: {Code}", ex.Code);

// Log all unhandled exceptions
_logger.LogError(ex, "Unhandled exception in {Endpoint}", GetType().Name);

// Don't log validation errors (too noisy)
// Don't log 404s (too noisy)
```

### Structured Logging
```csharp
_logger.LogError(ex, "Failed to publish product {ProductId} for tenant {TenantId}", 
    productId, tenantId);
```

## Result Pattern Extensions

### Async Extensions
```csharp
public static class ResultExtensions
{
    public static async Task<Result<TNew>> MapAsync<T, TNew>(
        this Task<Result<T>> resultTask, 
        Func<T, Task<TNew>> mapper)
    {
        var result = await resultTask;
        return result.IsSuccess 
            ? Result<TNew>.Success(await mapper(result.Value!))
            : Result<TNew>.Failure(result.Error!);
    }
    
    public static async Task<Result<TNew>> BindAsync<T, TNew>(
        this Task<Result<T>> resultTask, 
        Func<T, Task<Result<TNew>>> binder)
    {
        var result = await resultTask;
        return result.IsSuccess 
            ? await binder(result.Value!)
            : Result<TNew>.Failure(result.Error!);
    }
    
    public static async Task<Result<T>> TapAsync<T>(
        this Task<Result<T>> resultTask, 
        Func<T, Task> action)
    {
        var result = await resultTask;
        if (result.IsSuccess)
            await action(result.Value!);
        return result;
    }
}
```

### Collection Extensions
```csharp
public static class ResultCollectionExtensions
{
    public static Result<List<T>> Combine<T>(this IEnumerable<Result<T>> results)
    {
        var list = new List<T>();
        foreach (var result in results)
        {
            if (result.IsFailure)
                return Result<List<T>>.Failure(result.Error!);
            list.Add(result.Value!);
        }
        return Result<List<T>>.Success(list);
    }
    
    public static Result<List<T>> CombineWithErrors<T>(this IEnumerable<Result<T>> results)
    {
        var list = new List<T>();
        var errors = new List<Error>();
        
        foreach (var result in results)
        {
            if (result.IsSuccess)
                list.Add(result.Value!);
            else
                errors.Add(result.Error!);
        }
        
        return errors.Any()
            ? Result<List<T>>.Failure(new Error("MULTIPLE_ERRORS", 
                string.Join(", ", errors.Select(e => e.Message))))
            : Result<List<T>>.Success(list);
    }
}
```

## Testing Error Scenarios

```csharp
[Fact]
public async Task PublishProduct_AlreadyPublished_Returns409()
{
    // Arrange
    var productId = await CreatePublishedProduct();
    
    // Act
    var (response, error) = await _client.POSTAsync<PublishProductEndpoint, PublishProductRequest, ErrorResponse>(
        new PublishProductRequest(productId),
        bearerToken: AdminToken);
    
    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.Conflict);
    error.Code.Should().Be("PRODUCT_ALREADY_PUBLISHED");
}

[Fact]
public void Product_Publish_WhenAlreadyPublished_ReturnsFailure()
{
    // Arrange
    var product = new Product { Status = ProductStatus.Published };
    
    // Act
    var result = product.Publish();
    
    // Assert
    result.IsFailure.Should().BeTrue();
    result.Error!.Code.Should().Be("PRODUCT_ALREADY_PUBLISHED");
    result.Error!.Type.Should().Be(ErrorType.Conflict);
}
```

## Best Practices

### DO:
- ✅ Use Result<T> for all operations that can fail
- ✅ Return specific error codes and messages
- ✅ Chain operations with Map/Bind for clean flow
- ✅ Let FastEndpoints handle simple validation
- ✅ Convert exceptions to Results at boundaries
- ✅ Use Problem Details format for API responses
- ✅ Log infrastructure exceptions, not business errors

### DON'T:
- ❌ Don't throw exceptions for business logic
- ❌ Don't use exceptions for control flow
- ❌ Don't nest try-catch blocks
- ❌ Don't ignore Result failure cases
- ❌ Don't expose internal error details
- ❌ Don't mix Result pattern with exceptions

## Error Recovery Patterns

### 1. Retry with Exponential Backoff (For Transient Errors)
```csharp
// Use Polly for resilience
services.AddHttpClient<IPaymentService>()
    .AddPolicyHandler(GetRetryPolicy());

private static IAsyncPolicy<HttpResponseMessage> GetRetryPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .WaitAndRetryAsync(
            3,
            retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)));
}
```

### 2. Circuit Breaker (For External Services)
```csharp
services.AddHttpClient<ITcmService>()
    .AddPolicyHandler(GetCircuitBreakerPolicy());
```

### 3. Fallback Values
```csharp
try
{
    return await _inventoryService.GetStockLevel(productId);
}
catch (ServiceUnavailableException)
{
    // Return cached or default value
    return _cache.GetLastKnownStock(productId) ?? 0;
}
```

## Integration with Monitoring

### Application Insights / OpenTelemetry
```csharp
// Automatic exception tracking
services.AddApplicationInsightsTelemetry();

// Custom error metrics
_telemetryClient.TrackException(ex, new Dictionary<string, string>
{
    ["ErrorCode"] = domainEx.Code,
    ["TenantId"] = tenantId,
    ["Module"] = "Catalog"
});
```

## Implementation Decisions

### ✅ Decided:
1. **Result Pattern**: Use Result<T> for explicit error handling
2. **Error Codes**: String codes like `PRODUCT_NOT_FOUND` (self-documenting)
3. **HTTP Mapping**: ErrorType enum maps to appropriate status codes
4. **Problem Details**: RFC 7807 format for all API errors

### 🤔 Still to Decide:

1. **Result Library**: Build custom or use existing (FluentResults, ErrorOr)?
   - Custom gives us full control
   - Library saves implementation time

2. **Validation Approach**:
   - Option A: All validation returns Results
   - Option B: Simple validation via FluentValidation, complex via Results
   - Option C: Hybrid based on context

3. **Error Message Localization**:
   - English-only initially?
   - Support for multi-language from start?
   - Where to handle translation?

4. **Batch Operations**:
   ```csharp
   // Option A: Fail fast
   public Result<List<Product>> CreateProducts(List<CreateProductRequest> requests)
   
   // Option B: Partial success
   public BatchResult<Product> CreateProducts(List<CreateProductRequest> requests)
   ```

5. **Module Error Boundaries**:
   - Shared error types in Shared.Domain?
   - Module-specific error types?
   - Both with inheritance?

## Final Implementation Approach

Based on discussion, here's our approach:

1. **Vladimir Khorikov's Result Pattern** - Proven approach, well-documented
   - Consider using his `CSharpFunctionalExtensions` NuGet package
   - Or implement similar patterns based on his guidance

2. **Default Async** - Methods default to async without suffix
   ```csharp
   public static async Task<Result<TNew>> Map<T, TNew>(
       this Task<Result<T>> resultTask, 
       Func<T, Task<TNew>> mapper)
   // Not MapAsync - just Map
   ```

3. **Single Error Default** - Keep it simple
   - Most operations have one failure reason
   - Validation errors handled by FastEndpoints (returns multiple)
   - Can extend to Result<T, List<Error>> if needed later

4. **Performance** - Results are faster than exceptions
   - No stack unwinding
   - No exception object creation
   - Predictable performance
   - Better for high-throughput scenarios

## Implementation Example (Khorikov Style)

```csharp
// Shared/Domain/Results/Result.cs
public class Result
{
    public bool IsSuccess { get; }
    public Error Error { get; }
    public bool IsFailure => !IsSuccess;

    protected Result(bool isSuccess, Error error)
    {
        IsSuccess = isSuccess;
        Error = error;
    }

    public static Result Success() => new(true, Error.None);
    public static Result Failure(Error error) => new(false, error);
    
    public static Result<T> Success<T>(T value) => Result<T>.Success(value);
    public static Result<T> Failure<T>(Error error) => Result<T>.Failure(error);
}

public class Result<T> : Result
{
    public T Value { get; }

    protected internal Result(T value, bool isSuccess, Error error) 
        : base(isSuccess, error)
    {
        Value = value;
    }

    public static Result<T> Success(T value) => new(value, true, Error.None);
    public static new Result<T> Failure(Error error) => new(default!, false, error);
}

// Extension methods for railway-oriented programming
public static class ResultExtensions
{
    public static async Task<Result<K>> Map<T, K>(
        this Task<Result<T>> resultTask,
        Func<T, Task<K>> func)
    {
        var result = await resultTask;
        if (result.IsFailure)
            return Result.Failure<K>(result.Error);
            
        return Result.Success(await func(result.Value));
    }
    
    public static async Task<Result<K>> Bind<T, K>(
        this Task<Result<T>> resultTask,
        Func<T, Task<Result<K>>> func)
    {
        var result = await resultTask;
        if (result.IsFailure)
            return Result.Failure<K>(result.Error);
            
        return await func(result.Value);
    }
    
    public static async Task<Result> Tap<T>(
        this Task<Result<T>> resultTask,
        Func<T, Task> action)
    {
        var result = await resultTask;
        if (result.IsSuccess)
            await action(result.Value);
            
        return result;
    }
}
```