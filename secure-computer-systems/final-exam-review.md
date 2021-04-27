---
id: secure-computer-systems-final-exam-review
title: Final Exam Review
course: secure-computer-systems
lecture: final-exam-review
---

Before getting into final exam review Dr. Ahamad spends some time discussing

* The overall structure of the course
* Things we didn't discuss that are important in the field
* Important conferences in the field
* Active research areas

# Final Exam Review

The final exam is not cumulative, it covers

1. SELinux
2. Covert Channels
3. Distributed Systems Security
4. Database Security

## Refresher

### SELinux

* Roles
* Domain/object type and type enforcement
* Multi-level security, BLP+ which is read down and write at your own level
* Evaluating security policies

### Cover/side channels

* Covert communication lets you talk through channels not intended for communication, bypassing mandatory access control.
* Detecting covert channels, estimating their bandwidth, and mitigating them.
* The pump abstraction

### Distributed Systems Security

* Principals, statements and credentials (credentials are valid statements). Understanding the axioms and logic.
* Securing network channels with key exchange between named principals. We end up with authenticated secure channels.
* Security on the nodes in a network. A node isn't just a machine, it is a machine running an OS. Understanding the secure loading/boot, I think this section is the enclave/SGX stuff. Also understand how delegation works so the named entity can run their application on the OS on the machine and have it speak for them.
* Be able to analyze the security of a system.

### Database Security

Databases are different because the data is structured. We have queries, views, and stored procedures.

There are inference attacks, which use statistical queries and aggregate results to obtain data that shouldn't be accessible. There are some defenses to these inference attacks, and we can evaluate the effectiveness of these defenses.

Here are some of the techniques used to prevent inference attacks

* De-identification
* K-anonymity
* l-diversity
* Differential privacy

### Multi-level Databases (MLDB)

* There are access classes associated with each attribute/entry. These access classes for single values are used to compute the access classes for tuples, relations (tables?), and the whole database.
* There are different instances of the database viewed by users having different access classes (i.e. some users see null values because they have no permissions). There are inter-instance properties that formalize these things.
* Poly-instantiation can be visible and invisible. There is the Sea View and the JS models for poly-instantiation. There are certain things that should be true, formalized in poly-instantiation integrity.

## Sample Questions

### 1.

**Prompt:** We discussed the Bell and La Padula (BLP) model for mandatory access control in a system where a trusted computing base (TCB) on a single node mediated access to a set of documents.

In this question, we want to explore the BLP model in a distributed setting. In particular, we will consider the secure shared store 3S that you implemented. Assume that each client node runs a TCB that includes client user labels with *check_in()* and *check_out()* requests when it sends these requests to the 3S server. Assume that the TCB running at the 3S server is SELinux. 

Answer the following questions for this system and explain the answers.

**a.** When will SELinux allow *check_in*?

**Answer:** SELinux supports BLP+. Check_in is like a write, you can only check_in at your own level.

**b.** Can a covert channel be established by a high process to send sensitive data to a low process in this system where documents are stored at the 3S server and shared by clients at various nodes? If your answer is yes, explain how the covert channel is established and if it is noisy.

**Answer:** It depends on what *check_out* returns when access is denied to a file. If it says there is no access to the file, then the high process can use the presence/absence of a file on the server to communicate with the low process as we have discussed before. This would mean that a covert channel can be established and it is a storage channel. There is a possibility of a timing channel but you would have to explain exactly why one might arise.

**c.** Explain how a pump can be used to mitigate covert channels in a distributed system. If you provide an example of a covert channel in the previous part, can the bandwidth of this channel be reduced using a pump?

**Answer:** For timing channels, Pump can be used to break the timing pattern for acks or responses received by a node. The pump delays a response by some random amount. If the covert channel is storage based, the pump cannot reduce the bandwidth. If it is timing based, it can reduce the bandwidth.


### 2.

**a.** The ACL of a file *F* says that Bob has read access to it. Alice makes a request for *F* with the statement *Bob says Alice* $\implies$ *Bob*. Should access to *F* be granted to Alice in response to this request? Briefly explain your answer.

**Answer:** Yes, from the handoff axiom, Alice is at least as strong as Bob. Request should be granted. Essentially, she has a statement signed by Bob's private key saying that she can act on Bob's behalf. Bob has permission to read so Alice now has permission to do this for him.

**b.** Alice makes the same request but she only sends statements that can be used to infer 

Alice | Bob $\implies$ Alice for Bob

Should the request to F be granted in this case?

**Answer:** No, the delegated principle is Alice for Bob, which is not the same principal as Bob. Only Bob has access. We can have Alice speak for Bob because then Bob is actually saying it via Alice, no delegation.

**c.** The ACL for F is now changed to the following: "M as OS as Accounting for Alice can read F". We want to explore how an attacker may be able to gain unauthorized access to file F with this ACL. Answer if the attacker can successfully gain access to F under the following scenarios.

**c.1.** The attacker is able to steal Alice's private key but does not have physical access to machine M.

**Answer:** The ACL says we need M as OS as Accounting for Alice, so if you can't use M then you can't break in.

**c.2.** The attacker is able to compromise the private key of machine M.

**Answer:** If Alice isn't logged into the machine then they can't break in. They need both the machine key and Alice's key.

**c.3.** The attacker is able to compromise the operating system at the client node via a rootkit and is able to steal Alice's private key.

**Answer:** The data can be exfiltrated, since the OS on the machine is compromised then we are on the correct machine, and we have control of the operating system so we can do whatever we want on the machine.

**c.4.** The attacker is able to trick Alice to download a malicious "Accounting" application on her node.

**Answer:** A malicious application can exfiltrate the data, the request will be coming from M as OS as Accounting for Alice.

### 3.

**Prompt:** A medical database is de-identified and generalized to ensure k-anonymity and l-diversity before it is made public. Answer the following questions for this database.

**a.** It is always the case that k > l. True or false? Explain.

**Answer:** The value for k is the minimum number of observations across all QID groupings, and l is the minimum number of different sensitive values across all QID groupings. It could be the case that every row in every QID group contains a different sensitive value then we have k = l.

**b.** To have her medical information included in the database, Alice wants an assurance that there is no greater than 10% chance that a certain sensitive medical condition can be uniquely associated with her. Is it possible to provide this assurance with suitable choice of values for k and l? Explain your answer.

**Answer:** Yes, when k and l are greater than 10 there are at least 10 conditions with the same QID as hers.

**c.** If Alice is assured $\epsilon$-differential privacy with $\epsilon$ = 0.1, does she have the same level of privacy as in the above question? Explain.

**Answer:** 

Here's the formula for differential privacy - 

$$\frac{P[K(D)\text{ in }S]}{P[K(D')\text{ in }S]} \leq e^{\epsilon} \approx 1 + \epsilon$$

If $\epsilon$ = .1 than we have a 10% higher chance of a successful inference attack.

### 4.

**a.** In a multi-level relational database that implements the BLP model (e.g., SeaView), different elements in a tuple can have different access classes even when the tuple access class is the same as the access class of the tuple's primary key element. True or False? Explain.

**Answer:** False. For elements of the tuple, the following inequality holds. 

$$\text{key class} \leq \text{element class} \leq \text{tuple class}$$ 

So if the key class equals the tuple class then all elements must have the same class as the key/tuple.

**b.** The SeaView model focuses on BLP but in databases that store crowd-sourced data, integrity could be the primary concern (e.g. database is a repository for news stories and some of the stories could be fake news). Assume access levels for integrity could be low, medium, high, or very high. Users, who add data to the crowd-sourced database, can also have these same access levels based on how credible they are. Assume we want to support a Bibe like model in this database. Would there be poly-instantiation in this system? If yes, would it be visible, invisible, or both kinds.

**Answer:** Biba is read up, write down. Poly-instantiation will be visible since you can only read down.