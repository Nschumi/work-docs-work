# Eesy BFF

**Type**: System  
**Status**: 🟢 Live  
**Owner**: Eesy Team  
**Repository**: `eesy-bff`

## Overview

The Eesy BFF (Backend-for-Frontend) is a dedicated service layer for the Eesy brand website. Unlike the multi-tenant Edge Service used by Whitelabel brands, Eesy BFF is a standalone implementation tailored specifically for Eesy's unique requirements.

## Purpose

### Business Context
- Eesy is a standalone brand with custom requirements
- Operates independently from Whitelabel platform
- Has unique business logic and integrations
- Requires brand-specific optimizations

### Technical Goals
- Optimized API for Eesy frontend
- Custom business logic implementation
- Specialized caching strategies
- Eesy-specific integrations

## Architecture

### Core Technologies
- **Framework**: .NET 8
- **API Style**: REST with some GraphQL
- **Authentication**: JWT (migrating from BrandCookie)
- **Caching**: In-memory + Redis
- **Database**: None (API aggregator)

### Service Integrations
| Backend Service | Purpose | Protocol |
|----------------|---------|----------|
| Product Service | Customer data | REST |
| Identity Service | Authentication | REST |
| eCommerce Service | Products (future) | REST |
| Eesy Legacy Systems | Historical data | Various |

## Key Differences from Edge Service

| Aspect | Eesy BFF | Edge Service |
|--------|----------|--------------|
| Tenancy | Single-tenant | Multi-tenant |
| Technology | .NET | Node.js |
| API Style | REST-first | GraphQL |
| Customization | High | Standardized |
| Team | Eesy Team | Platform Team |

## Current Features

- Customer profile management
- Subscription handling
- Usage reporting
- Bill presentment
- Custom Eesy workflows

## Future Plans

- Complete JWT migration
- eCommerce integration
- Performance optimizations
- Microservices consideration

## Operational Metrics

- Availability: 99.7%
- Response time: 200ms avg
- Daily requests: 500K+
- Error rate: <0.1%

## Documentation
- [API Reference](./eesy-bff/api-reference.md)
- [Integration Guide](./eesy-bff/integration.md)
- [Deployment Guide](./eesy-bff/deployment.md)