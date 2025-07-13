# Roadmap View Setup Guide for Business Milestones

## Overview

This guide shows you exactly how to configure GitHub's roadmap view to work with your Business Milestone field and Kanban workflow.

## Prerequisites

- ✅ Organization project created
- ✅ Business Milestone field added (Single select)
- ✅ Target Date field added (Date)
- ✅ Epics created with both fields populated

## Step-by-Step Roadmap Setup

### Step 1: Create the Roadmap View

1. **Go to your organization project**
   - Navigate to your "SAGA eCommerce Platform" project

2. **Click "+ New view"**
   - Located at the top of your project

3. **Configure Basic Settings:**
   - **Name:** "📍 Business Roadmap"
   - **Layout:** Select **"Roadmap"**

### Step 2: Configure Date Fields for Timeline

**Roadmap requires start and end dates for timeline visualization.**

**Option A: Use Target Date for Both (Simple)**
1. **Start date field:** Target Date (minus estimated duration)
2. **End date field:** Target Date
3. **Result:** Shows when epics should complete

**Option B: Add Epic Start Date Field (Recommended)**
1. **Add new field:** "Epic Start Date" (Date type)
2. **Start date field:** Epic Start Date  
3. **End date field:** Target Date
4. **Result:** Shows full epic timeline

### Step 3: Configure Roadmap Grouping

**Group by Business Milestone:**
1. In roadmap view settings, find **"Group by"**
2. Select **"Business Milestone"**
3. **Result:** Roadmap shows swimlanes for each milestone

### Step 4: Set Filters

**Show only epics:**
1. **Filter:** `label:type:epic`
2. **Purpose:** Roadmap only shows business-level features
3. **Hide:** Stories and tasks (too granular for roadmap)

## Complete Roadmap Configuration

### Final Settings:
```
View Name: 📍 Business Roadmap
Layout: Roadmap
Start Date Field: Epic Start Date (or Target Date)
End Date Field: Target Date
Group By: Business Milestone
Sort By: Target Date (ascending)
Filter: label:type:epic
```

## Example Roadmap Layout

```
SAGA eCommerce Business Roadmap

Multi-tenant Foundation (May 2025)
├─────[Multi-tenant Infrastructure Epic]████████████████░░░░
      Mar 1 ────────────────────────────────→ Apr 30

Open Pages MVP (July 2025)  
├─────[Product Catalog Epic]░░░░░░░░░░░░████████████████░░░░
      ────────────────────────Apr 1 ────────────────→ Jun 15
├─────[Channel Module Epic]░░░░░░░░░░░░░░░░░░░░░░░░████████████
      ──────────────────────────────────May 1 ────→ Jul 1

Phase 1 Complete (October 2025)
├─────[Integration Epic]░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░████████
      ──────────────────────────────────────────Jul 15 → Oct 1
```

## Advanced Roadmap Features

### Epic Progress Tracking

**Show completion percentage:**
1. **Progress calculation:** Based on child stories completed
2. **Visual indicator:** Progress bar on epic timeline
3. **Updates:** Automatic as stories move to Done

### Dependency Lines

**Show epic dependencies:**
1. **Epic A blocks Epic B:** Line connects them on roadmap
2. **Setup:** Add dependencies in epic descriptions
3. **Visual:** Arrows showing prerequisite relationships

### Milestone Markers

**Add milestone markers:**
1. **Business deadlines:** Vertical lines on specific dates
2. **External dependencies:** Integration points with other teams
3. **Release dates:** Production deployment markers

## Roadmap View Variants

### Executive Roadmap
```
Name: 🎯 Executive Overview
Filter: label:type:epic AND priority:critical
Group By: Business Milestone
Focus: High-level business deliverables only
```

### Product Roadmap
```
Name: 🚀 Product Features
Filter: label:type:epic
Group By: Module
Focus: Feature delivery by area
```

### Release Roadmap
```
Name: 📦 Release Planning
Filter: label:type:epic AND Business Milestone != "Future Releases"
Group By: Target Date (quarterly)
Focus: Confirmed delivery timeline
```

## Setting Up Epic Date Fields

### Add Epic Start Date Field

1. **Click "+ Add field"**
2. **Name:** "Epic Start Date"
3. **Type:** Date
4. **Description:** "When epic development begins"

### Populate Epic Dates

**For each epic, set:**
- **Epic Start Date:** When development starts (e.g., March 1, 2025)
- **Target Date:** Expected completion (e.g., April 30, 2025)
- **Business Milestone:** Which business deliverable (e.g., "Multi-tenant Foundation")

## Example Epic Configuration

```markdown
Epic: Multi-tenant Infrastructure Foundation
Epic Start Date: March 1, 2025
Target Date: April 30, 2025
Business Milestone: Multi-tenant Foundation
Module: Infrastructure
Priority: 🔥 Critical
Progress: 40% (8 of 20 stories complete)
```

## Roadmap Best Practices

### Date Management
- **Use realistic ranges:** "End of April" not "April 30"
- **Update regularly:** Weekly adjustments based on throughput
- **Show confidence:** Use date ranges (April 15-30) for uncertain items

### Epic Sizing
- **2-8 weeks duration:** Not too small (use stories) or too large (split epic)
- **Clear deliverables:** Each epic should have testable business value
- **Dependencies visible:** Show what blocks what

### Milestone Alignment
- **Customer deadlines:** Align with external commitments
- **Integration points:** Show dependency on other teams
- **Release windows:** Match deployment schedule

## Troubleshooting Common Issues

### Issue: Epics not showing on roadmap
**Solution:** 
- Check filter includes `label:type:epic`
- Verify epics have Target Date field populated
- Ensure Epic Start Date field exists and is populated

### Issue: Milestones not grouping correctly
**Solution:**
- Verify Business Milestone field is single-select
- Check all epics have Business Milestone assigned
- Confirm Group By is set to Business Milestone

### Issue: Timeline looks wrong
**Solution:**
- Verify date fields are correctly populated
- Check Start Date is before End Date
- Ensure dates are realistic (not in past unless completed)

### Issue: Progress not updating
**Solution:**
- Verify child stories are linked to epic
- Check stories are moving to Done status
- Progress calculates based on story completion

## Success Criteria

Your roadmap is working when:

✅ **Business stakeholders** can see milestone progress at a glance  
✅ **Epic timelines** show realistic delivery windows  
✅ **Dependencies** are visible between features  
✅ **Progress tracking** updates automatically  
✅ **Date adjustments** are easy to make  

## Integration with Kanban

### How Roadmap Supports Kanban Flow:

**Strategic Planning:** Roadmap shows long-term feature delivery
**Tactical Execution:** Kanban board shows daily work flow
**Feedback Loop:** Kanban metrics inform roadmap adjustments

**Weekly Workflow:**
1. **Monday:** Check roadmap for milestone progress
2. **Daily:** Use Kanban board for task management  
3. **Friday:** Update roadmap dates based on week's throughput

---

**Setup Time:** 15-20 minutes
**Maintenance:** 5 minutes weekly for date updates
**Result:** Clear business roadmap showing feature delivery against milestone commitments