# Portfolio Terminology Guide

**Last Updated**: 2025-07-31  
**Status**: Official Naming Convention

## Overview

This document defines the official terminology used throughout the portfolio to ensure clear communication between technical teams and business stakeholders.

## Core Concepts

### 🏗️ Systems (Technical Architecture)
**Definition**: The actual codebases, repositories, and deployed services that make up our technical infrastructure.

**Examples**:
- Product Service (backend API)
- Identity Service (authentication)
- eCommerce Service (commerce APIs)
- Edge Service (BFF/GraphQL layer)
- Whitelabel Frontend (SvelteKit platform)

**Naming Pattern**: `{name}-service` or `{name}-system`

### 🎯 Product Areas (Business Capabilities)
**Definition**: Customer-facing features or business capabilities that deliver value, often spanning multiple systems.

**Examples**:
- Whitelabel eCare (customer self-service portal)
- Whitelabel Open Pages (public content/marketing)
- Whitelabel eCommerce (shopping experience)
- eCommerce Admin (brand partner management)

**Naming Pattern**: Business-friendly names describing the capability

### 📋 Projects (Work Initiatives)
**Definition**: Time-bound initiatives to build, enhance, or migrate functionality, typically spanning multiple systems.

**Examples**:
- JWT Authentication Migration
- PingFederate Enterprise SSO Integration
- Brand Configuration Centralization
- v3 Tenant Endpoints Upgrade
- eCommerce Phase 1 Launch

**Naming Pattern**: Action-oriented names describing the work

## Usage Guidelines

### When to Use Each Term

**System**: When discussing:
- Technical architecture
- API endpoints
- Database schemas
- Deployment configurations
- Code repositories

**Product Area**: When discussing:
- User experiences
- Business features
- Customer journeys
- Market offerings
- Brand capabilities

**Project**: When discussing:
- Work planning
- Resource allocation
- Timelines and milestones
- Cross-team coordination
- Implementation efforts

### Common Pitfalls to Avoid

❌ **Don't say**: "The Identity Service JWT project"  
✅ **Say**: "The JWT Authentication Migration project affecting the Identity Service"

❌ **Don't say**: "The Brand Service"  
✅ **Say**: "The Brand Configuration Centralization project" (implemented in Product Service)

❌ **Don't say**: "The Whitelabel eCare project"  
✅ **Say**: "The eCare Feature Completion project" (Whitelabel eCare is a product area)

## Quick Reference

| What You See | Type | Description |
|--------------|------|-------------|
| Product Service | System | Backend API service |
| JWT Authentication Migration | Project | Cross-system auth upgrade |
| Whitelabel eCare | Product Area | Customer self-service capability |
| PingFederate Integration | Project | Enterprise SSO implementation |
| Identity Service | System | Authentication service |
| eCommerce Admin | Product Area | Brand management interface |

---

Remember: This terminology helps us communicate clearly across technical and business teams. When in doubt, ask: "Am I talking about where code lives (System), what customers use (Product Area), or what we're building (Project)?