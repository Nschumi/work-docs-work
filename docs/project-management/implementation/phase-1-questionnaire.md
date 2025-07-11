# Phase 1 Implementation Questionnaire

Please answer these questions to help guide the implementation approach. Feel free to add additional context or concerns.

## Development Environment & Setup

### Current Environment

1. **Development Machine OS**:

   - [x] Windows
   - [x] macOS
   - [ ] Linux
   - [ ] Other: \***\*\_\_\_\*\***

2. **Installed Tools** (check all that apply):

   - [x] .NET 9.0 SDK
   - [x] Visual Studio 2022
   - [x] JetBrains Rider
   - [x] VS Code
   - [x] Docker Desktop
   - [x] Git
   - [x] PostgreSQL (local)
   - [x] Other: microsof t SQL Server, redis

3. **Do you have .NET Aspire workload installed?**
   - [x] Yes
   - [ ] No
   - [ ] Not sure

## Starting Point

4. **Are you starting from scratch or do you have existing code?**

   - [x] Complete scratch
   - [ ] Have some proof-of-concept code
   - [ ] Have existing system to migrate
   - Notes: I have other services that i can use as a reference, but nothing that is directly related to this project.

5. **What should we implement first?**
   - [x] Basic project structure and infrastructure
   - [x] Multi-tenant foundation
   - [x] First functional module (Catalog) (PoC)
   - [ ] Database design and migrations
   - [x] Authentication/Authorization
   - [ ] Other: \***\*\_\_\_\*\***

## Technical Decisions

### Multi-Tenancy Strategy

6. **Preferred tenant identification method** (can select multiple):

   - [ ] Subdomain (tenant1.saga.com, tenant2.saga.com)
   - [ ] Custom domain (brand1.com, brand2.com)
   - [ ] URL path (/tenant1/products, /tenant2/products)
   - [x] Request header (X-Tenant-Id)
   - [ ] JWT claim
   - Other considerations: The eCommerce module is a tier 3 API service, auth will be through header and jwt claims.

7. **Tenant data isolation strategy**:
   - [x] Shared database with TenantId column (recommended for this project)
   - [ ] Database per tenant
   - [ ] Schema per tenant
   - [ ] Hybrid approach
   - Notes: \***\*\_\_\_\*\***

### Database & Persistence

8. **Initial database setup preference**:

   - [ ] Start with in-memory for quick prototyping
   - [ ] PostgreSQL from the start
   - [ ] Use Docker for local PostgreSQL
   - [ ] Use cloud-hosted PostgreSQL
   - Connection details/preferences: will be using SQL server for now, but will move to PostgreSQL later. Locally available through Aspire.

9. **Migration strategy**:
   - [x] Code-first with EF Core migrations
   - [ ] Database-first approach
   - [ ] Hybrid (some existing, some new)
   - Notes: \***\*\_\_\_\*\***

### Architecture & Patterns

10. **Module communication preference**:

    - [ ] Direct service calls within same process
    - [ ] MediatR for all inter-module communication
    - [ ] Event-driven with in-process events
    - [ ] Mixed approach based on use case
    - Notes: Id like you to come with a good proposal for setting up a good communication pattern between modules. It should be in process though, but whether to use MediatR or not is up for discussion.

11. **API style preference**:
    - [ ] REST with controllers
    - [ ] Minimal APIs
    - [ ] GraphQL
    - [ ] gRPC for some services
    - Notes: Rest with Fastendpoints

### Development Workflow

12. **Preferred development workflow**:

    - [ ] TDD (Test-Driven Development)
    - [ ] BDD (Behavior-Driven Development)
    - [x] Traditional development with tests after
    - [x] Prototype first, tests later
    - Notes: Though if one likes to develop with TDD, that is fine, but it should not be a requirement.

13. **CI/CD preferences**:
    - [x] GitHub Actions
    - [ ] Azure DevOps
    - [ ] GitLab CI
    - [ ] Jenkins
    - [ ] Other: \***\*\_\_\_\*\***
    - [ ] Set up CI/CD later

## Team & Timeline

14. **Team size and roles**:

    - Number of developers: 4
    - Your role: Team lead and techinal lead / architect
    - Other team members and roles: Developers

15. **Timeline expectations**:
    - Phase 1 target completion: November 2025
    - First production deployment target: Oktober 2025
    - Any hard deadlines: no

## Specific Concerns

16. **What are your biggest concerns about starting this project?**

    ```
    Getting the architecture right, and making sure we have a good foundation to build on. Also, ensuring that we have a good multi-tenant setup that is scalable and maintainable.
    We have a partial delivery of this that we need to make, due to the dependency from the Open Pages project that uses contentful for a CMS. If the contentful pages should be able to show products, we need to have a basic product catalog working.
    We need to, temporarily, match the requirement from the old TCM eCom orderflow for adding items to the basket, since we will only later have the basket available in the Open Pages project.


    ```

17. **What aspects need the most careful planning?**

    ```

    The foundation, and the things that go across, getting a good foundation for multi-tenancy, authentication and authorization, and the product catalog.
    And that it is easy to test and develop against.


    ```

18. **Are there any existing systems this needs to integrate with immediately?**

    ```
    Product-service, which is a proxy to the legacy TCM system. We need to ensure that we can access product data and pricing information without direct integration.
    Our identity service, that is used for authentication and authorization.
    in the eCom project, we will not be logging anyone in, but we will be having endpoints that require the user to be logged in, so we need to ensure that we can handle that.
    Service to service communication is done through JWT tokens aswell, authority here is the identity service.


    ```

## Technical Constraints

19. **Are there any technical constraints we should be aware of?**

    - Specific .NET version requirements: no, newest.
    - Corporate proxy/firewall issues: some, but not critical
    - Limited access to certain tools: \***\*\_\_\_\*\***
    - Other: \***\*\_\_\_\*\***

20. **Performance requirements from the start?**
    - Expected concurrent users: 100-200
    - Expected number of tenants initially: 3
    - Data volume expectations:pass

## Implementation Priorities

21. **Rank these features by priority (1 = highest)**:

    - [1] Multi-tenant infrastructure
    - [2] Product catalog
    - [3] Channel module}
    - [8] Shopping basket
    - [10] Order processing
    - [9] Payment integration
    - [7] MSISDN management
    - [4] Admin portal
    - [5] Monitoring/Observability
    - [6] API documentation

- note, the channel service is not present here, and should be added just after the catalog module, as it is a prerequisite for phase 1 completion

22. **For the Catalog module, what's most important initially?**
    - [x] Basic CRUD operations
    - [ ] Complex pricing rules
    - [ ] Bulk import/export
    - [ ] Product variants
    - [ ] Image management
    - [ ] Other: \***\*\_\_\_\*\***

## Additional Notes

23. **Any other information that would help guide the implementation?**

    ```
    yeah, how we get this into tasks / projects. We currently use Jira, but i would actually like to use github because then you can help with creating all the tasks and issues, and we can use the kanban board there.


    ```

24. **Preferred communication style for development?**
    - [ ] Detailed documentation for everything
    - [x] Quick prototype, iterate based on feedback
    - [x] Regular check-ins with working code
    - [ ] Complete features before review
    - Other: \***\*\_\_\_\*\***

---

## Next Steps After Questionnaire

Once you've filled out this questionnaire, we can:

1. Create a specific implementation plan based on your answers
2. Set up the initial project structure aligned with your preferences
3. Define the first sprint's goals
4. Identify any blockers or prerequisites

Feel free to answer as many or as few questions as you'd like - even partial information will help guide our approach!
