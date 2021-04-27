---
id: secure-computer-systems-09-MAC-selinux
title: SELinux Mandatory Access Control
course: secure-computer-systems
lecture: 09-MAC-selinux
---

# SELinux

Janek Desai helped put together content for this module, and teaches it in the on-campus course.

## Background

SELinux is Security-Enhanced Linux. It implements additional access control models - 

* Domain/Type Enforcement (D/TE)
* Multilevel Security (MLS)
* Role Based Access Control (RBAC)

SELinux was developed by the NSA and then donated to the Linux open source community.

### Design Goals

* Regular Linux implements discretionary (DAC). SELinux adds features on top of Linux's DAC.
* Decouple policy from enforcement
* Flexible / Configurable / Loadable

### Who is using it?

Redhat Enterprise Linux was an early adopter and champion of SELinux. Supported by other distros such as Fedora, SuSE, Ubuntu, Debian.

Because Android is built on top of the Linux kernel we can add Linux to Android as well. This is called SEAndroid. There are enhanced security offerings like Samsung Knox and Tresys Mobile Fortess built on SEAndroid.

## Linux Security Module (LSM)

The Linux Security Module (LSM) lets you extend Linux to use additional access control with modules like SELinux, LIDS, SMAC, AppArmor. We focus on SELinux.

This module includes a bunch of functions that hook in and get called when they need to do something.

### DAC before LSM

In the diagram below, the dotted box represents the xyz LSM. It implements its own security operations. In this case we are checking for inode permissions (an inode stores file metadata in Linux).

The LSM is layered on top of Linux's existing DAC, so we check the DAC before checking the xyz LSM.

If xyz is not loaded then we just return the result of the DAC check.

![](https://assets.omscs.io/secure-computer-systems/images/module9/lsm1.png)

### Implementation Details

In the diagram below, the dotted box enforces security policies. The black circle in the top right represents the policy we are feeding into the system. The red circle actually enforces the policy. 

The LSM policy is checked after the DAC (DAC is just normal Linux permissions).

There is a text policy (a configuration file shown upper right) which compiles to a binary representation that then gets saved to a Policy DB. The security server does the enforcement. We cache the results for improved performance.

![](https://assets.omscs.io/secure-computer-systems/images/module9/lsm2.png)


## SELinux Security Context

### Attributes

Context is a collection of attributes. Some attributes like user ID come from Linux itself (`attrs` in the diagram below). There are also attributes specific to SELinux (`selinux attrs`). 

These attributes are used to decide - 
* **Access:** Can access be granted or not?
* **Inheritance:** If a process creates a child process, what security context can be inherited? For objects, what attributes get inherited from a directory to its subdirectories.
* **Transition:** This is like `setuid`, go from one type to another type within attributes.
* **Override:** Override policy rules.

![](https://assets.omscs.io/secure-computer-systems/images/module9/context1.png)

### Attribute Strings

There is a user ID (`staff_u`) in SELinux, which is separate from the Linux user ID. The user can have a role `staff_r`, the role can have a type `staff_t`.

To implement multi-level security like BLP we have the range. The range is split up into sensitivity level and compartment.

![](https://assets.omscs.io/secure-computer-systems/images/module9/context2.png)

Processes, files, directories, sockets, ports, nodes, etc., all have a string like this associated with them. It is associated with every subject and object in the system.

## Type Enforcement

The SELinux type is used in making decisions. There is something called the policy rules which decide if the user with type `staff_t` gets access to an object of type `etc_t`.

![](https://assets.omscs.io/secure-computer-systems/images/module9/type1.png)

Lets go through an example for a source of type `staff_t` and an object of type `etc_t`.

* Access
  * Access can be given via `allow staff_t etc_t:file {read write }` and this would mean that sources of type `staff_t` can read/write files of type `etc_t`.
* Inheritance
  * Child processes inherit parent's type and subdirectories inherit from parent directory.
* Transition
  * Transistion is similar to `setuid`, you can transfer between types when executing a file. For example, `staff_t` can transition to `mount_t` by executing a binary with type `mount_exec_t`.
* Override
  * No specific override rules. Each access must be explicitly granted.

  Types let us implement RBAC. In RBAC we have users -> roles -> permissions, we implement this through types as users -> roles -> types.

## Multilevel Security (MLS) in SELinux

With MLS we have a hierarchy within the attributes. In the Dept. of Defense it might be Top Secret > Secret > Confidential > Unclassified. With MLS we make rules about information flow to address confidentiality (BLP) or integrity (Biba). Here are some operations and the direction of information flow - 

* **Read:** Flows from object to user.
* **Execute:** Flows from object to user.
* **Write:** Flows from user to object.
* **Create:** Flows from user to object.
* **Connect:** Bidirectional. Flows from user to object and from object to user.

### Context

The portion of the security context that is used in MLS is in bold - 

staff_u:staff_r:staff_t:**s0-s15:c0.c1023**

The sensitivity levels can be s0 through s15 and are totally ordered, meaning that all sensitivity levels are either less than, greater than, or equal to, s15 > s0. The compartments are separated by periods or commas and represent a subset. Subsets are partially ordered, meaning that some subsets are not less than, greater than, or equal to each other.

### Order of Security Enforcement

Recall that Discretionary Access Control (DAC) is the first thing we check, this is provided by plain Linux. Then Domain/Type Enforcement (DTE) is checked. After both of these are checked we check if MLS allows access.

DAC -> DTE -> MLS

The access permissions can only reduce as we perform more checks.

### MLS Label Comparisons

As discussed earlier, sensitivity levels are totally ordered.

s15 > s14 > ... > s0.

Categories are a subset of \{c0, c1, ..., c1023\}. They are given as a string and separated by commas or periods. When they are separated by commas this means that they are included as an individual. Dots represent ranges.

c0,c2,c5.c1023 = {c0, c2, c5, c6, c7, ..., c1023}

There might be two sensitivity levels to indicate an **effective security level** and a **clearance level**. The lower level will be the effective level, and the higher will be the clearance level.

## BLP and SELinux

In the diagram below the leftmost arrow represents L1 reading from L2, this is allowed as L1 dominates L2. The second to left arrow represents L2 writing to L1 which would normally be allowed in BLP (write up) but is not allowed here. SELinux is not BLP, it is **BLP+** which is read-down, write at your own level. The rest of the diagram follows BLP.

![](https://assets.omscs.io/secure-computer-systems/images/module9/BLP.png)

## MLS Policy Language

There is some notation for MLS policies. The user or process has context labels `l1`, and `h1`. `l1` is the low permission level (remember, you can have an effective sensitivity level which is lower than the clearance level). We also denote the type of the user by `t1`. Similarly the object has labels `l2`, `h2`, `t2`, 1 is for user, 2 is for object.

Here is an example of an MLS constraint policy. The policy is defined for directories, files, lnk_files, etc... and the operations are read, getattr, execute.

```
mlsconstrain { dir file lnk_file chr_file blk_file sock_file fifo_file } { read getattr execute }
  ((l1 dom l2) or
  ((t1 == mlsfilereadtoclr) and (h1 dom l2)) or
  (t1 == mlsfileread) or
  (t2 == mlstrustedobject));
```

* The first rule lets us perform these read type operations when l1 dominates l2.
* If the user has type t1 == `mlsfilereadtoclr` then instead of using the low permissions (l1 dom l2) we use the high permissions h1 and check if h1 dom l2.
* We can also perform these operations if t1 == mlsfileread or t2 == mlstrusted object.

This is like the BLP rules but there are overrides.

## Policy Examples

Let's revisit our example for read rules along with a new example for write rules. The `filewritetoclr` type lets us write in the range between our effective level and our clearance level (shown in blue in the image). The `mlsfilewriteinrange` lets us write if our range of levels is contained by the objects range of levels (also shown in blue).

![](https://assets.omscs.io/secure-computer-systems/images/module9/BLP2.png)

### Transitions

We can have a policy that allows us to transition between  types, this is like `setuid()` but for types. Maybe the policy looks like:

`type_transition user_t passwd_exec_t:process passwd_t`

This says a user of type `user_t` can execute a file of type `passwd_exec_t` to have a process that runs with type `passwd_t`. In Linux we have a setuid() bit on the executable that lets users change their passwords. This lets the program run as root, but then root can change the password. Using a type transition instead of setuid() lets us be more granular. Even root cannot change password if the type is not `passwd_t`.

Objects can also change types. In the policy below `t3` is the type of the process that is either upgrading or downgrading a file.

![](https://assets.omscs.io/secure-computer-systems/images/module9/object-trans.png)

## Evaluating SELinux Policies

### Exercise 1

Will the following commands complete?

![](https://assets.omscs.io/secure-computer-systems/images/module9/eval1.png)

Firstly, the DAC allows read write for everything in the mode column. Since there are no problems with DAC we check types. 

1. The process of type `staff_t` has permissions to read from type mount_t. Process dominates file4 so there are no MLS problems. Command 1 is allowed.
2. No write rules are given anywhere. Not allowed.
3. Not allowed. The transition is not defined for staff_t. The type transition is from *sysadmin_t* to type mount_t by running an executable of sysadm_t_mount_exec. 

### Exercise 2

![](https://assets.omscs.io/secure-computer-systems/images/module9/eval2.png)

Again, DAC is fine.

**Commands for process #1**:

1. No access. `staff_t` does have read access to `home_t`. The effective sensitivity level of s0 is lower than s5, we fail MLS check. No access.
2. No access. Effective level is still s0 < s5.
3. No access. staff_t can execute the file of type `aide_exec_t` but staff_t has no transition to type aide_t, it will remain at the same type and have no permissions. If staff_t could transition to type aide_t then it would get the mlsfilereadtoclr and mlsfilewritetoclr attributes, allowing us to use the clearance level s15 instead of the effective level s0, this would allow access.

**Commands for process #2**:

1. Allowed. Our **clearance** level is s15, which allows us to read something with sensitivity level s5. Notice that sysadm_t has both `mlsfilewritetoclr` and `mlsfilereadtoclr`. This means when reading and writing we can use the clearance level instead of the effective level.
2. Allowed. Again, clearance of s15 > s5.
3. Allowed. sysadm_t can execute the file of type `aide_exec_t` and transition to type `aide_t` which has `mlsfilewritetoclr` and `mlsfilereadtoclr`. Our clearance of s15 > s0.