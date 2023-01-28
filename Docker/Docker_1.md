# Docker Part 1
## Monolithic vs Microservices

To understand the docker, we need to look into the application architecture types first - [Monolithic and Microservices](https://www.atlassian.com/microservices/microservices-architecture/microservices-vs-monolith#:~:text=A%20monolithic%20application%20is%20built,of%20smaller%2C%20independently%20deployable%20services.)

**Monolitic** - This architecture based applications were built as a unified unit and modules of it will be interconnected to each other. We can take banking application as an example, it has several modules - Home, personal,auto:loans, Personal banking, Credit/debit card services etc. These services are coupled with each other and was built using single code base i.e Java, Python etc. There are advantages and limitations of this architecture

**Advantages* - Easy deployment, Easy to Develop, Performance, Simplified testing, Easy debugging

**Limitations* - Slower development speed, Scalability(Individual components can't be scaled), Reliability(A small error can affect entire code), Barrier to technology adoption(changes takes time and risk).

**Micro-services** - This architecture based applications were built as a decentralized modules and are independent on each other. Swiggy,Uber are some exapmles uses this microservices. They are built with different code bases. As the modules inside the applications are independent on each other whch has several notable advantages over limitations.

**Advantages* - Agility, Flexible scaling, Continuous deployment, Highly maintainable and testable, Independently deployable, Technology flexibility, High reliability, Happier teams.

**Limitations* - Development sprawl, Exponential infrastructure costs, Added organizational overhead, Debugging challenges, Lack of standardization, Lack of clear ownership