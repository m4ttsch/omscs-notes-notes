---
id: operating-systems-datacenter-technologies
title: Datacenter Technologies
course: operating-systems
lecture: datacenter-technologies
---

# Datacenter Technologies

## Data Center Quiz
How many datacenters are there worldwide in 2015, and how much space (in square feet) is required to house them? These questions are just for fun.

The lecture answers with 2011 numbers, for which definitive data exists: about 510,000 datacenters, occupying about 285.5 million square feet of space (aggregated by datacenterknowledge.com). Current estimates are much higher, and these numbers keep changing all the time.

## Internet Services
An **internet service** is any type of service that is accessible via a web interface.

Users communicate with these services via web requests that are issued by their web browsers.

Most commonly, these services are divided into three tiers. The **presentation tier** is typically responsible for static content related to the webpage layout. The **business logic tier** integrates all of the business-specific processing, including all of the dynamic, user-specific content. The **database tier** deals with all of the data storage and management.

These different tiers do not need to run as separate processes on separate machines. What makes sense depends on the service complexity, the resource requirements, the expected loads, and the underlying technologies. For example, the Apache HTTP web server can fulfill the presentation tier and the business logic tier: it serves the static content, and, as part of the same process, PHP modules generate the dynamic content.

Many **middleware** components exists to connect and coordinate these tiers. They provide commonly used functionality, such as messaging services, service configuration and management, security, accounting, some persistence guarantees, and recovery management.

Multiprocess configurations will need to communicate via some form of IPC, which we have discussed previously, such as RPC or RMI (in Java-based architectures), plus optimizations based on shared memory when different processes run on the same machine.

## Internet Service Architectures
For services that need to deal with high or variable requests rates, choosing a configuration that requires multiple processes - potentially on multiple nodes - becomes necessary.

We can **scale out** a service deployment by running the service on more nodes. Multiprocess configurations are the easiest way to deal with increases in incoming request rates.

A front-end load-balancing component would route the incoming request to an appropriate or available machine that implements the internet service. This is similar to the boss-worker pattern we discussed when structuring multithreaded parallel programs: the front-end is the boss, and the nodes are the workers, which may be general purpose or specialized.

Behind the load balancer, we can have one of two different setups. In a **homogenous** setup, all nodes are able to execute any possible step in the request processing pipeline, for any request that can come in. In a **heterogenous** setup, nodes execute some specific steps in the request processing, for only some request types.

## Homogenous Architectures
Any node in a functionally homogenous setup can process any type of request and can perform any of the processing actions that is required in the end-to-end request processing.

The benefit of this is that the front-end (load balancer) can be kept very simple. It doesn't have to keep track of which node can service which type of request; instead, it can assign requests in a round-robin manner to the next available node. The front-end could also be enhanced in a simple way, keeping some information about CPU loads or utilization on the other nodes and using that to direct requests.

This design doesn't mean that every node has all of the data. Instead, data may somehow be replicated or distributed across the nodes. Importantly, every node is able to get to any type of information that is necessary for the execution of the service.

One downside of this approach is that there is little opportunity to benefit from caching. A simple front-end will not keep enough to understand the locality of each task on a node by node basis.

### Homogeneous Design Quiz
Consider a toy shop where every worker knows how to build any type of toy (a homogeneous architecture). If the rate at which new orders arrive starts increasing, how do you keep this architecture balanced?

Add more of everything: more workers (processes), more work benches (servers), and more tools and parts (storage, the state needed to execute the service). No additional decisions are needed about what the new workers are intended to do or which specific tools or parts to add; just a little bit more of everything. Management is fairly simple: it still takes time, but little thought goes into how to configure the added resources.

## Heterogenous Architectures
In a functionally heterogenous setup, different nodes are designated to perform certain functions or handle certain types of requests.

For instance, requests may be divided among the servers based on request content, such as the alphabetical order of the requested file name. In the case of eBay, servers may be specialized for browsing requests vs. bidding/buying requests.

Data can still live in a distributed, shared file system accessible to all nodes, but since different nodes perform different tasks, it may not be necessary to ensure that data is uniformly accessible everywhere. Certain types of data may be much more easily accessible from the servers that manipulate those types of data.

One benefit of this approach is that the system can benefit from caching and locality, as each node is specialized to repeatedly perform one or a few actions.

One downside of this approach is that the front-end needs to be more complex. The front-end now needs to perform some request parsing to determine to which node it should route the request.

In addition, the overall management of this system becomes more complex. When a machine fails, or requests increases, it is important to understand which types of servers need to be scaled out.  

Also, if something changes fundamentally in the workload pattern, the server layout needs to be reconfigured. It's not as easy as scaling up or down. We can't just redirect the excess requests to other nodes if those nodes are not capable of processing that kind of action or serving that kind of data, even if those nodes are otherwise idling. As a result, it is much easier in these environments to end up with nodes that become hotspots, with long backlogs of pending requests.

### Heterogeneous Design Quiz
Consider a toy shop where every worker knows how to build some specific toy (a heterogeneous architecture). If the rate of incoming toy orders increases, how do you keep this architecture balanced?

Ultimately you again add more workers, work benches, and parts (processes, server nodes, storage). However, before you can do that, you first need to profile what kinds of toys (requests) the external users are ordering, and what kinds of resources each of those request types requires. Only after this profiling can you determine exactly which resources to add to keep the design balanced. Management of these systems is much more complex than for a homogeneous architecture.

A popular reference on the design space of large-scale internet services is Eric Brewer's paper "Lessons from Giant-Scale Services", which also describes the tradeoffs between data replication and partitioning discussed in the previous two lessons.

## Scale Out Limitations
Quiz: in the homogeneous toy shop, the manager keeps scaling up as order rates increase, adding workers, work benches, and parts. Until when does this work? (Hint: is endless scaling possible?)

Scaling out by continually adding nodes does not work forever. Consider a toy shop where the manager keeps adding workers, work benches, and parts as orders increase. At some point the manager can no longer control any more resources, because a single person has a limited amount of attention. There is also a physical limit to how much staff can fit in the shop. Outsourcing could help, but if the manager only trusts their own workers, that option is closed.

The same limitations exist for internet services. Given the size of the data center, there is a limit on the resources that can be placed there, and given the complexity of the management processes, there is a limit on how many different things can be managed. Running our own software stacks, operating systems, and services only tightens these constraints. Cloud computing emerged to address these limitations on scale.

## Cloud Computing Poster Child: Animoto
In the mid 2000s, Amazon was already a dominant online retailer. However, the workload that they needed to handle was imbalanced. The bulk of their traffic was received during the US holiday shopping season (Thanksgiving to Christmas), and much of the hardware they provisioned for that peak sat idle outside of that window, or was used for other company tasks such as forecasting or other analytics.

Amazon had already developed software infrastructure that allowed these machines to be reprovisioned and used by other services within the company. In 2006, Amazon opened up those same types of APIs to the rest of the world, giving access to its hardware resources via web-based APIs. This meant that third party workloads could be run on Amazon resources, for a fee.

This was the birth of **Amazon Web Services** (AWS) and **Amazon Elastic Compute Cloud** (EC2).

Around the same time, a company called Animoto was created. This company stitched together photos into a movie, which is a fairly resource-intensive task. As a result, they chose to rent EC2 instances instead of building out their own datacenter.

Originally, Animoto required about 50 EC2 instances. These were not physical servers but virtual machines, and Animoto had no control over whether they ran on the same physical server or many different ones.

In April 2008, Animoto became available to Facebook users. Within three days, Animoto signed up 750,000 new users. The number of instances grew from 50 on Monday to 400 by Tuesday, an order of magnitude in a day, and reached 3,400 by Friday.

In a week, Animoto had scaled up the number of servers it used by two orders of magnitude.

There's no way they would have been able to respond to this demand if they had gone the traditional route of owning and managing their own infrastructure. They could not have brought in, installed, wired, and configured that many machines in such a short time, even if they somehow had the physical space for them and sufficient power to run them.

## Cloud Computing Requirements
Traditionally, business would need to buy and configure the resources that were needed for their services. The number of resources to buy/configure would be based on the peak expected demand for those services.

If the demand exceeded the expected capacity, the business would into a situation where requests have to be dropped, which would result in lost opportunity.

![](https://assets.omscs.io/notes/57336766-5450-410E-A7EA-44AD6A68CEEC.png)

Ideally, we would like the capacity of the available resources to scale elastically with the demand.

The scaling should be instantaneous: as soon as the demand increases, so does the capacity, and vice versa. This means that the cost to support this service should be directly proportional to the demand.

![](https://assets.omscs.io/notes/17DAC6A2-5849-4D9C-83AC-4A5CE3E1FD76.png)

All of this scaling should be able to happen automatically, and the provisioned resources should be accessible anywhere, anytime.

Note that you wouldn't potentially own these resources, but this may be a fair compromise.

Goals of cloud computing, summarized:

- On-demand, elastic resources and services
- Fine-grained pricing based on usage
- Professionally managed and hosted
- API-based access

## Cloud Computing Overview
Cloud computing provides shared resources. These resources can be infrastructure resources; that is, compute, storage or networking resources. This does not mean the provider rents out physical machines or physical disks; it rents out virtual machines, potentially interconnected into virtual clusters, along with some storage. Cloud computing can also provide higher-level software resources, like email, database services, or processing runtimes. It may be easier to rent the infrastructure together with an appropriately configured software stack than to rent raw infrastructure and deal with the deployment, configuration, and management of the service yourself.

These infrastructural/software resources are made available via some APIs for access and configuration. These resources need to be accessed and manipulated as necessary over the Internet.  APIs can be web-based, library-based, or command line-based.

Providers offer different types of billing and accounting services. Some marketplaces incorporate spot pricing, reservation pricing, or other pricing models.

Billing is often not done by raw usage, as overheads with monitoring at that level of fine-grained control are pretty high. Instead, billing is done based on some discrete step function. For example, compute resources may be billed according to "size": tiny, medium, extra-large.

All of this is managed by the cloud provider. Common software stacks for managing cloud resources include the open source OpenStack and VMware's vSphere software stack.

## Why Does Cloud Computing Work?
Two basic principles provide the fundamental theory behind the cloud computing approach.

The first is the **law of large numbers**. This says that average resource needs across a large number of clients will remain fairly constant. This is the reason that a cloud provider can support a number of clients with variable peak loads on a fixed amount of resources, since those peaks tend to be shifted in time.

The second is **economies of scale**.  A cloud provider is able to leverage a large number of customers on a single piece of hardware, which amortizes the cost of that hardware across those customers, assuming the number of customers is large enough.

## Cloud Computing Vision
Although cloud computing is a relatively new trend, the vision is old. The oldest description, by John McCarthy in 1961, predates the technology by almost half a century.

> If computers of the kind I have advocated become the computers of the future, then computing may some day be organized as a public utility, just as the telephone system is a public utility ... The computer utility could become the basis of a new and important industry.

Based on this vision, cloud computing should turn the IT resource into a fungible utility. Just as we turn on a switch for electricity without worrying about where it comes from, we shouldn't need to care which hardware resources are used, or where they are. Virtualization technology is definitely an enabler in this process.

Unfortunately, some limitations exist. For example, even with virtualization, there are some hardware dependencies that cannot be masked, so software that expects a certain hardware platform cannot simply run on another resource. In addition, different providers support different APIs; thus, we cannot seamlessly switch amongst providers without rewriting code (API lock-in). There are privacy/security concerns associated with putting core business code and data in the hands of an external provider. Finally, latency is an issue, given the geographic distance between us and the resources we access.

### Cloud Computing Definitions Quiz
An excerpt from the National Institute of Standards and Technology (NIST) definition of cloud computing, published October 25, 2011:

> Cloud computing is a model for enabling ubiquitous, convenient, on-demand network access to a shared pool of configurable computing resources (e.g., networks, servers, storage, applications, and services) that can be rapidly provisioned and released with minimal management effort or service provider interaction.

Map the phrases "ubiquitous", "on-demand", "shared pool", "rapidly provisioned", and "minimal management effort" onto the cloud computing requirements (elastic resources, fine-grained pricing, professionally managed, API-based):

- Elastic resources: on-demand, shared pool, rapidly provisioned
- Fine-grained pricing: (blank) nothing in the definition talks about pricing
- Professionally managed: minimal management effort
- API-based: ubiquitous

There is no solid, well-established definition of cloud computing that the entire community subscribes to.

## Cloud Deployment Models
NIST, which adopted a definition for cloud computing in 2011, also defined different types of clouds. The first dimension is the deployment model.

In **public clouds**, the infrastructure belongs to the cloud provider, and third party customers/tenants (anyone with a credit card) can rent the hardware to perform their computational tasks. Amazon EC2 is a public cloud.

In **private clouds**, the infrastructure and software is owned by the same entity. Cloud computing technology is leveraged to maintain some of the flexibility/elasticity on machines that are in-house. Amazon originally used the technology it later opened up as AWS internally, to provision its physical infrastructure elastically and dynamically across its own applications and services.

**Hybrid clouds** combine public and private clouds. Private clouds may comprise the main compute resources for the applications, with failover/spikes being handled on public cloud resources. In addition, public clouds may be used for auxiliary tasks, such as load testing.

Finally, **community clouds** are public clouds that are used by certain types of users.

## Cloud Service Models
Clouds are often differentiated based on the service model that they provide.

![](https://assets.omscs.io/notes/81DBAA16-6AF2-4CEB-9840-665F49F5001B.png)

Without the use of cloud computing, you run your application on premises, which means you have to take care of everything yourself.

At the other extreme, you can use cloud computing services to provide you with a complete application. This is what we call **Software as a Service** (SaaS). Gmail is a great example of a SaaS platform.

A **Platform as a Service** (PaaS) provides you with certain APIs to allow you to develop certain types of applications. The platform provides an execution environment, which includes the OS and other tools necessary for the application to run in that environment. Google App Engine is an example of a PaaS platform. This PaaS provides everything needed to develop android applications. Windows Azure was originally a PaaS offering for developing and running .NET applications.

At the lowest level, clouds can provide infrastructure instances, like compute instances that consist of the CPUs with accompanying memory, storage and network infrastructure. Amazon EC2 is a such a model of this **Infrastructure as a Service** (IaaS). These instances can also include other hardware resources such as GPUs.

These types of clouds still don't provide access to the physical resources directly, rather only the virtualized resources. It is often the case that you are sharing the physical resources with other tenants. That being said, Amazon does provide high-performance instances that are single tenant, where the VM runs independently on physical hardware; the same applies to GPU-enabled instances. This is due to the technical challenge of reaching sufficient performance for these instances in a virtualized environment.

## Requirements for the Cloud
Clouds must provide **fungible** resources. This means that the resources can easily be repurposed to support different customers with different types of requirements. Without fungibility, the economic opportunity for cloud providers disappears. Fungibility also hides the heterogeneity of the cloud's own resources, such as different generations or even different types of servers, so users do not have to deal with it.

Clouds must integrate resource management methods that support the premise of cloud computing. They must be able to dynamically adjust the resources that are allocated to cloud users depending on need.

Such management methods must be able to operate at very large scale - thousands and tens of thousands of nodes. Scale is important for both the cloud provider, in terms of how many resources it must manage, and for the customer: customers often come to the cloud because they otherwise lack access to sufficiently large resource pools, so the cloud must let an individual customer allocate very large collections of resources.

Once scale is introduced, failures become inevitable. The probability of system failure increases with the number of components in the system, which each have an independent probability of failure. If a single component fails with probability `p`, then the probability that at least one of `n` components fails is `1 - (1 - p)^n`. With `p = 0.03` and `n = 10`, this is about 26%; with `n = 100`, it rises to about 95%. Real cloud systems have thousands or hundreds of thousands of components, so even with more reliable hardware, something somewhere will be failing. We have to incorporate mechanisms to deal with failures, such as timeouts for detection, restart and retry for recovery, and backup, replication, and checkpointing. We have to embrace the fact that failures will happen and build robust software that can detect and recover from failures, or avoid them.

Clouds are shared resources, so cloud management has to provide mechanisms that guarantee performance and  isolation across these multi-tenant environments. Misbehaving tenants should not be able to wreak havoc on other tenants and/or the entire system.

Clouds must also make guarantees with regards to the privacy of their client's data and the security of the execution environment that they provide to their clients. These guarantees apply not just across tenants: the cloud provider must not access or take advantage of the state managed by individual tenants, and, the other way around, the cloud platform must be protected from vulnerabilities within a single tenant, so that one tenant cannot affect the entire platform.

## Cloud Enabling Technologies
A number of technologies are needed in order for cloud computing to be performed correctly and efficiently.

Virtualization technologies is needed to provide fungible resources that can be dynamically repurposed for different customer needs.

In addition, resource-provisioning and -scheduling technologies are required to enable the dynamic provisioning and scheduling of the infrastructure resources. **mesos** and **yarn** (Hadoop's YARN) are technologies that address this issue.

In order to address customers' needs for scale, cloud technologies need to provide abilities to process and store large amounts of data. **Hadoop MapReduce** and **Spark** are popular technologies for big data.

Regarding data storage, cloud computing platforms incorporate distributed filesystems - that typically operate in some "append only" mode, rather than arbitrarily rewriting, deleting, and modifying data. In addition, NoSQL databases (a departure from traditional relational SQL databases) and the ability to store data across distributed memories, instead of repeatedly accessing disk, also help with accessing and manipulating data at scale.

Cloud users need to be isolated from one another, so that each of them thinks it owns its resource slice. Cloud computing technologies need software that can enable and configure these software-defined slices of resources, so that each customer gets its own software-defined data center, or software-defined subset of the storage or network resources.

Finally, given the complexity of these environments, cloud computing platforms must incorporate efficient monitoring technologies, to process logs in real time and detect anomalies or failures. This is useful for the cloud provider to preside over the data center as a whole, but also as a service made available to cloud customers who want real-time, possibly interactive access to the information their applications produce, rather than just batch access. **Flume** (open source), **CloudWatch** (an Amazon service), and **Log Insight** (part of the VMware portfolio) are all monitoring and real-time log processing technologies.

## The Cloud as a Big Data Engine
One benefit of cloud computing is that it empowers anyone to have potentially infinite resources. As long as you can pay, you can have the resources that are required to work on hard, data- and resource-intensive problems.

To illustrate the amount of data involved: in 2011 alone, 1.8 zettabytes of data were created. That is equivalent to everyone in the US tweeting 4,320 times a day, or to 200 billion two-hour high-definition movies (it would take 47 million years to watch them all). Storing it would take so many 32 GB iPads that, stacked up, they would be 25 times higher than Mt Fuji. Not every application needs all of this data, but many applications, for scientific discovery, improving social services, and so on, do require a lot of it.

Cloud platforms that offer big data processing as a service need - at a minimum - a data storage layer, which enables storing and accessing data across many nodes, and a data processing layer, which makes it easy to describe applications in a parallel fashion so the data can be processed across many nodes.

Often, these services incorporate a caching layer as well, where data is brought into memory, possibly across multiple memories in the distributed system. Remember that memory access is much faster than going to disk, particularly to a disk attached to another node, and repeated cache access can definitely speed up the execution of an application.

Commonly, big data stacks incorporate some language front-end that allows developers to query their data in a way they are familiar with (like SQL queries or other query mechanisms).

People are often interested in analytics and mining when it comes to big data: searching for patterns with data mining operations that often involve common functions such as machine learning algorithms. As a result, just as big data platforms support popular language front-ends, they commonly support popular analytics libraries.

Finally, the data being analyzed with these platforms is often continuously being generated, and the answers derived from it are updated continuously over time. This means that these platforms need streaming support, both for inputs (ingesting and staging data that is continuously streamed into the platform) and for outputs.

## Example Big Data Stacks
Two popular open source big data stacks used in cloud computing platforms are the Hadoop stack and the Berkeley Data Analytics Stack (BDAS). These are not the only options: there are proprietary stacks and other open source stacks, such as the HPCC stack by LexisNexis, which predates Hadoop but was not widely used outside of LexisNexis. In terms of popularity and adoption, in both commercial and research settings, Hadoop and BDAS are the dominant stacks.

### Hadoop

![](https://assets.omscs.io/notes/690C46E9-31A8-4841-BA34-660234AE758A.png)

At the bottom is the data storage layer, the Hadoop file system (HDFS). It splits large amounts of data and replicates it, making sure that data does not get lost and that there are no hot spots in the system.

On top of it, the MapReduce processing framework lets computation operate on that data and schedules data manipulation operations on specific nodes, ideally so that data does not constantly have to move from one node to another.

HBase provides a table-like view of the stored data, similar to what we know from databases, but not the same as a relational database representation. The Hive language front-end takes an SQL query and translates it into a number of MapReduce operations that operate on the data stored in HBase tables on top of the distributed file system.

Higher-level services include the R environment, for describing how data should be processed and analyzed, and Mahout, a collection of machine learning algorithms. At the lowest level, all of these end up as more primitive operations executing on top of the distributed file system. Supporting services provide locking and coordination, and streaming of data into the distributed environment.

### Berkeley Data Analytics Stack (BDAS)

![](https://assets.omscs.io/notes/686C631F-E544-4048-AF40-A21BB31E7427.png)

BDAS similarly has a data storage layer, with an in-memory file system on top of it. Either the regular Hadoop MapReduce engine or another processing framework, Spark, can run on top of this layer. Spark has a number of front-ends for different execution models: SQL queries, stream processing, graph processing, and machine learning.

At the lowest level, Mesos is the scheduling framework and resource manager. It allows resources to be partitioned and used by different types of frameworks; for example, there may be a Hadoop partition, a Spark partition, and an MPI partition. The frameworks coordinate and negotiate among themselves through Mesos, which provides elasticity across these very different types of frameworks.
