---
id: operating-systems-midterm-exam-review-questions
title: Midterm Exam Review Questions
course: operating-systems
lecture: midterm-exam-review-questions
---

# Midterm Exam Review Questions

## What are the key roles of an operating system?
The operating system has three main roles:

- hide hardware complexity
- manage underlying hardware resources
- provide isolation and protection

### Hide Hardware Complexity
An application developer should not need to have to worry about the how to directly interface with the CPU, memory, or I/O devices. The OS provides abstractions to these hardware components to separate the application developer from the intimate details of the hardware. For example, the operating system provides the *file* abstraction as a representation of logical components of information stored on disk.

### Manage Underlying Hardware Resources
Since the operating system is the interface between the user level applications the physical hardware, it makes sense that its duties include managing those hardware resources. The operating system allocates a certain amount of memory to an application, schedules it to run on the CPU, and controls access to various I/O devices, among other responsibilities.

These first two responsibilities can be summarized by the phrase **abstract and arbitrate**.

### Provide Isolation And Protection
With multiple applications running concurrently, the operating system must make sure that no one application interferes with the execution of another application. For example, the operating system ensures that memory allocated to one application is neither read from nor written to by another application.

## What Is The Distinction Between OS Abstractions, Mechanisms And Policies?
**Abstractions** are entities that represent other entities, often in a simplified manner. For example, all of the complexity of reading and manipulating physical storage is abstracted out into the **file**, an abstraction the operating system exposes to layers above. We can interact with the file interface, and let the operating system handle the complexities involved in the implementation. Apart from simplicity, another benefit of abstractions is their portability. Operating systems are free to swap out their implementations to suit different hardware resources, and as long as their API remains constant, programs will still run.

Example of abstractions include:

- process/thread (application abstractions)
- file, socket, memory page (hardware abstractions)

**Policies** are the rules around how a system is maintained and resources are utilized. For example, a common technique for swapping memory to disk is the **least recently used** (LRU) policy. This policy states that the memory that was least recently accessed will be swapped to disk. Policies help dictate the rules a system follows to manage and maintain a workable state. Note that policies can be different in different contexts or a different times in a system.

**Mechanisms** are the tools by which policies are implemented. For example, in order to enforce the LRU policy of memory management above, memory addresses/blocks may be moved to the front of a queue every time they are accessed. When it comes time to swap memory to disk, the memory at the back of the queue can be swapped. In this example, the queue is the mechanism by which the LRU policy is implemented.

## What does the principle of separation of mechanism and policy mean?
The idea behind separation of mechanism and policy is that how you enforce a policy shouldn't be coupled to the policy itself. Since a given policy is only valid in some contexts or during some states of execution, having a mechanism that only suits that policy is very brittle. Instead, we should try to make sure that our mechanism is able to support a variety of policies, as any one of these policies may be in effect at a given point in time.

That being said, certain policies may occur more frequently than others, so it may make sense to optimize our mechanisms a little bit in one direction or anything while still maintaining their flexibility.

## What does the principle optimize for the common case mean?
Optimizing for the common case means ensuring that the most frequent path of execution operates as performantly as possible. This is valuable for two reasons:

- it's simpler than trying to optimize across all possible cases
- it leads to the largest performance gains as you are optimizing the flow that by definition is executed the most often

A great example of this is discussed in the SunOS paper, when talking about using threads for signal handling instead of changing masks before entering/after exiting a mutex:

> The additional overhead in taking an interrupt  
is about 40 SPARC instructions. The savings in the
mutex enter/exit path is about 12 instructions. However,
mutex operations are much more frequent than
interrupts, so there is a net gain in time cost, as long
as interrupts don't block too frequently. The work
to convert an interrupt into a "real" thread is performed
only when there is lock contention.

## What happens during a user-kernel mode crossing?
Distinguishing between user and kernel mode is supported directly in the hardware. For instance, when operating in kernel mode, a special bit is set on the CPU, and if that bit is set, any instruction that directly manipulates the hardware is allowed. When in user mode, the bit will not be set, and any attempt to perform such privileged operations will be forbidden.

Such forbidden attempts will actually cause a trap. The executing application will be interrupted, and the hardware will switch control back to the operating system a specific location - the trap handler. At this point, the operating system will have a chance to determine what caused the trap and then decide if it should grant access or perhaps terminate the transgressive process.

This context switch takes CPU cycles to perform which is real overhead on the system. In addition, context switching will most likely invalidate the hardware cache (hot -> cold), meaning that memory accesses for the kernel context will initially come from main memory and not from cache, which is slow.

## What are some of the reasons why user-kernel mode crossing happens?
Basically, user/kernel mode crossing occurs any time any application needs access to underlying hardware, be it physical memory, storage, or I/O devices.

User/kernel cross may occur if an application wishes to

- read from a file
- write to a file
- listen on a socket
- allocate memory
- free memory

User/kernel crossings may occur in response to a hardware trap as mentioned above, or may occur through the process of the application invoking a system call, requesting that the operating system perform some service for them.

## What is a kernel trap? Why does it happen? What are the steps that take place during a kernel trap?
A kernel trap is a signal that the hardware sends to the operating system when the it detects that something has occurred.

A kernel trap will occur if the hardware detects an attempt to perform an unprivileged operation, which is basically any operation that occurs when the special bit is not set on the CPU. As well, the hardware may issue a trap if it detects an attempt to access memory that requires special privileges.

During a kernel trap, the hardware sends a signal to the operating system, which initiates controls and invokes its trap handler.  The operating system can then examine the process that caused the trap as well as the reason for the trap and make a decision as to whether it will allow the attempted operation or potentially kill the process.

## What is a system call? How does it happen? What are the steps that take place during a system call?
A system call is an operation that the operating system exposes that an application can directly invoke if it needs the operating system to perform a specific service and to perform certain privileged access on its behalf.

Examples of system calls include `open`, `send`, `mmap`.

When a user process makes a system call, the operating system needs to context switch from that process to the kernel, making sure it holds onto the arguments passed to that system call. Before the kernel can actually carry out the system call, the trap bit on the CPU must be adjusted to let the CPU know the execution mode is kernel mode. Once this occurs, the kernel must jump to the system call and execute it. After the execution, the kernel must reset the trap bit in the CPU, and context switch back to the user process, passing back the results.

## Contrast the design decisions and performance tradeoffs among monolithic, modular and microkernel-based OS designs.

### Monolithic

#### Pros
* Everything included
* Inlining, compile-time optimizations

#### Cons
* No customization
* Not too portable/manageable
* Large memory footprint (which can impact performance)

### Modular

#### Pros
* Maintainability
* Smaller footprint
* Less resource needs

#### Cons
* All the modularity/indirection can reduce some opportunities for optimization (but eh, not really)
* Maintenance can still be an issue as modules from different codebases can be slung together at runtime

### Microkernel

#### Pros
* Size
* Verifiability (great for embedded devices)

#### Cons
* Bad portability (often customized to underlying hardware)
* Harder to find common OS components due to specialized use case
* Expensive cost of frequent user/kernel crossing

## What are the differences between processes and threads? What happens on a process vs. thread context switch?
A process is defined by two main components: its virtual address mapping, and its execution context. The virtual address mapping contains the code of the program, any data that the program is initialized with, and the heap.  The execution context contains the stack and CPU registers associated with the process's execution.

Different processes will have different virtual address mappings and different execution contexts, all represented by the process control block. Different threads will exist within the same process, so they will share the virtual address mapping of the process. Only the execution context will be different. As a result, a multiprocess application will require a much larger memory footprint than a multithreaded application.

Greater memory needs mean that data will need to be swapped to disk more often, which implies that multithreaded applications will be more performant than multiprocess applications. In addition, process-process communication via IPC is often more resource intensive that thread-thread communication, which often just consists of reading/writing shared variables.

Since threads share more data than processes, less data needs to be swapped during a context switch. Because of this, thread context switching can be performed more quickly than process context switching. Process context switching involves the indirect cost of going from a hot cache to a cold cache. When a process is swapped out, most of the information the new process needs is in main memory and needs to be brought into the hardware cache. Since threads share more information - have more locality with one another - a new thread may still be able to benefit from the cache that was used by an older thread.

## Describe the states in a lifetime of a process?
When a process is created, it's in the **new** state. At this point, the operating system initializes the PCB for the process, and it moves to the **ready** state. In this state it is able to be executed, but it is not being executed. Once the process is scheduled and moved on to the CPU it is in the **running** state. If the process is then interrupted by the scheduler, it moves back the the ready state. If the process is running, and then makes an I/O request, it will move onto the wait queue for that I/O device and be in the **waiting** state. After the request is serviced, the process will move back to the ready state. If a running process exits, it moves to the **terminated** state.

##  Describe the lifetime of a thread?
A thread can be created  (a new execution context can be created and initialized). To create a thread, we need to specify what procedure it will run, and what arguments to pass to that procedure. Once the thread has been created, it will be a separate entity from the thread that created it, and we will say at this point that the process overall is multithreaded.

During the lifetime of a thread, the thread may be executing on the CPU - similar to how processes may be executing on the CPU at any point in time - or it may be waiting.

Threads may wait for several different reasons. They may be waiting to be scheduled on the CPU (just like processes). They may be waiting to acquire some synchronization construct - like a mutex - or they may be waiting on some condition to become true or some signal to be received - like a condition variable. Different queues may be maintained depending on the context of the waiting.

Finally, at the end of their life, threads can be joined back in to their parents. Through this join, threads can convey the result of the work they have done back to their parents. Alternatively, detachable threads cannot be joined back into their parent, so this step does not apply to them.

Threads can also be zombies! A zombie thread is a thread that has completed its work, but whose data has not yet been reclaimed. A zombie thread is doing nothing but taking up space. Zombies live on death row. Every once in a while, a special reaper thread comes and cleans up these zombie threads. If a new thread is requested before a zombie thread is reaped, the allocated data structures for the zombie will be reused for the new thread.

## Describe all the steps which take place for a process to transition form a waiting (blocked) state to a running (executing on the CPU) state.
When a process is in a blocked state, this means that process is currently waiting for an I/O request to be fulfilled. Usually this means that the process is sitting on an I/O queue within the kernel that is associated with the device it's making the request to. Once the request is fulfilled, the process moves back to a ready state, where it can be executed, although it is not yet scheduled. The currently executing process must be preempted, and the ready process must be switched in. At this point, the process is executing on the CPU.

### What are the pros-and-cons of message-based vs. shared-memory-based IPC?

### Message Passing IPC
The benefits of message passing IPC is that the operating system will manage the message passing channel, and already has system calls in place for operations like `read/write` and `recv/send`. The user doesn't need to worry about any of the details.

The downside of messaged-based IPC is the overhead. Every piece of data that is sent between processes must first be copied from the sending process's address space into memory associated with the kernel and then into the receiving process's address space. There is user/kernel crossing for every message.

### Shared-Memory IPC
The benefit of this approach is that the kernel is completely uninvolved. The processes can read from and write to this memory as they would with any other memory in their address space. Unfortunately, without the kernel, a lot of the APIs that were taken for granted with message passing IPC may have to be re-implemented. For example, the user now has to manage all of the synchronization themselves.

## What are benefits of multithreading? When is it useful to add more threads, when does adding threads lead to pure overhead? What are the possible sources of overhead associated with multithreading?
There are two main benefits of multithreading, namely parallelization and concurrency.

Parallelization comes into effect on multi CPU systems in which separate threads can be executing at the same time on different processors. Parallelizing work allows for the work to be accomplished more quickly.  

Concurrency refers to the idea that the CPU can do a little bit of work on one thread, and then switch and do a little bit of work on another thread. Succinctly, concurrency refers to the idea that the execution of tasks can be interwoven with one another.

The primary benefit of concurrency without parallelization - that is, concurrency on single CPU platforms - is the hiding of I/O latency. When a thread is waiting in an I/O queue, that thread is blocked: it's execution cannot proceed. In a multithreaded environment, a thread scheduler can detect a blocked thread, and switch in a thread that can accomplish some work. This way, it looks as if progress is always being made (CPU utilization is high) even though one or more threads may be waiting idle for I/O to complete at any given time.

Adding threads make sense if you have fewer threads than you have cores or if you are performing many I/O requests. Adding threads can lead to pure overhead otherwise.

While new threads require less memory than new processes, they still do require memory. This means that threads cannot be made for free, and in fact thread creation is often quite expensive. In addition, thread synchronization can add more overhead to the system, in terms of the CPU cycles and memory that must be consumed to represent and operate synchronously.

## Describe the boss-workers multithreading pattern. If you need to improve a performance metric like throughput or response time, what could you do in a boss-worker model? What are the limiting factors in improving performance with this pattern?
In the boss-workers problem, you have one boss thread and n worker threads. For each task that enters the system, the boss dispatches the tasks that the workers consume.

This is often, though not necessarily, done through a shared request queue/buffer. In this case, the boss will add items to the queue, and the workers will consume items from the queue.

If you wanted to improve throughput or response time in this model, there are mainly two things you could do. First, increase the number of threads. The more you leverage concurrency, the more potential you have to increase the efficiency of your processing. That being said, dynamic thread creation is expensive, so it makes sense to just have a pool of workers up front instead of creating new threads on the fly. Increasing the size of the pool may help performance.

Second, decrease the amount of work the boss has to do. Since the boss has to do some processing on every request, the throughput of the system is correlated to this processing time. Make sure to make this is low as possible.

This approach is still limited by the amount of processing power you have. After a certain number of threads, the work will become CPU-bound. Some threads will end up just having to wait their turn for computing resources.

In addition, this approach lacks locality. The boss doesn't keep track of what any of the workers were doing last. It is possible that a thread is just finishing a task that is very similar to an incoming task, and therefore may be best suited to complete that task. The boss has no insight into this fact.

## Describe the pipelined multithreading pattern. If you need to improve a performance metric like throughput or response time, what could you do in a pipelined model? What are the limiting factors in improving performance with this pattern?
In the pipeline pattern, the execution of the task is broken down into stages. Threads are assigned to continually complete the work at once stage, receiving requests from the stage before it and passing work on to the stage after it.

One of the benefits of this process is locality. Since each thread performs the same (small) task over and over again, it is more likely that the hardware cache will be hot, increasing performance.

On a larger level, this pattern will be bottle necked by the stage that takes the longest to complete. One way to overcome the difference in processing needed for each stage is to allocate a different number of threads to each stage. For example, a stage that takes three times as long as another stage should have three times the amount of threads.

A downside of this approach is that it is difficult to keep the pipeline balanced over time. When the input rate changes, or the resources at a given stage are exhausted, rebalancing may be required.

## What are mutexes?
Mutexes are synchronization constructs that enforce the principle of mutual exclusion.  Mutual exclusion is the requirement that one thread of execution never enter its critical section at the same time that another concurrent thread of execution enters its own critical section.

## What are condition variables?
Condition variables are constructs used in conjunction with mutexes to control concurrent execution. While mutexes and mutual exclusion represent binary states - either the thread can access a shared resource or it cannot - condition variables allow for more complex states. Threads can wait on condition variables until a condition is met, and threads can signal/broadcast on condition variables when a condition is met.

## Can you quickly write the steps/code for entering/existing a critical section for problems such as reader/writer, reader/writer with selective priority (e.g., reader priority vs. writer priority)?
### Reader

```c
mutex_lock(&m);

while(status == -1)
	wait(&cond_reader, &m);

status++;

mutex_unlock(&m);

// work
// work
// work, work, work

mutex_lock(&m);

if(--status == 0)
	signal(&cond_writer);

mutex_unlock(&m);
```

### Writer

```c
mutex_lock(&m);

while(status != 0)
	wait(&cond_writer, &m);

status = -1;
mutex_unlock(&m);

// work
// work
// work, work, work

mutex_lock(&m);
status = 0;
mutex_unlock(&m);

signal(&cond_writer);
broadcast(&cond_reader);
```

## What are spurious wake-ups, how do you avoid them, and can you always avoid them?
Spurious wake ups occur when a thread is woken up when the application is in a state during which it's impossible for that thread to make progress. This often occurs when one thread tries to signal/broadcast while holding a mutex. Threads associated with condition variable being signaled on will be woken up from the wait queue associated with the condition variable, but since the signaling thread holds the mutex, they will immediately be placed on the wait queue associated with acquiring the mutex. CPU cycles will be wasted.

Spurious wake ups can often be avoided by placing signal/broadcast calls outside of the mutex. Note that, this cannot always happen: if a signaling call depends on some configuration of shared state, this must be checked while holding the mutex, as with any other shared state access.

## Do you understand the need for using a while() look for the predicate check in the critical section entry code examples in the lessons?
When a condition variable is signaled on, and a thread is to be "woken up", two things occur:

- The thread is removed from the wait queue
- The thread reacquires the mutex

The two steps are logically independent. What this means is that another thread may be given CPU time (and potentially the mutex) in between these two steps. As a result, the shared state may be updated before the waking up thread reacquires the mutex. Therefore, the thread must do another check when it actually acquires the mutex to ensure the condition it needs to proceed is still true.

##  What's a simple way to prevent deadlocks? Why?
Simplest way to prevent deadlocks is to maintain a lock order. This will prevent a cycle in the wait graph, which is necessary and sufficient for a deadlock to occur. Two threads can deadlock if they are each trying to acquire mutexes the other holds.  A thread can also deadlock with itself if it tries to acquire a mutex it already holds. Enforcing a lock order can ensure that neither of these scenarios occurs.

## Can you explain the relationship among kernel vs. user-level threads? Think though a general mxn scenario (as described in the Solaris papers), and in the current Linux model. What happens during scheduling, synchronization and signaling in these cases?
User level threads are associated with a user level library (like pthreads), while kernel level threads are associated with the kernel threading implementation (like NPTL). For a user thread to run, it must be associated with a kernel thread, which in turn must be scheduled on the CPU.

In the one-to-one model, there is one kernel thread for every user thread. That means that when a user thread is created, a kernel thread is also created. This 1:1 model is the current situation in Linux and is supported at the kernel level by the `task` struct. The benefit of the approach is that the kernel understands that the process is multithreaded, and it also understands what those threads need. Since the operating system already supports threading mechanisms to manage its thread, the user libraries can benefit directly from the multithreading support available in the kernel.

One downside of this approach is that is it expensive: for every operation we must go to the kernel and pay the cost of a system call. Another downside is that since we are relying on the mechanisms and policies supported by the kernel, we are limited to only those policies and mechanisms. As well, execution of our applications on different operating systems may give different results.

In a so-called many-to-many scenario, there can be one or more user threads scheduled on one or more kernel threads. The kernel is aware that the process is multithreaded since it has assigned multiple kernel level threads to the process. This means that if one kernel level thread blocks on an operation, we can context switch to another, and the process as a whole can proceed. One of the downsides of this model is that is requires extra coordination between the user- and kernel-level thread managers.

Signaling in a many to many scenario comes with complexities. If the kernel thread has a signal enabled but the user thread does not, the user threading library may have to send directed signals back down into the kernel to get the right user level thread to respond to the signal.

## Can you explain why some of the mechanisms described in the Solaris papers (for configuring the degree concurrency, for signaling, the use of LWP…) are not used or necessary in the current threads model in Linux?
The mechanisms described in the Solaris paper were all mechanisms for rationing the number of threads that are created at any given point in time. Configuring the degree of concurrency implied that you couldn't just be automatically given as much as you needed. Having LWPs multiplex over kernel threads indicated that kernel threads needed to be shared. The rationing was based on real concerns about the available memory in a system at any given time.

The native implementation of threads in Linux is the Native POSIX Threads Library (NPTL). This is a 1:1 model, meaning that there is a kernel level task for each user level  thread. In NPTL, the kernel sees every user level thread. This is acceptable because kernel trapping has become much cheaper, so user/kernel crossings are much more affordable. Also, modern platforms have more memory - removing the constraints to keep the number of kernel threads as small as possible.

## What's an interrupt? What's a signal? What happens during interrupt or signal handling? How does the OS know what to execute in response to a interrupt or signal? Can each process configure their own signal handler? Can each thread have their own signal handler?
### Interrupts
Interrupts are signals that the hardware sends to the CPU that signal that something has occurred. For example, when a user-level application tries to perform a illegal task using the hardware, the kernel is notified via an interrupt. An interrupt is handled on a per-CPU basis, and the operating system maintains an interrupt table, which maps interrupts by number to handling procedures. When the interrupt occurs, the kernel jumps to the associated interrupt handler and executes that code.

Which interrupts occur is a function of the platform on which you are running. How those interrupts are handled is a function of the OS on top of the physical system.

### Signals
Signals are notifications that are delivered from the kernel to a user process. For example, if a process tries to access memory it has not allocated, the operating system may throw a SIGSEGV (segmentation fault).  Signals are operating system specific.  

Each process maintains its own signal handling table, which is very similar to kernel-level interrupt handling table. Each entry contains a reference to the signal and a reference to the handling code. When a signal comes in, the process jumps to the handling code. Threads cannot have their own handler, although they can set their own signal masks to ensure that they can disable signals they don't want to receive.

## What's the potential issue if a interrupt or signal handler needs to lock a mutex? What's the workaround described in the Solaris papers?
Since handlers are executed within a thread's stack, there is the potential for a thread to deadlock with itself if it tries to lock a mutex it has already acquired. This is because the current stack frame needs the mutex that was acquired in a lower stack frame to be released.

The solution is to have signal handlers execute in another thread. This way, the signal handling code can contend for a mutex like any other thread, which removes the possibility of deadlock.

Another solution is to have threads alter their signal masks before entering and after exiting their critical sections. While this solution requires fewer SPARC instructions than creating a new thread to handle signals, mutex acquisition happens much more frequently than signals. This is another example of optimizing for the common case!

## Contrast the pros-and-cons of a multithreaded (MT) and multiprocess (MP) implementation of a webserver, as described in the Flash paper.
### Multiprocess

The main benefits of the MP model are its simplicity. Each request is handled in a new process with it's own address space: there is no need for any (explicit) synchronization code. However, this benefit comes at the cost of performance. First, the memory foot print of the MP implementation is large. Processes have discrete address spaces, which means that memory usage grows steeply with request count. As a result, there is less memory available for caching, which means that computation becomes disk-bound more quickly. As well, context switching slows down the performance of the MP implementation. Context switching between processes consumes CPU cycles, which could otherwise be spent handling requests.

### Multithreaded

The main benefits of the MT model, compared to the MP model are that it is more efficient. MT applications share the address space of the process they are contained in, so they are more memory efficient than MP applications. As well, this sharing allows for smaller context switches (and often leaves hotter hardware caches), which can help performance. Unfortunately, this benefit comes at the cost of complexity. MT applications require explicit synchronization code to be written (mutexes, condition variables, etc). In addition, MT applications require kernel MT support, which wasn't a sure bet at the time of this paper.

## What are the benefits of the event-based model described in the Flash paper over MT and MP? What are the limitations? Would you convert the AMPED model into a AMTED (async multi-threaded event-driven)? How do you think an AMTED version of Flash would compare to the AMPED version of Flash?
The event-based model operated primarily in one thread, which makes its memory footprint smaller than both the MT and MP model. As well, the cost of context switching was not (as) present. That being said, helper processes were involved, but their utilization was as needed: they weren't created blindly for every new request entering the system. The benefit of the smaller memory footprint was that more memory was available for the various types of caching done in the system. This meant that Flash could delay becoming disk-bound longer than the MT/MP models.

Limitations of the main approach behind Flash was that not every kernel supported asynchronous I/O. As a result, Flash had to fake it in a sense, utilizing helper processes to make I/O look async.

I think that the AMTED model would perform better than the AMPED model, as the MT model uses less memory than the MP model, which again allows for a bigger cache. I think the main reason for choosing process-based helpers was that kernel support for multithreading was spotty at the time of the writing of the paper; thus, a process based approach was the most portable. That being said,  I think the performance differential would be on par with that between the standard MP/MT models, which is to say, not that much.

##  There are several sets of experimental results from the Flash paper discussed in the lesson. Do you understand the purpose of each set of experiments (what was the question they wanted to answer)? Do you understand why the experiment was structured in a particular why (why they chose the variables to be varied, the workload parameters, the measured metric…).

### Single File Test
This test was a test of "best case": to show what performance would look like across the servers when the request pattern was optimal. To achieve this, requests were made for a single file which varied in size. SPED performed better than AMPED - which performs the extra check to see if the file is in memory (not an issue here because its one file and is always going to be in memory). Both performed better than MT/MP, which were slowed by context switching overhead.

### Owlnet Trace
This tests workloads that can primarily be served from cache, but not completely. AMPED performs slightly better than SPED here. Since some of the work is disk-bound SPED blocks where AMPED context switches. Both of these approaches are better than MT/MP models, which have more memory allocated to them (less for cache size), and still incur the overhead of context switching.

### CS Trace
This tests workloads that become disk-bound very quickly. In this case, AMPED, and MT/MP smoke SPED. Since SPED is single-threaded, with no helpers, SPED blocks a lot when the workload is disk-bound. AMPED only has enough helper processes to keep the disk busy, so it has a smaller memory footprint and few context switching overheads than MP/MT.

### Optimizations
Looking at connection rate as a result of file size across the various combination of optimizations - pathname lookup caching, response header caching, and mapped file caching - shows that the combination containing all optimizations can handle the highest connection rate.

### Performance Under WAN
MT/AMPED/SPED all caused stable performance improvements when more clients were added. The per-process overhead of the MP model caused performance to degrade in this model.

## If you ran your server from the class project for two different traces: (i) many requests for a single file, and (ii) many random requests across a very large pool of very large files, what do you think would happen as you add more threads to your server? Can you sketch a hypothetical graph?

### Single file
Adding more threads would likely increase the throughput of the GETFILE server. Files need to be read from disk into memory before they can be served. Once a file is read into memory, it can stay in memory until its contents need to be replaced. More threads would be able to serve more concurrent requests.

### Random requests across a large pool of large files
Adding more threads may not have a huge impact on throughput in this scenario. Any given new request is not likely to be able to read from main memory, since the range of inputs is so wide. This means that this application would likely be disk-bound from the get-go. Increasing the number of threads allows for more concurrent requests to be processed, but each thread will likely have to pull content from disk.

I would say that the graph for throughput vs threads in both cases would be logarithmically increasing, with the graph for the single file example rising much more sharply than the graph for the large pool.
