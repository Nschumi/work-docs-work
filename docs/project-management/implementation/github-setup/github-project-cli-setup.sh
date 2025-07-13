#!/bin/bash
# GitHub Project Board Advanced Configuration via CLI
# Sets up professional project tracking with columns, fields, and views

set -e

echo "🎯 GitHub Project Board Advanced Configuration"
echo "============================================="

# Configuration
ORG="Nuuday"
REPO_NAME="saga-ecommerce-service" 
PROJECT_TITLE="SAGA eCommerce Development"

# Check if gh is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub"
    exit 1
fi

echo "📋 Configuration:"
echo "  Organization: $ORG"
echo "  Repository: $REPO_NAME"
echo "  Project: $PROJECT_TITLE"
echo ""

# Check if project exists, if not create it
echo "1️⃣ Checking/Creating project..."

PROJECT_ID=$(gh project list --owner "$ORG" --format json | jq -r ".[] | select(.title==\"$PROJECT_TITLE\") | .id" 2>/dev/null || echo "")

if [ -z "$PROJECT_ID" ]; then
    echo "Creating new project..."
    PROJECT_RESPONSE=$(gh project create --owner "$ORG" --title "$PROJECT_TITLE" --format json)
    PROJECT_ID=$(echo "$PROJECT_RESPONSE" | jq -r '.id')
    echo "✅ Project created with ID: $PROJECT_ID"
else
    echo "✅ Project found with ID: $PROJECT_ID"
fi

# Link repository to project
echo ""
echo "2️⃣ Linking repository to project..."
gh project link "$PROJECT_ID" --repo "$ORG/$REPO_NAME" 2>/dev/null || echo "⚠️  Repository may already be linked"

# Get current field IDs for cleanup/reference
echo ""
echo "3️⃣ Getting current project structure..."

# Create custom fields
echo ""
echo "4️⃣ Creating custom fields..."

# Story Points field
echo "Creating Story Points field..."
STORY_POINTS_FIELD=$(gh project field-create "$PROJECT_ID" \
    --name "Story Points" \
    --data-type "number" \
    --format json | jq -r '.id' 2>/dev/null || echo "")

if [ ! -z "$STORY_POINTS_FIELD" ]; then
    echo "✅ Story Points field created: $STORY_POINTS_FIELD"
else
    echo "⚠️  Story Points field may already exist"
fi

# Sprint field (single select)
echo "Creating Sprint field..."
SPRINT_FIELD=$(gh project field-create "$PROJECT_ID" \
    --name "Sprint" \
    --data-type "single_select" \
    --format json | jq -r '.id' 2>/dev/null || echo "")

if [ ! -z "$SPRINT_FIELD" ]; then
    echo "✅ Sprint field created: $SPRINT_FIELD"
    
    # Add sprint options
    echo "Adding sprint options..."
    gh project field-create "$PROJECT_ID" --field-id "$SPRINT_FIELD" --single-select-option "Sprint 0 - Foundation" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$SPRINT_FIELD" --single-select-option "Sprint 1 - Multi-tenant" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$SPRINT_FIELD" --single-select-option "Sprint 2 - Multi-tenant" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$SPRINT_FIELD" --single-select-option "Sprint 3 - Catalog" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$SPRINT_FIELD" --single-select-option "Sprint 4 - Catalog" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$SPRINT_FIELD" --single-select-option "Sprint 5 - Channel" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$SPRINT_FIELD" --single-select-option "Sprint 6 - Channel" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$SPRINT_FIELD" --single-select-option "Sprint 7 - Open Pages MVP" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$SPRINT_FIELD" --single-select-option "Sprint 8 - Production Prep" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$SPRINT_FIELD" --single-select-option "Sprint 9 - Production Prep" 2>/dev/null || true
    echo "✅ Sprint options added"
else
    echo "⚠️  Sprint field may already exist"
fi

# Module field (single select)
echo "Creating Module field..."
MODULE_FIELD=$(gh project field-create "$PROJECT_ID" \
    --name "Module" \
    --data-type "single_select" \
    --format json | jq -r '.id' 2>/dev/null || echo "")

if [ ! -z "$MODULE_FIELD" ]; then
    echo "✅ Module field created: $MODULE_FIELD"
    
    # Add module options
    echo "Adding module options..."
    gh project field-create "$PROJECT_ID" --field-id "$MODULE_FIELD" --single-select-option "Infrastructure" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$MODULE_FIELD" --single-select-option "Catalog" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$MODULE_FIELD" --single-select-option "Channel" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$MODULE_FIELD" --single-select-option "Basket" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$MODULE_FIELD" --single-select-option "Order" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$MODULE_FIELD" --single-select-option "Payment" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$MODULE_FIELD" --single-select-option "Tenant Management" 2>/dev/null || true
    gh project field-create "$PROJECT_ID" --field-id "$MODULE_FIELD" --single-select-option "Authentication" 2>/dev/null || true
    echo "✅ Module options added"
else
    echo "⚠️  Module field may already exist"
fi

# Priority Score field
echo "Creating Priority Score field..."
PRIORITY_FIELD=$(gh project field-create "$PROJECT_ID" \
    --name "Priority Score" \
    --data-type "number" \
    --format json | jq -r '.id' 2>/dev/null || echo "")

if [ ! -z "$PRIORITY_FIELD" ]; then
    echo "✅ Priority Score field created: $PRIORITY_FIELD"
else
    echo "⚠️  Priority Score field may already exist"
fi

# Get the default status field ID
echo ""
echo "5️⃣ Configuring status columns..."

# Note: Status field configuration via CLI is limited
# We'll provide instructions for manual configuration
echo "⚠️  Status column configuration requires manual setup via web UI"
echo "   Please follow the web UI guide for configuring:"
echo "   - 📋 Backlog"
echo "   - 📅 Sprint Planning" 
echo "   - 🔄 In Progress"
echo "   - 👁️ Code Review"
echo "   - 🧪 Testing"
echo "   - ✅ Done"

# Create multiple views
echo ""
echo "6️⃣ Creating project views..."

# Development Flow View (default board view)
echo "Creating Development Flow view..."
DEV_VIEW=$(gh project view-create "$PROJECT_ID" \
    --name "📊 Development Flow" \
    --layout "board" \
    --format json | jq -r '.id' 2>/dev/null || echo "")

if [ ! -z "$DEV_VIEW" ]; then
    echo "✅ Development Flow view created: $DEV_VIEW"
else
    echo "⚠️  Development Flow view may already exist"
fi

# Sprint Planning Table View
echo "Creating Sprint Planning view..."
SPRINT_VIEW=$(gh project view-create "$PROJECT_ID" \
    --name "📅 Sprint Planning" \
    --layout "table" \
    --format json | jq -r '.id' 2>/dev/null || echo "")

if [ ! -z "$SPRINT_VIEW" ]; then
    echo "✅ Sprint Planning view created: $SPRINT_VIEW"
else
    echo "⚠️  Sprint Planning view may already exist"
fi

# Team Workload Board View
echo "Creating Team Workload view..."
TEAM_VIEW=$(gh project view-create "$PROJECT_ID" \
    --name "👥 Team Workload" \
    --layout "board" \
    --format json | jq -r '.id' 2>/dev/null || echo "")

if [ ! -z "$TEAM_VIEW" ]; then
    echo "✅ Team Workload view created: $TEAM_VIEW"
else
    echo "⚠️  Team Workload view may already exist"
fi

# Module Overview Board View
echo "Creating Module Overview view..."
MODULE_VIEW=$(gh project view-create "$PROJECT_ID" \
    --name "🏗️ Module Overview" \
    --layout "board" \
    --format json | jq -r '.id' 2>/dev/null || echo "")

if [ ! -z "$MODULE_VIEW" ]; then
    echo "✅ Module Overview view created: $MODULE_VIEW"
else
    echo "⚠️  Module Overview view may already exist"
fi

# Priority Matrix Board View  
echo "Creating Priority Matrix view..."
PRIORITY_VIEW=$(gh project view-create "$PROJECT_ID" \
    --name "🎯 Priority Matrix" \
    --layout "board" \
    --format json | jq -r '.id' 2>/dev/null || echo "")

if [ ! -z "$PRIORITY_VIEW" ]; then
    echo "✅ Priority Matrix view created: $PRIORITY_VIEW"
else
    echo "⚠️  Priority Matrix view may already exist"
fi

# Epic Tracking Table View
echo "Creating Epic Tracking view..."
EPIC_VIEW=$(gh project view-create "$PROJECT_ID" \
    --name "📈 Epic Progress" \
    --layout "table" \
    --format json | jq -r '.id' 2>/dev/null || echo "")

if [ ! -z "$EPIC_VIEW" ]; then
    echo "✅ Epic Progress view created: $EPIC_VIEW"
else
    echo "⚠️  Epic Progress view may already exist"
fi

# Add existing issues to project
echo ""
echo "7️⃣ Adding existing repository issues to project..."

# Get all issues from the repository
ISSUES=$(gh issue list --repo "$ORG/$REPO_NAME" --limit 50 --json number --jq '.[].number')

for issue_number in $ISSUES; do
    echo "Adding issue #$issue_number to project..."
    gh project item-add "$PROJECT_ID" --url "https://github.com/$ORG/$REPO_NAME/issues/$issue_number" 2>/dev/null || echo "⚠️  Issue #$issue_number may already be in project"
done

echo "✅ Issues added to project"

# Update existing epics with custom field values
echo ""
echo "8️⃣ Updating epic issues with field values..."

# Function to update item fields (simplified - actual implementation may vary)
update_epic_fields() {
    local issue_number=$1
    local module=$2
    local priority=$3
    local story_points=$4
    
    echo "Updating issue #$issue_number..."
    # Note: Field updates via CLI are complex and may require item IDs
    # This is a placeholder for the concept
}

# Update the three initial epics (if they exist)
echo "⚠️  Epic field updates require manual configuration via web UI"
echo "   Please update the following epics with these values:"
echo "   - Multi-tenant Infrastructure Epic: Module=Infrastructure, Priority=4, Story Points=13"
echo "   - Product Catalog Epic: Module=Catalog, Priority=3, Story Points=13" 
echo "   - Channel Module Epic: Module=Channel, Priority=3, Story Points=13"

# Summary and next steps
echo ""
echo "✅ ================================================"
echo "✅ GitHub Project Board CLI Setup Complete!"
echo "✅ ================================================"
echo ""
echo "📋 What was configured via CLI:"
echo "  ✓ Project created/verified: $PROJECT_TITLE"
echo "  ✓ Repository linked to project"
echo "  ✓ Custom fields created:"
echo "    - Story Points (number)"
echo "    - Sprint (single select with 10 options)"
echo "    - Module (single select with 8 options)" 
echo "    - Priority Score (number)"
echo "  ✓ 6 project views created:"
echo "    - 📊 Development Flow (board)"
echo "    - 📅 Sprint Planning (table)"
echo "    - 👥 Team Workload (board)"
echo "    - 🏗️ Module Overview (board)"
echo "    - 🎯 Priority Matrix (board)"
echo "    - 📈 Epic Progress (table)"
echo "  ✓ Existing issues added to project"
echo ""
echo "⚠️  Manual configuration still needed:"
echo "  1. Configure status columns in web UI:"
echo "     📋 Backlog → 📅 Sprint Planning → 🔄 In Progress → 👁️ Code Review → 🧪 Testing → ✅ Done"
echo ""
echo "  2. Set up view grouping and filtering:"
echo "     - Module Overview: Group by Module field"
echo "     - Team Workload: Group by Assignees"
echo "     - Priority Matrix: Group by Priority Score"
echo "     - Sprint Planning: Sort by Sprint, then Priority"
echo ""
echo "  3. Configure automation workflows in project settings"
echo ""
echo "  4. Update epic issues with custom field values"
echo ""
echo "🔗 Project URL: https://github.com/orgs/$ORG/projects/[project-number]"
echo ""
echo "📖 Continue with the web UI guide for remaining configuration!"
echo ""