# Identity Service

**Type**: System  
**Status**: 🟢 Live  
**Owner**: Security Team  
**Repository**: `identity-service`

## Overview

The Identity Service provides centralized authentication and authorization for all platform systems. It handles both customer authentication (via MitID/Signicat) and service-to-service authentication using OAuth2.

## Current Architecture

### Core Capabilities
- **Customer Authentication**: MitID integration via Signicat
- **Service Authentication**: OAuth2 for inter-service communication
- **Token Management**: JWT issuance and validation
- **Session Management**: Currently via BrandCookie (migrating to JWT)

### Authentication Flows
1. **Customer Login**: MitID → Signicat → Identity Service → JWT/BrandCookie
2. **Service-to-Service**: Client credentials flow with service tokens
3. **Employee Login** (planned): PingFederate integration for M-numbers

## Technology Stack
- **Framework**: .NET 8
- **Protocols**: OAuth2, OpenID Connect, SAML (planned)
- **Token Format**: JWT (RS256)
- **External Providers**: Signicat, PingFederate (planned)

## Active Projects Affecting This System

| Project | Impact | Status |
|---------|--------|--------|
| [JWT Authentication Migration](../projects/jwt-authentication-migration.md) | Implement PasswordFlow for customer JWT | In Progress |
| [PingFederate Integration](../projects/pingfederate-integration.md) | Add enterprise SSO for employees | Planning |

## Integration Points

### Consumers
- All frontend applications
- All backend services
- Edge Service (BFF)
- Eesy BFF

### External Dependencies
- Signicat (MitID provider)
- PingFederate (planned)
- Nuuday IAM (via PingFederate)

## Security Considerations
- Token lifetime: 15min (access), 7d (refresh)
- Encryption: TLS 1.3 for all communications
- Key rotation: Monthly for signing keys
- Audit: All authentication events logged

## Operational Metrics
- **Availability**: 99.95% (critical service)
- **Auth Time**: <500ms average
- **Daily Authentications**: 50K+

## Documentation
- [Integration Guide](./identity-service/integration-guide.md)
- [Security Architecture](./identity-service/security-arch.md)
- [Token Specification](./identity-service/token-spec.md)