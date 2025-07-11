# GitHub Project Fields Configuration Guide

## Overview

This document provides the exact field configuration for your SAGA eCommerce organization project, including which fields to keep, delete, and add.

## Current GitHub Projects Default Fields

When you create a GitHub project, these fields exist by default:

| Field Name | Type | Keep/Delete | Reason |
|------------|------|-------------|---------|
| **Title** | Text | ✅ **KEEP** | Essential - issue/PR title |
| **Assignees** | People | ✅ **KEEP** | Essential - who's working on it |
| **Status** | Single Select | ✅ **KEEP** | Essential - workflow tracking |
| **Labels** | Labels | ✅ **KEEP** | Essential - categorization |
| **Linked Pull Requests** | Linked PRs | ✅ **KEEP** | Useful - shows PR connections |
| **Repository** | Repository | ✅ **KEEP** | Critical - shows which repo issue belongs to |
| **Milestone** | Milestone | ❌ **DELETE** | Use organization milestones instead |

## Custom Fields to Add

### Field 1: Business Milestone
- **Type:** Single select
- **Purpose:** Business-level milestone tracking across repositories
- **Options:**
  ```
  Multi-tenant Foundation
  Open Pages MVP  
  Phase 1 Complete
  Future Releases
  ```

### Field 2: Target Date
- **Type:** Date
- **Purpose:** Expected completion date for continuous flow planning
- **Usage:** Date ranges encouraged (e.g., "End of March" rather than "March 31")
- **Examples:**
  ```
  Epic: Multi-tenant Infrastructure → April 30, 2025
  Story: User Authentication → March 15, 2025
  Task: Database Schema Update → Next Week
  ```

### Field 3: Estimate
- **Type:** Number (GitHub built-in)
- **Purpose:** Story point estimation for tasks and stories
- **Usage:** 1, 2, 3, 5, 8, 13 (Fibonacci sequence)

### Field 4: Module
- **Type:** Single select
- **Purpose:** Feature area categorization
- **Options:**
  ```
  Infrastructure
  Catalog
  Channel
  Basket
  Order
  Payment
  Tenant Management
  Authentication
  Frontend
  DevOps
  ```

### Field 5: Priority
- **Type:** Single select
- **Purpose:** Business priority levels
- **Options:**
  ```
  🔥 Critical
  🟠 High  
  🟡 Medium
  🔵 Low
  ```

### Field 6: Work Item Age
- **Type:** Date (calculated)
- **Purpose:** Track how long items have been in active status (In Progress)
- **Usage:** Helps identify stuck items and flow bottlenecks
- **Implementation:** Calculate days since moved to "In Progress"

### Field 7: Team
- **Type:** Single select
- **Purpose:** Team assignment for multi-team coordination
- **Options:**
  ```
  Backend Team
  Frontend Team
  DevOps Team
  Full Stack
  ```

## Fields Usage by Issue Type

| Field | Epic | Story | Task | Bug | Purpose |
|-------|------|-------|------|-----|---------|
| **Title** | ✅ | ✅ | ✅ | ✅ | Issue identification |
| **Status** | ✅ | ✅ | ✅ | ✅ | Kanban workflow tracking |
| **Assignees** | ✅ | ✅ | ✅ | ✅ | Ownership |
| **Labels** | ✅ | ✅ | ✅ | ✅ | Categorization |
| **Repository** | ✅ | ✅ | ✅ | ✅ | Source identification |
| **Business Milestone** | ✅ | ❌ | ❌ | ❌ | Business planning |
| **Target Date** | ✅ | ✅ | ✅ | ✅ | Expected completion |
| **Estimate** | ❌ | ✅ | ✅ | Sometimes | Effort tracking (T-shirt sizing) |
| **Module** | ✅ | ✅ | ✅ | ✅ | Feature area |
| **Priority** | ✅ | ✅ | ✅ | ✅ | Business importance |
| **Work Item Age** | ❌ | ✅ | ✅ | ✅ | Flow metrics |
| **Team** | ✅ | ✅ | ✅ | ✅ | Team coordination |

## Step-by-Step Field Configuration

### Step 1: Delete Unnecessary Default Fields

**Repository Milestone Field:**
1. Go to project Settings → Fields
2. Find "Milestone" field 
3. Click "..." → Delete field
4. **Reason:** Using Business Milestone instead for cross-repo coordination

### Step 2: Configure Status Field Options

**Update Status Field Options:**
1. Click on "Status" field settings
2. Replace default options with:
   ```
   📋 Backlog
   📅 Ready  
   🔄 In Progress
   👁️ Review
   🧪 Testing
   ✅ Done
   ```

### Step 3: Add Custom Fields

**Add each custom field using the "+ Add field" button:**

**Business Milestone:**
- Name: "Business Milestone"
- Type: Single select
- Add options as listed above

**Iteration:**
- Look for "Iteration" in available fields (GitHub built-in)
- Add to project
- Configure iteration dates as specified

**Estimate:**
- Look for "Estimate" in available fields (GitHub built-in)  
- Add to project

**Module:**
- Name: "Module"
- Type: Single select
- Add options as listed above

**Priority:**
- Name: "Priority"
- Type: Single select  
- Add options as listed above

**Epic Timeline:**
- Name: "Epic Timeline"
- Type: Single select
- Add options as listed above

**Team:**
- Name: "Team"
- Type: Single select
- Add options as listed above

## Field Usage Examples

### Epic Configuration Example
```
Title: [EPIC] Multi-tenant Infrastructure Foundation
Status: 🔄 In Progress
Business Milestone: Multi-tenant Foundation
Epic Timeline: Iteration 1-2 (Multi-tenant)
Module: Infrastructure
Priority: 🔥 Critical
Team: Backend Team
Repository: saga-ecommerce-service
```

### Story Configuration Example  
```
Title: [STORY] As a developer I want tenant context setup
Status: 📅 Ready
Iteration: Iteration 1 - Multi-tenant Part 1
Estimate: 5
Module: Infrastructure  
Priority: 🔥 Critical
Team: Backend Team
Repository: saga-ecommerce-service
```

### Task Configuration Example
```
Title: [TASK] Implement tenant middleware pipeline
Status: 🔄 In Progress
Iteration: Iteration 1 - Multi-tenant Part 1
Estimate: 3
Module: Infrastructure
Priority: 🟠 High
Team: Backend Team
Assignees: @developer1
Repository: saga-ecommerce-service
```

## View-Specific Field Visibility

### Epic Roadmap View
**Show Fields:** Title, Business Milestone, Epic Timeline, Module, Priority, Team

### Sprint Planning View  
**Show Fields:** Title, Iteration, Estimate, Module, Priority, Assignees, Status

### Backend Development View
**Show Fields:** Title, Status, Assignees, Estimate, Priority
**Filter:** Repository = saga-ecommerce-service

### Frontend Development View
**Show Fields:** Title, Status, Assignees, Estimate, Priority  
**Filter:** Repository = saga-ecommerce-frontend

### Cross-Team Coordination View
**Show Fields:** Title, Team, Repository, Module, Status, Priority
**Group by:** Team

## Maintenance and Updates

### Monthly Field Review
- **Review unused options** in single-select fields
- **Add new modules** as system grows
- **Update iteration dates** for next quarter
- **Archive completed milestones**

### Field Performance Optimization
- **Limit single-select options** to 10-15 maximum
- **Use consistent naming** across all fields
- **Regular cleanup** of obsolete values

## Common Field Mistakes to Avoid

### ❌ Don't Do This:
- **Too many custom fields** (>10 becomes cluttered)
- **Repository milestones AND business milestones** (redundant)
- **Overly granular priority levels** (5+ options)
- **Team names that change frequently**

### ✅ Do This Instead:
- **Essential fields only** (7-8 custom fields maximum)
- **Organization milestones only** for cross-repo work
- **Simple priority scale** (4 levels: Critical/High/Medium/Low)  
- **Stable team structure** aligned with organizational structure

## Troubleshooting Field Issues

### Issue: Field not showing in views
**Solution:** Check view column configuration and field visibility settings

### Issue: Too many options in single-select
**Solution:** Consolidate similar options, archive unused values

### Issue: Team confusion about field usage
**Solution:** Add field descriptions and create team training on field usage

### Issue: Fields not syncing across repositories  
**Solution:** Verify organization project is properly linked to both repositories

---

**Configuration Time:** 30-45 minutes  
**Maintenance:** 15 minutes monthly  
**Result:** Optimized project fields for epic spanning and multi-repository coordination