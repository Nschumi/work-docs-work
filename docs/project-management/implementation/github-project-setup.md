# GitHub Project Setup - SAGA eCommerce Service

## Complete Setup Guide

This document provides the complete GitHub project setup based on your questionnaire responses. Execute these commands in sequence to create your fully configured project structure.

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated
- Appropriate permissions in the Nuuday organization
- Terminal/command line access

## Step 1: Repository Creation

```bash
# Create the repository under Nuuday organization
gh repo create Nuuday/saga-ecommerce-service \
  --internal \
  --description "SAGA Telecom eCommerce Module - Multi-tenant whitelabel platform" \
  --clone

cd saga-ecommerce-service
```

## Step 2: Initial Repository Configuration

```bash
# Set up branch protection for main branch
gh api repos/Nuuday/saga-ecommerce-service/branches/main/protection \
  --method PUT \
  --field "required_status_checks[strict]=true" \
  --field "required_status_checks[contexts][]=build" \
  --field "required_status_checks[contexts][]=test" \
  --field "enforce_admins=false" \
  --field "required_pull_request_reviews[required_approving_review_count]=1" \
  --field "required_pull_request_reviews[dismiss_stale_reviews]=true" \
  --field "restrictions=null" \
  --field "allow_force_pushes=false" \
  --field "allow_deletions=false"
```

## Step 3: Label Creation

```bash
# Module-based labels
gh label create "module:catalog" --description "Catalog module related" --color "0052CC"
gh label create "module:channel" --description "Channel module related" --color "0052CC"
gh label create "module:basket" --description "Basket module related" --color "0052CC"
gh label create "module:order" --description "Order module related" --color "0052CC"
gh label create "module:payment" --description "Payment module related" --color "0052CC"
gh label create "module:tenant" --description "Tenant management related" --color "0052CC"
gh label create "module:auth" --description "Authentication module related" --color "0052CC"
gh label create "module:infrastructure" --description "Infrastructure and cross-cutting" --color "0052CC"

# Priority labels
gh label create "priority:critical" --description "Critical priority - immediate action" --color "B60205"
gh label create "priority:high" --description "High priority" --color "D93F0B"
gh label create "priority:medium" --description "Medium priority" --color "FBCA04"
gh label create "priority:low" --description "Low priority" --color "0E8A16"

# Type labels
gh label create "type:epic" --description "Epic - large feature" --color "3E4B9E"
gh label create "type:story" --description "User story" --color "5319E7"
gh label create "type:task" --description "Technical task" --color "7057FF"
gh label create "type:bug" --description "Bug report" --color "D73A4A"
gh label create "type:spike" --description "Research/investigation task" --color "BFDADC"
gh label create "type:documentation" --description "Documentation task" --color "0075CA"

# Status labels
gh label create "status:blocked" --description "Blocked by dependency" --color "E4E669"
gh label create "status:in-review" --description "In code review" --color "C5DEF5"
gh label create "status:testing" --description "In testing phase" --color "BFD4F2"
gh label create "status:ready-for-qa" --description "Ready for QA testing" --color "2EA043"

# Special labels
gh label create "open-pages" --description "Required for Open Pages integration" --color "F9D0C4"
gh label create "tcm-compatibility" --description "Legacy TCM compatibility required" --color "FEF2C0"
gh label create "breaking-change" --description "Breaking change" --color "B60205"
gh label create "security" --description "Security related" --color "D1232A"
```

## Step 4: Milestone Creation

```bash
# Phase-based milestones
gh api repos/Nuuday/saga-ecommerce-service/milestones \
  --method POST \
  --field title="Phase 1 - Foundation" \
  --field description="Multi-tenant infrastructure, Catalog, Channel, and Open Pages integration" \
  --field due_on="2025-10-01T00:00:00Z"

gh api repos/Nuuday/saga-ecommerce-service/milestones \
  --method POST \
  --field title="Phase 2 - Core Commerce" \
  --field description="Basket, Order processing, Payment integration" \
  --field due_on="2025-11-01T00:00:00Z"

gh api repos/Nuuday/saga-ecommerce-service/milestones \
  --method POST \
  --field title="Open Pages MVP" \
  --field description="Minimum viable integration for Open Pages project" \
  --field due_on="2025-07-01T00:00:00Z"
```

## Step 5: Issue Templates

```bash
# Create .github/ISSUE_TEMPLATE directory
mkdir -p .github/ISSUE_TEMPLATE

# Epic template
cat > .github/ISSUE_TEMPLATE/epic.md << 'EOF'
---
name: Epic
about: Large feature spanning multiple sprints
title: '[EPIC] '
labels: 'type:epic'
assignees: ''
---

## Epic Overview
<!-- Provide a high-level description of the epic -->

## Business Value
<!-- Describe the business value and impact -->

## Success Criteria
<!-- Define what success looks like for this epic -->

## User Stories
<!-- List related user stories -->
- [ ] Story 1
- [ ] Story 2
- [ ] Story 3

## Technical Considerations
<!-- Any technical constraints or considerations -->

## Dependencies
<!-- List any dependencies on other epics or external factors -->

## Acceptance Criteria
<!-- High-level acceptance criteria -->
1. 
2. 
3. 
EOF

# User Story template
cat > .github/ISSUE_TEMPLATE/user-story.md << 'EOF'
---
name: User Story
about: Feature from user perspective
title: '[STORY] As a ... I want ... so that ...'
labels: 'type:story'
assignees: ''
---

## Story
As a **[type of user]**
I want **[goal/desire]**
So that **[benefit/value]**

## Acceptance Criteria
<!-- Use Given-When-Then format -->
```gherkin
Given [context]
When [action]
Then [outcome]
```

## Technical Implementation Notes
<!-- Technical details for developers -->

## Definition of Done
- [ ] Code complete and peer reviewed
- [ ] Unit tests written and passing
- [ ] Integration tests updated
- [ ] Documentation updated
- [ ] Deployed to staging environment

## Related Issues
<!-- Link to related epics, tasks, or dependencies -->
- Epic: #
- Depends on: #
- Blocks: #
EOF

# Task template
cat > .github/ISSUE_TEMPLATE/task.md << 'EOF'
---
name: Technical Task
about: Implementation work item
title: '[TASK] '
labels: 'type:task'
assignees: ''
---

## Description
<!-- Clear description of the technical task -->

## Technical Details
<!-- Implementation details, approach, and considerations -->

## Acceptance Criteria
- [ ] 
- [ ] 
- [ ] 

## Testing Approach
<!-- How will this be tested? -->

## Related Issues
- Story: #
- Blocked by: #
EOF

# Bug Report template
cat > .github/ISSUE_TEMPLATE/bug-report.md << 'EOF'
---
name: Bug Report
about: Report a bug or issue
title: '[BUG] '
labels: 'type:bug'
assignees: ''
---

## Bug Description
<!-- Clear description of the bug -->

## Steps to Reproduce
1. 
2. 
3. 

## Expected Behavior
<!-- What should happen -->

## Actual Behavior
<!-- What actually happens -->

## Environment
- Environment: [Development/Staging/Production]
- Module: [Catalog/Channel/etc.]
- Tenant: [If tenant-specific]

## Screenshots/Logs
<!-- If applicable -->

## Additional Context
<!-- Any other relevant information -->
EOF

# Spike template
cat > .github/ISSUE_TEMPLATE/spike.md << 'EOF'
---
name: Spike/Research
about: Research or investigation task
title: '[SPIKE] '
labels: 'type:spike'
assignees: ''
---

## Objective
<!-- What are we trying to learn or investigate? -->

## Questions to Answer
1. 
2. 
3. 

## Success Criteria
<!-- How will we know the spike is complete? -->

## Timebox
<!-- Maximum time to spend on this spike -->
- [ ] Timeboxed to: ___ hours/days

## Deliverables
- [ ] Technical recommendation document
- [ ] Proof of concept code
- [ ] Decision matrix
- [ ] Team presentation

## Related Issues
- Epic: #
- Will inform: #
EOF

# Documentation template
cat > .github/ISSUE_TEMPLATE/documentation.md << 'EOF'
---
name: Documentation
about: Documentation task
title: '[DOC] '
labels: 'type:documentation'
assignees: ''
---

## Documentation Need
<!-- What needs to be documented? -->

## Target Audience
- [ ] Developers
- [ ] Technical Architects
- [ ] Business Stakeholders
- [ ] End Users

## Documentation Type
- [ ] API Documentation
- [ ] Architecture Decision Record (ADR)
- [ ] How-to Guide
- [ ] Reference Documentation
- [ ] README Update

## Acceptance Criteria
- [ ] Content is accurate and complete
- [ ] Reviewed by subject matter expert
- [ ] Follows documentation standards
- [ ] Includes examples where appropriate

## Related Issues
- Feature/Story: #
EOF
```

## Step 6: Pull Request Template

```bash
# Create PR template
cat > .github/pull_request_template.md << 'EOF'
## Description
<!-- Provide a brief description of the changes -->

## Related Issue
<!-- Link to the related issue -->
Fixes #

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change
- [ ] Documentation update
- [ ] Infrastructure change

## Module Affected
- [ ] Catalog
- [ ] Channel
- [ ] Basket
- [ ] Order
- [ ] Payment
- [ ] Tenant Management
- [ ] Authentication
- [ ] Infrastructure/Cross-cutting

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] No regression in existing functionality

## Checklist
- [ ] My code follows the project style guidelines
- [ ] I have performed a self-review
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing unit tests pass locally
- [ ] I have updated relevant documentation
- [ ] My changes generate no new warnings

## Screenshots (if applicable)
<!-- Add screenshots for UI changes -->

## Additional Notes
<!-- Any additional context or notes for reviewers -->
EOF
```

## Step 7: Project Board Creation

```bash
# Create the main project board
PROJECT_ID=$(gh project create \
  --owner Nuuday \
  --title "SAGA eCommerce Development" \
  --format json | jq -r '.id')

# Note: GitHub CLI has limited project board configuration capabilities
# The following needs to be done via the web interface:
# 1. Add custom fields (Story Points, Sprint, Module)
# 2. Configure views (Module View, Priority View, Sprint View)
# 3. Set up automation rules
```

## Step 8: Initial Epic Creation

```bash
# Epic: Multi-tenant Infrastructure
gh issue create \
  --title "[EPIC] Multi-tenant Infrastructure Foundation" \
  --body "## Epic Overview
Implement the foundational multi-tenant infrastructure for the SAGA eCommerce platform.

## Business Value
Enable multiple brand partners to operate on a single platform instance with complete data isolation and customization capabilities.

## Success Criteria
- Tenant isolation at database level
- Tenant resolution via headers and JWT
- Tenant-aware base entities
- Multi-tenant middleware functioning

## User Stories
- [ ] Implement tenant context and resolver
- [ ] Create tenant-aware base entities
- [ ] Implement tenant middleware
- [ ] Add tenant management endpoints
- [ ] Create tenant configuration system" \
  --label "type:epic,module:infrastructure,priority:critical" \
  --milestone "Phase 1 - Foundation"

# Epic: Product Catalog Module
gh issue create \
  --title "[EPIC] Product Catalog Module" \
  --body "## Epic Overview
Implement the product catalog module with multi-tenant support and basic CRUD operations.

## Business Value
Enable tenants to manage their product offerings with customizable catalogs and pricing.

## Success Criteria
- Product CRUD operations
- Tenant-specific product isolation
- Category management
- Basic search functionality
- Price management

## User Stories
- [ ] Create product entity and repository
- [ ] Implement product CRUD endpoints
- [ ] Add category management
- [ ] Implement product search
- [ ] Add price management" \
  --label "type:epic,module:catalog,priority:high" \
  --milestone "Phase 1 - Foundation"

# Epic: Channel Module
gh issue create \
  --title "[EPIC] Channel Module" \
  --body "## Epic Overview
Implement the channel module for managing digital sales channels and visibility rules.

## Business Value
Enable tenants to control product visibility and availability across different sales channels.

## Success Criteria
- Channel CRUD operations
- Product-channel associations
- Visibility rules engine
- Channel-specific pricing

## User Stories
- [ ] Create channel entity and repository
- [ ] Implement channel CRUD endpoints
- [ ] Add product-channel associations
- [ ] Implement visibility rules
- [ ] Add channel-specific configuration" \
  --label "type:epic,module:channel,priority:high,open-pages" \
  --milestone "Phase 1 - Foundation"
```

## Step 9: GitHub Actions Workflows

```bash
# Create workflows directory
mkdir -p .github/workflows

# CI/CD Pipeline
cat > .github/workflows/ci.yml << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: 9.0.x
    
    - name: Restore dependencies
      run: dotnet restore
    
    - name: Build
      run: dotnet build --no-restore --configuration Release
    
    - name: Test
      run: dotnet test --no-build --verbosity normal --configuration Release
    
    - name: Code Coverage
      run: dotnet test --no-build --configuration Release --collect:"XPlat Code Coverage"

  security-scan:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Run security scan
      uses: security-devops/action-scan@v1
      with:
        policy: 'Microsoft'
        
  dependency-check:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Dependency Review
      uses: actions/dependency-review-action@v3
EOF

# Auto-labeling workflow
cat > .github/workflows/auto-label.yml << 'EOF'
name: Auto Label Issues

on:
  issues:
    types: [opened, edited]

jobs:
  label:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/labeler@v4
      with:
        repo-token: "${{ secrets.GITHUB_TOKEN }}"
        configuration-path: .github/labeler.yml
EOF

# Create labeler configuration
cat > .github/labeler.yml << 'EOF'
module:catalog:
  - 'src/Modules/Catalog/**/*'
  
module:channel:
  - 'src/Modules/Channel/**/*'

module:infrastructure:
  - 'src/Shared/**/*'
  - 'src/Host/**/*'

documentation:
  - 'docs/**/*'
  - '**/*.md'
EOF
```

## Step 10: Automation Rules (Via GitHub Web UI)

After running the above commands, configure these automation rules in the GitHub Project settings:

### Auto-move Issues
1. **When PR created** → Move to "In Progress"
2. **When PR marked ready for review** → Move to "Code Review"
3. **When PR approved** → Move to "Testing"
4. **When PR merged** → Move to "Done"

### Auto-assign
1. **Label: module:catalog** → Assign to catalog team member
2. **Label: module:channel** → Assign to channel team member
3. **Label: priority:critical** → Notify team lead

## Step 11: Wiki Structure

```bash
# Initialize wiki (if using wiki option)
gh repo clone Nuuday/saga-ecommerce-service.wiki
cd saga-ecommerce-service.wiki

# Create initial wiki structure
cat > Home.md << 'EOF'
# SAGA eCommerce Service Wiki

Welcome to the SAGA Telecom eCommerce Module documentation.

## Quick Links
- [Getting Started](Getting-Started)
- [Architecture Overview](Architecture-Overview)
- [Module Documentation](Module-Documentation)
- [API Reference](API-Reference)
- [Development Guide](Development-Guide)

## Project Overview
SAGA Telecom eCommerce Module is a multi-tenant, whitelabel telecom eCommerce platform built on a modular monolith architecture.
EOF

git add .
git commit -m "Initialize wiki structure"
git push
```

## Step 12: Team Access (When Ready)

```bash
# Add team members (replace with actual usernames)
# gh api repos/Nuuday/saga-ecommerce-service/collaborators/USERNAME \
#   --method PUT \
#   --field permission=write

# Example:
# gh api repos/Nuuday/saga-ecommerce-service/collaborators/developer1 --method PUT --field permission=write
# gh api repos/Nuuday/saga-ecommerce-service/collaborators/developer2 --method PUT --field permission=write
```

## Verification Checklist

After running all commands, verify:

- [ ] Repository created under Nuuday organization
- [ ] All labels created (module, priority, type, status)
- [ ] Issue templates in place
- [ ] PR template configured
- [ ] Milestones created
- [ ] Initial epics created
- [ ] GitHub Actions workflows set up
- [ ] Branch protection configured

## Next Steps

1. **Configure Project Board Views** (via web UI):
   - Module view grouped by `module:*` labels
   - Priority matrix view
   - Sprint planning view
   - Developer assignment view

2. **Add Team Members**:
   - Run team access commands with actual GitHub usernames
   - Configure code owners file

3. **Create Initial Stories**:
   - Break down epics into user stories
   - Add story points estimation
   - Plan first sprint

4. **Set Up Development Environment**:
   - Clone repository
   - Follow setup instructions
   - Start development!

---

**Note**: Some advanced project board configurations must be done via the GitHub web interface as the CLI has limitations for project board customization.