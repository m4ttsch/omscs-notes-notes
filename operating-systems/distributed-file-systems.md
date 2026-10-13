---
id: operating-systems-distributed-file-systems
title: Distributed File Systems
course: operating-systems
lecture: distributed-file-systems
---

# Distributed File Systems

**Reference paper**: [Caching in the Sprite Network File System](https://s3.amazonaws.com/content.udacity-data.com/courses/ud923/references/ud923-nelson-paper.pdf) - Nelson, Welch and Ousterhout.

**OSTEP chapters**:
* [49. Sun's Network File System (NFS)](https://pages.cs.wisc.edu/~remzi/OSTEP/dist-nfs.pdf)
* [50. The Andrew File System (AFS)](https://pages.cs.wisc.edu/~remzi/OSTEP/dist-afs.pdf)

## Distributed File Systems
Modern operating systems export a high-level filesystem interface to abstract all of the (potentially) different types of storage devices present on a machine and unify them under a common API.

The OS can hide the fact that there isn't even local physical storage on a machine; rather, the files are maintained on a remote filesystem that is being accessed over the network.

Environments that involve multiple machines for the delivery of the filesystem service are called **distributed filesystems** (DFS).

## DFS Models
A simple DFS model involves clients being served files from a server running on a different machine.

Often, the server is not running on a single machine, but rather is distributed across multiple machines. Files may be **replicated** across every machine or **partitioned** amongst machines.

In replicated systems, all the files are replicated and available on every server machine. If one machine fails, other machines can continue to service requests. Replicated systems are **fault tolerant**. In addition, requests entering a replicated system can be serviced by any of the replicas. Replicated systems are **highly available**.

In partitioned systems, each server holds only some subset of the total files.
If you need to support more files, you can just partition across more machines. In the replicated model, you will need to upgrade your hardware. This makes partitioned systems more **scalable**.

It's common to see a DFS that utilizes both partitioning and replication; for example, partitioning all the files, and replicating each partition. Many of the big data filesystems used by companies like Google and Facebook take this approach.

Finally, files can be stored on and served from all machines. This blurs the line between servers and clients, because all the nodes in the system are **peers**. Every node is responsible for maintaining the files and providing the filesystem service. Each peer will take some portion of the load by servicing some of the requests, often those that for files local to that peer.

This lesson focuses primarily on the first model, clients and separate server machines, and on the caching and consistency management issues in such environments.

## Remote File Service: Extremes
At one extreme, we have the upload/download model. When a client wants to access a file, it downloads the entire file, performs the modifications and then uploads the entire file back to the server. This is less like a proper filesystem and more like the way FTP servers, or version management systems such as SVN servers, behave.

![](https://assets.omscs.io/notes/B02657E2-D79B-43AB-87F4-7B75275CA3CB.png)


The benefit of this model is that all of the modifications can be done locally, which means they can be done quickly, without incurring any network cost.

One downside of this model is that the client has to download the entire file, even for small modifications. A second downside of this model is that it takes away file access control from the server. Once the server gives the file to the client, it has no idea what the client is doing with the file or when it will give it back. This makes some operations related to sharing files difficult to execute.

At the other extreme, we have the true remote file access. In this model, the file remains on the server and every single operation has to pass through the server. The client makes no attempt to leverage any kind of local caching or buffering.

![](https://assets.omscs.io/notes/4358EB0F-C95F-4106-A8ED-74E92E275263.png)

The benefit of this extreme is that the server now has full control and knowledge of how the clients are accessing and modifying a file. This makes it easier to ensure that the state of the filesystem is consistent.

The downside of this model is that every file operation pays a network cost. This cost is incurred even when clients are only reading repeatedly from a read-only file, since the model bypasses any local caching the client could have used. In addition, this model is limited in its scalability. Since every file operation goes to the server, the server will get overloaded more quickly, and will not be able to service as many clients.

## Remote File Service: A Compromise
We should allow clients to benefit from using their local memory/disk and to store at least some part of the file they are accessing. This may include downloading blocks of the file they are accessing, as well as prefetching blocks that they may soon be accessing.

When files can be served from a local cache, lower latencies on file operations can be achieved since no additional network cost in incurred. In addition, server scalability is increased as local service decreases server load.

Once we allow clients to cache portions of the file, however, it becomes necessary for the clients to start interacting with the server more frequently. On the one hand, clients need to notify the server of any modifications they make. In addition, they need to query the server at some reasonable frequency to detect if the files the are accessing from their cache have been changed by someone else.

This approach is beneficial because the server continues to have insight into what the clients are doing and retains some control over which accesses can be permitted. This makes it easier to maintain consistency. At the same time, the server can be somewhat out of the way, allowing some proportion of operations to occur on the client. The helps to reduce load.

The downside with this compromise is that the server becomes more complex. The server needs to perform additional tasks and maintain additional state to make sure it can provide consistency guarantees. This also means that the client has to understand file sharing semantics that are different from what they are used to in a normal filesystem.

## Stateless vs. Stateful File Server
A **stateless** server keeps no state.

It has no notion of:

- which files/blocks are being accessed
- which operations are being performed
- how many clients are accessing how many files

As a result, every request has to be completely self-contained: it carries the file being accessed, the absolute offset within that file, and any data that needs to be written. This type of server is suitable for the extreme models, but it cannot be used for any model that relies on caching. Without state, we cannot achieve consistency management. In addition, since every request has to be self-contained, more bits need to be transferred on the wire for each request.

One positive of this approach is that since there is no state on the server, there is no CPU/memory utilization required to manage that state. Another positive is that this design is very resilient. Since requests cannot rely on any internal state, if the server fails it simply needs to be restarted. Clients reissue any requests that timed out and receive the same answers they would have received anyway; neither the clients nor the server need to do anything else special to recover.

A **stateful** server maintains information about:

- the clients in the system
- which files are being accessed
- which types of accesses are being performed
- which clients have a file cached
- which clients have read/written the file

Because of the state, the server can allow data to be cached and can guarantee consistency. In addition, state management allows for other functionality like locking. Since accesses are known, clients can request relative blocks ("next kB of data") instead of having to specify absolute offsets.

On failure, however, all that state needs to be recovered so that the filesystem remains consistent. This requires more complex mechanisms: the state must be checkpointed, so that it can be rebuilt to represent what the clients were doing before the failure. In addition, there are runtime overheads incurred by the server to maintain state and execute the consistency protocols. Exactly how large those overheads are depends on how caching is enabled and on the consistency requirements the DFS needs to support.

## Caching State in a DFS
Caching state in a DFS involves allowing clients to locally maintain a portion of the state - a file block, for example - and also allows them to perform operations on this cached state: `open`/`read`/`write`,etc.

Keeping the cached portions of the file consistent with the server's representation of the file requires cache coherence mechanisms.

For example, two clients may cache the same portion of file. If one client modifies their local portion, and sends the update to the file server, how does the other client become aware of those changes?

The problem is similar to cache coherence in shared memory multiprocessors, where write-update or write-invalidate mechanisms are triggered whenever a memory location is written. Doing the same in a DFS, propagating every write to every client that caches the file, may not be realistic given the much higher communication costs and latencies of distributed systems, and it may not even be necessary given the ways files are actually shared.

For client/server systems, these coherence mechanisms may be trigged in different ways. For example, the mechanism may be triggered on demand any time a client tries to access a file, or it may be triggered periodically, or it may triggered when a client tries to open a file. In addition, the coherence mechanisms may be driven by the client or the server.

In a client-driven mechanism, the client asks whether the file has been updated; in a server-driven mechanism, the server notifies the clients that have cached the file that their cached state has changed. The exact details of how and when the coherence mechanisms run depend on the file sharing semantics the DFS needs to support.

### File Caching Quiz
Where can files or file blocks be cached in a DFS that has a single file server and many clients?

- In client memory, as part of the client's buffer cache, just as a regular filesystem caches blocks read from local disk.
- On the client's local storage devices (hard disks, SSDs). Retrieving portions of a file from local storage may be faster than going over the network to the remote filesystem.
- On the server side, in the buffer cache in the file server's memory. How useful this is depends on how many clients are accessing the server at the same time and how their requests interleave. With high request interleaving there may be little locality among accesses from many clients, and the server buffer cache may not be very useful.

## File Sharing Semantics in DFS
### Single Node, UNIX
Whenever a file is modified by any process, that change is immediately visible to any other process in the system. This will be the case even if the change isn't pushed out to disk because both processes have access to the same buffer cache.

![](https://assets.omscs.io/notes/78F61AEB-F700-4CEE-8D92-14B7D8E0FC26.png)

### DFS
Even if a write gets pushed to the file server immediately, it will take some time before that update is actually delivered to the file server. It is possible that another client will not see that update for a while, and every time it performs a read operation it will continue seeing "stale" data. Given that message latencies may vary, we have no way of determining how long to delay any possible read operation in order to make sure that any write from anywhere in the system arrives at the file servers so that we can guarantee no staleness.

![](https://assets.omscs.io/notes/4559FB2E-50BC-44BB-8A2C-39C2159B9945.png)

In order to maintain acceptable performance, a DFS will typically sacrifice some of the consistency, and will accept more relaxed file sharing semantics.

### Session Semantics
In **session semantics**, the client writes back whatever data was modified on `close`. Whenever a client needs to `open` a file, the cache is skipped, and the client checks to see if a more recent version is present on the file server. The period between the file `open` and the file `close` is one session.

With session semantics, it is very possible for a client to be reading a stale version of a file. However, we know that when we close a file or open a file that we are consistent with the rest of the filesystem at that moment.

Session semantics are easy to reason about, but they are not great for situations where clients want to concurrently share a file. For example, for two clients to be able to write to a file and see each other's updates, they will constantly need to `close` and re-`open` the file. Also, files that stay open for longer periods of time may become severely inconsistent.

### Periodic Updates
In order to avoid long periods of inconsistency, the client may write back changes periodically to the server. One way to think about this is that the client has a lease on how long it can use the cached data; this is not an exclusive lease like a lock, which is a separate issue. In addition, the server can send invalidation notifications periodically, which can enforce time bounds on inconsistency. Bounding the inconsistency also means fewer conflicts accumulate between updates, so any conflicts are easier to correct. Once the server notification is received, a client has to sync with the most recent version of the file.

Since the client does not know the start and end times of these synchronization periods, the filesystem can provide explicit operations to let the client `flush` its updates to the server, or `sync` its state with the remote server. These operations are not specific to distributed filesystems; local filesystems use them as well.

### Other strategies
With immutable files, you never modify an old file: you either delete it or create a new file with a new name. Sharing photos via Instagram or Facebook works this way: to change a photo, you upload the modified photo rather than editing the uploaded one.

With transactions, the filesystem exports some API to allow clients to group file updates into a single batch to be applied atomically.

### DFS Data Structure Quiz
Consider a DFS where file sharing is implemented via a server-driven mechanism and with session semantics. Which of the following should be part of the per file data structures maintained by the server: readers, current writer, current writers, version number?

Answer: readers, current writers, and version number (not "current writer").

- Server-driven means the server pushes invalidations to the clients, so it must know who has the file.
- Under session semantics, changes become visible when a session closes and a subsequent client opens the file. Overlapping sessions can therefore see different versions of the file, so there can be multiple concurrent writers, not just one. Session semantics does not specify what happens when all of these writers close the file: one version may become the valid one, the versions may be merged, or an error may be raised to the clients so they can resolve the conflict.
- A version number lets clients know which version they were given, and lets the server tell which clients have been modifying an old version of the file versus the newest one.

## File vs. Directory Service
Understanding the workload is important when designing a system to support a particular file sharing semantics: what the sharing frequency is, what the write frequency is, and how important it is to maintain a consistent view for a particular type of file. Once these workload properties are understood, the filesystem should be designed to optimize for the common case.

Filesystems have two different types of files: regular files and directories. These two types of files often have very different access patterns, in terms of locality, lifetime of the files, size distribution, and how frequently they are accessed. As a result, it is not uncommon to treat them differently. For example, we may adopt one type of semantics for regular files and another for directories. Or, if periodic updates are used for both, we may choose less frequent write-backs for regular files than for directories, based on the observation that directories are more frequently shared than the individual files in them.

Note that NFS (below) makes the opposite choice for its periodic checks, checking directories less often than regular files, on the rationale that directories are modified less frequently.

## Replication and Partitioning
Fileserver distribution can be accomplished via replication and/or partitioning.

With replication, the filesystem can be replicated onto multiple machines, such that each machine holds all the files.

The benefit of this is that client requests can be load balanced across all machines, which can lead to better performance. In addition, the system overall can be more available. Finally, this system is more fault tolerant. When one replica fails, the other replicas can serve clients with no degradation of service.

The downside of this approach is that writes become more complex. One solution is to force clients to write synchronously to all replicas, returning to the client only once every replica has been updated; this slows down all writes. Another solution involves writing to one replica, and then having a background job asynchronously propagate the write to the other replicas.

If replicas get out of sync, they must be reconciled. One simple reconciliation technique is voting, where the majority wins.

With partitioning, every machine has a subset of all of the files in the system. Partitioning may be based on filename (for example, files a to m on one machine and n to z on another), on directory (partitioning the hierarchical namespace of the directory tree), or on other criteria.

Partitioning achieves greater availability than a single server design: each server holds fewer files, so it can respond to requests for those files more quickly.

The main benefit of this approach is that it allows for better scalability as the size of the filesystem grows. With the replicated approach, adding more machines does not mean that you can support a larger filesystem. With the partitioned approach, more machines does mean more files.

As well, writes are simple. Since a single file only lives on a single machine, writes to that file are localized to that machine.

A main downside of this approach is that when a partition goes down, the data stored on that partition can no longer be accessed.

In addition, balancing the system is more difficult, because we have to take into consideration how the particular files are accessed. If there is a particular file that is more frequently accessed by most clients in the system, we can run into the issue of **hotspots**.

Finally, we can have a solution where the filesystem is partitioned across some axis, and then each partition is replicated some number of times. The degree of replication can differ per partition. For example, partitions of read-only files can be replicated to a greater degree than partitions of files that are also written. Or frequently accessed files can be placed in smaller partitions and less frequently accessed files in larger ones, with different degrees of replication for each, so that overall each machine receives approximately the same number of expected client requests.

### Replication vs. Partitioning Quiz
Consider server machines that can hold 100 files each. Using three such machines, the DFS can be configured using replication or partitioning. How many total files can be stored in each configuration, and what percentage of the total files is lost if one machine fails?

| | Replicated | Partitioned |
|---|---|---|
| Total files | 100 | 300 |
| Files lost if one machine fails | 0% | 33% |

With replication every machine holds all the files, so three machines still hold only 100 files; with partitioning each machine holds 100 different files. When one machine fails, the replicated system still has two machines with all the files, while the partitioned system loses every file stored on the failed machine. Partitioning provides greater scalability, replication provides greater fault tolerance, which is why a mixed approach provides greater flexibility in achieving both size and resiliency.

## Networking File System (NFS) Design
In a **Network File System** (NFS), clients access files across the network, hence the name. NFS is a contribution of the systems researchers at Sun; in fact, one of the reasons protocols like RPC were developed was to help with the use of NFS.

![](https://assets.omscs.io/notes/8EB8E1FB-C4FF-427C-A887-CD2B754A4DE0.png)

Clients request and access files via the VFS, using the same types of file descriptors and operations that they use to access files in their local storage. The VFS layer determines if the file belongs to the local filesystem or whether the request needs to be pushed to the NFS client so that it can be passed to the remote filesystem.

The NFS client interacts with the NFS server via RPC. The NFS server receives the request, forms it into a proper filesystem operation that is delivered to the local VFS. From there, the request is passed to the local filesystem interface. On the server machine, requests coming from the NFS server look identical to filesystem requests coming from any other application running on the server machine.

When an `open` request comes to an NFS server, it will create a file handle. This file handle is a byte sequence that encodes information about the server machine as well as information about the file. This handle will be returned back to the client machine and maintained by the NFS client, which passes it internally with every request the client makes to access the file. If the file is deleted or the server machine dies, this handle becomes stale, and using it results in an error.

On a `write`, the data to be written is carried as part of the RPC request from the client to the server. On a `read`, the data blocks read from the file are the results of the RPC request, passed back to the NFS client and ultimately to the application that issued the read.

### NFS File Handle Quiz
A file handle can become stale. What does this mean: the file is outdated, the remote server is not responding, the file on the remote server has been removed, or the file has been opened for too long?

Answer: only "the file on the remote server has been removed."

- The file being outdated (written by someone else since the client acquired the handle) may be a consistency problem, but it does not produce a stale handle.
- A remote server that is not responding is an RPC layer error, possibly just a network error; it has nothing to do with the file handle.
- The handle does not become stale because the file was open for too long. Some DFSs allow a client to keep a file open only for a limited time, but NFS is not one of them.

## NFS Versions
NFSv3 is stateless, whereas NFSv4 is stateful. Since NFSv4 is stateful, it can support operations like file caching and file locking. Even though NFSv3 is stateless, the implementation typically includes modules that provide certain stateful functionality.

For files that are not accessed concurrently, NFS behaves with session semantics. On `close`, all of the changes made to a file are flushed to the server, and on `open` a check is performed and, if necessary the cached portions of the files are updated.

As an additional optimization, NFS also supports periodic updates, which check whether there have been any changes to the file the client is working with. Using these updates will break the session semantics when there are multiple clients that are concurrently updating a file.

The periods are configurable (periodic updates can even be disabled). By default, they are 3 seconds for files and 30 seconds for directories. The rationale is that directories are modified less frequently, and when modified, the changes are more easily resolved.

NFSv4 incorporates a delegation mechanism where the server delegates to the client all rights to manage a file for a given period of time. This avoids the periodic update checks mentioned above.

With server-side state, NFS can support locking. NFS uses a lease-based mechanism to support locking. When a client acquires a lock, the server assigns a certain time period to the client during which the lock is valid. It is then the clients responsibility to either release the lock within the specified time frame or explicitly extend the lock. This handles client failure: if the client fails, the server sees that its lease has expired and can assign the lock to another client. When the client comes back, or network connectivity is re-established, the client knows its lease expired and it no longer holds a valid lock, so it has to redo whatever changes it was trying to make.

NFSv4 also supports a reader/writer lock called "share reservation". It also support mechanisms for upgrading from being a reader to a writer, and vice versa.

### NFS Cache Consistency Quiz
Which of the following file sharing semantics are supported by NFS in its cache consistency mechanisms: UNIX, session, periodic, immutable, or neither?

Answer: neither (by default).

- Not immutable: NFS allows files to be modified.
- Not UNIX: as a distributed system, NFS does not guarantee that an update to a file is immediately visible.
- NFS aims for session semantics (flush on `close`, check with the server on `open`), but it can be configured to periodically check for intermediate updates during a session, so it is not purely session semantics. If the periodic checks are disabled, NFS behaves with session semantics.
- It is not purely periodic either, because changes still propagate on `close` and are checked on `open`, as with session semantics.

NFS has session-like and periodic-like elements, and which one it resembles depends on how it is configured; by default it is neither purely one nor the other.

## Sprite Distributed File System
![](https://assets.omscs.io/notes/BF2F3D15-E0CE-4DFE-B0DF-EFF69297E33E.png)

Unlike NFS, Sprite was a research DFS rather than a production one, but it was actually built and deployed at UC Berkeley, and people used it. The authors used trace data gathered from users of a real distributed filesystem to understand file access patterns, and used those patterns to justify Sprite's design decisions.

> **Paper (Nelson et al.):** The lecture uses Sprite as a case study in cache consistency, which is one of the paper's two contributions. The other, which the lecture does not cover, is that Sprite's caches vary in size dynamically: the file system and the virtual memory system each manage a pool of physical pages and negotiate over memory by comparing the ages of their oldest pages, so the file cache can grow to occupy most of a client's memory when virtual memory does not need it (Sections 1 and 6). The paper's headline results are about caching's performance payoff, not consistency: client caches let diskless workstations run within 0-12% of workstations with local disks, cut server load by a factor of two or more, and cut network traffic by about a factor of four.

## Sprite DFS Access Pattern Analysis
In the paper on caching in the sprite system, the authors performed a study to see how files are accessed in the production filesystem used by their department.

> **Paper (Nelson et al.):** The access-pattern numbers the lecture attributes to a study of the authors' own filesystem come from the "BSD study" (Section 3), a separate trace-driven analysis of three time-shared VAX-11/780s running 4.2 BSD UNIX [Ousterhout et al., SOSP 1985]. Sprite's designers reused that trace rather than tracing Sprite itself: the paper uses the trace in a simulation (Tables 1 and 2) that feeds each timesharing user into a simulated client to estimate cache-consistency overhead, and again in Section 7 to estimate per-user I/O rates for sizing a Sprite server. A measurement study of Sprite's own production access patterns came later, in Baker et al., "Measurements of a Distributed File System" (SOSP 1991).

They found that 33% of all file accesses are writes. Caching can be an important mechanism to improve performance: 66% of all operations can be improved. In order to leverage the cache for writes as well, a write-through policy is not sufficient.

> **Paper (Nelson et al.):** The paper's figure is "about one-third of all file accesses are writes" (Section 4.3), and the limit it draws is stated as an upper bound: because about a third of accesses are writes, "a caching scheme based on write-through cannot reduce disk or server traffic by more than two-thirds." The two-thirds improvement is a ceiling on what caching can save, not a count of operations that are definitely improved.

Session semantics may have been a good strategy, but the authors also noticed that 75% of files were open less than 0.5 seconds and 90% of files were open less than 10 seconds. This means that the overheads associated with session semantics were still too high.

They also observed that 20-30% of new data was deleted within 30 seconds, with 50% of new data being deleted within 5 minutes. The also observed that file sharing in their system is rare. As a result, the authors decided that write-back on close was not really necessary.

> **Paper (Nelson et al.):** The paper rejects write-on-close with the same open-duration numbers (Section 4.3) but frames file sharing differently. "Rare" sharing is the paper's expectation about Sprite's own write-sharing, used to justify optimizing the consistency algorithm for the no-sharing case (Section 5); the paper does not list sharing frequency among the BSD study's access statistics in Section 4.3. The paper's own write-sharing evidence is the trace-driven simulation in Section 5.3 (Table 1, run on the BSD trace): of all write traffic, 4041 blocks were written through for concurrent write-sharing and 6887 flushed for sequential write-sharing, and consistency accounted for about one-fourth of server traffic.

Of course, the authors needed to support concurrent access even though they didn't need to optimize for it.

## Sprite DFS from Analysis to Design
The authors decided that Sprite should support caching, and use a write-back policy to send changes to the server.

Every 30 seconds, a client will write back all of the blocks that have not been modified within the last 30 seconds. Note that a file may be opened and closed multiple times by the client before any data is sent to the server. There is no write-back on `close`, so a client may have finished with a file and closed it while modified blocks of it remain in its cache. This is one way Sprite optimizes the 33% of accesses that are writes.

The intuition behind this is that blocks that have been more recently modified will continue to be modified. It doesn't make sense to force write-backs on blocks that are likely to be worked on more. This strategy avoids sending the same blocks to the server over and over.

Note that this 30 second threshold is directly related to authors' observation that 20-30% of new data was deleted within 30 seconds.

> **Paper (Nelson et al.):** The paper does not derive the 30-second interval from the 30-second deletion figure. It adopts "a delayed-write policy similar to the one used in UNIX: every 30 seconds, all dirty blocks that haven't been modified in the last 30 seconds are written back" (Section 4.3), which is the UNIX convention (the 30-second sync interval) rather than a value the paper derives from the trace. A block written on a client reaches the server's cache in 30-60 seconds and the disk 30-60 seconds after that. The deletion statistics motivate delayed writes in general: the paper notes that because 20-30% of new data dies within 30 seconds and 50% within 5 minutes, "a policy that delays writes several minutes can substantially reduce the traffic", and it says it plans to experiment with longer intervals. So the trace argues for a longer delay than 30 seconds, not for 30 specifically.

When a client comes along and wants to open a file that is being written by another client, the server will contact the writer and collect all of the outstanding dirty blocks.

Every open operation has to go to the server for this to work. This means that directories cannot be cached on the client: directory-related operations such as looking up, opening, or creating a file cannot be performed using the client cache alone.

> **Paper (Nelson et al.):** Routing every open through the server is a deliberate design choice with a known cost, not just a consequence of the write-back scheme. The consistency algorithm "depends on the fact that the server is notified whenever one of its files is opened or closed, so it can detect when concurrent write-sharing is about to occur," and this "prohibits performance optimizations (such as name caching) that allow clients to open files without contacting the files' servers" (Section 5). Andrew made the opposite choice, using server callbacks so clients can open cached files without contacting the server. The paper estimates (Table 8, Section 8) that adding Andrew-style name caching and callback to Sprite would improve client-visible speed by only a few percent but cut server and network utilization by as much as one-third, potentially letting one server support 50% more clients.

Finally, caching is completely disabled on concurrent writes. In this case, all of the writes will be serialized on the server-side. Because concurrent writes  do not happen frequently, this cost will not be significant.

In summary, Sprite distinguishes between two situations. When writes do not happen concurrently, and clients instead take turns writing to the file over time (sequential write sharing), Sprite allows caching and provides sequential semantics for file sharing. When Sprite determines that a file is being written concurrently by multiple clients (concurrent write sharing), it completely disables caching for that file.

> **Paper (Nelson et al.):** The paper specifies two actions the server takes when it detects concurrent write-sharing during an open (Section 5.1). First, it tells the one client that has the file open for writing, if any, to write all its dirty blocks back; there can be at most one such client. Second, it tells all clients that currently have the file open that the file is no longer cacheable, so they drop its blocks from their caches and send future accesses to the server. Clients that do not currently have the file open but still hold stale blocks are not notified; they take consistency actions the next time they open the file. Disabling is per file and only while sharing is concurrent.

## File Access Operations in Sprite
Assume that we have multiple clients that are accessing a file for reading, and one writer client.

All `open` operations will go through the server.

All of the clients will be allowed to cache blocks. The writer will also have to keep timestamps on each modified block in order to enforce the 30 second write-back policy.

When the writer `close`s the file, the contents will be stored in the writers' cache. Of course, the next `open` will still have to go through the server. This means that the server and the client need to keep some sort of version number in order to stay in sync.

On a per file basis, the client keeps track of:

- cache (overall yes/no)
- cached blocks
- timer for each dirty block
- version number

On a per file basis, the server keeps track of:

- readers
- writer
- version

Let's assume that a new writer comes along after the first writer has closed the file. This is referred to as a **sequential writer**, and this situation is sequential sharing.

In this case, the server contacts the old writer to gather all of the dirty blocks, which is convenient given that the client keeps track of all dirty blocks.

If the old writer has closed the file, the server will update the value of the writer it holds to point to the new writer. At this point, the new writer can proceed and cache the file.

> **Paper (Nelson et al.):** The paper splits sequential write-sharing into two separate problems with two separate mechanisms (Section 5.2). The first is that the opening client may hold out-of-date blocks in its own cache; this is solved by version numbers. The server keeps a version number per file and increments it each time the file is opened for writing; a client stores the version of every file it caches and, on open, flushes its cached copy if its version differs from the server's. The second problem is that the current data may still sit in some other client's cache, because the last writer need not have flushed on close; this is solved by the server tracking the last writer and, on a new open by a different client, telling that last writer to flush its dirty blocks through to the server before the opener reads. The lecture's "contact the old writer and gather dirty blocks" is the second mechanism; the version number does the first, so the two are not the same check.

Let's assume that a third writer comes along and wants to write to the file concurrently with the current writer. This is concurrent sharing.

When the write request comes, the server contacts the current writer to gather the dirty blocks. When the server realizes that this writer hasn't closed the file, the current writer writes back all of its dirty blocks, and the server marks the file not cacheable, disabling caching of the file for everybody.

To enable/disable caching, it makes sense for the server to maintain a cacheable flag on a per file basis.

Both writers will continue to have access to the file, but all operations will have to go through the server.

When a writer closes a file, the server will see it - as every operation goes through the server - and will make the file cacheable again. The remaining clients can then start caching the file again.

> **Paper (Nelson et al.):** The paper contradicts the lecture on this step. It says a non-cacheable file "becomes cacheable again once it is no longer undergoing concurrent write sharing; for simplicity, however, Sprite does not ... re-enable caching for files that are already open" (Section 5.1). In the lecture's scenario the remaining writer still has the file open, so in the paper it would not resume caching until it closes and reopens the file; caching is re-enabled only for later opens. The note's "When a writer closes a file, the server will see it - as every operation goes through the server - and will make the file cacheable again" is the lecture's version.

One unique feature of Sprite is that it dynamically enables and disables caching depending on whether there is sequential write sharing or concurrent write sharing among the clients in the system.
