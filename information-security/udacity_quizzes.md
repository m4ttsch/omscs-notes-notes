---
id: udacity-quizzes
title: Udacity Quizzes
sidebar_label: Udacity Quizzes
---

## The Security Mindset
### Security Impact Quiz
![](../assets/Screen%20Shot%202019-08-20%20at%208.42.25%20PM.png)

### Security Impact Quiz Solution
No one right solution. I think the important thing to understand here is that no company is safe from a breach, and many companies that you interact on a daily basis have suffered breaches.

### Black Market Prices Quiz
![](../assets/E8C3B157-9CC2-43BB-B761-89A237C8A7E5.png)

### Black Market Prices Quiz Solution
![](../assets/E405BEDE-4306-4A65-91C9-AD0296201E67.png)

I think the point here is not to remember the exact numbers, but rather to understand that this information can be purchased relatively cheaply. This makes sense given that millions of records can be retrieved in a single breach.

### Sony Pictures Quiz
![](../assets/3430D19A-B3A4-4978-B9D1-D2CCFFBB7676.png)

### Sony Pictures Quiz Solution
![](../assets/E35AAD32-24F6-494C-A37F-8DF068591D26.png)

Read more [here](https://en.wikipedia.org/wiki/Sony_Pictures_hack)

### Security Requirements Quiz
![](../assets/38ACE867-7D38-47CD-A9BB-52AA9B654980.png)

### Security Requirements Quiz Solution
![](../assets/1ED304D4-8E4A-43E3-9209-62B58C7AD5E5.png)

Since data breaches involve the disclosure of information to unauthorized parties, these breaches violate confidentiality.

### Losses Due to Cyber Crime Quiz
![](../assets/015A31E9-BB3F-4406-A5CD-A4A246C12321.png)

### Losses Due to Cyber Crime Quiz Solution
![](../assets/0405619E-94F9-42E9-8E7F-5CB07EB9CBF2.png)

### Security Mindset Quiz
![](../assets/980D23F6-7ADD-4C3A-BB92-FA6FD53BF9E7.png)

### Security Mindset Quiz Solution
![](../assets/D8E63E79-4288-4ECA-97E1-CA3270A46652.png)

## Software Security
### Stack Access Quiz
![](../assets/429E7357-0C4A-4E2E-B10B-474694620410.png)

### Stack Access Quiz Solution
![](../assets/1094841F-A963-4260-BA08-4E5F4BB130B5.png)

Since `allow_login`, `pwdstr` and `targetpwd` are all local variables to `main`, any access of them will access memory locations inside the stack frame for `main`.

The only lines of code that don’t access the stack frame for `main` are the calls to `printf`, (which create a new stack frame), and `else`.

### Attacker Code Quiz
![](../assets/4E905E4F-F658-4D3E-8A95-BC7BD589593A.png)

### Attacker Code Quiz Solution
![](../assets/82AEC50D-14C8-41D9-98DB-930CF11CA87E.png)

Remember that the stack pointer moves down in memory as space is allocated. This means that `allow_login` will receive memory starting at the highest feasible address, and `pwdstr` will receive memory starting at the next highest feasible address.

Suppose both `int` and `char` occupy 1 byte. `allow_login` may be allocated 1 byte of space starting at memory address `1000`. `pwdstr` may be allocated 12 bytes of space starting at memory address `988`.

If the user enters a password longer than 12 bytes, the remaining bytes will overflow into the memory allocated to `allow_login`, effectively overwriting its value.

Since login will succeed if `allow_login` is anything but 0 (i.e. not a fail-safe default), this overflow will almost certainly lead to access being granted.

### Buffer Overflow Quiz
![](../assets/AF1E8B07-5821-4767-976D-54A9EE56319C.png)

### Buffer Overflow Quiz Solution
![](../assets/07B11C34-5DB8-4233-BC74-E2075631A2E1.png)

The first answer is wrong. The target password can be as long as you’d like, but if the attacker submits a longer password, the overflow will still happen.

The third answer is also wrong. Besides the fact that you shouldn’t ever really add useless variables, these variables will only provide a finite amount of distance between the user-filled buffer and the return address. With a long enough password, the attacker can still overwrite the return address.

Only the second answer is correct. The overflow happens precisely because input larger than the space allocated for that input is not rejected by the program.

### NVD Quiz
![](../assets/61204FE2-AD15-4170-BCB4-48EC8A23F6C1.png)

### NVD Quiz Solution
![](../assets/FFB98B29-CFB5-4F45-8359-BC6804E3D04D.png)

### Strongly Vs Weakly Typed Language Quiz
![](../assets/041BD85C-82D0-4D30-AABA-C35771B37CB3.png)

### Strongly Vs Weakly Typed Language Quiz Solution
![](../assets/BB9848DB-A87B-4B54-B4FE-4CDB1A596F7A.png)

### Buffer Overflow Attacks Quiz
![](../assets/0AF6ADAD-2A2D-435A-BE02-786B77295BA2.png)

### Buffer Overflow Attacks Quiz Solution
![](../assets/618CEAB7-54EA-4819-9CE8-12CA704FC5C1.png)

Stack canaries do prevent return-to-libc buffer overflow attacks, because stack canaries prevent return address overwriting. Without overwriting the return address, a function can only return to the function that called it.

ASLR does not protect against read-only buffer overflow exploits. ASLR only makes it harder to supply key addresses in write-based buffer overflow exploits.

Heartbleed cannot be avoided by using a non-executable stack. Heartbleed is a read-based buffer overflow exploit, and the attack did not involve injecting any machine instructions onto the stack.
