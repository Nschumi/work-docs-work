# Kanban Roadmap Guide

## How Roadmaps Work Without Sprints

In Kanban, roadmaps focus on **continuous flow of features** rather than sprint boundaries. Here's how to make GitHub roadmaps work for your Kanban workflow.

## Roadmap Building Blocks

### 1. Business Milestones (Fixed Dates)
```
Multi-tenant Foundation ──────► Open Pages MVP ──────► Phase 1 Complete
      (May 2025)                 (July 2025)           (October 2025)
```

### 2. Epic Timeline (Flexible Duration)
```
Epic: Multi-tenant Infrastructure ████████████░░░░
Epic: Product Catalog            ░░░░████████░░░
Epic: Channel Module             ░░░░░░░░████████
```

### 3. Feature Flow (Continuous)
```
Ready Queue → In Progress → Done → Ready Queue → In Progress → Done
    ↓             ↓          ↓         ↓             ↓          ↓
 Feature A    Feature A   Feature A  Feature B   Feature B  Feature B
```

## Setting Up GitHub Roadmap for Kanban

### Step 1: Configure Epic Date Fields

**Add these fields to your project:**

**Epic Start Date**
- Type: Date
- Purpose: When epic work begins
- Example: March 1, 2025

**Epic Target Date**
- Type: Date  
- Purpose: Expected completion
- Example: April 30, 2025

**Epic Status**
- Type: Single select
- Options: Not Started, Active, Complete
- Purpose: High-level progress

### Step 2: Create Roadmap View

**Roadmap Configuration:**
1. Click **"+ New view"**
2. Select **"Roadmap"** layout
3. **Name:** "Feature Delivery Roadmap"
4. **Date fields:** Epic Start Date → Epic Target Date
5. **Group by:** Business Milestone
6. **Filter:** `label:type:epic`

### Step 3: Epic Planning Without Sprints

**Epic Attributes for Roadmap:**
```markdown
Title: [EPIC] Product Catalog Module
Business Milestone: Open Pages MVP
Epic Start Date: March 1, 2025
Epic Target Date: April 30, 2025
Status: Active
Progress: 40% (based on completed stories)
```

## Roadmap Visualization Patterns

### Pattern 1: Milestone-Based Roadmap
```
Q1 2025          Q2 2025          Q3 2025          Q4 2025
│                │                │                │
├─ Foundation ───┤                │                │
│                ├─ Open Pages ───┤                │
│                │                ├─ Phase 1 ──────┤
│                │                │                │
[Infrastructure] [Catalog+Channel] [Full Platform]
```

### Pattern 2: Epic Flow Roadmap
```
Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Multi-tenant Infrastructure     ]
         [Product Catalog Module          ]
                  [Channel Module         ]
                           [Basket Module      ]
                                    [Order+Payment    ]
```

### Pattern 3: Continuous Delivery Roadmap
```
Now (In Progress)     Next (Ready)        Later (Backlog)
─────────────────    ──────────────      ────────────────
• Tenant Context     • Product CRUD       • Payment Gateway
• Base Entities      • Category Mgmt      • Order Workflow
• Middleware         • Search API         • Subscription Mgmt
```

## Key Differences from Sprint Roadmaps

### Sprint-Based Roadmap:
- Fixed 2-week increments
- Rigid sprint boundaries
- Velocity-based planning
- Sprint commitment focus

### Kanban Roadmap:
- **Flexible timelines** based on flow
- **Continuous delivery** markers
- **Throughput-based** planning
- **Target date ranges** not fixed sprints

## Creating Effective Kanban Roadmaps

### 1. Use Date Ranges, Not Fixed Points
```
Bad:  Epic completes on April 15
Good: Epic target: Mid-April (April 10-20)
```

### 2. Show Flow Metrics
```
Epic: Product Catalog
Target: April 30
Current Throughput: 5 stories/week
Remaining: 15 stories
Projected: ~3 weeks (on track)
```

### 3. Visualize Dependencies
```
Infrastructure Epic ──────────┐
                             ↓
                    Catalog Epic ─────────┐
                                         ↓
                                 Channel Epic
```

## Roadmap Views for Different Audiences

### Executive Roadmap View
**Focus:** Business milestones and major deliverables
```
Configuration:
- Layout: Roadmap
- Group by: Business Milestone
- Show: Epic titles and progress
- Hide: Technical details
```

### Product Roadmap View
**Focus:** Feature delivery sequence
```
Configuration:
- Layout: Roadmap  
- Group by: Module
- Show: Epics and major stories
- Date field: Target completion dates
```

### Team Roadmap View
**Focus:** Current and upcoming work
```
Configuration:
- Layout: Table
- Columns: Now/Next/Later
- Group by: Priority
- Sort by: Target date
```

## Planning Without Sprint Boundaries

### Monthly Planning Rhythm
```
Week 1: Review milestone progress
Week 2: Adjust epic target dates
Week 3: Refine upcoming features
Week 4: Update roadmap communication
```

### Continuous Adjustments
- **Weekly:** Update epic progress percentages
- **Bi-weekly:** Adjust target dates based on throughput
- **Monthly:** Communicate roadmap changes

## Roadmap Metrics for Kanban

### Track These Instead of Sprint Burndown:

**1. Epic Cycle Time**
- Historical: How long do epics actually take?
- Use for future planning

**2. Feature Throughput**
- Stories completed per week
- Helps predict epic completion

**3. Milestone Confidence**
```
High (>90%): On track, good throughput
Medium (70-90%): Some risk, monitor closely
Low (<70%): At risk, need intervention
```

## Example Roadmap Setup

### Epic Configuration:
```yaml
Epic: Product Catalog Module
Business Milestone: Open Pages MVP
Start Date: March 1, 2025
Target Date: April 30, 2025
Child Stories: 20 total
Completed: 8
In Progress: 3
Throughput: 4 stories/week
Confidence: High (85%)
```

### Roadmap Display:
```
        Mar         Apr         May         Jun         Jul
        │           │           │           │           │
────────[Product Catalog Epic  ]
        ████████████░░░░░░░░░░░
              40% Complete
                    ↓
                    └──[Channel Module Epic    ]
                       ░░░░░░░░░░░░░░░░░░░░░░░
                          0% (Not Started)
```

## Common Roadmap Questions

**Q: How do we commit to dates without sprints?**
A: Use confidence levels and date ranges. Communicate probability, not false precision.

**Q: How far ahead should we plan?**
A: 
- Detailed: 4-6 weeks
- High-level: 3-4 months  
- Strategic: 6-12 months

**Q: What if things change?**
A: That's the point! Kanban roadmaps are living documents. Update weekly based on actual flow.

**Q: How do we show progress?**
A: Epic completion percentage, milestone confidence, and throughput trends.

## Tools and Automation

### GitHub Roadmap Features That Work Well:
- **Date ranges** for epics
- **Progress tracking** via child issues
- **Dependency lines** between epics
- **Milestone markers** for key dates

### What to Avoid:
- Fixed sprint markers
- Velocity calculations
- Commitment lines
- False precision in dates

## Success Criteria

Your Kanban roadmap is working when:

✅ **Stakeholders understand** what's coming and roughly when  
✅ **Team isn't stressed** about sprint commitments  
✅ **Dates adjust** based on actual throughput  
✅ **Focus remains** on flow, not time boxes  
✅ **Updates are easy** and frequent

---

**Key Insight:** Kanban roadmaps show the **flow of value delivery** rather than **time-boxed commitments**. This gives you flexibility while still providing visibility into what's coming next.