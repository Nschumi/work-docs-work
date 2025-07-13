#!/bin/bash
# SAGA eCommerce - Create Development Setup Issues
# Run this script to populate your GitHub project with actionable work items

set -e

echo "🚀 Creating development setup issues for SAGA eCommerce..."
echo "=================================================="

# Configuration
REPO="Nuuday/saga-ecommerce-service"
MILESTONE="Phase 1 - Foundation"

# Check if gh is authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub. Please run: gh auth login"
    exit 1
fi

echo "📋 Creating Epic..."

# Epic: Development Environment Setup
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

## Child Issues
Will be created as separate issues and linked to this epic.

## Dependencies
- GitHub repository setup ✅ (completed)
- Project management setup ✅ (completed)

## Acceptance Criteria
- [ ] All team members successfully complete environment setup
- [ ] Application runs locally for all developers
- [ ] Basic multi-tenant functionality works
- [ ] First API endpoints are callable
- [ ] Automated tests run successfully
- [ ] Deployment pipeline deploys to staging environment" \
  --label "type:epic,module:infrastructure,priority:critical")

echo "✅ Epic created: $EPIC_URL"

echo "🔧 Creating Tasks..."

# Task 1: Development Environment Documentation
TASK1_URL=$(gh issue create --repo "$REPO" \
  --title "[TASK] Create comprehensive development environment setup guide" \
  --body "## Description
Create and verify a comprehensive development environment setup guide that enables new developers to get coding within 45 minutes.

## Epic
Relates to: $EPIC_URL

## Target Date
Next week

## Technical Details
### Components to Document:
1. Prerequisites (IDEs, .NET 9.0, databases)
2. Repository clone and initial setup
3. Database configuration (SQL Server, Docker, PostgreSQL options)
4. IDE-specific setup instructions
5. Environment configuration and secrets management
6. Build and run verification steps
7. Troubleshooting common issues

### Required Documentation:
- Document location: /docs/technical/development-environment-setup.md ✅ (completed)
- Include IDE-specific instructions for VS2022, Rider, VSCode
- Provide multiple database setup options (LocalDB, Docker, PostgreSQL)
- Include configuration examples and environment variables

## Acceptance Criteria
- [ ] Development environment setup guide is accessible in repository
- [ ] Guide covers .NET 9.0, IDE setup, and database configuration
- [ ] Docker-based database setup is documented
- [ ] Troubleshooting section covers common issues
- [ ] Verification checklist confirms successful setup
- [ ] At least 2 developers test the guide successfully
- [ ] Setup time measured and optimized under 45 minutes
- [ ] Guide linked from main README

## Estimate
3 story points" \
  --label "type:task,module:infrastructure,priority:high")

echo "✅ Task 1 created: $TASK1_URL"

# Task 2: Initial Solution Structure
TASK2_URL=$(gh issue create --repo "$REPO" \
  --title "[TASK] Create modular monolith solution structure with .NET 9.0" \
  --body "## Description
Create the foundational .NET solution file and project structure for the modular monolith architecture.

## Epic
Relates to: $EPIC_URL

## Target Date
End of next week

## Technical Details
### Solution Structure to Create:
\`\`\`
src/
├── Host/                    # API host with FastEndpoints
├── Shared/
│   ├── Domain/             # Common domain entities
│   ├── Application/        # Application services
│   └── Infrastructure/     # Cross-cutting infrastructure
└── Modules/
    ├── Catalog/           # Product catalog module
    ├── Channel/           # Channel management module
    └── TenantManagement/  # Multi-tenant functionality
\`\`\`

### Implementation Steps:
1. Create solution file: \`saga-ecommerce-service.sln\`
2. Create Host project (Web API)
3. Create Shared projects (Domain, Application, Infrastructure)
4. Create Module projects (Catalog, Channel, TenantManagement)
5. Configure project references correctly
6. Add initial NuGet packages

### Required NuGet Packages:
- FastEndpoints
- Microsoft.EntityFrameworkCore
- Microsoft.EntityFrameworkCore.SqlServer
- Microsoft.AspNetCore.Authentication.JwtBearer
- FluentValidation

## Acceptance Criteria
- [ ] Solution (.sln) file created with proper project structure
- [ ] Host project configured as API entry point
- [ ] Shared kernel projects for common functionality
- [ ] Module projects for Catalog, Channel, TenantManagement
- [ ] Consistent project naming and folder structure
- [ ] NuGet package references properly configured
- [ ] Project references correctly configured (no circular dependencies)
- [ ] Solution builds without errors
- [ ] All projects target .NET 9.0
- [ ] Solution can be opened in all supported IDEs

## Estimate
5 story points" \
  --label "type:task,module:infrastructure,priority:high")

echo "✅ Task 2 created: $TASK2_URL"

# Task 3: FastEndpoints and API Configuration
TASK3_URL=$(gh issue create --repo "$REPO" \
  --title "[TASK] Configure FastEndpoints framework and sample API endpoints" \
  --body "## Description
Set up FastEndpoints as the API framework in the Host project with proper configuration for the modular monolith.

## Epic
Relates to: $EPIC_URL

## Target Date
1 week from solution creation

## Technical Details
### Configuration Steps:
1. Install FastEndpoints NuGet package
2. Configure in Program.cs with proper settings
3. Set up Swagger/OpenAPI integration
4. Configure JSON serialization options
5. Set up validation pipeline
6. Create sample health check endpoint
7. Create sample product endpoint for testing

### FastEndpoints Configuration:
\`\`\`csharp
builder.Services.AddFastEndpoints();
app.UseFastEndpoints(c => {
    c.Endpoints.RoutePrefix = \"api\";
    c.Serializer.Options.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
});
\`\`\`

## Acceptance Criteria
- [ ] FastEndpoints properly configured in Program.cs
- [ ] Health endpoint returns 200 OK
- [ ] Swagger UI accessible at /swagger
- [ ] JSON responses use camelCase naming
- [ ] Validation pipeline configured
- [ ] Sample product endpoint implemented
- [ ] Endpoints can be called via curl/Postman
- [ ] API documentation visible in Swagger

## Estimate
3 story points" \
  --label "type:task,module:infrastructure,priority:high")

echo "✅ Task 3 created: $TASK3_URL"

# Task 4: Entity Framework and Database Setup
TASK4_URL=$(gh issue create --repo "$REPO" \
  --title "[TASK] Set up Entity Framework Core with tenant-aware DbContext" \
  --body "## Description
Configure Entity Framework Core with a base DbContext that supports multi-tenant data isolation.

## Epic
Relates to: $EPIC_URL

## Target Date
2 weeks from solution creation

## Technical Details
### Implementation Steps:
1. Create TenantAwareDbContext base class
2. Configure connection string management
3. Implement tenant filtering in OnModelCreating
4. Set up database migration infrastructure
5. Create initial migration with sample entities
6. Configure dependency injection

### Key Components:
\`\`\`csharp
public abstract class TenantAwareDbContext : DbContext
{
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Configure tenant isolation for all ITenantAware entities
        foreach (var entityType in modelBuilder.Model.GetEntityTypes())
        {
            if (typeof(ITenantAware).IsAssignableFrom(entityType.ClrType))
            {
                modelBuilder.Entity(entityType.ClrType)
                    .HasQueryFilter(/* tenant filter expression */);
            }
        }
    }
}
\`\`\`

### Database Configuration:
- SQL Server for initial development
- PostgreSQL compatibility for future migration
- Connection string management via configuration
- Automatic migration on startup (development only)

## Acceptance Criteria
- [ ] TenantAwareDbContext base class implemented
- [ ] ITenantAware interface defined
- [ ] Tenant filtering automatically applied to all queries
- [ ] Database migrations work correctly
- [ ] Connection string configurable via appsettings
- [ ] DbContext properly registered in DI container
- [ ] Sample entity with tenant isolation created
- [ ] Integration test verifies tenant isolation

## Estimate
5 story points" \
  --label "type:task,module:infrastructure,priority:critical")

echo "✅ Task 4 created: $TASK4_URL"

# Task 5: Multi-Tenant Middleware Implementation
TASK5_URL=$(gh issue create --repo "$REPO" \
  --title "[TASK] Implement tenant resolution middleware for header-based multi-tenancy" \
  --body "## Description
Create middleware that extracts tenant information from HTTP headers and JWT claims, making it available throughout the request lifecycle.

## Epic
Relates to: $EPIC_URL

## Target Date
2 weeks from solution creation

## Technical Details
### Middleware Components:
1. **TenantResolutionMiddleware**
   - Extract tenant from X-Tenant-Id header
   - Fallback to JWT claims if header not present
   - Validate tenant exists and is active
   - Set TenantContext for request scope

2. **ITenantContext Service**
   \`\`\`csharp
   public interface ITenantContext
   {
       string CurrentTenantId { get; }
       bool IsMultiTenant { get; }
       Task<bool> IsValidTenantAsync(string tenantId);
   }
   \`\`\`

3. **TenantContext Implementation**
   - Scoped service for current HTTP request
   - Thread-safe access to current tenant
   - Validation against tenant store

### Configuration:
- Configurable header name (default: X-Tenant-Id)
- JWT claim name for tenant (default: tenant_id)
- Default tenant for development/testing

## Acceptance Criteria
- [ ] Middleware extracts tenant from X-Tenant-Id header
- [ ] Fallback to JWT claims when header not present
- [ ] Invalid tenant returns 400 Bad Request
- [ ] TenantContext service provides current tenant info
- [ ] Unit tests cover all resolution scenarios
- [ ] Integration test verifies end-to-end tenant resolution
- [ ] Sample API endpoint respects tenant context

## Estimate
5 story points" \
  --label "type:task,module:infrastructure,priority:critical")

echo "✅ Task 5 created: $TASK5_URL"

# Task 6: CI/CD Pipeline
TASK6_URL=$(gh issue create --repo "$REPO" \
  --title "[TASK] Set up GitHub Actions CI/CD pipeline" \
  --body "## Description
Create a CI/CD pipeline that builds, tests, and deploys the application automatically on pull requests and merges.

## Epic
Relates to: $EPIC_URL

## Target Date
3 weeks from start

## Technical Details
### Pipeline Components:
1. **Build Workflow** (.github/workflows/build.yml)
   - Trigger on PR and push to main
   - .NET 9.0 setup
   - Restore, build, test
   - Code coverage reporting

2. **Test Workflow**
   - Unit tests with coverage
   - Integration tests with test database
   - Code quality checks (SonarCloud optional)

3. **Deploy Workflow** (future)
   - Deploy to staging on main branch
   - Production deployment on release tags

### Build Configuration:
\`\`\`yaml
name: Build and Test
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-dotnet@v3
      with:
        dotnet-version: '9.0.x'
    - run: dotnet restore
    - run: dotnet build --no-restore
    - run: dotnet test --no-build --verbosity normal
\`\`\`

## Acceptance Criteria
- [ ] CI pipeline runs on every PR and push
- [ ] Build fails if code doesn't compile
- [ ] All tests must pass for PR approval
- [ ] Test results visible in GitHub interface
- [ ] Pipeline completes in under 10 minutes
- [ ] Proper status checks configured for branch protection

## Estimate
3 story points" \
  --label "type:task,module:infrastructure,priority:medium")

echo "✅ Task 6 created: $TASK6_URL"

echo ""
echo "✅ =================================================="
echo "✅ All issues created successfully!"
echo "✅ =================================================="
echo ""
echo "📋 Created Issues:"
echo "  Epic: $EPIC_URL"
echo "  Task 1 (Documentation): $TASK1_URL"
echo "  Task 2 (Solution Structure): $TASK2_URL" 
echo "  Task 3 (FastEndpoints): $TASK3_URL"
echo "  Task 4 (Database/EF): $TASK4_URL"
echo "  Task 5 (Multi-tenant Middleware): $TASK5_URL"
echo "  Task 6 (CI/CD Pipeline): $TASK6_URL"
echo ""
echo "🎯 Next Steps:"
echo "  1. Add these issues to your organization project board"
echo "  2. Set Target Date field for each issue"
echo "  3. Assign team members to stories and tasks"
echo "  4. Move the first task to 'Ready' to start development"
echo ""
echo "🚀 Your team can now start building!"