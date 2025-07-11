# How We Work with GitHub

## Overview

This document defines how the SAGA eCommerce team uses GitHub for project management, from business planning to development execution. Our approach aligns business deliverables with development workflows while maintaining clear ownership at each level.

## Core Principles

1. **Business owns epics** - Features that customers can verify
2. **Product team owns stories** - User value delivered incrementally  
3. **Development team owns tasks** - Technical work and estimates
4. **Clear hierarchy** - Roadmap → Features → Delivery → Execution

## Work Item Hierarchy

```
Milestone (Business Timeline)
├── Epic (Customer Feature) 
│   ├── Story (User Value)
│   │   ├── Task (Dev Work)
│   │   └── Task (Dev Work)
│   └── Story (User Value)
└── Epic (Customer Feature)
```

## Definitions

### Milestones
**Purpose:** Business deliverables and external commitments  
**Owner:** Project Manager / Business  
**Timeline:** Months (external deadlines)  
**Examples:**
- "Open Pages MVP" (July 2025)
- "Phase 1 Complete" (October 2025)
- "Multi-tenant Foundation" (May 2025)

**What goes in milestones:**
- Customer-facing deliverables
- Integration points with other teams
- Production releases
- Business commitments and contracts

### Epics
**Purpose:** Complete customer features that can be verified  
**Owner:** Product Owner / Business  
**Timeline:** 2-6 weeks (may span multiple iterations)  
**Examples:**
- "Product Catalog with Search"
- "Multi-tenant Infrastructure"
- "Channel Management for Open Pages"

**Epic characteristics:**
- Something a customer can test and accept
- Delivers complete business value
- Can be demoed independently
- Maps to business requirements

### Stories
**Purpose:** User value delivered incrementally  
**Owner:** Product Owner  
**Timeline:** 1-2 iterations  
**Format:** "As a [user] I want [goal] so that [benefit]"

**Examples:**
- "As a tenant admin I want to search products by category so that I can quickly find relevant items"
- "As a developer I want tenant context resolution so that I can build tenant-aware features"

### Tasks
**Purpose:** Technical implementation work  
**Owner:** Development Team  
**Timeline:** 1-3 days  
**Estimated:** Yes (1, 2, 3, 5, 8 points)

**Examples:**
- "Implement search API endpoint with pagination"
- "Add tenant context middleware to request pipeline"
- "Create unit tests for product repository"

## Multi-Repository Strategy

### Repository Structure

The SAGA eCommerce platform consists of two main repositories:

- **`saga-ecommerce-service`** - Backend API (.NET 9.0, modular monolith)
- **`saga-ecommerce-frontend`** - Frontend application (SvelteKit, whitelabel)

### Organization-Level Project Management

**Primary Approach: Organization-Level Project Board**

**Setup:**
- **Organization:** `Nuuday`
- **Project:** "SAGA eCommerce Platform" 
- **Scope:** Links both repositories for unified management
- **Owner:** Project Manager with organization admin rights

**Benefits:**
- Single source of truth for business planning
- Cross-repository dependency tracking
- Unified milestone and epic management
- Coordinated release planning

### Cross-Repository Coordination

**Milestone Strategy:**
```
Organization Milestone: "Open Pages MVP"
├── Backend Epic: Product Catalog API (saga-ecommerce-service)
├── Frontend Epic: Search UI Components (saga-ecommerce-frontend)  
├── Integration Epic: API-Frontend Integration (both repos)
└── Deployment Epic: Production Release (both repos)
```

**Epic Distribution:**
- **Backend Epics:** API features, data models, business logic
- **Frontend Epics:** UI components, user flows, integrations
- **Cross-cutting Epics:** Authentication, deployment, monitoring

**Dependency Management:**
- **Use GitHub issue references:** `saga-ecommerce-frontend#123 depends on saga-ecommerce-service#456`
- **Epic-level coordination:** Frontend epics reference backend epics they depend on
- **Story-level links:** Frontend stories link to required backend endpoints

### Repository-Specific Views

**Organization Project Views:**

**1. Cross-Repository Milestone View**
- **Filter:** All repositories
- **Group by:** Milestone
- **Purpose:** Business progress tracking

**2. Backend Development View**  
- **Filter:** `repo:saga-ecommerce-service AND (type:story OR type:task)`
- **Group by:** Status
- **Purpose:** API team daily workflow

**3. Frontend Development View**
- **Filter:** `repo:saga-ecommerce-frontend AND (type:story OR type:task)`  
- **Group by:** Status
- **Purpose:** Frontend team daily workflow

**4. Integration Coordination View**
- **Filter:** `label:integration OR label:cross-repo`
- **Group by:** Repository
- **Purpose:** Track cross-team dependencies

**5. Release Planning View**
- **Filter:** `type:epic`
- **Group by:** Repository, then Milestone
- **Purpose:** Coordinate release scope

## GitHub Configuration

### Labels Strategy

**Type Labels:**
- `type:epic` - Business features
- `type:story` - User stories  
- `type:task` - Development tasks
- `type:bug` - Bug fixes

**Module Labels:**
- `module:catalog` - Product catalog
- `module:channel` - Channel management
- `module:infrastructure` - Cross-cutting concerns

**Priority Labels:**
- `priority:critical` - Immediate business impact
- `priority:high` - Important for milestone
- `priority:medium` - Standard priority
- `priority:low` - Nice to have

**Repository Labels:**
- `repo:backend` - Backend-specific work
- `repo:frontend` - Frontend-specific work
- `cross-repo` - Requires coordination across repositories
- `integration` - Integration between systems

### Field Usage by Type

| Field | Epic | Story | Task | Purpose |
|-------|------|-------|------|---------|
| **Milestone** | ✅ | ❌ | ❌ | Business timeline |
| **Iteration** | ❌ | ✅ | ✅ | Sprint planning |
| **Estimate** | ❌ | ❌ | ✅ | Development effort |
| **Module** | ✅ | ✅ | ✅ | Feature area |
| **Priority** | ✅ | ✅ | ✅ | Business importance |

### Project Views

**1. Business Roadmap View**
- **Layout:** Table
- **Filter:** `type:epic`
- **Columns:** Title, Milestone, Module, Priority, Status
- **Sort:** Milestone, Priority
- **Purpose:** Track business deliverables

**2. Epic Progress View**  
- **Layout:** Board
- **Group by:** Status
- **Filter:** `type:epic`
- **Purpose:** Monitor feature completion

**3. Sprint Planning View**
- **Layout:** Table  
- **Filter:** `type:story OR type:task`
- **Columns:** Title, Iteration, Estimate, Assignee, Status
- **Sort:** Iteration, Priority
- **Purpose:** Plan and track iterations

**4. Development Board**
- **Layout:** Board
- **Group by:** Status  
- **Filter:** `type:task OR type:bug`
- **Purpose:** Daily development workflow

**5. Module Overview**
- **Layout:** Board
- **Group by:** Module
- **Filter:** `-status:Done`
- **Purpose:** Track work by feature area

## Workflow

### 1. Business Planning (Quarterly)
1. **Create milestones** for business deliverables
2. **Define epics** that deliver milestone value
3. **Assign epics to milestones**
4. **Prioritize epics** based on business value

### 2. Feature Planning (Epic Level)
1. **Break epics into stories** that deliver user value
2. **Write acceptance criteria** for each story
3. **Estimate story complexity** (t-shirt sizes: S/M/L/XL)
4. **Assign stories to iterations** based on capacity

### 3. Sprint Planning (Task Level)
1. **Break stories into tasks** (development work)
2. **Estimate tasks in story points** (1, 2, 3, 5, 8)
3. **Assign tasks to developers**
4. **Move tasks to Ready status**

### 4. Development Execution (Daily)
1. **Pick tasks from Ready**
2. **Move through status columns:** Ready → In Progress → Review → Testing → Done
3. **Update estimates** if actual effort differs
4. **Create new tasks** if scope increases

## Status Flow

### Epic Status Flow
```
Planning → Active → Completed
```

### Story Status Flow  
```
Backlog → Ready → In Progress → Review → Done
```

### Task Status Flow
```
Backlog → Ready → In Progress → Review → Testing → Done
```

## Estimation Guidelines

### Epic Sizing (Business Planning)
- **Small (S):** 1-2 iterations
- **Medium (M):** 2-4 iterations  
- **Large (L):** 4-6 iterations
- **Extra Large (XL):** Split into multiple epics

### Task Estimation (Development)
- **1 point:** Simple change, 1-2 hours
- **2 points:** Small feature, half day
- **3 points:** Medium feature, 1 day
- **5 points:** Complex feature, 2 days  
- **8 points:** Very complex, split if possible
- **13+ points:** Must be broken down

## Ceremonies and Reviews

### Epic Review (Business)
- **Frequency:** End of epic
- **Participants:** Product Owner, Stakeholders, Customer
- **Purpose:** Verify business value delivered
- **Outcome:** Epic accepted or additional work identified

### Iteration Review (Product)
- **Frequency:** End of iteration (2 weeks)
- **Participants:** Product Owner, Development Team
- **Purpose:** Demo completed stories
- **Outcome:** Stories accepted or feedback provided

### Daily Standups (Development)
- **Frequency:** Daily
- **Participants:** Development Team
- **Focus:** Task progress and blockers
- **Duration:** 15 minutes maximum

## Metrics and Reporting

### Business Metrics (Milestone Level)
- **Epic completion rate** by milestone
- **Milestone delivery confidence**
- **Business value delivered per quarter**

### Product Metrics (Iteration Level)  
- **Story points completed per iteration**
- **Velocity trends over time**
- **Story cycle time** (Ready → Done)

### Development Metrics (Task Level)
- **Task completion rate**
- **Estimation accuracy**
- **Code review turnaround time**

## Guidelines and Best Practices

### Writing Good Epics
- **Customer-focused:** Describe business value, not technical implementation
- **Testable:** Include clear acceptance criteria
- **Valuable:** Delivers standalone business value
- **Time-boxed:** Can be completed within milestone timeline

### Writing Good Stories
- **User perspective:** Use "As a... I want... So that..." format
- **Acceptance criteria:** Clear Given-When-Then scenarios
- **Sized appropriately:** Can be completed in 1-2 iterations
- **Independent:** Not dependent on other stories in same iteration

### Writing Good Tasks  
- **Specific:** Clear technical implementation details
- **Testable:** Include what tests need to be written
- **Estimated:** Development team provides story point estimate
- **Assigned:** Clear ownership for completion

## Common Patterns

### Feature Development Pattern
1. **Epic created** by Product Owner with business requirements
2. **Stories written** to break down user value
3. **Tasks created** by developers for implementation
4. **Development execution** following sprint process
5. **Epic review** with stakeholders and customer acceptance

### Bug Fix Pattern
1. **Bug reported** with reproduction steps
2. **Triage and prioritization** by Product Owner
3. **Task creation** for fix implementation
4. **Standard development flow** for resolution

### Research/Spike Pattern
1. **Spike story** created for investigation
2. **Time-boxed research** with specific questions
3. **Findings documented** in story comments
4. **Follow-up tasks** created based on learnings

## Tool Integration

### GitHub Projects Integration
- **Automatic issue linking** to project board
- **Status automation** based on PR activity
- **Custom fields** for estimation and categorization
- **Multiple views** for different stakeholder needs

### Development Workflow Integration
- **Branch naming:** Include issue number (`feature/123-add-search`)
- **PR linking:** Use "Fixes #123" to auto-close issues
- **Status updates:** PR creation moves tasks to Review
- **Merge completion:** Automatically moves to Done

## Success Criteria

Our GitHub workflow is successful when:

- **Business stakeholders** can track milestone progress
- **Product owners** can plan and prioritize effectively  
- **Developers** have clear, estimated work items
- **Customers** can verify delivered features
- **Team velocity** is predictable and improving
- **Work visibility** is clear across all levels

## Project Board Setup and Maintenance

### Initial Setup Checklist

**Organization Project Creation:**
- [ ] Create organization-level project: "SAGA eCommerce Platform"
- [ ] Link both repositories (`saga-ecommerce-service`, `saga-ecommerce-frontend`)
- [ ] Configure auto-add workflows for both repositories
- [ ] Set up admin access for Project Manager

**Custom Fields Setup:**
- [ ] Add "Estimate" field (GitHub built-in number field)
- [ ] Add "Iteration" field (GitHub built-in iteration field)
- [ ] Add "Module" field (single select with 8 options)
- [ ] Add "Priority" field (single select: Critical/High/Medium/Low)
- [ ] Add "Repository" field (single select: Backend/Frontend/Both)

**Views Configuration:**
- [ ] Cross-Repository Milestone View (table layout, group by milestone)
- [ ] Backend Development View (board layout, filter backend tasks)
- [ ] Frontend Development View (board layout, filter frontend tasks)
- [ ] Integration Coordination View (board layout, cross-repo items)
- [ ] Release Planning View (table layout, epic overview)

**Automation Setup:**
- [ ] Auto-add issues from both repositories
- [ ] Auto-move to Done when issues closed
- [ ] Auto-move to Done when PRs merged

### Iteration Setup

**Configure iterations for coordinated development:**

**Iteration 0 - Foundation (2 weeks)**
- Backend: Project setup, CI/CD, infrastructure
- Frontend: Project setup, design system, basic routing

**Iteration 1-2 - Multi-tenant Infrastructure (4 weeks)**  
- Backend: Tenant context, middleware, base entities
- Frontend: Tenant switching UI, context management

**Iteration 3-4 - Product Catalog (4 weeks)**
- Backend: Product CRUD, search API, categories
- Frontend: Product list, search interface, filters

**Iteration 5-6 - Channel Management (4 weeks)**
- Backend: Channel CRUD, visibility rules, associations
- Frontend: Channel management UI, visibility controls

**Iteration 7 - Open Pages Integration (2 weeks)**
- Backend: Open Pages API endpoints, data sync
- Frontend: Contentful integration, public-facing pages

**Iteration 8-9 - Production Readiness (4 weeks)**
- Backend: Performance, monitoring, documentation  
- Frontend: Optimization, error handling, deployment

### Daily Maintenance

**Project Manager Tasks (Daily - 10 minutes):**
- [ ] Review blocked items across both repositories
- [ ] Check cross-repository dependencies for completion
- [ ] Update milestone progress indicators
- [ ] Escalate blockers that affect other teams

**Team Lead Tasks (Daily - 5 minutes):**
- [ ] Move completed items to appropriate status
- [ ] Assign new work items to team members
- [ ] Update estimates if scope changes
- [ ] Review integration coordination items

**Developer Tasks (Daily - 2 minutes):**
- [ ] Update task status as work progresses
- [ ] Add comments for cross-repository coordination
- [ ] Link PRs to appropriate issues
- [ ] Flag blockers immediately

### Weekly Maintenance

**Iteration Planning (Every 2 weeks - 2 hours):**
- [ ] Review previous iteration velocity (both teams)
- [ ] Plan next iteration capacity and assignments
- [ ] Coordinate cross-repository dependencies
- [ ] Update epic progress and timeline estimates
- [ ] Review and update milestone delivery confidence

**Project Health Check (Weekly - 30 minutes):**
- [ ] Review automation workflow effectiveness
- [ ] Check for orphaned or misassigned items
- [ ] Validate cross-repository linking accuracy
- [ ] Update project views if team needs change
- [ ] Review and clean up old completed items

### Monthly Maintenance

**Process Review (Monthly - 1 hour):**
- [ ] Analyze velocity trends across both repositories
- [ ] Review estimation accuracy and adjust if needed
- [ ] Evaluate workflow effectiveness and team feedback
- [ ] Update custom fields or views based on learnings
- [ ] Review milestone delivery patterns and adjust planning

**Project Board Optimization (Monthly - 30 minutes):**
- [ ] Archive completed milestones and epics
- [ ] Review and update automation rules
- [ ] Clean up unused labels or fields
- [ ] Optimize views based on actual usage patterns
- [ ] Update documentation based on process changes

### Troubleshooting Common Issues

**Missing Cross-Repository Links:**
- **Problem:** Frontend work blocked by backend epic
- **Solution:** Add issue references (`depends on saga-ecommerce-service#123`)
- **Prevention:** Include dependency review in planning

**Automation Not Working:**
- **Problem:** Items not auto-moving to Done
- **Solution:** Check repository permissions and workflow status
- **Prevention:** Test automation monthly with sample items

**Inconsistent Status Updates:**
- **Problem:** Items stuck in "In Progress" 
- **Solution:** Daily team reminder to update status
- **Prevention:** Add status updates to daily standup agenda

**Epic Progress Unclear:**
- **Problem:** Hard to see epic completion across repositories
- **Solution:** Use milestone view and epic progress tracking
- **Prevention:** Regular epic review in iteration planning

### Success Metrics

**Project Management Effectiveness:**
- Cross-repository coordination incidents < 2 per iteration
- Milestone delivery confidence accuracy > 85%
- Epic completion timeline accuracy > 80%

**Team Productivity:**
- Daily status update compliance > 90%
- Blocked item resolution time < 2 days  
- Cross-team dependency lead time < 1 iteration

**Process Efficiency:**
- Project board maintenance time < 15 minutes/day total
- Planning meeting duration stable or decreasing
- Team satisfaction with process > 4/5 in retrospectives

---

**Document Owner:** Project Management Team  
**Last Updated:** 2025-01-11  
**Review Schedule:** Monthly or when process changes needed