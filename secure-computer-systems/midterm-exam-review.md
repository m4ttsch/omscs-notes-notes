---
id: secure-computer-systems-midterm-exam-review
title: Midterm Exam Review
course: secure-computer-systems
lecture: midterm-exam-review
---

# Midterm Exam Review

It is expected that you not only know the concepts, but can apply, analyze, and evaluate them.

The important sections of the required readings will be given in this module along with a review of core concepts and some practice questions.

## Design Principles, Memory Protection and Virtualization

### Requirements

The trusted computing base must meet 3 core requirements

* **Tamper-proof:** Untrusted code cannot modify code that makes up the trusting computing base.
* **Complete mediation:** Every reference from a resource that needs to be protected needs to go through the TCB.
* **Correctness:** The TCB must do work as expected, or else no other guarantees can be made.

### What is Trust?

* Understand the [Ken Thompson paper](https://dl.acm.org/doi/pdf/10.1145/358198.358210), "Reflections on Trusting Trust"
* TCSEC, the orange book. Mandatory access required when going from C to B. What does it do? How well does it do it? Division A focuses on formal proof.
* TPM and Attestation.

## Design Principles

* **User acceptability:** Don't require something unrealistic of your user to achieve security. For example a password requirement could be unacceptably long.
* **Economy of mechanism:** Simpler implementations are more secure.
* **Open design:** Don't rely on security by obscurity.
* **Least privilege:** Only giving applications what they need to function.
* **Separation of privilege:** Having granular ways of controlling access.
* **Fail-safe defaults:** Denying access by default. The user has no permissions that are not explicitly granted.
* **Defense in depth:** Having multiple diverse protection layers to protect against hackers

Read [Protection of Information Systems Paper](http://web.mit.edu/Saltzer/www/publications/protection/Basic.html), Section 1

## Memory Protection and Hardware Supported Isolation

User-level vs. System-level, there is a boundary between trusted and untrusted created by the TCB. Some privileged instructions can't be executed in user mode. There are different rings and we talk about how control transfer happens between these things.

How to translate from an address in virtual memory to an address in physical memory.

* Segmentation and paging
  * Hardware supported memory protection
  * Control transfer between privileged and non-privileged modes
  * Memory protection in 32 and 64-bit architectures
* CPL, RPL, DPL
* How does the hardware provide isolation for TCB from untrusted user code?
  * The user cannot directly modify memory belonging to the TCB. All user applications depend on logical address translation (performed by the hardware) which isolates them from the TCB.
* How does it protect one process's memory from other processes.
  * Logical addresses for different processes may be the same but will have their own physical memory. The physical memory for different processes are isolated, this is ensured by our address translation processes.

Read [Intel document](https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-system-programming-manual-325384.pdf) chapter 5 and background from chapters 3 and 4

## Virtualization

* Why virtualization?
  * Economy of mechanism. Less code than writing an OS.
* Type I and type II VMM
  * Type I VMM is between the hardware and guest OS. Type II VMM is above the OS. We focus on type I.
* Virtualization requirements
  * **Transparency** - The VMM provides an identical execution environment to the underlying physical machine. Note: There will be some performance degradation.
  * **Complete Mediation** - VMM controls all physical resources
  * **Efficiency** - Most VM instructions should execute natively \(directly on the hardware\).
* Hardware support for virtualization \(VT-x\)
* Root and non-root mode
  * Full
* Address translation with VT-x
  * Logical, guest physical, physical. How is this performed?
* Control transfer with VT-x \(VM exit and entry\)

**Readings**

* [Pentium virtualization paper](https://www.usenix.org/legacy/events/sec2000/full_papers/robin/robin.pdf), first 3 sections
* [SGX explained](https://eprint.iacr.org/2016/086.pdf), up to page 15 

## Authentication

* Entropy, authentication methods, implementation, evaluation
* Password hardening
  * Secret sharing based implementation, instruction table usage, history file. Expected to know this stuff.
  * Security analysis
  * Entropy estimation
* Password hardening is simply used as an example. For any authentication method you could be asked how to implement it and how to evaluate it.

When we talk about authentication 2 things are most important:
* implementation 
* security analysis

Also understand the threat model and how much work they must do.

**Readings**

* [Password hardening](http://citeseer.ist.psu.edu/viewdoc/download;jsessionid=7F15121BE6DEB80FF7ECDAC7DC52086D?doi=10.1.1.118.6510&rep=rep1&type=pdf) paper except sections that do hard math.
* Read sections 1 and 2 from [PIN-and-CHIP](https://www.cl.cam.ac.uk/research/security/banking/nopin/oakland10chipbroken.pdf).

## Access Control

### Discretionary Access Control - DAC

* Access Control Matrix
* ACLs and C-lists, tradeoffs
* HRU result
* Access control implementations in Unix, Linux, Windows
* Setuid: Motivation and usage
* Java accesss control \(Principals, Stack Introspection, and doPrivilege sections\). Really wants you to understand stack introspection and how it works. 
* Introduction to capabilities of Hydra.

**DAC readings**

* Protection by [Lampson](http://bwlampson.site/08-Protection/WebPage.html)
* Sections 1-6 of [Unix paper](https://www.usenix.org/legacy/events/usenix03/tech/freenix03/full_papers/gruenbacher/gruenbacher.pdf)
* Sections 1-3 of [Windows paper](http://pages.cs.wisc.edu/~swift/papers/win2kacl.pdf), you may have to traverse whole list if negative ACE not up front
* Section 1-4 of [Setuid demystified](http://pages.cs.wisc.edu/~swift/papers/win2kacl.pdf) paper \(only Linux\)
* [Java paper](https://www.usenix.org/legacy/publications/library/proceedings/usits97/full_papers/gong/gong.pdf) \(Policy files, Stack Introspection and doPrivilege sections\)
* Sections 1-6 of [Hydra](https://homes.cs.washington.edu/~levy/capabook/Chapter6.pdf) \(Objects and Capabilities, Sharing, Revocation and Protection problems\)

### Mandatory Access Control - MAC

* Motivation
  * **Shortcomings of DAC:** Information flow control problem (Alice -> Bob -> Throckmorton), user sets permissions (company might want to set permissions).
* Labels
  * Comparison, partial ordering, domination
* BLP model
  * simple security (read down rule), * property (write up rule).
  * How does BLP solve flow control.
  * Tranquility principle, non-accessibility of inactive objects
  * Declassification
* Biba Model
  * Focused on integrity
  * Read up write down rule
* RBAC
  * Permission assignment, User role assignment
  * RBAC1 is hierarchical
  * Roles are specific to jobs, unlike groups
  * Policy file is smaller, R(O+U) < O*U, economy of mechanism
* Clark-Wilson Policy
  * Users run applications
  * Applications have permissions
  * Defined order in which things happen
  * Separation-of-duty, one person can't be the buyer AND the seller.
  * Can partially implement using setuid(), difficulty implementing ordering or separation-of-duty because of statefulness
* Chinese Wall Policy
  * Deals with conflict of interest
  * Objects are placed in companies, companies are placed in groups where companies within the same group have conflicting interest.
  * If you read documents from Coca Cola you cannot access documents from Pepsi.

**MAC readings**

* Sections 6.3 to 6.5 of [Gasser book](https://www.researchgate.net/publication/242363259_Building_a_Secure_Computer_System)
* [RBAC paper](https://www.profsandhu.com/journals/computer/i94rbac(org).pdf)
* [Clark-Wilson papers](https://groups.csail.mit.edu/ana/Publications/PubPDFs/A%20Comparison%20of%20Commercial%20and%20Military%20Computer%20Security%20Policies.pdf)

## Sample Questions TCB, Design Principles and Virtualization

### 1.

**Prompt:** The rowhammer bug exploits a vulnerability in DRAM memories that can result a bit flip in a memory location by repeated reading of locations in an adjacent row. Exploits have been reported which allow user level code to cause a bit flip in a page table entry. In fact, a process could use this exploit to gain write access to its page table entry.

**a.** Describe the three requirements that must be met by a trusted computing base \(TCB\).

**Answer:**
1. Tamper proof
2. Complete mediation
3. Correctness

**b.** Which of the TCB requirements described in 1\(a\) could be violated in a system that has main memory with the rowhammer bug?

**Answer:** Tamper proof. You could make an argument that other requirements are being violated, but the fundamental problem is that user code is modifying the function of the TCB.

### 2.

Answer the following questions about design principles for secure systems.

**a.** Briefly describe the least privilege and fail-safe default principles.

**Answer:**

* Least privilege is that a process must execute with the fewest privileges with which it can complete its execution.
* Fail-safe default means we deny access unless explicitly granted.

**b.** If a system correctly implements the least privilege principle, should it also follow the failsafe default principle? Explain your answer.

**Answer:** The principle of least privilege states that a subject should be given only those privileges that it needs in order to complete its task. It requires that in a particular abstraction layer of a computing environment, every module (such as a process, a user, or a program, depending on the subject) must be able to access only the information and resources that are necessary for its legitimate purpose.


The principle of fail-safe defaults states that, unless a subject is given explicit access to an object, it should be denied access to that object. A fail-secure system is one that, in the event of a specific type of failure, responds in a way such that access or data are denied.

These are different things.

### 3.

**Prompt:** Answer the following questions about memory protection in the Intel x86 architecture. You must justify your true/false answer with a brief explanation.

**a.** In the protected mode in the x86 architecture, when current protection level \(CPL\) is 0, any data from both user and kernel segments can be accessed. True or false?

**Answer:** False. We can access only when max(CPL, RPL) $\leq$ DPL. When RPL is 3 it doesn't matter what CPL is, we cannot access segments with DPL 0.

**b.** In a virtualization system with a type I hypervisor, a guest OS can run in ring 0 even in the absence of virtualization extensions of the x86. True or false.

**Answer:** False, you need the virtualization extension for the guest OS to run in ring 0. The hypervisor runs in ring 0, so the guest OS can't run in ring 0. We would have to modify the OS to not run in ring 0, this is paravirtualization. The VT-x is where we add new rings for the VMM, VT-x runs in ring -1 so that the OS can run in ring 0.

**c.** With the Intel SGX extensions, code in an enclave does not need to trust the hypervisor. This is because such code runs in a more privileged ring than the hypervisor. True or false.

**Answer:** It is true that code in an enclave does not need to trust the hypervisor, but it is false that this is due to it running in a more privileged ring than the hypervisor. The enclave code is actually in ring 3, the same ring as untrusted application code. The enclave code is protected instead through hardware mechanisms separate from the rings.

**d.** Consider the EIP and CR3 registers in x86 processors. EIP stores the address of the next instruction to be executed and the base address of a page table is stored in control register CR3. Both of these registers can be loaded using non-privileged instructions. True or false.

**Answer:** Because CR3 is used in page translation it must be loaded with privileged instructions. EIP is constantly updated to point to the next instruction. This doesn't require privileged instructions.

### 4.

**Prompt:** These questions are related to the password hardening paper discussed in class. Briefly explain your
answers.

**a.** An attacker is able to gain access to a sequence of instruction tables (IT) for a user as the user
logs into the system and the IT gets updated. Can the attacker infer what features are
distinguishing for this user given a sequence of ITs? 

**Answer:** This really doesn't give the attacker any new information.

**b.** Assuming each character in a password has four bits of entropy, what is the possible
minimum and maximum entropy of the password hardening authentication scheme when
every feature for every user is distinguishing. Assume that the password length is 8
characters.

**Answer:** The entropy due to the password is 8\*4 = 32. The entropy due to the hardening, well there are 8\*2-1 = 15 features in the feature vector. In the best case all are distinguishing and we get 15 extra bits of entropy, in the worst case none are distinguishing and we get 0 extra bits. Therefore we have between 32 and 47 bits of entropy.

**c.** In voice-biometric authentication, feature values are derived from audio captured from the
voice of a user. A vector of such feature values is computed when a user wants to login, and it
is compared against a similar vector which is provided to the system when the user is enrolled
by this system. Since feature values could change from one login to the next, the comparison
is typically done by computing similarity between the feature vectors. For example, cosine or
Euclidian distance may be computed between the points represented by the two vectors and if
the distance is below a certain threshold, the user is allowed to log into the system. 

**i.** Give an example of an attack that such an authentication scheme must consider.

**Answer:** You could record someone's voice and replay it.

**ii.** Is the voice-biometric scheme robust against such an attack?

**Answer:** No.

**iii.** If not, is it possible to implement it differently to defend against such an attack?

**Answer:** Maybe ask them to say a specific thing.


### 5.

**Prompt:** These questions are related to access control. Please provide brief explanation for your answers.

**a.** In Unix, an executable program file F is owned by user U and its setuid bit is 1. It is always
the case that both the real and effective UID when F is executed is the user id of U. True or
false.

**Answer:** False - The real ID is the ID of the owner of the process, which may not be the owner of the file F.

**b.** We discussed implementations of access control lists (ACLs) with a linked list. However,
other efficient implementations of linked lists also exist. For example, a hash table could be
used to improve performance in which a user or group id can be hashed to locate the access
control entry. Would you recommend such a hash table based implementation for Windows
ACLs?

**Answer:** It seems like you could either answer yes or no depending on your implementation. The important thing is being able to explain your reasoning.

**c.** Capability revocation in Hydra requires use of additional common objects. Assume n
different objects currently have access to a shared object O. If we want to allow revocation of
O’s capability for any subset of the n objects, how many additional common or intermediate
objects will we need? 

**Answer:** For each object having access to the shared object O, we will need an intermediary object that maps from the object to O. 

### 6.

**Prompt:** We discussed the Bell and La Padula (BLP) model for mandatory access control in a system where a
trusted computing base (TCB) mediated read and write access to a set of documents. In this question,
we want to explore the BLP model in a storage system setting (think of Dropbox like system).
Assume that each user runs a TCB that includes user labels and provides check_in() and check_out()
calls that allow users to request a to document and store it back in the storage system. The TCB
compares requesting user labels with the labels of requested documents, and takes appropriate action
(e.g., updates a document, makes a copy for the requesting client or denies a request). Answer the
following questions for this system

**a.** Describe the simple and star properties (read and write rules) of the BLP model, and discuss
how they will apply in this system. How will these rules be adapted to handle check_in() and
check_out() requests? In other words, based on labels of requested documents, how will the
storage server decide if a received request should be allowed?

**Answer:** The simple security property is that the label of the reader must dominate the label of the read object (read-down). The star property is that the label of the writer must be dominated by the object being written (write-up).

We treat check_in() like a write and check_out() like a read.

**b.** Assume that the storage server stores documents of various companies and some of these
companies may have conflict-of-interest (CoI) requirements that need to be met. What policy
can be used to address CoI, and explain how the storage server can implement it?

**Answer:** The chinese wall policy can be implemented to address the CoI. To implement this we label documents with the companies that they belong to. We put companies in groups where companies within a group have conflicts of interest with each other. We do not let someone check out a document if they have previously checked out a document from a company that has a conflict of interest with the requested document.
