---
id: operating-systems-introduction-to-operating-systems
title: Introduction To Operating Systems
course: operating-systems
lecture: introduction-to-operating-systems
---

# Introduction To Operating Systems

## What is an operating system?
Let's first look at the hardware of a computing system. This computing system consists of:

* Central Processing Unit (CPU)
* Physical Memory
* Network Interfaces (Ethernet/Wifi Card)
* GPU
* Storage Devices (Disk, Flash drives [USB])

In addition, a computing system can have higher level applications. These are the "programs" that we use every day on our computer:

* Skype
* Word
* Chrome

**The Operating System is the layer of software that sits between the hardware components and the higher level applications.**

## Main Functions of an Operating System

#### Operating systems hide hardware complexity.
You don't want to have to worry about the nuts and bolts of interacting with storage devices when you are writing an application. The operating system provides a higher level abstraction, the *file*, with a number of operations - like *read* and *write* - which applications can interact with.

#### Operating systems manage underlying hardware resources.
Operating system allocates memory for applications, schedules them for execution on the CPU, controls access to various network devices and so on.

#### Provides isolation and protection.
When applications are running concurrently, the operating system has to ensure that they can do what they need to without hurting one another. For example, memory allocated to each application must not be readable/writable from another application.

## Operating System Definition
An operating system is a layer of systems software that

* directly has privileged access to the underlying hardware;
* manages hardware on behalf of one or more applications according to some predefined policies.
* Ensures that applications are isolated and protected from one another

## Operating System Examples
Certain operating systems may target the desktop environment, while others may target an embedded environment, while still others may target a mainframe or a server environment.

For our purposes, we will focus mainly on operating systems for desktop environments and embedded environments.

For desktop operating systems we have:

* Microsoft Windows
* Unix-based systems
	* OS X
	* Linux

For embedded operating systems:

* Android
* iOS
* Symbian

## OS Elements
To achieve its goals, an operating system provides a number of high level abstractions, as well as a number of mechanisms to operate on these abstractions.

Examples of abstractions include:

* process, thread (application abstractions)
* file, socket, memory page (hardware abstractions)

Corresponding mechanisms could be:

* create/schedule
* open/write/allocate

Operating systems may also integrate specific policies that determine exactly how the mechanisms will be used to manage the underlying hardware.

For example, a policy could determine the maximum number of sockets that a process has access to.

## OS Elements Example
Let's look at an example of *memory management*.

The main abstraction here is the *memory page*, which corresponds to some addressable region of memory of some fixed size.

The operating system integrates mechanisms to operate on that page like *allocate*, which actually allocates the memory in DRAM. It can also map that page into the address space of the process, so that the process can interact with the underlying DRAM.

Over time, the page may be moved to different spaces of memory, or may be moved to disk, but those who use the page abstraction don't have to worry about those details. That's the point of the abstraction.

How do we determine when to move the page from DRAM to disk? This is an example of a *policy*, and one such implementation of that policy would use the least-recently-used (LRU) algorithm, moving pages that have been accessed longest ago onto disk.

## OS Design Principles

### Separation of mechanism and policy
We want to incorporate flexible mechanisms that can support a number of policies.

For the example of memory, we can have many policies: LRU, LFU (least-frequently used), random. It is a good design strategy to create our memory management mechanisms such that they can generalize to these different policies.

In different settings, different policies make more sense.

### Optimize for the common case

* Where will the OS be used?
* What will the user want to execute on that machine?
* What are the workload requirements?

Understanding the common case - which may change in different contexts - helps the OS implement the correct policy, which of course relies on generalized mechanisms.

## OS Protection Boundary
Computer systems distinguish between at least two modes of execution:

* user-level (unprivileged)
* kernel-level (privileged)

Because an OS must have direct access to hardware, it must operate in kernel mode.

Applications generally operate in user-mode.

Hardware access can only be utilized in the kernel mode from the OS directly.

Crossing from user-level to kernel-level is supported by most modern operating systems.

As an example, the operating system can flip a bit in the CPU that allows applications executing instructions to have direct access to hardware resources. When the bit is not flipped, operations are forbidden.

When privileged instructions are encountered during a non-privileged execution, the application will be **trapped**. This means the application's execution will be interrupted, and control will be handed back to the OS.

The OS can decide whether to grant the access or potentially terminate the process.

The OS also exposes an interface of  **system calls**, which the application can invoke, which allows privileged access of hardware resources for the application.

For example:

* `open` (file)
* `send` (socket)
* `mmap` (memory)

Operating systems also support **signals**, which is a way for the operating system to send notifications to the application.

## System Call Flow
Begin within the context of a currently executing process. The process needs access to some hardware, and thus needs to make a system call. The application makes the system call (potentially passing arguments), and control is passed to the operating system, which accesses the hardware. Execution control (as well as any necessary data) is passed back from the operating system to the application process.

In terms of context switching, the process involves a change from user-mode to kernel-mode to user-mode.

Not necessarily a cheap operation to make a system call!

Arguments to system call can either be passed directly from process to operating system, or they can be passed indirectly by specifying their address (pointers?)

In **synchronous mode**, the process waits until the system call completes. Asynchronous modes exist also.

## Crossing the OS Boundary
User/Kernel transitions are very common and useful throughout the course of application execution.

The hardware supports user/kernel transitions.

For example, the hardware will cause a *trap* on illegal executions that require special privilege.

Hardware initiates transfer of control from process to operating system when a trap occurs.

User/Kernel transition requires instructions to execute, which can take ~100ns on a 2Ghz Linux box.

In addition, the OS may bring some data into the hardware cache, which will bounce out some other memory used by another application. Accessing data out of cache, say from  main memory, may have as much as 100x impact on the performance of some subsequent actions.

## OS Services
An operating system provides applications with access to the underlying hardware.

It does so by exporting a number of services, which are often directly linked to the components of the hardware:

* Scheduling component (CPU)
* Memory manager (physical memory)
* Block device driver (block device)

In addition, some services are even higher level abstractions, not having a *direct* hardware component. For example, the filesystem as a service.

Basic services include:

* Process management
* File management
* Device management
* Memory management
* Storage management
* Security

[Windows v. Unix Services](https://s3.amazonaws.com/content.udacity-data.com/courses/ud923/notes/ud923-p1l2-windows-vs-linux-system-calls.png)

## Monolithic OS
Historically, operating systems have a monolithic design.

Everything is included off the bat!

This makes the operating system potentially very large.

#### Pros
* Everything included
* Inlining, compile-time optimizations

#### Cons
* No customization
* Not too portable/manageable
* Large memory footprint (which can impact performance)

## Modular OS
This type of operating system has a basic set of services and APIs that come with it.

Anything not included can be added, as a module.

As a result, each application can interface with the operating systems in the ways that make most sense to it.

Dynamically install new modules in the operating system!

#### Pros
* Maintainability
* Smaller footprint
* Less resource needs

#### Cons
* All the modularity/indirection can reduce some opportunities for optimization (but eh, not really)
* Maintenance can still be an issue as modules from different codebases can be slung together at runtime

## Microkernel
Microkernels only require the most basic operating system components.

Everything else (including file systems and disk drivers) will run outside of the operating system at user-level.

This setup requires lots of interprocess communication (IPC), as the traditional operating system components run within application processes.

As a result, the microkernel often supports IPC as a core abstraction.

#### Pros
* Size
* Verifiability (great for embedded devices)

#### Cons
* Bad portability (often customized to underlying hardware)
* Harder to find common OS components due to specialized use case
* Expensive cost of frequent user/kernel crossing

## Linux and Mac OS Architecture

### Linux

* Hardware
* Linux Kernel
* Standard Libraries (sys call interface)
* Utility program (shells/compiler)
* User applications

Kernel consist of several logical components

* Virtual file system
* Memory management
* Process management

Each subcomponent within the three above can be modified or replaced 'cause modularity!

### Mac OS X
* I/O kit for device drivers
* Kernel extension kit for dynamic loading of kernel components
* Mach microkernel
	* memory management
	* thread scheduling
	* IPC
* BSD component
	* Unix interoperability
	* POSIX API support
	* Network I/O interface
* All applications sit above this layer
