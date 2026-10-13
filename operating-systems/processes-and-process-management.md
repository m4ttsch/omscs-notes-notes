---
id: operating-systems-processes-and-process-management
title: Processes and Process Management
course: operating-systems
lecture: processes-and-process-management
---

# Processes and Process Management

**OSTEP chapters**:
* [4. The Abstraction: The Process](https://pages.cs.wisc.edu/~remzi/OSTEP/cpu-intro.pdf)
* [5. Interlude: Process API](https://pages.cs.wisc.edu/~remzi/OSTEP/cpu-api.pdf)
* [6. Mechanism: Limited Direct Execution](https://pages.cs.wisc.edu/~remzi/OSTEP/cpu-mechanisms.pdf)

## What is a Process?
A process is an instance of an executing program. The terms **task** and **job** are often used interchangeably with process.

One of the roles of the operating system is to manage the hardware on behalf of **applications**. When an application is stored on disk, it is static. Once an application is launched, it is loaded into memory and starts executing; it becomes a **process**. A process is an active entity.

If the same program is launched more than once, multiple processes will be created. They will have the same instructions, but very different state.

For example, one instance of a text editor might be displaying notes from a previous lecture that you're only reading. A second instance of the same editor is open for taking notes on the current lecture: barely any content yet, and some unsaved edits.

A process represents the execution state of an **active** application. It may not be running at every given moment, but it is an application that has been loaded and started. It might be waiting on user input, or waiting for another process that currently holds the CPU.

## What Does a Process Look Like?
A process encapsulates all of the state of a running application. This includes the code, the data, the heap, and the stack. Every element of the process state has to be uniquely identified by its address. An operating system abstraction used to encapsulate all of the process state is an **address space**.

The address space is defined by a range of addresses V_0 to V_max. Different types of process state will appear in different regions of the address space.

Different types of process state in an address space:
* The code
* The data available when process is first initialized (static state)
* Heap: Dynamically created state (what we create): memory the process allocates, intermediate results it stores, data it reads from files
	* Drawn as a contiguous region starting after the data, but in reality it may have holes
	* Those holes are regions that have no meaning for the process, and the process isn't permitted to access them; the OS tracks which addresses are valid
* Stack: Dynamically created state that grows and shrinks as the program executes
	* LIFO
	* Stack frames added and removed as functions are called and return

Say the process is executing and needs to call procedure `y`. The state it was in before the call has to survive, so it gets pushed onto the stack, and control jumps to `y`. When `y` returns, that state is popped back off and execution continues exactly as it was before the call.

![](https://assets.omscs.io/notes/9AA4A864-5E7F-40AB-9E02-A1EAB43D34E6.png)

## Process Address Space
Potential range of addresses in process address space go from V_0 to V_max. These addresses are called **virtual addresses**. They are virtual because they don't have to correspond to actual locations in the physical memory.

Memory management hardware and components of the operating system maintain a mapping between virtual memory addresses and physical memory addresses. By using this mapping, we can *decouple* the layout of the data in the virtual address space from the layout of the data in physical memory.

The virtual layout can be complicated, and it depends on the specifics of the application and on choices the compiler made about where to put things. None of that should constrain how physical memory gets managed.

For example, data may live at `0x03c5` in the virtual address space and this may map to `0x0f0f` in physical memory. When the process asks for memory at some virtual address, the physical address the OS actually hands out may be completely unrelated.

The operating system creates a mapping between the virtual address and the physical address so that processes can access their data without knowing its physical location. This mapping is called a **page table**.

![](https://assets.omscs.io/notes/2J14QLu.png)

## Address Space and Memory Management
Not every process needs the entire range from V_0 to V_max; parts of the address space may simply be unallocated. Separately, we may not have enough physical memory to store all a process's state even if we do need it.

With 32-bit virtual addresses, a single address space can span up to 4GB. If several such processes run at once, even a well-provisioned machine runs out of physical memory quickly.

To deal with this overflow, the operating system decides dynamically which portion of the process's address space will live in physical memory and which portion will be swapped temporarily to disk. Swapped-out regions get brought back in when they're needed, which may in turn force some other region (belonging to this process or another one) out to disk to make room.

Operating system must maintain a mapping from the virtual addresses to the physical addresses, and must also check the validity of memory accesses, to make sure that, say, process A isn't trying to write to memory mapped to by process B.

<details>
<summary>Virtual addresses quiz spoiler</summary>

If two processes P1 and P2 run at the same time, both can have the exact same virtual address space range (for example, 0 to 64,000). Because virtual addresses are decoupled from physical addresses, the OS maps P1's virtual addresses to one set of physical locations and P2's to another, so identical virtual ranges still resolve to distinct physical memory.
</details>

## Process Execution State
For an operating system to manage processes, it must have some idea about what a process is "doing". If the operating system stops a process, for example, it must know exactly what it was doing when it was stopped, so it can resume its execution with the exact same state.

Source code gets compiled into a binary, and that binary is a sequence of instructions. Those instructions are not necessarily executed in order: there are jumps, loops, and interrupts that redirect the flow.

At any given time the CPU must know where within a program's code a process currently is. The CPU's knowledge of the current executing line within a program is the **program counter**.

The program counter is maintained on a CPU's register while the program is executing. Other data related to a current process's state is also stored on CPU registers. These registers hold values that are necessary during execution: addresses for data, or status information that affects the execution of the instruction sequence.

Another piece of state that defines what a process is doing is the process's stack. The top of the stack is defined by the **stack pointer**. The stack is LIFO: whatever item came onto the stack last is the first item we can retrieve from it.

To maintain all of this useful information for every single process, the operating system maintains a **process control block** or PCB.

## Process Control Block
A process control block is a data structure that the operating system maintains for every process that it manages.

Process control block contains:
* process state
* process number
* program counter
* CPU registers
* memory limits, plus the virtual-to-physical memory mappings needed for address translation
* CPU scheduling info: how long this process has already run on the CPU, how much time it should get in the future, its priority
* list of open files
* and more!

The PCB is created when the process is initially created, and is also initialized at that time. For example, the program counter will be set to point at the very first instruction.

Certain fields of the PCB may be changed when process state changes. For example, virtual/physical memory mappings may be updated when the process requests more memory.

Some fields can change often, like the program counter. We don't want to waste time on every instruction changing the counter. The CPU maintains a dedicated register just for the program counter, and the CPU automatically updates that register on every new instruction.

It is the job of the operating system to collect all of the data about a process - stored within CPU registers - and save it to the PCB when the process is no longer running.

## How is a PCB Used?
PCBs are stored in memory on behalf of a process by the operating system until it comes time for the process to start/resume execution. At that point, the process's PCB is loaded from memory into CPU registers, at which point instruction execution can begin.

If a process is interrupted by the operating system - perhaps to give another process some CPU time - the operating system must pull the PCB out of CPU registers and save it back into memory.

Consider two processes P1 and P2, both already created with PCBs sitting in memory. P1 is running, which means the CPU registers currently hold P1's state. The OS decides to interrupt P1, so it saves those register values into P1's PCB. Then it restores P2's PCB into the CPU registers, and P2 runs.

Suppose P2 needs more memory partway through and calls `malloc`. The OS allocates it, establishes new virtual-to-physical mappings for P2, and updates P2's PCB accordingly.

When P2 is done executing, or when the OS decides to interrupt P2, the OS saves P2's state back into P2's PCB and restores P1's. The values being restored are the ones captured when P1 was interrupted, so **P1 resumes at the exact instruction where it left off.**

Each time the operating system switches between processes, we call this a **context switch**.

![](https://assets.omscs.io/notes/FA0C9097-CC39-422B-8281-20C1B8964C27.png)

## Context Switch
PCB blocks corresponding to each process will reside in memory until the operating system loads that data into the CPU registers, at which point the process can begin executing instructions.

A *context switch* is a mechanism used by the operating system to switch from the context of one process to the context of another process.

This operation is **EXPENSIVE**.

We incur *direct costs*, which are the number of CPU cycles required to load and store a new PCB to and from memory.

We also incur *indirect costs*. When a process is running on the CPU a lot of its data is stored in the processor cache. Accessing data from cache is *very* fast (on the order of cycles) relative to accessing data from memory (on the order of hundreds of cycles). When the data we need is present in the cache, we say that the cache is *hot*. When we context switch to another process, some or even all of the data belonging to the old process is replaced to make room for the data the incoming process needs. The next time it is swapped in, the cache is *cold*. That is, the data is not in the cache and the CPU has to spend many more cycles fetching data from memory.

In practice there isn't one cache but a *hierarchy* of them: L1, L2, on down to the last level cache. Each level is larger than the one before it and potentially slower, though all of them are far faster than going out to memory.

Basically, we want to limit how often we context switch!

<details>
<summary>Hot cache quiz spoiler</summary>

The quiz asks which options correctly complete the sentence "When a cache is hot...": (1) it can malfunction, so we must context switch to another process; (2) most process data is in the cache, so the process performance will be at its best; (3) sometimes we must context switch. Option 2 is the most correct one, and option 3 is correct as well; option 1 is wrong.

A hot cache has nothing to do with the physical temperature of the cache. The term refers only to accesses resolving in cache hits, which is when the process performs at its best.

Even so, a hot cache does not keep a process on the CPU. Sometimes we have to context switch away from one, because another process with higher priority needs to execute, or because a policy timeshares the CPU between two processes and this one's time has expired.
</details>

## Process Life Cycle: States
When a process is created, it is in the *new* state. This is when the OS performs admission control, and allocates/initializes the PCB and some initial resources for this process, provided minimum resources are available. At this point, the process moves to the *ready* state, where it is ready to start executing, but isn't currently executing. When the scheduler schedules the process and it moves on to the CPU it is in the *running* state. The process can be interrupted and a context switch can be performed. This moves the process back to the *ready* state. Alternatively, the running process may need to perform some I/O operation or wait on an event, at which point the process enters a *waiting* state. The process can then move back to *ready* when the I/O operation completes or the event occurs. Finally, a process can exit, with or without error, and at this point the process is *terminated*.

![](https://assets.omscs.io/notes/E65850CD-7381-48DB-A3AB-6E2A386428CD.png)

<details>
<summary>Process state quiz spoiler</summary>

The CPU can execute a process that is in the *running* or *ready* state. A running process is already executing; a ready process is only waiting for the scheduler to place it on the CPU. When a ready process is scheduled, it resumes from the instruction its program counter points to: the first instruction of the process if it was newly created, or wherever it was last interrupted (by the scheduler, or because it had to wait on I/O or an event).
</details>

## Process Life Cycle: Creation
In operating systems, a process can create one or more *child processes*. The creating process is the parent and the created process is the child. All of the processes that are currently loaded will exist in a tree-like hierarchy.

Once the operating system is done booting, it will create some *root* processes. The processes have privileged access.

When a user logs in, a shell process is created. When the user types a command, a new process is spawned as a child of that shell.

<details>
<summary>Parent process quiz spoiler</summary>

On UNIX-based systems, `init` is the first process that starts after the system boots. Every other user level process can ultimately be traced back to it, which is why `init` is referred to as the parent of all processes.

Android takes a different approach. Zygote is a daemon process whose purpose is launching app processes. It preloads the Android framework classes, and each new app process is created by forking Zygote, so the app inherits that preloaded framework and Zygote is the parent of all of the app processes.
</details>

Most operating systems support two mechanisms for process creation:
* fork
* exec

With **fork**, the operating system will create a new PCB for the child, and then will copy the exact same values from the parent PCB into the child PCB. The result is that both processes will continue executing with the exact same state at the instruction immediately following the fork (they have the same program counter).

With **exec**, the operating system will take a PCB (created via fork), but will not leave the values to match those of the parents. Instead operating system loads a new program, and the child's PCB will now point to values that describe this new program. The program counter of the child will now point to the first instruction of the new program.

For "creating" a new program, you have to call fork to get a new process, and then call exec to load that program's information into the child's PCB. Fork produces the process; exec replaces the image that fork created with the image of the new program.

## Role of the CPU Scheduler
For the CPU to start executing a process, the process must first be ready. At any given time, there may be many processes that are in the ready state, so the question becomes: how does the operating system decide which process to run next on the CPU?

This is determined by an operating system component known as the **CPU scheduler**. The CPU scheduler manages how processes use the CPU resources. It determines which process will use the CPU next, and how long that process has to run.

The operating system must be able to **preempt**; that is, interrupt the current process and save its context. This is **preemption**. The operating system must then run the scheduler to **schedule**, or select, the next process. Once the process is chosen, the operating system must **dispatch** the process and switch into its context.

Since CPU resources are precious, the operating system needs to make sure that it spends the bulk of its time running processes, NOT making scheduling decisions.

The scheduling *algorithms* need efficient designs and efficient implementations, and so do the *data structures* that hold the waiting processes and whatever information feeds the scheduling decision, such as priorities and execution history.

![](https://assets.omscs.io/notes/DAF29EA9-7360-4F5C-9765-8D39E7FFB6EF.png)

## Length of Process
One issue to consider is how often we run the scheduler. Put another way, the operating system has to make smart decisions about how long a process can run.

We can calculate a measure of CPU efficiency by looking at the amount of time spent executing a process divided by the total duration of the interval, which includes the time spent scheduling.

Call the time a process runs `T_p` and the time the scheduler takes `T_sched`. `T_p` is the time allocated to a process that has been scheduled to run, the time that process can consume on the CPU. This time is known as the **timeslice**.

Over an interval containing two of each, useful work as a fraction of total time is:

```
2 * T_p / (2 * T_p + 2 * T_sched)
```

For example, if the number of blocks of time spent scheduling equals the number of blocks spent executing, and the length of an execution block is the same as the length of a scheduling block, then the CPU *efficiency* is only 50%!

On the other hand, if the same number of blocks are spent scheduling as are spent executing, but the process runs for 10 times the length of the scheduling block, the efficiency increases to roughly 91%.

![](https://assets.omscs.io/notes/F718D68A-984A-41AD-9EFD-09FDF30C2093.png)

When designing a scheduler, we have to make important design decisions:
* What are appropriate timeslice values?
* What criteria is used to decide which process is the next to run?

## What about I/O
The hardware the OS manages includes I/O devices (keyboards, network cards, disks), not just CPU and memory.

When a process makes an I/O request, the operating system will deliver that request, and move the process to the **I/O queue** for that particular I/O device. The process will remain in the queue until the device completes the operation and responds, after which the process will move back to a ready state. If nothing else is waiting ahead of it in the ready queue, it might be scheduled on the CPU immediately.

Processes can end up on the ready queue in four ways:

1. A process was waiting on an I/O event, and the event completed.
2. A process was running on the CPU and its timeslice expired.
3. A new process was created via `fork`.
4. A process was waiting for an interrupt, and the interrupt occurred.

![](https://assets.omscs.io/notes/80BB70E4-B83B-42C4-9860-760D5AC3EA7C.png)

<details>
<summary>Scheduler responsibility quiz spoiler</summary>

Of the listed items, the ones that are NOT the CPU scheduler's responsibility are maintaining the I/O queue and deciding when to generate an event a process is waiting on: the scheduler has no control over when I/O operations occur or when external events are generated. The exception is the timer interrupt, which the scheduler does influence. Maintaining the ready queue and deciding when to context switch ARE scheduler responsibilities.
</details>

## Inter-Process Communication
Can processes interact? YES! It is common today that an application consists of multiple processes, so it is important that one process can talk to another.

Example: Web application! Web server running in one process, database running in another.

These mechanisms that allow processes to talk to one another are known as **inter-process communication (IPC)**.

The OS goes to considerable lengths to isolate processes from one another: separate address spaces, controlled CPU allocation, memory that one process cannot reach from another.

These mechanisms help to transfer data/information between address spaces while maintaining protection and isolation. The interactions they need to support vary a lot: periodic data exchanges, a continuous stream flowing between processes, or several processes coordinating on one shared piece of information, so these mechanisms need to be flexible and performant.

### Message Passing IPC
Operating system establishes a communication channel - like a shared buffer, for instance - and the processes use that to communicate. One process can write/send through the channel, while the other can read/recv from the channel.

In *message passing*, the sending process explicitly puts the information it wants to send into a message, and sends that message to this dedicated communication channel.

Benefits of this approach is that the operating system will manage this channel, and it provides the exact same APIs, the exact same system calls, to both sides for write/send and read/recv. Neither process has to implement the protocol itself.

Downsides are overhead. Every single piece of information to be transmitted needs to be copied from address space of sending process into memory allocated to the kernel, and then finally into the address space of the receiving process.

![](https://assets.omscs.io/notes/0BE38751-7D8F-4DCB-AA5F-D4CF90216EAE.png)

### Shared Memory IPC
The operating system establishes a shared memory channel, and then maps it into the address space of both processes. The processes are then allowed to directly read/write to this memory the same way they can read/write from any memory allocated to them in their address space.

The operating system is out of the *fast path* in this case: it isn't involved in the individual exchanges, so the processes incur no OS overhead on each read and write. That is the main benefit.

The OS does still have to establish the mapping, and mapping memory between two address spaces is expensive, so shared memory only wins if that one-time setup cost is amortized across enough messages. For a small number of exchanges, message passing can be the better choice.

The disadvantage to this approach is that because the OS is out of the way, a lot of the APIs that were taken for granted in message passing IPC have to be reimplemented. Without a fixed, well-defined API governing how the shared region gets used, the code also tends to be more error-prone.

![](https://assets.omscs.io/notes/4F0200FD-93B6-4D98-B703-9C4EC18A6B18.png)

<details>
<summary>Shared memory quiz spoiler</summary>

"Shared memory-based communication performs better than message passing" is neither simply true nor false: it depends. Individual data exchanges are cheap because nothing is copied in and out of the kernel, but mapping memory between two processes is itself expensive. Shared memory only wins when that one-time setup cost is amortized across a sufficiently large number of messages.
</details>
