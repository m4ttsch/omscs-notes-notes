---
id: information-security-mandatory-access-control
title: Mandatory Access Control
course: information-security
lecture: mandatory-access-control
---

# Mandatory Access Control

## Discretionary Access Control
In the last lesson we talked about access control.

In particular, we focused on **discretionary access control** (DAC), whereby the user who creates a resource is the owner of that resource and can choose to give access to other users.

## Two Problems with DAC
To illustrate the first problem with DAC, let's consider the following scenario.

Alice owns a file and gives read access to Bob, but not to Charlie. Bob copies the contents into a new file, and shares that file with Charlie. Charlie now has effective access to the file that Alice didn't want to share with him in the first place.

While DAC allows users to control direct access to a file, we can't actually prevent the spread of data contained in that file; that is, we can't control the *information flow*.

Another problem with DAC is that it doesn't reflect how most organizations treat their data. Most employers do not leave the decisions about data sharing in the hands of their employees, but rather mandate explicit policies about who can share what.

To address these problems, we will explore another model for access control: **mandatory access control** (MAC). In mandatory access control, decisions about sharing information are not made at the discretion of the user.

## DAC Quiz
![](https://assets.omscs.io/notes/FFAA8FAE-B0AC-421F-A71A-2B59F7D76D87.png)

## DAC Quiz Solution
![](https://assets.omscs.io/notes/CC4FCC5B-CC40-4ADC-8AC7-B14CEA595009.png)

DAC can't control information flow, so we must use MAC.

## Mandatory Access Control (MAC) Models
Hospitals are a great example of an entity that needs to employ mandatory access control.

Hospitals store and process electronic health records (EHRs), which contain medical information about patients. We regard  health information as highly sensitive and, as such, seek to limit who can access and/or share this information.

In addition, there are regulatory requirements that limit how medical information can be shared and control how patient records can be accessed. [HIPAA](https://www.hhs.gov/hipaa/index.html) is the legislation in the United States that dictates how records can be accessed and shared.

Of course, there is a need to share your medical information - if you see a new doctor, for instance.

The point is that these access control decisions are not dictated by the individual performing data entry on the patient's record, but rather by the hospital and the government.

## Implementing MAC
In mandatory access control, users and resources/documents will have certain labels associated with them.

A **label** is simply an identifier that will tell us how sensitive certain information is, or how privileged a certain user is. Labels can also contain categories, which can be used to group users or documents.

While the TCB does not assign these labels, it uses labels to determine whether a given user can access a given resource.

In order to grant access decisions, we have to be able to compare labels. Labels must have an order so that the system can make consistent decisions.

For example, if `A > B > C`, the system will deny access to a document with label `A` to a user with label `B`, but will grant that user access to a document with label `C` .

The exact nature of what the labels look like, how we compare them, and the result of the comparison depends on the particular policy being implemented.

In the Department of Defense, the labels will include a clearance level for users and a classification level for documents, as well as a compartment. The compartment is used to describe what kind of information a document contains and what categories of information a user can access.

In the commercial world, we don't have notions of clearance and classification, so the labels will look different.

The concerns are different as well. For example, we may have a policy that prevents conflict of interest. A user may not be able to access resources from which they stand to enjoy a material gain.

## Implementing MAC Example
In the Department of Defense, documents have classifications and users have clearances.

The sensitivity levels present in the DoD system, in order from most sensitive to least sensitive, are: Top Secret, Secret, Confidential, Restricted, and Unclassified.

A label contains a sensitivity level and a compartment that describes what kind of data is contained in the document.

Let's consider two different documents, which contain information about various arms stockpiles.

One document may have the label `(TS, {nuclear, chemical})`, identifying it as a top secret document concerned with nuclear and chemical weapons.

The other document may have the label `(S, {nuclear, conventional})`, identifying it as a secret document containing information about nuclear and conventional weapons.

A document may pertain to multiple topics, so the compartment can have multiple entries.

The [Bell-LaPadula Model](https://en.wikipedia.org/wiki/Bell%E2%80%93LaPadula_model) (BLP) makes use of labels and provides a set of rules that determines when a document can be read or written.

## Health Data Quiz
![](https://assets.omscs.io/notes/B190798D-AB66-4B7B-938B-ED38D21FBB4C.png)

## Health Data Quiz Solution
![](https://assets.omscs.io/notes/9EF783B9-6360-427A-918C-CDF9773C4034.png)

BLP is concerned with military/governmental intelligence. HIPAA is concerned with health information.

## Security Clearance Quiz
![](https://assets.omscs.io/notes/4492690A-933D-4088-BCCC-51031EA9A047.png)

## Security Clearance Quiz Solution
![](https://assets.omscs.io/notes/D0C61525-5A43-4B43-8C64-4CCBC4715B41.png)

Source: [Washington Post](https://www.washingtonpost.com/news/the-switch/wp/2014/03/24/5-1-million-americans-have-security-clearances-thats-more-than-the-entire-population-of-norway/?noredirect=on)

## Comparing Labels
In order to fully implement access control using labels, we need some strategy for comparing labels.

Sensitivity levels in the DoD scheme are ordered as follows:

```bash
TS > S > C > U
```

This ordering is *total*, which means that if you pick any two sensitivity levels, you can always determine which level is more sensitive than the other.

Labels also have compartments, which comprise sets of different topics.

Two sets `S1` and `S2` can be oriented such that

- `S1` is contained in `S2`
- `S2` is contained in `S1`
- Neither set contains the other

Sets are compared by containment. A set that contains another set is "greater" than that set. Note that this ordering is *partial*, because two sets that don't contain each other cannot be ordered.

When we want to order labels, we must look at both the sensitivity level and the compartment

## Comparing Labels Example
Based on the comparison rules just described, the following chart depicts the circumstances under which

- one label dominates another
- two labels are equal
- two labels are not comparable

![](https://assets.omscs.io/notes/5A925057-513C-4F06-B342-E5D00A71AD2C.png)

## Ordering Among Labels
Let's try to compare the following labels.

```bash
L1 = (TS, {A,B,C})
L2 = (S, {A, B})
L3 = (S, {B, C, D})
```

`L1` dominates `L2`  because `TS > S` , and `{A, B, C} > {A, B}`.

`L2` cannot be compared with `L3` because while `S == S`, `{A, B}` cannot be compared to `{B, C, D}`.

Similarly, `L1` and `L3` cannot be compared. While `TS > S`, `{A, B, C}` cannot be compared with `{B, C, D}`.

## Order Quiz
![](https://assets.omscs.io/notes/2F90AB65-3E72-4760-BB6B-28DB02993748.png)

## Order Quiz Solution
![](https://assets.omscs.io/notes/37633CE2-16DD-45D5-B67D-52318AF4DD6E.png)

Given any two real numbers, one number is always greater than the other.

## Label Domination Quiz
![](https://assets.omscs.io/notes/11C6E389-14C8-4928-B128-A743249D4F2A.png)

## Label Domination Quiz Solution
![](https://assets.omscs.io/notes/89DAADB0-D668-480D-8B6D-38C0037CCE42.png)

While `secret < top-secret` , `{Asia, Europe}` cannot be compared with `{Europe, South-America}`.

## Sensitive Data Quiz
![](https://assets.omscs.io/notes/65E58104-8D29-4E6C-AE31-FCB742D1C233.png)

## Sensitive Data Quiz Solution
![](https://assets.omscs.io/notes/34881303-A27C-4BB1-807C-03DE3A0016D9.png)

In order for `D1` to dominate `D2`, `D1` must have a higher sensitivity level than `D2`.

In addition, the compartment of `D1` must contain the compartment of `D2` in order to be 'greater' (based on the ordering rules for sets). For this to be the case, the compartment of `D2` must be a subset of ("narrower" than) the compartment of `D1`.

## Using Labels for MAC: Confidentiality
The **Bell and LaPadula Model** (BLP) is a model that deals with confidentiality. Its development was funded by the DoD.

The model is concerned with disclosure of information and preventing information of one classification level from being shared with individuals possessing a clearance level of lower sensitivity.

Since the model was developed for the DoD, this model assumes the classification/clearance levels of top secret, secret, classified, and unclassified. In addition, a label can have a compartment that describes what a given document is about.

There are two main operations a user can perform with a file - read and write - and so the model defines a rule for each operation.

### Read-Down Rule
The read rule says that a user with label `L1` can read a document with label `L2` only if `L1` dominates `L2`.

For example, a user with secret clearance may read a classified document.

This rule is the *read-down rule*, also known as the **simple security property**. A user can read documents that are classified at their clearance level or lower.

### Write-Up Rule
The write rule says that a user with label `L1` can write a document with label `L2` only if `L2` dominates `L1`.

For example, a user with secret clearance may write a top secret document.

This rule is the *write-up rule*, also referred to as the **star property** (*-property). A user can write documents that are classified at their clearance level or higher.

What is the rationale for write-up?

If I am a user with top secret clearance and I write a secret document, I may - inadvertently or maliciously - include top secret information in that document.

Since users with secret clearance can now read this document, we have broken the containment of top secret information to the top secret clearance level.

For this reason, users are only allowed to write documents at their clearance level or higher.

## Preventing Information Flow with BLP
Information flow is a problem that cannot be addressed with discretionary access control. Mandatory access control - in particular, the BLP model - solves the information flow problem.

![](https://assets.omscs.io/notes/4FE897A0-C072-4EA6-8500-C9D672BA0036.png)

Basically, we want to ensure that top secret information never ends up in the hands of individuals with less than top secret clearance.

The write-up and read-down rule prevent more sensitive information from flowing into the hands of users with a less sensitive clearance.

On one hand, users with secret clearance are not allowed to read top secret documents.

On the other hand, users with top secret clearance are not allowed to write secret documents, lest they reveal some top secret information in them.

A user with secret clearance is thus unable to access top secret information because: one, they are explicitly prohibited from reading top secret documents, and; two, users with top secret information are prohibited from writing that information into secret documents.

## Unclassified Documents Quiz
![](https://assets.omscs.io/notes/EA4A6F50-B773-4345-BD3C-28CFB3AEA7D4.png)

## Unclassified Documents Quiz Solution
![](https://assets.omscs.io/notes/3D70CF4F-3BC7-40D2-B75C-FB84BB1CE0D8.png)

Write-down says that individuals cannot write documents with a classification that is less than their security clearance. Therefore, unclassified documents cannot be written by individuals holding a security clearance of classified, secret, or top secret.

## Classified Data Quiz
![](https://assets.omscs.io/notes/2BE2011C-6B0A-4D48-BF24-575316A8F447.png)

## Classified Data Quiz Solution
![](https://assets.omscs.io/notes/A699ECFA-0934-4CCD-9C63-056FD1E46428.png)

Because of the write-up rule, individuals are allowed to write documents at a classification level that is greater than their clearance level. Individuals with unclassified security clearance are thus allowed to write top secret documents.

## BLP Model Quiz
![](https://assets.omscs.io/notes/C4229ADC-2062-4802-BD5C-8BA008F90F29.png)

## BLP Model Quiz Solution
![](https://assets.omscs.io/notes/3D182BB1-66B8-4F82-8795-E5BEEA1C6F11.png)

For example, if a user is writing to a top secret document, and the classification level suddenly changes to secret, the write-up rule is violated and information is flowing in the wrong direction.

## Other MAC Models
Instead of focusing on confidentiality, the **Biba Model** focuses on integrity.

Remember, integrity is concerned with information quality, while confidentiality is concerned with information disclosure.

The Biba rules are the inverse of the BLP rules.

When you are concerned about information integrity, you want to *read up*. Information that is of lower quality than the information that you produce is of no interest to you.

In addition, Biba defines a write down rule. If you can produce information at a certain level of integrity, you can surely produce information at a lower integrity. Therefore, you can write documents at or below your integrity level.

For example, the New York Times may have a high level of integrity. That information can likely be trusted. Supermarket tabloids are low integrity. Information in those documents is likely of poor quality.

The compartment component of the integrity label can capture the topic(s) of the document, similar to BLP.

The point is that low integrity information should never flow into high integrity documents.

## Policies for Commercial Environments Part 1
In commercial environments, user clearance is not common. However, other requirements exist.

One common requirement is that data should only be accessed by certain applications, and only certain users should be able to gain access to those applications.

For example, only employees in payroll should have access to salary files.

Another requirement that arises in commercial environments is preventing conflict of interest. Users must be prevented from accessing information that can place them in a conflict of interest.

For example, a financial analyst advising a bank should not have access to confidential information from other banks.

Finally, a separation of duty requirement can be important for reducing the possibility of fraud. If a user can take on multiple roles, it can be easier for them to commit fraud.

For example, a user should not be able to both authorize and execute a financial transaction.

## Policies for Commercial Environments Part 2
Let's look at two different policies that make sense for commercial environments.

### Clark-Wilson Policy
The **Clark-Wilson Policy** says that users should only be able to access certain applications, and only certain applications can access certain objects in the system.

Put another way, the access that a user has to objects in the system is constrained by the applications they are allowed to use.

Achieving separation of duty through this policy is as simple as blocking access to the set of programs that would allow a user to conduct fraudulent activity.

### Chinese Wall Policy
The **Chinese Wall Policy** deals with conflict of interest. Specifically, this model dictates that what a user can access now depends on what they have accessed in the past.

If the documents you have accessed so far have no conflict with the document you are currently requesting, access may be granted. Otherwise, access will be denied.

Let's assume we have the following documents in our system.

![](https://assets.omscs.io/notes/FF68C6DD-8AB9-4A4C-B4A5-EFCB0EB09B02.png)

The group of documents in the "Banks" box are referred to as a **conflict class**. Since Wells Fargo, Chase, and Bank of America are all competitors, access to documents about more than one of these banks can present an individual with a conflict of interest.

Similarly, the "Oil Companies" conflict class contains documents about competitors Exxon, Shell and Chevron.

The Chinese wall policy basically says that a user can access any object as long as they have not previously accessed an object from the same conflict class.

For example, once a user accesses a document pertaining to Exxon, they can access a document pertaining to Chase, but cannot access a document pertaining to Shell.

## Clark Wilson Quiz
![](https://assets.omscs.io/notes/A286764A-C66E-4C60-9CE7-106440934312.png)

## Clark Wilson Quiz Solution
![](https://assets.omscs.io/notes/A4317935-9B6A-4DB8-869A-1644B8A403F0.png)

In mandatory access control, sharing decisions are not made at the discretion of the user.

## COI Quiz
![](https://assets.omscs.io/notes/FD528D21-BCC6-48D4-A1F4-179CB9A9470B.png)

## COI Quiz Solution
![](https://assets.omscs.io/notes/2A693A0B-93E6-4AE5-B6AB-3869601B5800.png)

Competition implies that there is a possibility for a conflict of interest. Chinese Wall is best at preventing these situations.

## RBAC Quiz
![](https://assets.omscs.io/notes/18AF82C6-AE0E-4A04-BE46-24C199FAC8DF.png)

## RBAC Quiz Solution
![](https://assets.omscs.io/notes/E32A017C-052D-4DF1-94CA-ABBD02770338.png)

In mandatory access control, the company decides who can share what.

## MAC Support Quiz
![](https://assets.omscs.io/notes/1F3AB8F6-7244-44E3-91BD-833C137AC8FD.png)

## MAC Support Quiz Solution
![](https://assets.omscs.io/notes/B94746DE-2747-401F-B607-68799681137C.png)

## Revisiting TCB
How do we know that a certain system that claims to be a trusted computing base can actually be trusted?

First, it is important to talk about terminology.

When we talk about something being secure, we are usually talking about a binary quality of a system. Either something is secure or it isn't.

When we talk about a system being trusted, we mean that we have a high level of confidence that the system will uphold the requirements that we expect it to uphold.

This high level of assurance is what we expect from the trusted computing based comprised of the operating system and the underlying hardware.

Any other claims we are able to make about the security implemented in the system - access control, for example - depend on the security of the trusted computing base.

## Trusting Software
Software is supposed to perform a set of functions. If it is going to implement certain functionality, it has to be functionally correct. It should do what it was designed to do.

To implement these functions, the software has to maintain certain data structures and state. Software often exposes an interface/API to allow users to consume and manipulate this state. Malicious users will use these entry points to attempt to compromise the system. The software must maintain the integrity of the data it relies on, especially in the face of malicious input.

The TCB stores and consumes sensitive data. It must protect this data and address the confidentiality/disclosure of this data. It must perform these duties in the presence of untrusted software.

Our assurance in the TCB describes how confident we are in its ability to carry out the above functions. We cannot always demand formal proof that a program works as expected, but there are certain actions that can increase our confidence.

For example, experts can analyze a program and assure the level of trust that a system provides. It is their word on which we derive our trust in the system.

In addition, we think about our requirement/needs as forming a specification of the security expectations we have for a system. Some vendor who builds the TCB (operating system) thus builds the system to those requirements.

The verification of trust should be formally (mathematically) derived where possible, but this level of certification is not always feasible.

## TCB Design Principles
Trust in the trusted computing base is going to come from a number of design principles we expect a TCB to embody.

A trusted computing base should follow the principle of least privilege. Any time a user is executing, they should be provided with the least amount of privilege required to complete their task.

Remember, a trustworthy system is one that performs with a high likelihood of security. That being said, there is no guarantee. If something goes wrong - a malicious user gains access, for example - least privilege provides damage containment.

A trustworthy system should abide by economy of mechanism. The trusted code should be small and it should be simple. Simple code is easier to analyze and less code means less bugs.

A trustworthy system should have an open design. Trust is not going to come through blindly believing a software vendor. Security by obscurity is a lie. We want open design so we can know exactly how a certain level of security is being achieved.

A trusted system should enforce complete mediation. Every access is checked by the system and attempts to bypass the system must be prevented.

A trusted system should provide fail-safe defaults. This means that the default behavior should be the safest behavior. When we talk about access control, for example, the fail-safe default is to deny access.

Finally, a trusted system should be psychologically acceptable. We have to make the right assumptions about what users are able to do and what they are not able to do. Users avoid security that gets in their way.

Trust comes from building a system with these principles in mind.

## Least Privilege Quiz
![](https://assets.omscs.io/notes/125DFCBE-E30F-4B38-AE98-DB12FA30C0DC.png)

## Least Privilege Quiz Solution
![](https://assets.omscs.io/notes/FC19D98D-46EB-46BE-8AE3-7C75BF6E482B.png)

The TCB provides high assurance, not certainty.

## TCB High Assurance Quiz
![](https://assets.omscs.io/notes/F33DDE22-EF71-4878-9A86-1153AE4C938B.png)

## TCB High Assurance Quiz Solution
![](https://assets.omscs.io/notes/47F700ED-F1EE-4693-B99C-5117AEEF93A2.png)

Security by obscurity violates open design.

## Design Principle Quiz
![](https://assets.omscs.io/notes/130DA7AD-F9EE-498B-807C-C00F7111C79B.png)

## Design Principle Quiz Solution
![](https://assets.omscs.io/notes/D70011C5-D8EA-404D-82A6-7A6C4A77DDDB.png)

A fail-safe default is one that provides security unless otherwise specified. In this case, the default should be traffic encryption.

## Support Key Security Features
If we claim a system to be a trusted computing base, it must fulfill certain key requirements. Specifically, the system must implement certain functions that are relevant to security.

For example, the system must address authentication, otherwise it cannot know who is making a request for a resource in the system.

Additionally, the system must perform access control against the objects it protects. We talked about two different kinds of access control.

Systems may support mandatory access control, using the BLP model or other models that we discussed. SELinux is an example of a platform that supports MAC.

Systems can also support discretionary access control, whereby the creator of a resource has control over who can and cannot access it.

## Data Protection
One of the requirements of a TCB is that it must be tamper-proof. In order to achieve this, an operating system must protect the data it uses.

When we talk about security features of trusted operating systems, one aspect that we can focus on is **object reuse protection**.

During execution, a process can allocate some temporary memory or disk space for storing information. When that process completes, the operating system needs to reclaim those resources to give to other processes.

If a process leaves behind some (potentially sensitive) data and the operating system reallocates the resources containing that data to a new process, the new process can potentially read that data. The operating system will have broken process isolation.

A system must understand that a process can leave behind some artifacts in these reusable resources and must ensure that they are "zeroed out" before being allocated again.

**Secure file deletion** refers to the operating system procedure of overwriting reclaimed disk space with varying patterns of zeros and ones in order to obfuscate the original contents.

**Secure disk destruction** is not really the job of the TCB, but rather is just a good practice when disposing of a computer. This involves [degaussing](https://en.wikipedia.org/wiki/Degaussing) or otherwise physically destroying your disk during disposal.

## Trusted Paths
A TCB must ensure complete mediation. We have to guarantee that there is no way to get to a resource without passing through the trusted computing base.

We also need to have a trusted path from the user to the secure system. Without the trusted path, a malicious program could spoof the interface of the trusted system.

Alternatively, a malicious program could tap into the communication path between a user and the TCB in the absence of a trusted path.

For example, a keylogger could tap the communication path from the keyboard to the operating system and record your password.

A trusted path confers confidence that a user is communicating exclusively with the trusted computing base.

### Auditing
We've talked a lot about prevention mechanisms, such as authentication and authorization, which are used to block inappropriate access to system resources.

The reality is that no matter how hard we work at prevention, things will go wrong. With this realization, we have to employ detection mechanisms in addition to prevention mechanisms.

We can keep an **audit log** of what happens in the system, and can use this log to detect unusual behavior that may be indicative of system misuse/abuse.

Naturally, the audit log, like all other data managed by the TCB, must also be tamper-proof.

[Butler Lampson](https://en.wikipedia.org/wiki/Butler_Lampson) describes the gold standard of security as authentication, authorization and audit. The symbol for gold is "Au" in the periodic table.

## Kernel Design
One approach for creating a trusted computing base is to design a **security kernel** where you bring the security-relevant functions together and place them at the core of the system you are trying to build.

In this approach, the security mechanisms and enforcement strategies live in the kernel and ensure the proper government of the rest of the system.

Kernel design strives to find the smallest possible system that encapsulates the necessary security mechanisms. This size requirement helps to ensure that the kernel is isolated from other parts of the system. In addition, smaller kernels lend themselves to easier analysis/verification.

Like other trusted computing bases, a security kernel must be tamper-proof and enforce complete mediation.

## Kernel Design and TCB
The mechanisms that are necessary for the correct enforcement of security policy belong in the security kernel.

Resources are implemented using physical hardware that we attach to the system, and the correct implementation of security blocks direct access to those physical resources.

Complete mediation can also be handled by virtualization. In virtual environments, host operating systems have handles for virtual resources, and the hypervisor allows us to achieve both hardware isolation and logical OS separation.

## Revisiting Assurance
In addition to describing the functionality that a TCB must possess, we need some *assurance* that it is actually carrying out those functions.

One basic check involves interacting with the developers of the system and ensuring that they have implemented all of the necessary requirements.

A more structured way to provide assurance is to extensively test the system. There are three main types of testing.

One type of testing looks at functionality. We write tests to ensure that our functions execute and our software is not "buggy".

Another type of testing is **penetration testing**. In penetration testing, the tester approaches the software with the adversarial mindset and specifically tries to uncover vulnerabilities in the system.

The final kind of testing is **regression testing**, which we run when we enhance a system to make sure that new features don't break functionality or hurt performance of existing features.

As a word of caution: testing can only demonstrate the existence of a problem. Tests cannot demonstrate the absence of a problem. For example, you cannot run a suite of tests and then claim that the system is completely secure.

Even better than testing is to have a formal proof that irrefutably verifies the functionality and security of a system.

## Assurance Challenges
### Functional Testing
A developer must generate the right set of test cases when testing a system. Test cases demonstrate the existence of problems, and without a sufficient number of test cases, problems may go undiscovered.

In testing a system, you want to have good code coverage. Ideally, you want to be able to test every execution path present in the system, so you can concretely understand any behavior that the system will exhibit when it is deployed.

The problem with this ideal is that execution paths grow exponentially in a system. For example, every `if-else` construct doubles the number of execution paths that need to be tested.

In addition, a system may behave differently in different execution environments, which also adds to the difficulty of achieving comprehensive testing.

### Penetration Testing
In penetration testing, we deliberately employ an ethical hacker to attempt to defeat the security measures we have in place.

As the good guys, we have the burden of ensuring that *every* possible execution path is secure. In penetration testing, the tester just needs to find *some* execution path containing a vulnerability that can be exploited in order to demonstrate a problem.

If they can't find any issues, this doesn't prove that we don't have a problem. Testing - penetration or otherwise - cannot demonstrate the absence of a problem.

### Formal Verification
A formal verification is a mathematical specification of a program's behavior. This verification proves which security assertions and properties hold throughout the execution of a system.

There are automated ways to formally verify a program, such as [model checking](https://en.wikipedia.org/wiki/Model_checking) and [automated theorem proving](https://en.wikipedia.org/wiki/Automated_theorem_proving).

These approaches typically look at the initial set of state variables in a program and watch how the code changes these variables. Throughout the execution of the program, assertions about security are verified against the program state.

The problem with model checking is the same that we had with testing. The state space grows exponentially which makes this approach unfeasible for anything other than relatively small programs.

Model checking pioneers won the Turing Award in 2007 and this field remains an area of active research.

## Reducing TCB Size Quiz
![](https://assets.omscs.io/notes/11F63B01-9D9D-4070-B054-C4DE0A004584.png)

## Reducing TCB Size Quiz Solution
![](https://assets.omscs.io/notes/B9687C3C-5D80-45A9-9112-224E955CDF88.png)

## Testing TCB Quiz
![](https://assets.omscs.io/notes/DFED8BC1-EB62-44EB-A00D-06864E69B0AE.png)

## Testing TCB Quiz Solution
![](https://assets.omscs.io/notes/5F87B5BC-DB54-413C-8348-BF6973C787F5.png)

Testing can't show the absence of problems.

## Model Checking Quiz
![](https://assets.omscs.io/notes/1DD38815-AC14-4050-8BE4-CD4B6545DE3B.png)

## Model Checking Quiz Solution
![](https://assets.omscs.io/notes/B90F59EF-3CF9-42B6-BC7C-6237B4AB68B2.png)

## Security Evaluations: The Orange Book
Many people are faced with the problem of trying to evaluate the level of security present in a system.

The Department of Defense created the [Trusted Computer System Evaluation Criteria](https://en.wikipedia.org/wiki/Trusted_Computer_System_Evaluation_Criteria) to address this problem.

This document defines a ranking of system security using the following divisions (letters) and classes (numbers).

```bash
D < C1 < C2 < B1 < B2 < B3 < A1
```

Division D is reserved for systems that do not meet the requirements for a higher division.

A system has to implement authentication and discretionary access control to be considered for division C. A system must implement mandatory access control to be considered for division B. A system must be formally verified via mathematical techniques to be considered for division A.

Most commercial systems have been evaluated at C1, C2, or B1.

In order to advance to B2, a system needs to demonstrate a proof of correctness for the underlying security model and provide a narrative specification for the TCB.

A system that provides a formal verification of TCB correctness is a candidate for B3/A1.

## Security Evaluations: Common Criteria
After time, multiple countries began to recognize the importance of security evaluation, and TCSEC was replaced by an international standard which combined US, Canadian and European efforts: the [Common Criteria](https://en.wikipedia.org/wiki/Common_Criteria).

The idea is that as a consumer of a system, users specify what security they want to see in their software. Vendors implement  these requirements and make claims about their solution meeting users' needs. The evaluator determines if the claims that are made match the specifications.

The **evaluation assurance level** (EAL) rates the trustworthiness of the system. EAL1 is the most basic rating and EAL7 is the most rigorous.

## TCSEC Divisions Quiz
![](https://assets.omscs.io/notes/812B3058-CB14-4745-9085-7D918AD2AE0F.png)

## TCSEC Divisions Quiz Solution
![](https://assets.omscs.io/notes/472F8C5A-752D-4F31-B25E-1AB70F353DDF.png)

## Earning an EAL4 Certification Quiz
![](https://assets.omscs.io/notes/1BD7FA8D-A4A3-420D-B034-5DE4ACFF0305.png)

## Earning an EAL4 Certification Quiz Solution
![](https://assets.omscs.io/notes/54D03A5C-FF37-40C9-A359-3F2B765910B4.png)

## Cost Benefit Certification Tradeoffs Quiz
![](https://assets.omscs.io/notes/0DB30C2E-0FDD-438F-8532-4B6CC06E7977.png)

## Cost Benefit Certification Tradeoffs Quiz Solution
![](https://assets.omscs.io/notes/FC3F201F-6A8B-4E3B-9725-E8128B9719E5.png)
