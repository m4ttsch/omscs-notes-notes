---
id: operating-systems-threads-case-study-pthreads
title: Threads Case Study - PThreads
course: operating-systems
lecture: threads-case-study-pthreads
---

# Threads Case Study - PThreads

**Reference paper**: [An Introduction to Programming with Threads](https://s3.amazonaws.com/content.udacity-data.com/courses/ud923/references/ud923-birrell-paper.pdf) - Andrew Birrell.

**OSTEP chapter**: [27. Interlude: Thread API](https://pages.cs.wisc.edu/~remzi/OSTEP/threads-api.pdf)

PThreads stands for POSIX Threads, the de facto threading standard on UNIX systems. POSIX (Portable Operating System Interface) describes the system call interface that operating systems need to support, with the intent of increasing interoperability among OSes. Within POSIX, PThreads describes the threading API that operating systems need to support for creating, using and managing threads, including both the threads themselves and synchronization constructs such as mutexes and condition variables.

## PThread Creation
Birrell proposed the Thread abstraction together with the Fork and Join mechanisms; pthreads provides corresponding constructs.

To represent threads, pthreads supports a `pthread_t` data type. Like Birrell's Thread type, a variable of this type uniquely identifies and describes a thread. It holds the thread's identifier, its execution state, and any other information that is relevant to the thread. Most of this is not something we see directly as developers; it is used and maintained by the pthreads library.

Threads are created by the following function

```c
int pthread_create(pthread_t *thread, const pthread_attr_t *attr, void * (*start_routine)(void *), void *arg);
```

This function takes as arguments a pointer to a `pthread_t`, as well as a start routine and an argument to pass to that start routine. `pthread_create` is the equivalent of Birrell's `Fork`: `start_routine` corresponds to Fork's proc, and `arg` to Fork's arguments.

It also takes an argument which is of the type `pthread_attr_t` which is a data structure that can be used to set various options on the thread during creation.

`pthread_create` returns an `int` which indicates whether the creation was a success or a failure.

Child threads can be joined back to a parent thread with

```c
int pthread_join(pthread_t thread, void **status);
```

`pthread_join` is the equivalent of Birrell's `Join`. This function takes the thread to be joined as well as a status variable. The status variable will capture all of the relevant return information, as well as the results returned by the thread to be joined.

`pthread_join` returns an `int` which indicates whether the join was a success or a failure. These operations are fairly analogous to the ones Birrell proposed.

 The `pthread_attr_t` data structure allows us to define features of the new thread we are creating, such as:

- stack size
- scheduling policy
- priority
- system/process scope
- inheritance
- joinable

If `NULL` is passed in the place of a `pthread_attr_t`, pthreads falls back to default behavior for the new thread.

There are several calls that allow us to operate on a `pthread_attr_t`

```c
int pthread_attr_init(pthread_attr_t *attr);
int pthread_attr_destroy(pthread_attr_t *attr);
pthread_attr_{set/get}{attribute};
```

These functions can be used, respectively, to allocate space for a `pthread_attr_t`, to deallocate space for that `pthread_attr_t` and to set/get various attributes of that structure. `pthread_attr_init` also sets the fields of the structure to the pthreads default values.

---

One mechanism not considered by Birrell is **detachable threads**.  In pthreads, the default behavior for thread creation is joinable threads, just as Birrell described. For a joinable (child) thread, the parent should not terminate until the child has completed its execution and has been joined with an explicit join operation. If the parent thread exits early, the child threads may turn into zombies: they may have completed or died, but they were never exited or reaped properly.

In pthreads, it is possible to allow child threads to become detached. Detached threads cannot be joined back into the parent, allowing the parent to exit early and the child threads to continue their execution. Detaching makes the parent and the children equivalent to one another, with the exception that the parent still holds some additional information about the children it created.

To detach threads, use

```c
int pthread_detach(pthread_t thread);
```

Or

```c
pthread_attr_setdetachstate(attr, PTHREAD_CREATE_DETACHED);

// ...

pthread_create(..., attr, ...);
```

Since parent threads do not need to wait around until child threads complete, they can simply exit with `pthread_exit`.

> **Paper (Birrell):** Join is not called very much at SRC, some thread facilities do not provide it at all, and a thread whose procedure returns with no later Join "quietly evaporates", which is in effect a detached thread. The paper says nothing about what happens to other threads when the forking thread exits. POSIX agrees that detach only lets a thread's storage be reclaimed without a join, and other threads outlive `main` only if it calls `pthread_exit` instead of returning.

Example of creating a new thread with custom options:

![](https://assets.omscs.io/notes/AE046645-2865-4D9E-9BB6-F6D29630925E.png)

The attribute structure is created and initialized first, which allocates it with enough memory and sets its values to the pthreads defaults. We then adjust the values we care about: the detach state becomes `PTHREAD_CREATE_DETACHED`, and the scheduling scope becomes system scope, so the new thread shares resources equally with all other threads in the system. The resulting structure is passed to `pthread_create`.

## Compiling PThreads
![](https://assets.omscs.io/notes/DB37467E-C553-47FF-AB93-C9A563E19C37.png)

We need to include the pthreads header file, `pthread.h`, in the file that contains our pthreads code. Without it, the program will not compile.

We also need to link the program against the pthreads library by passing the `-lpthread` flag at compile time. On certain platforms the better option is `-pthread`, which tells the compiler to link the pthreads library and to configure the compilation for threads. If we do not link the library, the program may not report certain compilation errors at compile time, but it will still fail.

Finally, it is a good idea to check the return values of common functions, such as those that create threads, create variables, or initialize data structures. This is good practice in general, and it is especially useful when writing multithreaded programs.

## PThread Creation Example 1
![](https://assets.omscs.io/notes/F9C7DD92-0CBA-4F3F-A956-447277AD1FCF.png)

We loop and create four threads with `pthread_create` passing in `hello` as the start routine; `hello` just prints Hello Thread. Since this function takes no arguments we pass `NULL` as the fourth argument to the function. Also, since we do not need any custom behavior, we pass `NULL` as the second argument. Because the default attributes make the threads joinable, after we create the threads we must join them all back in.

<details>
<summary>PThread creation quiz 1 spoiler</summary>

The quiz asks what the output of this program is. Hello Thread is printed four times, once by each of the threads we created.
</details>

## PThread Creation Example 2
![](https://assets.omscs.io/notes/E7949C2E-E41F-4F6E-89CD-187F515770A0.png)  

In this case, the call to `pthread_create` passes in a value for the final parameter (the argument to pass to the start routine). This value is the pointer to current value of `i` the loop counter. In `threadFunc`, the pointer is first cast to an integer pointer, before a local variable is assigned to the value the pointer points to. Finally, the value is printed out.

Both `p` and `myNum` are **private to each thread**. They only exist within the scope of the thread function, so each of the four threads gets its own copies, and those copies will likely hold different values.

<details>
<summary>PThread creation quiz 2 spoiler</summary>

The quiz asks which outputs of this program are possible (check all that apply); all three options are possible. We do not have control over how these newly created threads will actually be scheduled. The order in which each thread reaches its `printf` may differ from the order in which the threads were created, so an output such as Thread Number 0, 2, 1, 3 is possible even though the loop created the threads with `i` running from 0 to 3. Sequential output is possible too. A third output, with Thread Number 2 printed twice and no Thread Number 1, is also possible; the next section explains why.
</details>

## PThread Creation Example 3
This section explains how this is a valid output for the example above

```bash
Thread Number 0
Thread Number 2
Thread Number 2
Thread Number 3
```

The lecture calls the variable `i` that is used in thread creation in the example above a globally visible variable defined in `main`: when its value changes in one thread, every one of the other threads will see the new value. Strictly, `i` is local to `main`, not global. The threads can still see its value change because we pass `pthread_create` the address of `i` rather than a copy of its value. When `main` changes `i`, every thread that reads through that address will see the new value.

In this particular case, the second thread that is created with `pthread_create` is created when `i == 1`. In the thread function, `p` will become equivalent to the address of `i` and `myNum` will take on the value of `i`, which is presumably 1.

However, it is possible that before this thread had the chance to cast the pointer and define a local variable pointing to the pointer's value, the main thread went into the next iteration of the `for` loop and incremented `i`, making `i` now 2. Since we pass the address of `i` to the start routine, `p` will still point to the address of `i`, but `myNum` will take on the (new) value of `i`, which is 2.

We call the above situation a **data race** or **race condition**. In summary, these terms refers to situations in which one thread tries to read a value that another thread is modifying.

To correct the problem, we must first initialize an array `tNum` that contains as many elements as we have threads. On each iteration of the `for` loop, we can set the index of `tNum` at `i` to `i`. We can then pass the address of `tNum[i]` to the call to `pthread_create`. This way we can increment `i`, while ensuring that the value of `i` that a thread needs to see does not change. We accomplish this by copying the value of `i` over to this private storage that we do not modify.

![](https://assets.omscs.io/notes/B5DB4FD0-C1D8-4180-A2A9-D4E8BFB93F7E.png)

<details>
<summary>PThread creation quiz 3 spoiler</summary>

The quiz asks which outputs of the fixed program are possible (check all that apply). Since every thread now has its own private storage for its argument, we expect Thread Number 0, 1, 2 and 3 each to appear in the output, in any order. Given that, the first option is not a possible output; the second and third options are correct.
</details>

## PThread Mutexes
To deal with the mutual exclusion problem, pthreads supports mutexes. Mutual exclusion ensures that threads access shared state in a controlled manner, such that only one thread at a time can apply modifications or otherwise access that shared variable.

In pthreads, the mutex data structure is represented via a `pthread_mutex_t` type.

Birrell proposed the use of the mutex itself and an operation to lock mutexes. Birrell protected a critical section with a block construct: the opening curly bracket meant that the mutex was being locked, and the closing curly bracket meant that the mutex was released.

In pthreads, there is no implicit unlock: both lock and unlock must be explicitly called.

```c
int pthread_mutex_lock(pthread_mutex_t *mutex);
int pthread_mutex_unlock(pthread_mutex_t *mutex);
```

Whatever code appears between these two statements will correspond to the *critical section*.

The `safe_insert` operation we implemented with Birrell's block construct in the introductory threads lecture becomes an explicit lock, the insert into the shared list `my_list`, and then an explicit unlock.

Mutexes must be explicitly initialized, as with the following function

```c
int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr);
```

 The `pthread_mutexattr_t *attr` argument allows us to specify the behavior that we want the mutex to have. Passing `NULL` gives us the default behavior (similar to the case with `pthread_create` and `pthread_attr_t`).

One such attribute is process sharing. By default, a mutex is private to a process, which means it is visible only to the threads within that process. We can modify that behavior explicitly so that the mutex can be shared with other processes.

Another interesting operation that can be used on mutexes is

```c
int pthread_mutex_trylock(pthread_mutex_t *mutex);
```

Unlike `pthread_mutex_lock` which will cause the calling thread to block, this function will return immediately if the mutex cannot be acquired, notifying the caller that the mutex is not available. If the mutex is free, trylock acquires it. If it is in use, the calling thread is not blocked, so it can go and do something else and check again later whether the mutex is free.

Mutexes can be destroyed (freed) with

```c
int pthread_mutex_destroy(pthread_mutex_t *mutex);
```

### Mutex Safety Tips

- shared data should always be accessed through single mutex
- mutex scope must be global
	- the mutex must be visible to all threads; it cannot be private to a single thread, including `main`
- globally order locks
	- lock mutexes in order (to prevent deadlocks)
- always unlock the (correct) mutex
	- separate lock and unlock calls make it easy to forget the unlock, and the compiler will not necessarily warn you

> **Paper (Birrell):** Mutexes are ordinary data values, and a module managing many objects can protect each one by associating a mutex with the record that represents it, such as one lock per open file plus a lock for the global table, which allows more parallelism. Third-party sources (POSIX, OSTEP) agree that the requirement is that every thread using the mutex can reach the same instance, not that it is a global variable.

## PThread Condition Variables
Condition variables are synchronization mechanisms that allow blocked threads to be notified when a certain condition occurs. Birrell proposed the Condition abstraction with three operations: Wait, Signal and Broadcast; the pthreads operations align with these.

In pthreads, condition variables are represented by the `pthread_cond_t` data type.

To wait on a condition variable, we can call

```c
int pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex);
```

Like Birrell's Wait, it takes a condition variable and a mutex. When a thread enters this function, it automatically releases the mutex and places itself on the wait queue associated with the condition variable. When the thread is woken up, it will automatically reacquire the mutex before exiting the wait operation. These semantics are identical to Birrell's Wait.

To signal or broadcast on a condition variable we call

```c
int pthread_cond_signal(pthread_cond_t *cond);
int pthread_cond_broadcast(pthread_cond_t *cond);
```

`pthread_cond_signal` notifies one thread that is waiting on the condition variable. `pthread_cond_broadcast` notifies all of the threads that are waiting on it. These are identical to Birrell's Signal and Broadcast.

To allocate/create a condition variable and de-allocate/destroy a condition variable, we can call

```c
int pthread_cond_init(pthread_cond_t *cond, const pthread_condattr_t *attr);

int pthread_cond_destroy(pthread_cond_t *cond);
```

`pthread_cond_init` takes some attributes that can further specify the behavior of the condition variable (much like we saw with `pthread_create` and `pthread_mutex_init`). One of these attributes controls whether the condition variable is used only by the threads that belong to a single process or is shared across processes. As before, setting this value to `NULL` gives us the default behavior, which is that the condition variable is private to a process.

### Condition Variable Safety Tips

- Don't forget to notify waiting threads!
	- When a condition changes, make sure to signal/broadcast the correct condition variable
- When in doubt use broadcast!
	- Using broadcast incorrectly can incur a performance loss, but using signal incorrectly make cause your program to execute incorrectly.
	- Once you figure out the desired behavior, switch to the correct mechanism (signal or broadcast), since broadcast costs performance.
- You don't need a mutex to signal/broadcast
	- May be best to notify after unlocking mutex to prevent spurious wake ups.

## Producer and Consumer Example
Let's walk through a real producer/consumer example using PThreads.

### Global State

![](https://assets.omscs.io/notes/8EC12822-FD53-44F6-8E53-ADC3504DBF41.png)

Our shared buffer is `buffer`. `add` and `rem` refer to the indices at which we add and remove elements, respectively, while `num` refers to the number of elements in the queue. `BUF_SIZE` is 3 in this example.

All three start at zero. An addition writes at `add`, advances `add` and increments `num`. A removal reads at `rem`, advances `rem` and decrements `num`. So after two additions and one removal, `num` is 1, `add` is 2, and `rem` is 1.

These shared variables are used in conjunction with our mutex `m` and our condition variables `c_cons` and `c_prod` which are all initialized here. The mutex is set up with the static initializer at declaration time instead of with a call to `pthread_mutex_init`.

Finally, we define our two procedures: `producer` and `consumer`, which will be executed by the producer and consumer threads respectively.

### Main

![](https://assets.omscs.io/notes/BAB41E1C-B65F-4409-948C-8AFBD2203D1C.png)

The first thread that we create will execute the `producer` function, and the second thread will execute the `consumer` function. Neither function takes input, so `NULL` is passed as the argument. `main` checks each `pthread_create` return code to help with debugging, then simply waits for both threads to exit.

We use the default behavior for these threads (i.e. they are not detachable), so we must make sure to `pthread_join` them before `main` returns.

### Producer

![](https://assets.omscs.io/notes/91CE2BF6-F3DC-4B8A-9F65-BF320C4D2DE6.png)

The producer loops twenty times, and tries to produce an element to the shared buffer on each iteration.

It tries to accomplish this by first acquiring `m` with `pthread_mutex_lock`. After a sanity check for overflow (the program exits if `num > BUF_SIZE`), the producer will potentially wait on `c_prod` with `pthread_cond_wait` if the shared buffer is full (`num == BUF_SIZE`). `m` is passed to `pthread_cond_wait` so that the pthreads library knows which mutex to release while waiting and reacquire afterwards. Once there is room (immediately, or after being woken), the producer will add its element to the buffer, and update `add` and `num` to reflect this addition.

The buffer has a fixed size, so `add` can run off the end of it. The producer advances the index with modular arithmetic, `add = (add + 1) % BUF_SIZE`, which wraps it back around to the front of the buffer.

Once the producer unlocks the mutex, it signals on `c_cons` with `pthread_cond_signal` to let the consumers know that there is data to consume. It signals rather than broadcasts because it inserted a single element, so only one consumer thread can proceed.

### Consumer

![](https://assets.omscs.io/notes/6454827D-99FF-45DD-A6A6-AA55B2F7C647.png)

The consumer loops forever, continuously trying to remove elements from the shared buffer.

It tries to accomplish this by first acquiring `m` with `pthread_mutex_lock`. After a sanity check for underflow (the program exits if `num < 0`), the consumer will potentially wait on `c_cons` with `pthread_cond_wait` if the shared buffer is empty (`num == 0`). Once there is data (immediately, or after being woken), the consumer will remove an element from the buffer, and update `rem` and `num` to reflect this removal.

As with `add` on the producer side, the consumer advances `rem` with modular arithmetic, `rem = (rem + 1) % BUF_SIZE`, so that the index wraps back around at the end of the buffer.

When the consumer comes out of `pthread_cond_wait`, it re-verifies that `num` is non-zero rather than assuming that a producer has left something in the buffer.

Once the consumer unlocks the mutex, it signals on `c_prod` with `pthread_cond_signal` to let the producer know that there is space in the buffer to add more data. The signal is issued after the mutex is released, which is safe here because the signal is unconditional at that point: it does not depend on the value of any shared variable. Signaling outside the critical section avoids the spurious wake ups mentioned in the Condition Variable Safety Tips above. We signal rather than broadcast because consuming one element frees exactly one slot, so only one producer can proceed.
