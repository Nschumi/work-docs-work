# Unified Authorization Solution for Mixed Endpoint Types

**Created**: 2025-07-31  
**Author**: Niclas Schumacher  
**Status**: Implementation Proposal

## Overview

This document proposes a unified authorization solution that automatically handles BrandCookie authentication for both traditional controller-based endpoints and FastEndpoints in the Product Service v3 project.

## Problem Statement

The service uses two different endpoint patterns:
1. **Controller-based endpoints**: Use `[BrandCookieAuthorize]` attribute
2. **FastEndpoints**: Use `PreProcessor<StandardBrandCookiePreprocessor<TRequest>>()` configuration

We need a unified approach that automatically detects and enforces authorization requirements without manual configuration in the authorization document.

## Proposed Solution

### 1. Authorization Detection Service

```csharp
public interface IAuthorizationDetectionService
{
    bool RequiresBrandCookieAuth(HttpContext context);
}

public class UnifiedAuthorizationDetectionService : IAuthorizationDetectionService
{
    private readonly IEndpointDataSource _endpointDataSource;
    
    public UnifiedAuthorizationDetectionService(IEndpointDataSource endpointDataSource)
    {
        _endpointDataSource = endpointDataSource;
    }
    
    public bool RequiresBrandCookieAuth(HttpContext context)
    {
        var endpoint = context.GetEndpoint();
        if (endpoint == null) return false;
        
        // Check for controller-based endpoints
        if (IsControllerEndpoint(endpoint))
        {
            return CheckControllerAuthorization(endpoint);
        }
        
        // Check for FastEndpoints
        if (IsFastEndpoint(endpoint))
        {
            return CheckFastEndpointAuthorization(endpoint);
        }
        
        return false;
    }
    
    private bool IsControllerEndpoint(Endpoint endpoint)
    {
        return endpoint.Metadata.GetMetadata<ControllerActionDescriptor>() != null;
    }
    
    private bool IsFastEndpoint(Endpoint endpoint)
    {
        // FastEndpoints typically have specific metadata
        var routePattern = endpoint.Metadata.GetMetadata<RouteEndpointDataSource>();
        return endpoint.DisplayName?.Contains("FastEndpoints") ?? false;
    }
    
    private bool CheckControllerAuthorization(Endpoint endpoint)
    {
        var actionDescriptor = endpoint.Metadata.GetMetadata<ControllerActionDescriptor>();
        if (actionDescriptor == null) return false;
        
        // Check method attributes
        bool methodHasAttribute = actionDescriptor.MethodInfo
            .GetCustomAttributes(true)
            .Any(x => x is BrandCookieAuthorizeAttribute);
            
        // Check class attributes
        bool classHasAttribute = actionDescriptor.MethodInfo.DeclaringType
            .GetCustomAttributes(true)
            .Any(x => x is BrandCookieAuthorizeAttribute);
            
        return methodHasAttribute || classHasAttribute;
    }
    
    private bool CheckFastEndpointAuthorization(Endpoint endpoint)
    {
        // FastEndpoints store preprocessor info in endpoint metadata
        var endpointMetadata = endpoint.Metadata;
        
        // Look for preprocessor metadata
        var preprocessorTypes = endpointMetadata
            .Where(m => m.GetType().IsGenericType)
            .Where(m => 
            {
                var genericDef = m.GetType().GetGenericTypeDefinition();
                return genericDef.Name.Contains("PreProcessor") || 
                       genericDef.Name.Contains("PreprocessorMetadata");
            })
            .ToList();
            
        // Check if any preprocessor is StandardBrandCookiePreprocessor
        foreach (var metadata in preprocessorTypes)
        {
            var metadataType = metadata.GetType();
            if (metadataType.GetGenericArguments().Any(arg => 
                arg.Name.Contains("StandardBrandCookiePreprocessor")))
            {
                return true;
            }
        }
        
        // Alternative: Check endpoint instance for preprocessor configuration
        var endpointInstance = endpoint.Metadata.GetMetadata<IEndpointInstance>();
        if (endpointInstance != null)
        {
            var preprocessorProperty = endpointInstance.GetType()
                .GetProperty("PreProcessors", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
                
            if (preprocessorProperty != null)
            {
                var preprocessors = preprocessorProperty.GetValue(endpointInstance) as IEnumerable;
                if (preprocessors != null)
                {
                    foreach (var preprocessor in preprocessors)
                    {
                        if (preprocessor.GetType().Name.Contains("StandardBrandCookiePreprocessor"))
                        {
                            return true;
                        }
                    }
                }
            }
        }
        
        return false;
    }
}
```

### 2. Authorization Middleware

```csharp
public class UnifiedAuthorizationMiddleware
{
    private readonly RequestDelegate _next;
    private readonly IAuthorizationDetectionService _authDetectionService;
    private readonly IBrandCookieService _brandCookieService;
    private readonly ILogger<UnifiedAuthorizationMiddleware> _logger;
    
    public UnifiedAuthorizationMiddleware(
        RequestDelegate next,
        IAuthorizationDetectionService authDetectionService,
        IBrandCookieService brandCookieService,
        ILogger<UnifiedAuthorizationMiddleware> logger)
    {
        _next = next;
        _authDetectionService = authDetectionService;
        _brandCookieService = brandCookieService;
        _logger = logger;
    }
    
    public async Task InvokeAsync(HttpContext context)
    {
        // Skip if endpoint doesn't require auth
        if (!_authDetectionService.RequiresBrandCookieAuth(context))
        {
            await _next(context);
            return;
        }
        
        // Validate brand cookie
        var brandCookie = _brandCookieService.GetBrandCookie(context);
        if (brandCookie == null || !_brandCookieService.IsValid(brandCookie))
        {
            _logger.LogWarning("Invalid or missing brand cookie for protected endpoint: {Path}", 
                context.Request.Path);
                
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("Unauthorized: Valid brand cookie required");
            return;
        }
        
        // Set brand context for downstream processing
        context.Items["BrandContext"] = brandCookie;
        context.Items["TenantId"] = brandCookie.TenantId;
        
        await _next(context);
    }
}
```

### 3. FastEndpoint Preprocessor Detection Enhancement

For more reliable FastEndpoint detection, we can create a custom attribute that gets applied during endpoint registration:

```csharp
[AttributeUsage(AttributeTargets.Class)]
public class RequiresBrandCookieAttribute : Attribute { }

// Extension method for FastEndpoints configuration
public static class FastEndpointExtensions
{
    public static TEndpoint WithBrandCookieAuth<TEndpoint>(this TEndpoint endpoint) 
        where TEndpoint : IEndpoint
    {
        endpoint.PreProcessor<StandardBrandCookiePreprocessor<EmptyRequest>>();
        
        // Add metadata for detection
        endpoint.Options(x => x.WithMetadata(new RequiresBrandCookieAttribute()));
        
        return endpoint;
    }
}

// Usage in endpoint:
public class GetProductEndpoint : Endpoint<GetProductRequest, GetProductResponse>
{
    public override void Configure()
    {
        Get("/api/v3/products/{id}");
        this.WithBrandCookieAuth(); // This adds both preprocessor and metadata
    }
}
```

### 4. Simplified Detection for FastEndpoints

With the metadata approach above, the detection becomes simpler:

```csharp
private bool CheckFastEndpointAuthorization(Endpoint endpoint)
{
    // Check for our custom attribute
    return endpoint.Metadata.GetMetadata<RequiresBrandCookieAttribute>() != null;
}
```

### 5. Service Registration

```csharp
// In Program.cs or Startup.cs
services.AddSingleton<IAuthorizationDetectionService, UnifiedAuthorizationDetectionService>();
services.AddScoped<IBrandCookieService, BrandCookieService>();

// Add middleware after routing but before authorization
app.UseRouting();
app.UseMiddleware<UnifiedAuthorizationMiddleware>();
app.UseAuthorization();
app.UseEndpoints(endpoints => { ... });
```

## Benefits

1. **Automatic Detection**: No need to manually configure authorization in a document
2. **Unified Approach**: Single middleware handles both endpoint types
3. **Type Safety**: Compile-time checking for authorization requirements
4. **Maintainability**: Authorization logic centralized in one place
5. **Flexibility**: Easy to extend for new authorization types

## Migration Strategy

1. **Phase 1**: Implement detection service and test with existing endpoints
2. **Phase 2**: Add middleware in parallel with existing authorization
3. **Phase 3**: Migrate endpoints to use the extension method pattern
4. **Phase 4**: Remove old authorization document approach

## Testing Approach

```csharp
[TestFixture]
public class AuthorizationDetectionTests
{
    [Test]
    public void Should_Detect_Controller_With_BrandCookieAuthorize()
    {
        // Arrange
        var endpoint = CreateControllerEndpoint<TestController>(
            nameof(TestController.ProtectedAction));
            
        // Act
        var requiresAuth = _service.RequiresBrandCookieAuth(CreateContext(endpoint));
        
        // Assert
        Assert.IsTrue(requiresAuth);
    }
    
    [Test]
    public void Should_Detect_FastEndpoint_With_Preprocessor()
    {
        // Arrange
        var endpoint = CreateFastEndpoint<TestFastEndpoint>();
        
        // Act  
        var requiresAuth = _service.RequiresBrandCookieAuth(CreateContext(endpoint));
        
        // Assert
        Assert.IsTrue(requiresAuth);
    }
}
```

## Conclusion

This unified approach provides automatic authorization detection for both controller-based and FastEndpoint patterns, eliminating the need for manual authorization document maintenance while maintaining security and flexibility.