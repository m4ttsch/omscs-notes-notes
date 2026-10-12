---
id: operating-systems-scheduling
title: Scheduling
course: operating-systems
lecture: scheduling
---

# Scheduling

**Reference paper**: [Chip Multithreading Systems Need a New Operating System Scheduler](https://s3.amazonaws.com/content.udacity-data.com/courses/ud923/references/ud923-fedorova-paper.pdf) - Fedorova et al.

**OSTEP chapters**:
* [7. Scheduling: Introduction](https://pages.cs.wisc.edu/~remzi/OSTEP/cpu-sched.pdf)
* [8. Scheduling: The Multi-Level Feedback Queue](https://pages.cs.wisc.edu/~remzi/OSTEP/cpu-sched-mlfq.pdf)
* [9. Scheduling: Proportional Share](https://pages.cs.wisc.edu/~remzi/OSTEP/cpu-sched-lottery.pdf)
* [10. Multiprocessor Scheduling (Advanced)](https://pages.cs.wisc.edu/~remzi/OSTEP/cpu-sched-multi.pdf)

## Visual Metaphor
A toy shop manager schedules work in the toy shop much like an OS scheduler schedules tasks onto CPUs. The manager has several options, each motivated by a different goal:

- dispatch orders immediately, as soon as they arrive (FIFO). This keeps scheduling overhead low, since the manager does not have to analyze each order.
- dispatch the simple orders first. This maximizes the total number of orders processed over a period of time, but the manager has to spend time assessing the complexity of each order.
- dispatch the complex orders first. This keeps all of the tools on the workbenches as busy as possible; workers can pause a complex order to squeeze in a simple one.

The OS scheduler has the same choices. **First come first serve** keeps the scheduler simple, with low overhead. Dispatching simple (short) tasks first, **shortest job first**, maximizes overall throughput. Dispatching complex tasks first aims to utilize all aspects of the platform well: the CPUs as well as devices, memory, and other resources.

## Scheduling Overview
The CPU scheduler decides how and when the processes (and their threads) access the shared CPUs.  The scheduler concerns the scheduling of both user level tasks and kernel level tasks.

The scheduler selects one of the tasks in the ready queue and then schedules it on the CPU. Tasks may become ready a number of different ways:

- after an I/O operation they have been waiting on has completed
- after they have been woken up from a wait on an interrupt or signal
- when they are created (for example, when a new thread is forked)
- after they have been interrupted while executing on the CPU (for example, because the CPU must be shared); such a task is still ready, so it goes straight back into the ready queue

![](https://assets.omscs.io/notes/0CD9CFF9-08C7-4678-B3AE-F3C8E25B5042.png)

Whenever the CPU becomes idle, we need to run the scheduler. For example, if a task makes an I/O request and is placed on the wait queue for that device, the scheduler has to select a new task from the ready queue to run on the CPU. The goal is to not keep the CPU idle for too long.

Whenever a new task becomes ready (a task that was waiting on I/O, an interrupt, or a signal, or a brand new task), we also need to run the scheduler. The goal is to check whether the new task is of higher importance and should therefore interrupt the task that is currently executing.

A common way that schedulers share time within the system is by giving each task some amount of time on the CPU. This is known as a timeslice. When a timeslice expires, the scheduler must be run.

Once the scheduler selects a task to be scheduled, that task is dispatched onto the CPU. The operating system context switches to the new task, enters user mode, sets the program counter, and execution begins.

In summary, the objective of the OS scheduler is to choose the next task to run from the ready queue.

How do we decide which task to be selected? This depends on the scheduling policy/algorithm. How does the scheduler accomplish its job? This depends very much on the structure of ready queue, also known as a **runqueue**. The decision of the runqueue and the scheduling algorithm are tightly coupled: a data structure that is optimized for one algorithm may be a poor choice for implementing another.

## Run To Completion Scheduling
**Run To Completion** scheduling assumes that once a task is assigned to a CPU, it will run on that CPU until it is finished.

For the purposes of discussion, it's necessary to make some assumptions. First, we can assume that we have a group of tasks that need to be scheduled. Second, we can assume that we know the execution times of the tasks. Third, we can assume that there is no preemption in the system. Fourth, assume that there is a single CPU.

When it comes to comparing schedulers, some common metrics include:

- throughput
- average job completion time
- average job wait time
- CPU utilization

The first and the simplest algorithm is **First Come First Serve** (FCFS). In this algorithm, the tasks are simply scheduled in the order in which they arrive. When a task completes, the scheduler will pick the next task in order.

A simple way to organize these tasks would be a queue structure, in which the tasks can be enqueued to the back of the queue, and dequeued from the front of the queue by the scheduler in a FIFO manner. All the scheduler needs to know is the head of the queue, and how to dequeue tasks.

Let's look at a scenario with three threads: T1, T2, T3. T1 has a task that takes 1 second, T2 has a task that takes 10 seconds, and T3 has a task that takes 1 second. Let's assume that T1 arrives before T2, which arrives before
T3.

For this example, the throughput is 3 tasks over 12 seconds, or 0.25 tasks per second. The average completion time is (1 second + 11 seconds + 12 seconds) / 3, or 8 seconds. The average wait time is (0 seconds + 1 second + 11 seconds) / 3, or 4 seconds. FCFS is simple, but its wait time is poor even if there is just one long task ahead of some shorter tasks.

We can improve our metrics by changing our algorithm. Instead of FCFS we can try **shortest job first** (SJF), which schedules jobs in order of their execution time. Ties are broken arbitrarily.

With this algorithm, it doesn't really make sense for the runqueue to be a FIFO queue any more. We need to find the shortest task in the queue, so we may need to change our queue to be an ordered queue. This makes the enqueue step more laborious. Alternatively, we can use a tree structure, ordered by execution time, to maintain the runqueue. Inserting a new task may require rebalancing the tree, but selection is easy: the scheduler always picks the leftmost node, which has the smallest execution time. The runqueue doesn't have to be a queue.

### SJF Performance Quiz
Assume SJF schedules the same three tasks as above: T1 and T3 take 1 second, T2 takes 10 seconds, there is no preemption, the execution times are known, and all three tasks are in the system at time 0. Compute the throughput, average completion time, and average wait time.

The execution order is T1, T3 (or T3, T1), then T2.

- Throughput: 3 tasks in 12 seconds, or 0.25 tasks per second. Nothing changes compared to FCFS.
- Average completion time: (1 + 2 + 12) / 3 = 5 seconds, compared to 8 seconds for FCFS.
- Average wait time: (0 + 1 + 2) / 3 = 1 second, compared to 4 seconds for FCFS.

## Preemptive Scheduling: SJF + Preempt
Let's remove the assumption that a task cannot be interrupted once its execution has started. Let's also relax the assumption that tasks must all arrive at the same time.

![](https://assets.omscs.io/notes/302527F5-EA2F-4DD0-9E07-F38CA209E204.png)

When T2 arrives, it is the only task in the system, so the scheduler will schedule it. When T1 and T3 arrive, T2 should be preempted, in line with our SJF policy. The execution of the rest of the scenario is as follows.

![](https://assets.omscs.io/notes/0EC22063-46A4-47EF-B109-571A03494F41.png)

Whenever tasks enter the runqueue, the scheduler needs to be invoked so that it can inspect the new task's execution time, and make a decision as to whether it should preempt the currently executing task.

We are still holding our assumption that we know the execution time of the task. In reality, this is not really a fair assumption, as the execution time depends on many different things that may be out of our perception, such as the task's inputs, whether its data is present in the cache, and which other tasks are running. We can generate heuristics about running time based on execution times that have been recorded for past runs of the same task. We can think about how long a task took to run the very last time or the average execution time over the past n times (a **windowed average**).

## Preemptive Scheduling: Priority
Instead of looking at execution time when making scheduling decisions, as we do in SJF, we can look at task priority levels. It is common for different tasks to have different priorities. For example, it is common that kernel level tasks that manage critical system components will have higher priority than tasks that support user applications. Even within a user-level process, threads that run when there is user input may have higher priority than threads doing background processing for a long running simulation.

When scheduling based on priority, the scheduler must run the highest priority task next. As a precondition of this policy, the scheduler must be able to preempt lower priority tasks when a high priority task enters the runqueue.

![](https://assets.omscs.io/notes/55C02A40-B081-416F-826E-19749053B0C8.png)

We start with the execution of T2, as it is the only thread in the system. Once T3 and T1 are ready, T2 is preempted. T3 is scheduled as it has the highest priority, and it runs to completion. T2 is scheduled again - as it has higher priority than T1 - and runs to completion. Finally, T1 is scheduled and runs to completion. T1 does not start running until the 11th second and completes at time 12.

![](https://assets.omscs.io/notes/9FF251EC-C80C-4184-91CE-11DC71A15A45.png)

Our scheduler now not only needs to know which tasks are runnable, but also each task's priority. An effective way to be able to quickly tell a task's priority is to maintain a separate runqueue for each priority level. As a result, the scheduler can just empty queues by priority level. Alternatively, the runqueue can be an ordered data structure, like the tree used for SJF, but ordered by task priority.

![](https://assets.omscs.io/notes/B9E26ED4-074D-4A16-A0C4-8EBB6AB9966D.png)

 One dangerous situation that can occur with priority scheduling is **starvation**, in which a low priority tasks is essentially never scheduled because higher priority tasks continually enter the system and take precedence.

One mechanism to protect against starvation is **priority aging**. In priority aging, the priority of a task is not just the numerical priority, but rather a function of the actual priority and the amount of time the task has spent in the runqueue. This way, older tasks are effectively promoted to higher priority to ensure that they are scheduled in a reasonable amount of time.

### Preemptive Scheduling Quiz
An OS scheduler uses a priority-based algorithm with preemption, with priorities P3 < P2 < P1. T3 arrives at time 0 and needs 4 seconds, T2 arrives at time 3 and needs 4 seconds, and T1 arrives at time 5 and needs 3 seconds. What are the finishing times of the three tasks?

T3 is the only task in the system, so it runs first. At time 3, T2 arrives and preempts T3. At time 5, T1 arrives, preempts T2, and runs for 3 seconds, finishing at 8. T2 then needs 2 more seconds and finishes at 10. Finally T3 runs its remaining 1 second and finishes at 11.

The finishing times are T1 = 8 seconds, T2 = 10 seconds, T3 = 11 seconds.

## Priority Inversion
Consider the following setup assuming an SJF policy with priority, where P3 < P2 < P1.

![](https://assets.omscs.io/notes/975B4BFD-B8BD-46FC-BE7A-8E48B91F47E5.png)

Initially, T3 is the only task in the system, so it begins executing. Suppose it acquires a mutex. T2 now arrives, which has higher priority than T3, so T3 is preempted and T2 begins to execute. Now T1 arrives and preempts T2. Suppose T1 needs the lock that T3 holds. T1 gets put on the wait queue for the lock and T2 executes. T2 finishes and T3 executes. Once T3 unlocks the mutex, T1 becomes runnable again, preempts T3, acquires the lock, and continues executing.

![](https://assets.omscs.io/notes/E11CA11B-7FD7-435C-95CC-0A2E2CACFACE.png)

We see that we have a case of **priority inversion** here because T1 which has the highest priority is now waiting on T3 which has the lowest priority. The order of execution should have been T1, T2, T3, but instead was T2, T3, T1.

A solution to this problem would have been to temporarily boost the priority of the mutex owner. When T1 needs to acquire the lock owned by the T3, T3 should have its priority boosted to P1, so it would be scheduled on the CPU. Once T3 releases its mutex, T3 should have its priority dropped back to P3, so T1 can now execute, as T1 is the task with the actual highest priority.

We can now see why it is important to keep track of the current owner of the mutex in the mutex data structure.

## Round Robin Scheduling
When it comes to running jobs with the same priority there are alternatives to FCFS and SJF. A popular option is **round robin scheduling**. Consider the following scenario.

![](https://assets.omscs.io/notes/BD3715F2-BD12-4661-ACDB-2E74F02B6B38.png)

We have three tasks that all arrive at the same time and are all present in the runqueue. We first remove T1 from the queue and schedule it on the CPU, just like FCFS. Unlike FCFS, a task does not have to run until it completes. Suppose that after one time unit T1 has to wait on an I/O operation, so it yields the CPU and blocks. T2 is removed from the queue and scheduled, and T3 moves to the front of the queue. When T1's I/O completes, T1 is placed at the end of the queue, behind T3. When T2 completes, T3 is scheduled (it needs two time units). When T3 completes, T1 is finally picked up again and completes.

If T1 had not been waiting on I/O, the tasks would simply execute one by one in the order in which they were placed in the queue: T1, T2, T3.

![](https://assets.omscs.io/notes/62D89DA0-691E-4F48-9343-E437EB64C1B8.png)

We can generalize round robin to include priorities as well. Suppose T2 and T3 arrive a little later than T1, and T1's priority is the lowest and T3's the highest. When a higher priority task arrives, the lower priority task is preempted. If T2 and T3 have the same priority, the scheduler just goes round robin between them until they complete. To incorporate priorities we have to include preemption; otherwise tasks are taken from the front of the queue as in FCFS, except that they may explicitly yield instead of running until completion.

![](https://assets.omscs.io/notes/EDCC9CA7-6286-49DB-A03C-F40A1B12DDE8.png)

A further modification that makes sense with round robin is not to wait until the tasks explicitly yield, but instead to interrupt them in order to mix in all the tasks in the system at the same time. For example, we would give each task a window of one time unit before interrupting it to schedule a new task. We call this mechanism **timeslicing**.

![](https://assets.omscs.io/notes/AED712E3-7C9D-4E10-B5CD-48ACB79788FA.png)

## Timesharing and Timeslices
A **timeslice** (also known as a time quantum) is the maximum amount of uninterrupted time that can be given to a task. A task may run for a smaller amount of time than what the timeslice specifies. If the task needs to wait on an I/O operation, or synchronize with another task, the task will execute for less than its timeslice before it is placed on the appropriate queue and preempted. Also, if a higher priority tasks becomes runnable before a lower priority task's timeslice has expired, the lower priority task will be preempted.

The use of timeslices allows for the tasks to be interleaved. That is, they will be timesharing the CPU. For I/O bound tasks, this is not super critical, as these tasks will often be placed on wait queues. However, for CPU bound tasks, timeslices are the only way that we can achieve timesharing.

Let's compare round robin scheduling with a timeslice of 1 to the FCFS and SJF algorithms across the metrics of throughput, average wait, and average completion. Note that the FCFS metrics also apply to a round robin scheduler without timeslices: these tasks perform no I/O, so round robin would run them one after another in queue order, exactly like FCFS.

![](https://assets.omscs.io/notes/4D3CD488-5851-47C3-8840-4E79CBD288FA.png)

T1 executes for one second, and is completed. T2 executes for one second and is preempted by T3. T3 executes for 1 second and is completed. T2 now executes for 9 seconds (no other tasks are present to preempt it), and it completes.

For metrics, our throughput stays the same (3 tasks in 12 seconds, or 0.25 tasks per second). The wait times are 0, 1, and 2 seconds, so the average wait time is 1 second. The tasks complete at 1, 12, and 3 seconds, so the average completion time is 5.33 seconds. These are on par with SJF (1 second and 5 seconds), but **without** needing the a priori knowledge of execution times, which was said was unfeasible in a real system.

Some of the benefits of  timeslicing are that the short tasks finish sooner, the scheduler is more responsive to changes in the system, and that lengthy I/O operations can be initiated sooner. For example, if T2 is a task that users interact with, it starts only 1 second into the execution, and any I/O it needs can be initiated then. With SJF, T2 would only start after both T1 and T3 complete.

The downside of timeslicing is the overhead. We have exaggerated in our graphs that there is no latency between tasks, but this is not the case. Timeslicing takes time: we have to interrupt the running task, we have to execute the scheduler, and we have to context switch to the new task.

Even when there are no other runnable tasks in the system, as with the case of T2 above after T=3, the timer will still fire at timeslice intervals. That being said, there will be no scheduling or context switching, which is the dominant part of the overhead, so the overhead will not be as great when the current task does not need to be preempted.

If we consider the overheads when we compute our metrics, we can see that our total time will increase slightly, so our throughput will go down. As well, each task will have to wait just a little longer to start, so our wait time and our completion time will increase.

As long as the timeslice is significantly longer than the amount of time it takes to context switch, we should be able to minimize the overheads of context switching.

## How Long Should a Timeslice Be
Timeslices provide benefits to the system, but also come with certain overheads. The balance of the benefits and the overheads will inform the length of the timeslice. The answer is different for I/O bound tasks vs. CPU bound tasks.

## CPU Bound Timeslice Length
Let's consider two CPU bound tasks that each take 10 seconds to complete. Let's assume that the time to context switch is 0.1 seconds. Let's consider a timeslice value of 1 second and a timeslice value of 5 seconds.

![](https://assets.omscs.io/notes/7E4262FA-1297-474A-A624-4BBD1B57DA5B.png)

**NB**: The average wait time for the 5 second timeslice is wrong in the lecture graphic, which has a division error. `T1` starts at 0 seconds and `T2` starts at 5.1 seconds, so the average wait is 2.55 seconds and not 3.05 seconds. The course errata lists this correction.

**NB**: The average completion time for the 1 second timeslice is also wrong in the lecture graphic. The schedule has 20 one-second slices and 19 context switches, so it takes 20 + 19 x 0.1 = 21.9 seconds in total (which gives the graphic's throughput of 2 / 21.9 = 0.091 tasks/s). `T1` finishes its 10th slice at 19 + 18 x 0.1 = 20.8 seconds and `T2` finishes at 21.9 seconds, so the average completion time is (20.8 + 21.9) / 2 = 21.35 seconds, not the graphic's 20.85 seconds. The lecture audio gives no numbers for these tables.

With a smaller timeslice value, we have to pay the time cost of context switching more frequently. This will degrade our throughput and our average completion time. That being said, smaller timeslices mean that tasks are started sooner, so our average wait time is better when we have smaller timeslices.

The user cannot really perceive when a CPU bound task starts, so average wait time is not super important for CPU bound tasks. The user cares when a CPU bound task completes.

For CPU bound tasks, we are better off choosing a larger timeslice. In fact, if our timeslice value was infinite - that is to say we never preempt tasks - our metrics would be best.

![](https://assets.omscs.io/notes/033B24F5-0B4D-445D-899E-9CC8A7119851.png)

## I/O Bound Timeslice Length
Let's consider two I/O bound tasks that each take 10 seconds to complete. Let's assume that the time to context switch is 0.1 seconds. Let's assume that each task issues an I/O request every 1 second, and that I/O completes in every 0.5 seconds. Let's consider a timeslice value of 1 second and a timeslice value of 5 seconds.

![](https://assets.omscs.io/notes/C7A8B07E-5DBC-445B-8C9B-639425A92F93.png)

In both cases, regardless of the timeslice, each task is yielding the CPU after every second of operation - when it makes its I/O request. There isn't really any preemption going on. Thus the execution graphs and the metrics for timeslice values of 1 second and 5 seconds are identical, and identical to the CPU bound case with a 1 second timeslice.

**NB**: As in the CPU bound table, the 20.85 second average completion time shown for these schedules should be 21.35 seconds (`T1` completes at 20.8 seconds, `T2` at 21.9 seconds). The same correction applies to the first two rows of the next table.

Let's change the scenario and assume only T2 is I/O bound. T1 is now CPU bound.

![](https://assets.omscs.io/notes/F384B9B2-2367-42EA-B43F-DFAC45DF4626.png)

The metrics for a timeslice value of 1 second do not change. The only function difference we have is that T1 is now explicitly preempted when its timeslice expires as opposed to before when T1 yielded the CPU after issuing its I/O request.

The metrics for a timeslice value of 5 seconds do change. T1 runs until its timeslice expires at T=5. T2 then runs for only 1 second until it issues its I/O request. T1 then runs again for 5 seconds and completes. Finally T2 is the only runnable task left, so it runs alone until it completes.

Note that the I/O latency of T2 can no longer be hidden, which means that the total execution time of these operations is extended (the graphic draws T2 without its I/O waits after T1 completes; the table values assume them), which means that the throughput suffers. The average wait time suffers as well, because T2 now has to wait 5 seconds for T1's timeslice to expire. The average completion time is lower, but only because of a large variance: T1 completes early, at about 11 seconds, while T2 completes much later. This is not an improvement for the I/O bound task.

For I/O bound tasks, we want a smaller timeslice. We can keep throughput up and average wait time down with a smaller timeslice. As well, we can maximize device utilization with a smaller timeslice, as we can quickly switch between different tasks issuing I/O requests.

## Summarizing Timeslice Length
CPU bound tasks prefer longer timeslices as this limits the number of context switching overheads that the scheduling will introduce. This ensures that CPU utilization and throughput will be as high as possible.

On the other hand, I/O bound tasks prefer short timeslices. This allows I/O bound tasks to issue I/O requests as soon as possible, and as a result this keeps CPU and device utilization high and well improves user-perceived performance (remember wait times are low).

### Timeslice Quiz
On a single CPU system, there are 10 I/O bound tasks and 1 CPU bound task. The I/O bound tasks issue an I/O operation after every 1 ms of CPU compute time, and each I/O operation takes 10 ms to complete. The context switching overhead is 0.1 ms, and all tasks are long running. What is the CPU utilization (rounded to the nearest percent) for a round robin scheduler with a 1 ms timeslice? With a 10 ms timeslice?

CPU utilization = useful CPU time / total time (useful time plus context switch overhead).

- 1 ms timeslice: every 1 ms, either the CPU bound task is preempted or an I/O bound task stops to issue its I/O. Each 1 ms of useful work costs 1.1 ms in total, so utilization = 1 / 1.1 = 91%.
- 10 ms timeslice: each of the 10 I/O bound tasks runs for 1 ms and then issues an I/O request, and then the CPU bound task runs for the full 10 ms. Utilization = (10 x 1 + 10) / (10 x 1.1 + 10.1) = 20 / 21.1 = 95%.

From the CPU utilization perspective, a large timeslice that favors the CPU bound task is better. From the perspective of the I/O device, a smaller timeslice is better, because the I/O device cannot do anything while the CPU bound task runs for its full 10 ms.

## Runqueue Data Structure
The runqueue data structure is only logically a queue. It can be implemented as multiple queues or even a tree. What's important is that the data structure is designed so that the scheduler can easily determine which task should be scheduled next.

For example, if we want I/O and CPU bound tasks to have different timeslice values, we can either place I/O and CPU bound tasks in the same runqueue and have the scheduler check the type, or we can place them in separate runqueues.

One common data structure is a multi queue structure that maintains multiple distinct queues, each differentiated by their timeslice value. I/O intensive tasks will be associated with the queue with the smallest timeslice values, while CPU intensive tasks will be associated with the queue with the largest timeslice values.

For example, the most I/O intensive tasks go in a queue with an 8 ms timeslice, tasks with a mix of I/O and CPU processing go in a queue with a 16 ms timeslice, and CPU intensive tasks go in a queue with an infinite timeslice (effectively FCFS). The I/O intensive queue has the highest priority, so the scheduler always checks it first; the CPU bound queue has the lowest priority and is checked last.

![](https://assets.omscs.io/notes/E73C69B5-5984-42BF-A68B-3E495829C2A3.png)

This solution is beneficial because it provides timeslicing benefits for I/O bound tasks, while also avoid timeslicing overheads for CPU bound tasks.

How do you know if a task is CPU or I/O intensive?

We can use history based heuristics to determine what a task has done in the past as a way to inform what it might do in the future. However, this doesn't help us make decisions about new tasks or tasks that have dynamic behaviors.

To help make these decisions, we will need to move tasks between queues.

When a new task enters the system, we will place it on the topmost queue (the one with the lowest timeslice), as if we expect it to be the most demanding task in terms of scheduling operations. If the task yields before the timeslice has expired, we have made a good choice. We will place this task back on this queue when it becomes runnable again. If the task has to be preempted, this implies that the task was more CPU intensive than we thought, and we push it down to a queue with a longer timeslice. If the task has to be preempted still, we can push the task down even further, to the bottom queue.

If a task in a lower queue begins to frequently release the CPU due to I/O waits, the scheduler may boost the priority of that task and place it in a queue with a smaller timeslice.

The resulting data structure is called the **multi-level feedback queue**.

![](https://assets.omscs.io/notes/1A833C17-905A-46B8-B90B-F5E0803B3B6E.png)

The MLFQ is not just a group of priority queues. There are different scheduling policies associated with each level. Importantly, this data structure provides feedback on a task, and helps the scheduler understand over time which queue a task belongs to given the makeup of tasks in the system.

Fernando Corbató received the Turing Award in part for the multi-level feedback queue and his broader work on timesharing systems. The Solaris scheduler is essentially a multi-level feedback queue with 60 levels and its own set of feedback rules governing how a task is moved up and down those levels.

## Linux O(1) Scheduler
The Linux O(1) scheduler gets its name from the fact that it can add/select a task in constant time, regardless of the number of tasks in the system. It is a preemptive, priority-based scheduler, with 140 priority levels, where 0 is the highest priority and 139 the lowest. The priority levels are broken into two classes: priorities from 0 to 99 are for real-time tasks, while 100 - 139 are for timesharing tasks.

User processes have priorities in the timesharing class, with the default priority in the middle at 120. Priority levels can be adjusted with so-called **nice values** which span from -20 to 19, corresponding to 120 - 20 to 120 + 19. There is a system call to adjust the priority of a user process.

The O(1) scheduler borrows from the MLFQ scheduler in that each priority level is associated with a different timeslice value. As well, the O(1) scheduler uses feedback from how tasks behaved in the past in order to understand how to prioritize tasks in the future.

The scheduler assigns the smallest timeslice values to the low-priority, CPU bound tasks, and assigns the largest timeslice values to the more interactive tasks.

The feedback for the task depends on how long the task spent sleeping during its timeslice. Sleeping refers to time spent idling or waiting. If a task spends more time sleeping, this means it is a more interactive tasks, and its priority is boosted (priority - 5). If a task spends less time sleeping, this means it is a more computationally intensive task, and its priority is lowered (priority + 5, up to a maximum).

The runqueue in the O(1) scheduler is implemented as two arrays of tasks.  Each array elements points to the first runnable task at that priority level.

The two arrays are **active** and **expired**.

The active list is the primary one that the scheduler uses to select the next task to run. It takes constant time to add a task, as it takes constant time to index into the array and then follow the pointer to the end of the task list to enqueue the task.  It takes constant time to select a task because the scheduler relies on certain instructions that return the first set bit in a sequence of bits. If the sequence of bits corresponds to the priority levels, and a set bit means that there are tasks at that level, then it will take a constant amount of time to run those instructions to detect what is the priority level that has certain tasks on it. Once that position is known, it takes a constant amount of time to index into the array and select the first task from the task list.

If a task yields the CPU to wait on an event or is preempted due to a higher priority task becoming runnable, the time it has spent on the CPU is compared to the timeslice. If it is less than the timeslice, the task is placed back on the active queue for that priority level.

Only after the entire timeslice has been exhausted will the task move to the expired array. The expired array contains the inactive tasks. This means that the scheduler will not schedule tasks from this array while there are still tasks in the active array. Once there are no more tasks in the active array, the active and the expired arrays will be swapped.

This sheds a little bit of light as to why the lowest priority tasks have the smallest timeslices. Remember, we had originally thought to give the lowest priority, CPU intensive tasks the largest timeslices. In this case, however, giving the lowest priority tasks the smallest timeslices ensures that low priority tasks - which only run after all higher priority tasks expire - do not block the higher priority tasks for too long. The lower priority tasks get their small window to accomplish their work, and then quickly yield back to more important tasks.

The two arrays also act as an aging mechanism: high priority tasks eventually consume their timeslices and are placed on the expired array, at which point the low priority tasks get a chance to run for their small timeslices.

The O(1) scheduler was introduced in Linux 2.5 by Ingo Molnar. Despite its constant time add/select functionality, though, this scheduler significantly hurt the performance of interactive tasks. As typical applications became more time sensitive (think Skype, movie streaming, gaming), the jitter introduced by the O(1) scheduler became unacceptable. For this reason, the O(1) scheduler was replaced by the **completely fair scheduler** (CFS) in Linux 2.6.23, which is now the default scheduler. Both schedulers were developed by the same person, and both are part of the standard Linux distribution, so it is possible to switch back to the O(1) scheduler.

## Linux CFS Scheduler
One problem with the O(1) is that once a task enters the expired queue, it will not get a chance to run again until all other tasks in the active queue have executed for their timeslices. This is a problem for interactive tasks, introducing jitter into interactions that should appear seamless.

In addition, the scheduler in general doesn't make any **fairness** guarantees. Intuitively, fairness is the concept that in a given time interval, a task should be able to run for an amount of time that is proportional to its priority. There are multiple formal definitions of fairness.

As a replacement for the O(1) scheduler, the CFS scheduler was introduced. CFS is now the default scheduler for non-realtime tasks in Linux; realtime tasks are scheduled by a realtime scheduler.

CFS uses a **red-black tree** as a runqueue structure. Red black trees are self-balancing trees, which ensure that all of the paths from the root of the tree to the leaves are approximately the same size.

![](https://assets.omscs.io/notes/EB1FD238-3A0E-4D51-AC7A-A859C6539011.png)

Tasks are ordered in the tree based on the amount of time that they spent running on the CPU, a quantity known as **vruntime** (virtual runtime). CFS tracks this quantity to the nanosecond.

This runqueue has the property that for a given node, all nodes to the left have lower vruntimes and therefore need to be scheduled sooner, while all nodes to the right, have larger vruntimes and therefore can wait longer. Each internal node corresponds to a task; the leaves play no role in the scheduler.

The CFS algorithm always schedules the node with the least amount of vruntime in the system, which is typically the leftmost node of the tree. Periodically, CFS will increment the vruntime of the task that is currently executing on the CPU, at which point it will compare this vruntime with the vruntime of the leftmost task in the tree. If the currently running task has a smaller vruntime than the leftmost node, it will keep running; otherwise, it will be preempted in favor of the leftmost node, and will be inserted appropriately back into the tree.

To account for differences in task priorities (nice values), CFS changes the effective rate at which a task's vruntime progresses. For lower priority tasks, time passes more quickly: their vruntime progresses faster, so they will likely lose the CPU sooner. For higher priority tasks, time passes more slowly: their vruntime progresses at a slower rate, so they get to execute on the CPU longer.

CFS uses one runqueue structure for all of the priority levels, unlike the per-priority queues of the O(1) scheduler.

In summary, task selection from the runqueue takes constant time. Adding a task to the runqueue takes log time relative to the total number of tasks in the system. Given typical levels of load in current systems, this log(n) time is acceptable.

It is possible that the log(n) performance of the addition step may limit the use of this scheduler as the number of tasks a system can handler increases past a certain threshold. At some point, the search may be on for a fair scheduler than can select and add in constant time.

### Linux Schedulers Quiz
What was the main reason the Linux O(1) scheduler was replaced by the CFS scheduler?

- Scheduling tasks under high loads took an unpredictable amount of time. Incorrect: the O(1) scheduler took a constant amount of time to select and schedule a task, regardless of the load.
- Low priority tasks could wait indefinitely and starve. Sort of correct: as long as higher priority tasks kept arriving, low priority tasks could wait an unpredictable amount of time, possibly indefinitely. This was not the main reason.
- Interactive tasks could wait unpredictable amounts of time to be scheduled to run. **Correct**: workloads were becoming more interactive and demanded high predictability, but once a task was moved to the expired array, it had to wait there until the tasks in the active array had used up their timeslices.

For a long time Linus Torvalds resisted integrating a scheduler that addressed the needs of small interactive tasks, on the grounds that Linux was a general purpose operating system. As general purpose workloads themselves changed, Linux needed a scheduler that met those needs, and CFS did.

## Scheduling on Multiprocessors
Before we can talk about scheduling on multiprocessor systems, it is important to understand the architecture of multiprocessor systems.

In a **shared memory multiprocessor**, there are multiple CPUs. Each CPU has its own private L1/L2 cache, as well as a last-level cache (LLC) which may or may not be shared amongst the CPUs. Finally, there is system memory (DRAM) which is shared across the CPUs.

In a **multicore** system, each CPU can have multiple internal cores. Each core has it's own private L1/L2 cache, and the CPU as a whole shares an LLC. DRAM is present in this system as well. Dual-core CPUs are common in client devices like laptops and cell phones, while servers commonly have multiple CPUs with six or eight cores each.

![](https://assets.omscs.io/notes/4CF9EA4E-5B8F-4B27-B0EC-397F76E05656.png)

As far as the operating system is concerned, it sees all of the CPUs and all of the cores in the CPUs as entities onto which it can schedule tasks.

Since the performance of processes/threads is highly dependent on the amount of execution state that is present in the CPU cache - as opposed to main memory - it makes sense that we would want to schedule tasks on to CPUs such that we can maximize how "hot" we can keep our CPU caches. To achieve this, we want to schedule our tasks back on the same CPUs they  had been executing on in the past. This is known as **cache affinity**.

To achieve cache affinity, we can have a hierarchical scheduling architecture which maintains a load balancing component that is responsible for dividing the tasks among CPUs. Each CPU then has its own scheduler with its own runqueue, and is responsible for scheduling tasks on that CPU exclusively.  

To load balance across the CPUs, we can look at the length of each of the runqueues to ensure one is not too much longer than the other. In addition, we can detect when a CPU is idle, and rebalance some of the work from the other queues on to the queue associated with the idle CPU.

In addition to having multiple processors, it is possible to have multiple memory nodes. The CPUs and the memory nodes will be connected via some physical interconnect (for example, QuickPath Interconnect, or QPI, on modern Intel platforms). In most configurations it is common that a memory node will be closer to a socket of multiple processors, which means that access to this memory node from those processors is faster than accessing some remote memory node. We call these platforms **non-uniform memory access** (NUMA) platforms.

![](https://assets.omscs.io/notes/B506B72A-ECBC-4DF4-8DAB-62F9FD2BC10B.png)

From a scheduling perspective, what makes sense is to keep tasks on the CPU closest to the memory node where their state is, in order to maximize the speed of memory access. We refer to this as **NUMA-aware scheduling**.

## Hyperthreading
The reason why we have to context switch among threads is because the CPU only has one set of registers to describe an execution context. Over time, hardware architects have realized they can hide some of the latency associated with context switching. One of the ways that this has been achieved is to have CPUs with multiple sets of registers where each set of registers can describe the context of a separate thread.

![](https://assets.omscs.io/notes/DA77AC78-FEB2-4DB0-B12C-F84B43FF7D24.png)

We call this **hyperthreading**. In hyperthreading, we have multiple hardware-supported execution context. We still have one CPU - so only one of these threads will execute at a given time - but context switching amongst the threads is very fast.

This mechanism is referred to by many names:

- hardware multithreading
- hyperthreading
- chip multithreading (CMT)
- simultaneous multithreading (SMT)

Modern platforms often support two hardware threads, though some high performance platforms may support up to eight. Modern systems allow for hyperthreading to be enabled/disabled at boot time, as there are tradeoffs to this approach.

If hyperthreading is enabled, each of these hardware contexts appears to the scheduler as an entity upon which it can schedule tasks.

One of the decisions that the scheduler will have to make is which two threads to schedule on this hardware contexts. If the amount of time a thread is idling is greater than the amount of time to context switch twice, it makes sense to context switch. Since a hardware context switch is on the order of cycles and DRAM access is on the order of hundreds of cycles, hyperthreading can be used to hide memory access latency.

## Scheduling for Hyperthreading Platforms
To understand what is required from a scheduler in a hyperthreaded platform we first need to make some assumptions.

First, we need to assume that a thread can issue an instruction on every CPU cycle. This means that a CPU bound thread will be able to maximize the **instructions per cycle** (IPC) metric.

Second, we need to assume that memory access takes four cycles. What this means is that a memory bound thread will experience some idle cycles while it is waiting for the memory access to complete.

![](https://assets.omscs.io/notes/2B1476A6-EE31-4AA9-A733-718FDDFE3727.png)

Third, we can also assume that hardware switching is instantaneous.

Finally, we will assume that we have an SMT platform with two hardware threads.

Let's look at the scenario of co-scheduling two compute-bound threads.

![](https://assets.omscs.io/notes/B90046E6-16D2-4B95-89A9-DCF7264862CF.png)

Even though each thread is able to issue a CPU instruction during each cycle, only one thread will be able to issue an instruction at a time since there is only one CPU pipeline. As a result, these threads will interfere with one another as they compete for CPU pipeline resources.

The best case scenario is that a thread idles every other cycle while it yields to the other thread issuing instructions. As a result, the performance of each thread degrades by a factor of two.

In addition, the memory component is completely idle during this computation, as nothing is performing any memory access.

Let's look at the scenario of co-scheduling two memory-bound threads.

![](https://assets.omscs.io/notes/F48DA477-45B0-45E0-966D-BDA4E885C859.png)

 Similar to the CPU-bound thread example, we still have idle time where both threads are waiting on memory access to return, which means wasted CPU cycles.

Let's look at co-scheduling a mix of CPU and memory-bound threads.

![](https://assets.omscs.io/notes/702A8D07-EEE9-4FB3-98B0-C32117214897.png)

This solution seems best. We schedule the CPU-bound thread until the memory-bound thread needs to issue a memory request. We context switch over, issue the request, and then context switch back and continue our compute-heavy task. This way, we minimize the number of wasted CPU cycles.

Scheduling a mix of memory/CPU intensive threads allows us to avoid or at least limit the contention on the processor pipeline and helps to ensure utilization across both the CPU and the memory components.

Note that we will still experience some degradation due to the interference of these two threads, but it will be minimal relative to the co-scheduling of only memory- or CPU-bound threads. For instance, the compute-bound thread can only execute three out of every four cycles, compared to when it ran alone.

> **Paper (Fedorova et al.):** The paper develops this with a three-system comparison rather than the lecture's two-hardware-thread picture. It contrasts a single-threaded core (A, the lower bound), a multithreaded core (B), and a multiprocessor with one core per thread (C, the upper bound). On a purely CPU-bound workload A and B perform comparably while C is four times faster; on a purely memory-bound workload B and C both beat A by a factor of four, because the multithreaded core overlaps the four threads' memory latencies. The contention argument rests on instruction delay latency: an ALU instruction has 0 delay latency, an L1-cache-hit load has 4 cycles, and a branch delays the next instruction by 2 cycles. The headline result is that a CMT-aware scheduler can improve application performance by as much as a factor of two over a naive one.

## CPU Bound or Memory Bound
How do we know if a thread is CPU bound or memory bound? We need to use historic information.

When we looked previously at determining whether a process was more interactive or more CPU intensive, we looked at the amount of time the process spent sleeping. This approach won't work in this case for two reasons. First of all, the thread is not really sleeping when it is waiting on memory access. It is waiting at some stage in the processor pipeline, not on some software queue. Second, to keep track of the sleep time we were using software methods and that is too slow at this level. The context switch takes on the order of cycles, so we need to be able to make our decision on what to run very quickly.

We need some hardware-level information in order to help make our decision.

Most modern platforms contain **hardware counters** that get updated as the processor executes and keep information about various aspects of execution, like

- L1, L2 ... LLC cache misses
- number of instructions retired (from which IPC can be computed)
- Power/Energy usage data

There are a number of software interfaces for accessing these hardware counters, such as

- oprofile
- Linux perf tool

Hardware counters are not uniform across platforms; the oprofile website lists the counters available on different architectures.

So how can hardware counters help us make scheduling decisions? Many practical scheduling techniques rely on the use of hardware counters to understand something about the resource needs of a thread. The scheduler can use this information to pick a good mix of the threads that are available in the runqueue to schedule in the system so that all of the components of the system are well utilized and the threads interfere with each other as little as possible.

For example, a thread scheduler can look at the number of LLC misses - a metric stored by the hardware counter - and determine that if this number is great enough then the thread is most likely memory bound, because its footprint does not fit in the cache. However, the same counter could instead mean that the thread has entered a different phase of its execution and is running with a cold cache. One counter can tell us different things about a thread, so there is no unique way to interpret it; schedulers have to guesstimate a thread's resource use.

That does not make hardware counters useless: schedulers can still make informed decisions from them. Schedulers often look at a combination of multiple counters across the CPU, not just one, and can rely on models that have been built for a specific platform and that have been trained using some well-understood workloads (for example, a workload known to be memory intensive).

## Scheduling with Hardware Counters
Fedorova speculates that a more concrete metric to help determine if a thread is CPU bound or memory bound is **cycles per instruction** (CPI). A memory bound thread will take a lot of cycles to complete an instruction; therefore, it has a high CPI. A CPU bound thread will have a CPI of 1 (or some low number) as it can complete an instruction every cycle (or close to every cycle).

> **Paper (Fedorova et al.):** The paper is less tentative than "speculates" suggests. Section 5 states that mean CPI, "easily determined using hardware counters, gives us a useful window into the dynamic instruction mix of a workload" and "nicely captures average instruction delay." The reasoning runs through single-threaded CPI (the CPI a thread would show on a dedicated processor): a high single-threaded CPI means the thread spends much of its time blocked on memory or long-latency instructions and so has low pipeline resource requirements, while a low CPI means high resource requirements. The lecture's "high CPI implies memory bound" is the same idea stated through the thread's behavior rather than its resource demand.

Given that there is no CPI counter on the processor that Fedorova uses - and computing something like 1 / IPC would require unacceptable software intervention - she uses a simulator in which the CPU is assumed to have a CPI counter. Her hope is that if she can demonstrate that CPI is a useful metric, hardware engineers will add this counter to future architectures.

To explore this question, Fedorova simulates a system that has 4 cores, with each core have a 4-way SMT, for a total of 16 hardware execution contexts.

> **Paper (Fedorova et al.):** The simulated core is not SMT. Section 3 models fine-grained multithreading (Laudon et al.): the core has one set of functional units and interleaves the threads by switching context on every cycle, so at most one instruction issues per cycle and the per-core IPC maxes out at 1. The paper names SMT (multiple sets of functional units, instructions from several threads issued in the same cycle) as the alternative design it deliberately did not take, choosing a simple RISC core to fit more cores on the chip. The lecture labels the whole platform SMT, which the course also treats as a synonym for hyperthreading.

Next, she wants to vary the threads that get assigned to these hardware contexts based on their CPI, so she creates a synthetic workload where her threads have a CPI of 1, 6, 11, and 16. The threads with the CPI of 1 will be the most CPU-intensive, while the threads with the CPI of 16 will be the most memory-intensive. The overall workload mix has four threads of each kind.

She wants to assess is the overall performance when a specific mix of threads gets assigned to each of these 16 hardware contexts, and she uses IPC as the metric. Given that the maximum number of cores is 4, the maximum IPC is 4.

She runs four experiments, (a) - (d), with each core having a specific composition of threads, manually and statically assigned to mimic the decisions a scheduler would make. In (a), every core runs the identical mix of CPI 1, 6, 11, and 16. In (d), each core runs a very different mix: all of the tasks on core 0 have a CPI of 1, while all of the tasks on core 3 have a CPI of 16. Experiments (b) and (c) fall between these two extremes.

![](https://assets.omscs.io/notes/19415E6A-E6EF-4A29-823A-EE8C95FFB327.png)

## CPI Experiment Results
Here are the results for the four experiments.

![](https://assets.omscs.io/notes/F39D7297-567A-4D1C-8B45-56285FCC173A.png)

In the first two experiments, we have a fairly well balance mix of high- and low-CPI threads across the cores. We see that in these two cases, the processor pipeline was well-utilized and our IPC is high. It is not the maximum IPC of 4, but it is fairly high.

In the last two experiments, each of the cores were assigned tasks with similar - or in the case of the final experiment, identical - CPI values. We can see that in these two cases, the processor pipeline was much more poorly utilized. Threads either spent a lot of time in contention with one another - in the case of CPU bound tasks - or the CPU spent a lot of time idling - in the case of memory-bound tasks. Regardless, our IPC dropped significantly. Cores 0 and 1, which held mostly low-CPI (compute intensive) tasks, had a lot of contention for the pipeline, while cores 2 and 3, which held mostly memory intensive tasks, contributed very little to the aggregate IPC.

> **Paper (Fedorova et al.):** Section 5 gives the magnitudes: schedules (a) and (b) perform twice as well as schedule (d) and 1.5 times better than schedule (c). In the poor schedules the CPI-1 threads are packed together (two cores of 1, 1, 6, 6 in (c); one core of 1, 1, 1, 1 in (d)), so those cores are saturated while the cores holding only high-CPI (memory-bound) threads are under-utilized.

We can conclude that scheduling tasks with mixed CPI values leads to higher platform utilization.

We have used a synthetic workload in this case, with each task having a CPI that is quite far from other CPI values present in the system. Is this a realistic workload?

In order to answer this, Fedorova profiled a number of applications from several respected benchmark suites and computed the CPI values for each.

![](https://assets.omscs.io/notes/CC98A928-2A37-420E-A949-F801FA2DEB7E.png)

What we can see is that most of the values are quite cluttered together. We do not see the distinct values presented in the synthetic workload. Most CPIs range from 2.5 - 4.5 (read off the lecture graphic).

Because CPI isn't that different across applications, it may not be the most instructive metric to inform scheduling decisions.

> **Paper (Fedorova et al.):** The paper draws the opposite conclusion from its profiling and never gives a "2.5 to 4.5" range (that figure is from the lecture graphic). Section 5 reports that measured CPI "can vary by an order of magnitude among applications" and that, given recent behavior, "we can predict the near-term CPI of a thread," so "constructing a scheduler that balances load across CPU cores on a CMT processor should be a simple matter of engineering." The paper's own stated limitations are different ones: CPI does not reveal which specific resources (cache hierarchy, floating-point unit) threads contend for, and CPI measured on a busy system is already perturbed by existing contention. The "CPIs cluster, so CPI is not useful" takeaway is the lecture's framing; it aligns with Fedorova's later work (USENIX 2005), which identifies L2 cache contention, not pipeline CPI, as the dominant effect.

![](https://assets.omscs.io/notes/A260F044-D32B-4ADA-8E2C-AE04AE7F0A92.png)

Even though the paper describes something that does not work in practice, it has important takeaways. We learn about SMTs and their resource contention issues, specifically with the processor pipeline as a resource. We learn how hardware counters can be used to characterize a workload and inform OS-level resource management. And we learn that schedulers should consider resource contention, not just load balancing: a scheduler should choose a set of tasks that will not contend for the processor pipeline, the hardware cache, the memory controller, or some I/O device. These principles generalize beyond the processor pipeline in hardware multithreaded platforms.

Fedorova's follow-on work, as well as several other efforts, established that a particularly important contributor to performance degradation when running multiple tasks on a hardware multithreaded or multicore platform is the use of the cache, in particular the last level cache. A scheduler should therefore track how a set of threads uses the cache and pick a mix that does not cause contention on the LLC.
