---
id: secure-computer-systems-12-distributed-systems-2
title: Distributed Systems, Secure Boot, Delegation, Decentralized Trust
course: secure-computer-systems
lecture: 12-distributed-systems-2
---

# Secure Boot, Delegation, Decentralized Trust

Users delegate to machines that act on their behalf. 

A credential is a statement that we can verify to be true.

Because the user doesn't have a trusted path to the computer we have to have things speaking on behalf of other things.

We need to set up a secure communication channel between nodes.

## A Single Node

The machine hardware is denoted $M$. $M$ is running an operating system (i.e. Linux). The machine and the operating system together constitute a node.

A principal N might be in a role. For example, *N as manager* means that N is taking on the role of a manager, the **as** operator is for roles. The role can limit authority because it only lets you do a subset of the things you could otherwise do. 

The machine $M$ could be many different things, but when it runs $M$ as Linux then it is restricted to whatever Linux can do. So a node N is then $M$ as OS.

### Secure Loading

We have established that

$$N \equiv M \text{ as } OS$$

When we run a program P with digest D that makes a request s:

$$s \equiv N \text{ as } D \equiv M \text{ as } OS \text{ as } D$$

If the process running a secure program P with digest D is $P_r$ then the credential of $P_r$ is $M \text{ as } OS \text{ as } D$. The credential is just a claim that we can believe about who the process can speak for.

### Attestation

One way of ensuring secure loading is to make the assumption that the file system is secure. Since we get the program from the file system the program is trusted. This transfers the problem to ensuring that the file system is actually secure.

If we have an untrusted file system then we can use a known digest of the program to verify that the program is what it should be. We have seen this before and it is called attestation.

If P is the OS then secure loading is also known as **secure booting**. Since we have securely booted then we have a credential, $M$ as OS.

This OS can load one or more programs, which it may also securely load.

## Secure Boot Details

Machine M is the base case for authentication, if we can't trust M then we can't trust anything else in the machine.

We assume that M comes with keys $K_m^{-1}, K_m$ and a certificate $K_{CA}$ says $K_m \implies M$. The certificate is signed by the private key of the trusted certificate authority. We need to make sure that M is a globally unique identifier like a manufacturer serial number.

Is it practical to assume this? The Trust Policy Module (TPM) was supposed to have such a certificate. Generally the assumptions we are making here aren't entirely realistic for most machines.

M really is the initial code that gets executed when a machine is first powered on, like BIOS.

### More Details

We want it so that M only loads a trusted OS, the TPM or boot ROM can store the OS digest and perform attestation.

As part of the boot process we create a new certificate for the node. We make keys $(K_n, K_n^{-1})$ and have a certificate saying that $K_n \implies M \text{ as } OS$. We trust this certificate because it is signed by the machine which is trusted because it has a certificate from the CA. M is going to protect $K_m^{-1}$ even from the operating system which is why we use $K_n$.

Once the OS is secured then we can perform user authentication and these users will launch processes that run on their behalf, and we can use attestation to make sure the processes running are the correct ones.

## Delegation

When a user U logs into a node, the node itself (M as OS) does not become the user U. What we want is that the node can launch programs that can act on behalf of the user U, not that the node can become the user.

This is delegation. U delegates authority for M as OS to assert that a process P runs on behalf of U. 

This is different than "speaks for". If $N$ speaks for $U$ then $N$ can speak unconditionally on $U$'s behalf. If we do not want $N$ to become as powerful as $U$ then we use delegation. Delegation transfers limited authority.

### What is Delegation?

Delegation from A to B results in a new principal:

$$B \text{ for } A$$

Delegation is established in two steps:

* 1. A delegates to B:
  * $A \text{ says } B |A \implies B \text{ for } A$
* 2. B accepts delegation:
  * $B|A \text{ says } B|A \implies B \text{ for } A$

This results in: $B|A \implies B \text{ for } A$. Delegation allows user login.

## Delegation and Login

### Logging In

We use many assumptions to demonstrate the security of our system. Let's list them:

* A user U has a certificate $K_{CA}$ says $K_U \implies U$
* U has a private key $K_U^{-1}$ which is used for login (something you know)
  * $K_U^{-1}$ is provided to the OS for a short time
* Login results in delegation from U to the node N ($M$ as OS)
  * (1) U delegates: $K_U$ says $(K_N \wedge K_L) | K_U \implies K_N \text{ for } K_U$
    * $K_L$ is a session key that is used to limit the lifetime of $K_N$. If we ignore $K_L$ then this is just the delegation protocol previously discussed. $K_L$ says $K_N \implies K_L$ and expires after a short timeout period.
  * (2) Node N accepts delegation by saying$(K_N \wedge K_L) | K_U \implies K_N \text{ for } K_U$

These statements lead to $K_N | K_U \implies K_N \text{ for } K_U$.

This lets the node make requests saying they come from $K_N$ for $K_U$.

### Launching User Processes

When the user logs in with their private key the OS has statements signed with this private key. These signed statements provide evidence that U is logged in.

The OS is securely booted and has some program you would like to run. It will make requests that come from $M$ as $OS$ as $P$ ($P$ is the program) for $K_U$.

Credentials used to establish the communication are either pushed (sent from the client) or pulled (requested by the server).

## Request/Grant Example

Here are some things we have discussed so far:

* We know what machine a request is coming from.
  * This is because the machine has some certificate that tells us in a trusted manner that the machine is $M$ (this is a reference to a serial number or identifier) and this certificate says $K_M$ speaks for $M$.
* We know the machine is running an operating system that is booted in a secure fashion.
* We know that a user is logged in using our delegation protocol.
* We perform attestation on any user application so we know that the application is who it claims to be.
* The channel is secure because of key exchange.

### The full picture

We have a machine that has securely booted an OS that is running an accounting application that is used by an authenticated user. This application will send a request over the network channel, which is really the secure channel we have built. This request is responded to by the server which is also running a secure OS. 

The accounting application makes a request of the form:

$$M \text{ as } OS \text{ as Accounting App for User}$$

And the file service on the server will have an ACL that permits such access.

![](https://assets.omscs.io/secure-computer-systems/images/module12/the-full-picture.png)



### Q&A

Here are some questions you might ask about the security, along with the work we have done so far to answer the questions:

* Who is the requesting user?
  * Delegation gives us statements that are sent to the server establishing the user's identity
* Is the application legitimate or compromised?
  * If we trust the OS we can assume the application is legitimate through attestation
* Is the OS trusted?
  * Yes if we do secure boot
* Is the hardware who it claims to be?
  * Yes if the certificate it has is from a trusted CA
* Is the communication channel secure?
  * Yes, key exchange

We can also ask questions about the server's OS and services, which are answered in the same manner as for the client.

## Putting it all together

### Secure File Access

Assume we have some sensitive file called "Budget". We might have an access control rule:

*SRC-Node as Accounting as bwl-user can read Budget*

The security policy will say who can be SRC-Node, this policy is set by someone trusted. Part of this security policy is 

M as OS $\implies$ SRC-Node.

### Convincing the Server to Return File Budget

We need to extend the chain of trust from a certificate authority to the machine - 

$K_{CA}$ says $K_M \implies M$

Extend trust from machine to OS, the machine trusts the OS because of secure boot - 

$K_M$ says $K_N \implies$ M as OS 

$K_N$ is used as the public key when making a secure communication channel C with the server.

After all of this work we get C $\implies$ M as OS.

When a user logs in we get: N | bwl-user $\implies$ M as OS for bwl-user. When running our accounting application the credential will be M as OS as Accounting for bwl-user. This process sends "read-budget" over the secure channel to the server.

### Credential Processing at the Server

The server's ACL is given previously as 

*SRC-Node as Accounting as bwl-user can read Budget*

The various statements made in the preceding sections are all sent to the server (pushed) or the server can request (pull) the statements. Some calculations using our axioms allow for a proof that the request should be granted.

### Intuition

Here is a diagram that summarizes how everything fits together.

![](https://assets.omscs.io/secure-computer-systems/images/module12/intuition.png)


### Observations

Let's revisit and summarize some of the components of our secure architecture.

* To set up a secure channel we use Diffie-Hellman key exchange.
* The Machine $M$ has a certificate signed by the CA. This machine is the root of all trust.
  * This is not a reasonable assumption in the real world. 
* Secure boot transfers trust to the OS
  * In practice we might do this but as we make updates then the digest must be changed and doing this securely introduces some of its own problems
* Delegation during login lets the server know that the node has a logged in user.
  * We assumed users have certificates, this is not realistic in practice. Usually we have passwords or 2-FA.

You should be convinced that our architecture is a good way to build things but understand where its limits are. 
* Public key infrastructure does not extend to all users on the internet, so there are not certificates for users.
* Machines don't necessarily come with a certificate of trust.

## Threat Modeling and Security Analysis

**Network attacks** like man-in-the-middle are not possible because we set up a secure communication channel. The nodes have certificates and do a key exchange.

If someone gives you bad certificates and you accept it, then you are vulnerable to man in the middle attacks.

**Theft of user private key** is another threat. But, the attacker needs the correct machine $M$ to access the application because of how the ACL is set up.

We are protected from a **trojan accounting application** by using attestation. For the same reason the machine **will not load a compromised operating system**.

But, if the OS is compromised **after** it is booted then we are in big trouble. Trojan applications can be loaded and user private keys can be leaked.

## SGX and Distributed Trust

The SGX enclave can manipulate sensitive data that is protected from non-privileged and privileged software. 

Suppose we want an application to run in an enclave on a remote platform (i.e. the cloud). We don't want to have to trust the software stack, but we must trust the hardware stack. 

We verify that the enclave code is correct through remote attestation and we have secure authenticated channels for the exchange of sensitive data.

### Diagram

Our client application has the enclave which communicates to the service provider over an authenticated secure channel. The client also must somehow communicate with the attestation service for attestation.

![](https://assets.omscs.io/secure-computer-systems/images/module12/enclave.png)

### Certificates and Keys

We have seen that the service provider is a principal that holds sensitive data that is sent to the client application. The software in the enclave (like our accounting application) is written by an **independent software vendor (ISV)**.

The ISV has a certificate given by a trusted CA. The ISV certificate, CA says $K_\text{ISV} \implies$ ISV.

The **Intel Attestation Service (IAS)** receives the certificate from ISV and issues a service provider ID (SPID). The software in the enclave can now communicate with the service provider.

The attestation service has a certificate for communication with the service provider. The attestation service will use the root seal key to sign its root provisioning key.

* **Root seal key**: When Intel ships a machine they create a root seal key which is made during manufacturing and is not retained by Intel, think of this like $K_M$ that we discussed in the verification of hardware. 
* **Root provisioning key**: The provisioning key signs the certificate that says the root seal key is the key for the processor. The enclave has a certificate of its own.

**Enclave certificate** comes from the ISV, we must trust the key for the ISV.

### Outline of Remote Attestation Scheme

Diffie-Hellman key exchange is used to exchange keys from the client and server. Both the enclave and the service provider have public keys and certificates so the communication can be secure.

The client hardware can make a digest of the enclave for attestation. This digest is sent to the service provider, who sends it to the Intel Attestation Service (IAS).  Intel has worked with the software vendors to get the knowledge it needs to verify the digest using the IAS. After verification we feel confident in sending sensitive data to the enclave.







