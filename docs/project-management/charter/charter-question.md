# 2. Project Charter Questionnaire

##A. Project Basics
What is the official project name? (e.g., SAGA Telcom eCommerce System)
SAGA Telecom eCommerce Module

### Who is the main project sponsor? (Name, title, department)

Lars Vieland Grasberger, Head of It, Nuuday Mobile Partners

### Who is the project manager? (Name, contact info if possible)

Bjørn Alsted Nielsen, Product Owner, Nuuday Mobile Partners

## B. Project Purpose

### Why is this project being undertaken? (Business need/problem)

To modernize the telecom eCommerce platform, enabling a whitelabel solution that supports multiple brand partners with distinct configurations and branding, while replacing the legacy TCM system.

### What are the main goals and objectives?

- Enable multi-tenant support for telecom brand partners.
- Allow brand partners to manage their own product offerings, pricing, and campaigns through adminstration tools.
- Provide a seamless, intuitive shopping experience for customers across digital channels.
- Ensure high performance and scalability to handle significant transaction volumes.

### How does this project align with the organization’s strategy?

To improve operational efficiency, accelerate product launches, and enhance customer experience by providing a flexible, modular eCommerce platform that supports multiple tenants and brand configurations.

## C. Scope

### What is included in the project scope? (What will you deliver?)

- Development of a multi-tenant eCommerce module.
- Integration with downstream provisioning systems.
- Support for distinct product offerings and pricing strategies for each brand partner.
- Support for distinct branding and configurations for each brand partner.
- Centralized product management system for brand partners.

### What is specifically excluded from the project scope?

- Defining the API interface towards the downstream provisioning systems.

### Are there any dependencies on other systems, teams, or projects?

- A few dependecies on the legacy TCM system for data retrieval, (e.g., product details, pricing, MSISDN number availability)

## D. Stakeholders & Team

### Who are the key stakeholders? (Names, roles)

- Lars Vieland Grasberger, Head of IT, Nuuday Mobile Partners (Project Sponsor)
- Nichlas Bruselius, Head of Brand Partners, Nuuday Mobile Partners (Stakeholder)
- Bjørn Alsted Nielsen, Product Owner, Nuuday Mobile Partners (Project Manager)
- Katrine Grøn Iversen, Grøn-Iversen, Commercial Manager, Nuuday Mobile Partners (Stakeholder)
- Katrine Blicher Christensen, Commerical Manager, Nuuday Mobile Partners (Stakeholder)
- Niclas Schumacher, IT-Lead, Nuuday Mobile Partners (Technical Lead)

### Who is on the core project team? (Roles, names if available)

- Infrastructure & Platform team: Responsible for building the eCommerce module.

### Are there any external partners or vendors involved?

No external partners or vendors are currently involved, but this may change as the project progresses.

## E. Success & Deliverables

What are the main project deliverables?

- A fully functional multi-tenant eCommerce module.
- Integration with downstream provisioning systems.
- Documentation for brand partners on how to use the eCommerce module.
- A centralized product management system for brand partners.

### What are the success criteria for the project?

- Successful Migrated of at least one brand partner using the eCommerce module with Whitelabel frontend capabilities
- Positive feedback from brand partners and customers on the usability and performance of the eCommerce module.
- High performance and reliability of the eCommerce module, with minimal downtime and fast response times.

### How will you measure success?

- System performance metrics (response time, uptime, transaction volume).
- User satisfaction surveys from brand partners and customers.
- Monitoring and alerting systems that track error rates and system health.
- Support tickets decreased significantly after the launch of the eCommerce module.

## F. Timeline & Milestones

### What is the expected project timeline? (Start/end dates, key milestones)

First phase: Technical design and architecture planning, expected to start in August.
Second phase: Development and integration Milestone 1, expected to start in September and end in December.

### What are the key milestones?

Milestone 1: Completion of initial requirements gathering and analysis.
Milestone 2: Completion of technical design and architecture planning.
Milestone 3: Development of needed features for Open Pages Project completion.
Milestone 4: eCom module version 0.5.
Milestone 5: Whitelabel frontend capabilities for the eCom module.
Milestone 6: eCom moduel version 1.0, including all features and capabilities for brand partners.

### Are there any critical deadlines or go/no-go checkpoints?

- Dependencies on the legacy TCM system for data retrieval may impact the timeline.
- Dependencies on the Open Pages project for frontend capabilities may also impact the timeline.
- Dependencies on customer / subscriber provisioning systems for integration may impact the timeline.

## G. Budget & Resources

What is the estimated project budget?
The project budget is not yet defined, but it will include costs for development resources, infrastructure, and any necessary third-party services.

### What resources are required? (People, technology, tools)

- Development team with expertise in C#/.NET and modular monolith architecture.
- Infrastructure team for building and deploying the eCommerce module.
- Tools for project management, documentation, and communication (e.g., Jira, Confluence, Slack).

## H. Risks & Assumptions

### What are the main risks to the project?

- Integration challenges with the legacy TCM system and downstream provisioning systems.
- Potential delays in development due to dependencies on other projects (e.g., Open Pages).
- Communication with brand owners and stakeholders may lead to scope creep or misalignment on requirements.
- Alignment with Brand Partner Eesy on their expectations and requirements for the eCommerce module.
- Other project within Nuuday Mobile Partners may impact the availability of resources or priorities (DAWN, Ad hoc requests).

Are there any constraints you’re working under? (Time, budget, technology)
No specific constraints have been identified at this time, but the project will need to be flexible to adapt to any changes in requirements or priorities.

### I. Communication & Governance

## How will you communicate project status to stakeholders?

- Jira plan and dashboard covering project status, milestones, and key deliverables.
- Regular status updates announced on Slack channel shared between the project team and stakeholders.
- Bi weekly project meetings with key stakeholders to review progress and address any issues when development start to hit feature stage.
  What is the governance structure for decision-making?

## Who needs to approve the project charter and key deliverables?

- The project charter and key deliverables will need to be approved by the project sponsor, Lars Vieland Grasberger, and the core project team members.
