---
id: information-security-midterm-2-study-guide
title: Midterm 2 Study Guide
course: information-security
lecture: midterm-2-study-guide
---

# Midterm 2 Study Guide

## Chapter 7: Denial-of-Service Attacks

**Multiple Choice**

SYN spoofing attack targets \___.

- A. Email service
- B. TCP connections table
- C. DNS service
- D. None of the above

<details>
<summary>Answer</summary>

B

**Source**

Stallings, 4th Edition, Section 7.1, page 227
</details>

**Multiple Choice**

What is a _poison packet_?

- A. A packet that triggers a bug in the network software and makes it crash.
- B. A packet that contains the signature of a virus.
- C. A packet that infects other packets in the network buffer.
- D. A packet that redirects other packets to a malicious target.

<details>
<summary>Answer</summary>

A

**Source**

Text pg 226
</details>

**Multiple Choice**

What is a _cyber slam_?

- A Cyber slam is a made up term.
- B. Another name for a DDoS attack.
- C. A firewall packet strategy that helps to thwart a DoS or DDoS attack.
- D. A large number of queries that severely load a server.

<details>
<summary>Answer</summary>

D

**Source**

Text pg 226
</details>

**Multiple Choice**

If an attacker directs a large number of forged requests to a server, what type of attack is being made?

- A. Slowloris
- B. Source address spoofing
- C. SYN spoofing
- D Reflector
- E Amplifier

<details>
<summary>Answer</summary>

C

**Source**

Text pg 230
</details>

**True or False?**

ICMP flood attacks remain common because some ICMP packets are critical to normal network behavior and cannot be filtered.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 233
</details>

**Multiple Choice**

What is the difference between a TCP SYN flood attack and a SYN spoofing attack?

- A. There is no difference, they are synonymous.
- B. The difference is in the volume of packets.
- C. SYN spoofing works with UDP only.
- D. TCP SYN flood attacks don't use spoofed source addresses.

<details>
<summary>Answer</summary>

B

TCP SYN flood attacks may or may not use spoofed addresses, but the difference is in the volume of packets sent, meant to overwhelm the server. The SYN spoofing attack is meant to overwhelm the server in sending SYN-ACK messages to spoofed (preferably not invalid) addresses.

**Source**

Text pg 231 and 234
</details>

**Multiple Choice**

What type of attack is based on sending a large number of INVITE requests with spoofed IP addresses to a server?

- A. Reflection attack
- B. Smurf attack
- C. Slashdot attack
- D. SIP flood attack

<details>
<summary>Answer</summary>

D

**Source**

Text pg 236, pg 241
</details>

**True or False?**

The best defense against a reflection attack is to not allow directed broadcasts to be routed into a network.

<details>
<summary>Answer</summary>

False

The description is the best defense for an Amplification attack. To defend against a reflection attack, filtering to block spoofed-source packets.

**Source**

Text pg 241, 242
</details>

**True or False?**

A characteristic of reflection attacks is the lack of backscatter traffic.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 241

</details>

**Multiple Choice**

What are some ways to prevent SYN spoofing attacks?

- A. Use SYN cookies
- B. Modify the size of the TCP connections table or timeout period
- C. Impose rate limits on network links
- D. Use selective or random dropping of TCP table entries
- E All of the above
- F None of the above

<details>
<summary>Answer</summary>

E

**Source**

Text pg 246
</details>

**True or False?**

Slowloris uses a ping flood via ICMP echo request packets.

<details>
<summary>Answer</summary>

False

That is the _smurf_ attack. Slowloris exploits servers that use multiple threads by sending multiple incomplete connections (by not including the terminating newline sequence) to a server.

**Source**

Text pg 238, 242
</details>

**True or False?**

In a TCP spoofing attack, attacker ideally wishes to use addresses that will not respond to the SYN-ACK with a RST.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 231
</details>

**Multiple Choice**

A recursive HTTP flood attack is also known as what?

- A. a Fraggle attack
- B. a Delayed Binding attack
- C. a Spidering attack
- D. a SIP flood

<details>
<summary>Answer</summary>

C

bots start from a given HTTP link and then follows all links on the provided website in a recursive way. This is also called spidering.

**Source**

Text pg 237
</details>

## Chapter 9: Firewalls and Intrusion Prevention Systems

**Multiple Choice**

When it comes to defense against attacks one of the most important principle is what?

- A.	Authorization
- B.	Authentication
- C.	Defense-in-depth
- D.	Time

<details>
<summary>Answer</summary>

C

**Source**

Defense in Depth in lecture
</details>

**Multiple Choice**

Firewalls are what type of mechanisms?

- A.	Prevention
- B.	Botnet
- C.	Attack
- D.	None of the above

<details>
<summary>Answer</summary>

A

**Source**

Defense in depth lecture
</details>

**True or False?**

The firewall will enforce different security restrictions on traffic.

<details>
<summary>Answer</summary>

True

**Source**

What is a Firewall
</details>

**Multiple Choice**

A _____ is a device that provide secure connectivity between networks

- A.	Enterprise intranet
- B.	Trusted Users
- C.	Firewall
- D.	DMZ

<details>
<summary>Answer</summary>

C

**Source**

What is a Firewall
</details>

**Multiple Choice**

Firewalls as a prevention mechanism should be designed to enforce what?

- A.	User safety
- B.	Security Policy
- C.	Organizational Policy
- D.	Public Key Infrastructure

<details>
<summary>Answer</summary>

B

**Source**

Firewall
</details>

**True or False?**

All traffic from internal network to the internet and vice versa (external and out of the network) must pass through the firewall

<details>
<summary>Answer</summary>

True

**Source**

Firewall
</details>

**Multiple Choice**

The critical component of planning and implementation of a firewall is specifying a suitable ____ policy?

- A.	Security
- B.	Access
- C.	Network
- D.	Directory

<details>
<summary>Answer</summary>

B

**Source**

Firewall Access Policy
</details>

**Multiple Choice**

At a high level the types of traffic that are allowed through the access policy is what?

- A.	Address ranges (Machines, protocols, the applications and the contents)
- B.	IPSec & TLS
- C.	Intranet
- D.	Defense in depth

<details>
<summary>Answer</summary>

A

**Source**

Firewall Access Policy
</details>

**True or False**

A policy should not be developed based on the security and risk assessment/organizations needs but how the CEO thinks it should be.

<details>
<summary>Answer</summary>

False

It should be based on the whole organization

**Source**

Firewall Access Policy
</details>

**True or False?**

Firewalls always provide protection 100% of the time.

<details>
<summary>Answer</summary>

False

The firewall isn't 100% secure.

**Source**

(Firewall limitations)
</details>

**True or False?**

Firewalls can log all traffic and can provide Network Address Translation.

<details>
<summary>Answer</summary>

True

**Source**

Additional Convenient Firewall Features
</details>

**Multiple Choice**

What is firewall filtering?

- A.	Firewall filtering is when policies are defined for the firewall
- B.	Firewalls authenticate users into the system
- C.	Firewall filtering means the firewall decides whether to let the traffic through or not
- D.	Firewall filtering means whether it will allow for a defense in depth strategy to protect the organizations digital assets.

<details>
<summary>Answer</summary>

C

**Source**

Firewalls and Filtering
</details>

**True or False?**

Packet filtering at a very high level is essentially a policy that has a set of access control lists based on packet types.

<details>
<summary>Answer</summary>

True

**Source**

Filtering types
</details>

**Multiple Choice**

Session filtering is based on the context within a session. In order to do this a firewall maintains a session or connection and performs a __________.

- A.	Traffic Block
- B.	Stateful inspection
- C.	DMZ re route
- D.	Virtual Switch

<details>
<summary>Answer</summary>

B

**Source**

Filtering types
</details>

**True or False?**

In a packet filtering firewall decisions are made on a per packet basis and not other packets.


<details>
<summary>Answer</summary>

True

**Source**

Packet filtering
</details>

**True or False?**

The packet filtering firewall applies a list of rules to match the IP or TCP header of a packet and based on the rules match the firewall and then to decide to forward or discard the packet.

<details>
<summary>Answer</summary>

True

**Source**

Packet Filtering Firewall

IP or TCP header information that a firewall can use to filter a packet:
- Source IP address (where the packets are coming from)
- Destinations IP address (this is the IP for the destination)
- Source and destination transport-level address (This defines the port number and applications such as smtp, http)
- IP Protocol field (this defines TCP , UDP or ICMP)
- Interface (this is with three or more ports with which interface the packet came or where it is going to.)
</details>

**Multiple Choice**

What policies for packet filtering firewalls are used?

- A.Default Discard Policy
- B. Default forward policy
- C. Default Isolation Policy
- D. Default write down policy
- E. C & B
- F. A & B

<details>
<summary>Answer</summary>

F

**Source**

Packet Filtering Firewall

When there is no rule that matches the packet it will be discarded this is safe procedure but also a hindrance to users who see that some traffic isn't allowed.

Forward policy is easier to use and manage and use but less secure it just lets all packets in.
</details>

**Multiple Choice**

What are the weaknesses to packet filtering?

- A. Limited logging functionality
- B. Vulnerable to attacks that take advantage of TCP/IP
- C. Can't Prevent attacks that employ application specific vulnerabilities or functions
- D.Packet filter firewalls are susceptible to security breaches if improperly configured.
- E. All of the above

<details>
<summary>Answer</summary>

E

**Source**

Packet Filtering
</details>

**Multiple Choice**

Packet Filtering Firewall Countermeasures are all of the following **except**?

- A. IP Address Spoofing
- B. Source Routing Attacks
- C. Tiny Fragment Attack
- D. Stateful inspection Attack

<details>
<summary>Answer</summary>

D

**Source**

Packet filtering firewall countermeasures are A,B,C

IP Address Spoofing countermeasures: Discard packets with an inside source address if the packet arrives on an external interface

Source Routing Attacks: Discards all packets in which the source destinations specifies to the route

Tiny Fragment Attack: Enforcing a rule that the first fragment of a packet must contain a predefined minimum amount of the transport header.

In textbook

IP address spoofing: The intruder transmits packets from the outside with a source IP address field containing an address of an internal host. The attacker hopes that the use of a spoofed address will allow penetration of systems that employ simple source address security, in which packets from specific trusted internal hosts are accepted. The countermeasure is to discard packets with an inside source address if the packet arrives on an external interface. In fact, this countermeasure is often implemented at the router external to the firewall.

Source routing attacks: The source station specifies the route that a packet should take as it crosses the Internet, in the hopes that this will bypass security measures that do not analyze the source routing information. A countermeasure is to discard all packets that use this option.

Tiny fragment attacks: The intruder uses the IP fragmentation option to create extremely small fragments and force the TCP header information into a separate packet fragment. This attack is designed to circumvent filtering rules that depend on TCP header information. Typically, a packet filter will make a filtering decision on the first fragment of a packet. All subsequent fragments of that packet are filtered out solely on the basis that they are part of the packet whose first fragment was rejected. The attacker hopes the filtering firewall examines only the first fragment and the remaining fragments are passed through. A tiny fragment attack can be defeated by enforcing a rule that the first fragment of a packet must contain a predefined minimum amount of the transport header. If the first fragment is rejected, the filter can remember the packet and discard all subsequent fragments.
</details>

**True or False?**

Firewalls can only be one single computer system.

<details>
<summary>Answer</summary>

False

**Source**

Firewalls can be a set of two or more systems (Page 290)
</details>

**Multiple Choice**

The goals of a firewall are all the following except which?

- A.	All traffic from inside to outside and vice versa must pass through the firewall. This is achieved by physically blocking all access to the local network except via the firewall.
- B.	Only authorized traffic as defined by the local security policy will be allowed to pass.
- C.	Only unauthorized users are defined by the local security policy and will be allowed to pass.
- D.	The firewall is immune to penetration

<details>
<summary>Answer</summary>

C

**Source**

Page 290…. It should also be noted that since the firewall itself is immune to penetration this implies the use of a hardened system with a secured operating system.
</details>

**True or False?**

A major component in the planning and implementation of a firewall is specifying an access policy.

<details>
<summary>Answer</summary>

True

**Source**

(True Page 290 This lists the types of traffic authorized to pass through the firewall, including address ranges, protocols, applications, and content types. This policy should be developed from the organization's information security risk assessment and policy)
</details>

**Multiple Choice**

A firewall access policy would use which of the following to filter traffic?

- A.	IP Address and Protocol values
- B.	Application Protocol
- C.	User Identity
- D.	Network Activity
- E.	All of the Above

<details>
<summary>Answer</summary>

E

**Source**

Page 290-291
IP Address and Protocol Values-This controls access based on the source and destination IP address and port numbers, direction of flow (either inbound or outbound). This type of filtering is used with packet filter and stateful inspection firewall designs. This practice is used to limit access to a specific service.
Application Protocol- This controls access on the basis of authorized application protocol data. This type of filtering is used by application-level-gateway that relays and monitors the exchange of information for specific application protocols (for example SMTP, HTTP (email and web requests) for authorized users)
User Identity- Controls Access based on user identity typically for inside users who identity themselves use secure authentication such as IPSec
Network Activity- Controls the access based on: time or request such as only during businesss hours, rate of request etc.
</details>

**Multiple Choice**

The following are all in the scope of a firewall except which?

- A.	Firewalls are a single choke point that attempts to keep unauthorized users out of the network, prohibit potential vulnerable services from entering or leaving the network and provide protection from various kinds of IP spoofing or routing attacks.
- B.	Firewalls provide a location for monitoring security-related events
- C.	Firewalls fully protect against internal threats which include disgruntled employee.
- D.	Firewalls allow for several internet functions that are not security related also to happen such as Network Address Translators and Network management function.
- E.	A firewall can serve as a platform for IPSec. Firewalls can be used to implement VPN's as well

<details>
<summary>Answer</summary>

C

**Source**

this is a limitation of the firewall Page 291
A firewall defines a single choke point that attempts to keep unauthorized users out of the protected network, prohibit potentially vulnerable services from entering or leaving the network, and provide protection from various kinds of IP spoofing and routing attacks. The use of a single choke point simplifies security management because security capabilities are consolidated on a single system or set of systems.
A firewall provides a location for monitoring security-related events. Audits and alarms can be implemented on the firewall system.
A firewall is a convenient platform for several Internet functions that are not security related. These include a network address translator, which maps local addresses to Internet addresses, and a network management function that audits or logs Internet usage.
A firewall can serve as the platform for IPSec. Using the tunnel mode capability described in Chapter 22, the firewall can be used to implement virtual private networks.
Firewalls have their limitations, including the following:
The firewall cannot protect against attacks that bypass the firewall. Internal systems may have wired or mobile broadband capability to connect to an ISP. An internal LAN may have direct connections to peer organizations that bypass the firewall.
The firewall may not protect fully against internal threats, such as a disgruntled employee or an employee who unwittingly cooperates with an external attacker.
An improperly secured wireless LAN may be accessed from outside the organization. An internal firewall that separates portions of an enterprise network cannot guard against wireless communications between local systems on different sides of the internal firewall.
A laptop, PDA, or portable storage device may be used and infected outside the corporate network, then attached and used internally.
</details>

**True or False?**

A web proxy is a form of application-level gateway.

<details>
<summary>Answer</summary>

True

**Source**

Lecture, Application Level Gateway
</details>

## Chapter 8: Intrusion Detection

**Multiple Choice**

Intrusion is what?

- A. Any attack that aims to compromise the security goals of an Organization
- B. Any attack that is hidden from a user
- C. A form of detection which users are able to see everyone on the network
- D. A form of encryption which allows end to end security.

<details>
<summary>Answer</summary>

A

**Source**

Intrusion Examples
</details>

**True or False?**

Intrusion Detection systems are part of the defense in depth strategy

<details>
<summary>Answer</summary>

True

**Source**

Intrusion Detection Systems (IDS)
</details>

**Multiple Choice**

Defense in depth strategies should include the following **except** what?

- A. Encrypting sensitive information
- B. Intrusion detection systems
- C. Detailed audit trails
- D. Strong authentication and authorization controls
- E.  Zero day exploits
- F. Actively management of operating systems
- G. Application security

<details>
<summary>Answer</summary>

E

**Source**

Intrusion Detection systems
</details>

**Multiple Choice**

What is the correct order for how an attacker behaves during intrusion:

- A. Maintaining Access this is important because an attack may not be a onetime action they may install backdoors or other malicious software on a target system so they can continue to access.

- B. Information Gathering System Exploit this is when an attacker has already gained sufficient privilege on a system and he or she can find out more about the network and the organization or even move to another target system to further exploit on the network.

- C. Covering Tracks: This is when the user makes sure there is no evidence of them on the system this can be done by disabling or even editing the system audit logs to remove evidence of attack activities. Alternatively, the user can install a root kit to hide the installed malware.

- D. Privilege Escalation this is taken after initial access ad the attacker will try to use a local exploit to escalate its privilege form from normal user to root on target system.

- E. Initial Access this is accomplished by exploiting a remote network vulnerability.

- F. Target acquisition and information gathering this is when the attacker identifies the target system using publicly available information both technical and non-technical and they also use network tools to analyze target resources.

<details>
<summary>Answer</summary>

The order for these values are:
F, E, D, B, A, C

**Source**

Intruder Behavior
</details>

**True or False?**

The key design elements for an intrusion detection system is examining network and group activities

<details>
<summary>Answer</summary>

False

The key design elements of an intrusion detection system is examining network and user activities

**Source**

Elements of Intrusion Detection
</details>

**True or False?**

From an algorithmic perspective models capture intrusion evidence meanwhile features piece evidence together.

<details>
<summary>Answer</summary>

False

From the Point of view of a detection algorithm we need to find out how to represent data from:
Features- capture intrusion evidences
Models – piece evidences together

**Source**

Elements of Intrusion Detection
</details>

**Multiple Choice**

Which of the components is not part of an Intrusion detection system?

- A. Data preprocessor
- B. Detection Models
- C. Detection Engines
- D. Decision Table
- E. Reporting and Analytics
- F. Decision Engine

<details>
<summary>Answer</summary>

E

**Source**

Components of an IDS lecture
</details>


**True or False?**

Anomaly detection tries to detect what is normal and is using machine learning meanwhile Signature detection uses a database to identify virus patterns.

<details>
<summary>Answer</summary>

True

**Source**

Lectures
</details>

**True or False?**

Another name for an intruder is a hacker or a cracker.

<details>
<summary>Answer</summary>

True

**Source**

Lectures & PG 252
</details>

**Multiple Choice**

An IDS is comprised of three logical components which of the following is not a component:

- A. Analyzers
- B. User interface
- C. Deep Learning
- D. Sensors

<details>
<summary>Answer</summary>

C

Deep learning is not part of the IDS logical component the IDS is composed of the following
Sensors: Sensors are responsible for collecting data. The input for a sensor may be any part of a system that could contain evidence of an intrusion. Types of input to a sensor includes network packets, log files, and system call traces. Sensors collect and forward this information to the analyzer.

Analyzers: Analyzers receive input from one or more sensors or from other analyzers. The analyzer is responsible for determining if an intrusion has occurred. The output of this component is an indication that an intrusion has occurred. The output may include evidence supporting the conclusion that an intrusion occurred. The analyzer may provide guidance about what actions to take as a result of the intrusion. The sensor inputs may also be stored for future analysis and review in a storage or database component.

User interface: The user interface to an IDS enables a user to view output from the system or control the behavior of the system. In some systems, the user interface may equate to a manager, director, or console component.

**Source**

Page 256
</details>

**Multiple Choice**

In an IDS system the sensors do what?

- A. Determine if an intrusion has occurred
- B. Allow users to view the output of the system
- C. Provide guidance about what actions to take when the intrusion occurs.
- D. Collect and forward information to the analyzer

<details>
<summary>Answer</summary>

D

**Source**

PG 256
</details>

**True or False?**

Analyzers are responsible for determining if an intrusion has occurred. The output of this component is an indication that an intrusion has occurred. But the output 100% of the time doesn't include evidence supporting the conclusion that an intrusion has occurred.

<details>
<summary>Answer</summary>

False

The analyzer output may include evidence supporting the conclusion that an intrusion occurred. The analyzer may provide guidance about what actions to take as a result of the intrusion.

**Source**

Page 256
</details>

**True or False?**

Intrusion Detection Systems are only allowed to use a single sensor.

<details>
<summary>Answer</summary>

False

IDS can use multiple sensors across a range of host and network devices sending information to a centralized analyzer and user interface in a distributed architecture.

**Source**

Page 256
</details>

**True or False?**

One of many intruder behaviors is Maintaining Access.  This is done by adding a machine code backdoor that is hard to detect.  Detection is difficult because the backdoor modifies machine level code.

<details>
<summary>Answer</summary>

True

**Source**

Lecture notes
Object Code Backdoors- This backdoor is hard to detect because it modifies machine code.
</details>

**Multiple Choice**

Match the appropriate Intrusion Detection classification to its correct value
- I. Monitors characteristics of a single host and the events occurring within the host
- II.Monitors Network Traffic for particular network segments or devices
- III. Combines information from multiple sensors often both host and network based and dumps the information into a central analyzer

- A. Distributed or Hybrid IDS is III,  Network-based IDS is I and Host based IDS is II
- B. Network-based IDS is II, Host-Based IDS is I and Distributed IDS is III
- C. Host-Based IDS is III, Network based IDS is I and Host based IDS is I
- D. There are no other IDS architectures just one Host-Based IDS

<details>
<summary>Answer</summary>

B

Host-based IDS (HIDS): Monitors the characteristics of a single host and the events occurring within that host, such as process identifiers and the system calls they make, for evidence of suspicious activity.

Network-based IDS (NIDS): Monitors network traffic for particular network segments or devices and analyzes network, transport, and application protocols to identify suspicious activity.

Distributed or hybrid IDS: Combines information from a number of sensors, often both host and network-based, in a central analyzer that is able to better identify and respond to intrusion activity.

**Source**

Page 257
</details>

**True or False?**

In the context of IDS systems a false negative is when a authorized user is identified as an intruder and a false positive is identified where intruders are not identified as intruders.

<details>
<summary>Answer</summary>

False

**Source**

> Thus, a loose interpretation of intruder behavior, which will catch more intruders, will also lead to a number of false positives, or false alarms, where authorized users are identified as intruders. On the other hand, an attempt to limit false positives by a tight interpretation of intruder behavior will lead to an increase in false negatives, or intruders not identified as intruders. Thus, there is an element of compromise and art in the practice of intrusion detection.

Page 257
</details>

**True or False?**

The base-rate fallacy of IDS states that if the numbers of intrusions are low compared to the number of legitimate uses of a system then the false alarm rate will be high unless the test is extremely discriminating

<details>
<summary>Answer</summary>

True

**Source**

Page 258
</details>

**Multiple Choice**

Anomaly detection involves the collection of data relating to a behavior over a period of time. Then once the data is collected the data is analyzed to determine whether or not the behavior is legitimate or not. An issue with Anomaly detection can be what?

- A. High false positive rate
- B. High False negative rate
- C. Both High false positive and negative rates
- D. Low false positive rate

<details>
<summary>Answer</summary>

A

**Source**

Lecture Notes & Pg 259
</details>

**True or False?**

Signature or Heuristic detection uses a set of pre-defined malicious data patterns or attack rules that are compared with current behavior to decide if it is that of an intruder.

<details>
<summary>Answer</summary>

True

This statement above is correct and this approach can only identify known attacks for which is has patterns or rules

**Source**

Pg 259
</details>

**Multiple Choice**

The disadvantages of locating a honeypot in an internal network are:

- a) It has little or no ability to trap internal attackers and it cannot detect a misconfigured firewall.
- b) If it is compromised, it can attack other internal systems and its location requires the outer firewall to permit traffic through its filters.
- c) It puts more load on the external firewall and on the resources of the internal system.
- d) It leads to honey files, which are malicous byproducts of the prolonged use of the honeypot.
- e) It leads to a honey do list, which can ruin a Saturday.

<details>
<summary>Answer</summary>

B

**Source**

Text pg 279
</details>

**Multiple Choice**

Which of the following is not listed as a desired quality of an IDS?

- A. Be able to scale to monitor a large number of hosts.
- B. Be able to monitor itself and detect if it has been modified by an attacker.
- C. Be able to be configured to the policies of the system it is monitoring.
- D. Impose a minimal overhead on the system.
- E. Be able to recover from crashes and reinitializations.
- F. Require static configuration, so changes in configuration require a system restart.
- G. Be able to adapt to changes in system and user behavior over time.
- H. Provide graceful degradation of service in the event that some components of the IDS stop working.

<details>
<summary>Answer</summary>

F

The IDS should allow dynamic reconfiguration -- the ability to reconfigure the IDS without restarting it.

**Source**

Text pg 258
</details>

**True or False?**

The SNORT system is a signature-based NIDS.

<details>
<summary>Answer</summary>

False

The SNORT system is a rule-based NIDS. A large collection of rules exist for it to detect a wide variety of network attacks.

**Source**

Text pg 261
</details>

**True or False?**

A key limitation of anomaly detection approaches used by many IDS's is that they are generally only trained with legitimate data.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 261
</details>

**Multiple Choice**

The advantages of __________________ anomaly detection include relative simplicity and low computation cost, and lack of assumptions about behavior expected. Disadvantages include difficulty in selecting suitable metrics, and that all behaviors can't be modeled using this approach.

- A. Statistical
- B. Knowledge based
- C. Machine-learning
- D. Heuristic
- E. Signature

<details>
<summary>Answer</summary>

A

**Source**

Text pg 259
</details>

**Multiple Choice**

A key disadvantage of _______________ anomaly detection is the significant time and computational resources needed.

- A. Statistical
- B. Knowledge based
- C. Machine-learning
- D. Heuristic
- E. Signature

<details>
<summary>Answer</summary>

C

**Source**

Text pg 259
</details>

**Multiple Choice**

The advantages of ______________ approaches include their robustness and flexibility. A disadvantage is the difficulty and time required and the need for expert assistance.

- A. Statistical
- B. Knowledge based
- C. Machine-learning
- D. Heuristic
- E. Signature

<details>
<summary>Answer</summary>

B

**Source**

pg 259
</details>

**True or False?**

Signature detection would be suitable to detect buffer overflows, password guessing, or malware transmission attacks.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 271
</details>

**True or False?**

Anomaly detection would be suitable to detect policy violation attacks.

<details>
<summary>Answer</summary>

False

Signature detection is better suited.

**Source**

Text pg 271
</details>

**True or False?**

Signature detection would be suitable to worm attacks.

<details>
<summary>Answer</summary>

False

Anomaly detection is better suited.

**Source**

Text pg 271
</details>

## Chapter 2: Cryptographic Tools

**True or False?**

Symmetric Encryption relies on a public and private key meanwhile asymmetric encryption relies on a shared key between two parties

<details>
<summary>Answer</summary>

False

**Source**

Lectures
</details>

**Multiple Choice**

There are two schemes to attack a symmetric encryption scheme. What are they?

- A. Cryptanalysis & Brute-Force attacks
- B. Cryptanalysis & DDoS
- C. Brute-force attack and CipherText
- D. Cryptanalysis & Caesar

<details>
<summary>Answer</summary>

A

There are two general approaches to attacking a symmetric encryption scheme. The first attack is known as cryptanalysis. Cryptanalytic attacks rely on the nature of the algorithm plus perhaps some knowledge of the general characteristics of the plaintext, or even some sample plaintext-ciphertext pairs. This type of attack exploits the characteristics of the algorithm to attempt to deduce a specific plaintext or to deduce the key being used. If the attack succeeds in deducing the key, the effect is catastrophic: All future and past messages encrypted with that key are compromised.

The second method, known as the brute-force attack, is to try every possible key on a piece of ciphertext until an intelligible translation into plaintext is obtained.

**Source**

Page 32
</details>

**True or False?**

The most commonly used asymmetric encryption are block ciphers. They are DES, Triple DES and AES.

<details>
<summary>Answer</summary>

False

These are symmetric encryption algorithms.

**Source**

Page 33
</details>

**Multiple Choice**

The two categories of concern about DES fall into two categories. What are they?

- A. 128 bit encryption and the algorithm itself (i.e. its cryptanalysis)
- B. The Key length of 56 bits and 256 bit encryption
- C. The key length of 56 bits and the cryptanalysis of the algorithm
- D. All of the above

<details>
<summary>Answer</summary>

C

**Source**

Page 33

</details>

**True or False?**

The main reason most companies go with 3DES is because the algorithm is relatively faster in software compared to normal DES and AES

<details>
<summary>Answer</summary>

False

The principal drawback of 3DES is that the algorithm is relatively sluggish in software.

**Source**

Pg 35

</details>

**Multiple Choice**

If Alice wants to send verification of her identity, she can send a message encrypted with her ________________ and anyone with her ______________ can verify that it was from her.

- A. secret key, secret key
- B. public key, private key
- C. hash function, private key
- D. private key, public key

<details>
<summary>Answer</summary>

D

Alice can send a message using her private key, and anyone knowing her public key can verify that.

**Source**

P2_L5 Notes, page 10
</details>

**True or False?**

If you want to achieve the highest level of privacy and reliability, it is often best to use a new or unpublished encryption algorithm.

<details>
<summary>Answer</summary>

False

It practice, we should always use the widely known and deployed algorithms and standards.

**Source**

P2_L5 Notes, pg 9
</details>

**True or False?**

A digital envelope is a technique for attaching a one-time key that encrypts a message to the receiver's public key.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 55
</details>

**True or False?**

The primary advantage of a block cipher is that block ciphers are almost always faster and use far less code than do stream ciphers.

<details>
<summary>Answer</summary>

False

**Source**

Text pg 35
</details>

** Multiple Choice **

All but one of the following situations are examples were Message Authentication confidentiality would not be preferable. Select that situation.

- A. When a message or notification is broadcast to many different users.
- B. When the receiver is expecting a message from the sender, or when both the user and sender have the same access privileges.
- C. When the system for either the sender or recipient are heavily loaded and cannot afford the time to encrypt.
- D. When authenticating a computer program, allowing it to execute without having to perform a decryption each time.

<details>
<summary>Answer</summary>

B

**Source**

Text pg 37
</details>

** Multiple Choice ** 

Which of the following is not a characteristic that is sought in random (or pseudo random) numbers used in cryptography?

- A. The overall distribution of numbers is normal or approximately normal.
- B. Values are statistically independent of one another.
- C. The sequence is unpredictable.

<details>
<summary>Answer</summary>

A

The values should be _uniformly distributed_.

**Source**

Text pg 55
</details>

**True or False?**

It is possible to for a computer chip to use software to generate true random numbers.

<details>
<summary>Answer</summary>

True

The Intel DRNG, offered on multi-core chips since 2012, uses thermal noise within the silicon to output a random stream of bits.

**Source**

Text pg 56 and https://software.intel.com/en-us/articles/intel-digital-random-number-generator-drng-software-implementation-guide

</details>

**True or False?**

So called _data at rest_ is often not encrypted, but it should be encrypted.

<details>
<summary>Answer</summary>

 True

**Source**

Text pg 57
</details>

**Multiple Choice**

Under which of the following situations would Message Authentication confidentiality NOT be preferable?

- A. Encryption software is slow.
- B. Hash functions are irreversible
- C. Encryption hardware is not inexpensive.
- D. Encryption hardware is geared toward larger data sizes.
- E. Encryption algorithms may be patent protected.

<details>
<summary>Answer</summary>

B

**Source**

Text pg 41
</details>

**Multiple Choice**

What are some uses of hash functions?

- I. Message encryption
- II. Message authentication
- III. Creating Digital Signatures
- IV. Password encapsulation
- V. Intrusion detection

- A. I, II, and III
- B. All of the choices
- C. I, III, and V
- D. II, IV, and V
- E. All except I.
- F. All except IV.

<details>
<summary>Answer</summary>

E

**Source**

Text pg 44
</details>

## Chapter 20: Symmetric Encryption and Message Confidentiality
**True or False?**

A symmetric cipher is characterized by ciphertext that is the same size as the original plaintext.

<details>
<summary>Answer</summary>

False

It can be characterized by the use of a shared secret key.

**Source**

Text pg 31 (Chapter 2)
</details>

**True or False?**

For applications such as file transfer, email, and database, a stream cipher may be more appropriate.

<details>
<summary>Answer</summary>

False

A block cipher may be more appropriate for applications that deal with large blocks of data. Stream ciphers may be more appropriate for data in web browsers or data communications channels.

**Source**

Text pg 620
</details>

**True or False?**

A number of attacks against RC4 have been published, but if a large enough key is used, none of those attacks are practical.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 622
</details>

**True or False?**

RC4 is a very fast and simple to explain, and it allows for variable key lengths.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 620
</details>

**Multiple Choice**

Which of the following is _not_ among the ways two users can arrange to exchange keys?

- A. If the two parties have recently used a key, they can transmit the old key, using the new key to encrypt.
- B. A third party could physically deliver the key to the second party.
- C. If the two parties have an encrypted connection to a third party, the third party can deliver the key.
- D. None of the above answers are correct.

<details>
<summary>Answer</summary>

A

**Source**

Text pg 628
</details>

**Multiple Choice**

Which of the following defines a _Session Key_?

- A. A key used between entities for the purpose of distributing keys.
- B. A one-time key used to communicate between two end systems.
- C. The authority that determines which systems are allowed to communicate with each other.
- D. A shared key that is used in Asymmetric encryption standards such as RSA.

<details>
<summary>Answer</summary>

B

**Source**

Text pg 628
</details>

**Multiple Choice**

How can 3DES be used to decrypt DES encrypted ciphertext?

- A. By setting Key1 = Key2 and Key3 = Key_DES
- B. By setting Key1 = Key2 = Key3 = Key_DES
- C. By setting Key3 = Key_DES
- D. By setting Key1 = Key3 and Key2 = Key_DES.

<details>
<summary>Answer</summary>

B

**Source**

Text pg 612,  P2_L6 Notes pg 8
</details>

**Multiple Choice**

In a public-key system using RSA, you intercept the ciphertext C=10 sent to a user whose public key is e=5, n=35. What is the plaintext M (as an integer)?

- A. 50
- B  25
- C. 17
- D. 30
- E. 5

<details>
<summary>Answer</summary>

B

n=35, so p = 7 and q = 5, so phi(n) = 6x4 = 24, so d = e^-1 mod phi(n) = 5, since 5x5 = 25 = 1 mod 24, M = C^d (mod N) = 10^5 mod 35 = 5

**Source**

Text pg 658, problem 21.8
</details>

**Multiple Choice**

Consider a Diffie-Hellman scheme with a common prime q=11 and a primitive root $\alpha$=2. If user A has public key YA=9, what is A's private key XA?

- A. 6
- B. 4
- C. 10
- D. 5
- E. 2

<details>
<summary>Answer</summary>

A

YA = 2^x mod 11 = 9, by inspection, 2^6 = 64 mod 11 = 9, so x = 6 = private key

**Source**

Text pg 653 and pg 658 problem 21.12
</details>

**True or False?**

The structure and functions used in SHA-1 and SHA-2 are substantially different from those used in SHA-3.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 639
</details>

**Multiple Choice**

The CTR cipher block mode _does not_ have which of the following advantages listed, according to the text?

- A. Simplicity
- B. Preprocessing capability
- C. Software efficiency
- D. Hardware efficiency
- E. Scalability
- F. Random Access capability
- G. Provable Security

<details>
<summary>Answer</summary>

E

**Source**

Text pg 627
</details>

**True or False?**

It is possible to convert any block cipher into a stream cipher.

<details>
<summary>Answer</summary>

True

Using the Cipher Feedback Mode

**Source**

Text pg 625
</details>

## Chapter 21: Public Key Cryptography and Message Authentication

**True or False?**

AES is a Feistel cipher.

<details>
<summary>Answer</summary>

False

**Source**

https://www.tutorialspoint.com/cryptography/advanced_encryption_standard.htm
</details>

**True or False?**

The primary advantage of a block cipher is that block ciphers are almost always faster than stream ciphers.

<details>
<summary>Answer</summary>

False

**Source**

Text pg 35
</details>

** Multiple Choice **

What is the main reason 3DES uses an encrypt-decrypt-encrypt sequence?

- A. It makes it more difficult to crytanalyze by eavesdroppers.
- B. It is faster than encrypt-encrypt-encrypt would be.
- C. It can decrypt DES encrypted messages.
- D It is easier to use with cipher block chaining.

<details>
<summary>Answer</summary>

C

**Source**

Text pg 611
</details>

** Multiple Choice **

Which of the following is not a mode of operation used in Cipher blocks?

- A. Random Bit Optimization
- B. Electronic Code Book
- C. Cipher Feedback
- D. Output Feedback
- E. Counter

<details>
<summary>Answer</summary>

A

**source**

Text pg 622
</details>

** Multiple Choice **

Which of the following is the weakest form of attack?

- A. Chosen Plaintext
- B. Chosen Ciphertext
- C  Known Plaintext
- D  Ciphertext Only
- E. Chosen Text

<details>
<summary>Answer</summary>

D

**Source**

https://notes.shichao.io/cnspp/ch2/
</details>

** Multiple Choice **

What is RC4?

- A. A stream cipher.
- B. A symmetric block cipher
- C An asymmetric block cipher.
- D. A set of standards used in Internet encryption.

<details>
<summary>Answer</summary>

A

**Source**

Text pg 619
</details>

**True or False?**

CTR mode is used for timing, for example, to ensure that encrypted streams remain in sync with one another.

<details>
<summary>Answer</summary>

False

**Source**

Text pg 627
</details>

** Multiple Choice **

What operation does the Diffie-Hellman algorithm use as a one way function?

- A. Discrete exponentiation
- B. Elliptical Key Cryptography.
- C. Discrete logarithms
- D. Hashing functions.

<details>
<summary>Answer</summary>

C

**Source**

Text pg 653
</details>

**Multiple Choice (True or False?)**

OCB offers Authenticated Encryption (T/F?).
It used 3DES to encrypt messages. (T/F?)
Its structure is similar to ECB mode, which makes it vulnerable to repeated messages. (T/F?)
It uses the same key for authentication and encryption. (T/F?)

- A. True, True, True, True
- B. True, False, True, False
- C. False, False, False, False
- D. True, False, False, True
- E. False, False, False, True
- F. True, True, False, False
- G. None of these are choices are correct.

<details>
<summary>Answer</summary>

G

T, F, (it uses AES) F (while it's structure is similar to ECB, it uses an offset xor'ed with PT in each block), T

**Source**

Text pg 646
</details>

**True of False?**

The MD5 hash function, despite being susceptible to the birthday attack, is suitable for HMAC.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 643
</details>

**True of False?**

RSA can be used for both encryption and key exchange, but DSS cannot.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 656
</details>

**True or False?**

If someone finds an efficient way to factor large integers, then AES will be obsolete.

<details>
<summary>Answer</summary>

False

**Source**

P2_L6 Notes, pg 20
</details>

**True or False?**

The Certification Authority is responsible for generating the public keys.

<details>
<summary>Answer</summary>

False

**Source**

https://www.youtube.com/watch?v=JAgaWJivKwg (about 3:55)
</details>

**Multiple Choice**

HMAC treats the SHA function as a black box. What benefits does this have?

- I. The hash algorithm used in HMAC is hidden from hackers.
- II. It is easy to replace the given hash function.
- III. HMAC code can be prepackaged and ready to use without modification.

- A. I and II
- B. I and III
- C. II and III
- D. I, II, and III

<details>
<summary>Answer</summary>

C

**Source**

Text pg 641
</details>

**True of False?**

Using the Pigeonhole Principle, given that a hash can take an input of any size and output a value of fixed size, then it should have collisions.

<details>
<summary>Answer</summary>

True

**Source**

Notes: P2_L8  - Hashes, pg 5
</details>

**True or False?**

The Pigeonhole Principle can be used as a counterexample to the Collision Resistance property of hashes.

<details>
<summary>Answer</summary>

False

While the Pigeonhole Principle says there exist collisions, the collision resistance property says that it is computationally infeasible to find them. So even though collisions exist, they are hard to find, thus keeping the collision resistance property of hashes intact.

**Source**

Notes P2_L8 - Hashes pg 5
</details>

**Multiple Choice**

From the birthday "paradox", if the length of the hash is _x_ bits, then a hacker would have to search 2^(x/2) messages in order to find a collision. In doing so, what is the probability, approximately, that the hacker will find a collision?

- A. nearly 100%
- B. about 75%
- C. about 66%
- D. about 50%
- E.  about 25%
- F. less than 25%

<details>
<summary>Answer</summary>

D

The approximate 2^(n/2) = sqrt(2^n) gives the probability of about 50% that the hacker will find at least 1 match.

So it's misleading to say that the hacker would have to search 2^(n/2) messages to "find a match". This would only give the hacker better than 50% chance of finding it without some more strategic choices.

**Source**

Notes P2_L8 - Hashes pg 4
</details>

**True or False?**

SHA-1 allows message sizes as large as 2 terabytes.

<details>
<summary>Answer</summary>

True

That's quite an understatement, though. SHA-1 holds messages up to 2^64 bits, which is a (2^21)*(2^43), , so the answer is more like up to a _2 million terabytes_. And SHA-384 and SHA-512 accept messages of that size _squared!_ (2^128)

**Source**

Notes P2_L8 - Hashes pg 7
</details>

**True or False?**

A truly ideal hash function should be nondeterministic.

<details>
<summary>Answer</summary>

False

You want to be able to always get the same hash for a given input, hence, it must be deterministic.

**Source**

https://en.wikipedia.org/wiki/Cryptographic_hash_function
</details>

**Multiple Choice**

What is the main advantage of ECC compared to RSA?

- A. Its technique is not as difficult to explain.
- B. Hackers have not shown interest in it.
- C. Its theory has been around for a long time.
- D. It offers equal security with smaller key size.

<details>
<summary>Answer</summary>

D

(A and B are the _opposite_ of being true, and C is a true statement, but it's not relevant here.

**Source**

Text pg 656
</details>

**True or False?**

Diffie-Hellman Key Exchange is, on its own, completely vulnerable to a man in the middle attack.

<details>
<summary>Answer</summary>

True

It is vulnerable because it does not _authenticate_ the participants.

**Source**

Text pg 656
</details>

**True or False?**

In attacks on RSA, it has been demonstrated that if the public key _d_ is less than _n_ and the private key _d_ is less than the fourth root of n, then _d_ can be "easily determined".

<details>
<summary>Answer</summary>

True

**Source**

Text pg  650
</details>

**True or False?**

According to the text, the largest product of primes that has been factored to date was over 200 decimal digits long.

<details>
<summary>Answer</summary>

True

In fact, it was 232 digits long, and that was done in late 2009.

**Source**

Text pg 650
</details>

**Multiple Choice**

Name all simple countermeasures for a timing attack:

- I. Ensure all exponentiations take the same amount of time before returning results
- II. Ensure true random numbers, and not pseudo random numbers, are used.
- III. Add a random delay to the exponentiation algorithm.
- IV. Ensure that all operations are optimized.
- V. Multiply the ciphertext by a random number before performing exponentiation.

- A. All choices: I, II, III, IV, and V.
- B. I, III, and V.
- C. II and IV.
- D. I, II, III, and IV.
- E. II, III, IV, and V.

<details>
<summary>Answer</summary>

B

**Source**

Text pg 652
</details>

**True or False?**

Blinding, or multiplying ciphertext by a random number before performing exponentiation during RSA encryption, incurs a 2 to 10% performance penalty.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 652
</details>

**Multiple Choice**

All hash functions operate using these two principles: (select two)

- I. The size of the input is greater than the size of the output
- II. The input is viewed as a sequence of n-bit blocks.
- III. The input value is "randomized" to overcome regularities.
- IV. Ciphertext does not change when blocks are permuted.
- V. Input is processed one block at a time in an iterative fashion.

- A. I and II
- B. I and III
- C. II and III
- D. II and V
- E. III and IV
- F. III and V

<details>
<summary>Answer</summary>

D

**Source**

Text pg 635
</details>

**True or False?**

SHA-512 is more efficient than SHA-256 on many 64-bit systems.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 637
</details>

**True or False?**

SHA-512 makes use of constants derived from the first 64 bits of fractional parts of cube roots of the first 80 (one for each round) prime numbers.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 639
</details>

**Multiple Choice**

A longitudinal redundancy check is reasonably effective for random data as a data integrity check. It uses which bitwise function?

- A. XOR
- B. MOD
- C. NOT
- D. LOG
- E. EXP
- F. OR
- G. AND
- H. Circular Shift

<details>
<summary>Answer</summary>

A

**Source**

Text pg 635

</details>

## Chapter 23: Internet Authentication Applications

**Multiple Choice**

What are the principal elements of a Kerberos system?

- I. AS
- II. TGT
- III. TGS

- A. I, II, and III
- B. I and II only
- C. I and III only
- D. II and III only

<details>
<summary>Answer</summary>

C

**Source**

Text pg 685 (see image)
</details>

**Multiple Choice**

What of the following are steps Kerberos uses to ensure security and authentication?

- A. It includes a timestamp to prevent replay attacks.
- B. It sets a lifetime on TGTs.
- C. It uses short-lived authenticators encrypted with session keys.
- D. It encrypts the TGT with the server key to prevent alteration.
- E. All of the above
- F. Duh

<details>
<summary>Answer</summary>

E

**Source**

Text pg 686 and https://www.youtube.com/watch?v=2WqZSZ5t0qk
</details>

**Multiple Choice**

What is an authenticator, as used by Kerberos?

- A. A software application that verifies a user's identity.
- B. An encrypted message which contains the ID, the address of the user, and a timestamp.
- C. An application that creates a one-time password that authenticates a user.
- D. A server which contains the IP, user ID, and user password, used for authentication.
- E. None of the above.


<details>
<summary>Answer</summary>

B

**Source**

Text pg 686

</details>

**True of False?**

The Authentication Server holds a copy of symmetric keys for all clients and servers.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 686
</details>

**True of False?**

The TGT includes a key ("ticket") that gives the client access to the requested service.

<details>
<summary>Answer</summary>

False

**Source**

Text pg 686
</details>

**True or False?**

The user cannot read the TGT, she only passes it forward along with other information, to the TGS.

<details>
<summary>Answer</summary>

True

**Source**

Text pg (you guessed it) 686
</details>

**Multiple Choice**

The set of keys and and user ID's / passwords in a Kerberos network (i.e., a full-service Kerberos environment consisting of a Kerberos server, a number of clients, and a number of application servers) are known as ______________.

- A. a realm.
- B. a session.
- C. a dictionary.
- D. an organization
- E. a Kerberos policy.

<details>
<summary>Answer</summary>

A

**Source**

Text pg 688
</details>

**True or False?**

PKI is defined as the set of hardware, software, people, policies, and procedures needed to create, manage, store, distribute, and revoke digital certificates based on symmetric cryptography.

<details>
<summary>Answer</summary>

False

Change _symmetric_ to _asymmetric_, and it's true!

**Source**

Text pg 694
</details>

**Multiple Choice**

Which of the following is _not_ a long-known problem with the X-509 PKI model?

- A. There is not a standardized set of trust stores used by all browsers and operating systems.
- B. The user is sometimes relied upon to make an informed decision regarding certificate trust.
- C. All CA's in the trust store are assumed to be equally trusted, well managed, and applying equal policies.
- D. The trust certificates shared in the trust store are not encrypted.

<details>
<summary>Answer</summary>

D

**Source**

Text pg 694
</details>

**Multiple Choice**

What is a trust store?

- A. A database of IP addresses of known trusted servers.
- B. A list of CA's and their public keys.
- C. A CA that issues authentication certificates.
- D. A single internationally specified hierarchy of government regulated CAs.

<details>
<summary>Answer</summary>

B

**Source**

Text pg 694
</details>

**True or False?**

Kerberos provides _both_ authentication _and_ access control.

<details>
<summary>Answer</summary>

True

**Source**

Notes P2_L9 Security Protocols, pg 15
</details>

**True or False?**

The authenticator is a program that checks the user's TGT versus the value on file.

<details>
<summary>Answer</summary>

False

The authenticator checks the user's identifying information and time stamp using the session key.

**Source**

P2_L9 - Security Protocols, pg 14
</details>

**Multiple Choice**

How does Trudy, the (wo)man in the middle, initiate a mutual authentication reflection attack between two users, Bob and Alice?

- A. She tricks Bob into sharing Alice's public key with her.
- B. She tricks Bob into solving a challenge response from Alice.
- C. She tricks Alice into sending her challenge twice.
- D. She simply re-sends the challenge response that she intercepted from Alice, back to her.

<details>
<summary>Answer</summary>

B

**Source**

Notes P2_L9 - Security Protocols, pg 7

</details>

**Multiple Choice**

What is a major shortcoming of using a pairwise key exchange based on a shared secret (key)?

- A. It does not scale well.
- B. It lacks computational security.
- C. Session keys expire after a set time.
- D. It is vulnerable to the man in the middle attack.

<details>
<summary>Answer</summary>

A

As new users are added, each must share a new pair of master keys. The number of keys increases rapidly as users are added.

**Source**

Notes P2_L9 Security Protocols pg 10
</details>

**True or False?**

In Kerberos, the localhost must store the user's password (or password hash) after retrieving the session key from the key distribution center.

<details>
<summary>Answer</summary>

False

**Source**

P2_L9 Security Protocols, pg 13
</details>

**Multiple Choice**

What are some reasons a user would revoke a certificate before it expires?

- I. A key has been compromised.
- II. Upgrades require a new key.
- III. The key has been duplicated.

- A. I, II, and III
- B. I and II only
- C. II and III only
- D. I and III only
- E  I only

<details>
<summary>Answer</summary>

B

**Source**

Text pg 692
</details>

**True or False?**

Conventional X.509 certifications have validity periods of months to years.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 692
</details>

## Chapter 22: Internet Security Protocols and Standards

**Multiple Choice**

Which of the following features does MIME add to the original RFC 822 Internet Mail Format?

- I. New header fields to define information about the body of the message.
- II. Cryptographic message syntax to sign, authenticate, digest, or encrypt message content.
- III. Context formats to standardize representations for support of multimedia email, such as images, audio and video.
- IV. The ability to sign and encrypt email messages.

- A. I, II, III, and IV.
- B. I, II, and IV.
- C. I and III.
- D. II and IV
- E. None of these

<details>
<summary>Answer</summary>

C

II and IV are features added by S/MIME.

**Source**

Text pg 661
</details>

**Multiple Choice**

What is the main difference between _signed data_ and _clear signed data_?

- A. Signed data allows users without S/MIME capability to view message content, but clear signed data does not.
- B. Clear signed data uses base 64 encoding, signed data uses does not.
- C. Clear signed data is not authenticated, signed data is.
- D. Clear signed data allows users to use PKI, signed data requires users to apply a private key.
- E. None of the above are correct.

<details>
<summary>Answer</summary>

E

If you switch _clear signed data_ and _signed data_ in answer A, it would be correct. ; )

**Source**

Text pg 664
</details>

**Multiple Choice**

What is _radix 64 encoding_ (aka _base 64 encoding_)?

- A. Encryption that is optimized for use with 64 bit computers.
- B. Encoding that uses binary logarithmic functions (radix base 2) to map input to output values.
- C. Encoding that maps binary data to ASCII characters.
- D. Encoding that encrypts a message using the receiver's 64 bit private key.
- E. None of the above are correct.

<details>
<summary>Answer</summary>

C

**Source**

Text pg 663
</details>

**True or False?**

The basic tool that permits the wide scale use of S/MIME is a pseudo random key generator.

<details>
<summary>Answer</summary>

False

The tool is a _public key certificate_ that conforms to X509v3 standards.

**Source**

Text pg 664
</details>

**Multiple Choice (Matching)**

Match the Internet mail acronym to the function. (Put the letters in order that match the acronym):

Acronyms:
- 1. MUA
- 2. MSA
- 3. MTA
- 4. MDA
- 5. MS

Definitions:

- AA. Transfers the message from the message handling agent to the message store.
- BB. Typically referred to as a client email program or a local network email server.
- CC. A long term repository, possibly on a remote server that is accessed by POP or IMAP.
- DD. Relays mail between others of its kind, adding trace information to the message header, until the message reaches the next step.
- EE. Accepts the message and enforces policies of the hosting domain and Internet standards.

Choices:

- A. AA, BB, CC, DD, EE
- B. BB, EE, DD, AA, CC
- C. AA, EE, CC, DD, BB
- D. CC, EE, BB, AA, DD
- E. DD, BB, CC, EE, AA

<details>
<summary>Answer</summary>

B

**Source**

Text pg 665
</details>

**True or False?**

A primary difference between DKIM and S/MIME is that in the former, the message is signed transparently using the private key of the admin domain from the originator, whereas the latter requires the originator's private key.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 665
</details>

**True or False?**

For most modern users of email, most incoming and outgoing mail is encoded using S/MIME.

<details>
<summary>Answer</summary>

False

**Source**

Text pg 665
</details>

**True or False?**

TLS sessions avoid the need for updating security parameters for each connection.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 668
</details>

**Multiple Choice**

Why is a random parameter sent along with client_hello message during phase 1 of a TLS handshake?

- A. It is used as a nonce which is combined with a security key.
- B. It prevents an eavesdropper from replaying the message.
- C. It is used to to exchange a key using the Diffie-Hellman protocol.
- D. It is sent to confuse bots to prevent a DDoS attack.
- E. It is part of legacy code, sent to allow back compatibility.

<details>
<summary>Answer</summary>

B

**Source**

Text pg 670
</details>

**Multiple Choice**

What is the basic tool that permits the widespread use of S/MIME?

- A. Public-key certificates
- B. HMAC
- C. MIME
- D. DKIM
- E. SMTP

<details>
<summary>Answer</summary>

A

**Source**

Text pg 664
</details>

**True or False?**

The SSL Record protocol provides both confidentiality and message integrity.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 669
</details>

**True or False?**

The Heartbleed vulnerability was due to a design flaw that was discovered in the TLS specification.

<details>
<summary>Answer</summary>

False

It was due to a programming mistake in the commonly-used OpenSSL library.

**Source**

Text pg 673
</details>

**Multiple Choice**

Which of the following statements concerning benefits of IPSec is false?

- A. IPSec is transparent to applications.
- B. No need to train users.
- C. IPSec can ensure that a routing update is forged.
- D. IPSec can ensure that a routing advertisement comes from an authorized router.

<details>
<summary>Answer</summary>

C

It can ensure the update is _not_ forged, i.e., that it is authentic.

**Source**

Text pg 677
</details>

**Multiple Choice**

Who signs the message to authenticate when DKIM is used?

- A. MUA
- B. MSA
- C. MTA
- D. MS
- E. MDA

<details>
<summary>Answer</summary>

B

**Source**

Text pg 667
</details>

**True or False?**

When ESP is used in IPSec transport mode, the packet payload and ESP trailer are encrypted, but the ESP header is not encrypted.

<details>
<summary>Answer</summary>

True

The header gives security information such as which algorithm or secret key was used.

**Source**

P2_L10+IPSEC+and+TLS notes, pg 5
</details>

**True or False?**

The Security Policy Database and the Security Association Database are maintained in separate tables.

<details>
<summary>Answer</summary>

True

**Source**

P2_L10+IPSec+and+TLS.pptx, slide 20 reviewer notes
</details>

**True or False?**

The SA is a two-way relationship between a sender and receiver, defined by IPSec parameters.

<details>
<summary>Answer</summary>

False

It is a one-way relationship -- one SA for inbound traffic, and another for outbound traffic.

**Source**

P2_L10+IPSec+and+TLS notes, pg 8
</details>

**True or False?**

In default mode, if a pre-shared key is compromised during phase 2 of Internet Key Exchange, then all IPSec keys previously computed are compromised.

<details>
<summary>Answer</summary>

True

If perfect forward security is required, then for each IPSec SA, the shared key along with new public components from Diffie-Hellman and new nonce values are used, protecting previously generated keys.

**Source**

P2_L10+IPSec+and+TLS notes pg 14
</details>

**Multiple Choice**

Which IPSec mode offers end-to-end security protection?

- A. ESP Mode
- B. IKE Mode
- C. Tunnel Mode
- D. TLS Mode
- E. Transport Mode

<details>
<summary>Answer</summary>

E

**Source**

Lesson 19 lecture video: Concept 7
</details>

**Multiple Choice**

What is done if the sequence number in the IPSec header of a packet is less than the the maximum sequence number minus the sliding window value?

- A. The packet is rejected.
- B. The packet is replayed.
- C. The packet is returned.
- D. The packet is accepted.
- E. The packet is forwarded.

<details>
<summary>Answer</summary>

A

The packet is rejected to prevent replay attacks.

**Source**

Lesson 19 Lecture video: Concept 23
</details>

**True or False?**

Multiple IPSec SAs can be established with one IKE SA.

<details>
<summary>Answer</summary>

True

**Source**

Lesson 19 Lecture Video: Concept 25
</details>

**Multiple Choice**

Which is the main reason a cookie is sent during Phase 1 of IKE?

- A. To authenticate the users
- B. To store log in credentials for the session.
- C. To help prevent DoS attacks.
- D. To store header information, such as time stamp, a nonce, and the user's public key.

<details>
<summary>Answer</summary>

C

**Source**

Lesson 19 Lecture Video: Concept 27
</details>

## Chapter 24: Wireless Network Security

**Multiple Choice**

Adding firewall policies to limit the scope of data and application access for all mobile devices, as well as setting up IDS and IPS configured to have tighter rules for mobile device traffic is:

- A. Device security
- B. Traffic security
- C. Barrier security
- D None of the above

<details>
<summary>Answer</summary>

C

**Source**

Text pg 707-708
</details>

**Multiple Choice**

Using Virtual Private Network(VPN) configured so that all traffic between mobile devices and the organization's network is an example of:

- A. Device security
- B. Traffic security
- C. Barrier security
- D None of the above

<details>
<summary>Answer</summary>

B

**Source**

Text pg 708
</details>

**Multiple Choice**

What are the main threats to wireless transmission?

- I. Eavesdropping
- II. Disrupted transmissions
- III. Message integrity attacks
- IV. Signal attenuation attacks
- V. Masquerade channel attacks

- A. I and II
- B. I, III, and V
- C. II, III, and IV
- D. I, II, III, IV, and V
- E. none of the above

<details>
<summary>Answer</summary>

E

The correct pairing should be I, II, and III (altering or inserting messages = message integrity attack)

**Source**

Text pg 703
</details>

**True or False?**

The main threat to wireless access points is disruption.

<details>
<summary>Answer</summary>

False

The main threat is unauthorized access to the network.

**Source**

Text pg 703
</details>

**True or False?**

Configuring routers to use MAC authentication will block unauthorized access to the network.

<details>
<summary>Answer</summary>

False

MAC addresses can be spoofed, so this is just one element of a defense in depth strategy.

**Source**

Text pg  703
</details>

**Multiple Choice**

What does the concept of _de-perimeterization_ mean, regarding mobile device security?

- A. Guests, their-party contractors, and business partners should have limited access from non-centralized locations.
- B. Threats to the network mainly exist at the perimeter, where intruders gain unauthorized access.
- C. The network perimeter is no longer static, but must include a variety of devices, locations, roles, virtualizations, and access times.
- D. Administrators must put short time constraints on wireless access credentials so long-time users don't create a virtual perimeter wall and block other users from access.
- E. None of the above.

<details>
<summary>Answer</summary>

C

**Source**

Text pg 704
</details>

**True or False?**

IDS and IPS should be configured to have tighter rules for mobile device traffic.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 707
</details>

**True or False?**

WPA security mechanisms eliminates most of the weaknesses of the WEP algorithm.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 714
</details>

**Multiple Choice**

What services does the 802.11i security specification define?

- I. End to end encryption
- II. Authentication
- III. Key exchange facilitation
- IV. Message integrity
- V. VPN

- A. All of the services listed
- B. I, II, III, and IV
- C. II, III, and IV
- D. None of these choices

<details>
<summary>Answer</summary>

C

802.11i only ensures security from the station to the access point. A VPN is a different service that may be run individually.

**Source**

Text pg 715
</details>

**Multiple Choice**

What does _association_ mean, with respect to the 802.11i phase?

- A. The station and access point agree on a set of security capabilities to be used in future hook ups.
- B. The MAC address of the station and the access point.
- C. The key that is used for communication from a station to an access point or another station.
- D. The four step handshaking procedure that is completed when signing in to a wireless network.

<details>
<summary>Answer</summary>

A

Before the distribution service can deliver data to or accept data from a station, that station must be associated.

**Source**

Text pg 717
</details>

**Multiple Choice**

Which key is used for user traffic on a wireless connection?

- A. EAPOL - KCK
- B. TK
- C. EAPOL - KEK
- D. GTK
- E. PSK

<details>
<summary>Answer</summary>

B

The _temporal key (TK)_ is used for protecting user traffic. The EAPOL-KCK (used for origin authenticity and access control) and EAPOL-KEK (used for confidentiality of other keys and data) along with the TK are parts of the PTK (Pairwise Transient Key)

**Source**

Text pg 722
</details>

**True or False?**

The MAC layer is responsible for authorization and validation.

<details>
<summary>Answer</summary>

False

It is responsible for detecting errors and discarding frames that contain errors.

**Source**

Text pg 710
</details>

**Multiple Choice**

Which term corresponds to what is referred to in literature as a _cell_?

- A. the Logical Link Layer
- B. the Distribution System
- C. the Access Point
- D. the Mac Service Data Unit
- E. the Basic Service Set

<details>
<summary>Answer</summary>

E

**Source**

 Text pg 710
</details>

**True or False?**

The principal elements of a mobile device security strategy are _device security_, _client/server traffic security_, and _barrier security_.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 706
</details>

**True or False?**

Disassociation is a policy under the 802.11 standard which protects a channel from interference from eavesdroppers and third parties.

<details>
<summary>Answer</summary>

False

Disassociation: A notification from either a station or an AP that an existing association is terminated.

**Source**

Text pg 713
</details>

**True or False?**

All Android apps must be signed and reviewed by Google / Android.

<details>
<summary>Answer</summary>

False

All apps are self-signed by developers. Third-party apps are not signed by a CA. There is no vetting process.

**Source**

Notes: Project2_L12 Wireless and Mobile Security notes, page 15
</details>

## Chapter 14: IT Security Management and Risk Assessment

**True or False?**

Security standards recommend that the overall responsibility for an organization's IT security be assigned to a single person.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 464
</details>

**Multiple Choice**

Which of the following is the definition of _risk index_?

- A. Max Threat - Min Defence
- B. Max Likelihood of Events / Max Likelihood of Occurrence
- C. Max Impact + Max Likelihood of Occurrence + Magnitude of Impact
- D. Max Info Sensitivity - Min User Clearance
- E. Number of Threats / Likelihood of Occurrence

<details>
<summary>Answer</summary>

D

**Source**

Text pg 469
</details>

**True or False?**

An organization's _risk appetite_ is the net value that it invests in risk management.

<details>
<summary>Answer</summary>

False

It is the level of risk the organization views as acceptable

**Source**

Text pg 470
</details>

**Multiple Choice**

What is a threat agent?

- A. An IT specialist who performs risk analysis for an organization.
- B. The perpetrator of a threat, be it a person or act of God.
- C. A manager or CEO of a company, who makes decisions based on risk analyses.
- D. A person who makes a threat, via ransomware, toward an organization.

<details>
<summary>Answer</summary>

B

**Source**

Text pg 472
</details>

**Multiple Choice**

What is the definition of risk, in terms of organizational security?

- A. (Probability that a threat occurs) x (Cost to the organization)
- B. (Sum of costs of all threats) - (Sum of benefits of preventative measures)
- C. (Net loss due to threats) / (Net worth of the organization)
- D. (Estimated cost of repairs to threats) + (Estimated costs to prevent threats)

<details>
<summary>Answer</summary>

A

Cost can also be defined as _impact_ to the organization

**Source**

Text pg 474
</details>

**True or False?**

A rating of _Likely_ or higher, in a risk analysis, suggests that the threat has occurred previously.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 475
</details>

**Multiple Choice**

What is a _risk register_?

- A. A table describing risks and their associated levels.
- B. A ledger of estimated costs due to threats, weighting costs by the likelihood of each threat.
- C. A table risks on assets, detailing threats, controls, likelihood, consequences, and level of risk.
- D. A summary of losses incurred, along with the corresponding costs involved, people, and resources affected.

<details>
<summary>Answer</summary>

C

**Source**

Text pg 477
</details>

**Multiple Choice**

What is the definition of _risk exposure_?

- A. (Size of an Organization) x (Risk Index)
- B. Sum of the values in the organization's Risk Register.
- C. (Total value of resources) x (Probability of Risks)
- D. (Probability of adverse event) x (Impact of adverse event)
- E. (Risk exposure w/o control - risk exposure after control) / (cost of control)

<details>
<summary>Answer</summary>

D

**Source**

Notes P3_L1_Cybersecurity, pg 12
</details>

**Multiple Choice**

What is the definition of _Risk Leverage_?

- A. The amount of risk an organization can tolerate as a fraction of total perceived risk.
- B. The reduction in risk from imposing controls as a fraction of the cost of the controls.
- C. The expected gain from imposing controls less the expected loss from not imposing them.
- D. The resources available for controls as a fraction of the revenue stream of the organization.

<details>
<summary>Answer</summary>

B

Risk leverage = (Risk exp before (w/o) control - Risk exp. after control) / (cost of control)

**Source**

Notes P3_L1_Cybersecurity pg 12
</details>

**Multiple Choice**

What values of risk leverage imply that the controls are effective?

- A. negative
- B. 0 (or close to 0)
- C. 1 (or close to 1)
- D. greater than 1

<details>
<summary>Answer</summary>

D

Values greater than 1 imply that the reduced risk is greater than the cost of controls

**Source**

P3_L1_Cybersecurity pg 13
</details>

## Chapter 15: IT Security Controls, Plans, and Procedures

**True or False?**

Contingency planning, incident response, maintenance, media protection, personnel security, physical and environmental protection, and system and information integrity are all _Operational_ security controls.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 492, Table 15.1
</details>

**True or False?**

An IT Security plan includes details of risks, controls, priorities, resources, personnel, dates, and maintenance requirements needed to mitigate risks.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 498
</details>

**True or False?**

Security and Awareness training often receives the least attention and in many cases is an afterthought, if at all.

<details>
<summary>Answer</summary>

False

Replace Security and Awareness training with _monitoring affected systems and checking for security implications_

**Source**

Text pg 500
</details>

**True or False?**

The decision as to whether to install the latest patches immediately, or to test to ensure that they don't adversely affect other applications is a part of the _Change Management_ process of monitoring risks.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 500
</details>

**True or False?**

As the number of reported incidents have increased, the budgets invested in cyber security have drastically increased.

<details>
<summary>Answer</summary>

False

In fact, the budges dipped (as of 2014).

**Source**

Notes P3_L1_Cybersecurity pg 21
</details>

## Chapter 19: Legal and Ethical Aspects

**Multiple Choice**

Which of the following is _not_ cited in the Articles on the Convention on Cybercrime?

- A. Illegal access
- B.  Fake news
- C. Illegal interception
- D. Data interference
- E. System interference
- F. Pass interference
- G. Misuse of devices
- H. Computer-related forgery
- I. Computer-related fraud
- J. Offenses related to child pornography
- K. Infringements of copyright
- L. Attempt and aiding or abetting

<details>
<summary>Answer</summary>

B and F

**Source**

Text pg 580
</details>

**Multiple Choice**

Which of the following are copyright owner rights against infringement?

- I. Reproduction right
- II. Fair Use right
- III. Distribution right
- IV. Fair compensation right
- V. Public-performance right
- VI. Public-display right

<details>
<summary>Answer</summary>

All except for II and IV.  (Also add Modification right)

**Source**

Text pg 584
</details>

**True or False?**

Both criminal and civil penalties apply to individuals who attempt to circumvent technological measures used to thwart access to or copying of copyrighted material.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 586
</details>

**True or False?**

Algorithms can be patented.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 585
</details>

**Multiple Choice**

Under the Digital Millennium Copyright ACT, individuals may be allowed to do which of the following?

- I. Distribute portions of the work for review.
- II. Reverse engineer in order to achieve interoperability
- III. Attempt to decrypt technology in order to advance the development of the technology.
- IV. Testing a vulnerability in a computer or network.
- V. Bypassing technological measures to protect PII.

- A. I, II, III, IV, V
- B. I, IV, V
- C. I, II, IV, V
- D. III, IV, V

<details>
<summary>Answer</summary>

A

**Source**

Text pg 586
</details>

**True or False?**

Anonymity directly conflicts with authorization and access control functions.

<details>
<summary>Answer</summary>

False

It need not conflict, because these are bound to computer-based user IDs, not to personal user information.

**Source**

Text pg 592
</details>

**True or False?**

PII in anonymized data can sometimes be re-identified.

<details>
<summary>Answer</summary>

True

**Source**

Text pg 594

</details>

**True or False?**

Privacy is the principle that only authorized persons should have access to information. Confidentiality is the control that individuals have over who can access their personal information.

<details>
<summary>Answer</summary>

False

Switch _privacy_ and _confidentiality_, and it's true

**Source**

Text pg 594
</details>

**True or False?**

Software applications embedded in toys may be classified as a computing artifact.

<details>
<summary>Answer</summary>

True

computing artifact refers to any artifact that includes an executing computer program. This includes software applications running on a general purpose computer, programs burned into hardware and embedded in mechanical devices, robots, phones, Web bots, toys, programs distributed across more than one machine, and many other configurations.

**Source**

Text pg 599
</details>
