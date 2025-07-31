# Brand Configuration API

**Type**: Project  
**Status**: 🟡 Planning  
**Project Lead**: Niclas Schumacher  
**Duration**: Q2-Q3 2025  

## Overview

This project centralizes all tenant/brand configuration by adding a Brand Service within the Product Service. Currently, tenant configuration is scattered across app settings and KeyVault in each service. This project creates a single source of truth for all tenant data, dramatically reducing onboarding time and complexity.

## Business Impact

### Current State
- Tenant configuration in each service's app settings
- Secrets in KeyVault per service
- Manual configuration for new tenants
- 2-3 days to onboard new brand
- Configuration changes require deployments

### Future State
- Centralized configuration API
- Dynamic runtime configuration
- Self-service brand management
- 30-minute onboarding
- Zero-deployment configuration changes

## Scope

### Core Deliverables
1. **Brand Service API** (in Product Service)
   - CRUD operations for brand configuration
   - Versioning and audit trail
   - Caching layer for performance

2. **Configuration Schema**
   - Tenant metadata (name, domains, etc.)
   - Service-specific settings
   - Feature flags per tenant
   - API keys and secrets management

3. **Integration SDKs**
   - .NET SDK for service integration
   - Configuration caching
   - Hot-reload capabilities

4. **Admin UI Integration**
   - Brand management in Brand Management System
   - Self-service configuration
   - Approval workflows

## Systems Affected

| System | Changes | When |
|--------|---------|------|
| **Product Service** | Add Brand Service | Phase 1 |
| **Identity Service** | Consume brand config | Phase 2 |
| **Edge Service** | Consume brand config | Phase 2 |
| **eCommerce Service** | Consume brand config | Phase 2 |
| **Eesy BFF** | Consume brand config | Phase 3 |

## Technical Architecture

```
┌─────────────────────┐
│ Brand Management    │ (Management UI)
│      System         │
└────────┬────────────┘
         │
┌────────▼────────────┐
│  Brand Service      │ (In Product Service)
│   - REST API        │
│   - Database        │
│   - Cache           │
└────────┬────────────┘
         │
    SDK Integration
         │
┌────────┴────────┬──────────────┬──────────────┐
│ Identity Service│ Edge Service │ eCommerce    │
│ (Runtime Config)│ (Runtime)    │ Service      │
└─────────────────┴──────────────┴──────────────┘
```

## Implementation Phases

### Phase 1: Core Service (Q2 2025)
- Build Brand Service in Product Service
- Design configuration schema
- Implement REST APIs
- Add caching layer

### Phase 2: Service Integration (Q2-Q3 2025)
- Create .NET SDK
- Pilot with Identity Service
- Migrate Edge Service
- Update eCommerce Service

### Phase 3: Full Migration (Q3 2025)
- Migrate remaining services
- Deprecate app settings approach
- Complete admin UI integration

## Success Metrics
- ✅ Onboarding time: 2-3 days → 30 minutes
- ✅ Configuration API response: <200ms
- ✅ 99.95% availability (critical service)
- ✅ Zero configuration-related deployments

## Dependencies
- PingFederate integration (for admin API auth)
- Brand Management System (for UI)

## Benefits
- **Development**: No more scattered configuration
- **Operations**: Centralized management
- **Business**: Rapid brand onboarding
- **Security**: Centralized secrets management

## Resources
- Backend Team: 2 developers
- Platform Team: 1 architect
- DevOps: Configuration migration support