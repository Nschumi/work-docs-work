# Organization Project Setup Guide

## What is an "Organization Project"?

An **Organization Project** is a GitHub Projects board that exists at the organization level (Nuuday) rather than within a specific repository. This allows you to manage work across multiple repositories from a single project board.

**Key Difference:**
- **Repository Project:** Lives inside `saga-ecommerce-service` repo, only sees that repo's issues
- **Organization Project:** Lives at `Nuuday` org level, can see issues from ALL repos

## Why Organization Projects for Multi-Repository Work?

### Problems with Repository Projects:
- Each repo has its own project board
- No unified view across backend + frontend
- Milestones can't span repositories
- Difficult to coordinate cross-repo dependencies

### Solution: Organization Project:
- Single project board for entire platform
- Issues from both `saga-ecommerce-service` AND `saga-ecommerce-frontend`
- Unified milestones and epic tracking
- Cross-repository dependency management
- Single roadmap view

## Step-by-Step Setup Guide

### Step 1: Create Organization Project

**Navigate to Organization Projects:**
1. Go to `https://github.com/orgs/Nuuday/projects`
2. Click **"New project"**
3. Choose **"Board"** or **"Table"** (you can change this later)
4. **Name:** "SAGA eCommerce Platform"
5. **Description:** "Multi-repository project management for SAGA eCommerce backend and frontend"
6. Click **"Create project"**

**Result:** You now have a project at `https://github.com/orgs/Nuuday/projects/[NUMBER]`

### Step 2: Link Both Repositories

**Add Repository Connections:**
1. In your new project, click **"⚙️ Settings"** (top right)
2. Click **"Manage access"** in left sidebar
3. Under **"Repository access"**, click **"Add repository"**
4. Add `Nuuday/saga-ecommerce-service`
5. Add `Nuuday/saga-ecommerce-frontend` (when created)
6. Set permissions to **"Write"** for both

**Alternative CLI Method:**
```bash
# Get your project ID first
gh project list --owner Nuuday

# Link repositories (replace PROJECT_ID with actual ID)
gh project link PROJECT_ID --repo "Nuuday/saga-ecommerce-service"
gh project link PROJECT_ID --repo "Nuuday/saga-ecommerce-frontend"
```

### Step 3: Configure Auto-Add Workflows

**Enable Automatic Issue Addition:**
1. In project **"⚙️ Settings"** → **"Workflows"**
2. Click **"Add workflow"**
3. Select **"Auto-add to project"**
4. Choose **"Issues and pull requests"**
5. Select both repositories
6. **Enable workflow**

**Result:** New issues in either repository automatically appear in your project

### Step 4: Set Up Custom Fields

**Add Organization-Level Fields:**

**Field 1: Business Milestone**
1. Click **"+ Add field"**
2. **Name:** "Business Milestone"
3. **Type:** "Single select"
4. **Options:**
   - "Multi-tenant Foundation"
   - "Open Pages MVP"
   - "Phase 1 Complete"
   - "Future Releases"

**Field 2: Target Date**
1. Click **"+ Add field"**
2. Look for **"Date"** (built-in field) or **"Target Date"** if available
3. **Name:** "Target Date"
4. **Purpose:** Expected completion date for Kanban flow
5. **Usage Examples:**
   - Epic: Multi-tenant Infrastructure → April 30, 2025
   - Story: User Authentication → March 15, 2025  
   - Task: Database Schema → End of next week
6. **Note:** Use realistic date ranges, not precise deadlines

**Field 3: Estimate**
1. Click **"+ Add field"**
2. Look for **"Estimate"** (built-in field) 
3. Add it to your project

**Field 4: Module**
1. Click **"+ Add field"**
2. **Name:** "Module"
3. **Type:** "Single select"
4. **Options:**
   - Infrastructure
   - Catalog
   - Channel
   - Basket
   - Order
   - Payment
   - Tenant Management
   - Authentication
   - Frontend

**Field 5: Priority**
1. Click **"+ Add field"**
2. **Name:** "Priority"
3. **Type:** "Single select"
4. **Options:**
   - 🔥 Critical
   - 🟠 High
   - 🟡 Medium
   - 🔵 Low

**Field 6: Repository**
1. Click **"+ Add field"**
2. **Name:** "Repository"
3. **Type:** "Single select"
4. **Options:**
   - Backend
   - Frontend
   - Both

### Step 5: Create Project Views

**View 1: Cross-Repository Epic Planning**
1. Click **"+ New view"**
2. **Name:** "Epic Roadmap"
3. **Layout:** "Table"
4. **Filter:** `type:epic`
5. **Columns:** Title, Business Milestone, Module, Repository, Epic Timeline, Priority
6. **Sort:** Business Milestone, Priority

**View 2: Backend Development Board**
1. Click **"+ New view"**
2. **Name:** "Backend Development"
3. **Layout:** "Board"
4. **Group by:** Status
5. **Filter:** `repo:saga-ecommerce-service AND (type:story OR type:task)`

**View 3: Frontend Development Board**
1. Click **"+ New view"**
2. **Name:** "Frontend Development"
3. **Layout:** "Board"
4. **Group by:** Status
5. **Filter:** `repo:saga-ecommerce-frontend AND (type:story OR type:task)`

**View 4: Cross-Repository Coordination**
1. Click **"+ New view"**
2. **Name:** "Integration Planning"
3. **Layout:** "Board"
4. **Group by:** Repository
5. **Filter:** `label:integration OR label:cross-repo`

**View 5: Iteration Planning**
1. Click **"+ New view"**
2. **Name:** "Sprint Planning"
3. **Layout:** "Table"
4. **Filter:** `type:story OR type:task`
5. **Columns:** Title, Iteration, Estimate, Assignees, Repository, Status
6. **Sort:** Iteration, Priority

**View 6: Business Milestone Tracking**
1. Click **"+ New view"**
2. **Name:** "Milestone Progress"
3. **Layout:** "Table"
4. **Filter:** `type:epic`
5. **Group by:** Business Milestone
6. **Columns:** Title, Repository, Progress, Epic Timeline, Priority

### Step 6: Enable Roadmap View

**Create Roadmap for Epic Timeline:**
1. Click **"+ New view"**
2. **Name:** "Epic Roadmap"
3. **Layout:** "Roadmap"
4. **Items:** `type:epic`
5. **Date field:** Use iteration start/end dates
6. **Group by:** Business Milestone or Module

**Roadmap Configuration:**
- **Start date:** Based on epic timeline labels
- **End date:** Based on epic timeline labels
- **Dependencies:** Show lines between epics
- **Progress:** Based on child story completion

### Step 7: Migrate Existing Epics

**Add Current Epics to Organization Project:**

**Manual Method:**
1. Go to each existing epic in `saga-ecommerce-service`
2. Copy the issue URL
3. In organization project, click **"Add item"**
4. Paste the URL to add the epic

**CLI Method:**
```bash
# Get your project ID
PROJECT_ID=$(gh project list --owner Nuuday --format json | jq -r '.[] | select(.title=="SAGA eCommerce Platform") | .id')

# Add existing epics (replace with actual issue numbers)
gh project item-add $PROJECT_ID --url "https://github.com/Nuuday/saga-ecommerce-service/issues/1"
gh project item-add $PROJECT_ID --url "https://github.com/Nuuday/saga-ecommerce-service/issues/2"
gh project item-add $PROJECT_ID --url "https://github.com/Nuuday/saga-ecommerce-service/issues/3"
```

**Update Epic Fields:**
1. For each epic in the organization project:
   - **Business Milestone:** Assign appropriate milestone
   - **Repository:** "Backend" or "Both"
   - **Module:** Infrastructure/Catalog/Channel
   - **Priority:** Critical/High
2. **Remove repository milestone assignments** from individual epics

### Step 8: Set Up Automation

**Configure Additional Workflows:**

**Workflow 1: Item Closed**
1. **Settings** → **Workflows** → **Add workflow**
2. Select **"Item closed"**
3. **When:** Issue or PR is closed
4. **Then:** Set status to "Done"

**Workflow 2: Pull Request Merged**
1. Select **"Pull request merged"**
2. **When:** PR is merged
3. **Then:** Set status to "Done"

### Step 9: Team Access Setup

**Add Team Members:**
1. **Settings** → **Manage access**
2. **Add people** or **Add teams**
3. Set appropriate permissions:
   - **Admin:** Project Manager
   - **Write:** Development Team Leads
   - **Read:** Stakeholders and Business Users

### Step 10: Verification

**Test Your Setup:**
1. **Create a test issue** in `saga-ecommerce-service`
2. **Verify it appears** in organization project automatically
3. **Assign custom fields** to the test issue
4. **Check all views** show the issue appropriately
5. **Test roadmap view** with epics

## Final Project Structure

```
Organization: Nuuday
└── Project: "SAGA eCommerce Platform"
    ├── Connected Repositories:
    │   ├── saga-ecommerce-service (Backend)
    │   └── saga-ecommerce-frontend (Frontend)
    ├── Custom Fields:
    │   ├── Business Milestone (Multi-tenant Foundation, Open Pages MVP, etc.)
    │   ├── Iteration (Iteration 0-9 with dates)
    │   ├── Estimate (GitHub built-in)
    │   ├── Module (Infrastructure, Catalog, Channel, etc.)
    │   ├── Priority (Critical, High, Medium, Low)
    │   └── Repository (Backend, Frontend, Both)
    ├── Views:
    │   ├── Epic Roadmap (table + roadmap views)
    │   ├── Backend Development (board)
    │   ├── Frontend Development (board)
    │   ├── Integration Planning (board)
    │   ├── Sprint Planning (table)
    │   └── Milestone Progress (table)
    └── Automation:
        ├── Auto-add from both repositories
        ├── Auto-close on issue/PR close
        └── Auto-close on PR merge
```

## Benefits of This Setup

### For Business Stakeholders:
- **Single dashboard** for entire platform progress
- **Milestone tracking** across all components
- **Epic roadmap** with realistic timelines
- **Cross-repository coordination** visibility

### For Development Teams:
- **Repository-specific views** for daily work
- **Unified sprint planning** across frontend/backend
- **Clear dependency tracking** between teams
- **Automated workflow** reduces manual overhead

### For Project Management:
- **Cross-repository epic management**
- **Unified milestone and iteration planning**
- **Dependency and integration tracking**
- **Single source of truth** for project status

## Troubleshooting

**Issue: Can't see organization projects**
- **Solution:** Ensure you have organization member permissions
- **Alternative:** Ask organization admin to create project and add you

**Issue: Repositories not linking**
- **Solution:** Check repository permissions and organization settings
- **Alternative:** Use CLI method with proper authentication

**Issue: Auto-add workflow not working**
- **Solution:** Check workflow is enabled and repositories are properly connected
- **Test:** Create test issue and verify it appears in project

**Issue: Roadmap not showing epic timelines**
- **Solution:** Ensure epics have iteration fields set or timeline labels
- **Alternative:** Use custom date fields for epic start/end dates

---

**Estimated Setup Time:** 45-60 minutes  
**Prerequisites:** Organization admin access or permissions to create projects  
**Result:** Unified project management across both repositories with epic spanning and roadmap visualization