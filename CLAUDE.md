# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **documentation repository** for the SAGA Telecom eCommerce Module project - a multi-tenant, whitelabel telecom eCommerce platform. The repository contains project documentation, requirements specifications, and technical design documents for a C#/.NET modular monolith architecture.

**Important**: This is a documentation-only repository. There is no executable code, build processes, or test suites. All files are documentation in Markdown format.

## Repository Structure

- `SRS/` - Software Requirements Specification documents
- `charter/` - Project charter and planning documents  
- `email/` - Email correspondence and communications
- Root level: Various technical design documents and project specifications

## Project Architecture (Documentation Only)

The documented system is a C#/.NET modular monolith with the following key modules:

### Core Modules
- **Catalog Module**: Product catalog management with tenant isolation
- **Channel Module**: Digital sales channel configuration and visibility rules
- **Basket Module**: Shopping cart functionality with MSISDN reservation
- **Order Module**: Complete order lifecycle orchestration using Saga patterns
- **Payment Module**: Multi-gateway payment processing (Adyen, Stripe)
- **Number Management Module**: MSISDN lifecycle and number portability
- **Tenant Management**: Multi-tenant configuration and domain management
- **Whitelabel Frontend**: SvelteKit-based customizable storefronts

### Key Technical Concepts
- **Multi-tenancy**: Shared database with tenant isolation via TenantId patterns
- **Legacy Integration**: Integration with TCM (Telecom Customer Management) systems
- **Telecom-Specific Features**: MSISDN management, SIM card support (pSIM/eSIM), data sharing cards
- **Infrastructure**: Kubernetes deployment with .NET Aspire orchestration
- **Frontend**: SvelteKit with Contentful CMS integration for white-labeling

## Document Relationships

- `charter/project-charter.md` - High-level project scope and objectives
- `SRS/ecom-srs.md` - Detailed technical requirements and specifications
- `multi-tenant telecon ecom platform - project document.md` - Technical architecture overview
- Various design documents cover specific modules and technical aspects

## Key Stakeholders (As Documented)

- **Project Sponsor**: Lars Vieland Grasberger (Head of IT, Nuuday Mobile Partners)
- **Project Manager**: Bjørn Alsted Nielsen (Product Owner, Nuuday Mobile Partners)
- **IT Lead**: Niclas Schumacher
- **Development Team**: Infrastructure & Platform team

## Common Tasks

Since this is a documentation repository, typical tasks involve:

1. **Reading and analyzing** existing project documentation
2. **Understanding system architecture** from technical specifications
3. **Reviewing requirements** in the SRS documents
4. **Examining project scope** in charter documents
5. **Cross-referencing** information between different documents

## Project Context

This is a telecom industry project for Nuuday Mobile Partners aimed at modernizing their eCommerce platform to support multiple brand partners with whitelabel capabilities. The goal is to reduce tenant onboarding from months to 2-3 weeks through modern multi-tenant architecture.

## Current Active Tasks

**Document Improvement Initiative**: The project lead is actively working to improve two key documents:

1. **Project Charter** (`charter/project-charter.md`) - Mostly complete, needs review and refinement
2. **SRS Document** (`SRS/ecom-srs.md`) - Work in progress, needs completion and gap analysis

**Principal Engineer Perspective**: When working on these documents, act as an experienced Principal Engineer who can:
- Create documents that align business and engineering needs
- Serve as a "north star" for development teams
- Keep engineering teams on track with clear technical direction
- Balance business requirements with technical feasibility
- Provide clear architectural guidance and constraints

**Document Requirements**:
- Both documents must serve as alignment tools between business and engineering
- Must provide clear direction for development teams
- Should act as reference points to keep projects on track
- Need to balance business objectives with technical implementation details

## Working with This Repository

- All documents are in Markdown format
- Focus on understanding business requirements and technical architecture
- Cross-reference between documents for complete understanding
- Pay attention to tenant isolation and multi-tenant patterns
- Understand telecom-specific requirements (MSISDN, SIM cards, subscriptions)
- When improving documents, consider both business alignment and engineering guidance needs