# eCommerce Service

**Type**: System  
**Status**: 🟡 Early Development  
**Owner**: Commerce Team  
**Repository**: `ecommerce-service`

## Overview

The eCommerce Service provides comprehensive commerce capabilities including product catalog management, shopping cart functionality, order processing, and payment orchestration.

## Planned Architecture

### Core Modules
- **Catalog Module**: Product and pricing management
- **Basket Module**: Shopping cart with MSISDN reservation
- **Order Module**: Order lifecycle and fulfillment
- **Payment Module**: Multi-gateway payment processing

### API Structure
- **Public APIs**: Product catalog, shopping, checkout
- **Admin APIs**: Product management, order management, brand configuration
- **Integration APIs**: Legacy system synchronization

## Technology Stack
- **Framework**: .NET 9
- **Architecture**: Modular monolith
- **Database**: PostgreSQL
- **Caching**: Redis
- **Message Queue**: Azure Service Bus

## API Consumers

### Primary Consumers
- **Brand Management System**: Admin operations
- **Whitelabel Open Pages**: Product display
- **Whitelabel eCommerce**: Shopping experience
- **Edge Service**: Customer-facing APIs

## Active Projects Affecting This System

| Project | Impact | Status |
|---------|--------|--------|
| [eCommerce Phase 1](../projects/ecommerce-phase1.md) | Build catalog APIs | Starting Soon |
| [Brand Configuration API](../projects/brand-configuration-api.md) | Will consume tenant config | Future Consumer |

## Integration Requirements

### Will Integrate With
- Product Service (customer data)
- Identity Service (authentication)
- Payment gateways (Adyen, Stripe)
- Legacy TCM (product sync)
- Number Management Service
- Brand Service (when available)

### Will Provide To
- Whitelabel Open Pages (product data)
- Whitelabel eCommerce (commerce APIs)
- Edge Service (via APIs)

## Key Features (Planned)
- Multi-tenant product catalog
- Real-time inventory management
- Flexible pricing rules
- MSISDN lifecycle management
- SIM card support (pSIM/eSIM)
- Subscription management

## Success Metrics (Target)
- **API Response**: <200ms
- **Catalog Size**: 10,000+ products
- **Order Processing**: <5s end-to-end
- **Admin Operations**: <2s page load

## Documentation
- [Architecture Design](./ecommerce-service/architecture.md)
- [API Specification](./ecommerce-service/api-spec.md)
