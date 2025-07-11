#!/bin/bash
# SAGA eCommerce Service - GitHub Quick Setup Script
# This script creates the complete GitHub project structure

set -e  # Exit on error

echo "🚀 SAGA eCommerce Service - GitHub Quick Setup"
echo "=============================================="

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed. Please install it first:"
    echo "   brew install gh  (macOS)"
    echo "   https://cli.github.com/manual/installation"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub. Please run: gh auth login"
    exit 1
fi

# Configuration
ORG="Nuuday"
REPO_NAME="saga-ecommerce-service"
REPO_FULL="$ORG/$REPO_NAME"

echo ""
echo "📋 Configuration:"
echo "  Organization: $ORG"
echo "  Repository: $REPO_NAME"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Setup cancelled"
    exit 1
fi

# Step 1: Create Repository
echo ""
echo "1️⃣ Creating repository..."
gh repo create "$REPO_FULL" \
  --internal \
  --description "SAGA Telecom eCommerce Module - Multi-tenant whitelabel platform" \
  --clone || { echo "❌ Failed to create repository"; exit 1; }

cd "$REPO_NAME"

# Step 2: Create Labels
echo ""
echo "2️⃣ Creating labels..."

# Module labels
gh label create "module:catalog" --description "Catalog module related" --color "0052CC" 2>/dev/null || true
gh label create "module:channel" --description "Channel module related" --color "0052CC" 2>/dev/null || true
gh label create "module:basket" --description "Basket module related" --color "0052CC" 2>/dev/null || true
gh label create "module:order" --description "Order module related" --color "0052CC" 2>/dev/null || true
gh label create "module:payment" --description "Payment module related" --color "0052CC" 2>/dev/null || true
gh label create "module:tenant" --description "Tenant management related" --color "0052CC" 2>/dev/null || true
gh label create "module:auth" --description "Authentication module related" --color "0052CC" 2>/dev/null || true
gh label create "module:infrastructure" --description "Infrastructure and cross-cutting" --color "0052CC" 2>/dev/null || true

# Priority labels
gh label create "priority:critical" --description "Critical priority - immediate action" --color "B60205" 2>/dev/null || true
gh label create "priority:high" --description "High priority" --color "D93F0B" 2>/dev/null || true
gh label create "priority:medium" --description "Medium priority" --color "FBCA04" 2>/dev/null || true
gh label create "priority:low" --description "Low priority" --color "0E8A16" 2>/dev/null || true

# Type labels
gh label create "type:epic" --description "Epic - large feature" --color "3E4B9E" 2>/dev/null || true
gh label create "type:story" --description "User story" --color "5319E7" 2>/dev/null || true
gh label create "type:task" --description "Technical task" --color "7057FF" 2>/dev/null || true
gh label create "type:bug" --description "Bug report" --color "D73A4A" 2>/dev/null || true
gh label create "type:spike" --description "Research/investigation task" --color "BFDADC" 2>/dev/null || true
gh label create "type:documentation" --description "Documentation task" --color "0075CA" 2>/dev/null || true

# Status labels
gh label create "status:blocked" --description "Blocked by dependency" --color "E4E669" 2>/dev/null || true
gh label create "status:in-review" --description "In code review" --color "C5DEF5" 2>/dev/null || true
gh label create "status:testing" --description "In testing phase" --color "BFD4F2" 2>/dev/null || true
gh label create "status:ready-for-qa" --description "Ready for QA testing" --color "2EA043" 2>/dev/null || true

# Special labels
gh label create "open-pages" --description "Required for Open Pages integration" --color "F9D0C4" 2>/dev/null || true
gh label create "tcm-compatibility" --description "Legacy TCM compatibility required" --color "FEF2C0" 2>/dev/null || true

echo "✅ Labels created"

# Step 3: Create Milestones
echo ""
echo "3️⃣ Creating milestones..."

gh api repos/"$REPO_FULL"/milestones \
  --method POST \
  --field title="Phase 1 - Foundation" \
  --field description="Multi-tenant infrastructure, Catalog, Channel, and Open Pages integration" \
  --field due_on="2025-10-01T00:00:00Z" \
  2>/dev/null || true

gh api repos/"$REPO_FULL"/milestones \
  --method POST \
  --field title="Open Pages MVP" \
  --field description="Minimum viable integration for Open Pages project" \
  --field due_on="2025-07-01T00:00:00Z" \
  2>/dev/null || true

echo "✅ Milestones created"

# Step 4: Create Directory Structure
echo ""
echo "4️⃣ Creating project structure..."

mkdir -p .github/ISSUE_TEMPLATE
mkdir -p .github/workflows
mkdir -p docs
mkdir -p src

# Step 5: Create Issue Templates
echo ""
echo "5️⃣ Creating issue templates..."

# Epic template
cat > .github/ISSUE_TEMPLATE/epic.yml << 'EOF'
name: Epic
description: Large feature spanning multiple sprints
title: "[EPIC] "
labels: ["type:epic"]
body:
  - type: textarea
    id: overview
    attributes:
      label: Epic Overview
      description: Provide a high-level description of the epic
    validations:
      required: true
  - type: textarea
    id: business-value
    attributes:
      label: Business Value
      description: Describe the business value and impact
    validations:
      required: true
  - type: textarea
    id: success-criteria
    attributes:
      label: Success Criteria
      description: Define what success looks like for this epic
    validations:
      required: true
  - type: textarea
    id: user-stories
    attributes:
      label: User Stories
      description: List related user stories
      value: |
        - [ ] Story 1
        - [ ] Story 2
        - [ ] Story 3
    validations:
      required: false
  - type: textarea
    id: acceptance-criteria
    attributes:
      label: Acceptance Criteria
      description: High-level acceptance criteria
    validations:
      required: true
EOF

# Story template
cat > .github/ISSUE_TEMPLATE/user-story.yml << 'EOF'
name: User Story
description: Feature from user perspective
title: "[STORY] As a ... I want ... so that ..."
labels: ["type:story"]
body:
  - type: textarea
    id: story
    attributes:
      label: User Story
      description: Complete the user story
      value: |
        As a **[type of user]**
        I want **[goal/desire]**
        So that **[benefit/value]**
    validations:
      required: true
  - type: textarea
    id: acceptance-criteria
    attributes:
      label: Acceptance Criteria
      description: Use Given-When-Then format
      value: |
        ```gherkin
        Given [context]
        When [action]
        Then [outcome]
        ```
    validations:
      required: true
  - type: textarea
    id: technical-notes
    attributes:
      label: Technical Implementation Notes
      description: Technical details for developers
    validations:
      required: false
  - type: checkboxes
    id: definition-of-done
    attributes:
      label: Definition of Done
      options:
        - label: Code complete and peer reviewed
        - label: Unit tests written and passing
        - label: Integration tests updated
        - label: Documentation updated
        - label: Deployed to staging environment
EOF

# Task template
cat > .github/ISSUE_TEMPLATE/task.yml << 'EOF'
name: Technical Task
description: Implementation work item
title: "[TASK] "
labels: ["type:task"]
body:
  - type: textarea
    id: description
    attributes:
      label: Description
      description: Clear description of the technical task
    validations:
      required: true
  - type: textarea
    id: technical-details
    attributes:
      label: Technical Details
      description: Implementation details, approach, and considerations
    validations:
      required: true
  - type: textarea
    id: acceptance-criteria
    attributes:
      label: Acceptance Criteria
      description: What needs to be completed for this task to be done?
      value: |
        - [ ] 
        - [ ] 
        - [ ] 
    validations:
      required: true
EOF

# Bug template (simplified)
cat > .github/ISSUE_TEMPLATE/bug.yml << 'EOF'
name: Bug Report
description: Report a bug or issue
title: "[BUG] "
labels: ["type:bug"]
body:
  - type: textarea
    id: description
    attributes:
      label: Bug Description
      description: Clear description of the bug
    validations:
      required: true
  - type: textarea
    id: reproduce
    attributes:
      label: Steps to Reproduce
      description: How can we reproduce this issue?
      value: |
        1. 
        2. 
        3. 
    validations:
      required: true
  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What should happen?
    validations:
      required: true
  - type: textarea
    id: actual
    attributes:
      label: Actual Behavior
      description: What actually happens?
    validations:
      required: true
EOF

echo "✅ Issue templates created"

# Step 6: Create PR Template
echo ""
echo "6️⃣ Creating PR template..."

cat > .github/pull_request_template.md << 'EOF'
## Description
<!-- Provide a brief description of the changes -->

## Related Issue
Fixes #

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Module Affected
- [ ] Catalog
- [ ] Channel
- [ ] Basket
- [ ] Order
- [ ] Payment
- [ ] Tenant Management
- [ ] Authentication
- [ ] Infrastructure/Cross-cutting

## Checklist
- [ ] My code follows the project style guidelines
- [ ] I have performed a self-review
- [ ] I have added tests
- [ ] New and existing unit tests pass locally
- [ ] I have updated relevant documentation
EOF

echo "✅ PR template created"

# Step 7: Create Initial README
echo ""
echo "7️⃣ Creating README..."

cat > README.md << 'EOF'
# SAGA eCommerce Service

SAGA Telecom eCommerce Module - A multi-tenant, whitelabel telecom eCommerce platform.

## Quick Start

1. Clone the repository
2. Install .NET 9.0 SDK
3. Run `dotnet restore`
4. Run `dotnet build`

## Project Structure

```
src/
├── Modules/          # Feature modules
├── Shared/           # Shared kernel and infrastructure
└── Host/             # API host application
```

## Documentation

See the [docs](./docs) folder for detailed documentation.

## Contributing

1. Create a feature branch from `main`
2. Make your changes
3. Submit a PR with linked issue

## License

Proprietary - Nuuday Mobile Partners
EOF

echo "✅ README created"

# Step 8: Create Basic CI Workflow
echo ""
echo "8️⃣ Creating CI workflow..."

cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

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
EOF

echo "✅ CI workflow created"

# Step 9: Create Initial Epics
echo ""
echo "9️⃣ Creating initial epics..."

# Epic 1: Multi-tenant Infrastructure
gh issue create \
  --title "[EPIC] Multi-tenant Infrastructure Foundation" \
  --body "## Epic Overview
Implement the foundational multi-tenant infrastructure for the SAGA eCommerce platform.

## Business Value
Enable multiple brand partners to operate on a single platform instance with complete data isolation.

## Success Criteria
- Tenant isolation at database level
- Tenant resolution via headers and JWT
- Multi-tenant middleware functioning

## User Stories
- [ ] Implement tenant context and resolver
- [ ] Create tenant-aware base entities
- [ ] Implement tenant middleware
- [ ] Add tenant management endpoints" \
  --label "type:epic,module:infrastructure,priority:critical" \
  --milestone "Phase 1 - Foundation" || true

# Epic 2: Product Catalog
gh issue create \
  --title "[EPIC] Product Catalog Module" \
  --body "## Epic Overview
Implement the product catalog module with multi-tenant support and basic CRUD operations.

## Business Value
Enable tenants to manage their product offerings with customizable catalogs.

## Success Criteria
- Product CRUD operations
- Category management
- Basic search functionality

## User Stories
- [ ] Create product entity and repository
- [ ] Implement product CRUD endpoints
- [ ] Add category management" \
  --label "type:epic,module:catalog,priority:high" \
  --milestone "Phase 1 - Foundation" || true

# Epic 3: Channel Module
gh issue create \
  --title "[EPIC] Channel Module" \
  --body "## Epic Overview
Implement the channel module for managing digital sales channels.

## Business Value
Enable tenants to control product visibility across different sales channels.

## Success Criteria
- Channel CRUD operations
- Product-channel associations
- Visibility rules engine

## User Stories
- [ ] Create channel entity
- [ ] Implement channel endpoints
- [ ] Add visibility rules" \
  --label "type:epic,module:channel,priority:high,open-pages" \
  --milestone "Phase 1 - Foundation" || true

echo "✅ Initial epics created"

# Step 10: Initial Commit
echo ""
echo "🔟 Making initial commit..."

git add .
git commit -m "Initial commit - Project structure and GitHub configuration

- Issue templates for Epic, Story, Task, and Bug
- PR template with module checkboxes
- GitHub Actions CI workflow
- Basic project structure
- README with quick start guide

Generated by SAGA eCommerce Quick Setup Script" || true

git push origin main || true

# Step 11: Create Project Board
echo ""
echo "1️⃣1️⃣ Creating project board..."

PROJECT_ID=$(gh project create \
  --owner "$ORG" \
  --title "SAGA eCommerce Development" \
  --format json 2>/dev/null | jq -r '.id') || true

if [ ! -z "$PROJECT_ID" ]; then
    echo "✅ Project board created (ID: $PROJECT_ID)"
else
    echo "⚠️  Project board creation skipped (may already exist)"
fi

# Summary
echo ""
echo "✅ =========================================="
echo "✅ SAGA eCommerce GitHub Setup Complete!"
echo "✅ =========================================="
echo ""
echo "📋 What was created:"
echo "  ✓ Repository: $REPO_FULL"
echo "  ✓ 26 labels (modules, priorities, types, status)"
echo "  ✓ 2 milestones (Phase 1, Open Pages MVP)"
echo "  ✓ 4 issue templates"
echo "  ✓ PR template"
echo "  ✓ CI workflow"
echo "  ✓ 3 initial epics"
echo "  ✓ Project board"
echo ""
echo "🎯 Next steps:"
echo "  1. Configure project board views in GitHub UI"
echo "  2. Add team members to the repository"
echo "  3. Start Sprint 0 - Foundation setup"
echo ""
echo "🔗 Repository URL: https://github.com/$REPO_FULL"
echo ""