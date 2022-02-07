---
id: information-security-midterm-1-study-guide
title: Midterm 1 Study Guide
course: information-security
lecture: midterm-1-study-guide
---

# Midterm 1 Study Guide

## DAC

Which Type of control is based on the identity of the requestor and the access rules state what a requestor can or cannot do?

- A) Mandatory Access Control (MAC)
- B) Role-based access control (RBAC)
- C) Discretionary access control (DAC)
- D)Attribute-based access control (ABAC)

<details>
<summary>Answer</summary>
C. This policy is termed discretionary because an entity might have access rights that permit the entity, by its own volition, to enable another entity to access some resource.

Source: Book Chapter 4.2 Page 131
</details>



What data structure is typically used to implement DAC?

- A) Linked List
- B) 2 Dimensional Matrix
- C) Red Black Tree
- D) Stack

<details>
<summary>Answer</summary> B

Source: Book Chapter 4.3 Page 111
</details>



Access Control Lists make it easy to look up who all the users are that can access a resource, and the type of access they have for that resource.

True or False?

<details>
<summary>Answer</summary>  True

Source: Book Chapter 4.3 Page 111
</details>



Question: What does each entry of an access matrix indicate?

- A. Access rights of a particular object for a particular subject.
- B. Access rights of a particular subject for a particular object.
- C. Access rights of a particular subject for a particular directory.
- D. Access rights of a particular object for a particular group.

<details>
<summary>Answer</summary>  B.

Source: Book pg. 111
</details>



(True/False) DAC is a concept that evolved out of requirements for military information security.

<details>
<summary>Answer</summary>  False, DAC is the traditional method for implementing access control, MAC was created out of military necessity.

Source: Book, Ch 4, Pg. 109
</details>



(True/False) One problem with DAC is that it is not possible to control information flow.

<details>
<summary>Answer</summary>  True

Source: Mandatory Access Control Lecture
</details>



(True/False) DAC is popular with corporations because it reflects how they treat their data.

<details>
<summary>Answer</summary>  False. Employers mandate explicit policies on who can share what.

Source: Mandatory Access Control Lecture
</details>

## Program/Host Privileges -- Program control flow

Put the following statements, regarding the sequence of calls made made by a function call to the stack, in the correct order:

- A. Allocate space for local variables by moving the stack pointer down to leave sufficient room for them.
- B. Push the parameters for the called function onto the stack.
- C. Run the body of the called function.
- D. Execute the return function which pops the saved address off the stack and returns control to the calling function.
- E. Push the current frame pointer value (which points to the calling routine's stack frame) onto the stack.
- F. Executes the call instruction to call the target function, which pushes the return address onto the stack.
- G. Pops the old frame pointer value (restoring the link to the calling routine's stack frame).
- H. Sets the frame pointer to be the current stack pointer value, which now identifies the new stack frame location for the called function.
- I. Set the stack pointer back to the value of the frame pointer.

<details>
<summary>Answer</summary>
B, F, E, H, A, C, I, G, D

From text pg 327.
</details>

## Access control mechanisms

An access control mechanism mediates between a user (or a process executing on behalf of a user) and system resources, such as:

- a) firewalls
- b) routers
- c) applications
- d) a & b only
- f) All of the above

<details>
<summary>Answer</summary>
f) All of the above

Textbook, Chapter 4, pg. 108
</details>



Which of the following is granting permission to a system entity to access a system resource?

- A) Authentication
- B) Authorization
- C) Audit
- D) Allowance
- E) None of the Above

<details>
<summary>Answer</summary>  B, Authorization determines who is trusted for a given purpose
Source: Book Chapter 4.1 Page 130
</details>



Question: Access control implements a security policy that verifies the credentials of a user. True or false?

<details>
<summary>Answer</summary>  False. Access control implements a security policy that specifies who or what may have access to each specific system resource, and the type of access that is permitted in each instance.

Source: Book pg. 107
</details>

## MAC

Under Mandatory Access Control(MAC), what two properties provide confidentiality:

<details>
<summary>Answer</summary>
1. No read up: A subject can only read an object of less or equal security level
2. No write down: A subject can only write into an object of greater or equal
security level.

Source: Book Chapter 27 Page 27-4
</details>



Question: A subject is said to have a security clearance of a given level and an object is said to
have a security classification of a given level.

<details>
<summary>Answer</summary>  True

Source: Book Chapter 27 Page 27-4
</details>



For the Bell-Lapadula Model (BLP), the properties needed for the confidentiality form of MAC are:

1. ds-property and \*-property
2. ss-property and \*-property
3. ss-property and ds-property
4. None of the above

<details>
<summary>Answer</summary>  2. (Chapter 27.1)

ss-property (simple security property: no read up
\*-property (star property): no write down

The ds-property is a provision made by BLP for DAC but must be consistent with MAC rules.
</details>



Other MAC models such as Bell and La Padua(BLP Model) is focused on Integrity, and BIBA model is focused on Confidentiality.

<details>
<summary>Answer</summary>  False. BLP focuses on Confidentiality and BIBA focuses on Integrity.

Source: P1:L6 MAC slides | Other MAC models
</details>



Examples of BLP model classfications are High, Medium, and Low.

<details>
<summary>Answer</summary>  False. Examples are Top Secret, Secret, Confidential.

Source: P1:L6 MAC slides | Other MAC models
</details>



MAC cannot be employed with other access control policies, such as DAC, RBAC, and ABAC.

<details>
<summary>Answer</summary>  False. All four access policies (DAC, MAC, RBAC, and ABAC) are not mutually exclusive.

Source: Book, Ch. 4, Pg. 109
</details>

## RBAC

In the context of Role-Based Access Control Models, What does RBAC2 provide?
<details>
<summary>Answer</summary>  Constraints, mutually exclusive roles, Cardinality

Source: Book Pages 147-148
</details>



______ is based on the roles that users assume in a system rather than a user's identity.

- A. DAC
- B. MAC
- C. RBAC
- D. ABAC

<details>
<summary>Answer</summary>  C

Source: Book pg. 120
</details>



What kind of relationship is a role to a user in RBAC?

- A) 1 to 1
- B) 1 to Many
- C) Many to 1
- D) Many to Many

<details>
<summary>Answer</summary>  D, a role can have many users. a user can have many roles.
Source: Book Chapter 4.5 Page 146
</details>



What aspect of an established RBAC system is likely to change infrequently?

- A) The set of resources and the specific access rights associated with a particular role.
- B) The set of roles in the system.
- C) The set of users.
- D) A & B
- E) None of the above.

<details>
<summary>Answer</summary>  D

Source: Book. Ch 4, Pg 120
</details>



The RBAC prerequisite role can be used for the following:

- A) A way to increase the difficulty of collusion among individuals of different skills or divergent job functions to thwart security policies.
- B) For structuring the implementation of the least privilege concept.
- C) As a risk mitigation technique for a sensitive or powerful permission.
- D) None of the above

<details>
<summary>Answer</summary>  B.

Source: Book, Ch 4, Pg 125
</details>

## ABAC

Question: What are the 3 attributes of ABAC model?

<details>
<summary>Answer</summary>

- a) Subject - active entity: user, application, process, device
- b) Object - passive entity: file, record, network, domain
- c) Environment: date/time, virus activity, network's security level

Source: book p. 127https://www.proprofs.com/quiz-school/story.php?title=mr-f-quiz-network
</details>



Question: How does ABAC model controls access?

<details>
<summary>Answer</summary>  ABAC evaluates attributes of subject/object and access control rule defining allowable operation in a given environment

Source: book p. 127
</details>



In the Attribute-Based Access Control (ABAC) model: current date and time, the current virus/hacker activities, and the network's security level are known as ____

- A) Object attributes
- B) Subjects attributes
- C) Environment attributes
- D) Access Right
- E) None of the Above

<details>
<summary>Answer</summary>  C. environments describe the operational, technical, and even situational environment or context in which the information access occurs

Source: Book Chapter 4.6 Page 149
</details>



In a(n) _____ model, authorizations can be defined that express conditions on properties of both the resource and the subject.

- A. DAC
- B. MAC
- C. RBAC
- D. ABAC

<details>
<summary>Answer</summary>  D

Source: Book pg. 126
</details>



The strength of the ABAC approach is its ________ and ________.

- A. strictness, performance
- B. flexibility, expressive power
- C. extensibility, ease of use
- D. None of the above

<details>
<summary>Answer</summary>  B

Source: Book pg. 126
</details>

## Database and Data Center (Understanding of Inference)

Question: _____is the process of performing authorized queries and deducing unauthorized information from the legitimate response received.

<details>
<summary>Answer</summary>  Inference

Source: book p.166
</details>



Question: What are the approaches to deal with inference attack?
<details>
<summary>Answer</summary>

- a) Inference detection during DB design: removing data dependencies, using more fine-grained access control roles in RBAC scheme
- b) Inference detection at query time: if inference channel is detected, the query is denied.

Source: book p.167
</details>



Question: A _______ can provide restricted access to a relational database so a user or application only has access to certain rows or columns.

- A. primary key
- B. view
- C. relation
- D. tuple

<details>
<summary>Answer</summary>  B

Source: Book pg. 153
</details>



Question: _______ is an attack that exploits a security vulnerability occurring in the database layer of an application (such as queries).

- A. Trojan horse
- B. Logic bomb
- C. SQLi
- D. Buffer overflow

<details>
<summary>Answer</summary>  C

Source: Book pg. 156
</details>



Question: Improper handling of user input can result in a SQL injection. True or false?

<details>
<summary>Answer</summary>  True. The attack is viable when user input is either incorrectly filtered for string literal escape characters embedded in SQL statements OR user input is not strongly typed.

Source: Book pg. 156
</details>



Question: SQLi attacks can be grouped into three main categories: _______, ________, and ______.

- A. parameterized, user input, blind injection
- B. second-order injection, out-of-band, parameterized
- C. inferential, blind injection, inband
- D. inband, inferential, out-of-band

<details>
<summary>Answer</summary>  D

Source: Book pg 158
</details>



Question: What are the main avenues of attack for SQL injection?

- A. Cookies
- B. Server variables
- C. User input
- D. Second-order injection
- E. Physical user input
- F. All of the above
- G. None of the above

<details>
<summary>Answer</summary>  F

Source: Book pg. 158
</details>



Question: Defensive coding is an effective way to dramatically reduce the threat from SQLi. True or false?

<details>
<summary>Answer</summary>  True

Source: Book pg. 160
</details>



Question: In a DBMS, what happens in the following scenario assuming each of these steps are followed sequentially? Assume the grant option is always used.

- Ann grants access right to Bob.
- Ann grants access right to Chris.
- Bob grants access right to David.
- David grants access right to Ellen.
- Chris grants access right to David.
- David grants access right to Frank.
- Ellen grants access right to Jim.
- Bob revokes access right from David.

- A.David no longer has the access right.
- B. David, Ellen, Frank, and Jim no longer have the access right.
- C. David, Ellen, and Jim no longer have the access right.
- D. Ellen and Jim no longer have the access right.

<details>
<summary>Answer</summary>  D. In most implementations, the revocation is cascaded. In this case, since Chris also granted access to David, then David won't have his access revoked, but Ellen since her access was granted after Bob (and before Chris) had granted access to David. Frank's access remains since David granted access to him after Chris granted access to David.

In general terms, if the access right would exist anyway, then the revoke is not cascaded.

Source: Book pg. 163
</details>

## TCB (what it is, what it is comprised of, what it does)

The Trusted Computing Base or TCB has 3 main requirements which of the following is not a requirement.

- A.) Complete mediation between the OS and the hardware resources and applications. In addition the OS must make sure the application has the necessary authorizations.
- B.) The OS must be tamperproof.
- C.) The OS must must be able to go from user to kernel mode without errors
- D.) The OS must be correct and ensures that protected resources are used properly

<details>
<summary>Answer</summary> C

Lectures 2 OS and Security
</details>

## Injection attacks and how to defend them

Question: _____attack occurs when user input is incorrectly filtered for string escape characters or user input is not strongly typed.

<details>
<summary>Answer</summary>  SQLi

Source: book p.156
</details>



Question: Illegal/logically incorrect queries return often overly descriptive errors from the application server and allow an attacker to gather important information about the server. This is part of what type of attack?

<details>
<summary>Answer</summary>  inferential attack

Source: book p.159
</details>



Question: Which of the following are proper measures to defend against SQLi attacks?

- a) user input validation
- b) parameterized query insertion
- c) SQL DOM
- d) a and b
- e) All of the above

<details>
<summary>Answer</summary>  e)

Source: book p.160
</details>



Which of the following Detection methods to prevent SQLi attacks define a training phase to learn normal behavior?

- A) Anomaly-based
- B) Signature-based
- C) Code analysis
- D) None of the above

<details>
<summary>Answer</summary>  A. Anamoly based attempts to define normal behavior then detect behavior patterns outside the normal range.

Source: Book Chapter 5.4 Page 182
</details>

## Viruses: Their types and what they do

There are _________ generations of antivirus software.

- A.     Two
- B.     Three
- C.     Four
- D.     Five

<details>
<summary>Answer</summary>  C

From: https://www.proprofs.com/quiz-school/story.php?title=mr-f-quiz-network
</details>



A __________ virus is a virus that mutates with every infection, making detection by the "signature" of the virus impossible.

- A.    Metamorphic
- B.    Encrypted
- C.    Polymorphic
- D.    Stealth

<details>
<summary>Answer</summary>  C

From: https://www.proprofs.com/quiz-school/story.php?title=mr-f-quiz-network
</details>



Which of the following viruses are classified by concealment?

- A) Macro Virus
- B) Encrypted Virus
- C) Polymorphic Virus
- D) Metamorphic Virus
- E) B, C, D
- F) All of the above

<details>
<summary>Answer</summary>  E. viruses in B,C,D fit this description. Macro viruses are classified by Target rather than concealment

Source: Book Chapter 6.3 Page 215
</details>



Which phase does a virus place a copy of itself into other programs?

- A) Dormant Phase
- B) Propagation Phase
- C) Triggering Phase
- D) Execution Phase

<details>
<summary>Answer</summary>  B

Source: Book Chapter 6.3 Page 211
</details>



Which type of document is not known to carry macro viruses?

- A. Microsoft Word Document
- B. Plain Text File
- C. Adobe PDF File
- D. Microsoft Excel File

<details>
<summary>Answer</summary>  B

Source: page 212 Chapter 6.3
</details>



Macro Viruses will manipulate, call functions on the host document's content only.

True/False?

<details>
<summary>Answer</summary>  False

Source: page 213 Chapter 6.3. Their ability to interact with other parts of the system is demonstrated by the "Melissa" macro virus, which uses a Windows system registry to keep track of infection status.
</details>



Metamorphic Viruses are harder to detect than Polymorphic Viruses.

True/False?

<details>
<summary>Answer</summary>  True

Source: page 215 Chapter 6.3. Also https://searchsecurity.techtarget.com/definition/Metamorphic-virus
</details>

## Access Control lists

Question: Access Control Lists may have default entry that should always follow the rule of least privilege. True/False?

<details>
<summary>Answer</summary>  True

Source: book p.111
</details>

Question: Each element of the Access Control List contains the following:

- A.) Permitted Access Rights
- B.) Users
- C.) All of the Above
- D.) Capability Tickets
- E.) All of the above

<details>
<summary>Answer</summary>  C

Page 111
</details>



The columns of an Access Control Matrix are Access Control Lists.

<details>
<summary>Answer</summary>  True. The matrix may be decomposed by columns, yielding
access control lists (ACLs) (see Figure 4.2b). Decomposition by rows yields capability lists (see Figure 4.2c).

Source: Book chapter 4.3 page 133
</details>



Most of the operating systems use _____. In addition to this ____ is more efficient for finding access rights

- A.) ACLs & C-List
- B.) TCB & Chmod
- C.) Revocation & ACL
- D.) C-List & ACLs

<details>
<summary>Answer</summary>  A

Source: Lecture 5 notes
</details>

## Project 1

Name: Chris Taylor

Question: The _________ contains the base address of data stored within the stack for the current procedure.

<details>
<summary>Answer</summary>  EBP Register

Source: Quite possibly on the exam
</details>



Which of the following functions can lead to a buffer overflow vulnerability:

- A.) gets() & fgets()
- B.) gets() & strcpy()
- C.) main() & gets()
- D.) strncpy() & gets()

<details>
<summary>Answer</summary> B
</details>



Both the stack and heap grow up in memory address space. (True/False)

<details>
<summary>Answer</summary>  False. The stack grows down in memory while the heap grows up.
</details>



What data structure is implemented in heap memory?

- A. Chunk
- B. Pointer
- C. Frame
- D. Buffer

<details>
<summary>Answer</summary>  A
</details>



An attacker exploits a program and launches a shell. With which privilege level are the instructions executed?

- A. User
- B. Root
- C. System
- D. Host Program

<details>
<summary>Answer</summary>  D. The attacker's shellcode is run with the privileges of the exploited program. Source: L2 "Shellcode Privileges"
</details>



Which of the following does not get stored in a stack?

- A) return address
- B) local variables
- C) arguments
- D) global Variables
- E) Meta Data
- F) base pointer
- G) D,E
- H) E,F
- I) D,E,F

<details>
<summary>Answer</summary>  G. Global Variables are stored in the data segment in memory. Meta Data is stored with allocated chunks of a heap.

Source: https://www.geeksforgeeks.org/memory-layout-of-c-program
</details>

## Unix File access control

What are the 3 main types of subject/principals in unix?
<details>
<summary>Answer</summary>
user, group, world/other
</details>



What are the "classic" 3 permissions afforded to the subjects in unix-like?

Read (r), Write(w), Execute(x)




A user (U) can run with the permission of the file creator (C) under what condition(s)?

- a) U has execute privileges
- b) C has read, write, and execute permissions
- c) Set User ID
- d) Set Group ID
- e) a nd c
- f) all of the above

<details>
<summary>Answer</summary>  E
</details>



What contents exist inside of a file's inode?

<details>
<summary>Answer</summary>
Owner ID, Group ID and 12 protection bits
</details>



What is an inode (index node)?

- A.) An inode is part of a linked list design for memory storage
- B.) An inode is a special directory only to bee seen by root
- C.)An inode is a control structure that contains information needed by the OS for a file.
- D.) An inode is a user permission for a given user group.

<details>
<summary>Answer</summary>  C

Page 117
</details>



True or False: An inode contains all information about a file?
<details>
<summary>Answer</summary>
False

inode's don't contain the file name and actual data
Source: Internet
</details>

## Role hierarchy

Question: The concept of inheritance enables one role to implicitly include access rights associated with a subordinate role. What role-based access control makes use of this concept?

<details>
<summary>Answer</summary>  Role hierarchy

Source: book p.124
</details>

## Security and IoT

Question:
______interconnects IoT devices with higher-level networks, translates protocols, and may perform basic data aggregation function.

<details>
<summary>Answer</summary>  Gateway

Source: book p.446
</details>



Typically gateways implement secure functions what are the two common security mechanisms:

- A.) IPsec and Firewalls
- B.) TLS and IPsec
- C.) Checksums and CRC Mechanisms
- D.) Canary Values and ASLR mechanisms

<details>
<summary>Answer</summary>  B

Page 448
</details>



Which of the following is NOT key component in IOT enabled devices

- A)Actuator
- B)Sensor
- C)Microcontroller
- D)Transceiver
- E)Back Bone network
- F)Radio-frequency Identification (RFID)

<details>
<summary>Answer</summary>  E. backbone network connects geographically dispersed fog networks as well as provides access to other networks that are not part of the enterprise network.

Source: Book Chapter 13.4 Page 466-467
</details>



Which of the following are NOT a typical use case for botnets?

- A) Spamming
- B) DDos attacks
- C) Spear phishing
- D) Sniffing traffic

<details>
<summary>Answer</summary>  C. Spear phishing is a targeted attack whereas botnets are typically used as a swarm to work in concert to perform their attacks.

Source: Book P207
</details>

## Malwares

Which Malware was the first of a new generation that included aspects of virus, worm and trojan in one package.

- a) Morris worm
- b) Melissa e-mail worm
- c) Cod Red worm
- d)WannaCry ransomware

<details>
<summary>Answer</summary>  b

global edition pg. 219 chapter 6, Malicious software
</details>



What type of Malware is Easter egg?

- a) Virus
- b)Worm
- c)Trojan
- d)Trapdoor

<details>
<summary>Answer</summary>  d

Malicious Code slides
</details>



What is software the collects information form a computer and transmits it to another system monitoring keystrokes, network traffic and other screen data?

- A.) Spammer Programs
- B.) Keylogger
- C.) Spyware
- D.) Trojan Horse

<details>
<summary>Answer</summary> C.)

Page 185
</details>



Which type of malware is a program installed on an infected machine that is activated to launch attacks on other machines?

- A) Virus
- B) Trojan
- C) Worm
- D) Bot
- E) Root Kit

<details>
<summary>Answer</summary>  D

Source: Book Chapter 6.1 Page 207
</details>



Which of the following properties are not commonly found in both Viruses and Worms?

- A. Dormant, Propagation, Triggering, and Execution phases
- B. May attempt to determine if a system has been previously infected
- C. Requires a host program to run
- D. Can be polymorphic to evade detection

<details>
<summary>Answer</summary>  C

Source Page 222 Chapter 6.4
</details>

## Threats, attacks, and assets

Question:
Communication links, bridges, and routers are considered as assets to protect.

- a) True
- b) False

<details>
<summary>Answer</summary>  a) True

Source: book p.7
</details>



Passive network attacks are difficult to detect but can be prevented ; Active network attacks are difficult to prevent altogether but can be detected.

- a) True
- b) False

<details>
<summary>Answer</summary>  a) True

Source: book p.15
</details>



According to RFC 4949 there are four kinds of threats which threat consequence is not part of RFC 4949?

- A.) Unauthorized Disclosure
- B.) Deception
- C.) Usurpation
- D.) Corruption

<details>
<summary>Answer</summary> D. corruption is a type of disruption where disruption is a threat consequence and and corruption is the threat attack.

Page 9
</details>



If a hospital worker changes a patient's file without the patient's knowledge. Then they have broken ____

- A) Confidentiality
- B) Integrity
- C) Availability
- D) Accountability

<details>
<summary>Answer</summary>  B, Integrity: Guarding against improper information modification or destruction, including ensuring information nonrepudiation and authenticity.

Source: Book Page 25
</details>



____________, a design principle for secure systems, states that security measures can not be bypassed.

- A) Least Privilege
- B) Fail-Safe Defaults
- C) Economy of Mechanism
- D) Open Design
- E) Complete Mediation
- F) Psychological Acceptability

<details>
<summary>Answer</summary>  E) Complete Mediation - no one should be able to bypass security measures. "Every access to every object is checked" (Schneider).

Source: Lecture 1 "How Do We Address Cyber Security?"
Schneider, Fred. http://www.cs.cornell.edu/courses/cs513/2005fa/NL02.html
</details>

## Cloud service models

Question:
____is not part of cloud service model (according to NIST SP 800-145).

- a) Software-as-a-Service
- b) Platform-as-a-Service
- c) Code-as-a-Service
- d) Infrastructure-as-a-Service

<details>
<summary>Answer</summary>  c) Code-as-a-Service

Source: book p.426
</details>



Question:
In which cloud service model cloud service user has control over OS, deployed applications, and possibly limited control of select networking components?

<details>
<summary>Answer</summary>  Infrastructure-as-a-Service

Source: book p.426
</details>



A cloud broker can offer three areas of support. Which of the following is not an area of support?

- A.) Service Intermediation
- B.) Service aggregation
- C.) Service arbitrage
- D.) Service Auditor

<details>
<summary>Answer</summary>D. A service auditor is incorrect you might be thinking of cloud auditor if you picked this (a cloud auditor evaluates the services by the cloud service provider in terms of security controls, privacy impact and such)

Page 431
</details>



The typical cloud deployment models include which of the following?

- A) Public, Private, Hybrid, Community
- B) Public, Private, PaaS, SaaS
- C) PaaS, SaaS, Hybrid, Community
- D) IaaS, On-prem, Saas, PaaS

<details>
<summary>Answer</summary>  A, IaaS, PaaS, SaaS are cloud service models, not deployment models
</details>

## Means of authentication

Question:
What is the initial requirement for performing user authentication?

- A.) User must be registered within the system.
- B.) A token must be verified
- C.) A digital signature needs to e authenticated
- D.) A multi factor system has to be in place

<details>
<summary>Answer</summary>  A

Page 65
</details>



What are examples of static vs dynamic biometric recognition?

- A.) Dynamic biometric could be a fingerprint and Static could be a voice pattern
- B.) Dynamic can be face recognition and static could be fingerprint
- C.) Dynamic is when you have an electronic keycard and static is a fingerprint
- D.) Static biometric is a fingerprint and dynamic biometric is a voice pattern

<details>
<summary>Answer</summary>  D

Page 66
</details>



The means for authenticating a user can be summarized in general terms by four things. What are the four things?

- A.) Something the user knows, possesses, is and does.
- B.) Something the user knows, possesses, is and wants
- C.) Something the user can see, knows, wants and doesn't have
- D.) something the user knows, is, wants and does

<details>
<summary>Answer</summary>  A

Page 66
</details>



Question:
Bad person Eve walks up to the system and says she is Alice, and successfully logs in as Alice. This authentication outcome is a:

- A.) False negative
- B.) False positive

<details>
<summary>Answer</summary>  B

P1:L4 Authentication (Authentication Goals video slide)
</details>



Question: In order to increase the difficulty of an offline dictionary attack, a salt can be combined with a password before hashing. True or false?

<details>
<summary>Answer</summary>  True. For a salt of length b bits, the number of possible passwords is increased by a factor of 2^b

Source: Book pg. 72
</details>



Question: Which of the following is NOT a vulnerability of passwords?

- A. Offline dictionary attack
- B. Specific account attack
- C. Workstation hijacking
- D. Electronic monitoring
- E. None of the above

<details>
<summary>Answer</summary>  E. Additionally there is popular password attack, password guessing against single user, exploiting user mistakes, and exploiting multiple password use.

pg 71
</details>



Question: When an applicant applies to a registration authority (RA) to become a subscriber of a credential service provider (CSP), the RA is responsible for issuing an electronic credential. True or false?

<details>
<summary>Answer</summary>  False. The CSP issues the electronic credential to the subscriber.

Source: Book pg. 65
</details>



Question: Which of the following is not a common physical characteristic used for biometric authentication?

- A. Fingerprints
- B. Hair color
- C. Voice
- D. Signature
- E. Iris
- F. All of the above
- G. None of the above

<details>
<summary>Answer</summary>  B. Facial characteristics are used, but that does not include a person's hair color.

Source: Book pg. 88
</details>



Question: What is the purpose of a nonce used in a challenge-response password protocol?

- A. Prevent the hash of the password from being transmitted directly.
- B. Eliminate need for host to store user's password.
- C. Defend against a replay attack.
- D. All of the above
- E. A & B
- F. B & C
- G. A & C
- H. None of the above.

<details>
<summary>Answer</summary>  G. The nonce is used in generating a hash which the client sends to the server. The nonce is also randomly generated at the start of the session, so if an attacker tried a replay attack, they have a different nonce and thus would fail.

Source: Book pg. 93-94
</details>



Question: Which of the following statements is false?

- A. Client attacks are when an adversary attempts to masquerade as a legitimate user.
- B. Host attacks are directed at the user file on the host where passwords, tokens, etc are stored.
- C. One form of eavesdropping refers to attempting to learn the password by observing the user.
- D. Reply attacks are when an attacker repeat a previously captured user response.
- E. A trojan horse attack is when an attacker when malicious hardware / software is used to log a user's keystrokes.
- F. A denial of service attack is when an attack disables user authentication service by flooding it with numerous authentication attempts.

<details>
<summary>Answer</summary>  E. In a trojan horse attack, an app or device masquerades as an authentic application or device for the purpose of capturing a user password, passcode, etc. Example: rogue bank machine used to capture user's card / PIN.

Source: Book pg. 97
</details>

## Assurance levels

Question:
____ is defined as the degree of confidence in the vetting process used to establish the identity of the individual to whom the credential was issued.

- a) Authorization
- b) Audit
- c) Authentication
- d) Assurance

<details>
<summary>Answer</summary>  d) Assurance

Source: Book p.68
</details>



Question:
In the areas of Risk assurance levels are classified on a system of numbers 1 through 4. Pick the appropriate option which describes these risks accordingly:

- A.) Assurance Level of 1 tells us that users level is appropriate to access restricted services of very high value, Level 2 let's users access documents and services which are of a high a value but no the highest, Level 3 is where the secure authentication protocol is needed so we know who is accessing what, Level 4 there is little to no authentication at this level there is o confidence in the asserted identity's validity.

- B.) Assurance Level 1-4 are all the same they all have some confidence in the asserted identity's validity. The main thing is that each level is based on the user's username for their organization.

- C.) Level 1 typical authentication is a user supplied ID and there isn't much confidence in the users identity. Level 2 there is some confidence this is typically the level where an authentication protocol is devised for users, Level 3 is a high confidence but not the highest level at this level we have access to some sensitive documents and programs and at Level 4 you have the highest confidence and the highest access.

- D.) None of the above

<details>
<summary>Answer</summary>  C

Page 68
</details>

## Rootkits

Question:
A ________ is a set of programs installed on a system to maintain covert access to that system with administrator or root privileges, while hiding evidence of its presence to the greatest extent possible

<details>
<summary>Answer</summary>  Rootkit

Source: Book Page 212
</details>



Question:
A rootkit can be classified into which of the following characteristics:

- A.) Persistent
- B.) Memory Based
- C.) User Mode
- D.)Kernel Mode
- E.) Virtual Machine based
- F.) External Mode
- G.) All of the above
- H.) Detection

<details>
<summary>Answer</summary> G (H is not part of the answer)

Source: Book page 312
</details>


Question:
A rootkit can be classified into _______ this is when the rootkit intercepts calls to APIs and modifies the returned results.

- A.) Memory based
- B.) User Mode
- C.) Kernel Mode
- D.) External mode

<details>
<summary>Answer</summary>  User Mode

Source Book page 212
</details>



Question:
What type of rootkit can not survive a reboot and why not?

- A.) Kernel Mode and because there is no user intervention
- B.)Persistent and because the firewall flushes the rootkit out
- C.) Memory based and there is no persistent code
- D.) External Mode and because it is located in the BIOS

<details>
<summary>Answer</summary> C
Page 212: The book says "Memory based rootkits have no persistent code and therefore can not survive a reboot"
</details>
