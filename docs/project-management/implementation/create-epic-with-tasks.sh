#!/bin/bash
# SAGA eCommerce - Create Epic with Sub-Tasks using GitHub Task Lists
# This creates a single epic issue with tasks as checkable items

set -e

echo "🚀 Creating development setup epic with sub-tasks for SAGA eCommerce..."
echo "=================================================================="

# Configuration
REPO="Nuuday/saga-ecommerce-service"
MILESTONE="Phase 1 - Foundation"

# Check if gh is authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub. Please run: gh auth login"
    exit 1
fi

echo "📋 Creating Epic with Task List..."

# Epic: Development Environment Setup with Task List
EPIC_URL=$(gh issue create --repo "$REPO" \
  --title "[EPIC] Development Environment and Initial Setup" \
  --body "## Epic Overview
Establish the development environment and initial solution structure for the SAGA eCommerce platform.

## Business Value
Enable the 4-developer team to start building features immediately with a consistent, well-configured development environment.

## Epic Timeline
Target: End of January 2025 (2-3 weeks)

## Success Criteria
- All developers can run the application locally
- Initial solution structure is in place with modular monolith pattern
- Multi-tenant infrastructure foundation is operational
- CI/CD pipeline is functional
- First FastEndpoints are implemented and tested

## Task Breakdown

### Task 1: Development Environment Documentation
- [ ] **Create comprehensive development environment setup guide**
  - [ ] Document prerequisites (IDEs, .NET 9.0, databases)
  - [ ] Repository clone and initial setup instructions
  - [ ] Database configuration (SQL Server, Docker, PostgreSQL options)
  - [ ] IDE-specific setup instructions (VS2022, Rider, VSCode)
  - [ ] Environment configuration and secrets management
  - [ ] Build and run verification steps
  - [ ] Troubleshooting common issues section
  - [ ] Verification checklist confirms successful setup
  - [ ] Test guide with at least 2 developers
  - [ ] Optimize setup time to under 45 minutes
  - [ ] Link guide from main README
  - **Estimate:** 3 story points
  - **Target:** Next week

### Task 2: Solution Structure Creation
- [ ] **Create modular monolith solution structure with .NET 9.0**
  - [ ] Create solution file: \`saga-ecommerce-service.sln\`
  - [ ] Create Host project (Web API entry point)
  - [ ] Create Shared projects (Domain, Application, Infrastructure)
  - [ ] Create Module projects (Catalog, Channel, TenantManagement)
  - [ ] Configure project references correctly (no circular dependencies)
  - [ ] Add initial NuGet packages (FastEndpoints, EF Core, etc.)
  - [ ] Ensure consistent project naming and folder structure
  - [ ] Verify solution builds without errors
  - [ ] Ensure all projects target .NET 9.0
  - [ ] Test solution opens in all supported IDEs
  - **Estimate:** 5 story points
  - **Target:** End of next week

### Task 3: FastEndpoints Configuration
- [ ] **Configure FastEndpoints framework and sample API endpoints**
  - [ ] Install FastEndpoints NuGet package
  - [ ] Configure FastEndpoints in Program.cs with proper settings
  - [ ] Set up Swagger/OpenAPI integration
  - [ ] Configure JSON serialization options (camelCase)
  - [ ] Set up validation pipeline
  - [ ] Create sample health check endpoint
  - [ ] Create sample product endpoint for testing
  - [ ] Verify health endpoint returns 200 OK
  - [ ] Ensure Swagger UI accessible at /swagger
  - [ ] Test endpoints via curl/Postman
  - [ ] Verify API documentation visible in Swagger
  - **Estimate:** 3 story points
  - **Target:** 1 week from solution creation

### Task 4: Entity Framework and Database Setup
- [ ] **Set up Entity Framework Core with tenant-aware DbContext**
  - [ ] Create ITenantAware interface
  - [ ] Create TenantAwareDbContext base class
  - [ ] Configure connection string management
  - [ ] Implement tenant filtering in OnModelCreating
  - [ ] Set up database migration infrastructure
  - [ ] Create initial migration with sample entities
  - [ ] Configure dependency injection for DbContext
  - [ ] Test tenant filtering automatically applied to queries
  - [ ] Verify database migrations work correctly
  - [ ] Configure connection string via appsettings
  - [ ] Create sample entity with tenant isolation
  - [ ] Write integration test verifying tenant isolation
  - **Estimate:** 5 story points
  - **Target:** 2 weeks from solution creation

### Task 5: Multi-Tenant Middleware Implementation
- [ ] **Implement tenant resolution middleware for header-based multi-tenancy**
  - [ ] Create ITenantContext interface and implementation
  - [ ] Implement TenantResolutionMiddleware
  - [ ] Extract tenant from X-Tenant-Id header
  - [ ] Implement fallback to JWT claims when header not present
  - [ ] Add tenant validation (return 400 for invalid tenant)
  - [ ] Configure scoped TenantContext service for HTTP requests
  - [ ] Add configurable header name (default: X-Tenant-Id)
  - [ ] Add JWT claim name configuration (default: tenant_id)
  - [ ] Set up default tenant for development/testing
  - [ ] Write unit tests covering all resolution scenarios
  - [ ] Create integration test verifying end-to-end tenant resolution
  - [ ] Ensure sample API endpoint respects tenant context
  - **Estimate:** 5 story points
  - **Target:** 2 weeks from solution creation

### Task 6: CI/CD Pipeline Setup
- [ ] **Set up GitHub Actions CI/CD pipeline**
  - [ ] Create build workflow (.github/workflows/build.yml)
  - [ ] Configure trigger on PR and push to main
  - [ ] Set up .NET 9.0 in pipeline
  - [ ] Add restore, build, test steps
  - [ ] Configure code coverage reporting
  - [ ] Set up unit tests with coverage
  - [ ] Add integration tests with test database
  - [ ] Ensure build fails if code doesn't compile
  - [ ] Verify all tests must pass for PR approval
  - [ ] Make test results visible in GitHub interface
  - [ ] Optimize pipeline to complete in under 10 minutes
  - [ ] Configure proper status checks for branch protection
  - **Estimate:** 3 story points
  - **Target:** 3 weeks from start

## Dependencies
- GitHub repository setup ✅ (completed)
- Project management setup ✅ (completed)

## Acceptance Criteria
- [ ] All team members successfully complete environment setup
- [ ] Application runs locally for all developers
- [ ] Basic multi-tenant functionality works
- [ ] First API endpoints are callable
- [ ] Automated tests run successfully
- [ ] Deployment pipeline deploys to staging environment

## Notes
Each task can be tracked individually by checking off the items above. When all sub-tasks are complete, the epic is considered done." \
  --label "type:epic,module:infrastructure,priority:critical")

echo "✅ Epic created with task list: $EPIC_URL"

echo ""
echo "✅ =================================================="
echo "✅ Epic with sub-tasks created successfully!"
echo "✅ =================================================="
echo ""
echo "📋 Created Epic:"
echo "  Epic: $EPIC_URL"
echo ""
echo "🎯 Next Steps:"
echo "  1. Add this epic to your organization project board"
echo "  2. Set Target Date field for the epic"
echo "  3. Assign team members to the epic"
echo "  4. Check off tasks as they are completed"
echo "  5. Progress will be automatically tracked"
echo ""
echo "🚀 Your team can now start building!"