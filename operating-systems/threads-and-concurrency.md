---
id: operating-systems-threads-and-concurrency
title: Threads And Concurrency
course: operating-systems
lecture: threads-and-concurrency
---

# Threads And Concurrency

**Reference paper**: [An Introduction to Programming with Threads](https://s3.amazonaws.com/content.udacity-data.com/courses/ud923/references/ud923-birrell-paper.pdf) - Andrew Birrell.

**OSTEP chapter**: [26. Concurrency: An Introduction](https://pages.cs.wisc.edu/~remzi/OSTEP/threads-intro.pdf)

## Visual Metaphor
A thread is like a worker in a toy shop. A worker has three relevant qualities:
* it is an active entity: it executes a unit of work needed for a toy order, and many workers can contribute to one order
* it works simultaneously with others: many workers on the shop floor build toys at the same time, on the same order or on different ones
* it requires coordination: workers share tools, workstations and parts, so they must coordinate to operate efficiently

Threads map onto this directly. A thread is an active entity that executes a unit of work on behalf of a process. Threads work simultaneously with others, which is where the term *concurrency* applies; on a machine with multiple processors or cores, multiple threads can execute at exactly the same time. Threads also require coordination, mainly of access to the underlying platform resources: I/O devices, CPU cores, memory and other system resources must be carefully controlled and scheduled by the operating system. How to decide which thread gets access to these resources is an important design decision for operating systems and for software developers in general.

## Process vs. Thread
A single-threaded process is represented by two components:
* address space (virtual <-> physical memory mapping)
	* code
	* data
	* heap
* execution context
	* CPU registers, including the program counter and stack pointer
	* stack

All of this information is represented by the operating system in a process control block.

Threads represent multiple independent execution contexts within the **same** address space, which means they share the virtual to physical address mapping, as well as the code/data/files that make up the application.

However, they will potentially be running different instructions and accessing different portions of the address space at any given time. This means that each thread will have to have its own program counter, stack pointer, registers and stack.

Each and every thread has its own data structure to represent information specific to its execution context.

A multithreaded process will have a more complex process control block structure, as these thread specific execution contexts need to be incorporated.

![](https://assets.omscs.io/notes/984D3189-6CAC-4EDA-8C68-D0315AD3BED6.png)

## Benefits of Multithreading
At any given time when running a multithreaded process on a multiprocessor machine, there may be multiple threads belonging to that process, each running on a given processor. While each thread is executing the *same code* (in the sense of same source code), each thread may be executing a *different instruction* (in the sense of different line or function) at any given time.

As a result, different threads can work in parallel on different components of the program's workload. For example, each thread may be processing a different component of the program's input. By spreading the work from one thread/one processor to multiple threads that can execute in parallel on multiple processors, we have been able to speed up the program's execution.

Threads may also execute completely different portions of the program. We can dedicate threads to I/O work such as input processing or display rendering, or split threads across specific functions in the code.

Another benefit that we can achieve through multithreading is specialization. If we designate certain threads to accomplish only certain tasks or certain types of tasks, we can take a specialized approach with how we choose to manage those threads. For instance, we can give higher priority to tasks that handle more important tasks or service higher paying customers.

Performance of a thread depends on how much information can be stored in the processor cache (remember - cache lookups are super fast). By having threads that are more specialized - that work on small subtasks within the main application - we can potentially have each thread keep more of its state within the processor cache (*hot cache*), further enhancing the speed at which the thread continuously performs it task.

### So why not just write a multiprocess application?
A multiprocess application requires a new address space for each process, while a multithreaded application requires only one address space. Thus, the memory requirements for a multiprocess application are greater than those of a multithreaded application. For example, with four CPUs, four processes need four address space allocations and four execution context allocations, while four threads share one address space and need only the four execution contexts.

As a result, a multithreaded application is more likely to fit in memory, and not require as many swaps from disk, which is another performance improvement.

Also, passing data between processes - inter-process communication (IPC) - is more costly than inter-thread communication, which consists primarily of reading/writing shared variables.

## Benefits of Multithreading: Single CPU
Generally, are threads useful when the number of threads exceeds the number of CPUs?

Consider the situation where a single thread makes a disk request. The disk needs some amount of time to respond to the request (call it `t_idle`), during which the thread cannot do anything useful. If `t_idle` is greater than twice the time it takes to context switch (`t_idle > 2 * t_ctx_switch`), then it makes sense to switch over to a new thread and back, hiding the latency of the I/O operation.

Now, this is true for both processes and threads. One of the most time consuming parts of context switching for processes is setting up the virtual to physical mappings. Thankfully, when we are context switching with threads, we are using the same mappings because we are within the same process. This brings down the total time to context switch, which brings up the number of opportunities in which switching threads can be useful.

As a result, multithreading lets us hide more of the latency associated with I/O operations, and this is useful even on a single CPU.

![](https://assets.omscs.io/notes/4B5064D0-7B6A-4EEC-9503-895184EA5707.png)

## Benefits of Multithreading: Apps and OS Code
By multithreading the operating system kernel, we allow the operating system to support multiple execution contexts, which is particularly useful when we do have multiple CPUs, which allows the execution contexts to operate concurrently. The OS threads may run on behalf of different application or OS-level services like daemons and device drivers.

![](https://assets.omscs.io/notes/96B2D50D-5518-486F-AFA3-9FC1CAFB5566.png)

<details>
<summary>Process vs. thread quiz spoiler</summary>

Do the following statements apply to processes, threads, or both?

* *Can share a virtual address space*: threads. Each thread of a process shares the virtual address space with the other threads in that process.
* *Take longer to context switch*: processes. Because threads share an address space, context switching among them is faster.
* *Have an execution context*: both. Threads and processes each have an execution context, described with a stack and registers.
* *Usually result in hotter caches when multiple such entities exist*: threads. Because threads share the virtual address space, the data one thread needs is often already in the cache, brought there by another thread. Among processes, such sharing is not really possible.
* *Make use of some communication mechanisms*: both. The operating system supports inter-process communication mechanisms for processes, and threads have mechanisms to communicate, coordinate and synchronize amongst each other.
</details>

## Basic Thread Mechanisms
To support threads we need a data structure to represent them, mechanisms to create and manage them, and mechanisms that let them coordinate amongst each other.

When processes run concurrently, they operate within their own address space. The operating system ensures that physical access from one address space never touch memory mapped to by another process's address space.

Threads share the same virtual to physical address mappings, since they share the same address space. Naturally, this can introduce some problems. For example, one thread can try to read the data while another modifies it, which can lead to inconsistencies. This is an example of a **data race** problem.

To avoid such problems, we need a mechanism that allows threads to operate on data in an exclusive manner. We call this **mutual exclusion**. This is a mechanism by which only one thread at a time is granted access to some data. The remaining threads must wait their turn. We accomplish mutual exclusion through the use of a **mutex**.

Also, it is useful to have a mechanism by which a thread can wait on another thread, and to be able to exactly specify what condition the thread is waiting on. For this inter-thread communication, we may use a construct called a **condition variable**.

Both *mutexes* and *condition variables* are examples of **synchronization mechanisms**. Birrell also describes mechanisms for waking up other threads from a wait state, but this lesson focuses on thread creation and these two synchronization mechanisms.

## Thread Creation
We need some data structure to represent a thread. The information we need to describe a thread may include:
* Thread ID
* Program counter
* Stack pointer
* Register values
* Stack
* Other attributes (priority attributes, etc.)

To create a thread, think of a `fork` (not the UNIX fork) call which takes two arguments - the `proc` to run when the thread is created, and the `args` to pass to `proc`.

When one thread calls `fork` a new thread is created, with a new data structure, its program counter pointing to the first instruction of `proc`, and `args` available on its stack.

After the fork completes, the process now has two threads both of which can execute concurrently. The parent `T0` continues with the operation after the `fork` call, and the child `T1` starts executing at the first instruction of `proc`, with the specified arguments.

When the forked thread completes, we need some mechanism by which it can return its result or communicate its status to the forking thread. On the other hand, we need to ensure that a forking thread does not exit before its forked thread completes work (as child threads exit when parent threads do).

One programming practice is to store the result of the computation in a well-defined location in the address space that is accessible to all of the threads, together with some mechanism to notify the parent, or some other thread, that the result is now available.

One mechanism that can handle this is the `join` mechanism. When the parent thread calls `join` with the thread id of the child it will be blocked until the child thread is finished processing. `join` returns the result of the child's computation. When `join` returns, the child thread exits the system and all resources associated with it are deallocated.

> **Paper (Birrell):** Join is rarely called at SRC and some thread facilities omit it; most forked threads are daemons or report results by other means. The paper does not say what happens to children when the parent exits.

Other than the parent being the one that joins the child, the parent and the child thread are completely equivalent. They can access and share all of the resources available to the process as a whole: the CPU, the memory, and any state within the process.

## Thread Creation Example
![](https://assets.omscs.io/notes/F3C7BFC2-F512-478D-A6BC-ECF6CDA6EEB5.png)

**NB**: Because we do not know which thread will run at which time in this example, we cannot be certain of the ordering of the elements in the list. Nothing guarantees that control switches to the child as soon as `fork` returns, so perhaps the child thread inserts its element before the parent thread, or perhaps the parent thread inserts first. Both executions are possible. If `safe_insert` were not actually protected, the two concurrent updates to the shared list would also be a *data race*; the next section shows why.

If the child has already finished, the `join` in this example returns immediately. The child's result reaches the parent through the shared list either way, so the join isn't strictly necessary here. It matters when we need the child's return value, or need to guarantee the child has finished.

## Mutexes
![](https://assets.omscs.io/notes/E4DBE552-3589-4160-88E0-257EC1B5D20A.png)

Each element of the list has a value and a pointer, `p_next`, to the next element. The head of the list is reached by reading the shared variable `list`, and insertion happens at the head.

Many steps are required to add an element to the list: create the element `e` and set its value, read `list` and its `p_next` pointer, set the new element's pointer (`e.pointer` on the slide, i.e. the element's own `p_next`) to `list.p_next`, then set `list.p_next` to `e`. Think about two threads, A and B, trying to insert elements into the list, initially empty. Here is a problematic scenario that can occur.

1. Thread A reads `list` and `list.p_next` (null)
2. Thread B reads `list` and `list.p_next` (null)
3. Thread A sets `e.pointer` to `list.p_next` (null)
4. Thread B sets `e.pointer` to `list.p_next` (null)
5. Thread A sets `list.p_next` to its `e`
6. Thread B sets `list.p_next` to its `e`

Both threads read the same initial value, so both new elements point to null, and the threads then take turns pointing the list at their own element. B's write in step 6 overwrites the pointer A just set in step 5. Only B's element ends up linked to the list; A's element is simply lost.

Generally, when reading and writing to shared variables (in multiple steps, as is often the case), the opportunities for this type of data overwriting increase.

That scenario is two threads sharing one CPU, where their operations end up randomly interleaved. There is a second way this goes wrong: two threads running on two different CPUs may try to update the pointer field of the first element at the same time, and we have no idea what the outcome of that will be.

## Mutual Exclusion
To support mutual exclusion, operating systems support a construct called a **mutex**. A mutex is like a lock that should be used whenever you access data/state that is *shared* among threads. When a thread locks a mutex (also called *acquiring* the lock or the mutex), it has exclusive access to the shared resource. Other threads attempting to lock the same mutex will not be successful. These threads will be **blocked** on the lock operation, meaning they will not be able to proceed until the mutex owner releases the mutex.

As a data structure, the mutex should have at least the following information:
* lock status
* owner
* blocked threads

**NB**: The list of blocked threads is not guaranteed to be ordered. When the mutex is freed, any one of the threads waiting on it may acquire it, and so may a brand new thread that has only just reached the lock statement. A thread that has been waiting longer gets no priority. If `T3` reaches its lock statement exactly as `T1` releases the lock, `T3` may be the first to acquire it, even though `T2` was already waiting.

The portion of the code protected by the mutex is called the **critical section**. The critical section should contain any code that would necessitate restricting access to one thread at a time: commonly, providing read/write access to a shared variable.

Threads are mutually exclusive with respect to their execution of the critical section of the code. That is, the critical section will ever only be executed by one thread at a given moment in time.

![](https://assets.omscs.io/notes/05F6A738-DE5B-419A-8BCC-79914DA1B6BD.png)

The mutex can be unlocked in two ways, depending on the implementation:
* the end of a clause following a lock statement is reached
* an unlock function is explicitly called

Birrell's lock construct, used throughout this lecture, frees the mutex implicitly at the closing curly bracket of the locked block. Most common APIs instead have two separate calls, lock and unlock, and both must be used explicitly and carefully: we must lock the mutex before entering the critical section and unlock it when we finish, otherwise no other thread will be able to proceed.

![](https://assets.omscs.io/notes/717286AD-8502-4612-A324-6C832EE627FA.png)

## Mutex Example
![](https://assets.omscs.io/notes/596C65A0-DC4B-4E6C-8451-8BA0F2BF0544.png)

This is the earlier `safe_insert` example, now protected by a mutex. Parent `T0` inserts 6, child `T1` inserts 4.

Say `T0` creates `T1`, keeps executing, and reaches `safe_insert` first. It acquires the lock and inserts 6. When `T1` reaches `safe_insert` it tries to acquire the same lock, fails, and blocks. Once `T0` releases, `T1` acquires the lock and inserts 4 at the front. The list ends up as `4 -> 6`.

The ordering of the two inserts is still not determined by the code; the mutex only guarantees they don't interleave.

<details>
<summary>Mutex quiz spoiler</summary>

Five threads, `T1` through `T5`, contend for a mutex `m` protecting a shared resource. `T1` gets the mutex first. `T2` and `T4` issue `lock(m)` while `T1` still holds it (`T4` before `T2`), `T3` issues its lock only after `T1` has released `m`, and `T5` issues its lock just as `T1` releases it. Which threads could get the mutex after `T1` releases it?

`T2`, `T4` and `T5`. `T2` and `T4` are both in the queue of pending requests, and the mutex makes no guarantee about the order in which pending requests are granted, so it does not matter that `T4` asked first. `T3` is not a candidate, because it asks only after the release, when other requests are already pending. `T5` is the tricky one: `T1` releases the lock, and just before it is given to `T2` or `T4`, `T5` arrives on another CPU and requests it. The lock is still free at that moment, so `T5` can be the one that gets it.
</details>

## Producer and Consumer Example
Mutual exclusion is a binary operation: either the lock is free and the resource can be accessed, or the lock is not free and the resource cannot be accessed.

What if the processing you wish to perform needs to occur with mutual exclusion, but only under *certain conditions*?

For example, what if we have a number of producer threads adding values to a list, and one consumer thread that needs to wait until, say, the list is full? We want to ensure that the consumer thread executes only when the condition is met.

Each producer inserts an element whose value is its own thread identifier. The consumer prints the contents of the list and then clears it, which only makes sense once the list is full. In this first version, the consumer repeatedly locks the mutex and checks whether the list is full; if it is, it prints and clears the list, otherwise it releases the lock and immediately tries to reacquire it.

![](https://assets.omscs.io/notes/EDA4A436-CA50-4ED0-BAEF-635D8DF3CD2A.png)

Note that this strategy is kind of wasteful. Ideally we wouldn't want our consumer thread to loop but
rather our producers to be able to notify the consumer when the list is full.

## Condition Variables
A **condition variable** is a construct that can be used in conjunction with mutexes to control the execution of concurrent threads.

![](https://assets.omscs.io/notes/D6DFDEB1-9AC5-419B-BB33-9F5F2699AEE3.png)

In this version, the consumer locks the mutex and, if the list is not full, waits for it to become full. Each producer, after inserting its element, checks whether that insertion made the list full, and only then signals `list_full`. While the consumer waits, the only way the list can become full is for a producer to acquire the mutex and insert an element, so the wait must release the mutex on entry and reacquire it on exit, since the consumer then modifies the list the mutex protects.

When a consumer sees that it must wait, it makes a call to the **wait** function, passing in a mutex and the condition variable it must wait on.

The wait function must ensure that the mutex is released if the condition is not met (so that the signaling thread may acquire the mutex) and must also ensure that the mutex is acquired when the condition is met (since the wait call occurs in the middle of a critical section).

When the condition becomes true, a thread holding the mutex may call the **signal** function to alert a waiting thread that they may proceed.

> **Paper (Birrell):** "Signal" awakens at least one blocked thread, but possibly more than one; the SRC implementation could rarely wake several, which is one of Birrell's reasons for re-checking the condition in a `while` loop. POSIX `pthread_cond_signal` likewise unblocks at least one thread.

## Condition Variable API
We need some type that corresponds to the condition variable. The condition variable data structure should contain:
* mutex reference
* list of waiting threads

We need a **wait** procedure which takes in a mutex and a condition variable. The wait procedure must be able to immediately release and reacquire the mutex as necessary depending on the condition variable.

We need a **signal** procedure, which allows a thread to signal to another thread waiting on a condition that the condition has been met.

We can also have a **broadcast** procedure, which allows a thread to signal to all other threads waiting on a condition that the condition has been met.

Basic implementation of wait procedure:

```c
Wait(mutex, cond){
  // atomically release mutex and place thread on wait queue

  // wait wait wait

  // remove thread from wait queue
  // reacquire mutex
  // exit wait
}
```

Note that broadcast may not always be super useful. Even though we can wake up all threads in wait, since we immediately lock the mutex when we remove a thread from the wait queue, we can still only execute one thread at a time.

> **Paper (Birrell):** Broadcast has two legitimate uses: simplifying a program by waking several threads without separating wait reasons onto different condition variables, and waking several threads when the resource just released can be used by more than one of them. Readers in a readers/writer lock are the standard example: they re-acquire the mutex one at a time only to update the counter, then read concurrently. POSIX likewise recommends broadcast when more than one waiter can proceed, and Lampson & Redell treat it as always correct.

<details>
<summary>Condition variable quiz spoiler</summary>

In the consumer code, why do we use `while` instead of simply `if` around the wait? Is it because `while` can support multiple consumer threads, because we cannot guarantee access to `m` once the condition is signaled, because the list can change before the consumer gets access again, or all of the above?

All of the above, and the three reasons are linked. With multiple consumer threads, a waiting consumer can wake up because the list is full, but before it processes the list, another consumer acquires the mutex, sees the full list, and prints and clears it. When the first consumer comes out of the wait, the state of the list has already changed. This happens because signaling a condition gives no guarantee about the order in which access to the mutex is granted, so other threads may acquire it first. Without control over access to the mutex, there is no way to guarantee that the list does not change before the consumer gets access to it again. We therefore use `while` to make sure the condition we waited on is actually met when we wake up.
</details>

## Readers/Writer Problem
Let's look at a scenario where there is some subset of threads that want to read from shared state, and one thread that wants to write to shared state. This is commonly known as the **readers/writer** problem.

At any given point in time, 0 or more readers can access the shared state at a given time, and 0 or 1 writers can access the shared state at a given time. The readers and writer cannot access the shared state at the same time.

One naive approach would be to wrap access to the shared state itself in the mutex. However, this approach is too restrictive. Since mutexes only allow access to shared state one thread at time, we would not be able to let multiple readers access state concurrently.

Let's enumerate the conditions in which reading is allowed, writing is allowed, and neither is allowed. We will use a `read_counter` and a `write_counter` to express the number of readers/writers at a given time.

If `read_counter == 0` and `write_counter == 0`, then both writing and reading is allowed. If `read_counter > 0`, then only reading is allowed. If `write_counter == 1`, neither reading nor writing is allowed.

We can condense our two counters into one variable, `resource_counter`. If the `resource_counter` is zero, we will say that resource is free; that is, available for reads and writes. If the resource is being accessed for reading, the `resource_counter` will be greater than zero, and its value is exactly the number of current readers. We can encode the case where the resource is being accessed for writing by setting `resource_counter` to `-1`, which also captures the fact that there can only ever be one writer.

Our `resource_counter` is a **proxy variable** that reflects the state that the current resource is in. Instead of controlling updates to the shared state, we can instead control access to this proxy variable. As long as any update to the shared state is first reflected in an update to the proxy variable, we can ensure that our state is accessed via the policies we wish to enforce.

Every problem in computer science can be solved with one more level of indirection. A mutex on its own can only express mutual exclusion, but a mutex guarding a proxy variable can express whatever policy we can encode in that variable.

![](https://assets.omscs.io/notes/E04D6E34-CC4A-44ED-A448-11D9B3D023AB.png)

## Readers/Writer Example
Let's make our previous discussion concrete with an example.

![](https://assets.omscs.io/notes/82238159-E5C0-4B01-A887-9946A2CBB3D4.png)

In this example, we can see that our reading and writing operations exist outside of a locked mutex, but are preceded and followed by a mutex enforced update to the shared variable, `resource_counter`.

Our program will require four things:

- `resource_counter` - a proxy variable for the state of the shared resource
- `counter_mutex` - a mutex which controls access to `resource_counter`
- `read_phase`  - a condition variable signifying that the resource is ready for reading
- `write_phase` - a condition variable signifying that the resource is ready for writing

Readers can begin reading by first locking the mutex and incrementing the value of the `resource_counter`. If multiple readers try to lock the mutex at once, all but one will block and each will unblock as the mutex becomes available.

If a writer tries to enter the fray while multiple readers are accessing the state, the writer will have to `wait`, since our application is such that writes cannot proceed while reads are ongoing. The writer will wait on the condition variable `write_phase`.

Once the reader decrements `resource_counter`, it will check to see if `resource_counter` is zero. If so, that means our application is in a state where writes can proceed, so this final reader will `signal` on the `write_phase` variable to wake up a waiting writer. Given that only one writer can proceed at a time, it does not make sense to use a `broadcast` here.

The pending writer will be removed from the wait queue that is associated with the `write_phase` variable, and the counter mutex will be reacquired before coming out of the wait operation. We recheck the while predicate: `resource_counter` must still be 0 (that is, `resource_counter != 0` must now be false) before we set it to -1. We can then proceed with our write.

**NB**: We need to recheck our condition in our while loop because the act of removing the thread from the wait queue and the act of reacquiring the mutex occur as two separate procedures. This means that the mutex could be reacquired in between these two steps by a *different thread*, with `resource_counter` being updated by that thread. Thus, we must check that our condition holds one last time after we acquire the mutex.

If a new thread wants to write while another thread is currently writing, this new thread will have to `wait` on `write_phase`. If a new thread wants to read while another thread is currently writing, this new thread will also have to `wait`, but on `read_phase` instead.

Once the current writer completes, it resets `resource_counter` to 0, and then `broadcast`s to the `read_phase` and `signals` to `write_phase`. We `signal` to `write_phase` because only one writer can access the shared state at a given time, and we `broadcast` to `read_phase` because multiple threads are allowed to read from the shared state at a given time.

> **Paper (Birrell):** The refined `ReleaseExclusive` wakes only one class of thread: it broadcasts to the readers' condition variable if any readers are waiting, and otherwise signals one writer. Waking both classes is correct, but it is the kind of spurious wake-up (in Birrell's sense, see Spurious Wake-ups below) his revision removes.

**NB**: Note that multiple threads cannot access the mutex concurrently, as this defeats the point of the mutex. But, after each thread accesses the mutex in turn, all readers can read from the shared state concurrently. This is why a mutex over the shared state itself was not sufficient: concurrent reads would not have been possible.

Even though we call `broadcast` before `signal` we don't really have control over whether a waiting reader or writer will be woken up first. That decision is left up to the thread scheduler, into which we do not usually have insight.

## Critical Section Structure
If we consider the reading and writing of the data to be the protected operations of the above application, then those sections of code are really the critical sections of our application, even though they exist outside of a mutex block.

![](https://assets.omscs.io/notes/CEC2C229-0849-48E2-A098-58B3E26F5436.png)

The structure of our application is such that even though the critical operations are not governed by a mutex, entering and exiting from those operations is.

![](https://assets.omscs.io/notes/17C45807-015F-4B4B-8457-3403DC414A21.png)

For example, before we can read data, we must first lock the mutex and increment `resource_counter`. After we read data, we must again lock the mutex and decrement `resource_counter`. A similar setup exists for writing data.

Each time we acquire the mutex, we must ensure that a condition is met such that we can proceed safely. If the condition is not met, we must wait. Once the condition is met, we can update our proxy variable. If appropriate, we can signal/broadcast to other threads if some condition has changed. Finally we can unlock the mutex.

![](https://assets.omscs.io/notes/359DCB22-6F78-4FF1-87E6-2EC2E7D1E554.png)

The "enter critical section" blocks can be seen as a higher level "lock" operation, while the "exit critical section" blocks can be seen as a higher level "unlock" operation, even though a mutex is being locked and unlocked within each of those blocks.

![](https://assets.omscs.io/notes/E1172921-B522-4812-B54F-5D6106CBB30A.png)

## Critical Section Structure With Proxy
![](https://assets.omscs.io/notes/FC626433-043F-4F39-88FB-54F5F184C381.png)

The mutex is held only *inside* the enter and exit blocks, so more than one thread can be in the real critical section at the same time. Note the asymmetry between the two: the enter block has a predicate to wait on, while the exit block generally has nothing to wait for and just updates the proxy variable and signals or broadcasts.

Again, this structure allows us to implement more complex sharing scenarios than the simple mutual exclusion that mutexes allow.

## Common Pitfalls
Make sure to keep track of the mutex/condition variables that are used with a given shared resource. Comments help!

 Make sure to always protect access to shared state, and make sure to do so consistently by acquiring the **same** mutex. A common mistake occurs when we forget to lock or unlock a mutex associated with a given piece of state. Compilers may generate warnings/errors to help us.

Don't use different mutexes to access a single resource. Using different mutexes to access a resource is akin to just not using a mutex at all, since there is no mutual exclusion amongst different mutexes.

Make sure that you are signaling or broadcasting on the correct condition. Signaling that reads can occur when you should be signaling that writes can occur can impact the correctness of your program.

Make sure to not use signal when broadcast needs to be used. Note that the opposite is actually okay (although it may incur a performance penalty). With signal only one thread wakes up to proceed; if more than one thread was waiting on the condition, the rest keep waiting, possibly indefinitely, and using signal instead of broadcast can also cause deadlocks.

Remember that the order of execution of threads is not related to the order in which we call signals or broadcasts. If priority/ordering guarantees are needed, other strategies must be devised.

## Spurious Wake-ups
![](https://assets.omscs.io/notes/64285C7B-9C4A-4FD6-9631-B740C1D61227.png)

We have a setup similar to the readers/writer example we saw previously. In this case, the writer is locking the mutex after writing to the shared state. Once the mutex is acquired, the proxy variable is updated, and a broadcast and signal are sent.

When the broadcast is issued, the thread library can start removing reader threads from the wait queue for their condition variable, potentially even before the writer releases the mutex.

What will happen, as the readers are removed from this queue is that they will try to acquire the mutex. Since the writer has not yet released the mutex, none of the readers will be able to acquire the mutex. They will have been woken up from one queue (associated with the condition variable) only to be placed on another queue (associated with acquiring the mutex) .

This situation in which we unnecessarily wake up a thread when there is no possible way for it proceed is called a **spurious wake up**.

> **Paper (Birrell):** Birrell uses "spurious wake-ups" for waking threads that cannot make useful progress, caused by using Broadcast where Signal would do or by threads waiting on one condition variable for several reasons. The case described here, a thread woken inside Wait only to block on a mutex the signaller still holds, he calls a "spurious lock conflict". Standard usage (POSIX, OSTEP) is closer to Birrell's sense: a thread returns from wait without its condition being true.

Note that spurious wake ups will not affect the correctness of the program, but rather the performance, as cycles will be wasted context switching to threads that will just be placed back on another queue.

Often we can unlock the mutex before we signal or broadcast. Sometimes we cannot. For example, if we signal/broadcast conditionally depending on some property of the shared state, that property must be accessed from within the mutex, which means the signal or broadcast must also take place within the mutex.

> **Paper (Birrell):** Only the test of shared state needs the mutex. In `ReleaseShared`, the reader computes `doSignal := (i = 0)` inside the lock clause and calls `Signal(cW)` after it, which avoids the lock conflict while keeping the access to `i` protected. POSIX also allows signalling without holding the mutex.

![](https://assets.omscs.io/notes/DB2EC542-93FD-406D-AB18-B041037F0EED.png)

## Deadlocks
A **deadlock** occurs when two or more competing threads are waiting on each other to complete, but none of them ever do.

In the toy shop, imagine two workers finishing toy train orders, each of whom needs a soldering iron and a solder wire, and there is only one of each. The first worker grabs the soldering iron, the second grabs the solder wire, and since neither will give up what they hold, neither toy ever gets made.

Let's consider two threads, T1 and T2, that need to perform operations on some shared variables A and B. Before performing these operations, each thread must lock the mutex associated with those variables, because they are part of shared state.

Let's assume that T1 first locks the mutex for A  and then locks the mutex for B before performing the operation. Let's assume that T2 first locks the mutex for B and then locks the mutex for A, before performing the operation.

This is where the problem lies. T2 will not be able to lock the mutex for A, because T1 is holding it. T1 will not be able to lock the mutex for B, because T2 is holding it. *More importantly*, neither T1 nor T2 will be able to release the mutex that the other needs, since they are both blocking trying to acquire the mutex the other has.

How can we avoid these situations?

One solution would be to unlock A before locking B, an approach known as **fine-grained locking**. However, this solution will not work in this scenario since we need access to both A and B.

Another solution would be to get all locks up front, and then release all of them at the end. Or we can just use a single **mega-lock** covering both A and B. This solution may work for some applications, but may be too restrictive for others, because it limits the amount of parallelism that can exist in the system.

The last and most ideal solution is to maintain a **lock order**.  In this case, we would enforce that all threads must lock the mutex associated with A before locking the mutex associated with B, or vice versa. The particular order may not be important, but rather the enforcement of that ordering within the application is paramount.

Suppose both threads must take A then B. If T1 is about to lock B, it must already hold A. If T1 holds A, then T2 cannot hold A. And if T2 doesn't hold A, it hasn't reached its first lock yet, so it cannot be holding B either. No cycle is possible, so T1 acquires B and proceeds.

This technique is foolproof, but it takes effort. In a large program with many shared variables and many mutexes, we have to establish an order and then enforce it consistently everywhere. With complex code, especially code that comes from different sources, it is hard to guarantee that every mutex is acquired in exactly the same order across every source file. Deadlocks are a reality.

A cycle in the wait graph is necessary and sufficient for a deadlock to occur, and the edges in this graph are from the thread waiting on a resource to the thread owning a resource.

We can try to prevent deadlocks. Each time a thread is about to acquire a mutex, we can check to see if that operation will cause a deadlock. If it will, we have to delay the operation, and we may even have to restructure the code so that the thread first releases some resource and only afterwards issues the lock request. This can be expensive.

Alternatively, we can try to detect deadlocks and recover from them. We can accomplish this through analysis of the wait graph and trying to determine whether any cycles have occurred. This is still an expensive operation as it requires us to have a rollback strategy in the event that we need to recover, which means maintaining enough state during execution to figure out how to recover. In some cases rollback is not merely expensive but impossible: inputs and outputs that came from external sources cannot be rolled back.

We can also apply the ostrich algorithm by doing nothing! We can hope that the system never deadlocks, and if we are wrong we can just reboot.

Prevention and detection/recovery impose enough overhead on the execution time of the system that they are typically applied only in really performance-critical systems.

<details>
<summary>Critical section quiz spoiler</summary>

A toy shop handles new orders and old orders (repairs of toys already processed). A mutex, `orders_mutex`, controls which workers have access to the toy shop. The policy: at any point in time there can be up to three new orders processed, and if there is only up to one new order being processed, any number of old orders can be handled. The critical section entry code for workers performing new orders locks `orders_mutex`, then waits on condition variable `new_cond` (with `orders_mutex`) while a predicate holds, and finally increments `new_order`. Which of four candidate predicate checks are correct?

* First option, correct: wait while `new_order` is equal to 3, or while one new order has already entered and there are some old orders in the system. This matches both parts of the policy. `new_order` can never exceed 3, since it is only incremented after coming out of the wait.
* Second option, incorrect: almost identical to the first, but uses `if` instead of `while`. Another thread may change the predicate before the woken thread reacquires the mutex, and without re-evaluating it the thread can enter the toy shop in violation of the policy.
* Third option, incorrect: checks whether `old_order` is greater than or equal to 0. A new order would then be blocked whenever one new order is already in the shop, even with no old orders at all, while the policy allows up to three new orders.
* Fourth option, correct: identical to the first except that it uses greater than or equal to 3. Since `new_order` never exceeds 3, the behavior is identical.
</details>

## Kernel vs. User Level Threads
Kernel level threads imply that the operating system itself is multithreaded.  Kernel level threads are visible to the kernel and are managed by kernel level components like the kernel level scheduler.  The operating system scheduler will determine how these threads will be mapped onto the underlying physical CPU(s) and which ones will execute at any given point.

Some kernel level threads may exist to support user level applications, while other kernel level threads may exist just to run operating system level services, like daemons for instance.

At the user level, the processes themselves are multithreaded and these are the user level threads. For a user level thread to actually execute, it must first be associated with a kernel level thread, and then the OS level scheduler must schedule that kernel level thread on the CPU.

## Multithreading Models
We will consider three multithreading models.

### One-to-One Model
In this model, each user level thread has a kernel level thread associated with it. When a user process creates a new user level thread, either a new kernel level thread is created or an existing kernel level thread is associated with this new user level thread.

This means that the operating system can see the user level threads. It understands that the process is multithreaded, and it also understands what those threads need. Since the operating system already supports threading mechanisms to manage its thread, the user libraries can benefit directly from the multithreading support available in the kernel.

One downside of this approach is that is it expensive: for every operation we must go to the kernel and pay the cost of a system call. Another downside is that since we are relying on the mechanisms and policies supported by the kernel, we are limited to only those policies and mechanisms. For example, if the kernel does not support a particular scheduling policy, or limits the number of threads, the process is restricted to operate within those bounds. This hurts portability: an application with particular needs for how its threads are managed can run only on kernels that provide exactly that support.

### Many-to-One Model
In this model, all of the user level threads for a process are mapped onto a single kernel level thread. At the user level, there is a thread management library to make decisions about which user level thread to map onto the kernel level thread at any given point in time. That user level thread will still only run once that kernel level thread is scheduled on the CPU by the kernel level scheduler.

The benefit of this approach is that it is portable. Everything is done at the user level, which frees us from being reliant on the OS limits and policies. As well as, we don't have to make system calls for any thread-related decisions.

However, the operating system loses its insight into application needs. It doesn't even know that the process is multithreaded. All it sees is one kernel level thread. If the user level library schedules a thread that performs some blocking operation, the OS will place the associated kernel level thread onto some request queue, which will end up blocking the entire process, even though more work can potentially be done.

### Many-to-Many Model
This model allows for some user threads to have a many-to-one relationship with a kernel thread, while allowing other user threads to have a one-to-one relationship with a kernel thread.

The benefit is that we get the best of both worlds. The kernel is aware that the process is multithreaded since it has assigned multiple kernel level threads to the process. This means that if one kernel level thread blocks on an operation, we can context switch to another, and the process as a whole can proceed.

We can have a situation where a user level thread can be scheduled on any allocated kernel level thread. This is known as an **unbound** thread. Alternatively, we can have the case where a user level thread will always be scheduled atop the same kernel level thread. This is known as a **bound** thread.

> **Paper (Stein & Shah):** Unbound threads are multiplexed by the library over a pool of nearly identical LWPs, so any unbound thread can run on any LWP in the pool rather than on one fixed kernel thread. A bound thread is permanently attached to its own LWP.

Bound threads are useful when certain user level threads need better priority, or need to be more responsive to events happening in the kernel. Since the mapping is permanent, the kernel can schedule the corresponding kernel level thread immediately. For instance, if the kernel sees some user input and we have a user level thread designated to run the user interface for the process, the kernel can immediately schedule the kernel level thread it is bound to, and with it that user level thread.

One of the downsides of this model is that it requires extra coordination between the user level and kernel level thread managers. In the one-to-one model nearly everything goes to the kernel level manager, and in the many-to-one model nearly everything goes to the user level library; the many-to-many model often needs the two to coordinate, mostly to take advantage of performance opportunities.

## Scope of Multithreading
At the kernel level, there is system wide thread management, supported by the operating system level thread managers. These managers will look at the entire platform before making decisions on how to run their threads. This is the **system scope**.

On the other hand, at the user level, the user level library manages all of the threads for the given process it is linked to. The user level library thread managers cannot see threads outside of their process, so we say that these managers have **process scope**. Different processes are managed by different instances of the same library, and some processes may link entirely different user level libraries.

To understand the consequences of having different scope, let's consider the scenario where we have two processes, A (a web server) and B (a database). A has twice as many user level threads as B.

If the threads have a process scope, this means that the kernel cannot see them, and will probably allocate equal kernel resources to A and B, for example two kernel level threads each. This means that a given thread in A will be allocated half of the CPU cycles as will be allocated to a thread in B.

If we have a system scope, the user level threads will be visible at the kernel, so the kernel will allocate the CPU relative to the total amount of user threads, as opposed to the total amount of processes. If the kernel's policy is to give every user level thread an equal share of the CPU, A will receive a larger share overall than B, since it has more user level threads.

![](https://assets.omscs.io/notes/29EDC9A1-9608-4CDD-832E-8C268E93F031.png)

## Multithreading Patterns
Let's discuss three different patterns.

We will describe them in the context of the toy shop. For each wooden toy order, the shop performs six steps:
1. accept the order from the customer
2. parse the order to see what it is for
3. cut the wooden parts for the toy
4. paint and add decorations to the toy parts
5. assemble the wooden toy
6. ship the order

Each pattern assigns these steps to the workers differently.

### Boss/Workers Pattern

The boss/workers pattern is characterized by having one boss thread and some number of worker threads. The boss is in charge of assigning work to the workers, and the workers are responsible for completing the entire task that is assigned to them.

In the toy shop, the boss performs only step 1: it accepts an order and immediately passes it on, without looking at what the order is for. Each worker performs steps 2 through 6. This keeps the amount of work the boss does per order small.

The throughput of the system is limited by the boss thread, since the boss has to do some work for every task that comes into the system. As a result it is imperative to keep the boss efficient to keep the overall system moving smoothly. Specifically, the throughput of the system is inversely proportional to the amount of time the boss spends on each task.

How does the boss assign work to the workers? One solution is to keep track of which workers are currently working, and send a direct signal to a worker that is idle. This means that the boss must do some work for each worker, since it has to select a worker and then wait for that worker to accept the work.

The positive of this approach is that the workers do not need to synchronize amongst each other. The downside of this approach is that the boss must keep track of every worker, and this extra work will decrease throughput.

Another option is to establish a queue between the boss and the workers, similar to a producer/consumer queue. In this case, the boss is the sole producer, while the workers are consumers.

The positive of this approach is that the boss doesn't need to know any of the details about the workers. It just places the work it accepts on the queue and moves on. Whenever a worker becomes free it just looks at the front of the queue and retrieves the next item.

The downside of this approach is that further synchronization is required, both for the boss producing to the queue, and the workers competing amongst one another to consume from the queue. All the workers may contend for the front of the queue, and any given work item must go to exactly one worker. The boss and workers also need to synchronize when comparing the front and end pointers to determine whether the queue is full or empty.

Despite this downside, this approach still results in decreased work for the boss for each task, which increases the throughput for the whole system. This is the variant usually chosen when building applications with this pattern.

#### How many workers?
If the work queue fills up, the boss cannot add items to the queue, and the amount of time that the boss has to spend per task increases. The likelihood of the queue filling up is dependent on the number of workers: with more threads, the queue is less likely to be full.

Adding more threads may help to increase/stabilize the throughput, but adding an arbitrary number of threads can introduce complexities.

We can create workers on demand; that is, in response to a new task coming into our system. This may be inefficient, though if the cost of creating a worker (thread) is significant.

A more common model is to create a pool of workers that are initialized up front. The questions remains: how do we know how many workers we ought to create?

A common technique is to use a pool of workers that can be increased in response to high demand on the system. This is not quite like the on demand approach in that new threads will not be created one at a time when the demand passes a threshold, but rather several threads are added at once whenever the pool size needs adjusting. This tends to be the most effective approach to managing the number of threads in the boss/workers pattern.

The benefit of the boss/workers model is the overall simplicity. One thread assigns the work, and the rest of the threads complete it.

One downside of this approach is the thread pool management overhead, including synchronization for the shared buffer. Another downside is that this system lacks **locality**. The boss doesn't keep track of what any of the workers were doing last. It is possible that a thread is just finishing a task that is very similar to an incoming task, and therefore may be best suited to complete that task. The boss has no insight into this fact.

#### Worker Variants
An alternative to having all the workers in the system perform the same task is to have different workers specialized for different tasks. We can split the work by type of item being produced, by new requests versus repairs or reprocessing, or by class of customer.

One added stipulation to this setup is that the boss has to do a little bit more work in determining which set of workers should handle a given task. This extra work is usually offset by the fact that workers are now more efficient at completing their tasks.

This approach exploits locality. By performing only a subset of the work, it is likely only a subset of the state will need to be accessed, and it is more likely this part of the state will already be present in CPU cache.

In addition, we can offer better quality of service. We can create more threads for urgent tasks or tasks that have higher paying customers.

One downside of this approach is the load balancing mechanisms and requirements may become more difficult to reason about.

### Pipeline Pattern
In a pipeline approach, the overall task is divided into subtasks and each of the subtasks are assigned a different thread. For example, if we have six step process, we will have six kinds of threads, one for each stage in the pipeline. In the toy shop, six workers each perform one of the six steps.

At any given point in time, we may have multiple tasks being worked on concurrently in the system, each at a different stage. For example, one worker can be accepting one order, another parsing a second order, a third cutting the wooden pieces for a third order, and so forth.

The throughput of the pipeline will be dependent on the *weakest link* in the pipeline; that is, the task that takes the longest amount of time to complete. In this case, we can allocate more threads to that given step. For example, if a step takes three times as long as every other step, we can allocate three times the number of threads to that step.

To decide how many threads each stage needs, we can use the same thread pool technique described for the boss/workers model.

The best way to pass work between these stages is a shared buffer base communication between stages. That means the thread for stage one will put its completed work on a buffer that the thread from stage two will read from and so on.

The alternative is direct communication, where a thread hands its output straight to the thread in the next stage. That couples the two: the earlier stage may have to wait until the next stage is free to receive. With a shared buffer, a thread deposits its output and moves on, and the next stage picks it up when ready. The buffer corrects for small imbalances between stages and avoids stalls due to temporary pipeline imbalances.

![](https://assets.omscs.io/notes/DEDC3AC5-1BDC-4288-8FB0-20AE35A510C6.png)

In summary, a pipeline is a sequence of stages, where a thread performs a stage in the pipeline, which is equivalent to some subtask within the end to end processing. To keep the pipeline balanced, a stage can be executed by more than one thread. Communication via shared buffers reduces coupling between the components of the system.

A key benefit of this approach is specialization and locality, which can lead to more efficiency, as state required for subsequent similar jobs is likely to be present in CPU caches.

A downside of this approach is that it is difficult to keep the pipeline balanced over time. When the input rate changes, or the resources at a given stage are exhausted, rebalancing may be required.

The other downside is synchronization overhead. There are synchronization points at multiple stages along the end-to-end path, so the total overhead is higher.

### Layered Pattern
A layered model of multithreading is one in which similar subtasks are grouped together into a "layer" and the threads that are assigned to a layer can perform any of the subtasks in that layer. The end-to-end task must pass through all the layers.

In the toy shop, steps 1, 2 and 6 (accept, parse, ship) all deal with order processing and form one layer. Steps 3 and 5 (cutting and assembling the wooden pieces) form another, and step 4 (painting and decorating) forms a third.

Unlike the pipeline, a task travels **up and down** through the layers, not in one direction. Related steps get grouped together even when they sit at opposite ends of the end-to-end flow, so control has to move both ways across the stack.

A benefit of this approach is that we can have specialization while being less fine-grained than the pipeline pattern. Being coarser also makes the thread allocation question easier: deciding how many threads per layer is a simpler problem than deciding how many per pipeline stage.

Downsides of this approach include that it may not be suitable for all applications and that synchronization may be more complex as each layer must know about the layers above and below it to both receive inputs and pass results.

Grouping only pays off if the steps in a layer genuinely share state. For example, it may not make sense to group the first and last steps of the toy order (accept and ship) and assign them to the same thread. If the steps have little in common, assigning them to the same thread gives us no locality, and the specialization benefit disappears.

![](https://assets.omscs.io/notes/2649776E-95FB-4692-8F9C-EC4574A421EA.png)

<details>
<summary>Multithreading patterns quiz spoiler</summary>

Take six threads, a boss/workers solution where a worker takes 120ms to process a toy, and a pipeline solution whose six stages each take 20ms. Ignore any time spent waiting in the shared queues, and assume infinite processing resources like tools and work areas.

Boss/workers dedicates one thread to the boss, leaving five workers, so five orders proceed at a time. Ten orders take two rounds of 120ms, or 240ms. Eleven orders need a third round for the one order left over, even though only one worker is busy in it, so they take 360ms.

The pipeline takes 120ms for the first order to clear all six stages. Every order behind it is already in the last stage when its predecessor exits, so each one adds a single stage time of 20ms. Ten orders take 120 + 9 * 20, or 300ms. Eleven orders take 120 + 10 * 20, or 320ms.

Boss/workers wins at ten orders and the pipeline wins at eleven. This is the same metric and the same thread count in both cases, so which pattern is better can depend on the input the application receives.

This calculation is simplified. It ignores the overheads of synchronization and of passing data among threads through the shared memory queues, so deciding which pattern suits an application needs more experimental analysis than this.
</details>
