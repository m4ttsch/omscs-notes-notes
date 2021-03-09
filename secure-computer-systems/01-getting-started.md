---
id: secure-computer-systems-01-getting-started
title: Getting Started
course: secure-computer-systems
lecture: 01-getting-started
---

# Getting Started

## The Security Mindset and Operating Systems

The operating system is very complex, not only in size of the codebase, but also in terms of the responsibilities it has. This complexity makes it difficult to secure an operating system. 

This complexity attracts attackers. Attackers are also interested in the OS because a successful hack can give them access to do whatever they want with the machine.

## What is an OS

The OS makes it easier to build and deploy applications. It is hard to work with the physical resources of a machine. The operating system lets you work with virtual resources, abstractions on top of the physical resources. A file is a virtual resource that abstracts the disk.

![](https://assets.omscs.io/secure-computer-systems/images/module1/OS-HW.png)

The operating system has access to all the physical resources so that it can implement the virtual resources. Hackers would love access to all physical resources, so they target the OS.

## TCB \(Trusted Computing Base\) and Reference Monitor

The operating system is called the "Trusted Computing Base" because we trust it's security to protect physical resources.

### Reference Monitor

If you have a file with sensitive information you want to control or *monitor* attempts to access this resource. The thing that monitors attempts to reference a protected resource is called a **reference monitor**.

Any application that references/attempts to access a protected resource must be **monitored**. The Operating System is the reference monitor because it monitors access to physical resources.

### TCB Requirements

There are 3 requirements our TCB must meet in order to be our reference monitor.

* **tamper proof:** Untrusted code cannot alter the operation of the TCB \(i.e. to do something malicious\). There is a special interface called **system calls** for interacting with the TCB, these calls do not allow untrusted code to modify code, memory, or data from where the TCB lives.
* **complete mediation:** TCB cannot be bypassed.
* **correctness:** There are no vulnerabilities.

### Model

We trust the hardware. There have been security issues in hardware before but this is not the focus of the class. Our focus is using secure hardware to run untrusted applications using our TCB \(which is typically the OS\).

![](https://assets.omscs.io/secure-computer-systems/images/module1/TCB-HW.png)

### Reference Monitor Responsibilities

When a request is made for resources the reference monitor must know who/what is requesting the protected resource. This is called **authentication**. The authenticated user/application is then **authorized** to access certain resources. Access control is a synonym for authorization.

An early paper on security lists **authentication**, **authorization**, and **audit** as the gold standard of security. These words all start with the letters "au", the symbol for gold on the periodic table.

## Importance of OS Security

As discussed earlier, the operating system has access to all resources. If the operating system is compromised the attacker now has access to all resources. This is why security of the operating system is more important than the security of applications.

If the OS is compromised, attackers can -

* impersonate users
* destroy/corrupt/disclose sensitive information
* bypass security measures of the OS
* send spam over networks

Most attacks you can think of can be performed via a compromised OS.

## What is Trustworthiness?

Why should we trust the trusted computing base? This question depends on

* What does the TCB do?
* How well does the TCB do it?

The requirements for the TCB as a reference monitor were given earlier as

* tamper proof
* complete mediation
* correctness

These bullet points address the question of **what the TCB does**.

**How well the TCB does these things** can be evaluated by testing, formal verification, or analyzing the structure of the TCB.

## Trusting People?

Overview of: ACM Turing Award lecture by Ken Thompson, [Reflections on Trusting Trust](https://dl.acm.org/doi/pdf/10.1145/358198.358210).

You can write a program that can print itself as output. Similarly, the C compiler is written in C. This is possible because the compiler's source code is compiled to a binary using a prior version's binary of the C compiler. So the source code of the 11.0.0 compiler might be compiled into the binary of the 11.0.0 compiler by the 10.12.11 compiler's binary.

If we write malicious source code someone will discover that we are doing bad things. So we write the malicious source code and compile it to a malicious binary, and this malicious binary is capable of compiling safe looking source code into a new malicious binary. This process can be repeated over and over and the bug will never go away even though the source code always appears to be clean.

The key takeaway is that trust doesn't just depend on what the source code looks like, but also depends on if you trust the people making the software. And this can be difficult because there are many pieces of software in something like an OS.

## Trusted Computing Systems Evaluation Criteria \(TCSEC\)

Trusted Computing Systems Evaluation Criteria \(TCSEC\) was created by the DOD to assist government agency IT departments in evaluating security of software/hardware provided by vendors.

* Class D: System cannot be trusted, and is not isolated from untrusted software.
* Class C1: Has isolation of TCB. User Authentication. Access control.
* Class C2: Has what C1 has along with accountability/audit requirements like logs.

Division B moves from specifying functionality to also specifying the quality of implementation.

* Class B1: Has mandatory access control, meaning a trusted party in the company can specify access controls. Has a well defined TCB and penetration testing.
* Class B2: Covert Channels. How is the TCB designed \(i.e. is it modular?\).
* Class B3: Defined security model. Security related code is separate from non-security code. Least privilege.
* Class A1: Verified design.
* Class A2: Formal verification of implementation \(this is a formal proof\).

The TCSEC didn't catch on in the corporate world because things like verifying security can be costly or infeasible.

## Secure Boot and Trust Policy Module

The Trust Policy Module \(TPM\) ensures that you are booting the correct operating system. This is good because it stops you from booting an attacker's software. The process of verifying something like an operating system or application is called **attestation**.

But what if I want to boot the wrong operating system? Technology like this is used to lock down a vendor's product and take freedom from the user. This is what creates the desire for "jailbreaking" Apple products.