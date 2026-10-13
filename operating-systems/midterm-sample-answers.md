---
id: operating-systems-midterm-sample-answers
title: Sample Midterm Exam Answers
course: operating-systems
lecture: midterm-sample-answers
---

# Sample Midterm Exam Answers

These answers are based on the course lecture notes and assigned papers (Birrell, Eykholt et al., Stein & Shah, Pai et al.). The sample midterm has six questions; each answer below cites its source lectures and provides exam-ready coverage of the topic.

Convention note: if a question says "n threads" in a boss/workers context, assume 1 boss + (n-1) workers. If it says "n worker threads," it means n workers. Use two decimal places for numerical answers.

---

## Question 1: Processes vs Threads

**Lectures**: P2L1 (Processes and Process Management, videos 44-55), P2L2 (Threads and Concurrency, videos 75-80)

### What is a Process?

A process is an active instance of an application. When a program is loaded from disk into memory and begins executing, it becomes a process. A process encapsulates all of the state of a running application within an **address space**, which includes:

- **Code**: the program instructions
- **Data**: static/initialized data
- **Heap**: dynamically allocated memory (grows upward)
- **Stack**: function call frames, local variables (grows downward, LIFO)

The operating system maintains a **process control block (PCB)** for each process, which contains:

- Process state (new, ready, running, waiting, terminated)
- Process number (PID)
- Program counter
- CPU registers
- Memory limits / virtual-to-physical address mappings (page table)
- CPU scheduling information
- Open file descriptors, I/O status, etc.

Each process has its own **virtual address space**, and the OS maintains a **page table** that maps virtual addresses to physical addresses. Processes are isolated from one another: process A cannot read or write memory belonging to process B.

### What is a Thread?

A thread is an independent execution context *within* a process. Threads belonging to the same process share the same virtual address space, meaning they share code, data, heap, and files. Each thread has its own:

- **Program counter** (PC)
- **Stack pointer** (SP) and stack
- **CPU registers**
- Thread ID

A multithreaded process has a more complex PCB structure that incorporates these per-thread execution contexts alongside the shared process-level state.

### Key Differences

| Aspect | Process | Thread |
|---|---|---|
| Address space | Own private address space | Shares address space with other threads in the same process |
| Creation cost | Expensive (new PCB, new address space, new page table) | Cheaper (new execution context only; shared address space) |
| Memory footprint | Large (each process duplicates address space) | Small (threads share code, data, heap) |
| Communication | IPC required (message passing or shared memory setup) | Direct read/write of shared variables |
| Isolation | Full isolation between processes | No isolation; a bug in one thread can corrupt shared state |
| OS visibility | Always visible to kernel | User-level threads may not be visible to kernel (depends on threading model) |

### Context Switching

**Process context switch**:

1. Save the entire PCB of the current process (registers, PC, SP, memory mappings, etc.) to memory.
2. Load the PCB of the next process from memory into CPU registers.
3. Update virtual-to-physical address mappings (page table base register).
4. The hardware cache goes from **hot** (current process's data cached) to **cold** (new process's data must be fetched from main memory). A main-memory access costs hundreds of cycles versus a few cycles for a cache hit, so a cold cache slows the incoming process's early accesses.

**Thread context switch** (threads within the same process):

1. Save the execution context of the current thread (registers, PC, SP) to its thread control block.
2. Load the execution context of the next thread.
3. No need to change virtual-to-physical address mappings, since threads share the same address space.
4. The cache is more likely to remain **hot**, because threads share data and code. The new thread may find relevant data already in cache.

Thread context switching is cheaper than process context switching in both **direct costs** (fewer CPU cycles to save/restore state, no page table swap) and **indirect costs** (cache remains warmer due to shared address space locality).

### When to Use Each

Use **multiple processes** when:

- Strong isolation is required between tasks (e.g., a web server and a database should not be able to corrupt each other's memory)
- Fault tolerance matters (one process crashing does not kill others)
- The application is naturally structured as independent programs

Use **multiple threads** when:

- Tasks share a lot of state and need to communicate frequently
- Low-overhead concurrency is desired
- Memory footprint is a concern
- You need to exploit parallelism within a single application (e.g., processing different parts of an input concurrently)

---

## Question 2: Thread Creation

**Lectures**: P2L2 (Threads and Concurrency, videos 81-83), P2L3 (Threads Case Study: PThreads, videos 122-132)

### Thread Data Structures

To represent a thread, the system needs:

- Thread ID
- Program counter (PC)
- Stack pointer (SP)
- Register values
- Stack (each thread gets its own)
- Other attributes (priority, scheduling policy, etc.)

### Creating Threads: Fork and Join

In the Birrell threading model (which PThreads follows), threads are created using a **fork** call (not the UNIX process fork) that takes two arguments:

- `proc`: the procedure (function) the new thread will execute
- `args`: the arguments to pass to that procedure

```
child_thread = fork(proc, args)
```

When `fork` is called:

1. A new thread data structure is allocated and initialized.
2. The new thread's PC is set to the first instruction of `proc`.
3. The new thread's stack is set up with `args`.
4. The new thread is placed on the ready queue.
5. Both the parent and the child thread can now execute concurrently.

The **join** mechanism allows a parent thread to wait for a child thread to complete:

```
result = join(child_thread)
```

When `join` is called:

1. The parent thread blocks until the child thread finishes.
2. When the child completes, its result is returned to the parent via `join`.
3. The child thread's resources are deallocated.

(Paper, Birrell: `fork` returns a handle that can be passed to `join`, and `join` returns the forked procedure's result. If a thread's procedure returns and nobody calls `join`, the thread "quietly evaporates"; `join` is rarely used in practice, since most forked threads are long-lived daemons.) In PThreads, a joinable thread that finishes but is never joined remains a **zombie**: it has completed its work but its resources have not been reclaimed.

### PThreads API

In PThreads, the concrete API is:

```c
// Create a thread
int pthread_create(
    pthread_t *thread,            // thread handle (output)
    const pthread_attr_t *attr,   // attributes (NULL for defaults)
    void *(*start_routine)(void *), // function to execute
    void *arg                     // argument to function
);

// Join a thread (wait for completion)
int pthread_join(pthread_t thread, void **status);
```

Thread attributes (`pthread_attr_t`) can configure:

- Stack size
- Scheduling policy and priority
- System vs. process scope
- Joinable vs. detached state

**Detached threads** cannot be joined. The parent does not need to wait for them. Created via:

```c
pthread_detach(thread);
// or set at creation time:
pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
```

(Lecture framing: detachable threads are a mechanism Birrell did not describe, and a parent should not exit before its joinable children; Paper, Birrell: an unjoined thread already "quietly evaporates", which behaves like a detached thread. In POSIX, letting other threads outlive `main` requires `pthread_exit()`, not detachment.)

### Thread Lifecycle

1. **Created**: `pthread_create` allocates thread data structure, initializes PC/SP/registers.
2. **Ready**: thread is on the ready queue, waiting to be scheduled.
3. **Running**: thread is executing on a CPU.
4. **Waiting/Blocked**: thread is waiting on a mutex, condition variable, I/O, etc.
5. **Completed/Joined**: thread finishes execution. If joinable, parent calls `join` to retrieve result and reclaim resources. If detached, resources are reclaimed automatically.
6. **Zombie**: thread is done but not yet reaped. Exited threads are placed on **death row**, and a **reaper** thread periodically garbage-collects their data structures. (Lecture framing: if a new thread is requested before reaping, the exited thread's data structures can be reused; Paper, Stein & Shah: the reaper frees each exited thread's stack onto a cache of thread stacks, and that cache is what speeds up later creation; deathrow holds only detached threads, while undetached ones sit on a zombie list until `thr_join()` reaps them.)

### Race Condition Example

A common pitfall when creating threads in a loop:

```c
// BUGGY: data race on i
for (int i = 0; i < NUM_THREADS; i++) {
    pthread_create(&threads[i], NULL, threadFunc, &i);
}
```

The problem: `i` is shared. By the time the child thread dereferences the pointer, the main thread may have already incremented `i`. Multiple threads may see the same value.

The fix: copy `i` into per-thread private storage:

```c
int tNum[NUM_THREADS];
for (int i = 0; i < NUM_THREADS; i++) {
    tNum[i] = i;
    pthread_create(&threads[i], NULL, threadFunc, &tNum[i]);
}
```

---

## Question 3: Synchronization, Reader/Writer Problem

**Lecture**: P2L2 (Threads and Concurrency, videos 90-101)

### The Reader/Writer Problem

Multiple readers can access shared state concurrently, but a writer requires exclusive access. Readers and writers cannot access the shared state at the same time.

- `resource_counter == 0`: resource is free; both reads and writes allowed
- `resource_counter > 0`: resource is being read; only more reads allowed
- `resource_counter == -1`: resource is being written; no reads or writes allowed

The `resource_counter` is a **proxy variable** that encodes the state of the shared resource. We control access to the proxy variable with a mutex, rather than wrapping the entire read/write operation in a mutex (which would be too restrictive, as it would prevent concurrent reads).

### Synchronization Constructs Needed

- `resource_counter`: proxy variable (int)
- `counter_mutex`: mutex protecting access to `resource_counter`
- `read_phase`: condition variable signaling that reading is allowed
- `write_phase`: condition variable signaling that writing is allowed

### Reader Code

```c
// --- Enter critical section (reader) ---
mutex_lock(&counter_mutex);

while (resource_counter == -1)    // a writer is active
    cond_wait(&read_phase, &counter_mutex);

resource_counter++;               // register as a reader
mutex_unlock(&counter_mutex);

// --- Perform read (outside mutex) ---
// ... read shared data ...

// --- Exit critical section (reader) ---
mutex_lock(&counter_mutex);
resource_counter--;

if (resource_counter == 0)        // last reader out
    cond_signal(&write_phase);    // wake ONE waiting writer

mutex_unlock(&counter_mutex);
```

### Writer Code

```c
// --- Enter critical section (writer) ---
mutex_lock(&counter_mutex);

while (resource_counter != 0)     // readers or writer active
    cond_wait(&write_phase, &counter_mutex);

resource_counter = -1;            // mark as writing
mutex_unlock(&counter_mutex);

// --- Perform write (outside mutex) ---
// ... write shared data ...

// --- Exit critical section (writer) ---
mutex_lock(&counter_mutex);
resource_counter = 0;             // done writing
cond_broadcast(&read_phase);      // wake ALL waiting readers
cond_signal(&write_phase);        // wake ONE waiting writer
mutex_unlock(&counter_mutex);
// (Moving the broadcast/signal after the unlock is the lecture's fix for spurious wake-ups; see below.)
```

### Why Use `while` Instead of `if` for the Predicate Check?

When a thread is woken from `cond_wait`, two things happen as logically separate steps:

1. The thread is removed from the condition variable's wait queue.
2. The thread reacquires the mutex.

Between these two steps, another thread could acquire the mutex and change the shared state. The condition that was true when the signal was sent may no longer be true when the waking thread actually acquires the mutex. The `while` loop rechecks the predicate after reacquiring the mutex, ensuring correctness.

Using `if` instead of `while` is a bug: the thread would proceed even if the condition is no longer satisfied.

(Paper, Birrell: three reasons for the `WHILE NOT expression DO Wait(m, c)` pattern: `Signal` does not guarantee the awoken thread is the next to lock the mutex; an implementation may, rarely, wake more than one thread on `Signal`; and the predicate can be verified by local inspection instead of checking every place that signals the condition. The pattern also makes extra wake-ups benign, so `Signal` vs `Broadcast` becomes a performance question rather than a correctness one.)

### Spurious Wake-ups

(Lecture terminology; Birrell's differs, see below.) A **spurious wake-up** occurs when a thread is woken from a condition variable wait queue but cannot make progress. This happens when, for example, a writer holds the mutex while calling `broadcast` on `read_phase`. The reader threads are removed from the condition variable wait queue, but since the writer still holds the mutex, the readers immediately block on the mutex. They were woken up only to be placed on a different wait queue.

Spurious wake-ups do not affect **correctness** (the `while` loop protects against proceeding incorrectly) but hurt **performance** due to wasted context switches.

To reduce spurious wake-ups: call `signal`/`broadcast` **after** unlocking the mutex, when possible. This is not always possible; if the decision to signal depends on shared state, the signal must occur inside the mutex. (Lecture framing: the signal stays inside the mutex; Paper, Birrell: only the test needs the mutex, as described next.)

(Paper, Birrell: finer-grained terms. The mutex-held case is a **spurious lock conflict**, which on a multiprocessor costs two extra reschedules; the fix computes `doSignal` inside the lock and signals after it. **Spurious wake-up** is reserved for waking threads that cannot make progress at all, caused by using `Broadcast` where `Signal` suffices or by having readers and writers wait on one condition variable. The fix for the latter is separate `cR`/`cW` condition variables plus a `readWaiters` count: a finishing writer broadcasts `cR` if readers are waiting, otherwise signals `cW`.) The lecture's writer wakes both classes, which is correct but less efficient.

### Why `broadcast` for Readers, `signal` for Writers?

- **Readers**: multiple readers can proceed concurrently, so we `broadcast` to wake all waiting readers.
- **Writers**: only one writer can proceed at a time, so we `signal` to wake exactly one waiting writer. (Lecture framing: signal wakes exactly one; Paper, Birrell: at least one, possibly more, which the `while` loop tolerates.)

Note: using `broadcast` where `signal` is sufficient is safe but wasteful. Using `signal` where `broadcast` is needed is a correctness bug.

### Critical Section Structure

The actual read/write operations happen **outside** the mutex. The mutex protects only the entry and exit bookkeeping (updating the proxy variable and checking/signaling conditions). This structure allows concurrent reads while still enforcing mutual exclusion between readers and writers and between writers and writers.

```
[lock mutex] -> [check condition / wait] -> [update proxy] -> [unlock mutex]
    -> PERFORM WORK (outside mutex) ->
[lock mutex] -> [update proxy] -> [signal/broadcast] -> [unlock mutex]
```

---

## Question 4: Thread Design Considerations (Solaris/SunOS Papers)

**Lectures**: P2L2 (Threads and Concurrency, videos 107-109), P2L4 (Thread Design Considerations, videos 148-183)
**Papers**: Eykholt et al. (SunOS/Solaris multithreading), Stein & Shah (Lightweight threads in Solaris)

### Threading Models

**One-to-One (1:1)**: each user-level thread maps to one kernel-level thread.

- Pros: the kernel sees all threads and can make informed scheduling decisions. Blocking one thread does not block the process.
- Cons: expensive, every thread operation requires a kernel crossing. Limited to kernel-supported policies.

**Many-to-One (M:1)**: all user-level threads map to a single kernel-level thread.

- Pros: portable (all management at user level), no system calls for thread operations.
- Cons: if one user thread blocks (e.g., I/O), the entire process blocks. No true parallelism on multiprocessor systems. The kernel has no visibility into the application's threading.

**Many-to-Many (M:N)**: M user-level threads map to N kernel-level threads, where M >= N.

- Pros: best of both worlds. The kernel knows the process is multithreaded. Blocking one kernel thread does not block the entire process. User-level library can manage threads without always crossing into the kernel.
- Cons: complex coordination required between user-level library and kernel scheduler.

### Solaris Threading Architecture

Solaris 2.0 supported the many-to-many model with three layers (user threads can also be permanently **bound** to an LWP, e.g., for better priority or responsiveness). (Paper, Stein & Shah: unbound threads are multiplexed by the library over a pool of LWPs, and each bound thread has its own dedicated LWP.) (Lecture framing: a hybrid of many-to-one and one-to-one, in which unbound user threads map many-to-one onto a kernel thread and bound threads map one-to-one.)

1. **User-level threads (ULTs)**: managed by user-level library; unknown to the kernel. The thread structure holds the thread ID, a saved execution context (registers), signal mask, priority, and a pointer to the stack (Paper, Stein & Shah: thread-local storage, including a private `errno`, is carved from the base of the stack). (Lecture framing: TLS is a field of the thread data structure; Paper, Stein & Shah: the thread structure itself lives in TLS). The thread ID is an index into a table of thread pointers (not a raw pointer), so the library can encode information in the table entry and give meaningful error feedback (Paper, Stein & Shah: for IDs of exited, deallocated threads). Stacks are separated by **red zones** (Lecture framing: thread structures sit contiguously in memory, so a stack overrun would overwrite the neighboring thread's data, and red zones are gaps between them; Paper, Stein & Shah: the library leaves the page after each library-allocated stack invalid, so running off the stack faults in the offending thread instead of silently corrupting memory). (Paper, Eykholt et al.: the same protection exists for kernel stacks, via the `seg_kp` segment driver.)

2. **Lightweight Processes (LWPs)**: the kernel-visible entity that connects user threads to kernel threads. (Paper, Eykholt et al.: the LWP structure holds the pcb with user-level registers, system call arguments, signal masks, resource usage info, profiling pointers, and pointers to its kernel thread and process.) LWPs are the "virtual CPUs" that the user-level library schedules ULTs onto. LWP data is **swappable** (not needed when the process isn't running); the kernel stack is allocated with it in the swappable region.

3. **Kernel-level threads (KLTs)**: contain kernel-level registers, scheduling info (Paper, Eykholt et al.: scheduling class and dispatch queue links), stack pointer, and pointers to associated LWP, process, and CPU structures. KLT data is **not swappable** (needed by kernel services like the scheduler even when the thread isn't running). (Paper, Eykholt et al.: the thread structure therefore also carries the LWP data that must remain available while the LWP is swapped out. Every LWP has a kernel thread, but not every kernel thread has an LWP; system threads and interrupt threads do not.)

The CPU data structure contains the current thread, a list of kernel-level threads, and dispatching and interrupt handling information (Lecture framing: a per-CPU list of kernel-level threads; Paper, Eykholt et al.: the cpu structure points to the current and idle threads, and thread lists hang off the process and a system-wide list). On SPARC, a dedicated register points to the current thread structure (Paper, Eykholt et al.: global register `%g7`, so `curthread` fields are reachable in one instruction).

### Hard vs. Light Process State

The PCB is split:

- **Hard process state**: shared by all threads (virtual address mappings, user credentials, signal handlers). (Paper, Eykholt et al.: this is the `proc` structure: list of the process's kernel threads, address space pointer, credentials, signal handler list.)
- **Light process state**: specific to a subset of user threads associated with a particular kernel thread (signal masks, system call arguments)

This split means context switches between kernel threads within the same process only need to swap the light state, not the entire PCB.

### Signal Handling in Multithreaded Processes

Each ULT has a **user-level signal mask**. Each KLT has a **kernel-level signal mask**. The user-level library installs itself as the signal handler at the kernel level, giving it the ability to route signals to the correct user thread.

Several scenarios:

1. **KLT mask enabled, running ULT mask enabled**: signal delivered directly to the ULT handler. No problem.

2. **KLT mask enabled, running ULT mask disabled, a runnable (not running) ULT has it enabled**: the library's wrapper handler, which can see all ULT masks, invokes the user-level scheduler to swap in the ULT that can handle the signal, then passes the signal to its handler.

3. **Enabled ULT is already running on another KLT**: the library's wrapper handler recognizes the current ULT cannot handle it and sends a **directed signal** to the KLT (LWP) where that ULT is running; the kernel delivers it there, and the wrapper passes it to that ULT's handler.

4. **All ULTs have the signal disabled**: the library makes a system call to disable the signal on that KLT, then re-sends the signal to the whole process (Paper, Stein & Shah: to the same LWP if the signal was directed, to the process if undirected). The OS delivers it to another KLT that still has it enabled, and the process repeats until every KLT has it disabled. When a ULT later re-enables the signal, another system call re-enables it at the kernel level.

This is another **optimization for the common case**: signal mask changes at the user level (which happen frequently) are cheap, just flipping a bit in user-space, no system call needed. The expensive kernel-level correction only happens when a signal actually arrives at a "wrong" thread, which is infrequent.

- (Paper, Stein & Shah: the library keeps each LWP's mask equal to or **less restrictive** than its current thread's mask, and interposes its own global handler below the application's handlers.)
- (Paper, Stein & Shah: on delivery, the global handler checks the current thread's mask. If the signal is enabled, it calls the application handler. If it is masked, the handler sets the LWP's mask to the thread's mask and **re-sends** the signal: to the process if undirected, to the LWP if directed. If no ACTIVE thread can take it, the library can run an inactive thread that has it unmasked.)
- (Paper, Stein & Shah: `thr_sigsetmask()` makes no system call unless a signal actually arrives; internally the library uses an even cheaper per-thread "in critical section" flag that defers all signals.)
- (Paper, Stein & Shah: synchronous signals, e.g. `SIGSEGV`, go to the thread that caused them. All threads share one vector of signal handlers; only masks are per-thread.)
- (Paper, Stein & Shah: **directed signals**: `thr_kill()` posts the signal as pending on the thread if it is not ACTIVE, or sends it to the thread's LWP via `_lwp_kill()` if it is. The kernel-added `SIGLWP` signal is used this way for inter-LWP signaling, e.g., to preempt a thread running on another LWP.)

### Interrupts as Threads (SunOS Paper)

**The problem**: if an interrupt handler runs in the context of the interrupted thread and tries to acquire a mutex that the thread already holds, **deadlock** occurs. The handler cannot proceed until it gets the mutex, and the thread cannot release the mutex until the handler returns.

**Naive solution**: disable interrupts (mask them) before acquiring a mutex, re-enable after releasing. This costs ~12 SPARC instructions per mutex enter/exit (to manipulate the mask). (Paper, Eykholt et al.: raising/lowering interrupt priority is especially expensive with external interrupt controllers, interdependent kernel subsystems end up holding high priority for long periods, and handlers are confined to code that can never sleep.)

**SunOS solution**: treat interrupts as threads that can block and use the standard synchronization primitives (Paper, Eykholt et al.: this applies to most interrupts, handled as asynchronously created, high-priority threads). When an interrupt arrives (Lecture framing: the handler splits into a top half and a bottom half, a common technique whose names Linux also uses; Paper, Eykholt et al.: SunOS rejected a mandatory two-level split and runs the whole handler on an interrupt thread that becomes a full thread only if it blocks):

- **Top half**: (Lecture framing: minimal processing in the context of the interrupted thread, fast and non-blocking; Paper, Eykholt et al.: the kernel does the minimum work to switch onto the stack of a **preallocated, partly initialized** interrupt thread; the interrupted thread is **pinned**, so it cannot run elsewhere, until the interrupt thread returns or blocks.)
- **Bottom half**: if the handler must block (e.g., on a contended mutex), it runs as a real thread that can be scheduled and blocked like any other, and the original thread resumes (Paper, Eykholt et al.: the interrupt thread **passivates**, saving its state to become a full-fledged thread that any CPU can schedule, and the pinned thread resumes). From then on it contends for mutexes like any other thread. No deadlock possible.

The kernel pre-creates and pre-initializes thread structures for interrupt routines to avoid the cost of dynamic thread creation, which removes thread creation from the fast path of interrupt processing (Paper, Eykholt et al.: an interrupt thread is converted into a full thread only when it blocks, and on SPARC this includes flushing the register file). (Paper, Eykholt et al.: the alternative of a bounded first-level handler that always wakes a second-level thread is explicitly rejected, because it would require restructuring drivers and always cost a full context switch.)

**The trade-off**:

- **Cost**: ~40 SPARC instructions of additional overhead per interrupt taken (Lecture framing: the 40 instructions pay for the checks and, if necessary, creating a separate thread; Paper, Eykholt et al.: they are the fixed cost of entering through a preallocated interrupt thread, since no thread is created per interrupt).
- **Savings**: ~12 SPARC instructions saved per mutex enter/exit (no longer need to disable/re-enable interrupts around every mutex operation).
- **Net result**: a net gain, because **mutex operations are far more frequent than interrupts**, as long as interrupts do not block too often. This is a textbook example of **optimizing for the common case**.
- **Memory cost** (Paper, Eykholt et al.: one preallocated interrupt thread, stack plus structure, ~8 KB, per interrupt level below the "thread level" per CPU, nine such levels on SPARC, plus one clock interrupt thread for the whole system. Interrupts above the thread level are not handled as threads and may only use spin mutexes.)

### Why Solaris Mechanisms Are Not Needed in Linux

Linux uses the **Native POSIX Threads Library (NPTL)**, a strict **1:1 model**. Every user-level thread has exactly one kernel-level task (`struct task_struct`). Reasons this works now:

1. **Kernel trapping is cheaper** on modern hardware, so the overhead of a system call per thread operation is acceptable.
2. **Modern systems have more memory**, removing the pressure to minimize kernel thread count.
3. With 1:1, the kernel has full visibility into all threads, so there is no need for:
   - LWPs as an intermediate layer (the KLT *is* the ULT's execution context)
   - `set_concurrency` calls (the kernel already schedules all threads)
   - Complex user/kernel signal mask synchronization (the kernel manages each thread's mask directly)

Linux's `clone()` system call creates tasks with configurable sharing flags. With all flags set, it creates a new thread (shared address space). With no flags set, it behaves like `fork()` (new process).

### Adaptive Mutexes (Solaris)

On multiprocessor systems, if a thread tries to acquire a held mutex, it has two choices:

- **Block**: be placed on a wait queue, context switch out, and be woken later. Good if the critical section is long.
- **Spin**: busy-wait, checking the lock repeatedly. Good if the critical section is short and the lock holder is currently executing on another CPU.

Solaris uses **adaptive mutexes**: spin if the lock holder is running on another CPU (likely to release soon); block if the lock holder is not running (no point spinning).

(Paper, Eykholt et al.: adaptive is the default kernel mutex type, `MUTEX_DEFAULT`. The owner is recorded when the lock is acquired, and the waiter polls the owner's status while spinning, sleeping as soon as the owner stops running. On a uniprocessor this degenerates to always sleeping. It works because mutexes are by far the most heavily used primitive and are usually held for short intervals. Pure spin mutexes, `MUTEX_SPIN`, exist but are rarely used. Kernel mutexes and writer locks also implement **priority inheritance**.) (Lecture framing: information about critical-section length, short vs. long, is used together with owner status to choose spin or block; Paper, Eykholt et al.: the only runtime test is whether the owner is running, and short hold times are an assumption, not tracked state.)

### Thread Reuse (Death Row)

When threads exit, their data structures are not immediately freed. Instead, they are placed on **death row**. A **reaper** thread periodically garbage-collects them. (Lecture framing: if a new thread is requested before reaping, the existing structure is reused, saving allocation overhead; Paper, Stein & Shah: freed *stacks* are reused via a stack cache, below, not unreaped structures.)

(Paper, Stein & Shah: an exiting **detached** thread is put on the `deathrow` queue in the ZOMBIE state, deferring the expensive stack free out of the exit path. The high-priority reaper runs when LWPs are idle or when deathrow fills, frees the stacks, and places them on a **cache of thread stacks** that speeds up later thread creation. An exiting **undetached** thread goes on a zombie list and is reaped by whichever thread calls `thr_join()` on it.)

### Sizing the LWP Pool: `SIGWAITING` and `thr_setconcurrency`

(Paper, Stein & Shah: the library grows and shrinks the LWP pool automatically. It must never deadlock for lack of LWPs, yet should not hold one LWP per thread.)

- (Paper, Stein & Shah: the kernel sends **`SIGWAITING`** when all LWPs in the process are blocked in indefinite waits. Once there are more threads than LWPs, the library installs a handler, and on `SIGWAITING` it creates a new LWP if runnable threads exist.)
- (Paper, Stein & Shah: **`thr_setconcurrency(n)`** is an application hint: the library keeps at least n LWPs once there are at least n threads, or one per thread, if fewer. Growth beyond n comes only from `SIGWAITING`.)
- (Paper, Stein & Shah: LWPs idle for a "long" time, 5 minutes, are aged out and terminated.)

(Lecture framing: ideally the kernel notifies the library just before blocking, so the library can request more kernel threads, and the application asks for more via a `set_concurrency` system call to which the kernel responds by allocating another kernel thread; Paper, Stein & Shah: `SIGWAITING` arrives only after all LWPs are already blocked, and `thr_setconcurrency()` is a library hint, with the library creating the LWPs itself.)

(Paper, Stein & Shah: this is the answer to the lecture's "kernel and library have no insight into one another" problem.) Under Linux's 1:1 model, none of it is needed.

---

## Question 5: Multithreading Patterns, Boss/Workers and Pipeline

**Lectures**: P2L2 (Threads and Concurrency, videos 110-117), P2L5 (Thread Performance Considerations, video 188)

### Boss/Workers Pattern

- One **boss** thread accepts and dispatches work.
- Multiple **worker** threads consume tasks from a shared queue (producer/consumer pattern).
- Throughput is limited by the boss: `throughput = 1 / boss_time_per_task`.
- Workers execute the full task end-to-end.

**Convention**: if the problem says "n threads," that means 1 boss + (n-1) workers.

**Pros**: simplicity. One thread assigns work, the rest do it.

**Cons**:
- Thread pool management overhead.
- Lacks **locality**: the boss has no insight into what a worker was previously doing. A worker that just finished a similar task might be best suited for a new task, but the boss doesn't know.

**Variants**: specialized workers for different task types. Exploits locality (each worker touches a smaller subset of state, keeping cache hot) and enables quality-of-service differentiation. Downside: load balancing is harder.

### Pipeline Pattern

- The task is divided into **stages**; each stage is handled by one or more threads.
- Tasks flow through stages sequentially; multiple tasks can be in different stages simultaneously.
- Throughput is limited by the **slowest stage**: `throughput = 1 / longest_stage_time`.
- The slowest stage can be balanced by assigning more threads to it.

**Pros**: specialization and locality (each thread repeatedly performs the same small subtask, keeping cache hot).

**Cons**: difficult to keep the pipeline balanced as workload characteristics change.

### Worked Example: 11 Toy Orders, 6 Threads

Each toy order takes 120ms total to complete.

#### Boss/Workers Model

With 6 threads = 1 boss + 5 workers.

The boss dispatches orders. 5 workers can process 5 orders simultaneously. Each order takes 120ms.

- **Wave 1** (orders 1-5): start at t=0, finish at t=120ms.
- **Wave 2** (orders 6-10): start at t=120ms, finish at t=240ms.
- **Wave 3** (order 11): starts at t=240ms, finishes at t=360ms.

**Total time** = 360ms.

**Average time per order**:

Orders 1-5 each take 120ms (from dispatch to completion).
Orders 6-10 each wait 120ms then take 120ms = 240ms.
Order 11 waits 240ms then takes 120ms = 360ms.

```
Average = (5 * 120 + 5 * 240 + 1 * 360) / 11
        = (600 + 1200 + 360) / 11
        = 2160 / 11
        ~= 196.36ms
```

#### Pipeline Model

With 6 threads = 6 pipeline stages. Each toy order passes through 6 stages. If total processing is 120ms split evenly across 6 stages, each stage takes 20ms.

The first order enters stage 1 at t=0, finishes stage 6 at t=120ms. The second order enters stage 1 at t=20ms (after order 1 leaves stage 1), finishes at t=140ms. Each subsequent order starts 20ms after the previous one.

**Total time** = time for first order + (remaining orders * longest stage time)
= 120 + (10 * 20) = 120 + 200 = **320ms**.

**Average time per order**:

Each order takes 120ms of processing. Order k (1-indexed) completes at time 120 + (k-1) * 20.

```
Order  1: completes at 120ms
Order  2: completes at 140ms
Order  3: completes at 160ms
Order  4: completes at 180ms
Order  5: completes at 200ms
Order  6: completes at 220ms
Order  7: completes at 240ms
Order  8: completes at 260ms
Order  9: completes at 280ms
Order 10: completes at 300ms
Order 11: completes at 320ms

Sum = 120 + 140 + 160 + 180 + 200 + 220 + 240 + 260 + 280 + 300 + 320
    = 2420

Average = 2420 / 11 = 220.00ms
```

#### Comparison

| Metric | Boss/Workers | Pipeline |
|---|---|---|
| Total execution time | 360ms | 320ms |
| Average time per order | ~196.36ms | 220.00ms |

- If **total execution time** matters, the pipeline is better (320 < 360).
- If **average completion time per order** matters, boss/workers is better (~196 < 220).

Neither model is universally better. Performance depends on which metric you care about.

### Key Formulas

**Boss/Workers**:
- Throughput = 1 / boss_time_per_task
- Total time = ceil(num_tasks / num_workers) * time_per_task
- Average time: sum each order's wait+processing time, divide by number of orders

**Pipeline**:
- Throughput = 1 / longest_stage_time
- Total time for N orders = time_for_first_order + (N - 1) * longest_stage_time
- Average time: each order k completes at first_order_time + (k - 1) * longest_stage_time; average these

---

## Question 6: Flash Web Server and Experimental Results

**Lecture**: P2L5 (Thread Performance Considerations, videos 195-211)
**Paper**: Pai et al. (Flash: An Efficient and Portable Web Server)

### Web Server Architectures Compared

| Architecture | Description | Key Properties |
|---|---|---|
| **Multi-Process (MP)** | One process per request. Each process has its own address space. | Simple; no explicit synchronization. Large memory footprint; expensive context switches; less memory for caching. |
| **Multi-Threaded (MT)** | One thread per request within a single process (Lecture framing: boss/workers; Paper, Pai et al.: each thread handles a whole request before accepting the next, with no boss thread). | Shared address space; smaller footprint than MP; cheaper context switches. Requires explicit synchronization; depends on kernel thread support. |
| **SPED** | Single-Process Event-Driven. One thread, one process, event loop dispatches handlers. | Smallest footprint; no context switching or synchronization overhead. Blocks on disk I/O (no async I/O or helpers). |
| **AMPED (Flash)** | Asymmetric Multi-Process Event-Driven. Event-driven main process + helper processes for blocking I/O. | Combines event-driven efficiency with non-blocking I/O via helpers. Smaller footprint than MP/MT, since helpers are needed only per concurrent disk operation. |

### Flash (AMPED) Design

Flash uses a single event-driven process as the main dispatcher. When a request arrives:

1. The dispatcher accepts the connection, parses the request.
2. It checks with **`mincore`** whether the requested file's pages are resident in memory, and uses this to decide between a local handler and a helper. (The file is read into memory via **`mmap`** by the helper.)
3. If the file is in memory: a local handler serves it directly, no blocking.
4. If the file is not in memory: the request is passed to a **helper process** via a pipe. The helper performs the blocking disk read. When done, it notifies the dispatcher (the pipe is a file descriptor, so `select`/`poll` picks it up).

This design means the main event loop never blocks on disk I/O.

- (Paper, Pai et al.: the helper `mmap`s the same file and **touches every page**, then sends back only a completion notification, never file data. The main process then sends from its own mapping without risk of blocking, and no extra copy is made.)
- (Paper, Pai et al.: helpers also perform **pathname translation**, which can block on `stat`/`open`. They are spawned dynamically, kept in reserve when idle, and each handles one request at a time.)
- Helpers are separate processes rather than kernel threads for **portability** (Paper, Pai et al.: FreeBSD 2.2.6 had no kernel threads).
- (Paper, Pai et al.: AMPED needs only standard APIs: non-blocking `read`/`write`/`accept` on sockets and pipes, `select`, `mmap`, and `mincore`. This is the paper's case against SPED: on most UNIXes a "non-blocking" read on a disk file can still block, and true async disk I/O APIs are not integrated with `select`.)
- Only one helper is needed per concurrent disk operation, not per concurrent connection. That keeps the footprint far below MP/MT.

### Application-Level Caching

Flash performs aggressive caching at multiple levels:

- **Data caching**: frequently requested files are kept in memory.
- **Computation caching**:
  - **Pathname lookups**: mapping from URL pathname to file location is cached, avoiding repeated filesystem traversals.
  - **Response headers**: HTTP headers depend on the file (content type, size, modification date). As long as the file hasn't changed, cached headers can be reused.

These optimizations avoid redundant computation and disk access, reducing the load on the system.

(Paper, Pai et al.: there are three caches: **pathname translations**, **response headers**, and **file mappings**.)

- (Paper, Pai et al.: the pathname cache also cuts down how many translation helpers are needed, which recovers the memory the cache itself uses.)
- (Paper, Pai et al.: the header cache has no invalidation mechanism of its own. When the mapping cache detects that a file changed, the header is regenerated.)
- (Paper, Pai et al.: mapped files are cached in chunks. Inactive chunks sit on an LRU free list and are lazily unmapped. Every mapped page is checked with `mincore()` before use.)
- Alignment (Lecture framing: an optimization for the network hardware, alignment for DMA and DMA with scatter-gather, i.e. vector I/O; Paper, Pai et al.: it is **byte position alignment**: response headers are padded to 32-byte multiples so `writev()` does not cause misaligned copies in the kernel, keeping the copies aligned with 32-byte CPU cache lines.)

(Paper, Pai et al.: in SPED and AMPED a single cache serves all requests without synchronization. MT needs locking for its shared cache, and MP has to replicate caches per process.)

### Experimental Setup

**Systems compared**: Flash (AMPED), SPED, MT (multithreaded), MP (multiprocess), Apache (MP, lacking Flash's aggressive optimizations; Paper, Pai et al.: v1.3.1), Zeus (Lecture framing: SPED with two processes; Paper, Pai et al.: Zeus v1.30, run as one process for the synthetic tests and as two processes, as the vendor advised, for the real-workload tests).

SPED, MT, and MP are built from the **same Flash code base** (Paper, Pai et al.: as Flash-SPED, Flash-MT, and Flash-MP, with only the event/helper dispatch mechanism replaced). This isolates the effect of the concurrency architecture. (Paper, Pai et al.: Flash-MP and Apache ran 32 processes and Flash-MT 64 threads. Flash and Flash-MT had a 128 MB mapped-file cache and 6000 pathname entries; each Flash-MP process had only 4 MB and 200 entries, because MP replicates caches per process. All servers ran on a 333 MHz Pentium II with 128 MB RAM, under both Solaris 2.6 and FreeBSD 2.2.6.)

**Workloads**:

- **Synthetic (best case)**: all requests for the same file, varying file size. Represents optimal caching scenario.
- **Owlnet trace**: replayed log of a Rice University server hosting student-run websites (Paper, Pai et al.: personal pages for ~4,500 students and staff). Smaller dataset; mostly fits in memory (cache-friendly).
- **CS trace**: replayed log of Rice's Computer Science department web server. Larger dataset that does not fit in memory (disk-bound).
- **ECE trace, truncated** (Paper, Pai et al.: Rice ECE logs cut to dataset sizes of ~15-150 MB, to sweep from cached to disk-bound.)
- **WAN simulation** (Paper, Pai et al.: persistent connections on the ECE log at 90 MB, with up to 500 concurrent clients.)

**Metrics**: bandwidth (bytes transferred / time) and connection rate (connections / time), both as functions of file size. (Paper, Pai et al.: the trace experiments report bandwidth only.)

### Experimental Results

#### Best Case (Synthetic, Same File)

All requests hit the same file, so the file is always cached after the first request.

- **SPED** performs best, though only slightly: single process, no overhead, file always in cache. (Lecture framing: the summary slide writes it as "SPED >> AMPED Flash"; Paper, Pai et al.: Flash-SPED "slightly outperforms" Flash.)
- **Flash** is close but slightly lower: it performs the extra `mincore` check on every request (unnecessary here since the file is always in memory, but Flash doesn't know that a priori).
- **Zeus** (Paper, Pai et al.: single-process SPED in this test) performs similarly to Flash but exhibits an anomaly (Lecture framing: a dip around 125 KB on the Solaris graph the lecture shows, from a DMA misalignment; Paper, Pai et al.: it occurs on FreeBSD for file sizes between 10 and 100 KB and is attributed to the `writev` **byte alignment problem** that Flash avoids by padding headers).
- **MT** and **MP** perform slightly lower (Lecture framing: extra synchronization and context switching; Paper, Pai et al.: extra kernel overhead such as context switching, and MP needs no synchronization between requests because its processes have private address spaces). This happens even though caching is perfect.
- **Apache** is lowest, because it has no optimizations (Paper, Pai et al.: lowest across all file sizes on both OSes, attributed to Flash's, and presumably Zeus's, more aggressive optimizations, not to the architecture).

(Paper, Pai et al.: the headline here is that **architecture has little impact on a trivial cached workload**. All servers also ran substantially faster on FreeBSD than on Solaris, without changing their relative order much.)

**Why**: when data is fully cached, the simplest architecture (SPED) wins because there is zero blocking I/O. Any overhead from context switching, synchronization, or extra memory checks is pure waste.

#### Owlnet Trace (Small, Mostly Cached)

Most requests are served from cache, but occasionally a request requires disk access.

- **Flash** slightly outperforms **SPED**. SPED blocks when a file isn't in cache (no helpers, no async I/O). Flash's helpers handle the occasional blocking I/O without stalling the main loop.
- Both Flash and SPED outperform MT/MP for the same reasons as the best case.
- Apache remains lowest (Paper, Pai et al.: comparing it with Flash-MP shows this is mostly due to Apache's lack of optimizations, and only partly due to its MP architecture).

**Why**: a small trace mostly fits in memory, so the workload is cache-friendly. But "mostly" is not "entirely"; the occasional disk-bound request is where Flash's helper architecture pays off over SPED.

#### CS Trace (Large, Disk-Bound)

The working set far exceeds available memory. Most requests require disk I/O.

- **Flash** performs best. It has a smaller memory footprint than MP and MT, which leaves more memory for caching files. More cache means fewer disk accesses, which means better performance. Its helper processes handle blocking I/O without stalling the dispatcher.
- **SPED** drops precipitously. Without helpers or async I/O, SPED blocks on every disk request. It essentially serializes all disk-bound requests (Paper, Pai et al.: it can issue only one disk request at a time, so it cannot benefit from multiple disks or disk head scheduling).
- **MT** outperforms **MP** (Lecture framing: MT has a smaller memory footprint than MP, shared address space vs. separate address spaces, so more memory is available for caching, and its synchronization and context switching are cheaper; Paper, Pai et al.: MP still performs well on this disk-intensive trace).
- MP's large memory footprint (per-process address spaces consume memory that could be used for caching; Paper, Pai et al.: so do its replicated per-process caches) and expensive context switching keep it behind Flash.

**Why**: when the workload is disk-bound, memory footprint determines performance because more memory for caching = fewer disk accesses. Flash's AMPED model is far leaner than MP/MT and causes less context switching (Paper, Pai et al.: Flash needs only enough helpers to keep the disk busy rather than a process per connection, and the helpers use little application-level memory). SPED fails because it has no mechanism for non-blocking I/O.

#### Varying Dataset Size (ECE Trace) (Paper, Pai et al.)

All servers decline as the dataset grows, with a sharp drop once the working set exceeds the effective cache.

- Flash tracks Flash-SPED on cached workloads and meets or exceeds MP once disk-bound, which is the stated design goal of AMPED.
- SPED and Zeus deteriorate quickly as disk activity increases.
- Flash-MP falls well short on cached workloads because of its smaller per-process caches.
- Flash-MT matches Flash on Solaris, but only after careful minimization of lock contention. Without that work it resembled SPED on disk-bound loads. There are no MT results for FreeBSD 2.2.6, which lacked kernel threads.
- Zeus on FreeBSD drops only past ~100 MB. The paper attributes this to Zeus favoring small-document requests, which shrinks the effective working set. Running Zeus as two processes also gives it a slight edge over single-process Flash-SPED.
- Solaris results were up to 50% lower than FreeBSD.

#### WAN Conditions (Paper, Pai et al.)

Persistent connections simulate long-lived WAN clients. SPED, AMPED, and MT initially improve as concurrent clients increase, since each `select` reports more events and its cost is amortized. Past ~200 connections, SPED and AMPED flatten, MT declines gradually (per-thread switching and space overhead), and MP declines significantly (per-process overhead and replicated caches).

#### Impact of Optimizations (Connection Rate)

(Lecture framing: the graph shows four curves: no optimizations, pathname caching only, pathname plus mapped-file caching, and all three; Paper, Pai et al.: Flash was tested on the FreeBSD single-file workload with all eight combinations of its three caching optimizations, from no caching up to all three.) The three optimizations:

1. Pathname translation caching
2. Response header caching
3. Mapped file caching

In all cases, connection rate decreases with file size (more work per connection). But at every file size, adding optimizations increases the connection rate. The fully optimized Flash has the highest connection rate. (Paper, Pai et al.: **pathname translation caching provides the largest benefit**. Without any of the optimizations, small-file performance drops by about half. The effect is strongest on small files, because each optimization removes a per-request cost.)

**Why**: each layer of caching eliminates redundant work. Pathname caching avoids repeated filesystem lookups. Header caching avoids repeated header computation. File caching avoids redundant disk reads.

### Summary Table

| Workload | Winner | Why |
|---|---|---|
| Best case (cached) | SPED | Zero overhead; no blocking I/O occurs |
| Small trace (mostly cached) | Flash (SPED close behind) | Flash edges out SPED due to helpers handling occasional disk I/O |
| Large trace (disk-bound) | Flash | Smaller footprint than MP/MT means more cache, so fewer disk accesses; helpers prevent blocking |

The consistent theme: **memory footprint matters** because it determines how much memory is available for caching. When workloads exceed cache, disk I/O dominates, and the architecture with the most cache wins. Flash achieves this through its single-process event-driven design with lightweight helpers. (Paper, Pai et al.: on real workloads, Flash beats Zeus by up to 30% and Apache by up to 50%.)
