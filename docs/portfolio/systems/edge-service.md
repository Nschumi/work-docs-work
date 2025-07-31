# Edge Service

**Type**: System  
**Status**: 🟢 Live (Beta)  
**Owner**: Platform Team  
**Repository**: `edge-service`

## Overview

The Edge Service is a Backend-for-Frontend (BFF) that provides a GraphQL API layer for all Whitelabel brand frontends. It aggregates data from multiple backend services and optimizes it for frontend consumption.

## Purpose

### Business Goals
- Single API endpoint for frontends
- Optimized data fetching
- Reduced network calls
- Consistent data format
- Multi-tenant support

### Technical Benefits
- GraphQL query optimization
- Response caching
- Field-level authorization
- Request batching
- Schema stitching

## Architecture

### Core Technologies
- **Framework**: Node.js with Apollo Server
- **API Style**: GraphQL
- **Language**: TypeScript
- **Caching**: Redis
- **Monitoring**: DataDog

### Service Integrations
| Backend Service | Purpose | Protocol |
|----------------|---------|----------|
| Product Service | Customer & subscription data | REST |
| Identity Service | Authentication | REST |
| eCommerce Service | Product catalog (future) | REST |
| Content Service | CMS data | REST |

## Multi-Tenant Design

- Tenant resolution from domain/subdomain
- Tenant context propagation
- Data filtering per tenant
- Tenant-specific caching
- Configuration per brand

## GraphQL Schema

### Key Types
```graphql
type Customer {
  id: ID!
  subscriptions: [Subscription!]!
  profile: Profile!
  usage: Usage!
}

type Subscription {
  id: ID!
  plan: Plan!
  status: SubscriptionStatus!
  devices: [Device!]!
}
```

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

- Subscription support for real-time updates
- Federation with other GraphQL services
- Enhanced caching strategies
- Performance monitoring dashboard

## Documentation
- [GraphQL Schema](./edge-service/schema.md)
- [Integration Guide](./edge-service/integration.md)
- [Performance Tuning](./edge-service/performance.md)