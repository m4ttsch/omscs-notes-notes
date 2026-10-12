---
id: operating-systems-final-exam-review-questions
title: Final Exam Review Questions
course: operating-systems
lecture: final-exam-review-questions
---

# Final Exam Review Questions

This document provides thorough, exam-ready answers to all final exam review questions for the Operating Systems course, organized by lecture (P3L1 through P4L4). Answers are drawn from the course lectures and the referenced papers (Fedorova et al. on scheduling, Anderson on spinlocks, Popek & Goldberg and Rosenblum & Garfinkel on virtualization, Birrell & Nelson on RPC, Nelson, Welch & Ousterhout on the Sprite file system, and Protic et al. on distributed shared memory). Where relevant, pseudocode, comparison tables, and quantitative formulas are included. Where a lecture diverges from its assigned paper, the lecture's exam-facing version is given first and the paper's account is marked inline as `(Lecture framing: ...; Paper, <Author>: ...)`; paper-only additions are marked `(Paper, <Author>: ...)`.

## P3L1

### How does scheduling work? What are the basic steps and data structures involved in scheduling a thread on the CPU?

Scheduling is the operating system's job of deciding how and when the ready tasks in the system get to run on the shared CPUs. It applies to both user-level and kernel-level tasks. The scheduler's single objective is to pick the next task to run from the ready queue, and it is invoked whenever the CPU becomes idle or could usefully be reassigned.

#### When the scheduler runs

The scheduler is dispatched on any of these events:

- A running task completes or exits.
- A running task blocks (for example, it issues an I/O request and is moved to a device wait queue), freeing the CPU.
- A new task becomes runnable, or a task returns from a wait queue, which may warrant preempting the current task.
- A timeslice (time quantum) expires on a timesharing system.

#### Core data structure: the runqueue

The central data structure is the **runqueue** (the ready queue). It is only *logically* a queue. Its concrete form is chosen to match the scheduling policy, because the policy and the structure are tightly coupled:

| Policy | Natural runqueue form |
|---|---|
| First-Come-First-Serve (FCFS) | Simple FIFO queue |
| Shortest Job First (SJF) | Ordered queue or balanced tree keyed on run time |
| Priority | One FIFO queue per priority level |
| Multi-level feedback | Several queues, each with its own timeslice and rules |
| Linux CFS | Red-black tree keyed on virtual runtime |

A structure optimized for one policy is usually a poor fit for another. For FCFS the scheduler needs only the head of the queue; for SJF it must efficiently locate the minimum-runtime task, so a sorted structure or tree is preferable.

#### Steps to put a thread on the CPU

1. The scheduler selects a task from the runqueue according to the policy and removes it.
2. The task is **dispatched**: the OS context switches to it, enters user mode, sets the program counter to the task's next instruction, and begins execution.
3. If the policy uses timeslices, a timer is armed so the scheduler regains control when the quantum expires.
4. On preemption, timeslice expiry, or a block, the scheduler saves the task's context and returns it to the appropriate (and possibly different) runqueue, then selects and context switches to the next task.

The decision of *which* task to pick is the scheduling policy; *how* the pick is executed efficiently depends on the runqueue structure.

### What are the overheads associated with scheduling? Do you understand the tradeoffs associated with the frequency of preemption and scheduling/what types of workloads benefit from frequent vs. infrequent intervention of the scheduler (short vs. long timeslices)?

#### The overheads

The dominant overhead is the cost of **context switching** and running the scheduler itself: interrupting the running task, executing the scheduling algorithm, saving the old context, and loading the new one. There are two components:

- **Direct cost**: CPU cycles spent saving and restoring register state and running the scheduler.
- **Indirect cost**: cache pollution. When a new task runs, the previously hot cache is now cold for it, so it suffers cache misses while its working set is refetched. This indirect cost is often larger than the direct cost.

A timeslice is only worthwhile when it is **substantially longer than the context-switch time**. If the context switch costs 0.1 seconds and the timeslice is 1 second, roughly 9% of time is overhead; stretching the timeslice to 5 seconds cuts that to about 2%.

#### The frequency tradeoff

Frequent preemption (short timeslices) lowers the time any task waits before first running and makes the system more responsive, but it multiplies context-switch overhead, which lowers throughput and raises average completion time. Infrequent preemption (long timeslices) amortizes overhead and improves throughput and completion time, at the cost of longer waits.

#### Which workloads prefer which timeslice

| Workload | Preferred timeslice | Why |
|---|---|---|
| CPU-bound | Long (ideally infinite) | The user perceives completion, not start, so wait time barely matters. Fewer context switches keep CPU utilization and throughput high. With no preemption at all the metrics are best. |
| I/O-bound | Short | A short quantum lets the task issue its I/O request sooner, then block and yield. This keeps the device busy, hides I/O latency behind other tasks, and keeps user-perceived response time low. |

The subtlety for I/O-bound tasks: when such a task issues a blocking request every quantum, it yields *voluntarily* before the timeslice expires, so lengthening the timeslice changes nothing for a pure-I/O mix. The timeslice length only becomes visible when I/O-bound and CPU-bound tasks are mixed. If a CPU-bound task holds a long timeslice, a co-resident I/O-bound task is forced to wait for that quantum to expire, its I/O latency can no longer be hidden, device utilization drops, throughput falls, and its wait time balloons. That is precisely why a shorter timeslice helps the mixed case.

### Can you work through a scenario describing some workload mix (few threads, their compute and I/O phases) and for a given scheduling discipline compute various metrics like average time to completion, system throughput, wait time of the tasks...

#### The metric definitions

Let tasks arrive (for simplicity) at time 0. For each task record its **start** time (first instant on the CPU) and its **finish** (completion) time.

- **Throughput** = number of tasks / total time to finish all tasks.
- **Average completion time** = mean of (finish_i - arrival_i) over all tasks.
- **Average wait time** = mean of (start_i - arrival_i) over all tasks.

Two rules that are easy to forget:

- Context switching takes time; add it between tasks when preemption actually occurs.
- An I/O-bound task that blocks cannot hide its latency if there is no other runnable task to switch to, so the device service time must be added to the timeline in that case.

#### Worked example 1: three tasks, run-to-completion, arrive at 0

T1 = 1s, T2 = 10s, T3 = 1s, arriving T1 then T2 then T3. Ignore context-switch cost.

**FCFS** (order T1, T2, T3):

| Task | Start | Finish |
|---|---|---|
| T1 | 0 | 1 |
| T2 | 1 | 11 |
| T3 | 11 | 12 |

- Throughput = 3 / 12 = 0.25 tasks/s.
- Average completion = (1 + 11 + 12) / 3 = 8.00 s.
- Average wait = (0 + 1 + 11) / 3 = 4.00 s.

**SJF** (order T1, T3, T2):

| Task | Start | Finish |
|---|---|---|
| T1 | 0 | 1 |
| T3 | 1 | 2 |
| T2 | 2 | 12 |

- Throughput = 3 / 12 = 0.25 tasks/s.
- Average completion = (1 + 2 + 12) / 3 = 5.00 s.
- Average wait = (0 + 1 + 2) / 3 = 1.00 s.

Throughput is unchanged (same total work), but SJF improves both completion and wait by front-loading the short jobs. The catch is that SJF assumes the run times are known in advance, which is unrealistic; in practice they are estimated from heuristics such as the last run time or a windowed average of recent runs.

**Round robin, timeslice = 1s** (same arrival): T1 runs 0 to 1 and finishes; T2 runs 1 to 2 then is preempted; T3 runs 2 to 3 and finishes; T2 resumes 3 to 12 (nothing left to preempt it) and finishes.

- Average completion = (1 + 12 + 3) / 3 = 5.33 s.
- Average wait = (0 + 1 + 2) / 3 = 1.00 s.

Round robin matches SJF's wait time and comes close on completion time without needing any a priori knowledge of run times.

#### Worked example 2: CPU-bound timeslice sizing with context-switch cost

Two CPU-bound tasks of 10s each, context switch = 0.1s.

- **Timeslice = infinite (run to completion):** T1 (0 to 10), T2 (10 to 20). No switch cost. Average wait = (0 + 10) / 2 = 5.00 s; average completion = (10 + 20) / 2 = 15.00 s.
- **Timeslice = 1s:** the two tasks interleave 1s at a time with a 0.1s switch between slices, so total time stretches to about 21.9s. Average wait drops (T2 starts at 1.1s instead of 10s), but throughput and average completion both degrade because of the repeated switch cost.

This is the quantitative basis for "CPU-bound tasks want long timeslices." (Lecture note on the course graphic: for the 5-second CPU-bound case the average wait is 2.55s, not 3.05s; the lecture slide contains a division error that the errata corrects.)

#### Worked example 3: a mixed CPU/I/O timeline

Two tasks, 10s of work each, context switch = 0.1s; each issues an I/O request every 1s of compute and the I/O takes 0.5s. If both are I/O-bound, each yields after 1s regardless of the timeslice, so a 1s and a 5s timeslice produce identical timelines and metrics. Make T1 CPU-bound and T2 I/O-bound and the picture changes: with a 5s timeslice T1 holds the CPU, T2 cannot issue its request until T1's quantum expires, its 0.5s I/O latency is no longer overlapped with T1's compute, total execution time grows, throughput falls, and T2's wait time rises. With a 1s timeslice the two interleave, T2's I/O overlaps T1's compute, and device utilization stays high. This is the mixed case that argues for short timeslices for I/O-bound work.

### Do you understand the motivation behind the multi-level feedback queue, why different queues have different timeslices, how do threads move between these queues... Can you contrast this with the O(1) scheduler? Do you understand what were the problems with the O(1) scheduler which led to the CFS?

#### Motivation for the multi-level feedback queue (MLFQ)

The scheduler cannot know in advance whether a task is CPU-bound or I/O-bound, and a task's behavior can change over its lifetime. The MLFQ is a single structure that holds several queues, each with a different timeslice and its own scheduling rules, and it *learns* which queue a task belongs in by observing its behavior. It is not merely a stack of priority queues; the feedback mechanism is the point.

#### Why different queues have different timeslices

Different tasks have different needs, so the queues offer different quanta:

- The **topmost queue has the shortest timeslice**, suited to I/O-bound tasks. Because an I/O-bound task issues a blocking request and yields quickly, a short quantum lets it get on and off the CPU fast, hiding I/O latency and keeping the device busy.
- **Lower queues have longer timeslices**, suited to CPU-bound tasks, which are penalized by frequent context switches and benefit from longer uninterrupted runs.

#### How threads move between queues

- A new task enters at the **top** (shortest timeslice).
- If a task **yields or blocks before its quantum expires**, that confirms it is I/O-bound; it stays at (or is returned to) that short-timeslice queue.
- If a task **uses its entire quantum and must be preempted**, it is more CPU-bound than assumed, so it is pushed **down** to a queue with a longer timeslice. Repeated preemption pushes it further down.
- If a task sitting in a lower queue starts yielding early due to I/O waits, the scheduler **boosts** it back up to a shorter-timeslice queue.

The feedback signal is simply preemption (CPU-bound) versus voluntary yield (I/O-bound). Solaris uses an MLFQ with 60 levels and its own promotion/demotion rules.

#### The Linux O(1) scheduler

The O(1) scheduler (introduced in Linux 2.5) selects and enqueues a task in **constant time regardless of the number of tasks**. It is preemptive and priority-based with **140 priority levels**:

- **0 to 99**: real-time priorities.
- **100 to 139**: timesharing priorities. User tasks default to 120 and are adjusted by a **nice value** from -20 to +19 (mapping to 100 through 139).

As in MLFQ, each priority level has an associated timeslice, but the assignment is inverted from the naive intuition: the scheduler gives the **smallest timeslices to the lowest-priority (CPU-bound) tasks** and the **largest timeslices to the higher-priority interactive tasks**. The feedback rule is based on **sleep time** (time spent idle or waiting): a task that sleeps more is treated as interactive and has its priority boosted (priority - 5); a task that sleeps little is treated as compute-bound and is penalized (priority + 5), bounded within the timesharing range.

The runqueue is two arrays of pointers, **active** and **expired**:

- The scheduler always picks from the **active** array, using a bitmask-and-find-first-set-bit trick to locate the highest-priority non-empty level in constant time.
- A task that yields or is preempted with time left in its quantum returns to the **active** array at its level.
- A task that **exhausts its entire timeslice** moves to the **expired** array.
- Only when the active array is empty do the two arrays **swap**.

Giving the lowest-priority tasks the smallest timeslices here is deliberate: since they only run after all higher-priority tasks, a small quantum ensures they do not block the important tasks for long once they do get the CPU.

#### Why O(1) gave way to CFS

The structural flaw: once a task lands in the expired array it cannot run again until **every** task in the active array has exhausted its timeslice. For an interactive, latency-sensitive application (the canonical example is a voice call such as Skype), this introduces unacceptable **jitter**. More broadly, the O(1) scheduler made no real **fairness** guarantee: it did not ensure a task received CPU time in proportion to its priority over a given interval. These problems motivated the **Completely Fair Scheduler** (CFS), the default for non-real-time tasks since Linux 2.6.23.

#### The CFS replacement

CFS keeps its runnable tasks in a **red-black tree** (a self-balancing binary tree) ordered by **vruntime** (virtual runtime), the time a task has spent running, tracked to nanosecond granularity. Nodes to the left have smaller vruntime (more deserving of the CPU); nodes to the right have larger vruntime. The algorithm:

1. Schedule the **leftmost** node (least vruntime), which takes constant time to find.
2. Periodically increment the running task's vruntime and compare it to the leftmost node's. If the running task still has the smallest vruntime it keeps running; otherwise it is preempted and reinserted into the tree at its new position.
3. Priority is encoded in the **rate** at which vruntime advances: for low-priority tasks vruntime advances quickly (time passes "faster," so they are checked and preempted sooner); for high-priority tasks it advances slowly (they run longer before being overtaken).

Selection is O(1); insertion is O(log n) in the total number of tasks in the system. That log(n) insertion cost is the theoretical limit on scaling CFS to very large task counts.

### Thinking about Fedorova's paper on scheduling for chip multi processors, what's the goal of the scheduler she's arguing for? What are some performance counters that can be useful in identifying the workload properties (compute vs. memory bound) and the ability of the scheduler to maximize the system throughput?

#### The goal of the scheduler

Fedorova argues that chip multithreading (CMT) hardware, which combines chip multiprocessing with hardware multithreading so that several threads share a core's pipeline, needs a scheduler that **maximizes system throughput by managing resource contention**, not just by balancing load. On such a platform each hardware context looks to the OS like a logical processor, and co-scheduled threads compete for the shared **processor pipeline**. The scheduler's job is to assign threads to contexts so that pipeline contention is minimized and overall utilization is maximized. (Paper, Fedorova et al.: the headline simulation result is that a CMT-aware scheduler can improve application performance by as much as a factor of two over a naive one.)

The key insight is that the best mix co-schedules threads with **complementary** resource needs. Co-scheduling two compute-bound threads makes them contend for the pipeline and each degrades (roughly by half in the two-thread model) while the memory system sits idle. Co-scheduling two memory-bound threads leaves the pipeline idle while both wait on memory. A **mix of one compute-bound and one memory-bound thread** keeps both the pipeline and the memory system busy and is the best case.

#### IPC, and the proposed CPI metric

Utilization is usually read through **instructions per cycle (IPC)**. Under the lecture's model each thread can issue one instruction per cycle, so per core the maximum IPC is 1; a compute-bound thread approaches IPC = 1, and a memory-bound thread, stalled on memory, has an IPC well below 1. In the four-core experiment the aggregate IPC maxes out at 4.

Fedorova proposes using **cycles per instruction (CPI)**, the reciprocal of IPC, as the scheduling signal. A compute-bound thread completes an instruction almost every cycle, so its CPI is about 1; a memory-bound thread stalls for many cycles per instruction, so its CPI is high. (Lecture framing: the lecture says Fedorova "speculates" that CPI is useful and frames high CPI as "takes many cycles, therefore memory-bound"; Paper, Fedorova et al.: more assertive, saying mean CPI "gives us a useful window into the dynamic instruction mix" and "nicely captures average instruction delay," and reasons through single-threaded CPI, the CPI a thread would show on a dedicated core, where a high value means low pipeline resource demand.)

#### The CPI experiment and its conclusion

Because the real processor has no CPI counter, she uses a simulator modeling 4 cores with 4 hardware contexts each, 16 contexts total. (Lecture framing: the lecture calls this a "4-way SMT" platform; Paper, Fedorova et al.: it actually models fine-grained multithreading, one set of functional units interleaving threads with a context switch every cycle and at most one instruction issued per cycle, and explicitly names SMT as the design it did *not* build.) The course treats SMT, hyperthreading, and CMT as synonyms. She builds a synthetic workload of 16 threads with CPIs of 1, 6, 11, and 16 (four of each), where CPI = 1 is the most compute-bound and CPI = 16 the most memory-bound, and runs four schedules that place different mixes on each core, using IPC as the metric.

The result: schedules that spread high- and low-CPI threads **across** cores (a well-mixed assignment) kept the pipeline well utilized and produced high IPC, while schedules that clustered similar-CPI threads onto the same core produced low IPC. (Paper, Fedorova et al.: the balanced schedules perform about twice as well as the fully clustered one and about 1.5 times better than the partially clustered one. In the bad schedules the cores packed with CPI-1 threads are saturated while the other cores are under-utilized.) The exam-facing conclusion is that **scheduling threads with mixed CPI values yields higher platform utilization**.

She then asks whether this synthetic spread is realistic by profiling real benchmarks. The exam-facing takeaway is that **real CPI values cluster together rather than spreading out the way the synthetic workload did, so CPI by itself may not be an instructive scheduling metric in practice**. (Lecture framing: this pessimistic conclusion, and the "2.5 to 4.5" clustering range, come from the lecture graphic; Paper, Fedorova et al.: optimistic, it says measured CPI "can vary by an order of magnitude among applications," that near-term CPI is predictable from recent behavior, and that building a CPI-balancing scheduler "should be a simple matter of engineering." The paper's own stated limitations are different: CPI does not reveal *which* resource threads contend for, such as the cache hierarchy or a floating-point unit, and CPI measured on an already-busy system is perturbed by existing contention.) The lecture's skeptical conclusion is retained as the exam answer because it aligns with Fedorova's later USENIX 2005 work, which found L2 cache contention, not pipeline CPI, to be the dominant effect.

#### Useful performance counters

Modern platforms expose **hardware counters** that update as the processor executes, read through interfaces such as oprofile or the Linux `perf` tool. The ones useful for classifying a thread and judging utilization:

- **IPC** (or its reciprocal CPI): near 1 (IPC) suggests compute-bound; low IPC / high CPI suggests memory-bound.
- **Cache miss counters** (L1, L2, last-level cache): a high LLC miss rate suggests the thread is memory-bound, though it can instead mean a cold cache after the thread has entered a new execution phase; few misses suggest compute-bound.
- **Power/energy counters**: additional input for the scheduler's model.

Software sleep-time tracking, used earlier to tell interactive from compute-bound tasks, does not work here: a thread stalled on memory is not sleeping on a software queue, and software accounting is far too slow when a hardware context switch costs only cycles. Schedulers therefore combine several counters, often through platform-specific models trained on known workloads, to pick a thread mix that keeps all system components busy with minimal mutual interference.

## P3L2

### How does the OS map the memory allocated to a process to the underlying physical memory? What happens when a process tries to access a page not present in physical memory? What happens when a process tries to access a page that hasn't been allocated to it? What happens when a process tries to modify a page that's write protected/how does COW work?

#### Mapping virtual to physical memory

The OS gives each process its own **virtual address space** and maps it to physical DRAM using **page tables**, which it maintains per process. The virtual address space is divided into fixed-size **pages**; physical memory is divided into **page frames** of the same size. A page table maps pages to frames: a virtual address is split into a **virtual page number (VPN)** and an **offset**; the VPN indexes the page table to produce a **physical frame number (PFN)**, and the PFN combined with the offset gives the exact physical address. Keeping page and frame sizes equal means only the frame's base needs translating; the offset carries straight through.

The hardware **memory management unit (MMU)** performs the translation on every reference and uses the page table entry's bits to validate it. On x86 a dedicated register (**CR3**) points to the active process's page table, and it is reloaded on every context switch.

Physical memory is assigned lazily by **allocation on first touch**: when a process first accesses a newly allocated virtual region, the OS takes a free frame and creates the page table entry at that moment, so memory that is reserved but never touched costs no physical frames.

#### Access to a page not present in physical memory

Each page table entry has a **present (valid) bit**. If a page has been swapped out to disk, its present bit is 0. When the process accesses it, the MMU sees present = 0 and raises a **page fault**, trapping into the kernel. The page fault handler recognizes the page lives on secondary storage, brings it back into a free frame, and **re-establishes the mapping**, which will almost certainly point to a different PFN than before (the whole point of virtual addressing). The faulting instruction's program counter is then reset so the reference re-executes and now succeeds.

#### Access to a page not allocated to the process

The MMU again raises a fault, but the handler determines the virtual address is **not part of any valid region** of the process's address space. This is an illegal access; the OS typically delivers a segmentation violation (**SIGSEGV**) to the offending process, which usually terminates it. The distinction from the previous case is made by consulting the error code and the faulting address (on x86 the faulting address is placed in the **CR2** register and an error code is pushed on the kernel stack).

#### Modifying a write-protected page, and copy-on-write

Page table entries carry **protection bits** (read / write / execute). Writing a page marked read-only triggers a protection fault. Normally that is punitive and ends the program, but the mechanism is also exploited productively for **copy-on-write (COW)**, most notably on `fork`:

1. Rather than physically copy the parent's entire address space into the child, the OS points the child's page tables at the **same physical frames** as the parent and marks those frames **read-only (write-protected)** for both.
2. As long as either process only reads, they safely share one copy, which is cheap and fast.
3. When one of them attempts a **write**, the MMU traps into the kernel on the protection fault. The kernel now **copies that single page** into a new frame, updates the writing process's page table entry to point to the private copy with write permission, and lets the write proceed.

COW thus defers and minimizes copying: only the pages that are actually written are ever duplicated, and purely static regions shared between parent and child are never copied at all.

### How do we deal with the fact that processes address more memory than physically available? What's demand paging? How does page replacement work?

#### Why the problem exists

A process's virtual address space can be far larger than physical DRAM. On a 32-bit architecture each process can address 2^32 = 4GB; with 8GB of RAM, three processes could each ask for 4GB and together demand far more than exists. The resolution is **swapping / demand paging**: physical memory holds only the pages currently in use, and the rest live on secondary storage (disk).

#### Demand paging

Under demand paging the OS **swaps pages out to disk** when the amount of occupied memory reaches a threshold (and CPU usage is low enough), choosing pages that have not been used recently. Swapping a page out clears its **present bit** to 0. A later access to that page makes the MMU trap into the kernel; the OS allocates a free frame, reads the page back from disk, and re-establishes the mapping. The restored page's physical address is generally **different** from where it lived before, which is exactly why virtual addresses are used. After the page is back, the program counter is reset to the trapping instruction and the reference completes successfully.

#### Page replacement

When memory is under pressure a **page-out (swap) daemon** chooses victim pages to evict. The guiding policy is **Least Recently Used (LRU)**: a page used recently is likely to be used again soon, so evict the one not used for the longest time. Two page table entry bits inform the choice:

- The **access (reference) bit** indicates whether a page has been accessed, approximating recency for LRU.
- The **dirty bit** indicates whether a page has been written since it was brought in. A clean page can be dropped without a disk write (its on-disk copy is still valid), while a dirty page must be written back. Since disk writes are expensive, the daemon prefers to evict clean pages.

Replacement is typically triggered when free memory falls below a threshold, and may also prefer pages that will not be needed soon. Linux by default uses a variant of LRU with a **second chance**: it makes **two scans** of the pages before deciding to swap one to disk, giving recently referenced pages an opportunity to survive an eviction pass.

### How does address translation work? What's the role of the TLB?

#### The translation path

Every virtual address issued by the CPU is first presented to the **translation lookaside buffer (TLB)**, a small hardware cache of recent virtual-to-physical translations held in the MMU. If the TLB holds the entry (a **TLB hit**), the physical address is produced immediately and the full page table need not be consulted. On a **TLB miss**, the hardware walks the page table to find the translation, writes the result into the TLB, and then the access proceeds through the TLB. The OS maintains the page tables, but accesses are serviced through the TLB.

#### How the page table produces an address

In the simplest single-level scheme, the virtual address is a **VPN** plus an **offset**. The VPN indexes the page table to yield a **PFN**; the PFN concatenated with the offset is the physical address. The TLB entry also carries the **protection and validity bits**, so the MMU can validate the access and raise a fault directly from a TLB hit without touching memory.

#### Why the TLB matters

A single-level page table already requires **two memory accesses per reference**: one to read the page table entry, one for the data itself. With a hierarchical (multi-level) page table the number of accesses grows with the number of levels, so a four-level table needs four page-table reads before the data read. The TLB collapses all of that into a **single lookup** on a hit. Despite being small, the TLB achieves a high hit rate because memory references exhibit strong **temporal and spatial locality**. On modern x86 cores the TLB is split, for example a 64-entry data TLB and a 128-entry instruction TLB per core, backed by a shared 512-entry second-level TLB.

### Do you understand the relationships between the size of an address, the size of the address space, the size of a page, the size of the page table...

#### The general relationships

Let the address be **X bits** and the page offset be **Y bits** (so the page size is 2^Y bytes). Then:

- **Addressable space** = 2^X bytes (the number of distinct addresses).
- **Offset / page size**: a Y-bit offset gives a page of **2^Y bytes**.
- **Number of VPNs / page table entries** = 2^X / 2^Y = **2^(X-Y)** entries, because the top (X - Y) bits form the VPN and a flat page table needs one entry per VPN.
- **Page table size** = number of entries x entry size = **2^(X-Y) x (entry size)**.

#### The 32-bit worked example

With X = 32 and 4KB pages (Y = 12):

- Addressable space = 2^32 = 4GB.
- Entries = 2^(32-12) = 2^20 (about one million).
- Each entry holds a PFN plus flag bits and is **4 bytes** on a 32-bit architecture.
- Page table size = 2^20 x 4 bytes = **4MB**, per process.

#### The 64-bit blow-up

With X = 64, 4KB pages, and 8-byte entries, a flat table would need 2^3 x 2^64 / 2^12 = 2^55 bytes, on the order of **32PB per process**. This is why flat tables are abandoned for hierarchical ones. Two points to keep in mind: a page table is a **per-process** structure, and a real process uses only a small fraction of its theoretical address space, yet a flat table reserves an entry for **every** VPN whether used or not, which is precisely the waste hierarchical tables eliminate.

### Do you understand the benefits of hierarchical page tables? For a given address format, can you workout the sizes of the page table structures in different layers?

#### The benefit

A hierarchical (multi-level) page table maps the address space **without an entry for every VPN**. A two-level table has an outer **page table directory** whose entries point to inner **page tables**, each of which maps a smaller slice of the address space and points to actual frames. Inner tables are created only for virtual regions that are actually used, so **gaps in the address space cost nothing**: if a span the size of one inner table's coverage is unallocated, the corresponding directory entry is simply null and no inner table exists. The amount of mapping the OS maintains then tracks the memory the process actually uses, rather than its theoretical maximum. The tradeoff is **more memory accesses per translation** (one per level) and therefore higher translation latency, which the TLB mitigates.

Adding more levels makes each inner structure cover a smaller region, so gaps are more likely to align with a structure's granularity and let whole directories go unallocated. This matters most on **64-bit** platforms, where address spaces are enormous and sparse, so two, three, and four-level tables are used to keep the structures small.

#### Working the sizes from an address format

Split the virtual address into index fields, one per level, plus the offset. Each field's bit width gives the number of entries in that level's structure, and the offset width gives the page size.

**Example A (32-bit, split 12 / 10 / 10):** outer index 12 bits, inner index 10 bits, offset 10 bits.

- The **directory** holds 2^12 entries, so the OS can maintain up to 2^12 inner page tables.
- Each **inner page table** holds 2^10 entries.
- Each inner entry addresses 2^10 bytes (the page size).
- Therefore each inner page table maps 2^10 x 2^10 = 2^20 bytes = **1MB** of the address space. Any unallocated 1MB-aligned gap needs no inner table at all.

**Example B (the multi-level reduction, 12-bit addresses, offset 6):** address split 2 / 4 / 6, so pages are 2^6 = 64 bytes. A flat table with a 6-bit VPN needs 2^6 = 64 entries no matter what is used. In the two-level scheme each of the 4 outer entries covers 2^(4+6) = 1KB of the space. For a process using only the first 2KB and the last 1KB, one outer entry maps to an unallocated 1KB region and needs no inner table; the other three inner tables hold 2^4 = 16 entries each, for 48 entries total, a 25% reduction over the flat 64-entry table.

The procedure generalizes: for each level, entries = 2^(index bits for that level); the coverage of one entry at a given level = (page size) x the product of the entry counts of all levels below it.

## P3L3

### For processes to share memory, what does the OS need to do? Do they use the same virtual addresses to access the same memory?

#### What the OS must do

Separate processes each have their own virtual address space, backed by their own page tables, so by default a physical page that belongs to one process is unreachable from another. To let two or more processes share memory, the OS has to make a region of physical memory reachable from each participating address space. Concretely:

1. Allocate a set of physical frames to serve as the shared region. These frames do not have to be physically contiguous.
2. For each participating process, install page table entries that map some range of that process's virtual addresses onto those same physical frames.
3. Enforce the usual protection bits (read/write/execute) and keep the mapping valid until the processes detach or the segment is destroyed.

Once those mappings exist, reads and writes that land in the shared range are visible to every process attached to the region, with no further OS involvement. System calls are needed only during setup and teardown.

#### Mechanisms

- **SysV shared memory**: the OS maintains shared memory as *segments* identified by a system-wide key. A process creates or opens a segment (`shmget`), the key is generated so independent processes can agree on it (`ftok`), the segment is attached into the address space (`shmat`), detached (`shmdt`), and controlled or destroyed (`shmctl` with `IPC_RMID`). Segments are system-wide persistent resources: a segment survives detachment and lives until explicitly destroyed or the system reboots. This differs from ordinary process-local memory, which is reclaimed when the process exits. The OS caps the number and total size of segments.
- **POSIX shared memory**: uses files rather than segments. The "files" live in the `tmpfs` in-memory filesystem, so the OS reuses file data structures to represent pages of physical memory. A region is created or opened with `shm_open`, mapped with `mmap`, unmapped with `munmap`; `shm_unlink` removes the backing object. Because a file descriptor names the region, no key-generation step is needed.
- **Memory-mapped files**: a file mapped into multiple address spaces is another route to the same effect.

#### Do processes use the same virtual addresses?

No, and in general they cannot be forced to. The virtual addresses each process uses to reach the shared region are independent and are typically different. With `shmat` the programmer may request a specific virtual address, but passing `NULL` lets the OS pick whatever addresses are convenient in that process. What matters is the mapping, not the address value: the OS arranges that some subset of each process's virtual addresses resolves, through that process's own page tables, to the same physical frames. The physical backing is shared; the virtual addresses pointing at it are per-process.

A direct consequence for programmers: you cannot store a raw pointer (an absolute virtual address) inside the shared region and expect another process to dereference it correctly, because that address is only meaningful in the writer's address space. Shared data structures must use offsets relative to the start of the region, not absolute pointers.

### For processes to communicate using a shared memory-based communication channel, do they still have to copy data from one location to another? What are the costs associated with copying vs. (re-/m)mapping? What are the tradeoffs between message-based vs. shared-memory-based communication?

#### Is copying eliminated?

Copying is reduced but not necessarily eliminated. The goal of both message-based and memory-based IPC is to move data from one process's address space to another's. With shared memory, the data is only visible to the peer if it physically resides in the shared region. If a process produces data somewhere else in its own address space, it must copy that data into the shared region before the peer can see it, and the peer may copy it back out. The copy is avoided only when a process allocates and operates on the data in place within the shared region to begin with. One common case where a copy is saved entirely: if a process only needs to *read* arguments the peer left in the region, it can work on them in place rather than copy them elsewhere first.

So the honest statement is: shared memory removes the *mandatory* kernel-mediated copies of message passing, but any copies the application does to marshal data into and out of the shared region remain the application's responsibility.

#### Copy cost vs. map cost

| | Message-based (copy) | Shared-memory (map) |
|---|---|---|
| What the CPU spends cycles on | Copying data into and out of the kernel channel on every send/receive | Mapping physical pages into address spaces (setup); possibly copying into the region |
| User/kernel crossings | Every `send` and `recv` is a system call | Only during setup/teardown |
| Cost of one request-response | 4 user/kernel crossings and 4 data copies | Mapping is a one-time cost, then zero per operation |
| Cost structure | Per-operation, recurring, scales with data size | Large but fixed, amortized over the channel's lifetime |

Message passing pays a recurring per-message tax: data is copied from the sender into the kernel-managed channel, then from the channel into the receiver, with a user/kernel context switch each way. A full request-response cycle therefore costs four crossings and four copies. Shared memory pays a large but one-time mapping cost. That setup cost can be amortized across many operations, and for a large enough transfer it pays off even on a single request-response, because the time to copy a large payload through the kernel exceeds the fixed cost of establishing the mapping.

Windows exploits exactly this crossover with **Local Procedure Calls (LPC)**: payloads below a size threshold are copied through a port-like channel, while larger payloads are copied once into a page-aligned area that is then mapped into the target's address space.

#### Message-based vs. shared-memory tradeoffs

**Message-based IPC**
- Pro: simplicity. The kernel manages the channel, the synchronization, and the data movement. The developer writes `send`/`recv` and little else.
- Pro: the OS can layer on useful semantics (message priorities, scheduling, flow control; a socket can carry an entire protocol stack such as TCP/IP, and the same API works across machines).
- Con: overhead. Every operation is a system call with a copy, so a request-response costs four crossings and four copies.
- Forms: pipes (byte stream, two endpoints, no message boundaries), message queues (OS understands discrete, possibly prioritized messages), sockets (`send`/`recv` through a kernel buffer, works within a host or across the network).

**Shared-memory IPC**
- Pro: low per-operation cost once established; the kernel is out of the data path, so no per-operation system calls or kernel copies.
- Con: the developer must now handle everything the kernel used to: synchronization (shared memory is concurrently accessible, so accesses must be coordinated to avoid races), the communication protocol, and management of the region (how many segments, how large, how to handle messages larger than a segment).
- Con: the setup cost is high, so it only pays off when amortized.

Rule of thumb: prefer message passing for small, infrequent, or simple exchanges where developer simplicity dominates; prefer shared memory for large or high-frequency transfers where the per-operation copy cost of messaging would dominate and the mapping cost can be amortized.

### What are different ways you can implement synchronization between different processes (think what kind of options you had in Project 3).

Data placed in shared memory can be accessed concurrently by every attached process, so the same race conditions that arise among threads arise among processes, and the accesses must be synchronized. Whatever mechanism is chosen must provide two capabilities: coordinating *how many* processes access the region concurrently (the role a mutex plays) and signaling *when* data is ready to be consumed (the role condition variables and signals play). There are three practical options.

#### 1. Pthreads mutexes and condition variables marked process-shared

The same pthreads mutexes and condition variables used among threads can synchronize processes, with two requirements:

- Initialize the synchronization variable with the `PTHREAD_PROCESS_SHARED` attribute (set `pshared` on the mutex/condition-variable attribute struct before initializing the primitive). Without this, the primitive is private to the creating process.
- The synchronization variable itself must live in the shared memory region. A mutex sitting in one process's private memory is invisible to the other process; it has to be placed inside the shared segment alongside the data it protects.

A typical layout casts the attached segment to a struct holding both the data buffer and the mutex (and any condition variables), so the lock and the data it guards travel together in shared memory.

Caveat: `PTHREAD_PROCESS_SHARED` is not supported on every platform, which motivates the OS-level alternatives below.

#### 2. Semaphores

Semaphores are an OS-supported synchronization construct well suited to IPC. A binary semaphore has two states, 0 and 1. A process arriving at a semaphore with value 1 decrements it to 0 and proceeds; this is equivalent to acquiring a lock. A process arriving at a value of 0 blocks. When the holder finishes with the shared state it increments (posts) the semaphore, releasing a waiting process. A binary semaphore thus behaves like a mutex across processes. SysV and POSIX both provide semaphore APIs, and the POSIX semaphore has a `pshared` flag indicating whether it is shared across processes.

#### 3. Message queues to coordinate shared-memory access

Message passing and shared memory can be combined: a message queue coordinates access to a shared region. For example, process A writes data into shared memory and sends a "ready" message into the queue; process B receives the message, reads the data, and sends an "ok" message back. In a client-server shape, a client sends a request message asking the server to place a response in shared memory, then waits on a semaphore associated with that region, which the server posts after writing its response. This uses the simplicity of message passing for signaling while keeping the bulk data transfer in shared memory.

On Linux the SysV message queue calls are `msgget` (obtain a queue id), `msgsnd` (send), `msgrcv` (receive), and `msgctl` (control), mirroring the shape of the SysV shared memory API.

## P3L4

### To implement a synchronization mechanism, at the lowest level you need to rely on a hardware atomic instruction. Why? What are some examples?

#### Why an atomic is required

A lock operation must *check* whether the lock is free and, if it is, *set* it to busy. Expressed in ordinary instructions this is a read-modify-write sequence that spans multiple CPU cycles:

```c
spinlock_lock(lock) {
    while (lock == busy)
        ; // spin
    lock = busy;   // check and set are separate steps
}
```

The check and the set are distinct operations separated in time. Between a thread observing that the lock is free and that thread writing busy, another thread can run, observe the same free value, and also proceed. Two threads then believe they hold the lock, which defeats mutual exclusion. The problem is that the check and the set are not performed as an indivisible unit.

The fix is a hardware instruction that performs the check and the set as one indivisible step. The hardware guarantees two things for such an instruction:

- **Atomicity**: the operation happens completely or not at all; no other operation can interleave between its read and its write.
- **Mutual exclusion at the hardware level**: cores cannot execute the atomic on the same location in parallel. Concurrent attempts are serialized by the memory system and performed one at a time.

With an atomic the lock becomes correct:

```c
spinlock_lock(lock) {
    while (test_and_set(lock) == busy)
        ; // spin
}
```

The first arriving thread calls `test_and_set` on a lock whose value is 0; the instruction atomically sets it to 1 (busy) and returns the old value 0, so that thread proceeds. Every later thread calls `test_and_set`, sees it already set, has 1 returned, and spins. Only one thread can win because only one atomic executes against the location at a time.

#### Examples

- `test_and_set`: atomically read the old value and set the location to 1 (or busy). The most widely available atomic.
- `read_and_increment` (fetch-and-increment): atomically read the current value and increment it; the queueing lock relies on this to hand out tickets.
- `compare_and_swap`: atomically compare the location against an expected value and, only if equal, write a new value.

Which atomics a platform offers, and how efficiently each runs, varies by hardware. Software built on a specific atomic therefore has to be ported to use an atomic the target supports, and ideally the most efficient one available there.

### Why are spinlocks useful? Would you use a spinlock in every place where you're currently using a mutex?

#### Why spinlocks are useful

- **Simplicity**: a spinlock is one of the simplest synchronization primitives, both to implement and to reason about. A thread that fails to acquire simply loops, re-checking the lock until it becomes free or the thread is preempted.
- **Foundational**: precisely because they are simple, spinlocks serve as the building block for more complex synchronization constructs.
- **Low latency and low delay**: latency is the time to acquire a free lock, and a spinlock acquires one with a single atomic. Delay is the time between a lock being released and a waiter acquiring it; a spinning thread notices the release almost immediately, so when the lock is freed the next contender picks it up with essentially no handoff delay. This matters when the critical section is short.

#### Would you replace every mutex with a spinlock?

No. The defining behavioral difference is what a waiter does when the lock is held:

| | Spinlock | Mutex |
|---|---|---|
| Behavior while waiting | Spins on the CPU, burning cycles re-checking the lock | Blocks and relinquishes the CPU to another thread |
| Cost of waiting | Wasted CPU cycles for the whole wait | Context-switch cost to block and later wake |
| Good when | Critical section is short; expected wait is less than the cost of blocking and resuming; or there is no other work for the CPU to do | Wait is long; the CPU could do useful work meanwhile |

A spinning thread does no useful work and prevents another runnable thread from using that core. If the critical section is long, the waiter wastes a large number of cycles that a blocking mutex would have handed to a thread that could make progress. So a spinlock is a good choice only when the expected wait is short enough that spinning costs less than the two context switches a block-and-resume would incur (or when the core has nothing else to run). A mutex, by yielding the CPU on contention, is the better choice when waits can be long. Replacing every mutex with a spinlock would waste CPU on exactly the long-held locks where blocking pays off.

### Do you understand why is it useful to have more powerful synchronization constructs, like reader-writer locks or monitors? What about them makes them more powerful than using spinlocks, or mutexes and condition variables?

The value of higher-level constructs is **expressiveness** and the **reduced opportunity for error** that comes with it. Mutexes and condition variables are low-level and correct but awkward and error-prone to use directly.

#### The limits of mutexes and condition variables

- **Limited expressive power**: mutexes and condition variables cannot easily express arbitrary synchronization conditions such as "many readers may proceed together, but a writer needs exclusive access." The readers/writer problem needed **helper variables** to express its invariants (number of active readers, whether a writer is present), and priority restrictions need helper variables too, because mutexes and condition variables lack the expressive power to represent them.
- **Easy to misuse**: it is easy to lock or unlock the wrong mutex, or to signal the wrong condition variable. These mistakes are not obviously wrong at the call site and compile fine. The programmer is responsible for every lock, unlock, wait, and signal, and every one is a chance to introduce a bug.

#### Why reader/writer locks are more powerful

A reader/writer lock (also called a shared/exclusive lock) lets the developer declare only the *kind* of access intended, read or write, and the lock enforces the correct policy behind the scenes: readers share concurrently, writers get exclusive access. The developer no longer hand-builds and hand-maintains helper variables, so the application semantics are expressed directly in higher-level code with less room for error.

(Semantics vary across implementations: whether a recursively acquired read lock is released all at once or one level at a time; whether a reader may upgrade to a writer in place or must release and re-contend; and whether an arriving reader is admitted when a writer is already waiting, which couples lock state to thread priority and scheduling policy.)

#### Why monitors are more powerful

A monitor is a higher-level construct that bundles a shared resource, the entry procedures that access it, and any condition variables for waking waiters. The locking and checking happen automatically on entry to a procedure, and the unlocking and signaling happen automatically on exit, all hidden from the programmer. Because the explicit lock/unlock and wait/signal calls are no longer written by hand, the most error-prone step is removed. Historically monitors appeared in the Mesa runtime at Xerox PARC; Java provides them through per-object locks and `synchronized` methods, where the compiler inserts the locking and checking (the one operation still explicit in Java is `notify`).

#### The general point

Lower-level primitives force the programmer to encode high-level intent out of binary locks and manual signaling, which is both inexpressive and easy to get wrong. Constructs like reader/writer locks and monitors raise the level of abstraction so the intended synchronization policy is stated directly and the mechanical, bug-prone bookkeeping is handled by the construct. Other examples in the same spirit: serializers (hide explicit signaling and make priorities easy to express), path expressions (specify a regular expression describing legal operation interleavings), barriers and rendezvous points (block until n threads arrive), and wait-free constructs such as read-copy-update (RCU) that avoid explicit locking altogether. All of them ultimately rest on hardware atomics.

### Can you work through the evolution of the spinlock implementations described in the Anderson paper, from basic test-and-set to the queuing lock? Do you understand what issue with an earlier implementation is addressed with a subsequent spinlock implementation?

The evolution is driven by three performance metrics, which trade off against one another:

- **Latency**: time to acquire a free lock. Best case is a single atomic.
- **Delay (waiting time)**: time between a lock being released and a waiter acquiring it.
- **Contention**: traffic generated on the shared bus or interconnect by the atomic memory references and the resulting cache-coherence traffic. Contention slows every CPU's memory access and, worst of all, slows the acquisition and release of the lock itself.

Background that drives the contention behavior: atomic instructions bypass the cache and go to the memory controller, and executing an atomic triggers cache-coherence traffic (invalidate or update) across all cached copies of the location regardless of whether the value changed. Under write-invalidate coherence, that means every atomic forces other spinners to miss and re-fetch. (Lecture framing: atomics "always bypass the cache"; Paper, Anderson: a teaching simplification, because real implementations cooperate with the cache, for example taking the dirty value from the holding cache under write-back invalidation; what is genuinely unavoidable is the arbitration and the coherence traffic, with the invalidation happening before the instruction executes even if the value does not change.)

Each stage below fixes a specific flaw in the previous one.

#### Stage 1: Test-and-set

```c
spinlock_lock(lock) {
    while (test_and_set(lock) == busy)
        ; // spin directly on the atomic
}
```

Every spin iteration executes the atomic.

- **Latency**: optimal. A single atomic acquires a free lock; nothing can beat it.
- **Delay**: good. The thread spins directly on the atomic, so the very next instruction after the lock is freed detects it and acquires it.
- **Contention**: poor. Because every spinning processor issues an atomic on every iteration, and atomics bypass the cache and go to memory, the processors continuously hammer the memory module and the shared bus, delaying all other CPUs. (Paper, Anderson: the holder must itself contend with the spinners for exclusive access just to release the lock, so even the release is delayed behind doomed atomics.)

**Problem to fix**: the constant stream of atomics from every spinner saturates the interconnect.

#### Stage 2: Test-and-test-and-set ("spin on read" / spin on cached value)

```c
spinlock_lock(lock) {
    while (lock == busy || test_and_set(lock) == busy)
        ; // first test reads the cached value; atomic only when it looks free
}
```

The idea is to separate the *test* from the atomic. (Paper, Anderson: the spin-on-read idea is credited to Segall and Rudolph, who call it spinning on test-and-test-and-set.) The first clause reads the lock's cached copy; with short-circuit evaluation the atomic (`test_and_set`) runs only when the cached read shows the lock free. While the lock stays busy, spinners loop on their local caches without touching memory.

- **Latency and delay**: slightly worse than pure test-and-set, because of the extra read step.
- **Contention**: it depends on the coherence strategy.
  - No cache coherence (NCC): no improvement; every reference goes to memory anyway.
  - Write-update coherence: improved, since spinners read updated cached values; but the moment the lock is freed, all processors see it free at once and all rush to atomic simultaneously.
  - Write-invalidate coherence: still bad. Executing one atomic invalidates every cached copy even if the value did not change, forcing every other spinner to miss and go to memory to re-read; so each atomic from any processor cascades into misses on all the others.

**Problem to fix**: everyone sees the release at the same instant and stampedes the atomic (the "all rush at once" / thundering-herd behavior), and under write-invalidate the cascade of invalidations and re-reads is severe. (Lecture framing: the lecture describes what happens on release, not a steady state; Paper, Anderson: the sharper claim is a *transient* one, a "quiesce" period after each release during which some processors have pending read misses and others have pending doomed test-and-sets, each failing test-and-set re-invalidating every copy. For a *short* critical section this transient dominates, so spin-on-read "has almost as much effect on busy processors as spinning directly on a test-and-set"; the paper measured time-to-quiesce growing linearly with the number of spinners.)

#### Stage 3: Delay-based locks

Introduce a delay so that not every spinner attempts the atomic at the same moment, directly attacking the stampede.

**Delay after noticing the lock is free:**

```c
spinlock_lock(lock) {
    while (true) {
        while (lock == busy) ;      // spin on cached value
        delay();                     // back off before trying the atomic
        if (lock == busy) continue;  // someone else took it; keep spinning
        if (test_and_set(lock) == free) break;
    }
}
```

When a spinner sees the lock free, it waits before attempting the atomic. By the time its delay expires another thread may already have taken the lock, so the spinner re-checks the cached value and only issues the atomic if the lock still looks free. Fewer processors issue doomed atomics.

- **Latency**: okay. Still a reference to bring the lock into cache plus the atomic, comparable to before.
- **Delay**: worse. A thread that sees the lock free must wait before acquiring; if there is no contention, that wait is pure waste.
- **Contention**: much improved, because the atomics are spread out in time rather than fired simultaneously.

**Delay after every reference** (the alternative placement): delay on every spin iteration, not only when the lock looks free.
- Benefit: works even on NCC architectures, where every reference goes to memory regardless, by cutting how often a spinner references memory.
- Cost: hurts delay even more, since the thread delays on every reference, and the delay grows with the length of the critical section (a long critical section inflates every spinner's delay even though contention has not actually risen).

**Choosing the delay:**
- **Static delay**: a fixed value derived from, for example, the CPU id. Simple, and under heavy load it spreads atomics out well. But under light load it imposes pointless waits; a high-id CPU may wait a long time even with no contention.
- **Dynamic delay**: each thread picks a random delay from a range that grows with *perceived* contention, estimated by counting failed `test_and_set` operations (more failures imply more contention). Adapts to actual load, so it avoids the unnecessary waits static delay suffers under light load. (Lecture framing: the lecture does not mention that these schemes are borrowed from network arbitration; Paper, Anderson: models a lock as a CSMA network: statically assigned slots come from BRAM, static mean delays between references from Aloha, and dynamic delay from Ethernet's exponential backoff, which doubles a processor's mean delay on each collision, caps the mean delay at the number of processors, and restarts each visit at half the previous delay. The paper also warns the analogy is imperfect, because a network collision aborts all parties equally while a test-and-set "collision" still lets one processor win.)

**Problem to fix**: the delay trades contention for delay. It reduces wasted atomics but introduces artificial waiting time, and it still does nothing about the fundamental fact that, under invalidation, each release still forces every spinner to miss and re-read to learn the lock is free.

#### Stage 4: Queueing lock (Anderson's array lock)

Instead of letting all spinners share one lock variable and all see the release at once, give each waiter its *own* location to spin on, and have the releaser signal exactly one successor.

Structure:
- An array of flags with up to `n` entries, one per processor; each entry is either `has_lock` or `must_wait`.
- A pointer to the current holder's slot (value `has_lock`) and a `queuelast` pointer to the last slot in line.
- On arrival a thread atomically fetches a "ticket" (its position) and advances `queuelast`. Because several threads may arrive together, the increment of `queuelast` must be atomic, which requires `read_and_increment`.
- Each thread's flag entry acts as its private lock: it spins while its entry reads `must_wait`.
- To acquire, a thread waits until its own entry becomes `has_lock`.
- To release, the holder signals only its immediate successor: `flags[ticket + 1] = has_lock`.

```c
// init: flags[0] = has_lock; flags[1..n-1] = must_wait; queuelast = 0
spinlock_lock(flags, queuelast) {
    myplace = read_and_increment(queuelast);   // atomic: take a ticket
    while (flags[myplace mod n] == must_wait)
        ; // spin on my own private flag
    flags[myplace mod n] = must_wait;          // reset for reuse
}
spinlock_unlock(flags, myplace) {
    flags[(myplace + 1) mod n] = has_lock;     // tap only the next thread
}
```

(Lecture framing: the narration has the holder reset its own slot to `must_wait` on release, just before signaling the next one, while the lecture slide, like the code above, resets it right after acquiring; Paper, Anderson: the slot is reset inside the lock routine, right after the spin ends.) Either works.

- **Latency**: worst of the set. `read_and_increment` is a more complex atomic than `test_and_set` and costs more cycles, plus some extra per-acquire bookkeeping.
- **Delay**: good. The releaser directly signals the one next-in-line thread, which is already spinning on exactly that flag.
- **Contention**: best of all the designs. The atomic (`read_and_increment` on `queuelast`) executes once up front on arrival, not on every spin. Each thread spins on a *different* variable, so when the holder writes one successor's flag, only that one cache entry is affected; the other spinners' caches are not invalidated. The invalidation traffic for the atomic variable is unrelated to the flag each thread spins on.

Conditions for the contention win: the architecture must be cache coherent (otherwise spinning on a flag means remote references), and each flag must sit on its own cache line (otherwise writing one flag invalidates the whole line and disturbs every spinner sharing it).

Costs: it needs `read_and_increment`, which is less commonly available than `test_and_set`, and it uses `O(n)` space, one slot per processor, where every other lock needed a single location.

**Problem fixed**: the queueing lock eliminates both the stampede and the invalidation cascade that plagued test-and-test-and-set under write-invalidate. Only one thread is signaled per release, and private per-thread spin locations mean a release does not invalidate every waiter's cache line.

(Paper, Anderson: caveats the lecture leaves out. Queueing makes the *preemption* problem worse, because if any queued spinner is preempted, every thread behind it must wait when it reaches the front until it is rescheduled, which can force lock-step behavior for small, frequently accessed critical sections; and queueing makes it hard to wait on several locks at once, since a thread can be in only one queue. The design was devised independently by Graunke at Sequent. On the measurement platform, the Sequent Symmetry, which has an atomic increment but no read-and-increment that returns the old value, Anderson's own measured queueing lock had to protect its sequence number with a separate backoff lock.)

#### Summary table

| Lock | Latency | Delay | Contention | Fixes what / needs what |
|---|---|---|---|---|
| Test-and-set | Best | Good | Poor: every spinner issues an atomic every iteration | Baseline |
| Test-and-test-and-set | Slightly worse | Slightly worse | Varies; bad under write-invalidate | Stops spinning on the atomic; but all see release at once and invalidation cascades |
| Delay (after free / after each ref) | Okay | Worse (artificial wait) | Much improved | Spreads out atomics to kill the stampede; trades delay for contention; "after each ref" also works on NCC |
| Queueing (array lock) | Worst (needs read_and_increment) | Good (direct successor signal) | Best; most scalable | Per-thread private spin location kills the invalidation cascade and stampede; needs cache coherence, separate cache lines, O(n) space |

#### Empirical results (Sequent Symmetry, 20 processors, cache coherent with write-invalidate)

- Under **high load**: the queueing lock performs best and is the most scalable: as more processors and load are added it performs best. Test-and-test-and-set performs worst, because write-invalidate forces on the order of `N^2` memory references to maintain coherence per release (on the order of `N` spinners each read-miss and then atomic, and each atomic re-invalidates all `N` copies). Among delay locks, static beats dynamic slightly (dynamic has randomness and more collisions), and delaying after each reference is slightly better than after each release.
- Under **light load**: test-and-test-and-set does well thanks to its low latency; dynamic delay beats static (static imposes needless large delays at low contention); the queueing lock does *worst*, because of its higher latency (complex atomic plus extra per-acquire work).

(Lecture framing: the headline result names the queueing lock as the winner under contention and stops there, and the `N^2` figure is the lecture's and the course quiz's accounting; Paper, Anderson: the paper's own conclusion names *two* joint winners: backoff and queueing both scale well, with backoff better under no contention, lower latency and simpler, and queueing better when there are waiting processors, because it parallelizes the handoff by doing the atomic's work before the lock is released. The paper states the same cascade in prose and notes that fixing any single cause still leaves bus activity growing linearly with the number of processors. The comparison figure plots spin-waiting *overhead*, elapsed minus a simulated ideal, not raw time, and pure test-and-set is omitted from it.)

## P3L5

### What are the steps in sending a command to a device (say packet, or file block)? What are the steps in receiving something from a device? What are the basic differences in using programmed I/O vs. DMA support?

#### The device interface

Every device exposes a small set of control registers that the CPU can read and write across the CPU/device interconnect (typically PCI Express on modern platforms, with legacy PCI/PCI-X for compatibility). These registers fall into three groups:

- **Command registers**: the CPU writes these to tell the device what to do.
- **Data registers**: used to move data into and out of the device.
- **Status registers**: the CPU reads these to learn what the device is doing.

Inside the device sits a microcontroller (the device's own CPU), on-device memory, and whatever device-specific logic the hardware needs (for example analog-to-digital conversion, or chips to interact with the physical network medium).

The CPU reaches these registers in one of two ways. Under **memory-mapped I/O**, the device registers appear at specific physical memory addresses; the integrated PCI controller recognizes accesses to that address range and routes them to the device. The range reserved for a device is set by its Base Address Registers (BARs), configured at boot per the PCI protocol. Alternatively x86 provides dedicated `in`/`out` instructions that name an **I/O port** and a value: the **I/O port model**.

#### Sending a command (the general path)

1. A user process issues a system call for the operation it wants (for example, send this packet, write this block).
2. The kernel runs the in-kernel stack for that device and does any preprocessing needed to turn the user's buffer into something the device expects (for example, forming a TCP/IP packet from a raw buffer).
3. The kernel invokes the appropriate **device driver**, the device-specific software component responsible for all access, management, and control of that device.
4. The driver configures the request on the device using PIO or DMA (details below), writing commands into the command registers and arranging for the data to reach the device.
5. The device performs the actual request (the NIC puts the packet on the wire; the disk performs the block read).

The driver is responsible for making sure that commands and data are neither overwritten nor dropped before the device consumes them.

#### Receiving from a device (the reverse path)

Results and events traverse the same chain in reverse: device -> driver -> kernel -> user process. The device signals that it has something for the CPU by one of two mechanisms:

- **Interrupts**: the device raises an interrupt as soon as it has information, trapping into the kernel. This gives low latency to notice an event, but the interrupt handler costs CPU cycles (saving/restoring state, setting and resetting interrupt masks) and causes indirect costs such as cache pollution.
- **Polling**: the CPU reads the device's status registers at times of its choosing. This lets the OS pick a convenient moment (minimizing cache pollution), but adds delay between when the event occurs and when it is observed, and polling too often wastes CPU.

Which is better depends on the device and the goal: throughput versus latency, how complex the interrupt handler is, and the device's data rates.

A third option is **OS bypass**: the OS maps a device's registers directly into a user process at setup time and then gets out of the way. The process uses a **user-level driver** (a library, usually supplied by the manufacturer) to talk to the device directly, with no kernel involvement on the data path. The OS keeps coarse-grained control (enable/disable, permissions), and because the kernel no longer sits in the middle, the device itself must **demultiplex** incoming data to the right process.

#### PIO vs. DMA

| | Programmed I/O (PIO) | Direct Memory Access (DMA) |
|---|---|---|
| Extra hardware | None; works with a plain PCI interconnect | Requires a DMA controller |
| Who moves the data | CPU writes every chunk into the data registers | DMA controller moves data between memory and device |
| CPU cost of a transfer | One command write plus one data-register write per chunk | One command write plus one DMA configuration step |
| Best for | Small transfers | Large transfers |
| Memory constraint | None | The buffer must be **pinned** (non-swappable) in physical memory for the whole transfer |

**Worked example (transmit a 1500-byte packet, 8-byte data registers):**

- PIO: 1 access to the command register, then ceil(1500 / 8) = 188 writes to the data register, for **189 CPU accesses**.
- DMA: 1 access to the command register, then **1 DMA configuration operation** that tells the controller the buffer address and size.

DMA is not free: configuring the controller takes many more cycles than a single memory access. There is a crossover point. For a device that moves little data per operation (a keyboard sending one keystroke), PIO wins because one or two stores are cheaper than configuring the controller. For a NIC it depends on transfer size: if a packet is small enough to need fewer stores than the DMA configuration cost, PIO wins; past that size, DMA wins. The pinning requirement follows from the DMA controller having access only to physical memory, so the buffer cannot be swapped out mid-transfer.

### For block storage devices, do you understand the basic virtual file system stack, the purpose of the different entities? Do you understand the relationship between the various data structures (block sizes, addressing scheme, etc.) and the total size of the files or the file system that can be supported on a system?

#### The block device stack, top to bottom

- **File API (POSIX)**: user applications work with the *file* abstraction, not with blocks. A file is a logical storage unit mapping to physical storage. The standardized `open`/`read`/`write`/`close` interface means a filesystem can be swapped out without breaking applications.
- **Virtual filesystem (VFS)**: an optional layer (present in Linux) that hides which underlying filesystem is in use, so files on several devices, of several filesystem types, or even over a network, appear as one coherent tree. It defines the abstractions every underlying filesystem must implement.
- **Filesystem (for example ext2)**: receives read/write operations for a file, locates the file, checks access, and figures out which portion to touch.
- **Generic block layer**: provides a single, consistent block API from the OS to all block devices, masking the per-device API differences. The full device features remain reachable through the driver.
- **Device drivers**: the device-specific code that performs the actual block transfers via PIO/DMA.

#### The VFS abstractions and their purpose

| Abstraction | Purpose | Persisted? |
|---|---|---|
| **File** (via file descriptor) | The thing the VFS operates on; the fd is an integer handed back on open | the file is |
| **inode** ("index node") | Holds the index of all data blocks for one file plus metadata (owner, permissions, size); lets a file's blocks be scattered across the disk | yes, in a block |
| **dentry** (directory entry) | Represents one path component during traversal (for `/users/ada`: one each for `/`, `/users`, `/users/ada`); cached in the **dentry cache** so repeat lookups skip re-reading directory files | no, memory only |
| **superblock** | Describes how the filesystem is laid out on the device (map of inodes, data blocks, free space); used for allocation and lookup | yes |

From the VFS perspective a directory is itself just a file whose contents name the files it holds and their inodes.

#### ext2 on disk

The first block of an ext2 partition is not used by Linux and is often used to boot the system. The rest is divided into **block groups** (whose size has no relation to the disk's physical geometry). Each block group holds a super block (inode count, block count, start of free blocks), a group descriptor (the location of the bitmaps, the free-inode count, the directory count, the last tracked so ext2 can balance directories across groups), bitmaps for quickly finding free inodes and blocks, the inodes (each a 128-byte structure describing exactly one file), and finally the data blocks.

#### Addressing math: how data structures bound file and filesystem size

The inode holds a fixed number of block pointers, so the inode size, the pointer size, and the block size together bound the maximum file size.

**Direct pointers only.** With a 128-byte inode holding 4-byte block pointers, the inode can hold at most 32 pointers. With 1 KB blocks:

```
32 pointers * 1 KB/block = 32 KB maximum file size
```

That is too restrictive, which motivates indirect pointers.

**Indirect pointers.** A pointer can instead point to a *block full of pointers*. With 1 KB blocks and 4-byte pointers there are 1024 / 4 = **256 pointers per block**:

- A **single indirect** pointer addresses 256 * 1 KB = **256 KB**.
- A **double indirect** pointer points to a block of single indirect pointers: 256 * 256 * 1 KB = **64 MB**.
- A **triple indirect** pointer points to a block of double indirect pointers: 256 * 256 * 256 * 1 KB = **16 GB**.

The Linux inode combines these. A classic layout is 12 direct pointers plus one single, one double, and one triple indirect pointer. With 4-byte pointers and 1 KB blocks:

```
max file size = (12 + 256 + 256^2 + 256^3) * 1 KB  ~= 16 GB
```

Block size amplifies this disproportionately. Move to 8 KB blocks and each block holds 2048 pointers, giving:

```
max file size = (12 + 2048 + 2048^2 + 2048^3) * 8 KB  ~= 64 TB
```

An eightfold increase in block size raises the ceiling far more than eightfold, because the gain compounds through the indirect levels.

**The tradeoff.** Indirect pointers keep the inode small while addressing large files, but they cost extra disk accesses. With no indirection, reading a block is at most two accesses (inode, then block). A double-indirect block costs four (inode, two levels of pointer blocks, then the data block). The total filesystem size, in turn, is bounded by how many blocks and inodes the superblock and bitmaps can address across all block groups.

### For the virtual file system stack, we mention several optimizations that can reduce the overheads associated with accessing the physical device. Do you understand how each of these optimizations changes how or how much we need to access the device?

The disk is the slow component, and the single slowest thing it does is move the read/write head. Each optimization attacks either *how many* times we touch the disk or *how far the head must travel*.

| Optimization | What it does | Effect on device access |
|---|---|---|
| **Buffer cache** | Keep blocks in main memory; serve reads and absorb writes there, flushing to disk only periodically (`fsync` forces it) | Cuts the *number* of disk accesses; the cost of one physical write is amortized across the many writes that hit the cache in between |
| **I/O scheduling** | Reorder queued requests so the head services them in a sweep instead of backtracking | Reduces *head movement* by turning random access into (closer to) sequential access. Example: head at position 15, requests for 25 then 17 arrive; the scheduler writes 17 on the way to 25 rather than overshooting and backtracking |
| **Prefetching** | On a request for block N, also read the next few logical blocks (the inode tells us which) into the cache | Trades extra disk *bandwidth* now for fewer future accesses; relies on spatial locality so later reads become cache hits instead of disk trips. Example: read 17 also pulls in 18 and 19 |
| **Journaling** | Write a compact description of each update (block, offset, content) to a sequential log, then apply the logged writes to their real locations periodically | Avoids many random disk accesses by writing a description of each update to a log instead of the proper location; logged writes are periodically applied to their real locations. Addresses the risk that data buffered in memory for the I/O scheduler is lost on a crash. ext3/ext4 use this |

Each one changes the device-access profile in a specific way: caching and prefetching reduce how *often* we go to disk (caching by reuse, prefetching by anticipation), I/O scheduling reduces how *expensive* each batch of accesses is by minimizing seeks, and journaling reduces random-write cost while adding durability. They compose: a block can be served from the buffer cache, and on a miss the scheduler and prefetcher together keep the resulting disk trip cheap.

## P3L6

### What is virtualization? What's the history behind it? What's hosted vs. bare-metal virtualization? What's paravirtualization, why is it useful?

#### What virtualization is

Virtualization lets multiple operating systems run concurrently on one physical platform, each under the illusion that it owns the underlying hardware (all or in part). Each OS plus its applications and virtual resources is a **virtual machine** (VM), also called a *guest* or *domain*. The coordination, allocation, and isolation are provided by the **virtual machine monitor** (VMM), also called the **hypervisor**.

The textbook definition is Popek and Goldberg's: a virtual machine is "an efficient, isolated duplicate of the real machine." The VMM has three responsibilities, which the lecture names **fidelity**, **performance**, and **safety/isolation**:

- *Fidelity*: the environment presented to the guest is essentially identical to a real machine (same CPU type, same device types); capacity may differ.
- *Performance*: guest code runs at worst with minor slowdown; the goal is near-native speed.
- *Safety/isolation*: the VMM is in complete control of the resources and keeps VMs from interfering with each other.

(Lecture framing: fidelity / performance / safety; Paper, Popek & Goldberg: names these *equivalence*, *efficiency*, and *resource control*, and defines them precisely. Equivalence means any program has an effect identical to running on the bare machine, with two allowed exceptions: timing differences and reduced resource availability. Efficiency means a statistically dominant subset of instructions executes directly on the real processor with no VMM intervention, which is what formally excludes pure emulators and interpreters from being VMMs. Resource control means a program cannot touch resources not allocated to it and the VMM can reclaim allocated resources. The equivalence property is also what distinguishes a VMM from an ordinary time-sharing OS and from plain virtual memory.)

#### History

Virtualization began in the 1960s at IBM, when computing meant a few large mainframes shared by many users, and the goal was to run diverse workloads under different operating systems on one machine. It then lapsed: mainframes were not ubiquitous, commodity x86 hardware was cheap, and capable multitasking operating systems made it simpler to buy another box than to make several OSes coexist. (Paper, Rosenblum & Garfinkel: by the late 1980s VMMs were regarded as little more than a historical curiosity.) It returned when data centers grew large, servers sat underutilized (roughly 10 to 20 percent average utilization), admin headcount rose, and power and cooling costs climbed, until operating expenses dominated IT budgets. Consolidating workloads onto fewer, better-managed machines brought those costs back down.

(Lecture framing: the "cheap hardware made it unnecessary, then data-center sprawl made it necessary again" arc; Paper, Rosenblum & Garfinkel: sharpens the irony: the very combination that killed VMMs, cheap hardware plus capable operating systems, is what later caused the problems VMMs solve, because cheap hardware proliferated underused machines and more capable operating systems grew "fragile and vulnerable," pushing admins to one-application-per-machine. It argues a VMM is going forward "less a vehicle for multitasking and more a solution for security and reliability." It also adds a different origin for the 1990s revival the lecture omits: Stanford researchers used VMs to make hard-to-program massively parallel machines look like existing platforms so they could reuse existing operating systems, and that project produced the people and ideas behind VMware.)

Benefits that follow: **consolidation** (fewer machines, less space, lower power), easier **migration** (OS and apps are decoupled from the box, so VMs are easy to clone, set up, and tear down), **availability/reliability** (spin a VM up elsewhere when a box is failing), fault and attack **containment**, a fertile ground for **OS research**, and affordable **legacy-OS** support.

#### Bare-metal vs. hosted

| | Bare-metal (type 1, hypervisor-based) | Hosted (type 2) |
|---|---|---|
| Where the VMM runs | Directly on the hardware | As a module inside a full host OS |
| Device drivers | A problem: the hypervisor must manage all devices, so a **service VM** (a privileged VM running a standard OS with full hardware access) typically runs the drivers | Reuses the host OS's existing drivers and services, so much less to build |
| Examples | Xen (privileged **dom0** runs the drivers, guest **domUs** run on top), VMware ESX | KVM (built into Linux) plus the QEMU emulator for critical instructions and I/O |
| Tradeoff | Device non-uniformity is the main difficulty; closest to the hardware | Leverages the host, can run native apps alongside guests; pays host-crossing overhead on I/O |

(Lecture framing: the hosted example is KVM/QEMU; Paper, Rosenblum & Garfinkel: uses VMware Workstation as the canonical hosted architecture (the term comes from the paper's reference, Sugerman et al.). Its I/O path is concrete: a guest disk read/write becomes a *host-OS file* read/write, and the guest display renders into a host window. The paper lists three advantages (the VMM installs like an ordinary application, it inherits the host's rich x86 driver support, and it reuses the host's scheduling and resource management) and two disadvantages: high I/O overhead because every request crosses into the host and traverses its layers, and the host OS's lack of resource-management support for performance isolation and service guarantees. Together they are why VMware's ESX Server dropped the host OS and runs on bare hardware.)

#### Paravirtualization and why it is useful

In paravirtualization the guest OS *knows* it is virtualized. Instead of issuing operations it knows will fail (or fail silently) on virtualized hardware, it makes explicit **hypercalls** to the hypervisor, which behave like system calls: the hypercall traps into the hypervisor, which performs the operation on the supplied data and returns control. This sidesteps the non-virtualizable-instruction problem (see the next question) and reduces the overheads of full virtualization (the guest makes hypercalls instead of issuing the problematic instructions, and can batch page-table updates into a single hypercall). The cost is that the guest OS must be modified, so it does not work for unmodified or legacy operating systems. The lecture attributes this approach to **Xen**.

(Lecture framing: Xen is the paravirtualization example; Paper, Rosenblum & Garfinkel: the canonical example is **Disco**, a VMM for the non-virtualizable MIPS architecture; the paper never mentions Xen. Disco replaced the MIPS equivalent of the troublesome instructions with accesses to a special memory location, which also removed the traps and improved performance. The paper frames paravirtualization generally as the VMM builder *redefining the VM interface*, replacing non-virtualizable instructions with efficient virtualizable equivalents, so most applications still run unmodified while the OS is ported. Its stated drawback is incompatibility: a ported OS, required vendor cooperation, no legacy OSes, no easy migration, which is why academic projects favored paravirtualization while a fully compatible commodity product, VMware, needed binary translation instead.)

### What were the problems with virtualizing x86? How does protection of x86 used to work and how does it work now? How were/are the virtualization problems on x86 fixed?

#### The core problem

Trap-and-emulate, the standard CPU-virtualization mechanism, depends on every instruction the VMM must mediate actually trapping when the guest runs it outside full privilege. On pre-2005 x86 that assumption failed. There were **17 instructions** that read or modified privileged machine state yet did *not* trap when issued from an unprivileged level. The guest OS, running de-privileged, would issue one, it would not trap, so the hypervisor never saw it and could not emulate the intended effect, and the failure was *silent*, so the guest assumed it had succeeded and carried on with wrong state.

The lecture's canonical example is interrupt enable/disable via the flags register. `POPF`/`PUSHF` manipulate the interrupt flag, but issued unprivileged they silently ignore the change to that flag. The hypervisor is never notified that the guest wanted to change interrupt status, and the guest never learns the change did not take effect.

(Lecture framing: "17 instructions that were privileged but did not trap"; Paper, Popek & Goldberg: under the paper's own definitions that phrasing is self-contradictory, because a privileged instruction is *defined* as one that traps in user mode. The accurate statement is that these 17 are **sensitive but not privileged**: they touch privileged state (sensitive) yet do not trap outside ring 0 (not privileged). They are exactly the instructions that violate Popek & Goldberg's subset condition. The 1974 paper predates x86 and contains no x86 instruction count; Popek & Goldberg's actual contribution is the theorem below.) The number 17 comes from **Robin & Irvine**, USENIX Security 2000, who analyzed the roughly 250 Pentium instructions.

(Paper, Popek & Goldberg: an instruction is **privileged** if it traps in user mode but not supervisor mode; **sensitive** if it is *control sensitive* (changes resources such as memory, or changes processor mode outside the memory-trap sequence) or *behavior sensitive* (its result depends on real-memory location or on processor mode); and **innocuous** otherwise. **Theorem 1** states that a VMM can be constructed for a conventional third-generation machine **if the set of sensitive instructions is a subset of the privileged instructions**, because then every instruction the VMM must mediate traps. Pre-2005 x86 violated this; the 17 sensitive-but-unprivileged instructions were the counterexamples.)

(Paper, Rosenblum & Garfinkel: gives the two concrete x86 examples behind the problem. First, `POPF` sets/clears the interrupt-disable flag but does not trap unprivileged; it silently drops the change. Second, unprivileged instructions can *read* privileged state: a guest can read the code-segment register to see the real current privilege level, and because the read does not trap, the VMM cannot patch the value, so the guest sees the physical privilege level instead of its virtual one.)

#### Protection: then and now

**Then.** x86 had a single mode with four **rings**, ring 0 most privileged (native OS), ring 3 least (applications). Virtualization software ran the hypervisor in ring 0 and de-privileged the guest OS into ring 1, with guest applications still in ring 3. The four requirements that force this arrangement: present a virtual CPU/memory/device interface to each guest; isolate guests from each other; keep the usual guest-OS-from-application protection inside a VM; and protect the VMM from the guest OSes. The last two together mean guest OS and VMM cannot share a protection level, so one faulty guest cannot take down the hypervisor.

**Now.** Recent x86 adds two **protection modes**, **root** and **non-root** (also called host and guest), and the four rings exist within each. The hypervisor runs in ring 0 of **root** mode; a guest VM runs in **non-root** mode with its OS back in ring 0 (of non-root) and its applications in ring 3. A guest privileged operation causes a **VMExit**, trapping to root mode and the hypervisor; when the hypervisor finishes it does a **VMEntry** back to non-root mode. The guest OS no longer has to be squeezed into ring 1.

#### The three fixes

**1. Binary translation (full virtualization, VMware).** Keep the guest *unmodified* by inspecting kernel instruction blocks at runtime, at a basic-block granularity (such as a loop or a function), before they execute. A block with none of the 17 instructions is marked safe and runs at hardware speed; a block containing one has that instruction rewritten into an alternate sequence that emulates the intended behavior. Overheads are reduced by caching translated fragments and only translating kernel code. This runs unmodified and legacy guests but adds translation latency.

(Paper, Rosenblum & Garfinkel: VMware runs only kernel code under the translator, translates each block into a similar block with the problematic instructions replaced, and caches it in a **trace cache** so a block is translated only on first execution. The output "looks much like" paravirtualized output, except changes are applied at first execution rather than to OS source. VMware's translator is simpler than cross-ISA translators because source and target ISAs are nearly identical. Binary translation is also a *performance* optimization: by removing frequently-trapping privileged instructions it cuts trap overhead, which is especially high on deep-pipeline x86 CPUs; once the trace cache is warm, speed is nearly indistinguishable from direct execution.)

**2. Paravirtualization (Xen).** Modify the guest so it never issues the bad instructions, making explicit hypercalls instead. Lower overhead than binary translation, but requires guest modification, so no unmodified or legacy guests. (Paper, Rosenblum & Garfinkel: canonical example is Disco/MIPS, not Xen, as noted in the previous question.)

**3. Hardware virtualization (the eventual fix).** Around 2005 AMD (Pacifica) and Intel (Vanderpool) changed the chips so the 17 instructions trap and pass control to the hypervisor, and added the root/non-root modes above. Per-vCPU state lives in a hardware-walked control structure (**VMCS** on Intel, **VMCB** on AMD) that specifies what traps. Memory structures were tagged with VM identifiers, enabling **extended page tables** and **tagged TLBs**, so a world switch no longer has to flush the previous VM's TLB entries, because the MMU matches both the virtual address and the VM identifier against each entry. I/O support was added (multiqueue devices, better interrupt routing). Intel brands these along three axes: **VT-x** (CPU: fix the instructions, extended page tables), **VT-d** (chipset: I/O routing, direct device access), and device-resident **IOV**/**VMDq** (DMA remapping, per-VM queues).

(Paper, Popek & Goldberg: forcing the 17 sensitive-but-unprivileged instructions to trap is exactly making x86 satisfy Theorem 1. Once they trap they join the privileged set, so the sensitive set becomes a subset of the privileged set, and the trap-and-emulate VMM the paper proves constructible can be built directly in hardware rather than worked around in software.)

(Paper, Rosenblum & Garfinkel: writing in 2005, predicted this. It noted Vanderpool and Pacifica had *announced* support that, rather than making existing modes virtualizable, adds a *new execution mode* so a VMM can use direct execution safely, cutting both the number and the cost of traps. It forecast that adequate hardware support would make a fully compatible VM abstraction outweigh the performance benefit of breaking compatibility, that is, outweigh paravirtualization.)

### How does device virtualization work? What a passthrough vs. a split-device model?

#### Why devices are the hard case

CPU and memory virtualization are eased by strong standardization at the **instruction set architecture** level: for a given ISA such as x86, the VMM supports one well-defined instruction set and ignores lower-level hardware differences. Devices have no such standardization. There is enormous diversity in device types and in the specifics and semantics of their interfaces, so there is no single virtual device interface to export. Virtualization solutions pick one of three models.

(Paper, Rosenblum & Garfinkel: frames this historically. Thirty years earlier IBM mainframes used a **channel**-based I/O architecture, with a separate channel processor that let the VMM export device access directly to the VM at very low overhead. The x86 world lost that, and its huge, diverse device collection makes a VMM I/O layer a large effort, while some devices (graphics, high-speed network) have severe performance needs. The paper's three concrete approaches only partly line up with the three models below: the hosted architecture routes I/O through the host OS's drivers (highest overhead, VMware Workstation); ESX borrows Linux drivers directly (lower overhead, feasible because relatively few network and storage devices are certified for major x86 vendor servers); and VMware exports *optimized paravirtualized virtual devices* that match no real device and need a special guest driver, which is the split-device idea.)

#### The three models

| Model | How it works | Strengths | Weaknesses |
|---|---|---|---|
| **Passthrough** (VMM-bypass) | The VMM-level driver sets access permissions once (maps the device's registers into the guest), then steps aside; the guest's own driver drives the device directly | Lowest overhead; VMM out of the data path | Exclusive access makes **sharing** hard (VMM must keep reassigning the device, no concurrent access); the guest needs the *exact* device type present, which **re-couples** guest and hardware and makes migration hard again (device-resident state must be copied) |
| **Hypervisor-direct** | The VMM intercepts *every* device request, translates it to a generic I/O operation for that device family, and runs it down the hypervisor-resident I/O stack to the real driver | Guest stays decoupled from the hardware, so migration stays easy; device sharing works | Emulation adds **latency** on every access; the hypervisor must support *all* the drivers, inheriting their complexity |
| **Split device driver** | Two cooperating parts: a **front-end driver** in the guest VM and a **back-end driver** in the service VM (type 1) or host OS (type 2); the front end wraps guest device operations in special messages passed directly to the back-end component, which issues the real requests | Eliminates per-access emulation overhead; the centralized back end manages shared devices well | The front end must be modified, so this works **only for paravirtualized guests** |

#### Passthrough vs. split device, directly contrasted

- **Passthrough** gives the guest *direct, exclusive* control of a real device with no VMM in the path. That buys speed but costs the two things virtualization is supposed to provide: easy sharing (the device belongs to one VM at a time) and decoupling (the guest must contain the exact driver for the physical device, which breaks clean migration).
- **Split device** keeps the real driver in one place (the back end in the service VM or host) and puts only a thin, format-wrapping **front end** in each guest. That restores easy device sharing through the centralized back end and removes the per-access emulation cost of the hypervisor-direct model, at the price of requiring a modified (paravirtualized) guest. The back-end driver itself is usually unmodified, the same one a native OS would use.

The through-line: passthrough optimizes raw performance at the expense of sharing and portability; hypervisor-direct optimizes decoupling and sharing at the expense of per-access latency and hypervisor complexity; split device is the paravirtualized middle ground that recovers sharing and low overhead by splitting the driver across a trusted back end and a modified front end.

## P4L1

### What's the motivation for RPC? What are the various design points that have to be sorted out in implementing an RPC runtime (e.g., binding process, failure semantics, interface specification... )? What are some of the options and associated tradeoffs?

#### Motivation

Almost every client/server program repeats the same low-level plumbing: open a socket, bind/connect, serialize arguments into a contiguous buffer, send, wait, receive, deserialize, handle transport errors. Two different applications (a client fetching a file; a client shipping an image to a server for processing) differ only in the request name and the payload, yet both require nearly identical setup. RPC was motivated by the observation that this socket plumbing (creating and initializing sockets, allocating buffers, populating them with protocol information such as a "get file" directive and the buffer size, and explicitly copying data in and out) is repeated boilerplate. The goal is to let a programmer call a remote procedure as if it were local, so they can focus on what the service does rather than on the transport.

Concretely, RPC provides:

- A high-level interface for data movement and communication, so the developer writes `add(i, j)` instead of socket code.
- Built-in handling of common transport/communication errors, so each program does not re-implement error handling.
- Hiding of cross-machine differences (endianness, float and negative-number representation, word size) behind an agreed wire format.

(Paper, Birrell & Nelson: the stated primary aim is the same idea from the other direction: make distributed computation easy, because at the time building communicating programs was a task reserved for communication experts, and the communication mechanisms themselves were the main thing constraining distributed computing. The guiding principle is that remote-call semantics should be as close as possible to local-call semantics.)

#### Design points and tradeoffs

| Design point | Options | Tradeoffs |
|---|---|---|
| Binding / registry | Global distributed registry vs. per-machine registry (and points in between) | A global registry carries heavy lookup traffic and must stay highly available, but the client need not know where the server runs. A per-machine registry is cheap and simple, but the client must already know the server's machine; it only resolves the port. |
| Failure semantics | Return a catch-all error vs. attempt richer diagnosis; retry vs. do not retry | So many independent things can fail (lost request, lost reply, dead network link, crashed server machine, crashed server process, overloaded server) that the runtime usually cannot say which. A single catch-all failure is honest but uninformative; retrying can mask transient faults but changes the call's guarantee (see below). |
| Interface specification (IDL) | Language-agnostic (e.g. XDR) vs. language-specific (e.g. Java RMI uses Java) | A language-specific IDL is natural if you already know that language and avoids learning a new notation. A language-agnostic IDL lets a C client talk to a server written in anything, at the cost of learning the IDL. |
| Call semantics | Synchronous blocking (standard) | Matches local procedure-call semantics, which is the whole point; the caller blocks until the result returns. The cost is that the caller is suspended for the full round trip. |
| Pointer arguments | Disallow pointers vs. serialize the pointed-to data | Either disallow pointers as arguments, or allow them and marshal the referenced data (not the pointer); the unmarshalling code hands the local procedure the address of the reconstructed data, so pointers are "passed" between client and server. |
| Transport protocol | TCP, UDP, others | RPC is meant to be more than a transport protocol: it should run over different transports and layer access control, authentication, and fault tolerance on top. |
| Type checking | Present | Catches wrong-type arguments and lets the runtime optimize interpretation of the raw byte stream, since the wire is otherwise just bytes. |

#### Call-semantics spectrum (the subtle one)

Because failures are ambiguous, the choice of what to do on timeout defines the delivery guarantee. The lecture itself stops at the catch-all error and SunRPC's configurable retry; the spectrum below comes from the paper and the ONC RPC standard.

- **At-least-once**: blindly retransmit the whole call until a reply arrives. Fine for idempotent procedures, dangerous for non-idempotent ones (a transfer could run twice).
- **At-most-once**: remember a transaction/call identifier so the callee can discard duplicates; this gives some degree of at-most-once.
- **Exactly-once (on return)**: (Paper, Birrell & Nelson: the packet protocol pairs retransmission with call identifiers and a per-activity sequence number, so the callee discards duplicates. The guarantee: if the call returns to the user, the procedure was invoked exactly once; if an exception is reported instead, it was invoked either once or not at all, and the user is not told which, nor whether the fault was a crash or a communication problem.)

(Lecture framing: binding is presented as a choice between a distributed registry and a per-machine registry, with the per-machine registry as one extreme; Paper, Birrell & Nelson: the actual binding uses Grapevine, a replicated distributed database, binding an importer to an exporter by interface type and instance.) The per-machine registry is the SunRPC point in the space, not the paper's.

### What's specifically done in Sun RPC for these design points: you should easily understand this from your project?

SunRPC is the RPC package Sun built in the 1980s for NFS on UNIX, now widely ported. Its concrete choices on each design point:

- **Binding / registry**: per-machine. SunRPC assumes the server machine is known up front. A registry daemon called **portmapper** runs on every machine (registered on both TCP and UDP at port 111). The server registers its service with the local portmapper on startup; the client must contact the portmapper on the target machine to obtain the port for the service it wants. `rpcinfo -p` lists the program id, version, protocol, port, and name of every service registered on a machine.
- **Interface specification**: language-agnostic. SunRPC uses **XDR** (eXternal Data Representation) both to specify the interface and to specify the on-the-wire encoding of each data type. The interface lives in a `.x` file; `rpcgen -C <interface>.x` compiles it into `<interface>.h` (types and prototypes), `<interface>_svc.c` (server stub plus a `main` with the registration code), `<interface>_clnt.c` (client stub), and `<interface>_xdr.c` (marshaling/unmarshalling routines shared by both sides).
- **Failure semantics**: SunRPC exposes a set of error codes and tries to return a meaningful error as often as possible. It includes a retry mechanism for re-contacting a server after a timeout, and the number of retries is configurable. The default behavior retries a bounded (configurable) number of times. Blind retransmission gives only at-least-once semantics, unsafe for non-idempotent procedures over an unreliable transport, which is a different point on the spectrum from Birrell & Nelson's exactly-once-on-return design (described above). (The ONC RPC standard, RFC 1831, makes this explicit: over an unreliable transport a reply implies at-least-once, a remembered transaction id gives some degree of at-most-once, and only a reliable transport yields exactly-once.)
- **Pointers**: allowed. SunRPC serializes the pointed-to data, and the server-side unmarshalling code hands the local procedure the address of the reconstructed data.
- **Binding handle**: when the client binds via `clnt_create(host, prog, vers, proto)`, it receives a `CLIENT*` handle used on every subsequent call to track per-client RPC state, request status, errors, and authentication.
- **Threading**: `rpcgen` output is not thread-safe by default; `-M` makes the generated code thread-safe, and `-A` generates a multithreaded server on Solaris (on Linux the multithreading must be written by hand).

### What's marshaling/unmarshalling? How does an RPC runtime serialize and deserialize complex variable size data structures? What's specifically done in Sun RPC/XDR?

#### Definitions

**Marshaling** is collecting arguments that live in scattered, non-contiguous locations in the caller's address space and packing them, together with a descriptor of which procedure to invoke, into a single contiguous buffer. It is needed because the transport layer (a socket) sends a contiguous byte stream, not a set of program variables.

**Unmarshalling** is the inverse on the receiving side: given the contiguous buffer plus knowledge of the target procedure and its argument types, extract the correct byte ranges and use them to allocate and initialize the corresponding data structures in the callee's address space.

Marshaling also encodes the data into an agreed format so the receiver can interpret it regardless of endianness or native representation. Both ends must agree on the convention in advance; otherwise the receiver cannot recover the structure. The marshaling and unmarshalling routines are not hand-written: an IDL compiler generates them from the interface specification, and the programmer links them in.

#### Serializing variable-size structures

A scalar like an `int` marshals trivially. A variable-size structure such as an array has more than one possible layout, and the two ends must agree on one:

- Write the length first, then the elements (length-prefixed), or
- Write the elements followed by a terminator (the convention strings use, where the null byte marks the end).

The receiver, knowing the convention, reads the length (or scans to the terminator), allocates the right amount of memory, and copies the remaining bytes in.

#### XDR specifics

- Base types include `char`, `byte`, `int`, `float`; `hyper` is a 64-bit integer; `quadruple` is a 128-bit float (the lecture calls it 120-bit; XDR per RFC 4506 and Sun/Oracle define it as 128 bits / 16 bytes). `const` compiles to a C `#define`. `opaque` is uninterpreted binary data, used for things like image bytes.
- **Fixed-length array**: `int data[80]`.
- **Variable-length array**: `int data<80>`. This compiles to a struct with two fields: an integer `len` holding the actual element count and a pointer `val` to the elements. The sender sets `len` and points `val` at the data; the receiver reads the first four bytes to learn `len`, allocates that much memory, and copies the rest of the stream in. (In-memory size of a full variable-length `int` array of max size 5 on a 32-bit machine: 4-byte `len` + 4-byte `val` pointer + five 4-byte ints = 28 bytes.)
- **Strings** are the exception: in memory they are ordinary null-terminated C strings, but on the wire they are encoded as a `len` plus `data` pair, like a variable-length array.

The reference for all of P4L1 is Birrell and Nelson, "Implementing Remote Procedure Calls" (ACM TOCS, 1984) alone. (Paper, Birrell & Nelson: the stub generator is named Lupine and the binding registry is Grapevine.)

## P4L2

### What are some of the design options in implementing a distributed service? What are the tradeoffs associated with a stateless vs. stateful design? What are the tradeoffs (benefits and costs) associated with using techniques such as caching, replication, partitioning, in the implementation of a distributed service (think distributed file service).

#### Where the work happens: the two extremes

- **Upload/download**: the client downloads the whole file, modifies it locally, and uploads it back. Modifications are fast and local with no per-operation network cost, but the client must transfer the entire file even for small modifications, and the server loses all control and knowledge of the file while it is checked out.
- **True remote access**: the file stays on the server and every operation crosses the network. The server keeps full control and consistency is easy to maintain, but every operation (even repeated reads of a read-only file) pays a network cost, and the server saturates quickly, limiting scalability.

The practical compromise is to let clients cache blocks (and prefetch likely-next blocks). This cuts latency and server load, but forces clients to tell the server about modifications and to check whether cached blocks have been invalidated by others, which makes the server more complex and introduces non-UNIX sharing semantics the client must understand.

#### Stateless vs. stateful

| | Stateless | Stateful |
|---|---|---|
| Knows about clients/files/accesses | No | Yes (which files/blocks are open, by whom, read vs. write, who has cached what) |
| Request form | Every request self-contained (absolute offsets, all parameters) | Can use relative requests ("next kB of data") |
| Caching + consistency | Not possible (no state to drive coherence) | Supported, plus locking |
| Resource use | No CPU/memory for state | Runtime overhead to maintain state and run coherence protocols |
| Failure recovery | Trivial: just restart; clients reissue timed-out requests and get the same answers | Hard: state must be recovered, so the state must be checkpointed to be rebuilt |
| Bits on the wire | More per request (self-contained) | Fewer |

Stateless servers suit the two extreme models; any caching model needs a stateful server.

#### Caching, replication, partitioning

- **Caching** (client-side): lets repeated reads hit local memory/disk, lowering latency and server load. The cost is cache coherence: when one client writes a block another has cached, the system needs a mechanism (on-demand, periodic, or on-open; client- or server-driven) to propagate or invalidate. Coherence requires server state, so caching and statelessness are incompatible.
- **Replication**: every server holds all files. Requests load-balance across replicas, the system is highly available, and it is fault tolerant (a replica can fail with no loss of service). Costs: writes become complex (write synchronously to all replicas, or write one and asynchronously propagate), replicas can diverge and must be reconciled (e.g. majority voting), and the system does not scale in capacity, since adding a machine does not let you store more files.
- **Partitioning**: each server holds a disjoint subset of files (by filename, by directory, which partitions the hierarchical namespace, or by other criteria). This scales in capacity (more machines means more files), and writes are simple because a file lives on exactly one machine. Costs: when a partition fails its files are unavailable, routing is more complex, load balancing must account for access skew, and a heavily-accessed file creates a hotspot.
- **Combination**: partition across one axis, then replicate each partition, to get scalability and availability together.

Update semantics are a further axis: **session semantics** (write back on close, check for a newer version on open) are easy to reason about but poor for concurrent sharing and allow long staleness windows; **periodic updates** (client flushes periodically, server sends periodic invalidations) bound inconsistency in time. Other strategies are immutable files (never modify; create a new file) and transactions (batch updates applied atomically).

### The Sprite caching paper motivates its design based on empirical data about how users access and share files. Do you understand how the empirical data translated in specific design decisions? Do you understand what type of data structures were needed at the servers' and at the clients' side to support the operation of the Sprite system (i.e., what kind of information did they need to keep track of, what kind of fields did they need to include for their per-file/per-client/per-server data structures).

Reference: Nelson, Welch, and Ousterhout, "Caching in the Sprite Network File System" (SOSP 1987 / ACM TOCS 1988). The "Nelson" here is Michael N. Nelson of the Sprite group, not Bruce Jay Nelson of the RPC paper.

#### The empirical data and what it drove

| Observation | Design decision |
|---|---|
| About one-third of accesses are writes (two-thirds reads) | Caching is worthwhile: 66% of operations can be improved; but write-through alone is insufficient to leverage the cache for writes. Use a delayed write-back policy. (Paper, Nelson et al.: a write-through cache cannot reduce disk or server traffic by more than two-thirds.) |
| 20-30% of new data deleted within 30 s; 50% within 5 min | Delayed write-back pays off: data deleted before it is written back never needs to be written at all. |
| 75% of files open < 0.5 s; 90% open < 10 s | Write-on-close (session semantics for write-back) would not significantly reduce traffic; reject it. (Paper, Nelson et al.: write-on-close would also force the closing process to wait for the write-back.) |
| Concurrent write-sharing is rare | Optimize the consistency algorithm for the no-sharing case; disable caching entirely during concurrent write-sharing, since the cost is paid infrequently. |

Sprite's resulting policy: client caching (Paper, Nelson et al.: main-memory caches on both clients and servers); delayed write-back where every 30 seconds all dirty blocks not modified in the last 30 seconds are written back; every `open` goes to the server (so directories/names are not cached); and caching disabled for a file while it is concurrently write-shared, with all its accesses serialized at the server.

(Lecture framing: the lecture presents these statistics as a study of Sprite's own production filesystem and derives the 30-second write-back interval from the 30-second deletion figure; Paper, Nelson et al.: the write %, open-duration, and deletion numbers come from the earlier "BSD study," a trace of three time-shared VAX-11/780s running 4.2 BSD UNIX; Sprite reused that trace rather than tracing Sprite itself, in its Section 5.3 simulation (Tables 1 and 2) and again in Section 7 to estimate per-user I/O rates for sizing a server. The one-third write figure is used as an upper bound ("write-through cannot reduce traffic by more than two-thirds"), not as a count of improvable operations. The 30-second interval is the UNIX convention (the 30-second sync interval), not a number tuned to the deletion statistic; the paper notes the trace actually argues for a longer delay and that it plans to experiment with longer intervals. And "concurrent write-sharing rare" is the paper's expectation about Sprite's own sharing used to justify optimizing for the no-sharing case, not a claim that the BSD trace measured sharing frequency; the paper's own sharing evidence is its Section 5.3 simulation, where of all write traffic 4041 blocks were written through for concurrent write-sharing and 6887 flushed for sequential write-sharing, and consistency accounted for about one-fourth of server traffic.)

#### Data structures

Per file, the **client** keeps:

- `cache` (overall cacheable yes/no for this file)
- the set of cached blocks
- a timer/timestamp per dirty block (to drive the 30-second write-back)
- a version number

Per file, the **server** keeps:

- the set of readers
- the current writer
- a version number
- (and, to enable/disable caching, a per-file `cacheable` flag)

How these are used:

- **Version numbers**: every `open` goes through the server, so the server and the client keep a version number per file to stay in sync. (Paper, Nelson et al.: this solves the first sequential-write-sharing problem, that the opener's own cache may be stale: the server increments the version each time the file is opened for writing; a client compares its stored version against the server's on open and flushes its cached copy if they differ.)
- **Writer tracking** (sequential write-sharing): when a new writer opens the file after the previous writer closed it, the server contacts the old writer to gather its dirty blocks (convenient, since the client tracks its dirty blocks), updates its writer field to the new writer, and the new writer can cache the file. (Paper, Nelson et al.: this is the separate second problem, that current data may still sit in the last writer's cache because the last writer need not have flushed on close; the server tells the last writer to flush its dirty blocks through before the opener reads.)
- **Concurrent write-sharing**: when another writer arrives while the current writer still has the file open, the server has the current writer write back all its dirty blocks and marks the file not cacheable (the per-file `cacheable` flag), disabling caching for everybody; all operations then go through the server. When a writer closes the file, the server sees it and makes the file cacheable again, so the remaining clients can resume caching. (Lecture framing: caching is re-enabled when a writer closes; Paper, Nelson et al.: on detecting concurrent write-sharing the server (1) tells the single writer, if any, to write back all dirty blocks (there can be at most one such writer), and (2) tells all clients currently holding the file open that it is no longer cacheable, so they drop its blocks and go to the server, giving single-timeshared-machine semantics. Clients that merely hold stale blocks but do not have the file open are not notified; they take consistency action at their next open. For simplicity Sprite does not re-enable caching for files that are already open, so the remaining writer would not resume caching until it closes and reopens the file; caching is re-enabled only for later opens.)

(Paper, Nelson et al.: Sprite provides *consistency* (every read returns the most recently written data) but not *synchronization* (it does not order concurrent applications' reads and writes sensibly); applications that care about order must use file locking. Consistency "simply eliminates the network issues and reduces the problem to what it was on time-sharing systems.")

## P4L3

### When sharing state, what are the tradeoffs associated with the sharing granularity?

The granularity is the unit at which the DSM layer tracks sharing and triggers coherence traffic. The tension is uniform: finer granularity gives precise sharing but generates coherence traffic too often to be affordable over a network; coarser granularity amortizes network cost over a larger unit but risks false sharing.

| Granularity | For | Against |
|---|---|---|
| Cache line | The SMP hardware unit; minimal false sharing | Far too fine for DSM: cache-line coherence traffic carried over the network is too expensive. |
| Variable | Meaningful to the programmer; could allow per-variable sharing semantics | Still too fine; many variables are only a few bytes long, so coherence overhead over the network stays too high. |
| Page | Natural to the OS (no language support needed); large enough to amortize remote-access cost | Must beware **false sharing**: two nodes writing different variables that happen to lie on the same page trigger coherence traffic that is logically unnecessary. |
| Object | No OS modification needed (the OS knows nothing about objects) | Requires a language runtime that understands which objects are local vs. remote, so it is not generalizable across languages. |

With a cooperating compiler, application objects can be laid out on separate pages so a page-based OS mechanism can be used without the language-runtime dependency.

(Paper, Protic et al.: the paper frames granularity as a two-sided tradeoff. Coarser blocks save directory storage and suit high-locality applications but raise the chance that different processors contend for the same block even when touching unrelated parts of it. It lists false sharing together with **thrashing** as the two adverse effects of coarse-grain, virtual-memory-based software DSM, which is why hardware systems favor cache-line granularity.)

### For distributed state management systems (think distributed shared memory) what are the basic mechanisms needed to maintain consistence, e.g., do you why is it useful to use 'home nodes', why do we differentiate between a global index structure to find the home nodes and local index structures used by the home nodes to track information about the portion of the state they are responsible for.

Two things must be maintained:

1. **A requester must be able to find a recent copy of any datum.** Each page/address is assigned a **home node** (manager) responsible for it. Every node holds a replicated **global map** from page id to home node, so any node can immediately locate the home node and request the data, then cache it until a coherence message arrives.
2. **State changes must be broadcast to exactly the nodes that care.** The home node for a datum drives coherence when that datum changes. To do so it keeps a **local, per-page index** of which nodes have cached that page (so requesters must include their node id in each request). It contacts only those nodes, not everyone.

Why split global vs. local indices: a small global map (page/object id -> manager id) is replicated on every node, so any node can find the manager of any page. The per-page (local) metadata is partitioned across the system, so no single node holds all of it; each manager keeps the metadata only for its own pages.

A useful refinement is to distinguish the **home node** from an **owner node**. When a non-home node accesses a page repeatedly or exclusively, continually routing updates through the home node is expensive; ownership (the right to drive coherence and modify) can migrate to that node, and the home node's role narrows to tracking who the current owner is. The address itself is a (node id, page frame number) pair; the mapping-table indirection lets the manager/owner change without changing the address.

The home node's per-page metadata typically includes: which pages were accessed, and by whom (readers, writers), modification status, caching enabled/disabled, and lock status. Replicas can also be created deliberately for load balancing, hot spot avoidance, or reliability (for example triplicating state across the local machine, a nearby machine in the same rack, and a remote machine in another rack or potentially another datacenter).

(Paper, Protic et al.: the paper's terms are manager, owner, and **copy set**, following the Li and Hudak algorithms. The copy set is exactly this per-page list of sites holding copies. Variants differ in where the copy set lives: the centralized-manager algorithm keeps it at the manager; the improved version lets it travel with the data to each new owner; the dynamic distributed manager tracks a *probable* owner and chases a chain, degrading only logarithmically under contention.)

### Do you have some ideas how would you go about implementing a distributed shared memory system?

The central requirement is to intervene on exactly the memory accesses that touch shared state, and stay out of the way for local, non-shared accesses. The lever is the **MMU**.

- **Detecting remote reads.** A reference to a remote address has no valid local page-table mapping, so the MMU faults and traps into the OS. The OS recognizes the address as remote, uses the global page-to-home-node map to find the home (or owner) node, sends it a request (via message queue, socket, or other IPC), receives the data, caches it on the local node, and returns it to the faulting process. The program counter is left so the faulting instruction re-executes against the now-valid mapping.
- **Detecting writes to shared state.** When content is cached, the DSM layer **write-protects** those virtual addresses. A write traps into the OS, which recognizes the address as shared and either (if this node is not the owner) messages the home/owner node to perform the update, or (if it is the home/owner) applies the update and sends coherence messages to the nodes in that page's copy set. Because each requester included its node id when it fetched the page, the home node knows precisely whom to notify.
- **Dynamic engage/disengage.** Using faults means the DSM machinery is invoked only on shared-state access; purely local accesses proceed with no overhead.
- **Extra MMU information.** Dirty and accessed bits can be read to implement different consistency and replacement policies (for example, deciding what to write back or invalidate).

For an object-granularity DSM, the same ideas move into a language runtime: the runtime distinguishes local from remote objects and generates the request/coherence operations for remote ones, optionally leaning on the same OS/MMU services, or doing everything in software.

### What's a consistency model? What are the different guarantees that change in the different models we mentioned: strict, sequential, causal, weak... Can you work through a hypothetical execution example and determine whether the behavior is consistent with respect to a particular consistency model?

#### What a consistency model is

A consistency model is a guarantee the DSM (or any distributed-state) layer makes about how memory updates become visible, *contingent on the software following a certain set of rules*. It answers two questions: in what order are operations observed, and how recent is the value a reader sees. Stronger models are simpler to program against but cost more in latency and bandwidth; weaker models perform better but push synchronization effort onto the programmer.

Notation convention: `R(x)a` means a read of location `x` returns value `a`; `W(x)a` means a write of value `a` to `x`.

#### The models

**Strict consistency.** Every read returns the value of the most recent write, with "most recent" fixed by absolute global time; all nodes see all writes in the same order, immediately. This requires instantaneous, globally-ordered visibility and is impossible in practice; even a single SMP gives no such guarantee across cores without extra synchronization, and in a distributed system latency, loss, and reordering rule it out. It is a theoretical ideal only.

**Sequential consistency.** Visibility need not be immediate. The observed order must correspond to *some* legal interleaving of the operations, subject to two rules: (1) operations issued by a single process appear in all observers in that process's issue order; (2) all processes observe the *same* single interleaving.

Example (two writers, two readers). P1 does `W(m1)X`; P2 does `W(m2)Y`. The two writes are unrelated (P2 computed Y without any reference to m1). A third process may legally observe `R(m1)X` then `R(m2)Y`, or `R(m1)0` then `R(m2)Y`; both are fine because each matches some possible ordering of the operations on a single shared memory. Same-process ordering: if P1 later does `W(m3)Z`, no process may see `Z` at m3 and only afterwards find out that `X` was written to m1. Agreement: if P3 sees one ordering of the updates, every other process must see the same ordering. If P3 sees m1 updated to X before m2 is updated to Y, while P4 sees m2 already updated to Y with m1 still 0, the two processes observe different orders of the same updates, which sequential consistency does not allow.

**Causal consistency.** Only *potentially causally related* writes must be seen in the same order by all processes; concurrent (causally unrelated) writes may be observed in different orders by different processes. A write that follows a read on the same process is treated as potentially dependent on the value read.

Example. P1 does `W(m1)X`. P2 does `R(m1)X` then `W(m2)Y` (so Y may depend on X). A causally consistent system forces every other process to read `X` at `m1` before it may read `Y` at `m2`. If instead P1's `W(m1)X` and P2's `W(m2)Y` were concurrent with no intervening read linking them, observers may see them in either order. As with sequential consistency, writes from the same process are seen everywhere in issue order.

**Weak consistency.** Memory is guaranteed consistent only at explicit **synchronization points**. The layer exports a `sync` operation in addition to read and write. A process that has made updates calls sync (an **exit/release**) to push its updates out; a process that wants to see others' updates calls sync (an **entry/acquire**) to pull them in. A sync by the writer alone does not make its writes visible to a reader that has not itself synchronized. Both sides must participate: once P2 syncs, it is guaranteed to see every update that existed as of P1's sync.

Example. P1 does `W(m1)X` then `sync`. P2 at that moment is not guaranteed to see `X`, because P2 has not synchronized. After P2 performs its own `sync`, it is guaranteed to see `X` (and all other updates that preceded P1's sync).

#### Which models come from where

(Paper, Protic et al.: of the four, only **sequential** and **weak** are in the paper's taxonomy (which runs sequential, processor, weak, release, lazy release, entry). **Strict** and **causal** are not in Protic.) The lecture takes strict and causal from the general distributed-systems literature (Tanenbaum). Precise points worth keeping straight:

- (Paper, Protic et al.: sequential consistency is stated as: all processors observe the same interleaving of the read/write sequences issued by individual processors.)
- (Paper, Protic et al.: the paper also defines **processor consistency**, which the lecture skips: all processors must see any one processor's writes in that processor's issue order, but need not agree on the interleaving of writes from *different* processors.)
- (Paper, Protic et al.: the paper's weak-consistency definition carries a guarantee the lecture leaves implicit: the synchronization accesses must themselves be sequentially consistent among one another.)
- (Paper, Protic et al.: the lecture's single acquire/release mechanism is, in the paper's finer taxonomy, **release consistency** (acquire gates later ordinary accesses; release waits for prior ordinary accesses). **Entry consistency** is a distinct, more aggressive model that additionally binds each shared variable to a specific synchronization variable, so an acquire propagates only the data that variable guards; the lecture's label "entry/acquire" does not fully capture it. **Lazy release** postpones propagation to the next relevant acquire and is contrasted with "eager" release.)

## P4L4

### When managing large-scale distributed systems and services, what are the pros and cons with adopting a homogeneous vs. a heterogeneous design?

Behind a front-end load balancer (a boss distributing to workers), the worker nodes can be organized two ways.

**Homogeneous.** Every node can perform any step of request processing for any request type. Data is replicated or distributed so that any node can reach any information it needs.

- Pros: the front-end is simple; it can hand requests out round-robin (optionally weighted by observed CPU load) with no knowledge of request content. Scaling is trivial: add or remove interchangeable nodes as traffic changes.
- Cons: little benefit from caching or locality. A simple front-end keeps too little state to route by locality, so a given node sees a mix of unrelated work and its cache hit rate stays low.

**Heterogeneous.** Each node specializes in a subset of requests or processing steps (for example, eBay routing browse requests to one pool and bid/buy requests to another, or splitting by the alphabetical order of a requested filename).

- Pros: caching and locality pay off, because each node repeatedly works on similar data and computations, so useful data is more likely to be cached. Data need not be uniformly accessible everywhere.
- Cons: the front-end is more complex (it must parse requests to route them). Overall management is harder: scaling is no longer "add a node," because you must know *which* specialized pool is the bottleneck; idle nodes of the wrong type cannot absorb excess load; and workload shifts force a layout reconfiguration. This makes hotspots and long per-node backlogs easier to fall into.

The tradeoff is simplicity and easy scaling (homogeneous) versus locality and cache efficiency at the cost of routing and management complexity (heterogeneous).

### Do you understand the history and motivation behind cloud computing, and basic models of cloud offerings? Do you understand some of the enabling technologies that make cloud offerings broadly useful?

#### History and motivation

Amazon in the mid 2000s had an imbalanced workload: most traffic came during the US holiday shopping season (Thanksgiving to Christmas), so much hardware provisioned for that peak sat idle outside that window, or was used for other company tasks such as forecasting or other analytics. In 2006 Amazon opened its hardware to third-party workloads over web APIs, for a fee; this was the birth of AWS and EC2. The canonical illustration is **Animoto**, which turned photos into videos (a compute-heavy task) and rented EC2 instances instead of building a datacenter. When it launched to Facebook users in April 2008 it signed up 750,000 users in three days and scaled from about 50 instances on Monday to 400 on Tuesday to 3,400 by Friday, roughly two orders of magnitude in a week, which an owned-infrastructure approach could not have met.

The deeper motivation is older: John McCarthy in 1961 envisioned computing organized as a public utility, like the telephone system. Cloud computing aims to turn IT resources into a fungible utility you consume without caring which hardware serves you or where it sits. Summarized goals: on-demand elastic resources, fine-grained usage-based pricing, professional hosting/management, and API-based access, so that cost tracks demand instead of being fixed at peak-provisioning levels.

Limits on the vision: hardware dependencies cannot be fully masked even with virtualization; providers expose different APIs (API lock-in); putting core code and data with a provider raises privacy/security concerns; and geographic distance adds latency.

#### Service models (differ by who owns which layer of the stack)

| Model | Provider owns | Customer brings | Example |
|---|---|---|---|
| On-premises | nothing (you own it all) | everything | n/a |
| IaaS (Infrastructure as a Service) | physical hardware (and virtualization) | applications, data, runtime, middleware, and O/S | Amazon EC2 |
| PaaS (Platform as a Service) | hardware + infrastructure + execution environment (OS, tools) | application and data | Google App Engine; early Windows Azure (.NET) |
| SaaS (Software as a Service) | application, data, infrastructure, hardware | nothing | Gmail |

IaaS typically gives virtualized, often multi-tenant resources rather than raw hardware, though single-tenant high-performance and GPU instances exist.

Deployment models: **public** (provider-owned, rented by tenants), **private** (same entity owns infrastructure and software, using cloud techniques in-house), **hybrid** (private for the main load with public for failover/spikes or auxiliary tasks like load testing), and **community** (public cloud shared by a particular class of users).

#### Enabling technologies

- **Virtualization**: makes physical hardware into fungible resources that can be repurposed per workload.
- **Resource provisioning and scheduling**: enable dynamic provisioning and scheduling of infrastructure resources (e.g. Mesos, Hadoop YARN).
- **Big-data processing and storage**: process and store large amounts of data (e.g. Hadoop MapReduce, Spark); append-only distributed filesystems and NoSQL databases, plus storing data across distributed memories instead of repeatedly accessing disk.
- **Isolation**: software to enable and configure software-defined slices of resources, so each customer gets its own software-defined data center.
- **Monitoring**: for the provider to run the datacenter and for customers to inspect their own applications (e.g. Flume, CloudWatch, Log Insight).

### Do you understand what about the cloud scales make it practical? Do you understand what about the cloud scales make failures unavoidable?

#### Why scale makes the cloud practical

From the **provider's** side:

- **Law of large numbers.** Averaged across many clients whose peaks are shifted in time, aggregate resource demand is roughly constant. The provider can buy a fixed amount of hardware and serve many clients without any one client's peak consuming everything.
- **Economies of scale.** The fixed cost of hardware is amortized across many tenants sharing it; the more clients, the lower the per-client cost.

From the **client's** side:

- **Elasticity of resources and of cost.** Capacity scales (ideally instantaneously and automatically) with demand, so spending tracks usage. Animoto's two-orders-of-magnitude week is the example: owned infrastructure is either over-provisioned (paying for idle capacity) or maxed out (dropping requests and losing opportunity), whereas elastic capacity lets cost mirror revenue, assuming higher consumption correlates with higher traffic and revenue.

For the cloud to deliver this it must provide **fungible** resources, dynamic resource management at very large scale (thousands and tens of thousands of nodes), performance isolation across multi-tenant environments, and guarantees on the privacy of client data and the security of the execution environment.

#### Why scale makes failure unavoidable

Failure probability rises with component count because each component fails independently. If a single component fails with probability `p`, the probability that at least one of `n` components fails is

```
P(at least one failure) = 1 - (1 - p)^n
```

Worked values: with `p = 0.03`, `n = 10` gives about 26%; `n = 100` gives about 95%. Real clouds have thousands to hundreds of thousands of components, so even with reliable hardware something is always failing. The system must therefore build in failure handling: timeouts for detection, restart and retry for recovery, and backup, replication, and checkpointing to limit loss.

P4L4 has no assigned paper; the material above is from the Datacenter Technologies lecture notes.
