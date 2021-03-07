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

* Tamper-proof
  * Untrusted code cannot modify code that makes up the trusting computing base.
* Complete mediation
  * Every reference from a resource that needs to be protected needs to go through the TCB.
* Correctness
  * The TCB must do work as expected, or else no other guarantees can be made.

### What is Trust?

Understand the Ken Thompson paper, "Reflections on Trusting Trust"

TCSEC, the orange book. Mandatory access required when going from C to B. What does it do? How well does it do it? Division A focuses on formal proof.

Attestation.

### Design Principles

* What are they?
* How they help in a secure system design

**Read Protection of Information Systems Paper, Section 1**

### Memory Protection Hardware Isolation

User-level vs. System-level, there is a boundary between trusted and untrusted created by the TCB. Some privileged instructions can't be executed in user mode. There are different rings and we talk about how control transfer happens between these things.

How to translate from an address in virtual memory to an address in physical memory.

* Segmentation and paging
  * Hardware supported memory protection: SPL/PPL
  * Control transfer between privileged and non-privileged modes
  * Memory protection in 32 and 64-bit architectures
* How does the hardware provide isolation for TCB from untrusted user code?
* How does it protect one process's memory from other processes.

**Read Intel document chapter 5 and background from chapters 3 and 4**

* Virtualization
  * Why virtualization
  * Type I and type II VMM
  * Virtualization requirements
* Hardware support for virtualization \(VT-x\)
  * Root and non-root mode
  * Address translation wiith VT
  * Control transfer with VT \(VM exit and entry\)
* Readings
  * Virtualization paper available on Canvas
  * Pentium virtualization paper, first 3 sections
  * SGX explained, up to page 15

## Authentication

* Entropy, authentication methods, implementation, evaluation
* Password hardening
  * Secret sharing based implementation, instruction table usage, history file. Expected to know this stuff.
  * Security analysis
  * Entropy estimation
* Password hardening is simply used as an example. For any authentication method you could be asked how to implement it and how to evaluate it.

For the readings

* Password hardening paper except sections that do hard math.
* Read sections 1 and 2 from PIN-and-CHIP.

Understand the implementation and security analysis. Understand the threat model and how much work they must do.

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

* Protection by Lampson
* Sections 1-6 of Unix paper
* Sections 1-3 of Windows paper, you may have to traverse whole list if negative ACE not up front
* Section 1-4 of Setuid demystified paper \(only Linux\)
* Java paper \(Policy files, Stack Introspection and doPrivilege sections\)
* Sections 1-6 of Hydra chapter \(Objects and Capabilities, Sharing, Revocation and Protection problems\)

### Mandatory Access Control - MAC

* Motivation
* Labels, Comparison, etc.
* BLP model
* Biba Model
* RBAC
* Clark-Wilson Policy
* Chinese Wall Policy

**MAC readings**

* Sections 6.3 to 6.5 of Gasser book
* RBAC paper
* Clark-Wilson papers

## Sample Questions TCB, Design Principles and Virtualization

### 1.

The rowhammer bug exploits a vulnerability in DRAM memories that can result a bit flip in a memory location by repeated reading of locations in an adjacent row. Exploits have been reported which allow user level code to cause a bit flip in a page table entry. In fact, a process could use this exploit to gain write access to its page table entry.

a. Describe the three requirements that must be met by a trusted computing base \(TCB\).

1. Tamper proof
2. Complete mediation
3. Correctness

b. Which of the TCB requirements described in 1\(a\) could be violated in a system that has main memory with the rowhammer bug?

Tamper proof. You could make an argument that other requirements are being violated, but the fundamental problem is that user code is modifying the function of the TCB.

### 2.

Answer the following questions about design principles for secure systems.

a. Briefly describe the least privilege and fail-safe default principles.

* Least privilege is that a process must execute with the fewest privileges with which it can complete its execution.
* Fail-safe default means we deny access unless explicitly granted.

b. If a system correctly implements the least privilege principle, should it also follow the failsafe default principle? Explain your answer.

I posted about it.

### 3.

Answer the following questions about memory protection in the Intel x86 architecture. You must justify your true/false answer with a brief explanation.

a. In the protected mode in the x86 architecture, when current protection level \(CPL\) is 0, any data from both user and kernel segments can be accessed. True or false?

b. In a virtualization system with a type I hypervisor, a guest OS can run in ring 0 even in the absence of virtualization extensions of the x86. True or false.

c. With the Intel SGX extensions, code in an enclave does not need to trust the hypervisor. This is because such code runs in a more privileged ring than the hypervisor. True or false.

d. Consider the EIP and CR3 registers in x86 processors. EIP stores the address of the next instruction to be executed and the base address of a page table is stored in control register CR3.

Both of these registers can be loaded using non-privileged instructions. True or false.

