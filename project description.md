Okay, so i got a bunch of different projects that we need to start setting up, and scoping. I think ill want to just run things by you, then youcan make some structure.

We got multiple actual projects that we are running, as well as different services / websites, that are part of these projects.

- Firstly we got the "Whitelabel eCare project", which is a project that is in progress at the moment. It requires work in the Product Service ( which is the backend system ) as well as the Edge-service (This is the BFF system for the Whitelabel frontend) and the sveltekit frontend also known as Whitelabel-frontend. this project is well underway, with most frontend missing. The eCare project is 1 pillar of 3, the two other pillars are eCommerce and Open Pages.

- Then we got the eCommerce project, which is ecommerce-service primarily, but writelabel-frontend will implement the frontend for whitelabel via the ecommerce-service backend. Save goes for the Eesy project ( who is a standalone tenant in the multi tenancy system). We will not implement the frontend for eCommerce for eesy as of now, but they will use our backend too.

- Then we have the identity service, which is our oauth 2 system. It handles auth between services, for customers towards MitId ( through signicat as provider ). We have a current project here to implement PasswordFlow for customers so the identity service can give back a JWT for when a customer is logging in, instead of we manage the BrandCookie in the Product-service. The new JWT based auth will be implemented in the "Product service v3 tenant endpoints"-project, though it does require some aligment with the BFFs ( eesy and whitelabel) and their frontends. We will drill down into that later.

- Whitelabel-frontend, is our sveltekit based frontend that is a multitenant system, it is one frontend that services multiple brands ( tenants ). It contains 3 pillars.
  -- eCare, the place a customer can manage their subscriptions. We are currently live with a beta version for eCare on 3 brands ( nettalk, altibox, hallo ) but it is still an active project, we still need functionality.

-- Open Pages, is the next pillar, it is going to be build with ContentFul as the CMS. We have started the project, and we need to design many more compontents. Open pages has a dependecy on eCommerce project phase 1, since we require to have available product data to show on open pages.

-- eCommerce, the frontend for ecommerce has not been started yet, but itll be all about making a complete ecommerce flow for a customer for buying a ProductSubscription , mobile or Mobile broadband.

- ecommerce-service - this project is in its very early stages, the first phase will be all about enabling the websites ( eesy (they will do the development and implementation themselves) and whitelabel-frontend) to get products to show on the websites, which brand partners will setup in the admin system.

- Admin system, is a part of the ecommerce-service, but will be a blazor based websites where admins can manage their brands, this contains creating catalog items ( products ), managing the sales channels etc.

Task: with this information, i want you to create an overview, with dependencies and general information of which project are active, and which should be up next. Ill continiously add more projects and information for you, which i need you to put into the right places.
Please have a good folder structure, and a single "frontfile" which give me the overview.
