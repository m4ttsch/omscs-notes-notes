---
id: operating-systems-introduction-to-operating-systems
title: Introduction To Operating Systems
course: operating-systems
lecture: introduction-to-operating-systems
---

# Introduction To Operating Systems

**OSTEP chapter**: [2. Introduction to Operating Systems](https://pages.cs.wisc.edu/~remzi/OSTEP/intro.pdf)

## Visual Metaphor
An operating system is like a toy shop manager. A toy shop manager:

* **directs operational resources**: is in charge of the employees, and schedules, allocates and distributes the parts and tools, deciding which employee works on which order with which tools;
* **enforces working policies**: fairness, safety, clean-up, for example how workers on two different orders share a tool, or how to clean up after finishing an order;
* **mitigates the difficulty of complex tasks**: makes the overall operation of the shop simpler and more optimized, so the employees don't have to work out among themselves how to establish order and handle the workload.

The parallels with an operating system:

* It directs operational resources: it controls the use of the hardware (CPU, memory, peripheral devices such as disks and network cards) and decides how those resources are allocated to applications.
* It enforces policies: fair access to shared resources, or limits on the maximum amount of a resource an application or process can use. Examples of such limits are the number of files that can be open per process, or the thresholds that need to be passed for some memory management daemons to kick in.
* It mitigates the difficulty of complex tasks: it simplifies the view of the underlying hardware that applications observe. Applications interact with the operating system via system calls, and the operating system takes care of the difficult tasks for them.

## What is an operating system?
Let's first look at the hardware of a computing system. This computing system consists of:

* Central Processing Unit (CPU)
* Physical Memory
* Network Interfaces (Ethernet/Wifi Card)
* GPU
* Storage Devices (Disk, SSD, Flash drives [USB])

In addition, a computing system can have higher level applications. These are the "programs" that we use every day on our computer:

* Skype
* Word
* Chrome

Except in some very specific environments, like certain embedded platforms or sensors, all of these hardware components get used by multiple applications at once. A single CPU consists of multiple cores, so even one CPU has more than one processing element to hand out. A server machine may run a web server, a database and a computation intensive simulation at the same time. Even on hardware that traditionally ran a single application, this holds: on your phone you have a browser, Skype, Facebook, and the one application that makes and receives phone calls.

**The Operating System is the layer of software that sits between the hardware components and the higher level applications.**

There isn't one formal definition of what an operating system is. Instead, we look at the role the operating system serves and the functionality it must provide, and build our understanding from that.

## Main Functions of an Operating System
An operating system **abstracts** and **arbitrates** the use of the computer system.

* **Abstraction** simplifies what the hardware looks like to the software above it.
* **Arbitration** manages and distributes the hardware among the applications competing for it.

#### Operating systems hide hardware complexity.
You don't want to have to worry about the nuts and bolts of interacting with storage devices when you are writing an application. The operating system provides a higher level abstraction, the *file*, with a number of operations - like *read* and *write* - which applications can interact with.

The same goes for the network. A web server accepting and responding to end user requests shouldn't have to think about the bits and packets it needs to compose. The operating system abstracts the networking resource as a *socket*, and provides operations to *send* and *receive* data over it.

#### Operating systems manage underlying hardware resources.
Operating system allocates memory for applications, schedules them for execution on the CPU, controls access of applications to the various devices in the system and so on. Overall, it is responsible for all types of resource allocation and resource management tasks on behalf of the applications.

#### Provides isolation and protection.
When multiple applications are co-running on the same hardware, the operating system has to ensure that each of them can make adequate progress and that they don't hurt one another. It allocates different parts of the physical memory to different applications, and it makes sure that, unless explicitly intended, applications don't access each other's memory.

**Protection** means an application cannot read another application's data. **Isolation** means an application cannot overwrite another application's memory.

## Operating System Definition
An operating system is a layer of systems software that

* directly has privileged access to the underlying hardware, and can manipulate its state (software that corresponds to the applications is not allowed to do that);
* hides hardware complexity;
* manages hardware on behalf of one or more applications according to some predefined policies;
* ensures that applications are isolated and protected from one another.

<details>
<summary>Operating system components quiz spoiler</summary>

Which of the following are likely components of an operating system: a file editor, a file system, a device driver, cache memory, a web browser, a scheduler? Check all that apply.

Likely OS components: the file system, the device driver and the scheduler. Not OS components: the file editor, the web browser and cache memory.

* File editor: not part of the OS. Users interact with it directly, and it is not directly involved in managing hardware.
* File system: part of the OS. It is directly responsible for hiding hardware complexity and exporting a simpler, more intuitive abstraction: a file, as opposed to a block of disk storage.
* Device driver: part of the OS. It is directly responsible for making decisions about the usage of the hardware devices.
* Web browser: not part of the OS. Like the file editor, it is an application that users interact with, and it has no direct control over the underlying hardware.
* Scheduler: part of the OS. It is responsible for distributing access to the processing element, the CPU, among all of the applications that share the platform.

Cache memory is a tricky case. Both the operating system and the application software use the cache for performance, but the OS does not directly manage it: the hardware manages the cache itself.

Beyond the lecture: the OS does control whether a mapping is cacheable, and it issues explicit flush operations where correctness demands them, but there is no OS component whose job is managing the cache.
</details>

<details>
<summary>Abstraction or arbitration quiz spoiler</summary>

For each option, is it an abstraction (the OS simplifies something about the underlying hardware) or arbitration (the OS manages the underlying hardware)? Distributing memory between multiple processes; supporting different types of speakers; providing interchangeable access of hard disk or SSD.

Distributing memory between processes is arbitration; supporting different speakers and interchangeable access to a hard disk or SSD are abstractions.

Distributing memory between processes is something the operating system does as part of managing memory and determining how multiple processes will share it.

Supporting different types of speakers is an abstraction the operating system provides. You can plug in one set of speakers and, if they don't work, exchange them for something else. In some cases drivers are required to make this work. The device driver knows the details of the particular hardware element, like that one set of speakers. That is what lets the operating system control the device without knowing those details itself.

Interchangeable access to different types of storage devices, like hard disks or SSDs, is an abstraction for the same reason. The storage abstraction the operating system supports handles the different types of devices underneath and hides them from the applications.
</details>

## Operating System Examples
Certain operating systems may target the desktop or server environment, while others may target an embedded environment, while still others may target ultra high end machines like mainframes.

For our purposes, we will focus mainly on operating systems for desktop environments and embedded environments, because they are the most common. We will also focus on recent, current operating systems rather than those that have evolved over the last 60 plus years of computer science.

For desktop operating systems we have:

* Microsoft Windows: well known since the early 1980s
* Unix-based systems: a family extended from the operating system that originated at Bell Labs in the late 1960s
	* OS X: Apple's operating system, which extends the Unix BSD (Berkeley System Distribution) kernel
	* Linux: a Unix-like system that is open source and bundled with many popular software libraries; there are many versions, like Ubuntu and CentOS

For embedded operating systems:

* Android: an embedded form of Linux
* iOS: Apple's proprietary operating system for devices like iPhones and iPads
* Symbian

Each of these makes its own design and implementation choices. This class focuses on Linux: most of the illustrative, in-depth examples are based on it.

## OS Elements
To achieve its goals, an operating system provides a number of high level abstractions, as well as a number of mechanisms to operate on these abstractions.

*Process* and *thread* are the abstractions that correspond to the applications the operating system executes. The mechanisms that go with them are *create*, which launches an application so it starts executing, and *schedule*, which makes it actually run on the CPU.

*File*, *socket* and *memory page* are the abstractions that correspond to the hardware resources the operating system manages: a storage device, a network card, and physical memory. The mechanisms that go with them are *open*, which gains access to a particular device or hardware component, *write*, which updates its state, and *allocate*, which makes sure an application has access to that resource.

Operating systems may also integrate specific policies that determine exactly how the mechanisms will be used to manage the underlying hardware.

For example, a policy could determine the maximum number of sockets that a process has access to, or which data is removed from physical memory, based on some algorithm like least-recently used.

## OS Elements Example
Let's look at an example of *memory management*.

The main abstraction here is the *memory page*, which corresponds to some addressable region of memory of some fixed size, typically 4KB.

The operating system integrates mechanisms to operate on that page like *allocate*, which actually allocates the memory in DRAM. It can also map that page into the address space of the process, so that the process can interact with the underlying DRAM.

Over time, the page may be moved to different spaces of memory, or may be moved to disk, but those who use the page abstraction don't have to worry about those details. That's the point of the abstraction.

How do we determine when to move the page from DRAM to disk? This is an example of a *policy*. Since accessing data in memory is much faster than accessing it on disk, the OS needs some rule for deciding which pages stay resident. One such implementation would use the least-recently-used (LRU) algorithm, moving pages that have been accessed longest ago onto disk. Moving a page out of physical memory and onto disk like this is called **swapping**.

A page that hasn't been touched in a while is probably not important right now and won't be needed soon, so it's cheap to evict. Pages that have been accessed more frequently are likely more important, or are part of the content the process is currently working on, so we keep them in memory.

## OS Design Principles

### Separation of mechanism and policy
We want to incorporate flexible mechanisms that can support a number of policies.

For the example of memory, we can have many policies: LRU, LFU (least-frequently used), random. It is a good design strategy to create our memory management mechanisms such that they can generalize to these different policies.

What is the mechanism that supports all three? The mechanism tracks how memory locations have been accessed, either their frequency or the time when they were last touched, or it ignores that information entirely. Any one of the three policies can be implemented on top of it.

In different settings, different policies make more sense.

### Optimize for the common case

* Where will the OS be used? What machine will it run on: how many CPUs, how much memory, what devices are attached?
* What will the user want to execute on that machine?
* What are the workload requirements? How does that workload actually behave?

Understanding the common case - which may change in different contexts - helps the OS implement the correct policy, which of course relies on generalized mechanisms.

## OS Protection Boundary
Computer systems distinguish between at least two modes of execution:

* privileged kernel mode
* unprivileged or user mode

Because an OS must have direct access to hardware, it must operate in privileged kernel mode.

Applications generally operate in unprivileged user mode.

Hardware access can only be utilized in kernel mode from the OS directly.

Crossing from user mode to kernel mode is supported by the hardware on most modern platforms.

As an example, when the CPU is in kernel mode a special bit is set in the CPU, and any instruction that directly manipulates hardware is permitted to execute. In user mode that bit is not set, and those instructions are forbidden.

When privileged instructions are encountered during a non-privileged execution, the application will be **trapped**. This means the application's execution will be interrupted, and the hardware will switch control to the OS at a specific location. At that point the OS checks what caused the trap.

The OS can decide whether to grant the access or potentially terminate the process.

The OS also exposes an interface of **system calls**, which the application can invoke, which allows privileged access of hardware resources for the application.

For example:

* `open` (file)
* `send` (socket)
* `malloc` (memory)

That last one is the lecture's example. Strictly, `malloc` is a C library function rather than a system call: it gets memory from the kernel through the `brk` or `mmap` system calls.

Operating systems also support **signals**, which is a way for the operating system to send notifications to the application.

## System Call Flow
Begin within the context of a currently executing process. The process needs access to some hardware, and thus needs to make a system call. The application makes the system call (potentially passing arguments), and control is passed to the operating system, which accesses the hardware. Execution control (as well as any necessary data) is passed back from the operating system to the application process.

In terms of context switching, the process involves a change from user mode to kernel mode to user mode.

Not necessarily a cheap operation to make a system call!

Why isn't it cheap? Making the call changes the execution context from the user process to that of the kernel, passes whatever arguments the operation needs, and jumps to the location in kernel memory that holds the instruction sequence for that system call. The return does all of it in reverse, ending back at the exact instruction in the user process where the call was made from.

Arguments to system call can either be passed directly from process to operating system, or they can be passed indirectly by specifying their address.

In **synchronous mode**, the process waits until the system call completes. Asynchronous modes exist also.

To make a system call, the application has to:

1. Write the arguments and save the relevant data at a **well-defined location**.
2. Make the call using a specific **system call number**.

The kernel uses the system call number to work out how many arguments to expect and where to look for them.

## Crossing the OS Boundary
User/Kernel transitions are a necessary step throughout the course of application execution. An application may need to access some hardware, or it may need to request a change in the hardware resources allocated to it. Only the kernel is allowed to perform those operations: an application cannot change the contents of certain registers to give itself more CPU or more memory.

The hardware supports user/kernel transitions.

For example, the hardware will cause a *trap* when an application in unprivileged mode tries to perform an instruction, or a memory access, for which it doesn't have permission.

Hardware initiates transfer of control from process to operating system when a trap occurs, and marks it by setting the special privilege bit. Whether the OS grants or denies the request depends on the policies it supports.

User/Kernel transition requires instructions to execute, which can take 50 to 100ns on a 2Ghz Linux box.

In addition, the OS will bring the content it needs into the hardware cache, replacing the application content that was there before the transition. Where accessing the cache is on the order of a few cycles, accessing memory can be on the order of hundreds of cycles, so the application pays for those evictions on its subsequent accesses.

In summary, user/kernel transitions are not cheap.

## OS Services
An operating system provides applications with access to the underlying hardware.

It does so by exporting a number of services, which are often directly linked to the components of the hardware:

* Scheduling component (CPU, or even multiple CPUs): controls access to the CPU
* Memory manager (physical memory): allocates physical memory to one or more co-running applications, and makes sure they don't overwrite each other's memory
* Block device driver (block device)

In addition, some services are even higher level abstractions, not having a *direct* hardware component. For example, the filesystem as a service.

Basic services include:

* Process management
* File management
* Device management
* and so forth

All of these services are made available to applications through system calls.

[Windows v. Unix Services](https://s3.amazonaws.com/content.udacity-data.com/courses/ud923/notes/ud923-p1l2-windows-vs-linux-system-calls.png)

Windows and Unix are very different operating systems, but the *types* of system calls they provide and the abstractions built around them line up closely. Both have process control (create a process, exit a process, wait on something), file creation, and so on.

<details>
<summary>System calls quiz spoiler</summary>

Some other Linux system calls: `kill` sends a signal to a process, `setgid` sets the group identity of a process, `mount` mounts a file system, and `sysctl` reads or writes system parameters. On a 64 bit system the call is `setgid`; on 16 or 32 bit systems there are the variants `setgid16` and `setgid32`.

Two of those have dated since the lecture. The `setgid` variants exist because the original call took a 16 bit group ID and Linux 2.4 added a 32 bit version, so the split is about the width of the group ID rather than the word size of the machine. `sysctl` was removed from Linux in 5.5, and system parameters are now read and written through the `/proc/sys` filesystem.
</details>

## Monolithic OS
Historically, operating systems have a monolithic design.

Everything is included off the bat. Every possible service that any application can require, or that any type of hardware will demand, is already part of the operating system, for instance several file systems at once: one specialized for sequential workloads, which read and write files sequentially, and another optimized for random I/O, which is common with databases, where each operation can access any portion of the backing file.

This makes the operating system potentially very large.

#### Pros
* Everything included: the abstractions and all the services are packaged at the same time
* Compile-time optimizations (inlining, for example)

#### Cons
* Too much state and too much code, which is hard to maintain, debug and upgrade
* Large memory requirements (which can impact performance)

## Modular OS
This type of operating system has a basic set of services and APIs that come with it.

Anything not included can be added, as a module. For instance, you can easily customize which file system or scheduler the operating system uses.

Linux uses this design, and it is the dominant approach today.

The OS specifies an **interface** that any module must implement to plug in. Once that contract exists, you can swap the implementation behind it.

Database applications that access random offsets want a file system optimized for random access; a workload that streams through files start to finish wants one optimized for sequential access.

As a result, each application can interface with the operating systems in the ways that make most sense to it.

Dynamically install new modules in the operating system!

A smaller code base is also less resource intensive, which leaves more memory for the applications. That can lead to better performance as well.

#### Pros
* Easier to maintain and upgrade
* Smaller footprint
* Less resource needs

#### Cons
* All the modularity/indirection can reduce some opportunities for optimization (typically not a significant performance impact)
* Maintenance can still be an issue as modules from different codebases can be slung together at runtime, and can be a source of bugs

## Microkernel
Microkernels only require the most basic operating system primitives: an address space and a thread, which together are enough to represent an executing application and its context.

Everything else (including file systems and device drivers) will run outside of the operating system at unprivileged user level.

This setup requires lots of inter-process communication (IPC), as those components now live in separate processes.

As a result, the microkernel supports IPC as one of its core abstractions and mechanisms.

#### Pros
* Size (lower overheads, better performance)
* Verifiability (valuable where correct behavior is critical, like some embedded devices or certain control systems)

#### Cons
* Bad portability (often customized to underlying hardware)
* Harder to find common OS components due to specialized use case, leading to software complexity
* Expensive cost of frequent user/kernel crossing

## Linux and Mac OS Architecture

### Linux

* Hardware
* Linux Kernel
* Standard Libraries (sys call interface)
* Utility program (shells/compiler)
* User applications

Kernel consist of several logical components

* I/O management
* Memory management
* Process management

These components have well defined functionality, as well as interfaces.

Each subcomponent within the three above can be modified or replaced 'cause modularity!

### Mac OS X
* I/O kit for device drivers
* Kernel extension kit for dynamic loading of kernel components
* Mach microkernel
	* memory management
	* thread scheduling
	* IPC, including remote procedure calls (RPC)
* BSD component
	* Unix interoperability (via a BSD command line interface)
	* POSIX API support
	* Network I/O interface
* All applications sit above this layer
