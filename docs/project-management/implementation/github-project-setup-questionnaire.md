# GitHub Project Setup Questionnaire

Please answer these questions to help create the optimal GitHub project structure for the SAGA Telecom eCommerce project.

## Repository & Organization

1. **Repository Name Preference**:

   - [ ] saga-telecom-ecommerce
   - [ ] saga-ecom-platform
   - [ ] telecom-ecommerce-module
   - [x] Other: saga-ecommerce-service

2. **Repository Visibility**:

   - [ ] Private (recommended)
   - [x] Internal (if part of organization)
   - [ ] Public

3. **GitHub Organization**:
   - Do you want to create this under a specific organization? Nuuday
   - Or under personal account? \***\*\_\_\_\*\***

## Project Structure Preferences

4. **Issue Template Types** (check all you want):

   - [x] Epic (large features spanning multiple sprints)
   - [x] User Story (feature from user perspective)
   - [x] Technical Task (implementation work)
   - [x] Bug Report
   - [x] Spike/Research Task
   - [x] Documentation Task
   - [ ] Other: \***\*\_\_\_\*\***

5. **Label Categories** (check preferred approach):

   - [x] Module-based (module:catalog, module:channel, etc.)
   - [x] Priority-based (priority:high, priority:medium, priority:low)
   - [x] Type-based (type:epic, type:story, type:task, type:bug)
   - [x] Status-based (status:blocked, status:in-review, status:testing)
   - [x] All of the above
   - [ ] Custom approach: \***\*\_\_\_\*\***

6. **Milestone Structure**:
   - [x] Phase-based (Phase 1, Phase 2, etc.)
   - [ ] Sprint-based (Sprint 1, Sprint 2, etc.)
   - [ ] Feature-based (Multi-tenancy, Catalog, Channel)
   - [ ] Date-based (October 2025, November 2025)
   - [ ] Hybrid approach: goals that are simular to sprint, with a goal, but not a fixed time frame

## Project Board Configuration

7. **Primary Project Board Columns**:

   - [ ] Basic: Backlog → In Progress → Review → Done
   - [x] Detailed: Backlog → Sprint Planning → In Progress → Code Review → Testing → Done
   - [ ] Custom: \***\*\_\_\_\*\***

8. **Additional Board Views**:

   - [x] Module-focused boards (separate for Catalog, Channel, etc.)
   - [x] Developer assignment board
   - [x] Priority/urgency matrix
   - [x] Sprint planning board
   - [x] All of the above

9. **Automation Preferences**:
   - [x] Auto-move issues when PR is created
   - [x] Auto-move to Done when PR is merged
   - [x] Auto-assign issues based on labels
   - [ ] Auto-close stale issues
   - [ ] Custom automation: \***\*\_\_\_\*\***

## Sprint & Timeline Management

10. **Sprint Duration**:

    - [ ] 1 week
    - [x] 2 weeks (recommended for your team size)
    - [ ] 3 weeks
    - [ ] 4 weeks
    - [x] Flexible/no fixed sprints

11. **Sprint Planning Approach**:

    - [ ] Pre-planned sprints (I create all sprints upfront)
    - [ ] Rolling planning (create next sprint as current one progresses)
    - [x] Milestone-driven (organize around major deliverables)

12. **Story Point Estimation**:
    - [x] Use GitHub's built-in estimation
    - [ ] Custom field for story points
    - [ ] No formal estimation
    - [ ] T-shirt sizing (S, M, L, XL)

## Team Workflow Integration

13. **Branch Naming Convention**:

    - [ ] feature/issue-number-description
    - [x] module/feature-description
    - [ ] username/feature-description
    - [ ] Custom: \***\*\_\_\_\*\***

14. **PR Requirements**:

    - [x] Require linked issue for all PRs
    - [x] Require code review approval
    - [x] Require automated tests to pass
    - [x] Custom PR template
    - [x] All of the above

15. **Issue Assignment Strategy**:
    - [ ] Auto-assign based on module expertise
    - [ ] Manual assignment during sprint planning
    - [x] Team members self-assign
    - [ ] Rotating assignment

## Initial Backlog Structure

16. **How detailed should the initial backlog be?**:

    - [ ] High-level epics only
    - [ ] Epics broken down into stories
    - [ ] Complete breakdown to task level
    - [x] Phase 1 detailed, later phases high-level

17. **Priority Focus for Initial Issues**:
    - [x] Infrastructure and foundation first
    - [x] Quick wins to show progress
    - [ ] Critical path for October delivery
    - [ ] Most uncertain/risky items first

## Integration Needs

18. **GitHub Actions Workflows** (check desired):

    - [x] Basic CI (build, test, lint)
    - [x] Automated dependency updates
    - [x] Security scanning
    - [x] Automated issue labeling
    - [x] Release automation
    - [x] Deploy to staging on merge

19. **External Tool Integration**:
    - [x] Link to Slack notifications
    - [x] Integration with monitoring tools
    - [x] Custom webhooks
    - [ ] None needed initially

## Team Preferences

20. **Issue Detail Level**:

    - [ ] Brief descriptions, discuss details in PR
    - [x] Detailed acceptance criteria upfront
    - [x] Include technical implementation notes
    - [ ] Reference external documentation

21. **Communication Style in Issues**:
    - [ ] Formal, structured updates
    - [x] Casual team communication
    - [ ] Minimal comments, let code speak
    - [ ] Regular progress updates

## Specific to Your Project

22. **Module Organization**:
    Given your priorities (Multi-tenant → Catalog → Channel → Auth), should issues be:

    - [x] Organized by module with cross-cutting infrastructure tasks
    - [ ] Organized by sprint with mixed module work
    - [ ] Infrastructure first, then module-by-module
    - [ ] Parallel tracks (one person on infra, others on modules)

23. **Open Pages Integration Tracking**:
    How should we track the dependency on Open Pages project?

    - [x] Separate milestone for Open Pages deliverables
    - [ ] Special labels for Open Pages-required features
    - [ ] External dependency tracking
    - [ ] Regular status check issues

24. **TCM Legacy Compatibility**:
    How should we track legacy system compatibility requirements?
    - [x] Acceptance criteria in each relevant story
    - [ ] Separate epic for legacy compatibility
    - [ ] Special label for legacy-related work
    - [ ] Documentation-driven approach

## Quick Setup Questions

25. **Timeline for GitHub Setup**:

    - [ ] Set up basic structure now, iterate
    - [x] Wait until we have complete plan
    - [ ] Set up in phases (repo first, then project boards)

26. **Initial Team Access**:
    - GitHub usernames of team members: \***\*\_\_\_\*\***
    - Role assignments (admin, write, read): \***\*\_\_\_\*\***

## Additional Preferences

27. **Documentation Approach in GitHub**:

    - [x] Wiki for project documentation
    - [x] Docs folder in repository
    - [ ] Separate documentation repository
    - [ ] Issues for documentation tasks

28. **Release Strategy**:
    - [x] Semantic versioning from start
    - [ ] Simple incrementing versions
    - [ ] Date-based versions
    - [ ] No formal releases until production

---

## Next Steps

Once you've answered these questions, I'll create:

1. **Complete GitHub repository structure**
2. **Tailored project boards and workflows**
3. **Initial issue backlog** organized by your preferences
4. **GitHub Actions workflows** for your development process
5. **Team onboarding documentation**

The setup will be specifically designed around your team's workflow and the October 2025 delivery timeline.
