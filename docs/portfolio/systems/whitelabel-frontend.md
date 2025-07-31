# Whitelabel Frontend

**Type**: System  
**Status**: 🟢 Live (Beta)  
**Owner**: Frontend Team  
**Repository**: `whitelabel-frontend`

## Overview

The Whitelabel Frontend is a multi-tenant SvelteKit platform that powers all customer-facing experiences for our brand partners. It delivers three distinct product areas (eCare, Open Pages, eCommerce) through a single, customizable codebase.

## Architecture

### Core Technologies
- **Framework**: SvelteKit
- **Language**: TypeScript
- **Styling**: Tailwind CSS + PostCSS
- **State Management**: Svelte Stores
- **Build Tool**: Vite
- **Testing**: Vitest + Playwright

### Multi-Tenant Design
- URL-based tenant resolution
- Dynamic theme loading
- Tenant-specific configurations
- Shared component library
- Per-brand asset management

## Product Areas

| Area | Purpose | Status |
|------|---------|--------|
| **eCare** | Customer self-service | Beta (3 brands) |
| **Open Pages** | Public content/marketing | Development |
| **eCommerce** | Shopping experience | Planned |

## Key Features

### Current
- Dynamic theming system
- Responsive design
- i18n/l10n support
- Progressive enhancement
- SEO optimization
- Performance monitoring

### Planned
- Offline support
- PWA capabilities
- Enhanced personalization
- A/B testing framework

## Brand Customization

### Theming
- CSS custom properties
- Component variants
- Layout options
- Typography systems
- Color schemes

### Configuration
- Feature flags
- Navigation structure
- Content preferences
- API endpoints
- Third-party integrations

## External Integrations

| Service | Purpose | Used By |
|---------|---------|---------|
| Edge Service | Backend data via REST APIs | All areas |
| Contentful | CMS content | Open Pages |
| Analytics | User tracking | All areas |
| CDN | Static assets | All areas |

## Performance

### Metrics
- Lighthouse Score: 92
- First Contentful Paint: 1.2s
- Time to Interactive: 2.1s
- Bundle Size: 150KB (gzipped)

### Optimization
- Code splitting
- Lazy loading
- Image optimization
- CDN integration
- Edge caching

## Deployment

- **Hosting**: Vercel/Netlify
- **CDN**: CloudFlare
- **Monitoring**: Sentry + Analytics
- **CI/CD**: GitHub Actions

## Live Brands

| Brand | Domain | Launch Date |
|-------|--------|-------------|
| Nettalk | nettalk.dk | Dec 2024 |
| Altibox | altibox.dk | Dec 2024 |
| Hallo | hallo.dk | Jan 2025 |

## Documentation
- [Development Guide](./whitelabel-frontend/dev-guide.md)
- [Component Library](./whitelabel-frontend/components.md)
- [Theming Guide](./whitelabel-frontend/theming.md)
- [Deployment Guide](./whitelabel-frontend/deployment.md)