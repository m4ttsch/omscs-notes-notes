---
id: operating-systems-remote-procedure-calls
title: Remote Procedure Calls
course: operating-systems
lecture: remote-procedure-calls
---

# Remote Procedure Calls

**Reference paper**: [Implementing Remote Procedure Calls](https://s3.amazonaws.com/content.udacity-data.com/courses/ud923/references/ud923-birrell-nelson-paper.pdf) - Birrell and Nelson.

**OSTEP chapter**: [48. Distributed Systems](https://pages.cs.wisc.edu/~remzi/OSTEP/dist-intro.pdf)

The IPC mechanisms of the previous lessons only move data among address spaces; they say nothing about the semantics of the operations. RPC is an IPC mechanism that specifies that processes interact via a procedure call interface. The general discussion roughly follows Birrell and Nelson's paper; the lesson then covers SunRPC, a concrete implementation, in more detail.

## Why RPC?
Let's look at two applications. In the first application, the client gets a file from the server. In the second application, the client sends an image to the server for some processing/modification (for example, a grayscale or low-resolution version, or a face detection algorithm).

![](https://assets.omscs.io/notes/3F721352-2899-4EBA-A6B0-6EADB5E2581E.png)

With a socket-based API, the developer has to explicitly create and initialize the sockets, allocate the buffers to be sent, populate them with protocol-related information (such as a "get file" directive and the buffer size), and explicitly copy the data in and out of these buffers.

Note that the setup required for both applications is very similar, even identical at points. The only difference, really, is the request being made from the client to the server, and the data being transmitted.

Almost all programs that implement some kind of basic client/server functionality will require these very similar setup steps, and thus it is productive to simplify this process. In the 1980s, as networks became faster and more distributed applications were developed, this need for simplification gave rise to RPC.

## Benefits of RPC
RPC is intended to simplify the development of interactions across address spaces and machines.

One benefit of RPC is that it offers a high-level interface for data movement and communication, capturing all of its aspects: communication establishment, requests, responses, acknowledgements, and so on. This means that the developer can focus more on what their application does as opposed to the standard boilerplate setup.

RPC also handles a lot of the errors that may arise from low-level communication/transmission interactions, freeing the developer from having to explicitly re-implement error handling in each program.

Finally, RPC hides complexities of cross-machine interactions: that the machines may be of different types, that the network between them may fail, and that the machines themselves may fail.

## RPC Requirements
The model of IPC interactions that the RPC model is intended for needs to match client/server interactions. The server performs some complex tasks. The clients need not have the server's capabilities or access to the same data; they only need to be able to issue requests to the server for whatever they need.

Since most of the languages at the time were procedural languages (hence the name remote *procedure* call), there was an expectation that this model followed certain semantics. As a result, RPCs have synchronous call semantics. When a process makes a remote procedure call, the calling process (or at least the calling thread) will block until the procedure completes and returns the result. This is the exact same thing that happens when we make a local procedure call.

> **Paper (Birrell & Nelson):** The implementation paper adopts the same rule, "the semantics of remote procedure calls should be as close as possible to those of local procedure calls," and follows it even where distributed-systems practice would differ: it provides no time-out limiting a call's duration in the absence of machine or communication failures, because local calls have none (Section 1.4).

RPCs also have type checking. If you pass an argument of the wrong type to an RPC, you will receive some kind of error. Type checking affords us opportunities to optimize the implementation of the RPC runtime. When packets are being sent between two machines, they are just a stream of bytes. Being able to transmit some information about the types can be useful when the RPC runtime is trying to interpret the bytes.

Since the client and the server may run on different machines, there may be differences in how they represent certain data types. For instance, machine may differ in their endianness (whether the most significant byte of an integer comes first or last), in their representation of floating point numbers, negative numbers and so on. The RPC system should hide these differences from the programmer, ensuring that the data is correctly transported and converted.

One way to deal with the conversion is for the RPC runtime, and both endpoints to agree upon a single data representation; for example, that everything is represented in network format. With this agreement, there is no need for endpoints to negotiate on how data should be encoded.

Finally, RPC is meant to be more than a transport-level protocol. RPC should support different types of protocols - whether UDP, TCP or others - to communicate. RPC should also incorporate some higher level mechanisms like access control, authentication, and fault tolerance. For instance, if a server is not responding, a client can retry and reissue the same request, either to the same server or to a replica of it.

## Structure of RPC
The client wants to perform some addition but doesn't know how. The server is the calculator. In this scenario, the client needs to send the operation it wants to perform as well the data needed to perform that operation over to the server. The server contains the implementation of that operation, and will perform it on behalf of the client.

We can use RPC to abstract away all of the low-level communication/transport details.

![](https://assets.omscs.io/notes/22426858-74EF-4124-98ED-80238E938AD4.png)

### Client

With RPC, the client is still allowed to call the function `add` with `i` and `j`, even those the client doesn't hold the implementation of the `add` function.

In a regular program, when a procedure is called, the execution jumps to some other point in the address space where the implementation of that procedure is actually stored. In this example, when the client calls `add`, the execution will also jump to another location in the address space, but it won't be where the implementation of `add` lives. Instead, it will be in a **stub** implementation. To the rest of the process, this stub will look like the real `add`.

The responsibility of the client stub is to create a buffer and populate that buffer with all of the appropriate information - the function name (`add`) and the arguments  `i` and `j` in this case. After the buffer is created, the RPC runtime sends the buffer to the server process. This may be via TCP/IP sockets or some other transport-level protocol.

The stub code itself is automatically generated via some tools that are part of the RPC package; that is, the programmer doesn't have to write the stub code.

### Server

When the packets are received on the server, they are handed off to the server stub. This stub knows how to parse all of the received bytes, and it will be able to determine that this is an RPC request for `add` with the arguments `i` and `j`.

Once this information is extracted, the stub is ready to make a call in the server process to the local `add` function with `i` and `j`.

The server will then create a buffer for the result and send it back to the client via the appropriate connection. The packets will be received by the client stub, and the information will be stored in the client address space.

Finally, the client function will return. The result of the call will be available, and client execution will proceed.

> **Paper (Birrell & Nelson):** The paper names the same arrangement as five pieces of program: the *user*, the *user-stub*, the *RPCRuntime*, the *server-stub*, and the *server*. The user, user-stub, and one RPCRuntime run on the caller machine; the server, server-stub, and another RPCRuntime run on the callee machine. The stubs were generated by a program called *Lupine* from Mesa interface modules; the lecture's generic stub-generation tools are Lupine (Section 1.5). The paper also notes that if user and server were linked directly on one machine without the stubs, the program would still work.

## Steps in RPC
Let's summarize the steps that have to take place in an RPC interaction between a client and a server.

![](https://assets.omscs.io/notes/8E8660BC-CC54-4A5B-8768-7BDF0796BA89.png)

In the first step, a binding occurs. The client finds and discovers the server that supports the functionality it needs. For connection-based protocols (like TCP/IP), the actual connection will be established in this step.

In the second step the client makes the actual RPC call. Control is passed to the stub, blocking the rest of the client.

The client stub then creates a data buffer, and populates it with the arguments that are passed in. This process is called **marshaling**. The arguments may located in noncontiguous memory locations within the client address space. The transport level, however, requires a contiguous buffer for transmission. This is why marshaling is needed.

Once the buffer is available, the RPC runtime will actually send the message to the server, via whatever transmission protocol the client and server have agreed upon during the binding process. This may be TCP, UDP, or even shared memory based IPC if the client and the server are on the same machine.

The data is then received by the RPC runtime on the server machine, which performs all of the necessary checks to determine which server stub the request needs to be delivered to. Access control checks can also be included at this step.

The server stub will **unmarshall** the data, extracting the necessary byte sequences from the buffer and populating the appropriate data structures.

Once the arguments are allocated and set to the appropriate values, the actual procedure call can be made. This calls the implementation of the procedure that is actually part of the server process.

The server will compute the result of the operation (or conclude that an error must be returned), which will be passed to the server side stub and returned to the client.

Note that before the client can bind to the server, the server must do something to let the world know it can be found. The server must execute a registration step to let the world know what procedures it supports, what arguments it requires, and what location (IP address, port number) it can communicated with at.

## Interface Definition Language
When using RPC, the client and the server don't need to be developed together. The can be written by different developers in different programming languages.

For this to work, however, there must be some type of agreement so that the server can explicitly say what procedures it supports and what arguments it requires.

This information is needed so that the client can determine which server it needs to bind with.

Standardizing how this information is represented is also important because it allows the RPC runtime to incorporate some tools that allow it to automate the process of generating the stub functionality.

To address these needs, RPC systems rely on the use of **interface definition languages** (IDLs). The IDL serves as a protocol of how the client-server agreement will be expressed.

## Specifying an IDL
An interface definition language is used to describe the interface that particular server exports. At a minimum, this will include the name of the procedure, the types of the different arguments and the result type.

Another important piece of information to include is a version number. If there are multiple servers that provide the same procedure, the version number helps clients find which server is the most up to date. In addition, version numbers allow clients to identify the server which has the version of the procedure that fits with the rest of the client program. This supports incremental upgrades: clients and servers need not all be upgraded at the same time.

An RPC system can use an IDL that is language-agnostic. **SunRPC** uses an IDL called **eXternal Data Representation** (XDR). XDR is a different specification from any programming language.  An RPC system can also use an IDL that is language-specific. For example, the Java RMI uses Java.

For programmers that know the language, a language-specific IDL is great. For programmers that don't know that language, learning a language-agnostic IDL is simpler than learning a whole new programming language.

Whatever the choice of IDL, the IDL is used solely to define the interface. The IDL is used to help the RPC system generate stubs, generate the marshaling procedures, and generate information that is used in the service discovery process.

The IDL is not used for the implementation of the service.

## Marshaling
To understand marshaling, let's look at the `add` example again, with arguments `i` and `j`.  Initially, `i` and `j` live somewhere in the client address space. When the client calls the add function, it passes in `i` and `j` as discrete entities.

At the lowest level, a socket will need to send a contiguous buffer of information over to the server. This buffer will need to hold a descriptor for the procedure (`add`) to be called on the server, as well as the necessary arguments, `i` and `j`.

This buffer gets generated by the marshaling code.

Generally, the marshaling process encodes the data into an agreed upon format so that it can be correctly interpreted by the server. This encoding specifies the layout of the data upon serialization into a byte stream.

To see why the format needs to be agreed upon, consider a less trivial `array_add` procedure that takes an integer `i` and an array `j` and adds `i` to every element of `j`. Marshaling `i` is straightforward, but the array can be serialized in more than one way. One convention writes the array length first and then the elements; another writes the elements followed by a terminator, which is how strings are handled, with the null character marking the end. Either way, both endpoints must agree on the convention in advance so that the receiver can recover the structure.

![](https://assets.omscs.io/notes/938F6FC8-08F2-4280-B95B-75AFA74E3B4A.png)

## Unmarshalling
In the unmarshalling code, we take the buffer provided by the network protocol and, based on the procedure descriptor and the type of arguments required by the described procedure, we extract the correct chunks of bytes from the buffer and use those bytes to initialize data structures that correspond to the argument types.

As a result of the unmarshalling process, the `i` and `j` variables will be allocated in the server address space and will be initialized to values that correspond to whatever was placed into the buffer sent by the client.

The marshaling/unmarshalling routines are generally not written by the programmer. RPC systems typically include a special compiler that takes an IDL specification and generates the marshaling/unmarshalling routines from that. These generated routines also perform the encoding-related actions, such as how an array is laid out in the byte stream or converting integers from one endianness to another. The programmer just needs to ensure that they link these autogenerated files with their program files.

![](https://assets.omscs.io/notes/CA66D7D2-E21F-484A-A0C5-B87185CE6515.png)

## Binding and Registry
**Binding** is the mechanism used by the client to determine which server to connect to, based on the service name and the version number. In addition, binding is used to determine how to connect to a particular server; basically, to discover the IP address and/or network protocol required for the client/server connection to be established.

To support binding, there needs to be some systems software that maintains a database of all available services. This is often called a **registry**.

A registry is essentially the yellow pages for services: you pass the registry the name of the service and the version you are looking for, and you receive the contact information for the best matching server (matched on protocol, version number, proximity, and so on). This contact information will include the IP address, port, and transport protocol.

At one extreme, this registry can be some distributed online platform where any RPC service can register. Clients then have a well-known contact point for finding the services they need.

On the other hand, the registry can be a dedicated process that runs on every server machine and only knows about the processes running on that machine. In this case, clients must know the machine address of the host running the service, and the registry need only provide the port number that the service is running on.

The registry needs some sort of naming protocol. The simplest approach requires that the client specifies the exact name and version number of the service it requires. A more sophisticated naming scheme may be able to consider synonyms. In this case, requesting the `sum` service might still get you the `add` service.

> **Paper (Birrell & Nelson):** The paper's registry is one concrete point in this design space: binding is done through the *Grapevine* distributed database, which is replicated across several servers rather than running per-machine. A client binds an *importer* of an interface to an *exporter*, naming the interface by *type* (which abstract interface) and *instance* (which particular implementor); an importer that gives only the type is bound to the closest running instance (Section 2.1, Section 2.2). Importing has no effect on the exporter's data structures, which matters for servers with hundreds of users, and a binding is implicitly broken when the exporter crashes and restarts, because a per-export unique identifier is re-checked on every call (Section 2.3).

## Visual Metaphor
Binding and registries can be compared to how a toy shop uses a directory of outsourcing services. Before outsourcing some work (say, assembly of train cars), the manager wants to know who can provide the service, what the specific service details are, and what shipping or packaging options (for instance, UPS) are offered.

An application using RPC goes through the same steps:

- **who provides the service**: the application looks up the registry by service name (for instance, some image processing service) to find the servers that provide it
- **service details**: the registry describes the services each server provides and their version numbers, expressed in an interface definition language so that the interface is described in a standard way
- **shipping options**: the registry also lists the protocols a server supports, such as TCP or UDP

The application uses all of this information to decide which server to bind with, just as the manager uses the answers to decide how to outsource.

## Pointers in RPC
In regular local procedures, it makes sense to allow pointer arguments. The pointer references some address within the address space of both the calling procedure and the called procedure, so the pointer can be dereferenced with no issue.

In RPC, this makes no sense. The pointer points to some particular data in the caller address space, and some arbitrary data in the remote address space.

To solve this problem, an RPC system can disallow pointers to be used an arguments to any RPC procedure.

Another solution allows pointers to be used, but ensures that the referenced data - not the pointer - is marshaled into the transmitted buffer.

On the server side, once the data is unpacked, the unmarshalling code will pass the address of this data to the local procedure.

In this way, RPC allows pointers to be "passed" between the client and the server.

> **Paper (Birrell & Nelson):** The implementation paper does not solve this in the runtime so much as rule it out at stub-generation time: the programmer must avoid arguments or results that are incompatible with the lack of a shared address space, and Lupine checks this avoidance (Section 1.5). It discards emulating a shared address space as too expensive for its hardware (Section 1.4).

## Handling Partial Failures
When a client hangs while waiting on a remote procedure call, it is often difficult to pinpoint the problem.

The server may be overloaded, the client's request may have been lost, the response may have been lost, the server machine may have crashed, the server process may have crashed, or some switch or router in the network may be down.

Even if the RPC runtime incorporates some timeout/retry mechanisms, there are still no guarantees that the problem will be resolved or that the runtime will be able to provide some better insight into the problem. Determining the exact cause may be possible in some cases, but in principle it is too complex, would involve a lot of overhead, and would still be unlikely to give a definitive answer.

RPC systems incorporate a special error notification that tries to capture what went wrong with an RPC request without claiming to provide the exact detail. This serves as a catch all for all types of (partial) failures that can potentially happen during an RPC call. It can also signal a genuinely partial failure, where the call did not cleanly fail and the client simply cannot tell what succeeded and what did not.

<details>
<summary>Quiz: an RPC call fails with a timeout. Which cause can the runtime conclude: client packet lost, server packet lost, network link down, server machine down, server process failed, server process overloaded, all of the above, or any of the above? (spoiler)</summary>

Any one of the listed causes (lost client packet, lost server packet, downed network link, downed server machine, failed server process, overloaded server process) could be responsible, and in principle several could happen at once. From a timeout alone the runtime can conclude only that the failure was *any of the above*; it cannot single out a cause. "All of the above" is possible, since every one of these could hypothetically happen at the same time, but the runtime cannot conclude it, so "any of the above" is the only correct answer.
</details>

> **Paper (Birrell & Nelson):** The paper is precise about the guarantee behind this error. The packet-level protocol defines the call semantics: if the call returns to the user, the server procedure was invoked *exactly once*; otherwise an exception is reported and the procedure was invoked *either once or not at all*, and the user is not told which, nor whether the fault was a server crash or a communication failure (Section 3.1). This "call failed" exception is the primary way clients tell a remote call apart from a local one (Section 3.4).

## RPC Design Choice Summary
The issues above define the design space for an RPC system:

- **binding**: a distributed registry or a per-machine registry
- **IDL**: language-agnostic or language-specific
- **pointers**: disallowed, or allowed with the pointed-to data serialized
- **partial failures**: a special error that tries to capture what went wrong, without guaranteeing a precise answer

Different RPC and RPC-like systems make different choices in this space. The rest of the lesson looks at the choices made by SunRPC and, briefly, at Java RMI.

## What is SunRPC?
SunRPC is an RPC package originally developed by Sun in the 1980s for its Network File System (NFS) on UNIX systems. It is now widely available on other platforms.

SunRPC makes the following design choices.

In SunRPC, it is assumed that the server machine is known up front, and therefore the registry design choice is such that there is a registry per machine. When a client wants to talk to a particular service, it must first talk to the registry on that particular machine.

SunRPC makes no assumption regarding the programming language used by the client or the server. Sun RPC relies on a language-agnostic IDL - XDR - which is used both for the specification of the interface and for the specification of the encoding of data types.

SunRPC allows the use of pointers and serializes the pointed-to data.

SunRPC supports mechanisms for dealing with errors. It includes a retry mechanism for re-contacting a server when a request times out. The number of retries can be specified.

The RPC runtime tries to return meaningful errors as often as possible, so that a caller can at least distinguish between cases such as the server being unavailable, a mismatch or unsupported protocol or version, or a timeout-related failure that covers all other types of failures.

> **Paper (Birrell & Nelson):** SunRPC's retry on timeout (a bounded number of times) sits at a different point on the call-semantics spectrum from the Cedar system this paper describes. Blind retransmission of the whole call gives only *at-least-once* semantics, which is unsafe for non-idempotent procedures, whereas the paper's protocol pairs retransmission with call identifiers and a per-activity sequence number so the callee can discard duplicates, preserving the *exactly-once-on-return* guarantee (Section 3.1, Section 3.2).

**NB**: The ONC RPC standard (RFC 1831 Section 4) makes the dependence on the transport explicit: over an unreliable transport a reply implies the procedure ran *at least once*, a remembered transaction ID can give some degree of *at-most-once*, and only a reliable transport yields *exactly once*.

## SunRPC Overview
SunRPC allows the client to interact via a procedure call interface.

The server specifies the interface that it supports in a .x file written in XDR. SunRPC includes a compiler called **rpcgen** that will compile the interface specified in the .x file into language-specific stub for the client and the server.

On start, the server process registers itself with the registry daemon available on the local machine. The per-machine registry keeps track of the name of the service, the version, the protocol, and the port number. A client must explicitly contact the registry on the target machine in order to obtain the full contact information about the desired service.

When the binding happens, the client creates an RPC handle, which is used whenever the client makes any RPC calls. This allows the RPC runtime to track all of the RPC-related state on a per-client basis.

The client and server processes may be on different machines, or on the same machine. In the latter case RPC works like other forms of IPC, except with higher-level semantics: procedure call semantics.

A more complete reference is the SunRPC tutorial and examples now maintained by Oracle (which purchased Sun in 2010). That documentation refers to **TI-RPC** (transport-independent RPC), in which the protocol used for client/server communication does not have to be specified at compile time but can be chosen dynamically at run time. Otherwise it closely follows the original SunRPC specification and the XDR IDL. The Linux APIs are documented under `man rpc`.

![](https://assets.omscs.io/notes/B8BC74B4-5D1E-498A-AD50-8F3F83984312.png)

## SunRPC XDR Example
Here is the XDR specification for a simple program in which the client sends an integer `x` to the server and the server squares it.

![](https://assets.omscs.io/notes/A4A18EDB-56E6-44B3-975A-E6408F565B64.png)

In the .x file, the server specifies all of the datatypes that are needed for the arguments and the results of the procedures that it supports.

In this case, the server supports one procedure `SQUARE_PROC` that has one argument of the type `square_in`, and returns a result of the type `square_out`.

The datatypes `square_in` and `square_out` are both defined in the .x file. They are both structs that have one member that is an `int`, which is just like the `int`s in C: a 32-bit integer.

In addition to the data types, the .x file describes the actual RPC service and all of the procedures that it supports.

First, there is the name of the RPC service, `SQUARE_PROG`, that will be used by clients trying to find an appropriate service to bind with.

A single RPC server can support one or more procedures. In our case, the `SQUARE_PROG` service supports one procedure `SQUARE_PROC`. There is an ID number associated with a procedure (1 in this case) that is used internally by the RPC runtime to identify which particular procedure is being called. The programmer does not use this number, and the procedure name is not sent between client and server; the packets carry the ID instead.

In addition to the procedure ID, and the input and output data types, each procedure is also identified by a version (1 in this case). The version applies to an entire collection of procedures. Clients and servers reference the version of the procedure being requested, and a server that does not support the requested version can reject the communication. A single server can support multiple versions of the same procedure, so a procedure can be refined, or new procedures added, without upgrading all clients and servers at the same time.

Finally, the .x file specifies a service id (here `0x31230000`). This id is a number that is used by the RPC runtime to differentiate among different services. The developer picks a value from the range allowed for user-defined services (0x20000000 to 0x3fffffff in the ONC RPC standard); the remaining values are either predefined for specific services, such as the network file system, or reserved for future use.

The client will use service name, procedure name, and version number, whereas the RPC runtime will refer to the service id, procedure id, and the version id.

![](https://assets.omscs.io/notes/A052ACC9-7F3E-4DA1-9359-AE681079494B.png)

## Compiling XDR
To generate the client/server C stubs from the interface defined in the .x file, run

```bash
rpcgen -C <interface>.x
```

The outcome of this operation generates several files.

`<interface>.h` contains all of the language specific definitions of the datatypes and the function prototypes.

`<interface>_svc.c` contains the code for the server side stub and `<interface>_clnt.c` contains the code for the client side stub.

The compilation steps also generates `<interface>_xdr.c` which contains code for marshaling/unmarshalling routines that will be used by both the client and the server.

The first part of `<interface>_svc.c` contains the `main` function for the server which includes code for the registration step and also some additional housekeeping operations. The second part contains all of the code that is related to the particular RPC service. This code handles request parsing and argument marshaling.

In addition, the autogenerated code will include the prototype for the actual procedure that is invoked in the server process. This has to be implemented by the developer. For `SQUARE_PROC` this is `square_proc_1_svc`, where `_1` refers to the version number.

The client stub will include a procedure that is automatically generated, `square_proc_1`, and this will represent a wrapper for the actual RPC call that the client makes to the server-side process, where `square_proc_1_svc` is actually called.

Once we have this, the developer can just call the function, with something like `y = square_proc_1(x, ...)`. This looks like a regular procedure call: there is no need to create sockets, create buffers, or copy data into the buffers.

**NB**: The lecture writes these names as `squareproc_1` and `squareproc_1_svc`. `rpcgen` derives them from the lowercased procedure name plus the version, so for `SQUARE_PROC` version 1 the generated names are `square_proc_1` and `square_proc_1_svc`.

![](https://assets.omscs.io/notes/900EBDD1-DB17-45DD-A88F-05F540A29F47.png)

## Summarizing XDR Compilation

![](https://assets.omscs.io/notes/921D2058-0023-44E9-9B95-817573324DA8.png)

To summarize the development steps: the developer writes the .x file and passes it through `rpcgen`, which generates the header, the stubs, the server skeleton, and the `_xdr.c` marshaling routines. On the server side the developer implements the service procedure (`square_proc_1_svc`). On the client side the developer writes the client application and calls the wrapper (`square_proc_1`) wherever needed. Both sides must include the generated `.h` file and link with the stub objects. The RPC runtime, called from the stubs, provides everything else: interactions with the operating system, creating sockets, managing connections, and so on.

By default, `rpcgen` generates code that is not thread safe. Internally, both the generated function and the runtime use statically allocated data structures for the result, which leads to race conditions when multiple threads make RPC calls to this routine concurrently. To generate thread safe code use:

```bash
rpcgen -C -M <interface>.x
```

With `-M` (multithreading safe), `rpcgen` still creates a wrapper function `square_proc_1`, but it has a different signature and a different implementation; for instance, it dynamically allocates memory for the results of the operation.

The `-M` flag doesn't actually give a multithreaded server, rather it ensures that the code produces will be thread safe.

To actual generate a multithreaded server, you can pass the `-A` flag on Solaris. In Linux, a multithreaded server needs to be implemented manually, using the multithreading safe routines as a starting point.

<details>
<summary>Quiz: what is the return type of <code>square_proc_1</code> when square.x is compiled with <code>rpcgen -C</code>, and with <code>rpcgen -C -M</code>? (spoiler)</summary>

- `rpcgen -C`: `square_out *`, as in `square_out *square_proc_1(square_in *, CLIENT *)`. The result lives in statically allocated storage.
- `rpcgen -C -M`: `enum clnt_stat`, as in `enum clnt_stat square_proc_1(square_in *, square_out *, CLIENT *)`. The caller supplies a pointer to where the result is written, and the return value is the RPC call status.

The thread safe and the non-thread safe versions of this function have different prototypes and return different values. (The subtitles transcribe the second flag as `-N`; the solution contrasts the thread safe and non-thread safe versions, which is `-M`.)
</details>

## SunRPC Registry
The code that the server needs in order to register with the registry is autogenerated as part of the `rpcgen` compilation step (in the server's `main` function).

In SunRPC, the registry process runs on every machine, and is called **portmapper**. To start this process on Linux, run

```bash
sudo /sbin/portmap
```

This is the process that needs to be contacted both by the server when it wishes to register its service, and by the client when it needs to find the specific contact information for a given service.

Since the client has already contacted the RPC daemon, it knows the IP address of the server machine. What it learns from portmapper is the port number to use to talk to the server, and whether the required version and protocol are supported.

Once the RPC daemon is running, we can check the services that are running with it using

```bash
/usr/sbin/rpcinfo -p
```

This command will return the program id, version, protocol, socket port number, and service name for every service running on that machine.

Portmapper itself is registered with both TCP and UDP protocols on socket 111: it listens on two different sockets, one TCP and one UDP, that use the same port number, so it can talk to both TCP and UDP clients.

## SunRPC Binding
The binding process is initiated by the client using the following operation

```c
CLIENT* clnt_create(char* host, unsigned long prog, unsigned long vers, char* proto);
```

For the `SQUARE_PROG` service we created above, the call would look like

```c
CLIENT* clnt_handle;
clnt_handle = clnt_create(rpc_host_name, SQUARE_PROG, SQUARE_VERS, "tcp");
```

`SQUARE_PROG` and `SQUARE_VERS` are autogenerated from the compilation of the XDR file and will be included in header file as `#define`'d values. Because the version is a static piece of information, a client that needs to support a different version number must be recompiled; none of the other client code has to change.

The return from this function is the client handle that will be used in every subsequent RPC call. This handle can also be used to track the status of the current request, as well as handle any error messages or authentication related information.

## XDR Data Types
All of the types defined in the XDR file must be XDR-supported data types.

Some of the default XDR data types include:

- char
- byte
- int
- float

XDR also support a `const` datatype which will get compiled into a `#define`'d value in C.

`hyper` values correspond to 64-bit integers and `quadruples` refer to 128-bit floats.

**NB**: The lecture calls `quadruple` a 120-bit float. It is 128 bits (16 bytes): XDR (RFC 4506 Section 4.8) and the Sun/Oracle XDR documentation both define quadruple-precision floating point as 128 bits using the IEEE format.

The `opaque` type corresponds to uninterpreted binary data, similar to the C byte type. For instance, if you wanted to transfer an image, that image could be represented as an array of opaque elements.

XDR support two types of arrays: fixed-length and variable-length. A fixed length array looks like `int data[80]`. Since the exact number of elements is specified, the RPC runtime knows how much memory to allocate whenever arguments of this type are sent or received, and exactly how many bytes to read from the incoming packet stream.

A variable-length array looks like `int data<80>`. The number in angle brackets is not the actual length but the maximum expected length. When compiled, this will translate into a data structure that has two fields: an integer `len` that corresponds to the actual size of the array, and a pointer `val` that is the address of where the data in this array is actually stored.

When the data is sent, the sender has to specify `len` and set `val` to point to the memory location where the data is stored. On the receiving end, the server will know that it is expecting a data structure that is of variable length, so it will know to read the first four bytes to determine the length to determine the size of the array, and then to allocate the appropriate amount of memory and copy the remaining portion of the incoming byte stream into that buffer.

The only exception to this is strings. A variable-length `string` compiles to a C `char *`. In memory, strings are stored as normal null-terminated strings, because operations like `strcpy` and `strlen` need that representation to find the end of the string. When the string is encoded for transmission, it will be stored as a pair of `len` and `data`, identical to other variable-length data types.

<details>
<summary>Quiz: in-memory size of a full variable-length <code>int</code> array of max size 5 on a 32-bit machine (spoiler)</summary>

The compiled struct has `len` (a 4-byte integer) and `val` (a 4-byte pointer on a 32-bit machine), plus the five 4-byte integers the pointer refers to: 4 + 4 + 20 = 28 bytes.
</details>

## XDR Routines
The marshaling/unmarshalling routines will all be found in the `<interface>_xdr.c` file.

In addition, the compiler will generate some cleanup operations, like `xdr_free` that will be used to free up memory regions that are allocated by the various RPC operations.  These routines will typically be called within a procedure named `*_freeresult` (for example, `square_prog_1_freeresult`). This is another user-defined procedure where the user can specify the pieces of state that need to be deallocated after the runtime is done servicing the RPC request. The RPC runtime will automatically call this procedure after it is done computing the results.

## Encoding
Since the server can support multiple programs, versions, and procedures, it is not enough just to pass procedure arguments from client to server.

RPCs must also contain information about the service procedure id, version number and request id (so that repeated requests on retries can be detected) in the header of the request. This header will be included in the response from the server as well.

In addition to these metadata fields, we clearly need to put the actual data (arguments or results) onto the wire. These datatypes are encoded into a byte stream which depends on the data type.

There may be a 1-1 mapping between how the data is represented in memory and how it is represented on the wire, but this may not always be the case. What is important is that the data is encoded in a standard format that can be deserialized by both the client and server.

Finally, the packet of data needs to be preceded by the transport header (TCP/UDP) in order to actually be sent along the wire in accordance with these transmission protocols.

## XDR Encoding
In addition to providing an IDL, XDR also defines an encoding; that is, the binary representation of our data "on the wire".

All data types are encoded in multiples of four bytes. Encoding a single byte argument therefore would take a single byte for the data and 3 bytes of padding. This helps with alignment when moving data between memory, the network packets, and the network card.

Big endian is used as the transmission standard. Regardless of the endianness of the client or the server, every communication will require that the data be converted to the big endian representation prior to transmission, and then, if necessary, converted on receipt to the endianness of the target machine. When both machines are, say, little endian, this is pure overhead, but a standard agreement means there is never any ambiguity about the encoding used on the wire.

Other encoding rules include:

- two's complement representation of integers
- IEEE format for floating point numbers

For example, suppose the .x file defines a variable-length string of up to 10 characters, and the argument `"hello"` is passed from client to server. In the address space of a C process this takes 6 bytes: 5 for the characters and 1 for the null terminator. On the wire it is encoded in 12 bytes: 4 bytes for the length (5), 5 bytes for the characters `h-e-l-l-o` (the null terminator is not transmitted), and 3 bytes of padding to reach a 4-byte boundary.

![](https://assets.omscs.io/notes/FF850174-AB55-4111-82DD-59CE3A9C98A7.png)

<details>
<summary>Quiz: on-the-wire size of a full variable-length <code>int</code> array of five elements (spoiler)</summary>

Encoding writes 4 bytes for the length followed by the five 4-byte integers: 4 + 20 = 24 bytes. No padding is needed because every field is already a multiple of four bytes, and this excludes any RPC header or protocol bytes. The in-memory figure differs (28 bytes) because the wire form carries the length and the data but not the pointer.
</details>

## Java RMI
Another popular RPC-like system is **Java Remote Method Invocations** (Java RMI).

This system was also pioneered by Sun as a form of client/server communication methods among address spaces in the JVM.

Since Java is a an object-oriented language, and entities interact via method invocations, not procedure calls, the RPC system is appropriately called RMI instead.

Since all clients and servers are written in Java, and the RMI system is meant for address spaces in JVMs, the IDL is language-specific to Java.

As in RPC, the client and server have stubs; in RMI the server-side stub is called a **skeleton**.

The RMI runtime is separated into two components.

The **Remote Reference Layer** contains all of the common code needed to provide reference semantics. For instance, it can support unicast (a client interacting with a single server), or broadcast (a client interacting with multiple servers). In addition, this layer can specify different return semantics, like *return-first-response* and *return-if-all-match*.

This functionality is implemented the same way regardless of the underlying transport protocol, which is why RMI separates it into its own layer. A developer can simply specify the desired reference semantics, or, for something exotic, implement just this layer while the rest of the system stays the same.

The **Transport Layer** implements all of transport protocol-related functionality, whether TCP, UDP, shared memory or something else.

The lesson mentions Java RMI only for completeness and does not discuss it in detail.
