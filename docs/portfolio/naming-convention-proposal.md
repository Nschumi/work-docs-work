# Portfolio Naming Convention Proposal

## Current Confusion

We're mixing different concepts:
- **Services/Systems** (e.g., Product Service, Identity Service, eCommerce Service)
- **Implementation Projects** (e.g., JWT Implementation, PingFederate Integration, Brand Service addition)
- **Product Areas** (e.g., Whitelabel eCare, Open Pages, eCommerce)

## Proposed Terminology

### 1. **Systems** (Technical Architecture Components)
- Product Service
- Identity Service
- eCommerce Service
- Edge Service (BFF)
- Whitelabel Frontend (Platform)

### 2. **Product Areas** (Business Capabilities)
- Whitelabel eCare (Customer self-service)
- Whitelabel Open Pages (Public content)
- Whitelabel eCommerce (Shopping experience)
- eCommerce Admin (Brand management)

### 3. **Projects** (Actual Work Initiatives)
These span across multiple systems/codebases:
- "JWT Authentication Migration" (touches Identity Service, Product Service, all frontends)
- "PingFederate Enterprise SSO" (touches Identity Service, affects Admin access)
- "Brand Configuration Centralization" (adds to Product Service, affects all systems)
- "v3 Tenant Endpoints Upgrade" (Product Service enhancement)

## Proposed Structure

```
Portfolio/
├── Systems/                    # Technical architecture
│   ├── product-service/
│   ├── identity-service/
│   ├── ecommerce-service/
│   └── edge-service/
│
├── Products/                   # Business capabilities
│   ├── whitelabel-ecare/
│   ├── whitelabel-openpages/
│   ├── whitelabel-ecommerce/
│   └── ecommerce-admin/
│
└── Projects/                   # Active work initiatives
    ├── jwt-authentication-migration/
    ├── pingfederate-integration/
    ├── brand-service-implementation/
    ├── v3-endpoints-upgrade/
    └── ecommerce-phase-1/

```

## Examples of How This Clarifies Things

**Current**: "Identity Service - JWT Implementation Project"
**Better**: 
- System: Identity Service
- Project: JWT Authentication Migration
- Impact: Affects Product Service, all frontend systems

**Current**: "Brand Service"
**Better**:
- Project: Brand Configuration Centralization
- Primary System: Product Service (where it lives)
- Impact: All systems consume the API

**Current**: "Whitelabel eCare"
**Better**:
- Product Area: Whitelabel eCare
- Systems Involved: Whitelabel Frontend, Edge Service, Product Service
- Current Project: "eCare Feature Completion"

## Benefits

1. **Clear separation** between what exists (systems) and what we're building (projects)
2. **Better tracking** of cross-system initiatives
3. **Business alignment** with product areas clearly defined
4. **Technical clarity** on where code changes happen

What do you think about this approach?