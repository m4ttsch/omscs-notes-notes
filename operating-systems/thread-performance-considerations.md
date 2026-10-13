---
id: operating-systems-thread-performance-considerations
title: Thread Performance Considerations
course: operating-systems
lecture: thread-performance-considerations
---

# Thread Performance Considerations

**Reference paper**: [Flash: An Efficient and Portable Web Server](https://s3.amazonaws.com/content.udacity-data.com/courses/ud923/references/ud923-pai-paper.pdf) - Pai, Druschel and Zwaenepoel.

**OSTEP chapters**:
* [28. Locks](https://pages.cs.wisc.edu/~remzi/OSTEP/threads-locks.pdf)
* [29. Lock-based Concurrent Data Structures](https://pages.cs.wisc.edu/~remzi/OSTEP/threads-locks-usage.pdf)

## Which Threading Model Is Better?
Let's compare the following two models to see which one is better

![](https://assets.omscs.io/notes/6599CE4C-F1E1-4AA1-A546-F2667436BE59.png)

Both models have six threads (boss/workers: 1 boss + 5 workers; pipeline: 6 stage threads) and both process an order of 11 toys. In the boss/workers model, a worker takes 120ms to process one toy order. In the pipeline model, each of the six pipeline stages takes 20ms, so one order still takes 120ms to travel the whole pipeline.

Regarding execution time, the boss/workers model took 360ms to complete 11 toy orders with 6 threads, while the pipeline model took 320ms with the same constraints.  From the perspective of total execution time, the pipeline model performs better than the boss/workers model.

What about average time to complete an order?

For the boss/workers problem, the first five orders took 120ms to complete. The second five orders had to wait 120ms and then took 120ms to complete. The final order had to wait 240ms and then took 120ms to complete. Thus the average time per order was

```ruby
total_orders = 11
total_time = (120 * 5) + (2 * 120 * 5) + (3 * 120)

average_time_per_order =  total_time / total_orders
# average_time_per_order approx 196ms
```

For the pipeline model, the first order took 120ms to complete. The second order waited 20ms for the first order to leave the first stage, and then took 120ms to complete. The third order waited 20ms on the first order, and 20ms on the second order, and then took 120ms to complete. Thus, the average time per order is

```ruby
total_orders = 11
total_time = (1..total_orders).reduce(0) do |sum, order|
	 sum += 120  + (20 * (order - 1))
end

average_time_per_order =  total_time / total_orders
# average_time_per_order == 220ms
```

If execution time is important, pick the pipeline model. Rather, if we care about the average time to complete the order, the boss/workers model is better: 196ms against 220ms, for the same workload and the same number of threads.

Change the number of workers or the number of orders and you may draw the opposite conclusion. The toy shop manager wants to complete as many orders as possible in a fixed amount of time, so he picks the pipeline model. The customers of the toy shop prefer the boss/workers model, because their individual orders come back sooner.

It's usually not possible to decree that one model is better than the other. Performance of a model is relative to the metric being measured, and different metrics may be important in different contexts.

## Are Threads Useful?
Threads are useful for a few reasons. They allow us to have speed up because we can parallelize problems. We get to benefit from a hot cache because we can specialize what a particular thread is doing. Using threads leads to implementations that have lower memory requirements and are cheaper to synchronize than implementations that are multiprocess. Threads are useful even on a single CPU because they allow us to hide latency of I/O operations.

What *is* useful?

For a matrix multiply application, we may care about the raw *execution time* of the application. For a web server application, we might care about the *throughput* of the application (number of requests/time) or we might care about the *response time*. For a hardware chip, we might care about the overall *utilization* increase of the hardware.

For any of these metrics, we might care about the average value, or the max/min value, or maybe even the value at a certain percentage. For example, we may consider that an application that completes a task in 3ms 95% of the time to be sufficient. A request rate or response time that is where we want it 95% or 99% of the time may be good enough, despite a few outliers. Because those outliers can behave very differently from the rest, an evaluation based on averages may look very different from one based on 95th percentile values.

To evaluate some solution, and determine whether it is useful or not, it is important to determine the properties that we really care about. We call such properties **metrics**.

## Visual Metaphor
Metrics exist in a toy shop just as they do in an operating system:
* **throughput**: the toy shop manager wants as many orders completed as possible; the OS cares how many processes complete over a period of time on a platform
* **response time**: the manager cares how long it takes, on average, to react to a new order; for the OS, when we click the mouse, does something happen immediately or do we wait a noticeable amount of time
* **utilization**: the manager cares what percentage of the workbenches is used over a period of time; for the OS, does the design use the CPU, devices and memory well, or does it leave a lot of resources unused

Metrics exist in any type of system, and they need to be well defined to analyze how a system behaves and how it compares to other solutions.

## Performance Metrics
A metric is a measurable or quantifiable property of a system that we are interested in that can be used to evaluate the system's behavior. For example, a metric can be the execution time (measurable property) of a software implementation to a problem (component of system we are interested in) which can be used to see if the implementation being analyzed is more performant than other implementations (system behavior evaluation). To make such comparisons, we should explore the metric over a range of meaningful parameters, for example by varying the workload or the resources allocated to the implementation.

So far, we have discussed many useful metrics, such as:

- execution time
- throughput
- response time
- CPU utilization

There are many more.

For example, in some systems we may not care so much when we get an answer, but rather when our job will start executing. This is known as **wait time**. Often, we would like for the value of this metric to be low. We would like to wait as little as possible for our jobs to start executing. This matters for interactive jobs, since the user can start interacting sooner, and for long-running jobs, since the user can find out sooner that something is going wrong, stop the job, reconfigure it and launch it again.

Throughput helps us evaluate the utility of a platform; that is, how many tasks will the platform complete in a given unit of time. This can be evaluated in the context of a single server or as complex a system as an entire datacenter.

If I own the data center, throughput may not be the metric that I am exclusively interested in. I might also be interested in **platform efficiency**, which measures how well resources are utilized in order to deliver a certain measure of throughput. This matters because I make money as a result of high throughput (completing work quickly), but I also spend money to maintain my platform. A higher measure of platform efficiency means I have to spend less on my platform.

If I really just care about money, I can look at **performance per dollar**. If I want to know if I should buy the next greatest hardware platform, I should examine whether that cost that I incur in doing so will be offset by a boost in performance per dollar.

Many times, I am more concerned about energy requirements. I might look at **performance per watt**, or **performance per joule** if I care about the energy consumed over an execution, when making decisions about new pieces of hardware. If my energy costs are high, maybe the right purchase is a machine that is more energy efficient.

Enterprise applications typically give their customers a **Service Level Agreement (SLA)**, for example a response within three seconds, or (for a service like Expedia, whose customers are airlines such as Delta and American) the most accurate quote for 95% of the flights returned. The **percentage of SLA violations** captures how many requests took longer than promised or returned quotes that were not accurate.

Some metrics are not super useful to maximize. For example, "smooth" video requires at least 30fps, since humans can't perceive more than 30fps. It doesn't make sense to maximize the fps, but rather the goal should be to make sure there are at least 30fps. In this case **client-perceived performance** is the goal, not raw performance.

You may be interested in just one metric before making decisions, or you may need to aggregate metrics or even derive new metrics in order to accurately understand the system that you are evaluating. An aggregate metric might average the execution time or the wait time over all tasks, and it might weight that average by the priorities of the tasks.

The CPU is also not the only resource we care about. Metrics that capture average usage of memory, of the file system, or of the storage subsystem are useful too.

In summary, a metric is some measurable quantity we can use to reason about the behavior of a system.

Ideally, we will obtain these measurements running real software on real machines with real workloads. Often, this is not feasible for many different reasons. In these cases, we may have to settle on "toy" experiments that are *representative* of realistic situations that we may encounter. The workloads should have similar access patterns to the real ones, and the machines should be of a similar type. We may also supplement the toy experiment with simulation, which lets us mimic a system larger than the one we can actually build.

We refer to these experimental settings as a **testbed**. The testbed tells us where/how the experiments were carried out and what were the relevant metrics being gathered.

## Really … Are Threads Useful?
There isn't really a straightforward answer to this question or the more general question of "Is X Useful?". The answer depends on which metrics we have gathered, as well as the workload on the system. For different combinations of these two variables, we may arrive at very different conclusions.

For example, in the toy shop, which of boss/workers and pipeline was better depended on the number of toy orders. Some shortest path algorithms work best on sparsely connected graphs, while others work best on densely connected graphs. Some filesystems are better for predominantly read accesses, while others are better for a mixed workload where files are both read and updated.

The answer is: it depends. This is pretty much always the correct answer to a question in systems, but it is never an accepted one, including in this course. The rest of the lecture looks at when threads are more or less useful compared to alternative implementations, and at how to define useful metrics and structure experiments to measure them.

## Multi Process vs. Multi Threaded
An application can be implemented in a multithreaded way, which we have talked about at length. An application can also be implemented in a multiprocess way. Both strategies can be used to provide concurrency.

We will compare the multithreaded approach and the multiprocess approach in the context of a web server, which may like to utilize concurrency in order to more efficiently process client requests.

Steps in a web server response flow

![](https://assets.omscs.io/notes/7777BD83-5AB4-4724-8FCC-03ACC3E80EFD.png)

Some of these steps are more computationally expensive, so most of the work will be done by the CPU. The request parsing step and header creation steps are good examples of this.

Other steps require interaction with the network, like accepting a connection, reading the request, and sending the data.

Still other steps require interaction with disk, such as finding and reading the file.

These network and disk steps may block, but whether they do depends on the state of the system at that moment. The connection may already be pending, or the file data may already be cached in memory from a previous request, in which case no device is involved and the step completes much more quickly.

## Multi Process Web Server
One easy way to achieve concurrency is to have multiple instances of the same process.

![](https://assets.omscs.io/notes/C5DA1B45-4114-437C-A96F-94AB7645F449.png)

The benefits of this approach is that it is simple. Once we have correctly developed the application, we can just spawn multiple processes and run it in each process.

The downside of running multiple processes in a platform is that there is a higher memory footprint, which can hurt performance. In addition, we have to pay the high cost of a context switch whenever we want to run a different process. As well as, it can be hard/costly to maintain shared state across processes due to IPC constraints. Finally, it may be difficult to have multiple processes listening on a specific port.

## Multi Threaded Web Server
Instead of taking a multiprocess approach, we can opt for a multithreaded approach, achieving concurrency within a single address space.

![](https://assets.omscs.io/notes/E9D12EF3-81CA-44E9-A248-4852A709C45D.png)

In this diagram, every thread is performing all of the steps. Of course, we could have a boss/workers setup where the boss performs the accept connection operation and the workers perform the remaining steps, from reading the HTTP request to sending the file. We could also have a pipeline setup, in which multiple threads execute one step and one step only.

The benefits of this approach are that we have a shared address space, shared state, and a cheap user level context switch. Since the state is shared, threads don't need to make system calls to coordinate with each other; processes do. Memory requirements are lighter, since we have a lot of shared information across all threads in the process.

The downside of this approach is that it is not a simple implementation. Multithreaded programs require explicit application level synchronization code, which can add to the overall complexity of the application. In addition, a multithreaded approach depends on underlying operating system level support for threads, although this is less of an issue now than it was in the past.

## Event-Driven Model
An event driven application is implemented in a single address space, with a single thread of control. The main part of the process is an **event dispatcher** which in a loop looks for incoming events and then based on those events invokes one or more of the registered handlers.

![](https://assets.omscs.io/notes/8070F398-66E2-46AB-9C66-DF1727B257C1.png)

Events (in the case of a web server application)  can correspond to:

- receipt of request
- completion of send
- completion of a disk read

The event dispatcher has the ability to accept any of these types of notifications and based on the notification type invoke the right handler. The dispatcher operates like a state machine. Since we are talking about a single threaded process, invoking a handler is just calling a function, so we just jump our execution to that instruction within the process's address space.

For example, a pending connection request on the server's port goes to the accept connection handler, and a message on an established connection goes to the read request handler. Once the filename is extracted and the file is found, the file is sent in chunks, iterating over the send handler as each chunk completes; if the file is not there, an error message is sent to the client.

The handlers run to completion. If the handler needs to block (by making an I/O request for instance), the handler will initiate the blocking operation and immediately pass control back to the dispatch loop.

## Concurrency In The Event-Driven Model
In the multiprocess and multithreaded implementation, one request is handled at a time per execution context. Since we have multiple execution contexts, we can achieve concurrency.

In the event driven model, the processing of multiple requests are interleaved within a single execution context.

Let's say client C1's connection is accepted and its request is parsed, and the read file handler initiates disk I/O, so C1 waits on the disk. In the meantime, C2 and C3 send connection requests. C2's connection is accepted and it now waits for the HTTP message from the network; C3 is currently in the accept connection handler. Some time later, C3 waits on its HTTP message, C2 waits on disk I/O to read its file, and C1 is sending its file in chunks, waiting between chunks.

Even though we are within one thread of execution, we are still able to concurrently process multiple client requests; their processing is just interleaved.

## Event-Driven Model: Why?
What is the benefit of having a execution context processing multiple requests?

On a single CPU, threads can be useful because they hide latency. If the amount of time a thread will spend idle is greater than the time it takes to context switch twice, it makes sense to context switch and let some other thread do some work.

If there really isn't any idle time, context switching just wastes cycles that could have been used for request processing.

In the event driven model, a request will be processed exactly until a wait is necessary, at which point the execution context will switch to servicing another request.

If we have multiple CPUs, the event driven model still makes sense, especially when we have to service more concurrent requests than we have CPUs. Each CPU could host a single event-driven process, and multiple requests could be worked on concurrently within that process. This can be done with less overhead than if each CPU had to context switch among multiple processes or multiple threads.

Gotcha: It is important to have mechanisms that will steer the right set of events to the right CPU.

## Event-Driven Model: How?
At the lowest level, we need to be receiving some events from the hardware, be it the network or the disk or some other hardware component. The operating system uses sockets as an abstraction over the network, and files as an abstraction over the disk.

Both sockets and files are represented by **file descriptors**. An event in the context of the web server is an input on any of the file descriptors associated with it.

To determine which file descriptor has input, we can use the `select` system call. This call takes a range of file descriptors and returns the first descriptor that has some input on it. Another alternative is the `poll` system call.  

Both of these system calls have to scan through a potentially large list of file descriptors until they find one with input, and it is likely that only very few in that list have input, so much of the search time is wasted.

A more recent system call, supported for instance by Linux, is `epoll`. This eliminates some of the problems that `select` and `poll` have, namely with scanning large lists of mostly useless file descriptors. Many high performance servers that need high data rates and low latency use it today.

The benefits of the event driven model mainly come from the design as a single address space with a single flow of control. As a result, the overheads are lower. There is a smaller memory footprint, and no need for context switching or synchronization. The programming is simpler too, since we don't have to reason about synchronization primitives or shared access to variables.

**NB**: Jumping among handlers for different connections hurts locality and pollutes the cache, but these effects are far smaller than the cost of a full context switch.

## Helper Threads And Processes
When we talked about the many-to-one user level thread to kernel level thread model, we saw that a user level thread that blocks will block the entire process.  

A similar problem can occur in the event driven model. If one of the handlers initiates a blocking call, the entire process can be blocked.

One way to circumvent this issue is to use **asynchronous I/O operations**. When an asynchronous system call is made, the kernel captures enough information about the caller and about where and how the data should be returned once it becomes available. Asynchronous calls let the process or thread continue execution now and check their results later.

One thing that makes asynchronous calls possible is a multithreaded kernel. While the caller thread continues execution, another kernel thread must do all the waiting that is needed to get the I/O results. Asynchronous operations can also benefit from the hardware devices. For example, a thread can pass a request over to a device and the device can let the calling thread know at a later time the results of its request.

The takeaway is that when we perform asynchronous I/O operations, our thread will not be blocked in the kernel while the I/O operation actually takes place.

Asynchronous I/O operations fit nicely with the event-driven model: the completion events can be caught with the same `select`, `poll` or `epoll` mechanism.

Asynchronous I/O calls are not available on all platforms or for all types of devices. When these calls are not available, we need **helpers**. For example, the server may need to call into an accelerator device that only it has access to.

When the handler needs to initiate an I/O operation that can block, the handler passes the call to the operation to a helper, and returns to the event dispatcher. The helper will be the one that handles the blocking I/O operation and interact with the dispatcher as necessary.

The communication with the helper can be with sockets or pipes, which both present a file descriptor like interface, which means that `select` and `poll` still work.

In doing this, the synchronous I/O call is handled by the helper. The helper will block, but the main event loop will not! Although we don't have asynchronous system calls, we can fake it to an extent by delegating blocking calls to processes.

![](https://assets.omscs.io/notes/007D0E12-DC9B-4787-91A9-FCEA8EB25A4F.png)

If the kernel is not multithreaded - it wasn't back in the day - the helpers need to be processes. The model was called the **Asymmetric Multi-Process Event-Driven Model** or AMPED. The multithreaded equivalent acronym is AMTED.

The processes are asymmetric: the helpers only deal with blocking I/O operations, and the main process performs everything else. A follow-on to the Flash work implements AMTED.

The key benefits of this model are that  it resolves some of the portability issues of the basic event-driven model. That is, it fakes asynchronous I/O operations instead of relying on native support for them, and it does not depend on kernel threading support.

In addition, this model allows us to have a smaller footprint than a pure multiprocess or multithreaded model. Since a thread or a process in the pure multiprocess/threaded model needs to perform all of the steps for processing the request, the memory footprint will be higher than that of a helper that just needs to do a very isolated task.

In AMPED we only need a helper for each concurrent blocking I/O operation. In the multiprocess or multithreaded models we need an entity for every concurrent request, whether or not that request ever blocks.

One downside is that while this model works well for server-type applications, it is not necessarily applicable to arbitrary applications. Another downside is that there are some complexities surrounding event routing on multi CPU systems.

<details>
<summary>Models and memory quiz spoiler</summary>

Of the boss/workers, pipeline and event-driven models, which likely requires the least amount of memory, and why?

The event-driven model. Its handlers are just procedures in the one address space, and extra memory is needed only for the helpers associated with concurrent blocking I/O calls. The boss/workers model needs a thread for every concurrent request, and the pipeline model needs multiple threads per stage once the level of concurrency exceeds the number of pipeline stages.
</details>

## Flash Web Server
Flash is an event-driven web server that follows the AMPED model, which means it has asymmetric helper processes to help with blocking I/O operations.

Since this is Web 1.0 technology, where the server just returns static files, the blocking I/O operations are basically just disk reads.

The communication from the helpers to the event dispatcher is performed via pipes. The helper reads the file in memory via `mmap` and then the dispatcher checks via `mincore` to see if the pages are in memory, and uses this information to determine if it should call a local handler or a helper. As long as the file is in memory, reading it will not result in the blocking I/O operation, which means that the local handler can be used. The check is extra work before every file read, but it results in big savings because it prevents the whole process from blocking when a blocking I/O operation turns out to be necessary.

> **Paper (Pai et al.):** The residency check comes first: the main process tests mapped file pages with `mincore()` before use (Secs. 5.4, 5.7). Only if the pages are not resident does it dispatch a helper; both the main process and the helper `mmap` the file, the helper touches every page, then notifies the main process via IPC that the file can be sent without blocking (Sec. 3.4). Stanford and MIT course notes describe the same check-first order.

Flash performs application level caching at multiple levels.

![](https://assets.omscs.io/notes/F11D499F-689F-4FC6-9357-06AA8772587E.png)

It does this on both data and computation. It is common to cache files: this is data caching. Computation can also be cached. For instance, every request has an associated pathname, and we need to look up the file given the pathname. That lookup will compute some result, which we can cache so we do not have to perform the same computation again.

Similarly, the fields in the HTTP header are often file dependent. So long as the file doesn't change, the headers don't need to change. Thus we can cache the response header so long as we can tell that the file hasn't changed. Again, we don't need to perform an unnecessary computation.

Flash also makes some optimizations that take advantage of the networking hardware and the network interface card. Data structures are aligned so that DMA operations can be performed without copying data, and DMA with scatter-gather support means the header and the file data do not have to be next to each other in memory; they can be sent from different locations, avoiding a copy. These optimizations are fairly common now, but were novel when the paper was written, and some of the systems compared against did not include them.

> **Paper (Pai et al.):** The paper frames this as byte position alignment, not a network hardware feature (Sec. 5.5). When `writev()` sends a response header followed by file data, the OS copies the regions into a contiguous kernel buffer, and a header whose length is not a multiple of the word size misaligns every subsequent copy. Flash pads response headers to multiples of 32 bytes to target systems with 32-byte cache lines; the section does not mention DMA. Princeton and Stanford notes describe it the same way.

## Apache Web Server
The core component of the apache web server provides the core server functionality. This includes accepting connections and managing concurrency. The various modules are mounted in a pipeline and extend the functionality of the basic server behavior. A specific apache deployment may contain one or more modules; modules can provide, for example, security features, management of dynamic content, or basic HTTP request processing.

The flow of control is similar to the event driven model in that each request passes through all the modules, similar to how the request passed through all the handlers.

Apache is a combination of a multiprocess and multithreaded model. In apache, each instance is a process, which implements a multithreaded boss/workers configuration with a dynamic thread pool, grown or shrunk according to configurable thresholds. The total number of processes can also be adjusted dynamically, based on factors such as the number of outstanding connections, the number of pending requests and CPU usage.

![](https://assets.omscs.io/notes/FFDE7A00-458B-4F77-AA6D-690930FEE146.png)

## Experimental Methodology
The experiments outlined in the flash paper are designed such that the results can help the authors of their paper back up the claims they made about flash.

To achieve a good experimental design you need to answer a few questions.

What systems are you comparing? Are you comparing two software implementations? If so, keep the hardware the same. Are you comparing two hardware platforms? Make sure the software is consistent.

What workloads will you use? What are the inputs on the system? Will you be able to use data that may be expected/gathered from the real world, or will dummy data be used?

Finally, how will you measure performance? Will you look at execution time, throughput or something else? Who are you designing the system for: the manager, resource usage, or the customers?

### What systems are you comparing?

The authors compared their implementation against

- a multiprocess, single threaded implementation
- a multithreaded implementation using the boss/workers pattern
- a single process event-driven (SPED) implementation
- Zeus (SPED implementation with two processes)
- Apache (multiprocess at the time)

Zeus used the second process to deal with blocking I/O. Every one of these implementations except Apache included the optimizations that Flash introduced, so the comparison is really between the models (multiprocess, multithreaded, SPED) and AMPED, over otherwise identical code.

> **Paper (Pai et al.):** In the MT architecture each thread performs all the steps of one HTTP request before accepting a new one, analogous to a process in MP (Sec. 3.2, Fig. 3); Flash-MT uses 64 threads and no boss thread is described (Sec. 6). Princeton and MIT notes likewise describe per-request threads.

> **Paper (Pai et al.):** Zeus v1.30 is a SPED server that was run as a single process for the synthetic-workload experiments and in a vendor-advised two-process configuration for the real-trace tests (Sec. 6). The paper notes that the two-process setup gives Zeus a slight advantage over single-process Flash-SPED in the trace tests, since one process can keep serving requests while the other is blocked on disk I/O (Sec. 6.2).

### What workloads will be used?

They wanted workloads that represented a realistic sequence of requests, because that is what will capture a distribution of web page accesses, but they wanted to be able to reproduce the experiment with the same pattern of accesses. To accomplish this, they gathered traces from real web servers, and replayed those traces to their systems.

They used two real-world traces, both gathered at Rice University. The first trace was the CS WebServer trace, which represents the Rice University web server for the computer science department, which includes a large number of files and doesn't really fit in memory. The second trace was the Owlnet trace, which was from a web server that hosted a number of student run websites and it was much smaller so it would typically fit in the memory of a common server.

In addition to these real traces, they also used a synthetic workload generator. Instead of replaying a real distribution of page accesses, the generator let them run best case and worst case analysis, and ask "what if" questions about access patterns they had not observed.

### How will you measure performance?

A common metric to measure web servers - that was used in this paper - is **bandwidth**. Bandwidth measures the total number of bytes transferred divided by the total amount of time it takes to transfer those bytes.

Second, because the authors were concerned with Flash's ability to perform concurrent processing, they wanted to see the impact of **connection rate** as a metric. This is defined as the total number of client connections serviced divided by the total amount of time that passed.

Both of these metrics were evaluated as a function of file size. The intuition is that with a larger file size, the connection cost can be amortized, resulting in higher bandwidth. On the other hand, with a larger file size, there is more work to do per connection, so it's expected that there will be a lower connection rate.

## Experimental Results
Let's look at the experimental results.

### Best Case Numbers
For the best case, the authors used the synthetic load. They varied the number of requests that were made, but made sure each request asked for the exact same file. The is the best case because once the file is requested once, it can be cached which means that subsequent requests for the file will be answered much more quickly.

For the best case experiment, they vary the file size from 0 to 200kb, and they measure the bandwidth which is the number of requests times the file size divided by the total time. By varying the file size, they vary the amount of work that the server has to do on a given request.  

![](https://assets.omscs.io/notes/EBC45431-74FC-4D6D-A91E-5E4D368BCB22.png)

All of the implementations had similar results, with bandwidth increasing sharply with file size initially before plateauing.

SPED has the best performance: it has no threads or processes to context switch among. Flash is similar in performance, but it performs the extra check for memory presence. Since every request is for the same single file, no helper is ever invoked here, and the check buys Flash nothing. Zeus has an anomaly: its performance drops a little at larger file sizes (around 125KB in the graph). That drop comes from a misalignment in some of its DMA operations; not all of Zeus's optimizations are bug free. The performance of the multithreaded/multiprocess implementations are lower because of the extra synchronization requirements and the cost of context switching. Apache has the lowest performance because it has no optimizations.

> **Paper (Pai et al.):** The paper discusses a Zeus anomaly only on FreeBSD, for file sizes between 10 and 100 KB, and attributes it to the `writev` byte alignment problem of Sec. 5.5 (Sec. 6.1; Fig. 7 caption), a kernel copy alignment issue rather than the DMA misalignment the lecture gives. The Solaris single-file graph (Fig. 6), which the lecture shows, is not discussed in terms of a Zeus anomaly, so the ~125 KB figure is a reading of that graph rather than the paper's stated result.

> **Paper (Pai et al.):** The paper attributes the slight lag of Flash-MT and Flash-MP on this test to "extra kernel overhead (context switching, etc.)" and does not mention synchronization (Sec. 6.1). MP processes have private address spaces and need no user-level synchronization between requests (Sec. 3.1), while MT does need it for shared data (Sec. 3.2), so synchronization is an MT cost only.

### Owlnet Trace

![](https://assets.omscs.io/notes/9FA2F6D6-44DC-4BA7-9EF6-FB4D43849B0A.png)

 For the Owlnet trace, the results are mostly similar to the best case. We can see that Flash and SPED are the best, followed by MT/MP and then Apache. The reason for this trend is because the owl trace is very small, so most of the requests can be serviced from the cache. However, not everything can be serviced from cache, so sometimes blocking I/O is required. In this case, SPED will block, but Flash will not because it has helpers. This helps explain why Flash's performance is slightly higher than the SPED implementation.

**NB**: Zeus is not included in this graph.

### CS Trace

![](https://assets.omscs.io/notes/7FAD964F-52B7-4742-BA6D-07615FBCFE00.png)

The CS trace is a much larger trace, which means that most requests are not serviced from the cache. Since the system does not support asynchronous I/O the performance of SPED drops significantly. SPED goes from performing right next to Flash to performing *below* both the multiprocess and the multithreaded implementations. The multithreaded implementation does better than the multiprocess implementation because it has a smaller memory footprint (more memory available to cache files) and is able to synchronize more quickly/cheaply.

Flash performs the best. It has a smaller memory footprint than the multithreaded and multiprocess implementations, which means it has more memory available for caching files and headers. As a result, fewer requests will require blocking I/O requests, which further speeds everything up. In addition, since everything occurs in the same address space, there is no need for explicit synchronization.

### Impact of Optimizations

![](https://assets.omscs.io/notes/2A9A866D-FC1C-49C3-B91B-54E20004E4AA.png)

The four curves are Flash with no optimizations, Flash caching only the pathname lookup, Flash caching the pathname lookup and the file itself via `mmap`, and Flash with all optimizations, which adds the cached header computation.

We can see that in all cases, connection rate decreases with file size. That being said, connection rate increases as the number of optimizations increase, with the fully optimized flash having the highest connection rate at a given file size. Optimizations are important.

Apache performed worst in both trace experiments, and it is the one implementation that did not integrate these optimizations. It would have done better with them.

## Summary of Performance Results
When the data is in cache, SPED smokes AMPED Flash, since AMPED Flash makes an "unnecessary" test for memory presence on each request. Both SPED and AMPED Flash perform better than MT/MP models, because neither incurs any synchronization or context switching overhead.

> **Paper (Pai et al.):** Flash-SPED only "slightly outperforms" Flash on the single-file test because of the residency check (Sec. 6.1), and on cached trace workloads Flash is "very competitive" with Flash-SPED, with only a slight difference (Sec. 6.2, observations after Figs. 9 and 10). MIT, Stanford and Princeton notes likewise treat SPED and AMPED as roughly tied on cached data.

When the workload is disk-bound, AMPED Flash performs much better than SPED, which blocks on I/O request because it doesn't have asynchronous I/O. AMPED Flash performs better than MT/MP because the more efficient memory implementation leaves more memory available for caching, and because it doesn't require the same amount of context switching. Only the concurrent I/O bound requests turn into extra processes or threads in AMPED.

The event-driven model is not suitable for every kind of server process. We need to route events to the appropriate core on a multicore machine, and some kinds of processing just don't fit the architecture. Still, a lot of the high performance servers in use today are event-driven with asynchronous I/O support.

<details>
<summary>Performance observation quiz spoiler</summary>

In a graph from the Flash paper comparing SPED and Flash (AMPED), at about 100MB the performance of Flash becomes better than that of SPED. Why? Check all that apply:
* Flash can handle I/O operations without blocking
* At that particular time, SPED starts receiving more requests
* The workload becomes I/O bound
* Flash can cache more files

Correct: Flash can handle I/O operations without blocking, since it has helper processes; and the workload becomes I/O bound, since beyond about 100MB it no longer fits in the cache as well as before. Once the workload is I/O bound, a single blocking I/O operation blocks the entire SPED process, none of the other requests can make progress, and its performance drops significantly. Wrong: SPED does not start receiving more requests; both receive the same number of requests in these experiments. Wrong: Flash cannot cache more files, as explained below.

The memory advantage does not explain why Flash beats SPED. SPED and AMPED Flash have comparable memory footprints, so neither one can hold appreciably more files in its cache than the other. If anything, the helper processes that Flash spawns take memory away from the rest of the process, leaving Flash with less memory available for caching files than SPED has.
</details>

## Advice on Designing Experiments
Designing experiments takes more thought and planning than running test cases, gathering metrics and plotting results. A relevant experiment leads to statements about a solution that are credible, so others believe them, and relevant, so others care about them. The Flash paper is full of such experiments.

The clients using the web server care about the response time: how quickly they get a response. The operators of the web server care about throughput: how many client requests are served over a period of time.

The efficacy of a solution will depend on whose problem you are trying to solve. You will likely need to justify your solution within the context of the problems that your stakeholders are experiencing.

For example, a solution may improve response time and throughput, or it may improve response time while keeping throughput constant, or it may improve response time while degrading throughput. Any of these solutions may be viable, depending on the context. Improving response time while degrading throughput can still pay off, for example if the better response time lets the operator charge clients more. We may also want experiments that show how the response time clients see is affected as the load on the web server, the request rate, increases.

By understanding the stakeholders and the goals that these stakeholders are trying to meet, we can gain some insight into both the metrics and the configuration of our experiments.

When picking metrics, a good rule of thumb is to start by looking at metrics that are standard for the target domain. For instance, for web servers it is common to talk about the client request rate or the server response time. This allows you to have a broader audience who can understand and interpret your results, and should be included even if they do not give the best punchline.

In addition, you need metrics that answer the who/what/why questions. Why are you doing this work? Whose problems are you trying to solve? For client performance, track response time or the number of timed-out requests; for operator costs, track throughput or power costs.

Once you understand the metrics you will be analyzing, it's important to understand system factors that affect those metrics.

For example, system resources can greatly affect metrics. Systems with different CPUs and memory configurations, running different software will often have wildly different results. Software resources count here too: the number of threads, the size of the queues, the buffer structures inside the program.

It's important to also consider the workload configuration. For a web server,  we can vary the request rate, the number of concurrent requests, the file size, the access pattern and many more. The request rate, the file size and the access pattern were all varied in the Flash experiments.

Once you have more insight into the configuration space available to your experiment, you need to actually pick some subset of features, the configuration parameters most likely to affect the metrics. It may be the case that the best approach involves variable ranges for some of the configuration parameters. Try to make these ranges realistic. Don't use 1, 2 or 3 threads when real world setups use hundreds of threads. Likewise, vary file sizes over what the real world sees, from tens of bytes to hundreds of megabytes and beyond.

It is possible to engineer configurations such that you can provide best/worst analysis about the system that you are analyzing. In this case, it may be okay to have configurations that, while not common, are still possible. The single-file experiment in the flash paper is one of these, and it was still informative.

Pick useful combinations of the factors you vary. A few experiments confirming the same observation are good. Tens of them are pointless.

Compare apples to apples. Put another way, only vary one parameter at a time. Don't run a large workload with few resources and then a small workload with more resources (say, more threads); if the second run is faster, you cannot tell whether the resources or the workload made the difference.

What is the baseline performance of the system you are improving? You want to be able to show that your experiment somehow improves the state of the art or at least improves the most common configuration/workflow. Failing that, compare against extreme workloads or resource assignments; that at least tells you how your solution scales.

## Advice on Running Experiments
Here is the easy part:

- Run test cases N times
- Compute metrics, averaged over the N runs
- Represent results

A good visual representation of the results strengthens your argument.

Make sure to not just show results. Draw a conclusion! Spell out what the results say about the hypothesis or the claim that you are presenting.

<details>
<summary>Experimental design quiz spoiler</summary>

A toy shop manager wants to know how many workers to hire to handle the worst case of incoming orders. Orders range in difficulty from blocks (simplest) to teddy bears to trains (most complex). The shop has 3 separate working areas, each with the tools for any kind of toy, and multiple workers can share an area. Which of these experiments lets us draw meaningful conclusions about the manager's question?

| Configuration | Trial 1 | Trial 2 | Trial 3 |
| --- | --- | --- | --- |
| 1 | trains, 3 workers | trains, 4 workers | trains, 5 workers |
| 2 | blocks, 3 workers | bears, 6 workers | trains, 9 workers |
| 3 | mixed, 3 workers | mixed, 6 workers | mixed, 9 workers |
| 4 | trains, 3 workers | trains, 6 workers | trains, 9 workers |

Configuration 4. It uses the worst case (only trains) in every trial and adds an even number of workers per working area. Configuration 2 changes the toy type between trials, so it says nothing about worst-case capacity. Configuration 3 could tell us how average throughput on a mixed workload responds to more workers, but that is not the manager's question.

Realism is not the only constraint on the values you vary. The values also need to divide evenly across whatever fixed resources they will be spread over, otherwise trials that look like a clean progression are not comparable. Consider a toy shop with three working areas that the workers share, where the manager wants to know how many workers to hire. Trials of 3, 4 and 5 workers give one worker per area, then one area with two workers and two areas with one, then two areas with two workers and one area with one. The amount of resource available per area is not equal across the trials, so the differences between them say nothing about the capacity of the system. Trials of 3, 6 and 9 workers add the same number of workers to every working area, and the resulting numbers do say something about how capacity responds to more workers.

It is also worth pushing the range past the point where the gains stop. If the toy shop tries twelve workers, four per working area, at some point it will likely stop seeing any improvement, simply because it cannot squeeze in more workers per working area. Where the curve flattens is likely to show the capacity of the individual working area.
</details>
