---
id: secure-computer-systems-10-covert-channels
title: Covert Channels
course: secure-computer-systems
lecture: 10-covert-channels
---

# Covert Channels

## Confinement Problem

The confinement problem is that Alice wants to share data with Bob but wants to prevent Bob from sharing this with Charlie. MAC partially addresses this, Bob cannot write below his security level and therefore cannot share something too sensitive for Charlie.

There are things called **covert channels** which are channels that are not explicitly meant for communication. These channels do not rely on normal information sharing mechanisms and can be used to propagate sensitive information.

TCSEC (the orange book mentioned in week 1) mentions covert channels. Class B1 requires MAC and class B2 requires us to address covert channels.

### Example

Suppose a file can only be read by a single process at a time. We can communicate a single bit (True/False) between a sending and receiving process by having the sending process read a file to represent `True`. In the code below the sending process makes sure it has the file open to send true, and it makes sure the file is closed to send false. The receiving process tries to open the file, if it can't open the file it knows that the sending process has it open and is sending true. This is an example of a covert channel, communication through means not meant for communication.

![](https://assets.omscs.io/secure-computer-systems/images/module10/example.png)

### More Examples

There are two types of covert channels

* **Storage covert channels:** When bits are communicated using storage.
  * Example: A top secret user can make a top secret file. When a user that only has secret clearance tries to read the file they will either get "file does not exist" (this can communicate a 0) or "access denied"(communicate a 1).
  * Our previous example about reading files is also a storage covert channel.
* **Timing covert channels:** When bits are communicated by looking at timing.
  * Example: Two processes are sharing a CPU. This sharing is done through round-robin CPU scheduling. A higher permission process can share information to a lower permission process by spending more or less time when given the CPU. Immediately passing the CPU to the lower permission process can be read as a 0, and taking a full time quantum can be read as a 1. This assumes that there are only two processes sharing the CPU, otherwise there is noise.

**Any shared resource can potentially lead to a covert channel**

## Covert and Side Channels

Covert communication happens over covert channels using mechanisms that are not designed for information transfer. Information can flow from a top secret process to a process that is less privileged by having the less privileged process observe some shared resource (files for example). Any information flow is said to be covert if it is forbidden by the mandatory access control policy.

In the slides a formal definition of **interference** is given, I omit the formalism but give the intuition. We have non-interference when a higher privileged process is entirely unaware of the existence of lower privileged processes.

### Covert Channel vs. Side Channel

With covert channels we assume there is some cooperation where a higher level process is trying to communicate with a lower level process.

With side channels there is no collusion. The higher level process is functioning as it should, the lower level process is inferring sensitive data based on activity it observes performed by the higher level process.

Maybe the lower level process is listening for acoustic or electromagnetic emanations. Maybe it is tracking power consumption to see how long a cryptographic key is.

## What to do about Covert Channels

* **Detection:** We need to determine if covert communication is possible.
* **Estimate Bandwidth:** We should figure out how much data should be communicated per unit of time. Communication can be noisy (recall our timing covert channel example), which decreases the bandwidth.
* **Mitigation:** We can try to decrease bandwidth. Often, not much can be done and covert communication is an unavoidable side effect of resource sharing.

## Covert Channel Detection

The root cause of covert channels is shared resources. You can make a matrix where the rows are TCB variables and the columns are TCB calls. We do this to enumerate the various variables that can be used in covert channels and the calls that modify and read them. 

![](https://assets.omscs.io/secure-computer-systems/images/module10/SRM.png)

A covert channel exists if there exists a path from a more sensitive process $P_1$ to a less sensitive process $P_2$ where $P_1$ modifies a variable that can eventually be read by $P_2$. In the diagram below $M$ is for modify and $R$ is for read.

![](https://assets.omscs.io/secure-computer-systems/images/module10/transitive.png)

## Estimating Covert Channel Bandwidth

We can measure the bandwidth of a covert channel in terms of the number of bits communicated per second. Here's an example with the timing channel previously discussed.

* The scheduler uses a 10ms time quantum.
* Context switch (changing users) takes 100 $\mu\text{s}$
* To communicate a 0 the CPU is immedately released, taking 100 $\mu\text{s}$ for the context switch.
* To communicate a 1 the CPU is released after a full quantum.
  * This takes 10ms + 100 $\mu\text{s}$ = 10.1 ms
* The average time to transfer a bit (assuming the string has equal number of 0 and 1) is (10.1 + .1)/2 ms = 5.1 ms. This is about **200 bits/sec**.

For a storage channel (file does not exist vs. access denied example from previous) we wil need to estimate the system call time, the number of calls required, and time overhead associated with context switch.

### Noise

Noisy channels can lead to bit flips. We can still send information over noisy channels. We could do something like send the same bit 3 times and you choose the bit that was received in the majority of cases.

Here's a formula from information theory:

r = channel rate, p = probability of bit flip

C(r, p) = max capacity with noise = r*(1-H(p))

H(p) = -p*$\log_2$(p) - (1-p)*$\log_2$(1-p)

## Reducing Covert Channel Bandwidth

We can limit resource sharing with **static partitioning**. In the context of task scheduling static partitioning would mean that we take 10ms regardless of if we need the CPU or not. This leads to poor utilization.

### Pump Abstraction

We have a situation where a low process is sending a message to a high process, this is allowed since in BLP we have write up. The high process sends back an "Ack" which is just a confirmation that the message is received, no other information should be transmitted. 

The potential for a covert channel is that the high process modulates when it sends back the ack. Maybe a short time is encoded as a 0 and a long time is encoded as a 1.

![](https://assets.omscs.io/secure-computer-systems/images/module10/ack.png)

To deal with this we place a pump (a non-volatile buffer) in between the high process and the low process. 

![](https://assets.omscs.io/secure-computer-systems/images/module10/ackpump.png)

The pump tracks the moving average of the Ack time from high to pump, and gives the low process an Ack with the same average but with randomly generated times. 

$$\text{AvgTime}_\text{HP}(\text{moving average}) \approx \text{AvgTime}_\text{PL}$$

The ack time is stochastic from the pump to the low process. Sometimes the pump will have to ack before the high process acks to ensure the averages. Sometimes the pump will wait a little bit extra.

## Meltdown and Spectre

Meltdown and Spectre are hardware vulnerabilities, but architecture people might think they are good things that speed up the computer.

These vulnerabilities exploit hardware optimizations like speculative execution. Speculative execution lets you execute an instruction ahead of retiring your current instruction, it speeds things up. An example of speculative execution is branch prediction. We predict which branch an if-statement will go into and begin execution ahead of time. Basically you can use this branch prediction to read kernel memory, there is a paper.

Also the RamBleed system exploits the rowhammer vulnerability to set up a side channel.

