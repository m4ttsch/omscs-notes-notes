---
id: operating-systems-virtualization
title: Virtualization
course: operating-systems
lecture: virtualization
---

# Virtualization

**Reference papers**:

* [Formal Requirements for Virtualizable Third Generation Architectures](https://s3.amazonaws.com/content.udacity-data.com/courses/ud923/references/ud923-popek-goldberg-paper.pdf) - Popek and Goldberg.
* [Virtual Machine Monitors: Current Technology and Future Trends](https://s3.amazonaws.com/content.udacity-data.com/courses/ud923/references/ud923-rosenblum-garfinkel-paper.pdf) - Rosenblum and Garfinkel.

**OSTEP appendix**: [B. Virtual Machine Monitors](https://pages.cs.wisc.edu/~remzi/OSTEP/vmm-intro.pdf)

## What is Virtualization?
Virtualization is an old idea. It originated in the 1960s at IBM, when computing meant a few large mainframes shared by many users and business services. In order to concurrently run diverse workloads on the same physical hardware without requiring that a single operating system be used for all of the applications, it was necessary to come up with a model where multiple operating systems can concurrently be deployed on the same hardware platform.

The solution is **virtualization**.

![](https://assets.omscs.io/notes/A96F5139-EFB1-4038-A5E4-9128C63CF5F8.png)


With virtualization, each of the operating systems that are deployed on the same physical platform has the illusion that it actually owns the underlying hardware resources, all or in part.

Each operating system, plus its applications and its virtual resources is called a **virtual machine** (VM). VMs are sometimes referred to as *guests* or *domains*.

Supporting the coexistence of multiple VMs on a single physical machine requires underlying functionality in order to deal with the allocation and management of the real hardware resources. In addition, it is necessary to provide some isolation guarantees across VMs.

This functionality is provided by the **virtualization layer**, also referred to as a **virtual machine monitor** or **hypervisor**.

## Defining Virtualization
A virtual machine is an **efficient, isolated duplicate** of a real machine.

Virtualization is supported by the virtual machine monitor (VMM). The VMM has three responsibilities.

First, the VMM must provide an environment that is essentially identical to the original machine. The capacity may differ, but the overall setup (type of CPU, types of devices) should be the same. The VMM must provide some **fidelity** that the representation of the hardware that is visible to the VM matches the hardware that is available on the physical platform.

Second, programs that run in VMs must show at worst only minor decreases in speed. Clearly, the VMs are only given a portion of the resources available to the host machine. However, the goal of the VMM is to ensure that the VM would perform at the same speed as a native application if it were given all of the host's resources. The VMM must provide **performance** to the VMs that is as close to native performance as possible.

Finally, the VMM is in complete control of the system resources. The VMM controls who access which resources and when, and it can be relied upon to provide **safety and isolation** among the VMs. This does not mean the VMM inspects every single hardware access. Instead, the VMM determines whether a particular VM is to be given direct hardware access, and once those decisions are in place, a VM cannot change those policies and potentially hurt other co-located VMs.

> **Paper (Popek & Goldberg):** This definition is lifted from the 1974 paper, which names the three VMM properties more formally than the lecture's "fidelity, performance, safety and isolation". The paper calls them *equivalence* (any program runs with an effect identical to running on the bare machine, except for timing and resource-availability differences), *efficiency* (a statistically dominant subset of instructions executes directly on the real processor with no VMM intervention), and *resource control* (a program cannot access resources not allocated to it, and under certain circumstances the VMM can regain control of resources already allocated). The efficiency property is what formally excludes pure emulators and software interpreters from being VMMs, and the equivalence property is what distinguishes a VMM from an ordinary time-sharing OS and from plain virtual memory.

<details>
<summary>Virtualization tech quiz spoiler</summary>

The quiz asks which of the following are virtualization technologies, based on the classical definition by Popek and Goldberg: VirtualBox, the Java Virtual Machine, and Virtual GameBoy (check all that apply). The only correct answer is VirtualBox. A virtual machine is an efficient, isolated duplicate of the real machine. The JVM is a language runtime that provides system services and portability to Java applications, and it is very different from the underlying physical machine. Emulators like Virtual GameBoy emulate some hardware platform (the GameBoy), which again is very different from the hardware platform the emulator runs on. With system virtualization, as in VirtualBox, the hardware visible to the virtual machine is identical, or at least very similar, to the physical platform supporting it.
</details>

## Benefits of Virtualization
Virtualization enables **consolidation**. Consolidation refers to the ability to run multiple VMs on a single physical platform. Consolidation leads to fewer machines, with less space, with fewer admins, with potentially smaller electric bills that are still able to run the same degree/type of workload.

Consolidation allows us to decrease cost and improve manageability.

Virtualization also makes **migration** easier. Since the operating system and the applications are no longer coupled to the physical system, it is easy to migrate them from one physical machine to another, or even to copy and clone them onto multiple physical machines at the same time.

Virtualization helps us address **availability** and **reliability**. If the load increases, we can create multiple VMs to handle it, which increases availability. If we detect that a particular hardware node is getting hot and is likely to fail, we can migrate its VMs onto other physical nodes, which improves reliability.

Because the OS and the applications are nicely encapsulated in a VM, it becomes easier to contain bugs or malicious code to those isolated containers without bringing down other VMs or the entire physical platform.

Virtualization has also provided fertile ground for operating systems research. Research can quickly boot up and test OSes in development without having to restart hardware.

Virtualization also provides affordable support for legacy operating systems. Applications that need to run on older OSes no longer need a physical box dedicated just to them. They can run as one VM of many, sharing the physical resource with other applications.

Virtualization is an old idea, so it is worth asking why it was not used ubiquitously from the start, and why it returned. It lapsed because mainframes were not ubiquitous and other hardware was cheap (not because virtualization was inefficient, or because everyone used Microsoft Windows): most companies ran commodity x86 servers, and it was simpler to buy another machine than to make several operating systems coexist on one. That model held for decades, until data centers grew too large, servers sat underutilized (average utilization around 10 to 20 percent), admin headcount rose, and power and cooling bills climbed (all four of these are why virtualization returned), to the point that companies were spending on the order of 70 percent of their IT budget on operating expenses rather than on new hardware or software. Consolidating workloads onto fewer, better-managed machines through virtualization became the way to bring those operating costs down.

> **Paper (Rosenblum & Garfinkel):** The paper tells the same arc and sharpens the point: the very combination that killed VMMs in the 1980s, cheap hardware plus capable multitasking operating systems, is what later caused the problems VMMs solve. Cheap hardware proliferated underused machines; more capable operating systems grew fragile and vulnerable, which pushed admins back to one-application-per-machine and so back to a hardware-sprawl problem. The authors argue that going forward a VMM is "less a vehicle for multitasking ... and more a solution for security and reliability", and that functions like migration and security are better implemented at the VMM layer than inside today's "complex and ossified" operating systems. They also note benefits the lecture does not: a general-purpose undo through checkpoint and rollback, VMM-level security services (intrusion detection as in Livewire, after-the-fact break-in analysis as in ReVirt), high-assurance isolation (the NSA NetTop architecture), trusted computing with remote attestation (Terra), and distributing whole preconfigured software stacks as virtual appliances. By the late 1980s VMMs were regarded as little more than a historical curiosity.

## Virtualization Models: Bare Metal
In **bare-metal** virtualization (also known as **hypervisor-based** or **type 1** virtualization), the VMM manages all the hardware resources and supports execution of VMs.

![](https://assets.omscs.io/notes/A320790E-26BD-4370-8B87-47E08D04FA9C.png)

One issue with this model concerns devices. According to the model, the hypervisor must manage all possible devices. In other words, device manufacturers now have to provide device drivers not just for different operating systems, but also for different hypervisors.

To eliminate this problem, the hypervisor model typical integrates a special virtual machine, a service VM, that runs a standardized OS with full hardware access privileges, allowing it to manipulate hardware as if it were native.

The privileged VM runs all of the device drivers and controls how the devices on the platform are used. This VM will run some other configuration and management tasks to further assist the hypervisor.

This model is adapted by the **Xen** virtualization software (both the open-source Xen and the version supported by Citrix, XenServer) and by the **ESX** hypervisor from VMware.

Regarding Xen, the VMs that run in the virtualized environment are referred to as domains. The privileged domain is referred to as **dom0** and the guest domains are referred to as **domUs**. Xen is the hypervisor. All of the device drivers are running in dom0.

Because VMware and its hypervisors were first to market, VMware maintains the largest share of virtualized server cores. VMware has been able to mandate that device manufactures develop drivers that can be used by the hypervisor. Since VMware targets servers, there are relatively few devices.  VMware also exports a number of APIs, both to support a third-party community of developers and to let users configure exactly the policies the hypervisor enforces.

VMware used to have a control core based in Linux (similar to the dom0 in Xen), but now all of the configuration is done via remote APIs.

## Virtualization Models: Hosted
The other type of virtualization model is the **hosted** (or **type 2**) model.

In this model, there is a full-fledged host OS that manages all of the hardware resources. The host OS integrates a VMM, which is responsible for providing the VMs with their virtual platform interface and for managing context switching, scheduling, and so on.

As necessary, the VMM module will invoke devices drivers and other host components as needed.

One benefit of this model is that it can leverage all of the services and mechanisms that are already developed for the host operating system. Much less functionality needs to be developed for the VMM module itself.

In this setup, you can run guest VMs through the VMM module as well as native applications directly on the host OS.

![](https://assets.omscs.io/notes/2BE5A89A-9473-420B-B659-D5F010B2BB8D.png)

One example of the hosted model is **kernel-based VM** (KVM) which is built into Linux. The Linux host provides all aspects of the physical hardware management and can run regular Linux applications directly.

The support for running guest VMs comes from a combination of the KVM (VMM) module and a hardware emulator called **QEMU**.

QEMU is not emulating some foreign hardware platform here. Instead, it is used in what is called *virtualizer* mode: the resources available to the guest VM are the exact hardware resources of the physical platform (x86 Intel or AMD), except that the virtualizer intervenes during certain types of critical operations or instructions to pass control to the KVM module and the host OS. One example is any aspect of I/O management, because all of the device drivers are handled by the host Linux OS.

KVM has been able to leverage all of the advances that have been contributed to the Linux open source community. Because of this KVM can quickly adapt to new features and fixes. In fact, the KVM module was originally developed so that regular Linux applications could take advantage of the virtualization-related hardware that started appearing in commodity platforms. Once users realized it could also run guest operating systems and regular VMs, KVM became, three months later, a virtualization solution that was part of the mainstream Linux kernel.

> **Paper (Rosenblum & Garfinkel):** The paper's canonical hosted example is VMware Workstation rather than KVM, and its Figure 2 illustrates that hosted architecture (the term comes from the paper's reference on VMware Workstation's hosted VMM, Sugerman et al.). The virtualization layer reuses the host OS's device drivers, so when a guest reads or writes its virtual disk the layer turns that into a system call that reads or writes a file in the host's file system, and it renders the guest's display into a window on the host. The paper lists three advantages: the VMM installs like an ordinary application rather than on bare hardware, it inherits the host's rich driver support for the diverse x86 device market, and it reuses the host's scheduling and resource management. It lists two disadvantages: high I/O overhead, because every I/O request must cross into the host and traverse its software layers, and the host OS's lack of resource-management support for performance isolation and service guarantees. These two are why VMware's server product (ESX Server) dropped the host OS and runs directly on the hardware instead.

<details>
<summary>Bare metal or hosted quiz spoiler</summary>

The quiz asks whether each of these products is bare-metal (hypervisor-based, HV) or host-OS-based (OS): KVM, Fusion, VirtualBox, VMware Player, VMware ESX, Citrix XenServer, and Microsoft Hyper-V. VMware ESX, Citrix XenServer, and Microsoft Hyper-V are hypervisor-based. All of the others (KVM, Fusion, VirtualBox, VMware Player) are hosted. Note, however, that in KVM the host OS switches into a module to assume a hypervisor-like role, so the rest of the operating system plays a secondary, supporting role, like a privileged partition.
</details>

## Hardware Protection Levels
A virtualization solution has four requirements that follow from the definition above: it must present a virtual platform interface over the CPU, memory, and devices to each guest VM; it must isolate the guest VMs from one another; it must preserve the usual protection of the guest OS from faulty or malicious applications inside the same VM; and it must protect the VMM from the guest operating systems. The last two together mean the guest OS and the VMM cannot run at the same protection level, so a single faulty guest cannot take down the hypervisor and the whole machine. Isolation across VMs can reuse the same mechanisms an OS already uses, such as preemption and the memory management unit.

Commodity hardware has more than two protection levels. For example, x86 architecture has four protection levels, called **rings**.

Ring 0 has the highest privilege and can access all resources and execute all hardware-supported instructions. In a native model, the operating system resides at ring 0.

In contrast, ring 3 has the least privilege. This is where the applications reside. Whenever an application tries to perform some operation for which it does not have privilege, a trap will be caused and control will be switched to ring 0.

In virtualization setups, the hypervisor sits in ring 0, pushing the OS to ring 1. The applications remain at ring 3.

More recent x86 architectures introduce two different **protection modes**: **root** and **non-root**. Within each mode, the four rings exist.

When running in root mode, everything is permitted. The hypervisor resides in ring 0 of the root mode. In contrast, in non-root mode, certain types of operations are not permitted. Guest VMs operate in non-root mode, with their applications in ring 3 of this mode, and their OS in ring 0.

Attempts by the guest OS to perform privileged operations cause traps called **VMExits**, which trigger a switch to root mode, passing control to the hypervisor. When the hypervisor completes its operation, it passes control back to the virtual machine, by performing a **VMEntry**, which switches back into non-root mode, ring 0, so that execution continues.

## Processor Virtualization
Guest instructions are executed directly by the hardware. The VMM does not interfere with every instruction that is issued by the guest OS or its applications.

As long as the guest OS is operating within the resources allocated to it by the hypervisor, the instructions will operate at hardware speeds, which will underline the efficiency of the virtualization solution.

Whenever a privileged instruction is issued, the processor causes a trap to the hypervisor. At this point, the hypervisor can determine if the operation is to be allowed or not. If the operation is illegal, the hypervisor can perform some punitive action, like shutting down the VM. If the operation should be allowed, the hypervisor must provide the necessary emulation to ensure that the guest OS receives the response it was expecting from the hardware. This is known as the **trap-and-emulate** strategy.

The hypervisor intervention must be invisible to the guest OS.

> **Paper (Popek & Goldberg):** Trap-and-emulate is exactly the VMM construction the paper proves correct. In the paper's model a VMM is a control program with three parts: a *dispatcher* placed at the hardware trap entry point, an *allocator* that decides which resources a VM gets (and is invoked whenever a trapped instruction would change a VM's resources), and a set of *interpreter* routines, one per privileged instruction, that simulate the trapped instruction's effect. The whole scheme works only if every instruction that could affect resource control actually traps, which is the content of the theorem below.

> **Paper (Popek & Goldberg):** The paper classifies instructions precisely. A *privileged* instruction is one that traps when executed in user mode but not in supervisor mode. A *sensitive* instruction is one that is either *control sensitive* (it changes the resources available, such as memory, or changes the processor mode without going through the memory-trap sequence) or *behavior sensitive* (its result depends on the configuration of resources, that is, on its location in real memory, called location sensitivity, or on the processor mode, called mode sensitivity). Any instruction that is not sensitive is *innocuous*. Theorem 1 then states that for a conventional third-generation machine, a VMM can be constructed **if the set of sensitive instructions is a subset of the set of privileged instructions**, because that condition guarantees every instruction the VMM must mediate will trap. This is the formal statement the lecture compresses into "privileged instructions trap".

## x86 Virtualization in the Past
Before 2005, x86 platforms had only the four privilege rings, without the root/non-root distinction. The basic strategy for virtualization software was to run the hypervisor in ring 0, and the guest operating system in ring 1.

However, there were exactly 17 hardware instructions that were privileged (required ring 0), but didn't cause a trap. Issuing them from another protection level wouldn't pass control to the hypervisor, but would just fail silently.

> **Paper (Popek & Goldberg):** The lecture's phrasing, "privileged instructions that do not trap", is loose against the paper's own vocabulary, where a privileged instruction is *defined* to trap in user mode. The precise statement is that these 17 are *sensitive but not privileged*: they read or change privileged machine state (so they are sensitive) yet do not trap when issued outside ring 0 (so they are not privileged). They are exactly the instructions that violate Theorem 1's subset condition, which is why pre-2005 x86 could not be virtualized by trap-and-emulate alone. The count of 17 is not from this paper; it comes from Robin and Irvine's USENIX Security 2000 analysis of the roughly 250 Pentium instructions.

For example, enabling/disabling interrupts requires manipulating a bit in a privileged register, which can be done with the POPF/PUSHF instructions. When these instructions were issued, they just failed silently.

Since control isn't passed to the hypervisor, the hypervisor has no idea that the OS wanted to change the interrupt status, so it cannot emulate that behavior.

At the same time, since the failure was silent, the OS doesn't know about it and assumes the change was successful. As a result, it continues with its execution. It may then perform operations that, if interrupted, can leave it in a corrupt or deadlocked state, which is exactly what disabling interrupts was meant to prevent. This is a major problem, and it makes the trap-and-emulate approach not applicable to these architectures.

> **Paper (Rosenblum & Garfinkel):** This paper gives the two concrete x86 examples behind the problem. First, `POPF` (pop flags) is used to set and clear the interrupt-disable flag, but in unprivileged mode it does not trap; it silently ignores the change to the interrupt flag, so direct execution breaks for kernel code that uses it. Second, unprivileged x86 instructions let software read privileged state: a guest can read the code-segment register to see the processor's current privilege level, and because the read does not trap, the VMM cannot patch what the guest sees, so the guest observes the wrong (physical) privilege level rather than its virtual one.

<details>
<summary>Problematic instructions quiz spoiler</summary>

The quiz notes that on earlier x86 architectures the privileged CPU flags register was accessed via the POPF and PUSHF instructions, which failed silently if not issued from ring 0, where the hypervisor resides. What can occur as a result: the guest VM could not request interrupts to be enabled, could not request interrupts to be disabled, could not find out the state of the interrupts enabled/disabled bit, or all of the above? The correct answer is all of the above. Each of these operations requires access to the privileged register and execution of these instructions. When they fail silently, the guest assumes the request completed, and may end up interpreting some other information on the stack incorrectly, as if it were provided by that register. So none of these will be successful.
</details>

## Binary Translation
One way to solve the issue of the 17 hardware instructions was to rewrite the guest VM binary so that it never issues any of those 17 instructions. This process is called **binary translation**.

The goal pursued by binary translation is to run unmodified guest operating systems. We shouldn't need to install additional software or policies to alter the guest OS in order to run in a virtualized environment. When the guest OS is not modified, this type of virtualization is called **full virtualization**.

To avoid these bad hardware instructions, some interception and translation must take place at the virtualization layer. Instruction sequences - typically at some meaningful granularity like a basic block, such as a loop or a function - that are about to be executed are captured from the VM binary. This needs to be done at runtime, dynamically, because the exact execution sequence may depend on parameters that are available only at runtime (it is input dependent), so it cannot be done efficiently statically up front, and in some cases cannot be done at all without the input parameters.

The first step involves capturing and inspecting code blocks that are about to be issued to see if any of the 17 hardware instructions are present.

If the code block does not have one of these instructions, the block is marked as safe and allowed to execute at hardware speeds.

However, if one of the bad instructions is found, that instruction is translated into some alternate instruction sequence that still emulates the desired behavior.

Binary translation adds overheads! Mechanisms to reduce these overheads include caching translated code fragments and making sure to only analyze kernel code executed in the guest OS.

This approach was taken by VMware. The technique was pioneered by the Stanford research group led by Mendel Rosenblum, who went on to co-found VMware and is a co-author of the Rosenblum and Garfinkel paper for this lesson. Rosenblum was later named an ACM Fellow, credited specifically with reinventing virtualization; he served as VMware's chief scientist for about ten years and is now back full time at Stanford.

> **Paper (Rosenblum & Garfinkel):** The paper describes VMware's binary translation in more detail. It runs only the privileged (kernel) code under the translator, translating each block into a similar block with the problematic instructions replaced, and caches the result in a *trace cache* so a block is translated only on its first execution. The translated output "looks much like the results from the paravirtualized approach", normal instructions unchanged and problematic ones such as `POPF` and code-segment reads replaced, with one difference: the changes are applied when the code first executes rather than to the OS source. The paper also notes VMware's translation is simpler than cross-ISA binary translators because source and target instruction sets are nearly identical, and that binary translation is not only a correctness fix but a *performance* optimization, since it can remove frequently-trapping privileged instructions and so cut the trap overhead that is especially high on the deep pipelines of modern x86 CPUs. Once the trace cache is warm, performance is nearly indistinguishable from direct execution.

## Paravirtualization
Paravirtualization is the second way to deal with the 17 non-trapping x86 instructions. Rather than rewriting the guest binary at runtime, it gives up on the goal of running unmodified guests, instead focusing on performance and avoiding the overheads of supporting unmodified guests. In contrast to full virtualization, this is called **paravirtualization**.

In paravirtualization, the guest OS is modified so that it knows that it is running in a virtualized environment on top of a hypervisor as opposed to native physical resources.

A paravirtualized guest OS does not directly try to perform operations that it knows will fail (such as the problematic instructions, for example POPF issued from ring 1), but will instead make explicit calls to the hypervisor to request the desired behavior, specifically the desired hardware manipulations. These calls are called **hypercalls** and they behave similar to system calls. The unprivileged guest OS packages all relevant information about its context and current state, specifies the desired hypercall, and issues it. The hypercall traps to the hypervisor, which, upon performing the required operation with the data supplied by the guest, passes control back to the guest, along with any data, if appropriate.

This approach was originally adopted and popularized by the **Xen** hypervisor. Xen started as an open source research project at the University of Cambridge in the UK; it was later commercialized as XenSource, which is now owned by Citrix. The open source Xen project remains active, and the open source and Citrix versions have diverged, perhaps substantially, over time.

> **Paper (Rosenblum & Garfinkel):** The paper's canonical paravirtualization example is Disco, a VMM for the non-virtualizable MIPS architecture, rather than Xen (Xen is not discussed in the paper). Disco's designers replaced the MIPS equivalent of `POPF` and the code-segment read with accesses to a special memory location, which also removed traps on those privileged instructions and so improved performance. The paper frames paravirtualization generally as the VMM builder *replacing* the non-virtualizable parts of the instruction set with easily virtualized equivalents, so most ordinary applications still run unmodified while the OS must be ported. Its stated main drawback is incompatibility: a ported OS, vendor cooperation, no legacy operating systems, and no easy migration of existing machines. In spite of that drawback, academic projects favored paravirtualization because building a VMM with both full compatibility and high performance is a significant engineering challenge; VMware, aiming at fast, compatible x86 virtualization, built binary translation instead.

<details>
<summary>BT and PV quiz spoiler</summary>

The quiz asks which of the following will cause a trap, exit the VM, and pass control to the hypervisor for both binary translation and paravirtualized VMs: access to a page that has been swapped, or update to a page table entry. The first option is correct. If a page is not present, the hardware MMU will fault and pass control to the hypervisor regardless of the virtualization approach. The second option, update to a page table entry, is not always true: it depends on whether the OS has write permissions for the page tables that it uses or not (see the memory virtualization sections below).
</details>

## Memory Virtualization: Full Virtualization
For full virtualization, a key requirement is that the guest OS continues to observe a contiguous, linear physical address space that starts from physical address zero. This is what an operating system would see if it actually owned the physical memory.

To achieve this, we need to distinguish among three types of addresses: virtual addresses, physical addresses, and machine addresses.

Virtual addresses are used by the applications in the guest. Physical addresses are used by the kernel of the guest. Machine address correspond to the physical addresses on the underlying physical platform. The same virtual versus physical versus machine distinction also applies to page numbers and page frame numbers.

The guest OS makes mappings of virtual addresses to the physical addresses that it thinks it owns. Underneath, the hypervisor maintains a mapping of the physical addresses to the machine addresses. "Contiguous" physical addresses can map to discontiguous machine addresses.

In effect, there are two page tables: one maintained by the guest OS, and one maintained by the hypervisor.

At the hardware level, the MMU and TLB help with the address translation process and free us from having to implement these translations in software.

In this setup, the first address translation exists solely in software, and the second translation can potentially leverage hardware components.

This is too expensive since this will add overhead on every memory reference.

Another option is for the hypervisor to maintain a shadow page table. The hypervisor looks at the virtual addresses the guest has mapped to its physical addresses and, in the shadow page table, directly maps those guest virtual addresses to machine addresses. The hardware MMU uses the shadow page table, so the guest runs natively, with its virtual addresses translated directly to machine addresses, completely transparently to the guest OS.

The hypervisor will clearly have to maintain consistency between these two pages tables. The hypervisor will have to make sure to invalidate the shadow page table on context switch.

It will also have to make sure to write protect the page table in order to keep track of new mappings. The write protection is necessary to ensure that whenever the guest tries to establish new address mappings, it will trap into the hypervisor. During the trap, the hypervisor can update its shadow page table.

> **Paper (Rosenblum & Garfinkel):** The paper calls this the traditional technique and names the structure the *shadow page table*. It adds two points the lecture leaves out. First, because the VMM controls the shadow page table it can page a VM out to disk and so overcommit machine memory, letting the total memory allocated to VMs exceed physical memory; the catch is that the VMM lacks the guest's knowledge of which pages are good eviction candidates, which VMware's ESX Server addresses with a *balloon* process (today usually called a balloon driver) running inside the guest. When the VMM wants memory back it inflates the balloon, and the guest, using its own page-replacement knowledge, picks the pages to surrender. Second, running many similar VMs wastes memory on identical pages, which ESX Server reclaims with *content-based page sharing*: the VMM detects identical physical pages, points the shadow page tables at a single copy, and copies on write if the contents later diverge (for example, 30 Windows VMs needing only one copy of the kernel in memory). The paper flags hardware-managed shadow page tables as a promising future direction, which is the extended page table support described later in this note.

## Memory Virtualization: Paravirtualization
Since an OS knows that it is in a virtualized environment in paravirtualization, it is no longer a strict requirement that the guest OS uses contiguous physical memory starting at 0.

The guest OS can explicitly register its page tables with the hypervisor, so there is no need for two page tables.

The guest still doesn't have write permissions to this page table - which is now used directly by the hardware - as this would allow as guest to potentially corrupt another guest by overwriting its memory.

Because of this, every write to the page table will cause a trap to the hypervisor. However, since the guest is paravirtualized, we can modify the guest to batch page table updates into a single hypercall, amortizing the cost of the VM exit across multiple updates.

There can be other useful optimizations too, for example in how memory is managed, so that it is friendlier to execution in a virtualized environment or more cooperative with respect to other VMs in the system.

Many of the overheads associated with memory virtualization in both full and paravirtualization have been reduced by improvements on newer hardware platforms.

## Device Virtualization
When we talk about CPU/Memory virtualization, certain things are relatively less complicated because there is a significant level of standardization at the **instruction set architecture** (ISA) level across different platforms.

From a virtualization standpoint, we know that we have to support a specific ISA and we don't care if there are lower level differences between the hardware because it is up to the hardware manufacturers to be standardized at the ISA level.

This is the case for a specific ISA like x86.

When we look at devices, there is a much greater diversity in the type of devices. Also, there is a lack of standardization when it comes to the specifics of the device interface and the semantics of that interface.

To deal with this diversity, virtualization solutions adapt one of three key models to virtualize devices. These models were developed before any virtualization-friendly hardware extensions were made to the CPU architectures and chipsets; those later modifications make some aspects of device virtualization much simpler.

> **Paper (Rosenblum & Garfinkel):** The paper frames I/O virtualization historically and names the trend. Thirty years ago IBM mainframes used a *channel*-based I/O architecture, where a separate channel processor let the VMM export device access directly to the VM with very low overhead. The x86 world lost this: its huge, diverse device collection makes writing a VMM I/O layer a large effort, and some devices (graphics, high-speed network) have severe performance requirements. The paper's three concrete approaches only partly line up with this note's three models: the hosted architecture routes I/O through the host OS's drivers (highest overhead, used by VMware Workstation); ESX Server runs a traditional VMM that borrows Linux drivers directly (lower overhead, the hypervisor-direct model, feasible because relatively few server I/O devices are certified for major x86 server machines); and VMware also exports *optimized paravirtualized virtual devices* that do not match any real device and need a special guest driver, which is the split-device-driver idea. Looking forward, the paper predicts channel-like devices (USB, SCSI) and hardware support, DMA address remapping and interrupt routing to the right VM, that would let device drivers in the VM talk to the device directly with no trap into the VMM, which is the passthrough model made safe, and the I/O hardware virtualization described later in this note.

## Passthrough Model
In the **passthrough model**, the VMM-level driver is responsible for  configuring the access permissions to a device. For example, it will allow a guest VM to have access to the memory registers corresponding to a device.

![](https://assets.omscs.io/notes/DB8B54EB-D3C3-4EB0-A8F4-71163B1426E0.png)

In this approach, the guest VM has exclusive access to a device. In addition, the VM can directly access the device, without interacting with the VMM. This model is also called the **VMM-bypass model**.

The problem with this exclusive access is that is making sharing devices across VMs difficult. The hypervisor will need to continuously reassign who the device belongs to over time, and device access will not happen concurrently across VMs. This is often unfeasible.

Because the hypervisor is completely out of the way, the guest VM and the device driver in the guest VM directly operate on and control the device. This means that there needs to be a device of the *exact same type* on the physical platform that the guest OS expects.

One of the benefits of virtualization is that the guest VMs are decoupled from the physical hardware, which makes migration of guests across physical nodes easy.

This passthrough model breaks that decoupling as it binds a device to a VM. This reintroduces migration complexity as there may be some device specific/resident state that would need to be properly copied and configured at the destination node. VM migration then stops being a generic hypervisor and VM operation, and must be implemented in a way that deals with the specifics of each device of interest.

## Hypervisor Direct Model
In the **hypervisor-direct model**, the hypervisor intercepts every device access request that is performed by the guest VM.

![](https://assets.omscs.io/notes/4F00CAC7-1C7B-4065-A509-F7B57DD7FBE3.png)

The hypervisor no longer has the constraint that the requested device and the physical device match.

Instead, the hypervisor can translate the device access request to some generic representation of an I/O operation for that particular family of devices - network or disk, for example - and then traverse the hypervisor resident I/O stack. The bottom of that stack is the actual real device driver, which the hypervisor will finally invoke to fulfill the request.

A key benefit of this approach is that the VM remains decoupled from the physical platform/device. As a result, migration remains easy. In addition, device sharing can now occur since device access is managed by the hypervisor.

The downside of the model is that the device emulation step adds latency to device accesses. As well, this model requires that the hypervisor supports all of the drivers so it can perform the necessary emulations, which means that the hypervisor is now exposed to all of the complexities and complications of various device drivers.

This model was originally adopted by the VMware ESX hypervisor. Because of VMware's market share (vendors provide drivers for its hypervisor), the model was reasonable for VMware, and it has been sustained because of that.

## Split Device Driver Model
In the **split device driver model**, all of the devices accesses are controlled in a way that involves a component that resides in a guest VM and a component that resides in a hypervisor layer.

![](https://assets.omscs.io/notes/BECB3588-AFBF-42F2-9A1C-22916449B1B4.png)

The **front-end driver** resides in the guest VM and the actual driver for the physical device - the **back-end driver** - resides in the service VM (or the host in type 2 virtualization).

Although the back-end driver doesn't necessarily have to be modified, as it is the same driver that the OS would use as if it were running natively, the front-end driver does need to be modified.

The front-end driver needs to take the device operations that are made by the applications in the guest, and then wrap them in special messages that are passed directly to the back-end component in the service VM. Because of this modification, this model can only really be used in paravirtualized guests, which can explicitly install these special front-end drivers. The front-end drivers look like wrappers for the actual device API, so the applications in the guest do not have to be modified; they keep making the same device requests.

One benefit of this approach is that the device emulation overhead can be eliminated: the virtualization layer does not have to reverse engineer what the guest OS is trying to do, because the front-end driver tells it explicitly. Another benefit of this approach is that the centralized back-end component, which accepts requests from all guest VMs, allows for better management of shared devices, such as enforcing finer-grained policies regarding fairness and priorities.

## Hardware Virtualization
In the x86 world, the two virtualization-friendly architectures are the AMD Pacifica architecture and the Intel Vanderpool Technology architecture, both created circa 2005.

> **Paper (Rosenblum & Garfinkel):** Writing in 2005, the paper predicted this. It notes that Intel's Vanderpool and AMD's Pacifica had *announced* hardware support, and that rather than making the existing execution modes virtualizable, both add a *new execution mode* that lets a VMM safely use direct execution, reducing both the number of traps and the cost of each. The paper forecasts that with such support, direct-execution-only VMMs become possible on x86 (at least for guests that do not themselves use the new modes), that support as good as IBM's mainframe support would cut overhead further and simplify implementation, and that, as past experience shows, adequate hardware support makes a fully compatible VM abstraction worth more than any performance gain from breaking compatibility (that is, from paravirtualization). The note describes what actually shipped.

One of the first things that was fixed was to close the holes with the 17 non-virtualizable hardware instructions so that they will cause a trap and pass control over to the hypervisor in privileged mode.

> **Paper (Popek & Goldberg):** Closing these holes is precisely making x86 satisfy Theorem 1. Forcing the 17 sensitive-but-unprivileged instructions to trap moves them into the privileged set, so that the set of sensitive instructions becomes a subset of the privileged instructions and the trap-and-emulate VMM the paper proves constructible can again be built, this time directly in hardware rather than worked around by binary translation.

Also, the new protection mode was introduced. Now, there was a "root" and "non-root" mode (also known as "host" and "guest", respectively).

Support was added for the hardware processor to interpret the state of the virtual processors (or vCPUs). This information is captured in a per-vCPU control structure, called the **VM control structure** (VMCS) on Intel and the **VM control block** (VMCB) on AMD. The hardware understands how to "walk" this data structure, and can specify whether or not a system call should trap. This way, a particular type of operation need not trap into root mode and can instead be handled by the privileged layer in non-root mode, which is the guest operating system.

Once hardware was able to detect the presence of different VMs, the next step was to tag the memory structures used by the hypervisor with the different VM identifiers.

This led to support for extended page tables and tagged TLBs, both of which incorporated VM identifiers. This makes context switches by VMs (also called world switches) more efficient: the TLB entries belonging to the previous VM no longer have to be flushed or invalidated, because the MMU matches both the virtual address and the VM identifier against each TLB entry, and uses the entry only if both match.

Hardware was also extended to add better support for I/O virtualization, which included modifications to the processor and chipset. Some examples of these extensions were multiqueue devices (think of a single devices having multiple logical interfaces that can be used by multiple VMs) as well as better interrupt routing so that the core on which the VM is running is actually the core that gets interrupted.

Other features were added for better security, including protecting VMs from one another as well as from the hypervisor, and for better management support.

Finally, a number of new instructions were added to x86 in order to implement these new features. For example, a new instruction was added to allow switching into new protection mode, and new instructions were added to manipulate state in the per-VM control structure.

<details>
<summary>Hardware virtualization quiz spoiler</summary>

The quiz asks: with hardware support for virtualization, guest VMs can now run unmodified and can have access to the underlying devices; given this, is the split device driver model still relevant (yes or no)? The answer is yes. With the split device driver model, all requests for device access are consolidated in the service VM, where we can make better decisions and enforce stronger policies about how the device is shared, without relying on specific support for the desired sharing behavior on the physical device itself.
</details>

## x86 VT Revolution
Intel summarizes its virtualization advances along three dimensions, each a separate axis of hardware support.

The first vector is the CPU itself: fixing the non-virtualizable instructions and adding support such as extended page tables. These modifications are branded **VT-x**, with VT-x2 and VT-x3 in later processor generations.

The second vector is the chipset, including support for I/O virtualization technologies, I/O routing, and direct device access (for example SR-IOV at the platform level). These are branded **VT-d**.

The third vector pushes support down into the devices themselves, so devices integrate more easily into a virtualized environment. Examples include DMA remapping, so a device DMAs into the memory belonging to the correct VM, and multiple logical interfaces (queues) so a separate logical interface can be handed to each VM. This device-resident support is branded **IOV** (I/O virtualization) and **VMDq** (virtual machine device queues).

![](https://assets.omscs.io/notes/57D4D274-194C-4906-8331-48AC6C00F7FE.png)
