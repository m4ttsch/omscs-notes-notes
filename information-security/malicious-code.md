---
id: information-security-malicious-code
title: Malicious Code
course: information-security
lecture: malicious-code
---

# Malicious Code

## What is Malware Quiz
![](https://assets.omscs.io/notes/40637903-CAAE-402C-9F8D-DC289CB7EC62.png)

## What is Malware Quiz Solution
![](https://assets.omscs.io/notes/07625575-7DE3-4F7F-AEF7-5E0B1178E7A7.png)

## Types of Malware
There are two major types of malware.

The first type of malware embeds itself in a host program and executes on the system when its host runs.

The second type of malware interacts with systems as independent programs that can run by themselves.

Malware can embed itself in a host through

- trap doors
- logic bombs
- Trojan horses
- viruses
- browser plugins/extensions

Examples of independent malware include

- worms
- botnets
- advanced persistent threats (APTs)

## Trap Doors
**Trap doors** - also known as backdoors - are secret entry points to a system that are typically only known to the developer of the system.

Trap doors are typically activated when a user provides a special sequence of input or a special user ID to the system.

Trap doors can be really helpful for programmers who need or want rapid access to a system without providing the proper user authentication.

Of course, an attacker with possession of a trap door can wreak havoc on a system.

A famous but naive version of a trap door - sometimes referred to as an **easter egg** - is the [flight simulator](https://www.youtube.com/watch?v=-gYb5GUs0dM)  embedded in the 1997 version of Microsoft Excel, which was activated by an undocumented series of commands entered by the user.

## Logic Bombs
A **logic bomb** is essentially a trigger planted in a program. When the triggering condition is met, the planted  code is executed.

For example, the [Code Red](https://en.wikipedia.org/wiki/Code_Red_(computer_worm)) worm contained a logic bomb that launched a denial of service attack at the White House web server on a specific date.

## Trojan Horses
Trojan horses get their name from an ancient Greek story from the Trojan War. From [wikipedia](https://en.wikipedia.org/wiki/Trojan_Horse):

> In the canonical version, after a fruitless 10-year siege, the Greeks constructed a huge wooden horse, and hid a select force of men inside including Odysseus. The Greeks pretended to sail away, and the Trojans pulled the horse into their city as a victory trophy. That night the Greek force crept out of the horse and opened the gates for the rest of the Greek army, which had sailed back under cover of night. The Greeks entered and destroyed the city of Troy, ending the war.  

In the context of malware, a Trojan horse is a piece of malicious code embedded in a utility program that a user runs frequently. When the utility program runs, the malicious code runs with it.

An example of a trojan horse is a login program that performs keylogging. This program will allow the user to login by calling the real login subroutine - a useful utility - while also stealing the user's credentials.

Many malicious browser extensions/plugins perform keylogging under the guise of offering some helpful utility.

## Viruses
A **virus** infects a program by modifying the program code so that when a program runs the virus code also runs. A virus is unique in that it is able to spread, much like a real virus.

There are four main stages in the lifecycle of a virus.

The first phase is the *dormant* phase. In this phase, the virus has infected the host system, but remains idle.

The second phase is the *propagation* phase. In this phase, the virus multiplies and spreads. It can copy itself into other programs on the same host, or it can send itself to other hosts - by way of an email attachment, for example.

In the *triggering* phase,  the virus is activated for execution. A user clicking on an email attachment containing a virus may trigger that virus for activation.

The final phase is the *execution* phase. In this phase, the virus actually performs its malicious work. For example, an executing virus might delete all of the files on disk.

## Host Required Malware Quiz 1
![](https://assets.omscs.io/notes/A4EDCDB2-1BCA-44CE-82D9-F9F87A38CED2.png)

## Host Required Malware Quiz 1 Solution
![](https://assets.omscs.io/notes/5FECA411-7C95-4E9C-B485-2FB274E512F5.png)

## Host Required Malware Quiz 2
![](https://assets.omscs.io/notes/21C54A27-F1F6-4A37-969F-A29DE164F9F5.png)

## Host Required Malware Quiz 2 Solution
![](https://assets.omscs.io/notes/049C97B7-000C-4F42-8755-89BDE3A06DB9.png)

## Virus Structure
A virus infects a program by modifying the program code. In order to achieve this, the virus code has to be physically inserted into the program file.

When an infected program runs, the virus code runs first. The virus code then runs the original program so that the user doesn't suspect that the program has been infected. Finally, the virus code runs again, often to perform some cleanup to avoid detection.

![](https://assets.omscs.io/notes/28595BDF-E52D-41AB-9E4D-19C299539E78.png)

The first line of the infected program must ensure that the virus runs immediately. This can be achieved with an instruction that calls the `main` function of the virus.

The virus code must also place a marker on the infected program to indicate that the program has been infected. Without this flag, a program could be repeatedly infected.

When the virus executes, it first finds other programs to infect. It will scan other applications on the system and infect those that do not have the special infected flag set.

In addition to infecting other programs, the virus can perform other malicious activities on the system.

Finally, the virus will transfer control to the original program so that normal work can be performed. This helps to prevent the user from detecting the infection.

The virus can perform other actions in order to avoid detection.

For example, when a virus is inserted into a program file, the size of that file increases. This increase can be a telltale sign that a program has been infected; therefore, the virus code might compress the infected program so that the file size appears unchanged.

## Types of Viruses
A **parasitic virus** scans non-running programs on the system - for example, those that reside on the hard drive - and then infects those programs.

A **memory-resident virus** is typically part of an operating system. When the operating system runs, the virus is loaded into memory and can infect any running program on the system.

A **macro virus** is a virus embedded in a document. The virus runs when the document is opened.

A **boot sector virus** resides in the boot sector of the hard drive and executes whenever the system is booted.

A **polymorphic virus** "looks different" with each infection. This is achieved by encrypting a portion of the virus code with a randomly generated key during each infection. The purpose of using polymorphic viruses is to avoid detection by anti-virus systems that rely on [virus signatures](https://www.computerhope.com/jargon/v/virus-signature.htm).

Any of these viruses can be polymorphic.

## Boot Sector Virus
In order to understand a boot sector virus, we need to understand how the boot sector works.

![](https://assets.omscs.io/notes/D45893B7-A8E1-43B1-99FC-8276CC5145A1.png)

A **boot sector** is a special sector on the hard drive of a system. When a system is booted, the code in the boot sector - called the **bootstrap loader** - always runs first.

The bootstrap loader is typically responsible for loading the operating system.

When a boot sector virus infects a system, the virus code is inserted in the boot sector. This ensures that the virus always executes first during system boot.

During system boot, the virus performs its malicious functions,  such as infecting other programs, spreading to other systems, or destroying useful documents.

After the virus executes, it transfers control to the original bootstrap loader in order to give the appearance that the system is functioning normally.

![](https://assets.omscs.io/notes/A9F823EB-31F6-4E93-8D78-1AD37DEE40C3.png)

## Macro Viruses
A **macro** is a program embedded in a document, such as a Microsoft Word document. A macro typically contains instructions for some useful functions, such as opening a file or starting a new application.

Because a macro is an executable program, it can be infected by viruses just like any other executable programs.

Macro viruses are unique in that users don't typically expect a document to contain a virus. As a result, attackers have had success spreading infected documents via email attachments.

When an unsuspecting user clicks on the email attachment and opens the document, the macro executes, and the macro virus runs.

The macro virus can perform malicious activities such as sending the infected document to every person in the user's address book.

A macro virus can also copy its macro to the global macro file. Whenever a user opens a new document, this now global macro will be copied into the new document, meaning that all new documents on the user's system will be infected.

## Types of Viruses Quiz
![](https://assets.omscs.io/notes/133BBEDD-CE14-4ED3-A8ED-48F539E3E52B.png)

## Types of Viruses Quiz Solution
![](https://assets.omscs.io/notes/6294734B-447D-4C84-9F5E-C80BD8923832.png)

Macro viruses run when an infected document is opened with a given application. Boot sector viruses run before the operating system is loaded.

## Rootkit
A **rootkit** is a program that typically modifies some of the code and data structures in an operating system in order to perform some malicious activities.

A rootkit can be used to hide malware from a user.

For example, when the user executes the `ls` command to list the contents of a directory, the rootkit can change the output of this command so that the user will not see the malware file.

Similarly, when the user executes the `ps` command to see what programs are running on the system, the rootkit can change the output of this command to hide the running malware.

Here is the functional flow for listing files using the windows command `dir`.

![](https://assets.omscs.io/notes/9474681E-8F39-4A87-B7A7-191C40CF07C0.png)

Before the rootkit has been embedded, here is what an operating system will typically return when the user lists the files in a directory.

![](https://assets.omscs.io/notes/16203A74-AC28-4BD8-9E31-9A74AF188A49.png)

The installed rootkit intercepts any call to the operating system and then determines whether the call will reveal the malware. If so, the rootkit alters the result to hide the malware; otherwise, it passes the result to the caller unmodified.

![](https://assets.omscs.io/notes/E559CAC9-6FCA-4ED3-AEF0-DBAD9ADDCE39.png)

For example, the rootkit can intercept the directory listing from the `dir` command and remove the malware entry.

![](https://assets.omscs.io/notes/E9070948-A413-4C12-9C50-22D1DDFD6A18.png)

## Rootkit Quiz
![](https://assets.omscs.io/notes/F9D17F35-7B72-4538-9425-77C62F298C1D.png)

## Rootkit Quiz Solution
![](https://assets.omscs.io/notes/F4D927F4-F0EF-4056-9F9C-3979A28E1375.png)

## Truth and Misconceptions Quiz
![](https://assets.omscs.io/notes/C55A0FCE-82C4-4243-83F9-9FE14B9B1982.png)

## Truth and Misconceptions Quiz Solution
![](https://assets.omscs.io/notes/FE1571D1-8225-4963-ABEA-379773BD8D9A.png)

## Worms
Worms are independent malicious programs that typically use network connections to spread from one system to another.

Worms first appeared in the 1990s - coinciding with the rapid expansion of the Internet - and marked a major advance in malware.

Worms later evolved into botnets around 2005, which remain the dominant form of malware we see today.

## The Internet Worm
One of the most famous worms is the **Morris Worm**, named after its creator Robert Morris. This worm is also referred to as the *Internet Worm*.

According to Morris, this worm was used to gauge the size of the Internet by measuring how many computers were connected together.

### Programming Error
However, there was a programming error in the code which transformed this intellectual exercise into a damaging attack.

The worm would ask a target system if it had been infected. Even if the target responded that it had, the worm would infect the system again, one out of seven times.

This reinfection rate proved too aggressive, and many systems that had been infected multiple times crashed.

Sysadmins had to disconnect their servers from the Internet in order to disinfect them. Since many servers were infected, Internet service overall was disrupted.

### Implementation
When the Morris Worm identified the next target to infect, it looked for several security flaws that it knew how to exploit.

From [court documents](http://www.loundy.com/CASES/US_v_Morris2.html):
> Morris identified four ways in which the worm could break into computers on the network: (1) through a "hole" or "bug" (an error) in SEND MAIL, a computer program that transfers and receives electronic mail on a computer; (2) through a bug in the "finger demon" program, a program that permits a person to obtain limited information about the users of another computer; (3) through the "trusted hosts" feature, which permits a user with certain privileges on one computer to have equivalent privileges on another computer without using a password; and (4) through a program of password guessing, whereby various combinations of letters are tried out in rapid sequence in the hope that one will be an authorized user's password, which is entered to permit whatever level of activity that user is authorized to perform.  

Specifically, the `fingerd` daemon was exploited via a buffer overflow vulnerability, and `sendmail` was exploited via a trapdoor that accepted shell commands.

Once the worm gained access to a target system, it then loaded a small piece of code - the bootstrap loader - which fetched the rest of the worm code. Password-based authentication was used to ensure that only the bootstrap loader could fetch the worm code.

The worm employed a number of tricks to hide itself.

For example, once the worm code was loaded into memory, it deleted its original file from disk and encrypted/decrypted itself as necessary. In addition, the worm even periodically changed its process name and ID, so a sysadmin looking at running programs could not easily discover the worm.

### What We Learned
Most of the flaws exploited by the Morris Worm were not only well known at the time but also had security patches available. The worm taught us the importance of frequent security scanning and patching.

We also learned that we need to have a fast and coordinated response to a major security incident like the Morris Worm. The US government established the [Computer Emergency Response Team](https://en.wikipedia.org/wiki/Computer_emergency_response_team) (CERT), which is responsible for issuing alerts about security flaws and recommendations about patches.


## Worm Quiz
![](https://assets.omscs.io/notes/63C5BA47-1177-48B3-8C53-AB4B8BD90395.png)

## Worm Quiz Solution
![](https://assets.omscs.io/notes/60DAF027-9368-40B6-AE36-FC6EA78B32B8.png)

## Malware Prevention & Detection Approaches
We can prevent malware from infecting our computer systems  by limiting our contact with the outside world. In other words, if we don't accept documents or programs from any external source, we can greatly reduce our chance of infection.

Obviously, this approach imposes a major inconvenience to a computer user.

Instead of preventing infection, we can try to improve how we detect an infection. We can continually improve the monitors that we use to watch for telltale signs of infection.

In addition, we can focus on removal. Once we detect a malware infection, we remove the malware and potentially also patch the system.

Given that prevention severely hampers productivity, detection is the main countermeasure that we use.

There are 4 generations of antivirus software, each with different strategies for detecting malware infection.

### Simple Scanners
**Simple malware scanners** scan program files looking for signatures (patterns) of known viruses. If a scanner finds a signature, it means that the program file has been infected by a known virus.

A **virus signature** is typically a unique sequence of instructions in the virus code or the unique infection marker that the virus would use.

These simple scanners are not effective against polymorphic viruses because each instance of a polymorphic virus is encrypted with a random key, meaning that there is no unique signature across all instances of the same virus.

### Heuristic Scanners
**Heuristic scanners** look for the possible effects of infection. For example, if a program file has been infected, the [checksum](https://en.wikipedia.org/wiki/Checksum) of the file will change because the file contents have changed.

This approach can be defeated if the malware deliberately ensures that the checksum after infection remains the same, which can be done by including some additional bytes at the end of the file.

### Activity Traps
**Activity traps** monitor the system by watching for particular kinds of activities that malware would usually perform on a system, such as reading a password file and sending it over the Internet.

These detectors are based on our knowledge of malware activities. Therefore, they are not effective against malware that performs new kinds of malicious activities.

### Full-Featured Analysis
A full-featured analysis typically involves multiple detection approaches, such as host-based monitoring - which includes activity traps and scanners - and network-based monitoring, which examines network traffic to detect suspicious activity.

This strategy can also include a sandbox-based analysis. A **sandbox** is typically a secure, observable environment on the system that is isolated from the rest of the system.

We can observe a suspicious executable in a sandbox first to ensure that it will not cause any damage to the system or network before allowing it to run outside of the sandbox.

## Malware Prevention & Detection Quiz
![](https://assets.omscs.io/notes/36682CCE-48D2-43A0-B174-A5558BA230E6.png)

## Malware Prevention & Detection Quiz Solution
![](https://assets.omscs.io/notes/919A3EB0-92AE-4221-BFC5-D339E835C7E6.png)

## Most Expensive Worm Quiz
![](https://assets.omscs.io/notes/8C469D3D-9061-45F2-8B2F-53D35CBD5A30.png)

## Most Expensive Worm Quiz Solution
![](https://assets.omscs.io/notes/38A65997-26BC-4D80-A560-169AF0930940.png)

[Source](https://encyclopedia2.thefreedictionary.com/Top+10+Worst+Computer+Worms+of+All+Time)
