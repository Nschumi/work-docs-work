# JWT Authentication Migration

**Type**: Project  
**Status**: 🟢 In Progress  
**Project Lead**: Niclas Schumacher  
**Duration**: Q1-Q3 2025  

## Overview

This project migrates the platform from legacy BrandCookie authentication to modern JWT-based authentication. The migration affects all systems but is designed with a phased approach to ensure zero downtime and smooth transition for all users.

## Business Rationale

### Current Problems
- BrandCookie tied to monolithic patterns
- Session management complexity
- Limited to single domain
- No standard token format
- Difficult cross-service authentication

### JWT Benefits
- Industry standard (OAuth2)
- Stateless authentication
- Cross-domain support
- Better security controls
- Simplified service integration

## Project Phases

### Phase 1: Identity Service Enhancement (Q1 2025)
- Implement PasswordFlow for customer authentication
- JWT token generation and validation
- Maintain BrandCookie compatibility

### Phase 2: Dual Authentication Period (Q2 2025)
- Product Service v3 accepts both JWT and BrandCookie
- BrandCookie bridge for legacy flows
- Frontend gradual migration
- Monitoring and metrics

### Phase 3: Full Migration (Q3 2025)
- All services JWT-only
- BrandCookie deprecation
- Legacy cleanup

## Systems Affected

| System | Changes | Phase |
|--------|---------|-------|
| **Identity Service** | JWT generation, PasswordFlow | 1 |
| **Product Service** | JWT validation, dual-auth | 2 |
| **Edge Service** | JWT forwarding, cookie bridge | 2 |
| **Whitelabel Frontend** | Token storage, API headers | 2 |
| **Eesy BFF** | JWT validation | 2 |
| **eCommerce Service** | JWT from start | 1 |

## Technical Implementation

### JWT Structure
```json
{
  "sub": "user-id",
  "tid": "tenant-id",
  "brand": "brand-code",
  "roles": ["customer"],
  "exp": 1234567890
}
```

### Migration Flow
1. User logs in → Identity Service
2. Identity Service → Returns JWT + BrandCookie
3. Frontend stores JWT
4. API calls include JWT header
5. Services validate JWT (fall back to BrandCookie if needed)
6. Legacy order flow still gets BrandCookie via bridge

## Critical Integration: BrandCookie Bridge

Since legacy order flow requires BrandCookie:
- v3 endpoints generate BrandCookie from JWT when needed
- Temporary bridge maintains backward compatibility
- Allows gradual migration of legacy components

## Success Criteria
- ✅ Zero authentication downtime
- ✅ All services support JWT
- ✅ Legacy flows continue working
- ✅ Improved authentication performance
- ✅ Enhanced security posture

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| User session disruption | High | Dual-auth period, gradual rollout |
| Legacy system incompatibility | High | BrandCookie bridge |
| Token security | Medium | Short expiry, refresh tokens |
| Performance impact | Low | Token caching, optimization |

## Timeline
- **Jan 2025**: Identity Service PasswordFlow
- **Feb 2025**: Product Service dual-auth
- **Mar 2025**: Frontend migration start
- **May 2025**: All services JWT-enabled
- **Jul 2025**: BrandCookie deprecated

## Resources
- Security Team: 2 developers
- Backend Teams: 1 developer each
- Frontend Team: 2 developers
- QA: Comprehensive testing