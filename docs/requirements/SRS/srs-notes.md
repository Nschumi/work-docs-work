# SRS notes for change

Action: Please edit / add the following notes to the SRS document.

## 2.1

SAGA Telecom eCommerce Module operates as a Tier 3. Though it does not directly integrate with the legacy TCM system, it relies on the SAGA Product Service to access product data and pricing information. This service acts as a proxy, ensuring secure communication and data retrieval without direct integration.
It ensure that we do not rely on a production only system.
(please adjust other places that has thins notion as well.)

## Generally about payment

Dont mention PCI DSS compliance in the SRS. It is a given that all payment gateways are PCI compliant.

## 4.8

We need to rerun over these requirements. They are not complete and need to be more specific.
Lets do questions and answers to get the requirements right, id like your input in this.

## 6.2

This just seems weird to have in the document.. at least it should be under each different section, but it seems TO development focused.

## 6.3

Same as 6.2, this is not a requirement, but a design decision. It should be removed from the SRS.

## 6.4

same as the above.

## 8.3.2

we are only using Terraform.

## 8.4.1

we do not use APM, we use Grafana and Prometheus for monitoring.

## 10.2.2

we want to use kanban approach.
