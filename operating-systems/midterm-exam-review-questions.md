---
id: operating-systems-midterm-exam-review-questions
title: Midterm Exam Review Questions
course: operating-systems
lecture: midterm-exam-review-questions
---

# Midterm Exam Review Questions

This document provides thorough, exam-ready answers to all midterm review questions for the Operating Systems course. Answers are drawn from the course lectures and referenced papers (Birrell's threads paper, the SunOS/Solaris papers by Eykholt et al. and Stein & Shah, and the Flash paper by Pai et al.). Where relevant, pseudocode, comparison tables, and quantitative formulas are included.

## Part 1: OS Fundamentals

### 1. What are the key roles of an operating system?

The operating system has three key roles:

1. **Hide hardware complexity.** Application developers should not need to interface directly with the CPU, memory, or I/O devices. The OS provides abstractions (e.g., the *file* abstraction for disk storage, the *process* abstraction for execution) that separate the developer from hardware details.

2. **Manage underlying hardware resources.** The OS is the interface between user-level applications and physical hardware, so it allocates memory to applications, schedules them for execution on the CPU, and controls access to network and I/O devices. These first two roles can be summarized as **abstract and arbitrate**.

3. **Provide isolation and protection.** With multiple applications running concurrently, the OS ensures that no application interferes with another. For example, memory allocated to one application is neither readable nor writable by another application.

### 2. Can you make distinction between OS abstractions, mechanisms, policies?

**Abstractions** are entities that represent other entities, often in a simplified manner. They hide complexity and provide portability. Examples:

- Process, thread (application abstractions)
- File, socket, memory page (hardware abstractions)

**Mechanisms** are the tools by which policies are implemented. They are the concrete methods or data structures the OS uses to carry out operations. For example, to enforce an LRU memory management policy, the OS might maintain a queue of memory pages ordered by last access time. The queue is the mechanism.

**Policies** are the rules about how a system is maintained and how resources are utilized. For example, the **Least Recently Used (LRU)** policy states that the memory page that was least recently accessed will be swapped to disk. Policies can differ across contexts or change at different times during system execution.

| Concept     | Definition                              | Example                                  |
|-------------|-----------------------------------------|------------------------------------------|
| Abstraction | Simplified representation of a resource | Memory page, process, file, socket       |
| Mechanism   | Tool/method that implements a policy    | Page table, queue, context switch logic  |
| Policy      | Rule governing resource utilization     | LRU page replacement, round-robin sched. |

### 3. What does the principle of separation of mechanism and policy mean?

The idea is that how you enforce a policy should not be coupled to the policy itself. Since a given policy is only valid in some contexts or during some states of execution, a mechanism that only suits that single policy is brittle. Instead, mechanisms should be flexible enough to support a variety of policies, since any one of these policies may be in effect at a given point in time.

For example, a memory management mechanism (page table, page replacement infrastructure) should be able to support LRU, LFU (Least Frequently Used), random replacement, and other policies without needing to be redesigned. The mechanism stays the same; only the policy logic changes.

That said, certain policies occur more frequently than others, so it may make sense to optimize mechanisms slightly in one direction while still maintaining their flexibility.

### 4. What does the principle optimize for the common case mean?

Optimizing for the common case means ensuring that the most frequent path of execution operates as performantly as possible. This is valuable for two reasons:

- It is simpler than trying to optimize across all possible cases.
- It leads to the largest performance gains because you are optimizing the flow that, by definition, is executed most often.

A great example from the SunOS paper (Eykholt et al.) is the use of threads for interrupt handling instead of blocking out interrupts (raising and lowering the interrupt priority level) before entering and after exiting a mutex-protected critical section:

> The additional overhead in taking an interrupt is about 40 SPARC instructions. The savings in the mutex enter/exit path is about 12 instructions. However, mutex operations are much more frequent than interrupts, so there is a net gain in time cost, as long as interrupts don't block too frequently.

The 40-instruction cost per interrupt is paid infrequently (Lecture framing: 40 instructions for the checks and, if necessary, creating a separate thread; Paper, Eykholt et al.: it is the overhead of taking an interrupt on a preallocated interrupt thread, not of creating a thread). The 12-instruction saving per mutex operation is collected on every lock/unlock. Because mutex operations vastly outnumber interrupts, the net instruction count decreases. (Paper, Eykholt et al.: the common case is optimized a second time inside the mechanism: the expensive work of turning an interrupt into a full, schedulable thread is done only when the interrupt handler actually blocks on lock contention.)

The Stein & Shah threads library applies the same principle to signal masks: updating a thread's signal mask (frequent) is a cheap user-level operation with no system call, while actually handling a signal (rare) may cost extra system calls to fix up the kernel-level mask.

### 5. What happens during a user-kernel mode crossing?

User and kernel mode are distinguished directly in hardware. In kernel mode, a special bit is set on the CPU that allows any instruction to directly manipulate hardware. In user mode, that bit is not set, and attempts to perform privileged operations are forbidden (triggering a trap).

During a user-kernel mode crossing:

1. The hardware switches the privilege mode (flips the CPU bit from user to kernel, or vice versa).
2. A context switch occurs: the CPU must save the state of the current user-level execution context (registers, program counter) and load the kernel's execution context.
3. This context switch takes CPU cycles, which is real overhead.
4. The kernel brings its own content into the hardware cache, potentially displacing some or all of the application's cached data. The application's cache goes from **hot** to **cold**. Subsequent memory accesses by the application (when control returns) will initially come from main memory rather than cache, which is slow.
5. On a 2 GHz Linux box, user/kernel transitions take on the order of 50 to 100 ns, and cache hits take a few cycles while main-memory accesses take hundreds of cycles, so a cold cache slows subsequent accesses.

### 6. What are some of the reasons why user-kernel mode crossing happens?

User/kernel mode crossing occurs any time an application needs access to underlying hardware (physical memory, storage, I/O devices). Specific reasons include:

- **System calls**: The application explicitly requests that the OS perform a service (e.g., `open`, `read`, `write`, `send`, `mmap`, `close`, `malloc`/`free` that triggers `brk`/`sbrk`).
- **Hardware traps**: The hardware detects an attempt to perform an unprivileged operation (e.g., accessing memory that requires special privileges, executing a privileged instruction in user mode, dividing by zero).
- **Signals**: The OS needs to deliver a notification to a user process (e.g., SIGSEGV, SIGKILL).
- **Interrupts**: External devices (I/O devices, timers, other CPUs) send notifications to the CPU that require kernel-level handling.

### 7. What is a kernel trap? Why does it happen? What are the steps that take place during a kernel trap?

A **kernel trap** is a signal that the hardware sends to the operating system when it detects that something has occurred that requires the OS's attention.

**Why it happens:**

- The hardware detects an attempt to perform an unprivileged operation (any operation that occurs when the CPU privilege bit is not set).
- An attempt to access memory that requires special privileges.
- An illegal instruction or arithmetic error (e.g., divide by zero).

**Steps during a kernel trap:**

1. The hardware detects the offending operation during the execution of a user-level process.
2. The hardware interrupts the currently executing process.
3. The hardware sends a trap signal to the operating system, transferring control to the OS.
4. The CPU switches from user mode to kernel mode (the privilege bit is set).
5. The OS invokes its **trap handler**, which examines the process that caused the trap and the reason for the trap.
6. The OS decides whether to grant the attempted operation, ignore it, or terminate the offending process.
7. If the process is allowed to continue, the OS restores the user-level execution context and switches back to user mode.

### 8. What is a system call? How does it happen? What are the steps that take place during a system call?

A **system call** is an operation that the OS exposes so that an application can directly invoke it when it needs the OS to perform a specific service or privileged access on its behalf. Examples: `open`, `read`, `write`, `send`, `mmap`, `close`.

**Steps during a system call:**

1. The user process invokes the system call, passing arguments (either directly via registers or indirectly via pointers to memory locations).
2. The OS context-switches from the user process to the kernel, saving the user-level execution state (registers, program counter, stack pointer).
3. The CPU trap bit is adjusted to indicate kernel mode, enabling privileged operations.
4. The kernel jumps to the appropriate system call handler (identified by a system call number).
5. The kernel executes the requested operation on behalf of the user process.
6. The kernel resets the trap bit to indicate user mode.
7. The kernel context-switches back to the user process, restoring its execution state and passing back the results of the system call.

In **synchronous mode**, the process waits until the system call completes. Asynchronous modes also exist.

### 9. Contrast the design decisions and performance tradeoffs among monolithic, modular and microkernel-based OS designs.

| Aspect             | Monolithic                                    | Modular                                         | Microkernel                                        |
|--------------------|-----------------------------------------------|--------------------------------------------------|----------------------------------------------------|
| **Structure**      | Everything included in one large kernel       | Basic services + dynamically loadable modules    | Minimal kernel; most services at user level        |
| **Size**           | Large memory footprint                        | Smaller footprint; load only what is needed      | Smallest kernel footprint                          |
| **Customization**  | No customization                              | Highly customizable                              | Customized per hardware/use case                   |
| **Optimization**   | Inlining, compile-time optimizations possible | Indirection may reduce some optimization (minor) | Limited optimization due to IPC overhead           |
| **Portability**    | Not discussed in lecture                      | Not discussed in lecture                         | Poor portability (often hardware-specific)         |
| **Performance**    | Can be fast (no IPC overhead)                 | Good; minor overhead from indirection            | Expensive frequent user/kernel crossings via IPC   |
| **Maintenance**    | Difficult to manage due to size               | Good, but runtime module mixing can cause issues | Hard to find common components for specialized use |
| **Verifiability**  | Difficult (too large)                         | Moderate                                         | Excellent (small; valuable where correctness is critical, e.g. some embedded devices or control systems) |

**Monolithic Pros:** Everything included; inlining and compile-time optimizations are possible because all code is in one compilation unit.
**Monolithic Cons:** Too much state and code, hard to maintain, debug and upgrade; large memory requirements, which can impact performance.

**Modular Pros:** Maintainability; smaller footprint; less resource usage; modules can be added/removed dynamically.
**Modular Cons:** Indirection from modularity can slightly reduce optimization opportunities; maintenance issues when modules from different codebases are loaded together at runtime.

**Microkernel Pros:** Small size; verifiability (valuable where correct behavior is critical, like some embedded devices or certain control systems).
**Microkernel Cons:** Poor portability (often customized to underlying hardware); harder to find common OS components due to specialized use case, leading to software complexity; expensive user/kernel crossings because traditional OS components (file systems, device drivers) run at user level and must communicate with the kernel via IPC.

## Part 2: Threads, Concurrency, IPC, and Flash

### 10. Process vs. thread, describe the distinctions. What happens on a process vs. thread context switch.

**Process:** A process is defined by its **virtual address mapping** (code, data, heap) and its **execution context** (CPU registers, stack, program counter). Each process has its own address space and its own PCB. Different processes do not share address spaces.

**Thread:** Threads exist within the same process. They share the virtual address mapping (code, data, heap, files) of the process, but each thread has its own **execution context** (registers, stack, program counter). Each thread has its own thread control block (or equivalent structure).

| Aspect                 | Process                                              | Thread                                                   |
|------------------------|------------------------------------------------------|----------------------------------------------------------|
| Address space          | Own, separate address space                          | Shared with other threads in the same process            |
| State shared           | Nothing (except via IPC)                             | Code, data, heap, file descriptors, address mappings     |
| State private          | Everything (code, data, heap, stack, registers)      | Stack, registers, program counter, thread-local storage  |
| Creation cost          | Expensive (new address space, PCB)                   | Cheaper (share address space, smaller data structure)    |
| Memory footprint       | Large (duplicate address space)                      | Small (shared address space)                             |
| Communication          | IPC (message passing, shared memory); expensive      | Shared variables in same address space; cheap            |
| Context switch cost    | Expensive (direct + indirect costs)                  | Cheaper (less state to swap, better cache behavior)      |

**Process context switch:**

1. Save the entire PCB (registers, program counter, stack pointer, memory mappings) of the outgoing process.
2. Load the entire PCB of the incoming process.
3. **Direct cost:** CPU cycles to store and load PCBs to/from memory.
4. **Indirect cost:** The hardware cache goes from hot to cold. The incoming process's data is not in cache, so subsequent memory accesses are slow (hundreds of cycles for main memory vs. a few cycles for cache).

**Thread context switch:**

1. Save the execution context (registers, program counter, stack pointer) of the outgoing thread.
2. Load the execution context of the incoming thread.
3. Since threads share the same address space, the virtual-to-physical memory mappings do **not** need to be swapped. This is one of the most time-consuming parts of a process context switch.
4. The cache is more likely to remain warm because threads share code, data, and heap. The incoming thread may benefit from the cache that was populated by the outgoing thread (better locality).

### 11. Describe the states in a lifetime of a process?

1. **New:** The process is being created. The OS performs admission control and allocates/initializes the PCB.
2. **Ready:** The PCB is initialized and the process is ready to execute, but is not currently on the CPU. It sits in the ready queue.
3. **Running:** The scheduler has dispatched the process onto the CPU and it is actively executing instructions.
4. **Waiting (Blocked):** The process has made an I/O request or is waiting on an event. It sits on the I/O queue or wait queue for that device/event.
5. **Terminated:** The process has exited (with or without error). Its resources are reclaimed.

**Transitions:**

- New -> Ready: OS finishes creating and initializing the PCB.
- Ready -> Running: Scheduler selects and dispatches the process onto the CPU.
- Running -> Ready: The process is preempted (interrupted) by the scheduler.
- Running -> Waiting: The process initiates an I/O request or waits on an event.
- Waiting -> Ready: The I/O request completes or the event occurs.
- Running -> Terminated: The process exits.

### 12. Describe the lifetime of a thread?

1. **Creation:** A new execution context is created and initialized. The creator specifies the procedure the thread will run and the arguments to pass. Once created, the thread is a separate entity from the creating thread, and the process is now multithreaded.

2. **Runnable/Running:** During its lifetime, a thread may be executing on the CPU or waiting. Threads wait for several reasons:
   - Waiting to be scheduled on the CPU (in the ready queue).
   - Waiting to acquire a synchronization construct (e.g., blocked on a mutex).
   - Waiting for a condition to become true or a signal to be received (e.g., on a condition variable wait queue).

3. **Joined/Exited:** At the end of its life, a joinable thread can be joined back into its parent via `join`. Through this join, the thread conveys the result of its work back to the parent. Detachable threads cannot be joined; they simply exit.

4. **Zombie:** A zombie thread is one that has completed its work but whose data structures have not yet been reclaimed. Exited threads are placed on **death row**, and periodically a special **reaper** thread garbage-collects their data structures. (Lecture framing: if a new thread is requested before a thread on death row is reaped, its data structures can be reused, saving allocation cost; Paper, Stein & Shah: the reaper frees exited threads' stacks into a cache of thread stacks, which is what speeds up creation; only detached threads go on deathrow, while undetached ones are reaped by `thr_join()`.)

### 13. Describe all the steps which take place for a process to transition from a waiting (blocked) state to a running (executing on the CPU) state.

1. The process is currently in the **waiting** state, sitting on an I/O queue (or event wait queue) within the kernel, associated with the device or event it is waiting on.
2. The I/O request completes (or the event occurs). The device/event notifies the kernel.
3. The kernel removes the process from the I/O/event queue and places it on the **ready queue**. The process is now in the **ready** state.
4. The CPU scheduler selects this process from the ready queue (based on its scheduling policy).
5. The currently executing process must be **preempted**: the OS saves its context (PCB) from CPU registers into memory.
6. The OS **dispatches** the previously-waiting process: loads its PCB from memory into CPU registers.
7. The process is now in the **running** state, executing instructions on the CPU.

### 14. What are the pros-and-cons of message-based vs. shared-memory-based IPC.

| Aspect              | Message-Based IPC                                     | Shared-Memory IPC                                      |
|---------------------|-------------------------------------------------------|--------------------------------------------------------|
| **Setup**           | OS creates/manages the channel                        | OS maps shared physical pages into both address spaces |
| **OS involvement**  | OS involved in every send/recv (system calls)         | OS involved only during setup (mapping); out of the way after |
| **Data transfer**   | Data copied: process -> kernel -> process (4 copies + 4 crossings for request-response) | Data placed directly in shared region; reduced copies  |
| **Synchronization** | Handled by OS (implicit)                              | Developer must implement explicitly (mutexes, etc.)    |
| **Simplicity**      | Simple for the developer                              | Complex; developer manages protocols and sync          |
| **Overhead**        | High (system calls + data copies per message)         | Low after setup (one-time mapping cost)                |
| **Best for**        | Small messages, infrequent communication              | Large data transfers, frequent communication           |

**Message-Based IPC Pros:**
- Simple: the OS manages the channel and provides send/recv system calls.
- No need for application-level synchronization.

**Message-Based IPC Cons:**
- Every send/recv requires a system call and a data copy (process address space -> kernel buffer -> process address space).
- A request-response exchange requires 4 user/kernel crossings and 4 data copies.

**Shared-Memory IPC Pros:**
- After setup, the OS is completely out of the way. No system calls for data transfer.
- Reduced data copies (data is written directly to shared region).
- The memory mapping cost is one-time and can pay off even for a single IPC exchange, especially for large data.

**Shared-Memory IPC Cons:**
- Developer must explicitly manage synchronization (mutexes, condition variables, semaphores).
- Developer must implement any communication protocols.
- Data must be explicitly placed in the shared memory region (may still require copies within the address space if data was allocated elsewhere).

Windows LPC exploits this tradeoff: small data is copied via message passing; large data is mapped into the target process's address space.

### 15. What are benefits of multithreading? When is it useful to add more threads, when does adding threads lead to pure overhead? What are the possible sources of overhead associated with multithreading?

**Benefits of multithreading:**

1. **Parallelization:** On multi-CPU systems, separate threads can execute simultaneously on different processors, completing work faster.
2. **Concurrency / hiding I/O latency:** On single-CPU systems, when one thread blocks on I/O, the CPU can context switch to another thread and do useful work. CPU utilization stays high.
3. **Specialization and hot caches:** Threads that perform small, specialized subtasks are more likely to keep their entire working state in the processor cache, improving performance.
4. **Lower memory footprint than multiprocess:** Threads share the address space, so a multithreaded application uses less memory than a multiprocess one. Less memory pressure means fewer disk swaps.
5. **Cheaper communication:** Inter-thread communication is just reading/writing shared variables; inter-process communication requires IPC mechanisms.
6. **Cheaper context switching:** Thread context switches are faster than process context switches because the address space mapping doesn't change and cache locality is better.

**When is it useful to add more threads?**

- When you have fewer threads than available CPU cores (you can parallelize more).
- When threads perform many I/O operations (idle time from I/O can be hidden by switching to another thread, so long as `t_idle > 2 * t_context_switch`).

**When does adding threads lead to pure overhead?**

- When all threads are CPU-bound and you already have as many threads as CPUs. Additional threads just compete for CPU time and add context-switching overhead with no gain.
- When the work is not parallelizable (serial dependency chains).
- When synchronization overhead dominates (too much contention on shared locks).

**Sources of overhead:**

- **Thread creation/destruction:** Not free; requires allocating data structures, stack space.
- **Context switching:** Even though cheaper than process context switching, thread context switches still consume CPU cycles.
- **Synchronization:** Mutexes, condition variables, and other sync primitives consume CPU cycles and memory. Lock contention can serialize execution, negating parallelism.
- **Memory:** Each thread needs its own stack and thread control block.

### 16. Describe the boss-worker multithreading pattern. If you need to improve a performance metric like throughput or response time, what could you do in a boss-worker model? What are the limiting factors in improving performance with this pattern?

**Description:** One **boss** thread and multiple **worker** threads. The boss accepts tasks as they enter the system and dispatches them to workers. Workers complete the entire assigned task.

**Dispatch mechanisms:**

1. **Direct signaling:** The boss tracks which workers are idle and sends work directly to a free worker. Pro: no synchronization among workers. Con: the boss must track every worker, increasing its per-task work and decreasing throughput.

2. **Shared queue (producer/consumer):** The boss places tasks on a shared queue; idle workers pull tasks from the queue. Pro: the boss does less work per task (just enqueue). Con: synchronization is needed on the queue. This is the more common approach.

**Throughput formula:**

```
throughput = 1 / t_boss
```

where `t_boss` is the time the boss spends per task. The boss is the bottleneck because it must touch every task.

**Improving throughput or response time:**

1. **Increase the number of workers.** More workers means more tasks are processed concurrently, reducing queue wait time. Use a pre-allocated thread pool (avoid dynamic creation overhead). The pool size can be adjusted dynamically in response to demand.
2. **Decrease the amount of work the boss does per task.** The less time the boss spends on each task, the higher the throughput. Use a shared queue rather than direct signaling.
3. **Use specialized workers.** Different workers handle different task types. This exploits locality (hot caches) and can improve per-task processing time. The boss must classify tasks, adding a small amount of per-task work, but the workers are more efficient.

**Limiting factors:**

- **CPU-bound ceiling:** After a certain number of threads, work becomes CPU-bound. Adding more threads just adds context-switching overhead.
- **Boss bottleneck:** Throughput is capped at `1 / t_boss`. If the boss cannot keep up, workers starve.
- **Lack of locality (generic workers):** With a shared queue, the boss has no insight into what a worker was doing last. A worker that just finished a similar task (and has a hot cache) might not be the one that picks up the next similar task.
- **Queue contention:** With many workers contending on a shared queue, synchronization overhead grows.

### 17. Describe the pipelined multithreading pattern. If you need to improve a performance metric like throughput or response time, what could you do in a pipelined model? What are the limiting factors in improving performance with this pattern?

**Description:** The overall task is divided into a sequence of **stages**. Each stage is assigned to one or more threads, and each thread performs only that stage's subtask. Work flows through the pipeline: the output of one stage is the input to the next, typically via shared buffers between stages. At any given time, multiple tasks can be in-flight at different stages.

**Throughput formula:**

```
throughput = 1 / t_longest_stage
```

The pipeline's throughput is limited by the **slowest stage** (the bottleneck).

**Improving throughput or response time:**

1. **Add more threads to the slowest stage.** If stage `k` takes 3x longer than other stages, assign 3x as many threads to stage `k` to balance the pipeline.
2. **Break a long stage into smaller sub-stages.** This reduces the bottleneck duration.
3. **Optimize the code in the slowest stage** to reduce its per-task execution time.

**Benefits:**

- **Specialization and locality:** Each thread performs the same small subtask repeatedly, so its working state is more likely to stay in the CPU cache (hot cache).
- **Concurrent processing:** Multiple tasks are processed simultaneously at different stages.

**Limiting factors:**

- **Pipeline depth and balancing:** It is difficult to keep the pipeline balanced over time. If the input rate changes or resources at a given stage are exhausted, rebalancing is required.
- **Bottleneck stage:** The overall throughput is constrained by the slowest stage. Even if all other stages are fast, one slow stage dominates.
- **Response time penalty:** A single task must pass through all stages sequentially. If there are many stages or some stages have wait times, the end-to-end latency for a single task can be higher than in the boss-worker model.

**Comparison with boss-workers (P2L2 multithreading-patterns quiz; the ~196ms / ~220ms averages are from P2L5, video 188):**

With 6 execution contexts (boss-workers: 1 boss + 5 workers, 120ms per order; pipeline: 6 stages of 20ms each):

- With 10 orders: boss-workers ~240ms total, pipeline ~300ms total (boss-workers wins).
- With 11 orders:
  - Boss-workers: total time ~360ms, average time per order ~196ms.
  - Pipeline: total time ~320ms, average time per order ~220ms.

Which model finishes first depends on the input. With 11 orders, the pipeline completes all work faster (lower total execution time), but the boss-workers model delivers a better average per-order response time. Which model is "better" depends on which metric matters.

### 18. What are mutexes? What are condition variables? Can you quickly write the steps/code for entering/exiting a critical section for problems such as reader/writer, reader/writer with selective priority? What are spurious wake-ups, how do you avoid them, and can you always avoid them? Do you understand the need for using a while() loop for the predicate check in the critical section entry code examples in the lessons?

#### Mutexes

A **mutex** (mutual exclusion lock) is a synchronization construct that ensures only one thread at a time can access a shared resource (the **critical section**). A mutex has at minimum: a lock status, an owner, and a list of blocked threads. When a thread locks a mutex, it has exclusive access; other threads attempting to lock the same mutex will block until the owner releases it.

#### Condition Variables

A **condition variable** is used in conjunction with a mutex to control concurrent execution based on arbitrary conditions (beyond the binary locked/unlocked of a mutex). A thread can **wait** on a condition variable (atomically releasing the associated mutex and sleeping), and another thread can **signal** (Lecture framing: wake one waiting thread; Paper, Birrell: wake at least one waiting thread, possibly more) or **broadcast** (wake all waiting threads) on the condition variable. When a waiting thread is woken, it automatically reacquires the mutex before returning from the wait call.

#### Reader/Writer Solution

We use a `resource_counter` proxy variable: 0 means free, positive means readers are active (count of readers), -1 means a writer is active.

**Reader:**

```c
// --- Enter critical section ---
mutex_lock(&counter_mutex);
while (resource_counter == -1)     // writer is active
    cond_wait(&read_phase, &counter_mutex);
resource_counter++;                // one more reader
mutex_unlock(&counter_mutex);

// ... READ shared data ...

// --- Exit critical section ---
mutex_lock(&counter_mutex);
resource_counter--;
if (resource_counter == 0)
    cond_signal(&write_phase);     // last reader signals writer
mutex_unlock(&counter_mutex);
```

**Writer:**

```c
// --- Enter critical section ---
mutex_lock(&counter_mutex);
while (resource_counter != 0)      // readers or writer active
    cond_wait(&write_phase, &counter_mutex);
resource_counter = -1;             // writer active
mutex_unlock(&counter_mutex);

// ... WRITE to shared data ...

// --- Exit critical section ---
mutex_lock(&counter_mutex);
resource_counter = 0;
cond_broadcast(&read_phase);       // wake all waiting readers
cond_signal(&write_phase);         // wake one waiting writer
mutex_unlock(&counter_mutex);
```

Note: `broadcast` for readers because multiple readers can proceed simultaneously. `signal` for writers because only one writer can proceed at a time. The scheduler ultimately decides whether a reader or writer is woken first. (Lecture framing: the exiting writer wakes both classes; Paper, Birrell: it should wake only one class: broadcast to readers if any are waiting, otherwise signal one writer. Waking both is correct but wakes threads that cannot proceed.)

#### Reader Priority Variant

To give readers priority, allow a new reader to proceed even if a writer is waiting, as long as no writer is currently active:

```c
// Reader enter: same as above (wait only while resource_counter == -1)
// Writer enter: same as above (wait while resource_counter != 0)
```

This is already reader-priority by default: a new reader only blocks when a writer is active (`resource_counter == -1`), not when a writer is waiting.

#### Writer Priority Variant

To give writers priority, readers must also check whether any writers are waiting:

```c
// Additional shared state:
int waiting_writers = 0;

// Reader enter (writer priority):
mutex_lock(&counter_mutex);
while (resource_counter == -1 || waiting_writers > 0)
    cond_wait(&read_phase, &counter_mutex);
resource_counter++;
mutex_unlock(&counter_mutex);

// Writer enter (writer priority):
mutex_lock(&counter_mutex);
waiting_writers++;
while (resource_counter != 0)
    cond_wait(&write_phase, &counter_mutex);
waiting_writers--;
resource_counter = -1;
mutex_unlock(&counter_mutex);
```

In the writer's exit, signal `write_phase` first (to give another waiting writer a chance), then broadcast `read_phase`.

#### Spurious Wake-ups

(Lecture terminology; Birrell's differs, see below.) A **spurious wake-up** occurs when a thread is woken up from a condition variable wait queue but the application is in a state where the thread cannot make progress. This typically happens when a thread signals or broadcasts while still holding the mutex. The woken threads are removed from the condition variable wait queue, but since the signaling thread still holds the mutex, the woken threads immediately block again on the mutex wait queue.

Spurious wake-ups do not affect correctness (the `while` loop re-checks the condition), but they hurt **performance** because CPU cycles are wasted context-switching to threads that immediately block again.

**How to avoid them:** Place the `signal`/`broadcast` call **after** unlocking the mutex, so that woken threads can immediately acquire the mutex and proceed.

**Can you always avoid them?** No. If the decision to signal depends on some property of shared state, that property must be checked while holding the mutex, which means the signal may need to happen inside the locked region. (Lecture framing: the signal then stays inside the mutex; Paper, Birrell: only the test needs the mutex: record it in a local flag inside the lock, e.g. `do_signal = (resource_counter == 0)`, and signal after unlocking.)

(Paper, Birrell: two related costs are separated. **Spurious wake-ups** wake threads that cannot make progress, e.g. by using `broadcast` where `signal` suffices or by having readers and writers wait on one condition variable; they are fixed by using separate condition variables. **Spurious lock conflicts** come from signaling while holding the mutex, so the woken thread immediately blocks on the mutex; they are fixed by signaling after unlock.) The lecture uses "spurious wake-up" for the second case.

#### Why use a while() loop?

When `cond_wait` returns, two things happen as logically independent steps:

1. The thread is removed from the condition variable's wait queue.
2. The thread reacquires the mutex.

Between these two steps, another thread may acquire the mutex and change the shared state. Therefore, when the woken thread finally reacquires the mutex, the condition it was waiting on may no longer be true. The `while` loop re-checks the predicate to guard against this scenario. Using `if` instead of `while` would be incorrect because it would not re-check.

(Paper, Birrell: two further reasons: some implementations of `signal` may, rarely, wake more than one thread, and the `while` pattern makes correctness verifiable by local inspection. Extra wake-ups become a performance issue only, not a correctness one.)

### 19. What's a simple way to prevent deadlocks? Why?

The simplest way to prevent deadlocks is to **maintain a lock ordering**: all threads must acquire mutexes in the same globally-defined order.

**Why this works:** A deadlock requires a cycle in the wait graph (an edge from thread A waiting for a resource held by thread B, and an edge from B waiting for a resource held by A). Enforcing a consistent lock order makes cycles impossible. If every thread must acquire mutex A before mutex B, no thread can hold B while waiting for A, so the cycle cannot form.

Other approaches:

- **Lock everything up front and release at the end.** Works for some applications but limits parallelism.
- **Deadlock detection and recovery.** Analyze the wait graph for cycles, then roll back one thread. Expensive.
- **Ostrich algorithm.** Do nothing and hope deadlocks don't occur. If they do, reboot.

(Paper, Birrell: a thread can also deadlock with **itself** if it tries to acquire a mutex it already holds, with a non-recursive mutex; this is the simplest case of deadlock.) Lock ordering (a partial order on mutex acquisition) completely prevents deadlocks involving only mutexes. (Paper, Birrell: deadlocks through condition variables, e.g. waiting for a resource while holding another, are prevented the same way, by imposing a partial order on the resources.)

### 20. Can you explain the relationship among kernel vs. user-level threads? Think through a general mxn scenario (as described in the Solaris papers), and in the current Linux model. What happens during scheduling, synchronization and signaling in these cases?

**User-level threads (ULTs)** are managed by a user-level threading library (e.g., pthreads). **Kernel-level threads (KLTs)** are managed by the kernel. For a user thread to execute, it must be associated with a kernel thread, which in turn must be scheduled on a CPU by the kernel scheduler.

#### One-to-One Model (Linux / NPTL)

In Linux's **Native POSIX Threads Library (NPTL)**, there is one kernel-level task (`struct task_struct`) for every user-level thread. This is the **1:1 model**.

- **Scheduling:** The kernel sees every thread and schedules them directly. The kernel scheduler has full visibility.
- **Synchronization:** The kernel sees every thread, including whether it is blocked on synchronization. (Beyond the lecture: in Linux, mutexes and condition variables are built on futexes, with a user-level fast path that needs no system call when uncontended and kernel support for blocking.)
- **Signaling:** Signals are delivered to specific kernel-level tasks. Since there's a 1:1 mapping, the kernel can deliver signals directly to the correct thread. Signal masks are maintained per task.

**Pros:** Kernel has full insight into the application's threading; blocking one thread does not block the whole process; direct kernel scheduling support.
**Cons:** Every thread operation (create, synchronize) incurs a system call cost.

#### Many-to-Many Model (Solaris / SunOS)

In the Solaris model, **m** user-level threads are mapped onto **n** kernel-level threads, where m >= n. The kernel provides lightweight processes (LWPs) to the process. Each LWP is associated with a kernel thread and has its own registers and signal mask (Paper, Stein & Shah: plus kernel-supported attributes threads lack: scheduling class, virtual-time timers, alternate signal stack, profiling buffer). From the user-level library's perspective, LWPs are the "virtual CPUs" onto which user threads are scheduled. A user thread can also be permanently **bound** to an LWP (e.g., for better priority or responsiveness to kernel events). (Paper, Stein & Shah: unbound threads are multiplexed over a pool of LWPs.) (Lecture framing: a hybrid of many-to-one and one-to-one, with unbound threads mapped many-to-one onto a kernel thread and bound threads one-to-one.)

- **Scheduling:** Two levels. The user-level library schedules unbound ULTs onto LWPs (Paper, Stein & Shah: from the pool, using priority-ordered run queues, process scope). The kernel scheduler schedules KLTs/LWPs onto physical CPUs (Paper, Stein & Shah: system scope). (Paper, Stein & Shah: the library sizes the LWP pool automatically: when all LWPs block in indefinite waits, the kernel sends **SIGWAITING**, and if runnable threads exist the library creates a new LWP.) (Lecture framing: ideally the kernel notifies the library just before blocking, so the library can request more kernel threads; Paper, Stein & Shah: SIGWAITING arrives only after all LWPs are already blocked.) The application can ask for more concurrency (Lecture framing: a `set_concurrency` system call, to which the kernel responds by allocating another kernel thread; Paper, Stein & Shah: `thr_setconcurrency(n)` is a library hint, and the library keeps at least n LWPs, creating them itself.) (Paper, Stein & Shah: idle LWPs are aged out after ~5 minutes unused. User-level preemption is done by setting a flag in the thread structure and sending the LWP a **SIGLWP**.)
- **Synchronization:** (Paper, Stein & Shah: if a ULT blocks on a process-local synchronization variable, it is placed on that variable's sleep queue and the library switches another ULT onto the same LWP, with no kernel involvement. A bound thread instead parks its LWP. Process-shared synchronization variables rely on LWP-level kernel primitives, so the thread sleeps in the kernel still attached to its LWP.) If a ULT blocks in the kernel (I/O), its LWP blocks with it (Paper, Stein & Shah: the library learns about pool exhaustion only through SIGWAITING). The kernel is unaware of the library's mutexes and wait queues, so a ULT holding a lock on a preempted KLT can stall the others. Solaris kernel mutexes are **adaptive** (Lecture framing: spin or block depending on whether the owner is running on another CPU and on the length of the critical section; Paper, Eykholt et al.: adaptive is the default kernel mutex type, which spins while the owner is running on another CPU and blocks otherwise; critical-section length is not an input).
- **Signaling:** Complex, because the kernel sees only the KLT/LWP masks, not the user-level thread masks. Signal handlers are shared by the whole process; masks are per thread. The library installs a wrapper handler that sees every ULT mask, and when the signal lands on a thread that has it masked, it swaps in a runnable ULT that can take it, sends a directed signal to the LWP running such a ULT, or, if no ULT can take it, disables the signal on that KLT by system call and reissues it to the process. (Paper, Stein & Shah: synchronous signals, e.g. SIGSEGV, go to the thread that caused them. For asynchronous signals, the library keeps each LWP mask equal to or less restrictive than its current thread's mask and interposes its own global handler. If the signal arrives at a thread that has it masked, the handler sets the LWP's mask to the thread's mask and re-sends the signal to the process if undirected, or to the LWP if directed, so it can reach another LWP running a thread with the signal enabled. If no active thread can take it, the library can run an inactive thread that has the signal unmasked. A directed `thr_kill()` to a non-running thread just posts the signal as pending in the thread structure; to a running thread it is sent to that thread's LWP via `_lwp_kill()`.)

**Pros:** Flexibility; can support many more user threads than kernel threads; user-level scheduling, synchronization, and signal-mask updates are fast (no system calls).
**Cons:** Requires coordination between user and kernel levels; complexity in signal handling; kernel has limited visibility into user threads.

### 21. Can you explain why some of the mechanisms described in the Solaris papers (for configuring the degree concurrency, for signaling, the use of LWP...) are not used or necessary in the current threads model in Linux?

The mechanisms in the Solaris papers were designed to **ration** kernel resources. Specifically:

- **Configuring the degree of concurrency** (`set_concurrency`) (Paper, Stein & Shah: `thr_setconcurrency`, plus the kernel's SIGWAITING notification used to grow the LWP pool) was needed because you couldn't just automatically get as many kernel threads as you wanted. (Paper, Stein & Shah: one LWP per thread is explicitly rejected because most would sit idle and overload the OS with their resource requirements.)
- **LWPs** served as an intermediate layer because kernel threads were too expensive to allocate one-per-user-thread. LWPs multiplexed user threads onto a smaller number of kernel threads.
- **Complex signal handling** was necessary because the kernel couldn't see user-level threads directly; signals had to be routed through the LWP/KLT layer with extra logic.

In the current Linux model (NPTL, 1:1), these mechanisms are unnecessary because:

1. **Kernel trapping has become much cheaper.** User/kernel crossings are more affordable on modern hardware, so the overhead of having the kernel manage every thread is acceptable.
2. **Modern platforms have much more memory.** The constraint that forced Solaris to keep the number of kernel threads small no longer applies. Allocating one kernel task per user thread is feasible.
3. **The kernel sees every user thread.** With 1:1, there is no need for an intermediate LWP layer, no need for user-level scheduling, no need for `set_concurrency` calls or special kernel signals, and no need for complex signal routing between user and kernel levels.
4. **Signal handling is straightforward.** Since each user thread has a corresponding kernel task, the kernel can deliver signals directly to the right task.

The tradeoff is that the 1:1 model may not scale as well at extreme thread counts. At very large scales, a many-to-many model with custom user-level policies might be more efficient, but for typical workloads, the simplicity and directness of 1:1 wins.

### 22. What's an interrupt? What's a signal? What happens during interrupt or signal handling? How does the OS know what to execute in response to an interrupt or signal? Can each process configure their own signal handler? Can each thread have their own signal handler?

#### Interrupts

An **interrupt** is an event generated **externally** by components other than the CPU (I/O devices, timers, other CPUs). Interrupts are notifications that some external event has occurred. They appear **asynchronously**, not in response to any specific action on the CPU. Which interrupts can occur depends on the **hardware platform**.

**Interrupt handling:**

1. A device sends an interrupt signal via the interconnect (or MSI message) to the CPU.
2. The interrupt is uniquely identified by its number.
3. The CPU looks up the interrupt number in the **interrupt handler table** (maintained by the OS, system-wide).
4. The CPU sets the program counter to the starting address of the corresponding handler routine.
5. The handler executes in the context of the thread that was interrupted (on that thread's stack). (Lecture framing: the traditional UNIX scheme; Paper, Eykholt et al.: in SunOS 5.0 the kernel instead switches onto the stack of a preallocated interrupt thread; the interrupted thread is pinned, not borrowed.)
6. After handling, execution returns to the interrupted thread.

Interrupt handling is per-CPU. The OS maintains interrupt masks per-CPU to enable/disable specific interrupts on specific processors. On multi-CPU systems, interrupt routing logic directs interrupts to a CPU that has the interrupt enabled.

#### Signals

A **signal** is an event triggered by the CPU and the software running on it. Signals can be **synchronous** (direct response to a CPU action, e.g., SIGSEGV from illegal memory access, SIGFPE from divide by zero) or **asynchronous** (e.g., SIGKILL sent from another process, SIGALARM from timer expiration). Which signals are available depends on the **operating system**.

**Signal handling:**

1. The OS generates the signal (or receives it from another process).
2. The OS looks up the signal number in the process's **signal handler table** (per-process, similar to the kernel's interrupt table).
3. The program counter is set to the handling routine for that signal.
4. The handler executes.

**Can each process configure their own signal handler?** Yes. Each process maintains its own signal handler table. Processes can install custom handlers via system calls like `signal()` or `sigaction()`. For most signals, processes can override the default behavior (terminate, ignore, core dump, stop, continue). Some signals cannot be caught or handled (Beyond the lecture: e.g., SIGKILL and SIGSTOP).

**Can each thread have their own signal handler?** No. Signal handlers are per-process (shared among all threads). (Paper, Stein & Shah: per-thread handler vectors were rejected as adding non-trivial complexity.) However, each thread can set its own **signal mask** to disable or enable specific signals for that thread. (Paper, Stein & Shah: synchronously generated signals, e.g. SIGSEGV, go to the thread that caused them; an asynchronous signal goes to one thread that has it unmasked; if every thread masks it, it stays pending on the process until some thread unmasks it.)

| Property          | Interrupts                        | Signals                              |
|-------------------|-----------------------------------|--------------------------------------|
| Source            | External hardware                 | CPU / software / OS                  |
| Depends on        | Hardware platform                 | Operating system                     |
| Timing            | Asynchronous                      | Synchronous or asynchronous          |
| Handler table     | System-wide (per OS)              | Per-process                          |
| Masking           | Per-CPU                           | Per-process (Paper, Stein & Shah: per thread) |
| Custom handlers   | Set by OS                         | Set by process                       |

(Lecture framing: the lecture's interrupts-vs-signals comparison says signal masks are per process; Paper, Stein & Shah: each thread and each LWP has its own mask, and only the handlers are per process.)

### 23. What's the potential issue if an interrupt or signal handler needs to lock a mutex? What's the workaround described in the Solaris papers?

**The problem:** Interrupt and signal handlers execute in the context of the interrupted thread, on that thread's stack. If the interrupted thread had already locked a mutex, and the handler code tries to lock the **same** mutex, a **deadlock** occurs. The handler cannot acquire the mutex because the interrupted thread holds it, but the interrupted thread cannot release the mutex because it is suspended while the handler runs on its stack.

**Workaround 1 (from the SunOS paper, Eykholt et al.): Interrupts as threads.**

Instead of executing the handler on the interrupted thread's stack, the handler code runs in its **own thread**. This way, if the handler needs the mutex, it blocks like any other thread and waits for the mutex holder to release it. No deadlock occurs because the original thread can continue executing and eventually release the mutex.

To avoid the cost of dynamic thread creation on every interrupt, the kernel pre-creates and pre-initializes the interrupt threads. (Paper, Eykholt et al.: it **preallocates partially initialized** interrupt threads: one per potentially active interrupt level below the "thread level", per CPU, nine SPARC interrupt levels can use threads, plus a single clock interrupt thread for the system, at roughly 8 KB each for stack and data structure. When an interrupt arrives, the kernel does the minimum work to switch onto the interrupt thread's stack. The interrupted thread is **pinned**, so it cannot run elsewhere, until the interrupt thread returns or blocks. Only if the interrupt thread blocks on a mutex or condition variable is it converted, passivated, into a full-fledged thread that any CPU can run, and the pinned thread resumes. Interrupts above the thread level are not handled as threads; they may use only spin mutexes and software interrupts. The thread level is normally the maximum priority and is lowered, typically to the scheduling clock's interrupt level, only where firmware cannot tolerate the short dispatcher lockout.)

The lectures describe a dynamic decision: if the handler does not lock, it executes on the interrupted thread's stack; if it can block, it becomes a real thread. They relate this to the common technique of splitting the handler into two halves, using Linux's names (Lecture framing: the two-half split; Paper, Eykholt et al.: SunOS does not do this, see the next paragraph):

- **Top half:** Executes in the context of the interrupted thread. Must be fast, non-blocking, minimal processing. (Paper, Eykholt et al.: no handler code runs in the interrupted context and no thread is created per interrupt; the kernel only switches onto a preallocated interrupt thread's stack.)
- **Bottom half:** Runs as a schedulable thread. Can contain arbitrary complexity, including blocking on mutexes. (Paper, Eykholt et al.: the entire handler runs in the interrupt thread, which is promoted to a full thread only if it blocks.)

(Paper, Eykholt et al.: the explicit two-level split, a bounded first-level handler that wakes a second-level thread, is the alternative the paper rejected, because it requires restructuring device drivers and always costs a full context switch. SunOS runs the whole handler on the interrupt thread and pays the full-thread cost only under contention.)

**Cost-benefit analysis (SunOS paper, specific numbers):**

- The overhead of the interrupts-as-threads approach: **~40 SPARC instructions** per interrupt (Lecture framing: the checks and, if necessary, creating a separate thread; Paper, Eykholt et al.: the fixed cost of entering through a preallocated interrupt thread).
- The savings: **~12 SPARC instructions** per mutex enter/exit (because the interrupt mask no longer needs to be changed around every mutex lock/unlock).
- Since mutex lock/unlock operations are **far more frequent** than interrupts, the net effect is a **decrease** in total instruction count, provided interrupts do not block too often. This is the "optimize for the common case" principle in action.

**Workaround 2 (from Stein & Shah): Signal masks.**

For signal handlers at user level, the fix is to mask the signal before acquiring the mutex and unmask it after releasing it, so the handler cannot run while the mutex is held (Paper, Stein & Shah: this makes the critical section **async safe**). (Paper, Stein & Shah: the example is the threads library itself: if `mutex_lock()` is interrupted while holding an internal library lock and the handler calls `mutex_lock()` again, it deadlocks.)

To make this cheap, signal mask updates happen at user level and make no system call unless a signal actually arrives (Paper, Stein & Shah: the call is `thr_sigsetmask()`, which only modifies the user-level thread mask). (Paper, Stein & Shah: for its own internal critical sections, the library goes further and sets/clears a flag in the thread structure that acts as a "mask all signals" bit; if a signal arrives while the flag is set, the library's global handler defers it.)

At the kernel level, the equivalent of masking (blocking out interrupts around each mutex) costs ~12 instructions per mutex enter/exit. The interrupts-as-threads approach eliminates this per-mutex cost at the expense of ~40 instructions per interrupt. Since mutexes are more frequent than interrupts, the interrupts-as-threads approach is the better optimization.

### 24. Contrast the pros-and-cons of a multithreaded (MT) and multiprocess (MP) implementation of a webserver, as described in the Flash paper.

| Aspect                   | Multiprocess (MP)                                     | Multithreaded (MT)                                     |
|--------------------------|-------------------------------------------------------|--------------------------------------------------------|
| **Simplicity**           | Simple: each request in its own process; no explicit sync needed | Complex: requires explicit synchronization (mutexes, CVs) |
| **Memory footprint**     | Large: separate address spaces per process            | Smaller: threads share address space                   |
| **Cache available**      | Less memory for caching (more used by processes)      | More memory for caching                                |
| **Context switch cost**  | Expensive: full address space swap, cold caches       | Cheaper: shared address space, warmer caches           |
| **Communication**        | IPC required (expensive)                              | Shared variables (cheap)                               |
| **Isolation**            | Strong: process failure doesn't affect others         | Weak: one thread crash can bring down the process      |
| **Kernel support needed**| No special threading support                          | Requires kernel-level thread support (Paper, Pai et al.: FreeBSD 2.2.6 lacked it, so Flash-MT could not run there) |
| **Application-level caching** | (Paper, Pai et al.: each process keeps its own cache: more compulsory misses, less efficient memory use) | (Paper, Pai et al.: single shared cache, but accesses must be synchronized) |
| **Information gathering**| (Paper, Pai et al.: requires IPC to consolidate statistics) | (Paper, Pai et al.: per-thread statistics with periodic consolidation, or fine-grained locking on globals) |
| **Long-lived connections**| (Paper, Pai et al.: a whole process per connection)  | (Paper, Pai et al.: a whole thread per connection)    |
| **Scalability**          | Per-process overhead limits scalability               | Better scalability with concurrent requests            |
| **Disk-bound behavior**  | Larger footprint means less cache, becomes disk-bound sooner | Smaller footprint, more cache, delays disk-bound behavior |

(Paper, Pai et al.: both MP and MT naturally overlap disk, CPU, and network activity: only the process or thread that issues a disk read blocks, and each can have one outstanding disk request, so both benefit from multiple disks and disk-head scheduling.)

In the Flash paper experiments (Paper, Pai et al.: Flash-MP used 32 processes, Flash-MT 64 threads):

- **Best case (all cached):** MP and MT lag slightly behind the event-driven servers (Lecture framing: synchronization and context switching; Paper, Pai et al.: extra kernel overhead, context switching, etc.; synchronization applies only to MT, since MP processes have private address spaces).
- **Owlnet trace (mostly cached):** Flash and SPED lead, followed by MT/MP, then Apache.
- **CS trace (disk-bound):** (Lecture framing: MT does better than MP because MT's smaller memory footprint leaves more memory for caching files, reducing the number of disk reads; Paper, Pai et al.: notes only that MP performs well on this disk-intensive trace, while Flash achieves the highest throughput.)
- **Varying data set size:** (Paper, Pai et al.: Flash-MP falls well short of the other architectures on cached workloads, likely because its per-process user-level caches are smaller. Flash-MT performed comparably to Flash, but only after the authors carefully minimized lock contention; without that, its disk-bound results resembled Flash-SPED.)
- **Many concurrent connections (WAN emulation):** (Paper, Pai et al.: MP declines significantly as connections are added, due to per-process overhead. MT holds up better but declines gradually past ~200 connections due to per-thread switching and space overhead.)

### 25. What are the benefits of the event-based model described in the Flash paper over MT and MP? What are the limitations? Would you convert the AMPED model into a AMTED (async multi-threaded event-driven)? How do you think an AMTED version of Flash would compare to the AMPED version of Flash?

**The event-based model (AMPED):** Flash uses a single-threaded event dispatcher in the main loop, with asymmetric helper processes to handle blocking I/O (disk reads). The dispatcher uses `select` (the lectures also mention `poll`/`epoll`) to detect events on file descriptors. Handlers run to completion; if they need to block, they delegate to a helper process via pipes. Flash maps files with `mmap` and checks memory residency with `mincore`, to decide between a local handler and a helper. (Paper, Pai et al.: only if pages are not resident does it ask a helper, which touches the pages to bring them into memory and returns just a completion notification, not the data. Helpers also perform pathname translations. They are spawned dynamically and kept in reserve when idle.)

**Benefits over MT and MP:**

| Benefit                       | Why                                                                        |
|-------------------------------|----------------------------------------------------------------------------|
| Smaller memory footprint      | Single address space, single main thread; helpers needed only per concurrent disk operation, not per connection |
| More memory for caching       | Smaller footprint means more memory available for file/computation caches  |
| No context switching overhead | Single main thread processes events sequentially; no thread/process switch |
| No synchronization overhead   | Single thread of control means no mutexes or condition variables needed    |
| Single unsynchronized cache   | Application-level caches are shared without locks (Paper, Pai et al.: statistics too, without IPC) |
| Cheap long-lived connections  | (Paper, Pai et al.: a connection costs a file descriptor and some state, not a thread/process) |
| Delays disk-bound behavior    | More cache means fewer disk reads are needed                               |

Flash also performs application-level caching at multiple levels: pathname translation caching, response header caching, and mapped file caching (Paper, Pai et al.: inactive mapped chunks kept in an LRU free list). (Lecture framing: alignment for DMA and DMA with scatter-gather, i.e. vector I/O; Paper, Pai et al.: it pads response headers to 32-byte multiples so that `writev` of header plus file data does not cause misaligned copies in the kernel, keeping the copies aligned with 32-byte CPU cache lines.)

Compared to SPED specifically, AMPED does not stall all processing when a request misses in the file cache. (Paper, Pai et al.: non-blocking `read` on disk files can still block on FreeBSD 2.2.6, Solaris 2.6, and most UNIX systems, and true async disk APIs were not integrated with `select`.)

**Limitations:**

- Not every kernel supports asynchronous I/O. Flash must fake it using helper processes.
- The event-driven model works well for server-type applications, but is not necessarily applicable to arbitrary applications.
- Event routing on multi-CPU systems adds complexity.
- A bug in the main event loop can block the entire server.
- Helper processes add the overhead of IPC (pipes) and process creation/management.
- The `mincore` residency check is wasted work on fully cached workloads, which is why SPED outperforms Flash there (Paper, Pai et al.: only slightly).

**AMPED -> AMTED conversion:**

Yes, converting to AMTED (Async Multi-Threaded Event-Driven) would make sense. Replace helper **processes** with helper **threads**.

**How AMTED would compare to AMPED:**

- **Better performance:** Helper threads share the address space with the main event loop, so they have a smaller memory footprint than helper processes. This means even more memory is available for caching.
- **Cheaper context switching:** Thread context switches between helpers and the event loop are cheaper than process context switches.
- **Cheaper communication:** Shared memory (shared variables) vs. pipes for IPC.
- **Performance differential:** Likely on par with the difference between standard MT and MP models. Not dramatic, but a consistent improvement. (Paper, Pai et al.: the gain is bounded because the helpers already share file data with the main process through `mmap` and the OS page cache, return only a short completion notification, and are few in number, only enough to keep the disk busy.)
- **Caveat:** Threads would share the main process's address space, so a crashing or misbehaving helper could take down the server, and any shared state touched by helpers would need synchronization.
- **Historical context:** Separate processes were chosen instead of kernel threads to keep Flash portable to operating systems that did not (yet) support kernel threads (Paper, Pai et al.: such as FreeBSD 2.2.6). On modern systems with reliable kernel threading, AMTED would be the obvious choice.

### 26. There are several sets of experimental results from the Flash paper discussed in the lesson. Do you understand the purpose of each set of experiments (what was the question they wanted to answer)? Do you understand why the experiment was structured in a particular way (why they chose the variables to be varied, the workload parameters, the measured metric...)?

The Flash paper compares: Flash (AMPED), SPED (single-process event-driven), MT (multithreaded), MP (multiprocess), Zeus (Lecture framing: the slide lists it as "SPED w/ 2 processes"; Paper, Pai et al.: Zeus v1.30, a SPED server run with two processes for the trace tests, as the vendor advised, and one process for the synthetic test), and Apache (multiprocess, no aggressive optimizations at the time; Paper, Pai et al.: v1.3.1). SPED, MT, and MP were built from the same code base (Paper, Pai et al.: as Flash-SPED, Flash-MT, and Flash-MP, by swapping only the event/helper dispatch mechanism), so differences reflect architecture rather than implementation quality. (Paper, Pai et al.: tests ran on a 333 MHz Pentium II with 128 MB of memory under both Solaris 2.6 and FreeBSD 2.2.6, with event-driven client programs issuing requests as fast as the server could handle them.)

**Metrics used:** Bandwidth (bytes transferred / time) and connection rate (connections serviced / time), both as a function of file size.

#### Experiment 1: Synthetic Best Case

- **Question:** What does performance look like when every request is a cache hit?
- **Setup:** All requests ask for the **same file**, varied in size from 0 to 200 KB. Since only one file is ever requested, it is always cached after the first access.
- **Why this structure:** By varying file size, they vary the amount of work per request. Using a single file guarantees cache hits, isolating the overhead of the server itself from disk I/O.
- **Results:** All implementations are similar (Paper, Pai et al.: architecture has little impact on a trivial cached workload). SPED is best (no extra checks; Lecture framing: the summary slide writes "SPED >> AMPED Flash"; Paper, Pai et al.: Flash-SPED only "slightly outperforms" Flash). Flash is close but does an extra `mincore` check for memory presence. Zeus shows an anomaly (Lecture framing: a drop around 125 KB on the Solaris graph the lecture shows, from a DMA misalignment; Paper, Pai et al.: it occurs on FreeBSD for files between 10 and 100 KB and is attributed to the byte-alignment problem that Flash avoids by padding headers). MT/MP are lower (Lecture framing: synchronization and context switching overhead; Paper, Pai et al.: extra kernel overhead such as context switching, and MP needs no synchronization between requests because its processes have private address spaces). Apache is lowest (no optimizations). (Paper, Pai et al.: all servers perform substantially better on FreeBSD than on Solaris, but their relative order is unchanged.)
- **Takeaway:** When data is cached, the overhead differences between models are small, but event-driven models have a slight edge because they avoid context-switching overhead (and, compared with MT, synchronization).

#### Experiment 2: Owlnet Trace

- **Question:** How do the servers perform with a realistic small workload that mostly fits in memory?
- **Setup:** Replayed traces from the Rice Owlnet web server (student-run websites; relatively small working set that mostly fits in memory) (Paper, Pai et al.: personal pages for ~4,500 students and staff). Replaying real logs gives a realistic yet reproducible request distribution.
- **Why this trace:** Represents a realistic workload that is mostly cache-friendly but not entirely.
- **Results:** Flash and SPED are best. Flash is slightly better than SPED because when a request requires disk I/O (not cached), SPED blocks entirely while Flash delegates to helper processes. MT/MP follow, then Apache.
- **Takeaway:** For mostly-cached workloads, AMPED and SPED dominate, but AMPED handles the occasional disk access gracefully.

#### Experiment 3: CS Trace

- **Question:** How do the servers perform with a realistic large workload that does not fit in memory?
- **Setup:** Replayed traces from the Rice CS department web server (large number of files, working set far exceeds memory).
- **Why this trace:** Represents a disk-heavy, realistic workload where caching is insufficient.
- **Results:** SPED performance drops dramatically (it blocks on every disk read with no helpers and no async I/O). MT does better than MP (Lecture framing: smaller memory footprint = more cache = fewer disk reads, plus cheaper context switching; Paper, Pai et al.: notes only that MP performs well on this disk-intensive trace). Flash performs **best**: a smaller memory footprint than MP/MT, more memory for caching, fewer disk reads, no explicit synchronization overhead. (Paper, Pai et al.: Flash needs only enough helpers to keep the disk busy rather than a process or thread per connection.) Apache is lowest on both traces (Paper, Pai et al.: comparing it with Flash-MP shows this is mostly due to its lack of optimizations, and only partly due to its MP architecture).
- **Takeaway:** When the workload is disk-bound, Flash's AMPED model shines because its small footprint maximizes cache utilization.

#### Experiment 3b: Real Workload with Varying Data Set Size (Paper, Pai et al.)

- **Question:** How does performance change as the working set grows from fitting in memory to exceeding it?
- **Setup:** Rice ECE department server logs, truncated to produce data sets of different sizes and replayed in a loop by 64 clients. Bandwidth is reported instead of requests/sec because truncating the log also changes the file-size distribution.
- **Results:** All servers decline as the data set grows, with a sharp drop once the working set exceeds the effective cache. Flash tracks SPED when the data is cached and meets or beats MP once the workload is disk-bound, i.e., it combines the best of both. SPED (and Zeus) deteriorate quickly as disk activity increases. Flash-MP is weak even on cached workloads because of its smaller per-process caches. Solaris results are up to 50% lower than FreeBSD.
- **Takeaway:** AMPED is the only architecture that performs well across the whole range.

#### Experiment 4: Impact of Optimizations

- **Question:** How much do Flash's application-level optimizations contribute to performance?
- **Setup:** (Paper, Pai et al.: same configuration as the single-file test on FreeBSD, with clients repeatedly requesting one cached file of a given size.) Measured connection rate vs. file size for combinations of the three optimizations: pathname translation caching, response header caching, mapped file caching (Lecture framing: four curves: none, pathname only, pathname plus mapped file, and all three; Paper, Pai et al.: all eight combinations).
- **Why this structure:** Isolates the contribution of each optimization.
- **Results:** Connection rate decreases with file size (more work per connection). Connection rate increases as optimizations are added. Fully optimized Flash has the highest connection rate. (Paper, Pai et al.: pathname translation caching provides the largest single benefit. Because each optimization removes a per-request cost, the effect is strongest for small files; without any of them, Flash's small-file performance would drop by about half.)
- **Takeaway:** Application-level optimizations (caching at multiple levels) provide significant, cumulative performance gains.

#### Experiment 5: WAN Performance (Paper, Pai et al.)

- **Question:** How do the servers scale with the number of concurrent connections? WAN clients have limited bandwidth and packet loss, so connections last longer and a real server at a given request rate holds many more concurrent connections than a LAN benchmark would show.
- **Setup:** WAN conditions were emulated on the LAN using persistent HTTP connections, increasing the number of simultaneous clients. Requests replayed the ECE logs with a 90 MB data set (to expose limited file cache effects), on Solaris.
- **Results:** SPED, AMPED (Flash), and MT initially rise as connections are added (more concurrency, and each `select` call reports more ready events, amortizing its cost). Past ~200 connections, SPED and AMPED flatten, while MT declines gradually due to per-thread switching and space overhead. MP declines significantly due to per-process overhead and multiple application-level caches.
- **Takeaway:** The per-process overhead of the MP model makes it scale poorly. Event-driven models handle increasing client counts best; MT is close but pays a per-thread cost.

(Paper, Pai et al.: overall, Flash matches or exceeds the other architectures across workloads, beating Zeus by up to 30% and Apache by up to 50% on real workloads.)

### 27. If you ran your server from the class project for two different traces: (i) many requests for a single file, and (ii) many random requests across a very large pool of very large files, what do you think would happen as you add more threads to your server? Can you sketch a hypothetical graph?

#### Scenario (i): Many requests for a single file

Once the file is read from disk the first time, it stays in memory (cached). Every subsequent request is served from memory. Adding more threads allows more concurrent requests to be processed, and since every request hits the cache, each thread completes quickly.

- Initially, adding threads increases throughput sharply (more concurrency, no disk bottleneck).
- Eventually, throughput plateaus as the CPU becomes the bottleneck, or context switching overhead offsets the gains.

#### Scenario (ii): Many random requests across a very large pool of very large files

The working set far exceeds available memory. Each new request is unlikely to find its file in cache and must read from disk. The application is **disk-bound** from the start.

- Initially, adding threads provides modest improvement by hiding disk latency (while one thread waits for disk I/O, another can do useful work).
- Throughput plateaus quickly once the disk is saturated. Additional threads beyond this point add context-switching overhead, synchronization contention, and consume memory that could otherwise be used for caching, potentially even causing throughput to decrease slightly.

#### Hypothetical Throughput vs. Threads Graph

```
Throughput
    ^
    |
    |        (i) Single file
    |       /----------------------------  (plateau, CPU-bound)
    |      /
    |     /
    |    /
    |   /     (ii) Large pool of large files
    |  /    /------  (plateau, disk-bound)
    | /    /
    |/   /
    |  /
    | /
    +--------------------------------------> Threads
    1    4    8    12   16   20   24
```

- **Curve (i)** rises steeply and plateaus at a high throughput value. The single file is always cached, so the limit is CPU and context-switching overhead.
- **Curve (ii)** rises modestly and plateaus at a much lower throughput value. The disk is the bottleneck, and adding threads beyond the point of disk saturation provides no benefit (and may even hurt as memory is consumed by thread stacks instead of file caching).

The gap between the two curves illustrates the difference between a CPU-bound (cache-friendly) workload and a disk-bound (cache-hostile) workload. For the single-file workload, the server can scale with threads up to CPU limits. For the large-pool workload, the server hits the disk wall quickly, and threads cannot fix a hardware bottleneck.
