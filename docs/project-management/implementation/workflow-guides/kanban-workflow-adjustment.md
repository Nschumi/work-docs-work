# Kanban Workflow Adjustment Guide

## Moving from Sprint/Iteration to Continuous Flow

Since you're focusing on **continuous feature delivery** rather than fixed sprints, here's how to adjust your GitHub Project setup.

## What to Remove

### ❌ Remove These Fields:
- **Iteration field** - Not needed for Kanban
- **Sprint Planning status** - Kanban uses continuous refinement
- **Sprint-based views** - Replace with flow-based views

### ❌ Remove These Concepts:
- Sprint planning meetings
- Sprint reviews
- Iteration assignments
- Sprint velocity tracking

## What to Keep/Add

### ✅ Keep These Fields:

| Field | Purpose | Why It Matters in Kanban |
|-------|---------|--------------------------|
| **Business Milestone** | Major deliverables | Still need business targets |
| **Target Date** | Expected completion | Helps with planning |
| **Priority** | Work sequencing | Critical for Kanban flow |
| **Module** | Feature area | Organization and filtering |
| **Estimate** | Size indicator | Helps predict cycle time |
| **Team** | Assignment | Who's working on what |

### ✅ Add These Kanban-Specific Fields:

**1. Work Item Age**
- Type: Date (started date)
- Purpose: Track how long items have been in progress
- Helps identify stuck items

**2. Target Week/Month**
- Type: Single select (Week 1, Week 2, etc. or Jan, Feb, Mar)
- Purpose: Loose planning without fixed sprints
- More flexible than iterations

**3. Class of Service**
- Type: Single select
- Options: Standard, Expedite, Fixed Date, Intangible
- Purpose: Kanban flow prioritization

## Adjusted Status Flow for Kanban

### Simplified Status Options:
```
📋 Backlog → ✨ Ready → 🔄 In Progress → 👁️ Review → ✅ Done → 🚫 Blocked
```

**Removed:** Planning, Testing (can be part of In Progress)

### WIP Limits by Status:
- **Ready:** Max 10-15 items
- **In Progress:** Max 1-2 per developer
- **Review:** Max 3-5 items
- **Blocked:** Should be zero (urgent attention)

## Updated Workflow Definitions

### Epic Flow (Feature Sets)
```
Business Milestone Assignment → Active Development → Completed
```
- Epics represent feature sets tied to business milestones
- No iteration assignment needed
- Track via milestone progress

### Story/Task Flow (Individual Work Items)
```
Backlog → Ready (refined) → In Progress → Review → Done
```
- Continuous flow, no sprint boundaries
- Pull when capacity available
- Focus on cycle time, not velocity

## Views for Kanban Workflow

### 1. Kanban Board (Primary View)
- **Layout:** Board
- **Columns:** Backlog, Ready, In Progress, Review, Done
- **Group by:** Status
- **Sort by:** Priority
- **Show:** WIP limits per column

### 2. Milestone Progress View
- **Layout:** Table
- **Filter:** `label:type:epic`
- **Group by:** Business Milestone
- **Sort by:** Target Date
- **Purpose:** Track feature delivery progress

### 3. Priority Queue View
- **Layout:** Table
- **Filter:** `status:ready`
- **Sort by:** Priority (desc), Work Item Age (desc)
- **Purpose:** What to pull next

### 4. Cycle Time Analysis View
- **Layout:** Table
- **Columns:** Title, Started Date, Completed Date, Cycle Time
- **Filter:** `status:done` last 30 days
- **Purpose:** Flow metrics

### 5. Blocked Items View
- **Layout:** Board
- **Filter:** `status:blocked`
- **Group by:** Reason for blocking
- **Purpose:** Impediment management

## Metrics for Kanban

### Instead of Sprint Velocity, Track:

**1. Cycle Time**
- Average time from In Progress → Done
- Target: < 3 days for tasks, < 5 days for stories

**2. Lead Time**
- Time from Ready → Done
- Includes wait time in Ready queue

**3. Throughput**
- Items completed per week
- More variable than velocity, but that's OK

**4. Flow Efficiency**
- Active time / Total time
- Identifies wait states

**5. WIP Limits**
- Are they being respected?
- Adjust based on flow

## Planning Without Sprints

### Continuous Planning Approach:

**1. Weekly Refinement**
- Review top 10 items in backlog
- Ensure 5-8 items are "Ready"
- No fixed sprint commitment

**2. Milestone Planning**
- Review monthly for milestone progress
- Adjust epic priorities
- Update target dates

**3. Daily Flow Management**
- Check WIP limits
- Clear blockers
- Pull new work when capacity available

## Benefits of This Approach

### ✅ What You Gain:
- **Flexibility** - Start work when ready, not waiting for sprint
- **Faster delivery** - No artificial sprint boundaries
- **Less overhead** - No sprint ceremonies
- **Better flow** - Focus on continuous improvement
- **Real metrics** - Cycle time more accurate than velocity

### ✅ What You Keep:
- **Business alignment** - Still have milestones
- **Feature tracking** - Epics tied to deliverables
- **Priority management** - Clear what's next
- **Team coordination** - Who's working on what

## Implementation Steps

1. **Remove Iteration field** from project
2. **Add Target Date field** for loose planning
3. **Simplify status options** (remove Planning)
4. **Create Kanban views** listed above
5. **Set WIP limits** in team agreement
6. **Start tracking cycle time** instead of velocity

## Team Agreement for Kanban

Document these agreements:

### WIP Limits:
- Each developer: Max 2 items In Progress
- Team total In Progress: Max 8 items
- Review queue: Max 5 items

### Pull Policies:
- Pull highest priority from Ready
- Can expedite if critical
- Must finish current before pulling new

### Definition of Ready:
- Clear acceptance criteria
- Estimated (if needed)
- No blockers identified
- Priority assigned

### Definition of Done:
- Code complete and reviewed
- Tests passing
- Deployed to staging
- Documentation updated

## Common Questions

**Q: How do we plan without sprints?**
A: Use milestone targets and weekly refinement. Plan continuously, deliver continuously.

**Q: How do we track progress?**
A: Milestone progress, throughput trends, and cycle time metrics.

**Q: What about deadlines?**
A: Use Target Date field and Class of Service for fixed-date items.

**Q: How do we coordinate releases?**
A: Release when features are ready, not on sprint boundaries.

---

**Result:** A lean, continuous flow system focused on delivering features as fast as possible without sprint overhead.