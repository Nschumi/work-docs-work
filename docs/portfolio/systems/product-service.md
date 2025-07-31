# Product Service

**Type**: System  
**Status**: 🟢 Live (v2), v3 in development  
**Owner**: Platform Team  
**Repository**: `product-service`

## Overview

The Product Service is the core backend API system providing tenant management, campaign services, subscriber management, and (soon) brand configuration. It serves as the primary data source for customer and product information across the platform.

## Current Architecture

### Services Within Product Service
- **Campaign Service**: Manages marketing campaigns and offers
- **Subscriber Service**: Customer subscription management
- **Tenant Service**: Multi-tenant configuration (currently app settings)
- **Brand Service** (planned): Centralized brand/tenant configuration

### API Versions
- **v2**: Current production endpoints (BrandCookie auth)
- **v3**: Under development (JWT auth ready, enhanced performance)

## Technology Stack
- **Framework**: .NET 8/9
- **API Style**: REST (Controllers) + FastEndpoints
- **Database**: SQL Server with EF Core
- **Authentication**: BrandCookie (v2), JWT ready (v3)

## Key Features
- Multi-tenant data isolation
- Legacy TCM integration
- High-performance caching
- Comprehensive audit logging

## Active Projects Affecting This System

| Project | Impact | Status |
|---------|--------|--------|
| [v3 Tenant Endpoints Upgrade](../projects/v3-tenant-endpoints.md) | New API version with JWT auth | In Progress |
| [Brand Configuration API](../projects/brand-configuration-api.md) | Add centralized tenant config | Planning |
| [JWT Authentication Migration](../projects/jwt-authentication-migration.md) | Phase 2 adds JWT support | Planning |

## Integration Points

### Consumers
- Edge Service (BFF)
- Eesy BFF
- Identity Service
- Future: eCommerce Service

### Dependencies
- Legacy TCM system
- Identity Service (for auth)

## Operational Metrics
- **Availability**: 99.8% (last 90 days)
- **Response Time**: ~180ms average
- **Daily Requests**: 2.5M+

## Documentation
- [API Documentation](./product-service/api-docs.md)
- [Database Schema](./product-service/db-schema.md)
- [Deployment Guide](./product-service/deployment.md)