So i want to have another service within the produt service, current the product service contains campaignservice, subscriberService etc.
I want to add a BrandService to the Product service, so we do not have our tenants (brands) configured in app settings and API key ( and other secrets) in the keyvault, but have them as data.

then i want the other depending services to use the Product Service Brand service to fetch information about our tenants, for their multitenant implementation.

Edge service, ecommerce service, identity service, all are multi tenant, and the tenants needs to be setup, this is currently done in the individual service per tenant.
I want to centralize tenant information within the brand service, and have the depending services to fetch tenants from the brand service.

Locally, there will still be some mocking i guess. but in the cloud environments, the service should reach out to the product service to get tenant information and store it runtime.

This project does not really depend on anything, though the it should be added to the admin system for management, but all the APIs needed can be done prior to ( though it does depend on the ping federate project for admin auth for these APIs)
