# GitHub Project Board - Simplified Current Setup Guide

## Overview
This is a practical, step-by-step guide for setting up your GitHub Project board using the **current GitHub Projects interface** (2024/2025). This guide focuses on features that actually work and are available.

## Prerequisites
- ✅ Project created: "SAGA eCommerce Development"
- ✅ Repository linked: `Nuuday/saga-ecommerce-service`
- ✅ Basic issues added to project

## Step 1: Access Your Project

1. Go to: **https://github.com/orgs/Nuuday/projects/71**
2. You should see your project board with some default columns

## Step 2: Set Up Status Columns

### Current Columns Setup

**Rename and organize your columns:**

1. **Click on column titles** to rename them:
   - Rename **"Todo"** → **"📋 Backlog"**
   - Rename **"In Progress"** → **"🔄 In Progress"**
   - Rename **"Done"** → **"✅ Done"**

2. **Add new columns** by clicking **"+ Add column"**:
   - Add: **"📅 Ready"** (between Backlog and In Progress)
   - Add: **"👁️ Review"** (between In Progress and Done)
   - Add: **"🧪 Testing"** (between Review and Done)

**Final column order:**
```
📋 Backlog → 📅 Ready → 🔄 In Progress → 👁️ Review → 🧪 Testing → ✅ Done
```

## Step 3: Add Custom Fields

### 3.1 Access Field Settings

1. Look for **"⋮" (three dots menu)** in the top right
2. Click **"Settings"** 
3. Or look for **"+ Add field"** button at the top

### 3.2 Create Essential Fields

**Field 1: Story Points**
1. Click **"+ Add field"**
2. **Name:** `Story Points`
3. **Type:** `Number`
4. **Description:** `Effort estimation (1,2,3,5,8,13)`
5. Click **"Save"**

**Field 2: Sprint**
1. Click **"+ Add field"**
2. **Name:** `Sprint`
3. **Type:** `Single select`
4. **Options:** Add these one by one:
   - `Sprint 0 - Foundation`
   - `Sprint 1 - Multi-tenant`
   - `Sprint 2 - Multi-tenant`
   - `Sprint 3 - Catalog`
   - `Sprint 4 - Catalog`
   - `Sprint 5 - Channel`
   - `Sprint 6 - Channel`
   - `Sprint 7 - Open Pages MVP`
5. Click **"Save"**

**Field 3: Module**
1. Click **"+ Add field"**
2. **Name:** `Module`
3. **Type:** `Single select`
4. **Options:** Add these:
   - `Infrastructure`
   - `Catalog`
   - `Channel`
   - `Basket`
   - `Order`
   - `Payment`
   - `Tenant Management`
   - `Authentication`
5. Click **"Save"**

**Field 4: Priority**
1. Click **"+ Add field"**
2. **Name:** `Priority`
3. **Type:** `Single select`
4. **Options:**
   - `🔥 Critical`
   - `🟠 High`
   - `🟡 Medium`
   - `🔵 Low`
5. Click **"Save"**

## Step 4: Create Multiple Views

### 4.1 Create Sprint Planning View

1. Click **"+ New view"** (next to current view tab)
2. **Name:** `📅 Sprint Planning`
3. **Layout:** `Table`
4. **Configure table columns:**
   - Title ✓
   - Status ✓
   - Sprint ✓
   - Module ✓
   - Story Points ✓
   - Assignees ✓
   - Priority ✓
5. Click **"Save changes"**

### 4.2 Create Module View

1. Click **"+ New view"**
2. **Name:** `🏗️ Module Overview`
3. **Layout:** `Board`
4. **Group by:** `Module` (in view settings)
5. **Save**

### 4.3 Create Team View

1. Click **"+ New view"**
2. **Name:** `👥 Team Workload`
3. **Layout:** `Board`
4. **Group by:** `Assignees`
5. **Filter:** Status is not "Done" (to hide completed work)
6. **Save**

### 4.4 Create Priority View

1. Click **"+ New view"**
2. **Name:** `🎯 Priority Focus`
3. **Layout:** `Board`
4. **Group by:** `Priority`
5. **Sort by:** `Story Points` (ascending - small items first)
6. **Save**

## Step 5: Set Up Basic Automation

### 5.1 Access Automation

1. Go to project **"Settings"** (⋮ menu → Settings)
2. Look for **"Workflows"** in the left sidebar
3. Click **"Workflows"**

### 5.2 Enable Available Workflows

**Workflow 1: Auto-add Items**
1. Click **"Auto-add to project"**
2. **Repository:** Select `saga-ecommerce-service`
3. **Events:** Check both "Issues" and "Pull requests"
4. **Enable workflow**

**Workflow 2: Auto-archive Closed Items**
1. Click **"Item closed"**
2. **When:** Item is closed
3. **Then:** Set status to "Done"
4. **Enable workflow**

**Workflow 3: Auto-move PR Merged**
1. Click **"Pull request merged"**
2. **When:** Pull request is merged
3. **Then:** Set status to "Done"
4. **Enable workflow**

## Step 6: Basic Filtering and Sorting

### 6.1 Create Useful Filters

In any view, use the **search/filter bar** at the top:

**Common Filters:**
- Current sprint: `sprint:"Sprint 0 - Foundation"`
- High priority: `priority:"🔥 Critical"`
- Specific module: `module:"Catalog"`
- Open items: `-status:"Done"`
- Assigned work: `assignee:@me`

### 6.2 Save Common Filters

1. Apply a filter you use often
2. Look for **"Save filter"** or bookmark option
3. Name it for easy access

## Step 7: Update Your Epic Issues

### 7.1 Add Field Values to Epics

Go to each of your 3 epic issues and update:

**Multi-tenant Infrastructure Epic:**
- Sprint: `Sprint 1 - Multi-tenant`
- Module: `Infrastructure`
- Priority: `🔥 Critical`
- Story Points: `13`

**Product Catalog Epic:**
- Sprint: `Sprint 3 - Catalog`
- Module: `Catalog`
- Priority: `🟠 High`
- Story Points: `13`

**Channel Module Epic:**
- Sprint: `Sprint 5 - Channel`
- Module: `Channel`
- Priority: `🟠 High`
- Story Points: `13`

## Step 8: Create Initial Sprint 0 Items

### 8.1 Create Sprint 0 Stories

Create these issues in your repository and add to project:

**Story 1:**
```
Title: [STORY] Set up development environment and project structure
Labels: type:story, module:infrastructure, priority:critical
Milestone: Phase 1 - Foundation
```

**Story 2:**
```
Title: [STORY] Configure CI/CD pipeline and basic workflows  
Labels: type:story, module:infrastructure, priority:high
Milestone: Phase 1 - Foundation
```

**Story 3:**
```
Title: [STORY] Create initial solution structure with modular monolith architecture
Labels: type:story, module:infrastructure, priority:high  
Milestone: Phase 1 - Foundation
```

### 8.2 Update New Stories

For each new story, set:
- **Sprint:** `Sprint 0 - Foundation`
- **Module:** `Infrastructure`
- **Priority:** `🔥 Critical` or `🟠 High`
- **Story Points:** `3`, `5`, or `8`

## Step 9: Team Workflow Setup

### 9.1 Daily Workflow

**For Team Members:**
1. **Check "👥 Team Workload" view** to see assigned work
2. **Move items** through columns as work progresses:
   - 📋 Backlog → 📅 Ready (when starting)
   - 📅 Ready → 🔄 In Progress (when actively working)
   - 🔄 In Progress → 👁️ Review (when ready for code review)
   - 👁️ Review → 🧪 Testing (when approved)
   - 🧪 Testing → ✅ Done (when complete)

### 9.2 Sprint Planning Workflow

**Weekly Sprint Planning:**
1. **Use "📅 Sprint Planning" view** (table format)
2. **Filter by current sprint** (e.g., `sprint:"Sprint 0 - Foundation"`)
3. **Assign story points** and team members
4. **Move planned items** from Backlog to Ready

### 9.3 Progress Tracking

**Use different views for different purposes:**
- **🏗️ Module Overview:** See progress by feature area
- **🎯 Priority Focus:** Ensure high-priority items are handled first
- **👥 Team Workload:** Balance work across team members

## Step 10: Mobile Access (Optional)

### 10.1 GitHub Mobile App

1. **Install GitHub mobile app**
2. **Sign in** and navigate to your project
3. **Enable notifications** for assigned issues and mentions
4. **Quick status updates** on the go

## Success Checklist

After completing this setup, you should have:

- [ ] 6 status columns configured
- [ ] 4 custom fields created (Story Points, Sprint, Module, Priority)
- [ ] 4 different views (Board, Sprint Planning, Module, Team, Priority)
- [ ] 3 basic automation workflows enabled
- [ ] Epic issues updated with field values
- [ ] Initial Sprint 0 stories created and configured
- [ ] Team members know the daily workflow

## Daily Usage Tips

### For Developers:
- **Check your assigned work** in Team Workload view
- **Update status** as you progress through tasks
- **Add story point estimates** when you understand the work better

### For Team Lead:
- **Use Sprint Planning view** for planning sessions
- **Monitor Module Overview** for feature progress
- **Check Priority Focus** to ensure critical items are moving

### For Sprint Reviews:
- **Filter by completed sprint** to see what was accomplished
- **Use table view** to see story points completed
- **Plan next sprint** using backlog items

## Maintenance

### Weekly:
- [ ] Update sprint assignments for upcoming work
- [ ] Review and estimate new backlog items
- [ ] Check for blocked items and resolve

### Monthly:
- [ ] Review velocity (story points completed per sprint)
- [ ] Adjust estimation practices if needed
- [ ] Clean up old completed items

---

**Setup Time:** 15-20 minutes  
**Result:** Functional project tracking that actually works with current GitHub Projects interface

This simplified setup gives you professional project management without the complexity of features that no longer exist or work reliably.