# GitHub Issues Creation Script for Development Setup

## Overview

This document contains the GitHub CLI commands to create issues for the initial development phase. Run these commands to populate your project board with actionable work items.

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated
- Repository: `Nuuday/saga-ecommerce-service` accessible
- Project board created and linked to repository

## Epic: Development Environment Setup

### Create the Epic Issue

```bash
gh issue create \
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
- [ ] Development environment setup guide implementation
- [ ] Initial solution structure creation
- [ ] Multi-tenant infrastructure foundation
- [ ] FastEndpoints integration setup
- [ ] CI/CD pipeline configuration
- [ ] Database setup and migrations
- [ ] Initial testing framework setup

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
  --label "type:epic,module:infrastructure,priority:critical" \
  --assignee "@me"
```

## Story 1: Development Environment Documentation

```bash
gh issue create \
  --title "[STORY] As a developer I want clear setup instructions so that I can configure my local environment quickly" \
  --body "## User Story
As a **new team developer**  
I want **comprehensive setup instructions with troubleshooting**  
So that **I can get coding within 45 minutes without asking for help**

## Epic
Relates to: Development Environment and Initial Setup Epic

## Target Date
Next week

## Acceptance Criteria
- [ ] Development environment setup guide is accessible in repository
- [ ] Guide covers .NET 9.0, IDE setup, and database configuration
- [ ] Docker-based database setup is documented
- [ ] Troubleshooting section covers common issues
- [ ] Verification checklist confirms successful setup
- [ ] All 4 developers can complete setup successfully

## Technical Implementation Notes
- Document should be in /docs/technical/development-environment-setup.md ✅ (completed)
- Include IDE-specific instructions for VS2022, Rider, VSCode
- Provide multiple database setup options (LocalDB, Docker, PostgreSQL)
- Include configuration examples and environment variables

## Definition of Done
- [ ] Documentation written and reviewed
- [ ] At least 2 developers test the guide successfully
- [ ] Common issues identified and documented
- [ ] Setup time measured and optimized
- [ ] Guide linked from main README" \
  --label "type:story,module:infrastructure,priority:high" \
  --milestone "Phase 1 - Foundation"
```

## Story 2: Initial Solution Structure

```bash
gh issue create \
  --title "[STORY] As a developer I want a modular monolith solution structure so that I can build features in isolated modules" \
  --body "## User Story
As a **backend developer**  
I want **a well-organized solution structure with clear module boundaries**  
So that **I can develop features without conflicts and maintain code quality**

## Epic
Relates to: Development Environment and Initial Setup Epic

## Target Date
End of next week

## Acceptance Criteria
- [ ] Solution (.sln) file created with proper project structure
- [ ] Host project configured as API entry point
- [ ] Shared kernel project for common functionality
- [ ] Module projects for Catalog, Channel, TenantManagement
- [ ] Consistent project naming and folder structure
- [ ] NuGet package references properly configured
- [ ] Build succeeds without errors

## Technical Implementation Notes
### Solution Structure:
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

### Key Requirements:
- .NET 9.0 project templates
- FastEndpoints NuGet package
- Entity Framework Core packages
- Shared project references configured correctly

## Definition of Done
- [ ] Solution builds successfully
- [ ] All projects follow naming conventions
- [ ] Module isolation is properly configured
- [ ] Dependencies flow in correct direction (no circular references)
- [ ] Solution can be opened in all supported IDEs" \
  --label "type:story,module:infrastructure,priority:high"
```

## Story 3: Multi-Tenant Infrastructure Foundation

```bash
gh issue create \
  --title "[STORY] As a developer I want multi-tenant infrastructure so that I can build tenant-aware features" \
  --body "## User Story
As a **feature developer**  
I want **multi-tenant infrastructure with automatic tenant resolution**  
So that **I can build features that automatically isolate data by tenant**

## Epic
Relates to: Development Environment and Initial Setup Epic

## Target Date
2 weeks from now

## Acceptance Criteria
- [ ] ITenantAware interface for entities
- [ ] TenantContext service for current tenant resolution
- [ ] Header-based tenant resolution middleware
- [ ] JWT-based tenant claims support
- [ ] Tenant-aware DbContext base class
- [ ] TenantId automatically added to queries and saves
- [ ] Unit tests for tenant isolation

## Technical Implementation Notes
### Components to Implement:
1. **ITenantAware Interface**
   \`\`\`csharp
   public interface ITenantAware
   {
       string TenantId { get; set; }
   }
   \`\`\`

2. **TenantContext Service**
   - Resolve tenant from X-Tenant-Id header
   - Support JWT claims-based resolution
   - Thread-safe current tenant access

3. **Tenant Middleware**
   - Extract tenant from request headers
   - Validate tenant exists and is active
   - Set tenant context for request lifecycle

4. **Tenant-Aware DbContext**
   - Automatic tenant filtering on queries
   - Automatic TenantId assignment on saves
   - Prevent cross-tenant data leakage

## Definition of Done
- [ ] All tenant infrastructure components implemented
- [ ] Unit tests demonstrate tenant isolation
- [ ] Integration tests verify header-based resolution
- [ ] Documentation updated with tenant usage patterns
- [ ] Code review completed and approved" \
  --label "type:story,module:infrastructure,priority:critical"
```

## Task Issues for Implementation

### Task 1: .NET Solution Creation

```bash
gh issue create \
  --title "[TASK] Create initial .NET 9.0 solution with modular structure" \
  --body "## Description
Create the foundational .NET solution file and project structure for the modular monolith architecture.

## Technical Details
### Steps:
1. Create solution file: \`saga-ecommerce-service.sln\`
2. Create Host project (Web API)
3. Create Shared projects (Domain, Application, Infrastructure)
4. Create Module projects (Catalog, Channel, TenantManagement)
5. Configure project references
6. Add initial NuGet packages

### Required NuGet Packages:
- FastEndpoints
- Microsoft.EntityFrameworkCore
- Microsoft.EntityFrameworkCore.SqlServer
- Microsoft.AspNetCore.Authentication.JwtBearer
- FluentValidation

### Project References:
- Host → All Modules + Shared.Infrastructure
- Modules → Shared.Domain + Shared.Application
- Shared.Infrastructure → Shared.Application
- Shared.Application → Shared.Domain

## Acceptance Criteria
- [ ] Solution builds without errors
- [ ] All projects target .NET 9.0
- [ ] Project references are correctly configured
- [ ] No circular dependencies
- [ ] Initial folder structure matches architecture design

## Estimate
3 story points" \
  --label "type:task,module:infrastructure,priority:high"
```

### Task 2: FastEndpoints Configuration

```bash
gh issue create \
  --title "[TASK] Configure FastEndpoints in Host project" \
  --body "## Description
Set up FastEndpoints as the API framework in the Host project with proper configuration for the modular monolith.

## Technical Details
### Configuration Steps:
1. Install FastEndpoints NuGet package
2. Configure in Program.cs
3. Set up Swagger/OpenAPI integration
4. Configure JSON serialization options
5. Set up validation pipeline
6. Create sample health check endpoint

### FastEndpoints Configuration:
\`\`\`csharp
builder.Services.AddFastEndpoints();
app.UseFastEndpoints(c => {
    c.Endpoints.RoutePrefix = \"api\";
    c.Serializer.Options.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
});
\`\`\`

### Sample Endpoint:
Create a health check endpoint to verify FastEndpoints is working

## Acceptance Criteria
- [ ] FastEndpoints properly configured in Program.cs
- [ ] Health endpoint returns 200 OK
- [ ] Swagger UI accessible at /swagger
- [ ] JSON responses use camelCase naming
- [ ] Validation pipeline configured
- [ ] Sample endpoint can be called via curl/Postman

## Estimate
2 story points" \
  --label "type:task,module:infrastructure,priority:high"
```

### Task 3: Database Setup and EF Core Configuration

```bash
gh issue create \
  --title "[TASK] Set up Entity Framework Core with tenant-aware DbContext" \
  --body "## Description
Configure Entity Framework Core with a base DbContext that supports multi-tenant data isolation.

## Technical Details
### Implementation Steps:
1. Create TenantAwareDbContext base class
2. Configure connection string management
3. Implement tenant filtering in OnModelCreating
4. Set up database migration infrastructure
5. Create initial migration
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
- [ ] Tenant filtering automatically applied to all queries
- [ ] Database migrations work correctly
- [ ] Connection string configurable via appsettings
- [ ] DbContext properly registered in DI container
- [ ] Integration test verifies tenant isolation

## Estimate
5 story points" \
  --label "type:task,module:infrastructure,priority:critical"
```

### Task 4: Tenant Resolution Middleware

```bash
gh issue create \
  --title "[TASK] Implement tenant resolution middleware for header-based multi-tenancy" \
  --body "## Description
Create middleware that extracts tenant information from HTTP headers and JWT claims, making it available throughout the request lifecycle.

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

## Estimate
5 story points" \
  --label "type:task,module:infrastructure,priority:critical"
```

### Task 5: CI/CD Pipeline Setup

```bash
gh issue create \
  --title "[TASK] Set up GitHub Actions CI/CD pipeline" \
  --body "## Description
Create a CI/CD pipeline that builds, tests, and deploys the application automatically on pull requests and merges.

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
  --label "type:task,module:infrastructure,priority:medium"
```

## Run All Commands

### Execute Issue Creation

To create all these issues at once, save the commands above to a script file and run:

```bash
# Make script executable
chmod +x create-issues.sh

# Run the script
./create-issues.sh
```

Or run each command individually in your terminal.

## After Creating Issues

### Configure Project Board

1. **Add issues to project board:**
   ```bash
   # The issues should auto-add if workflow is configured
   # If not, add them manually via GitHub UI
   ```

2. **Set up project fields for new issues:**
   - Target Date: Set realistic completion dates
   - Priority: Critical for foundation items
   - Module: Infrastructure for all these issues
   - Team: Backend Team (or Full Stack)

3. **Create dependencies between issues:**
   - Solution Structure depends on Environment Setup
   - Multi-tenant Infrastructure depends on Solution Structure
   - All tasks depend on their parent stories

### Assign to Team Members

```bash
# Assign epic to team lead
gh issue edit [EPIC_NUMBER] --add-assignee "team-lead-username"

# Assign stories and tasks to developers
gh issue edit [STORY_NUMBER] --add-assignee "developer-username"
```

---

**Result:** Your GitHub project will have a complete set of actionable issues that take your team from setup to first working features, all tracked in your Kanban board!