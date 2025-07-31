# Whitelabel eCare

**Type**: Product Area  
**Status**: 🟢 Beta Live (3 brands)  
**Business Owner**: Customer Experience Team  
**Technical Lead**: Niclas Schumacher

## Overview

Whitelabel eCare is the self-service portal where existing customers manage their telecom subscriptions. It's one of three pillars in the Whitelabel platform, currently live in beta for Nettalk, Altibox, and Hallo brands.

## Business Value

### Customer Benefits
- View and manage subscriptions
- Check usage and billing
- Update personal information
- Order additional services
- Self-service support

### Business Benefits
- Reduced call center volume (target: 40%)
- Increased customer satisfaction
- Lower operational costs
- Upsell opportunities

## Current State

### Live Features
- ✅ Subscription overview
- ✅ Basic usage display
- ✅ Profile management
- ✅ Invoice history

### Missing Features
- ❌ Advanced usage analytics
- ❌ Self-service plan changes
- ❌ Family account management
- ❌ Payment method updates

## Systems Involved

| System | Role | Integration |
|--------|------|-------------|
| **Whitelabel Frontend** | UI/UX delivery | Primary interface |
| **Edge Service** | API gateway | GraphQL queries |
| **Product Service** | Data source | Customer/subscription data |
| **Identity Service** | Authentication | Login/session management |

## Active Projects

- **[eCare Feature Completion](../projects/ecare-feature-completion.md)** - Adding remaining functionality

## Success Metrics

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| User Adoption | 35% | 50% | 🔄 |
| Self-Service Rate | 25% | 40% | 🔄 |
| Page Load Time | 2.5s | <2s | ⚠️ |
| User Satisfaction | 3.8/5 | 4.5/5 | 🔄 |

## Roadmap

### Q1 2025
- Complete core functionality
- Performance optimization

### Q2 2025
- Advanced features
- Additional brand onboarding

### Q3 2025
- Mobile app consideration
- AI-powered support

## Brand Status

| Brand | Status | Users | Launch Date |
|-------|--------|-------|-------------|
| Nettalk | Live (Beta) | 5,000 | Dec 2024 |
| Altibox | Live (Beta) | 3,500 | Dec 2024 |
| Hallo | Live (Beta) | 2,000 | Jan 2025 |
| Others | Planned | - | Q2 2025 |