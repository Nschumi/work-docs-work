# GitHub Project Status Alignment Guide

## Current Status Inconsistencies

I've found several different status configurations across your documents. Let's align them into one unified approach.

### Status Lists Found in Different Documents

**From github-project-simplified-setup.md:**
```
📋 Backlog → 📅 Ready → 🔄 In Progress → 👁️ Review → 🧪 Testing → ✅ Done
```

**From how-we-work-with-github.md:**
```
📋 Backlog → 📅 Planning → ✨ Ready → 🔄 In Progress → 👁️ In Review → 🧪 Testing → ✅ Done
```

**From github-project-board-setup.md:**
```
📋 Backlog → 📅 Sprint Planning → 🔄 In Progress → 👁️ Code Review → 🧪 Testing → ✅ Done
```

## Recommended Unified Status Configuration

### All Status Options (8 total)

```
📋 Backlog → 📅 Planning → ✨ Ready → 🔄 In Progress → 👁️ In Review → 🧪 Testing → ✅ Done → 🚫 Blocked
```

### Status Definitions

| Status | Purpose | Used By | Description |
|--------|---------|---------|-------------|
| **📋 Backlog** | Unrefined work | All types | Items identified but not ready to work on |
| **📅 Planning** | Definition phase | Epics, Spikes | Being broken down, requirements gathering |
| **✨ Ready** | Sprint-ready | Stories, Tasks | Refined, estimated, ready to pick up |
| **🔄 In Progress** | Active work | All types | Developer actively working |
| **👁️ In Review** | Quality check | All types | Code review, PR review, acceptance review |
| **🧪 Testing** | Verification | Tasks, Bugs | Integration testing, QA testing |
| **✅ Done** | Complete | All types | Merged, deployed, accepted |
| **🚫 Blocked** | Impediment | All types | Cannot proceed due to dependency |

## Missing Statuses You Might Need

### Consider Adding:

**🔍 In QA**
- Separate from Testing
- For dedicated QA team review
- Between Testing and Done

**📝 Draft**
- For work in early stages
- Before Ready status
- Useful for epics and stories

**🎯 Staged**
- Ready for deployment
- Between Testing and Done
- For release management

## Status Usage by Issue Type

### Epics
```
📅 Planning → 🔄 In Progress → ✅ Done
```
- Skip: Backlog, Ready, In Review, Testing
- May use: 🚫 Blocked

### Stories
```
📋 Backlog → ✨ Ready → 🔄 In Progress → 👁️ In Review → ✅ Done
```
- Skip: Planning (unless spike), Testing
- May use: 🚫 Blocked

### Tasks
```
📋 Backlog → ✨ Ready → 🔄 In Progress → 👁️ In Review → 🧪 Testing → ✅ Done
```
- Skip: Planning
- Use all statuses including Testing
- May use: 🚫 Blocked

### Bugs
```
📋 Backlog → 🔄 In Progress → 🧪 Testing → ✅ Done
```
- Skip: Planning, Ready (usually go straight to work)
- Focus on Testing verification
- May use: 🚫 Blocked

## Implementation Steps

### Step 1: Update Status Field in GitHub Project

1. Go to your organization project
2. Click on Status field settings
3. Delete all existing statuses
4. Add these 8 statuses in order:
   ```
   📋 Backlog
   📅 Planning
   ✨ Ready
   🔄 In Progress
   👁️ In Review
   🧪 Testing
   ✅ Done
   🚫 Blocked
   ```

### Step 2: Update All Documentation

Files that need status list updates:
- `how-we-work-with-github.md` ✓ (already updated)
- `github-project-simplified-setup.md` (needs update)
- `github-project-board-setup.md` (needs update)
- `organization-project-setup-guide.md` (needs update)

### Step 3: Configure Views

**Epic Board:**
- Visible columns: Planning, In Progress, Done, Blocked
- Hidden columns: Backlog, Ready, In Review, Testing

**Sprint Board:**
- Visible columns: Ready, In Progress, In Review, Done, Blocked
- Hidden columns: Backlog, Planning, Testing

**Development Board:**
- Visible columns: All 8 columns
- No hidden columns

**Bug Triage Board:**
- Visible columns: Backlog, In Progress, Testing, Done, Blocked
- Hidden columns: Planning, Ready, In Review

### Step 4: Team Training

**Key Points to Communicate:**

1. **Not all statuses apply to all issue types**
   - Epics don't use Ready or Testing
   - Bugs typically skip Planning and Ready

2. **Blocked is special**
   - Can be used from any other status
   - Must include comment explaining blockage
   - Should tag person who can unblock

3. **Planning vs Ready**
   - Planning = figuring out what to build
   - Ready = know what to build, ready to start

## Automation Rules

### Configure These Workflows:

1. **Pull Request Created**
   - Move to: In Review

2. **Pull Request Merged**
   - Move to: Done

3. **Issue Closed**
   - Move to: Done

4. **"blocked" Label Added**
   - Move to: Blocked

5. **"blocked" Label Removed**
   - Move to: Previous status (manual)

## Common Questions

### Q: Why both Planning and Ready?
**A:** Planning is for definition work (what to build), Ready is for execution readiness (how to build).

### Q: Can items move backwards?
**A:** Yes, especially from In Review back to In Progress if changes needed.

### Q: What about hotfixes?
**A:** Hotfixes can skip statuses - go directly from Backlog to In Progress.

### Q: How to handle blocked items?
**A:** Move to Blocked status AND add comment with:
- What's blocking
- Who can unblock
- Expected resolution date

## Status Transition Rules

### Allowed Transitions:
- ✅ Any status → Blocked
- ✅ Blocked → Any status
- ✅ In Review → In Progress (if changes needed)
- ✅ Testing → In Progress (if bugs found)

### Not Allowed:
- ❌ Done → Any other status (create new issue instead)
- ❌ Skipping In Review for code changes

## Success Metrics

Monitor these to ensure status alignment works:

1. **Status dwell time** - How long items stay in each status
2. **Backwards movements** - Items moving back (except from Blocked)
3. **Skip patterns** - Which statuses are commonly skipped
4. **Blocked frequency** - How often items get blocked

## Next Actions

1. **Update GitHub Project** with these 8 statuses
2. **Update all setup guides** to use consistent status list
3. **Create team quick reference** card with status flows
4. **Run team training** session on status usage
5. **Monitor for 2 weeks** then adjust if needed

---

**Implementation Time:** 30 minutes
**Documentation Updates:** 20 minutes  
**Team Training:** 15 minutes
**Result:** Consistent status flow across all issue types and documentation