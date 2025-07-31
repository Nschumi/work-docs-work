# Edge Service

**Type**: System  
**Status**: 🟢 Live (Beta)  
**Owner**: Platform Team  
**Repository**: `edge-service`

## Overview

The Edge Service is a Backend-for-Frontend (BFF) that provides an optimized API layer for all Whitelabel brand frontends. It aggregates data from multiple backend services and transforms it for efficient frontend consumption.

## Purpose

### Business Goals
- Single API endpoint for frontends
- Optimized data fetching
- Reduced network calls
- Consistent data format
- Multi-tenant support

### Technical Benefits
- Response optimization
- Response caching  
- Request aggregation
- Data transformation
- Reduced network calls

## Architecture

### Core Technologies
- **Framework**: Node.js/Express
- **API Style**: REST
- **Language**: TypeScript
- **Caching**: Redis
- **Monitoring**: DataDog

### Service Integrations
| Backend Service | Purpose | Protocol |
|----------------|---------|----------|
| Product Service | Customer & subscription data | REST |
| Identity Service | Authentication | REST |
| eCommerce Service | Product catalog (future) | REST |

## Multi-Tenant Design

- Tenant resolution from domain/subdomain
- Tenant context propagation
- Data filtering per tenant
- Tenant-specific caching
- Configuration per brand

## API Design

### Key Endpoints
- `GET /api/customer/:id` - Customer details with subscriptions
- `GET /api/subscriptions` - List customer subscriptions
- `GET /api/usage/:subscriptionId` - Usage data
- `GET /api/profile` - Customer profile
- `POST /api/profile` - Update profile

## Performance

- Average response time: 150ms
- Cache hit rate: 75%
- Requests/day: 1M+
- Availability: 99.8%

## Security

- JWT validation
- Field-level permissions
- Rate limiting per tenant
- Query depth limiting
- Request logging

## Future Enhancements

- WebSocket support for real-time updates
- GraphQL consideration for complex queries
- Enhanced caching strategies
- Performance monitoring dashboard

## Documentation
- [API Reference](./edge-service/api-reference.md)
- [Integration Guide](./edge-service/integration.md)
- [Performance Tuning](./edge-service/performance.md)