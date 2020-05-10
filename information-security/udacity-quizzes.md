---
id: information-security-udacity-quizzes
title: Udacity Quizzes
course: information-security
lecture: udacity-quizzes
---

# Udacity Quizzes

## The Security Mindset
### Security Impact Quiz
![](https://assets.omscs.io/notes/Screen%20Shot%202019-08-20%20at%208.42.25%20PM.png)

### Security Impact Quiz Solution
No one right solution. I think the important thing to understand here is that no company is safe from a breach, and many companies that you interact on a daily basis have suffered breaches.

### Black Market Prices Quiz
![](https://assets.omscs.io/notes/E8C3B157-9CC2-43BB-B761-89A237C8A7E5.png)

### Black Market Prices Quiz Solution
![](https://assets.omscs.io/notes/E405BEDE-4306-4A65-91C9-AD0296201E67.png)

I think the point here is not to remember the exact numbers, but rather to understand that this information can be purchased relatively cheaply. This makes sense given that millions of records can be retrieved in a single breach.

### Sony Pictures Quiz
![](https://assets.omscs.io/notes/3430D19A-B3A4-4978-B9D1-D2CCFFBB7676.png)

### Sony Pictures Quiz Solution
![](https://assets.omscs.io/notes/E35AAD32-24F6-494C-A37F-8DF068591D26.png)

Read more [here](https://en.wikipedia.org/wiki/Sony_Pictures_hack)

### Security Requirements Quiz
![](https://assets.omscs.io/notes/38ACE867-7D38-47CD-A9BB-52AA9B654980.png)

### Security Requirements Quiz Solution
![](https://assets.omscs.io/notes/1ED304D4-8E4A-43E3-9209-62B58C7AD5E5.png)

Since data breaches involve the disclosure of information to unauthorized parties, these breaches violate confidentiality.

### Losses Due to Cyber Crime Quiz
![](https://assets.omscs.io/notes/015A31E9-BB3F-4406-A5CD-A4A246C12321.png)

### Losses Due to Cyber Crime Quiz Solution
![](https://assets.omscs.io/notes/0405619E-94F9-42E9-8E7F-5CB07EB9CBF2.png)

### Security Mindset Quiz
![](https://assets.omscs.io/notes/980D23F6-7ADD-4C3A-BB92-FA6FD53BF9E7.png)

### Security Mindset Quiz Solution
![](https://assets.omscs.io/notes/D8E63E79-4288-4ECA-97E1-CA3270A46652.png)

## Software Security
### Stack Access Quiz
![](https://assets.omscs.io/notes/429E7357-0C4A-4E2E-B10B-474694620410.png)

### Stack Access Quiz Solution
![](https://assets.omscs.io/notes/1094841F-A963-4260-BA08-4E5F4BB130B5.png)

Since `allow_login`, `pwdstr` and `targetpwd` are all local variables to `main`, any access of them will access memory locations inside the stack frame for `main`.

The only lines of code that don't access the stack frame for `main` are the calls to `printf`, (which create a new stack frame), and `else`.

### Attacker Code Quiz
![](https://assets.omscs.io/notes/4E905E4F-F658-4D3E-8A95-BC7BD589593A.png)

### Attacker Code Quiz Solution
![](https://assets.omscs.io/notes/82AEC50D-14C8-41D9-98DB-930CF11CA87E.png)

Remember that the stack pointer moves down in memory as space is allocated. This means that `allow_login` will receive memory starting at the highest feasible address, and `pwdstr` will receive memory starting at the next highest feasible address.

Suppose both `int` and `char` occupy 1 byte. `allow_login` may be allocated 1 byte of space starting at memory address `1000`. `pwdstr` may be allocated 12 bytes of space starting at memory address `988`.

If the user enters a password longer than 12 bytes, the remaining bytes will overflow into the memory allocated to `allow_login`, effectively overwriting its value.

Since login will succeed if `allow_login` is anything but 0 (i.e. not a fail-safe default), this overflow will almost certainly lead to access being granted.

### Buffer Overflow Quiz
![](https://assets.omscs.io/notes/AF1E8B07-5821-4767-976D-54A9EE56319C.png)

### Buffer Overflow Quiz Solution
![](https://assets.omscs.io/notes/07B11C34-5DB8-4233-BC74-E2075631A2E1.png)

The first answer is wrong. The target password can be as long as you'd like, but if the attacker submits a longer password, the overflow will still happen.

The third answer is also wrong. Besides the fact that you shouldn't ever really add useless variables, these variables will only provide a finite amount of distance between the user-filled buffer and the return address. With a long enough password, the attacker can still overwrite the return address.

Only the second answer is correct. The overflow happens precisely because input larger than the space allocated for that input is not rejected by the program.

### NVD Quiz
![](https://assets.omscs.io/notes/61204FE2-AD15-4170-BCB4-48EC8A23F6C1.png)

### NVD Quiz Solution
![](https://assets.omscs.io/notes/FFB98B29-CFB5-4F45-8359-BC6804E3D04D.png)

### Strongly Vs Weakly Typed Language Quiz
![](https://assets.omscs.io/notes/041BD85C-82D0-4D30-AABA-C35771B37CB3.png)

### Strongly Vs Weakly Typed Language Quiz Solution
![](https://assets.omscs.io/notes/BB9848DB-A87B-4B54-B4FE-4CDB1A596F7A.png)

### Buffer Overflow Attacks Quiz
![](https://assets.omscs.io/notes/0AF6ADAD-2A2D-435A-BE02-786B77295BA2.png)

### Buffer Overflow Attacks Quiz Solution
![](https://assets.omscs.io/notes/618CEAB7-54EA-4819-9CE8-12CA704FC5C1.png)

Stack canaries do prevent return-to-libc buffer overflow attacks, because stack canaries prevent return address overwriting. Without overwriting the return address, a function can only return to the function that called it.

ASLR does not protect against read-only buffer overflow exploits. ASLR only makes it harder to supply key addresses in write-based buffer overflow exploits.

Heartbleed cannot be avoided by using a non-executable stack. Heartbleed is a read-based buffer overflow exploit, and the attack did not involve injecting any machine instructions onto the stack.

## Operating System Security
### Secure OS Quiz 1
![](https://assets.omscs.io/notes/3E4E1A33-04F6-49C8-A8BE-5C9B97CD9F46.png)

[Mac vs PC Security](https://usa.kaspersky.com/resource-center/threats/mac-vs-pc#.VRLACxDF-Hw)

### Secure OS Quiz 1 Solution
![](https://assets.omscs.io/notes/A47F089A-E76B-45FB-8EAB-67A1410CD42A.png)

### Secure OS Quiz 2
![](https://assets.omscs.io/notes/8FB30729-124D-4073-9C7B-E9B8BE6B98AE.png)

### Secure OS Quiz 2 Solution
![](https://assets.omscs.io/notes/14FB0734-2CED-4A50-97FE-789C608E61C3.png)

A system call requires control transfer from the calling process into the OS, which then must perform authentication/authorization checks before granting access and transferring control back.

This is more costly than a regular call, which incurs none of this overhead.

### Secure OS Quiz 3
![](https://assets.omscs.io/notes/B1E759C2-2BDC-4F1D-87CC-D0FF65033E40.png)

### Secure OS Quiz 3 Solution
![](https://assets.omscs.io/notes/9F2E641A-BA27-4DEB-8754-E4C12B164432.png)

Processes run on behalf of users. Users must login to the system to run applications/processes.

### User Isolation Quiz
![](https://assets.omscs.io/notes/65EE949F-30AB-462D-ABAF-766E03061E1B.png)

### User Isolation Quiz Solution
![](https://assets.omscs.io/notes/2CF867D1-BB5E-4D7F-A303-4A6F0A5CC1AD.png)

### Revisiting Stack Overflow Quiz
![](https://assets.omscs.io/notes/5D690072-1177-4D13-9415-4E98EDD4BC2A.png)

### Revisiting Stack Overflow Quiz Solution
![](https://assets.omscs.io/notes/D1ECF899-825E-4B79-89D3-4B6B2A5A64FC.png)

### Execution Privilege Level Quiz
![](https://assets.omscs.io/notes/71D72E8A-2857-48A2-8D0C-0B88F2A66C77.png)

### Execution Privilege Level Quiz Solution
![](https://assets.omscs.io/notes/3716BF8E-4D50-43B3-936E-318EABBFDDB4.png)

### TCB Requirements Quiz
![](https://assets.omscs.io/notes/B91C6769-2EB6-41EC-884C-9BECF16EAA16.png)

### TCB Requirements Quiz Solution
![](https://assets.omscs.io/notes/449C3685-5396-4F92-A070-F09425449193.png)

In this case, we have tampered with the TCB by turning off the check. The access still proceeds through the operating system, and is still technically correct (i.e. the access wasn't permitted because of a bug).

### Size of Security Code
![](https://assets.omscs.io/notes/D40FCB93-786B-464E-B73E-ED5EAE001FE2.png)

### Size of Security Code Solution
![](https://assets.omscs.io/notes/A944CF7D-097D-4359-B600-BAB6F6E3BB8F.png)

I think the point being made here is that the increase in complexity may be accompanied by an increase in vulnerability.

### Hypervisor Code Size Quiz
![](https://assets.omscs.io/notes/8AE1A120-4AD3-44D6-9A06-C19DB78BC670.png)

### Hypervisor Code Size Quiz Solution
![](https://assets.omscs.io/notes/32D8E299-1B81-442E-8468-5834F515C381.png)

Again, the argument being made here is that using a hypervisor as a TCB, with fewer lines of code than a full-fledged operating system, might be a more secure choice.

## Authentication
### Authentication Quiz
![](https://assets.omscs.io/notes/196A1024-D729-4CE2-BA23-5C8D8CD10B6B.png)

### Authentication Quiz Solution
![](https://assets.omscs.io/notes/57996615-B926-4F51-BF29-E3372F1A5C63.png)

If someone steals your phone, you will be thankful for your lock screen/passcode.

### Login Attacks Quiz
![](https://assets.omscs.io/notes/5A9CA9D1-FD6A-413F-9DF6-43B0D94BBE71.png)

### Login Attacks Quiz Solution
![](https://assets.omscs.io/notes/DBB01EA0-AF2A-4894-96DF-5D34EEC42A10.png)

Remember, the positive event is gaining access to the system. A false positive is gaining access erroneously. An attacker authenticating as someone else is a false positive.

### Implementation Quiz
![](https://assets.omscs.io/notes/6E147430-22A9-4286-A6F3-475688360A5A.png)

### Implementation Quiz Solution
![](https://assets.omscs.io/notes/CC89677E-5EA4-41E8-899B-5697A658BA99.png)

### Password Popularity Quiz
![](https://assets.omscs.io/notes/7E55E7C7-D42D-49D1-8BD8-426BFA142037.png)

### Password Popularity Quiz Solution
![](https://assets.omscs.io/notes/3F2C0344-3371-466B-B6CF-D7D1E177661C.png)

If we are attacking systems, we might get the best bang for our buck trying these passwords.

### Password Quiz
![](https://assets.omscs.io/notes/24F5D97B-1D55-46CD-B2D8-8E795B30BA8F.png)

### Password Quiz Solution
![](https://assets.omscs.io/notes/31FE2544-CBD2-4906-B310-7F05DC21E645.png)

A trusted path ensures that there is no application between the user and the operating system. Without this path, malicious programs may intercept login credentials.

### Hashed Passwords Quiz
![](https://assets.omscs.io/notes/C4A2AD00-738F-455D-830F-718C3ED2205D.png)

### Hashed Passwords Quiz Solution
![](https://assets.omscs.io/notes/2F6B2EAE-5899-4DE4-B41A-49697B251132.png)

### Hash Function Characteristics Quiz
![](https://assets.omscs.io/notes/3F37F04D-3EC1-4EA7-A0F4-C3EE3098D70D.png)

### Hash Function Characteristics Quiz Solution
![](https://assets.omscs.io/notes/245963DD-ABEE-4364-96FA-16B7753AAD9C.png)

### Unique PINS Quiz
![](https://assets.omscs.io/notes/C7E9CD09-30CD-4A70-A3E8-12CA15DB1769.png)

### Unique PINS Quiz Solution
![](https://assets.omscs.io/notes/B3B14694-D6EC-4C26-B0F3-C00DBB302AB8.png)

With ten options for the first digit, ten options for the second digit, and so on, the total number of four digit pins is 10 * 10 * 10 * 10, or `10^4`, or 10,000.

### Brute Force Quiz
![](https://assets.omscs.io/notes/F88846E5-1F09-4695-9ABA-9C6786066E21.png)

### Brute Force Quiz Solution
![](https://assets.omscs.io/notes/0EA2B5B0-F329-4B96-80EA-1BF697743D43.png)

With 72 options for each other six characters, the total number of unique passwords is 72^6, which is the number of attempts the hacker will have to make in the very worst case.

### Touch Screen Passwords Quiz
![](https://assets.omscs.io/notes/AB789F7E-C3A5-4938-B5C9-58BF3C3424D9.png)

### Touch Screen Passwords Quiz Solution
![](https://assets.omscs.io/notes/D02FF363-D3A3-4D71-B4E6-E5A137CE04A8.png)

Basically, the idea here is that attackers will likely not have to exhaustively search the space of possible patterns because biases exist that greatly shrink this space into a much smaller space of much more probable patterns.

### Multi-factor Authentication Quiz
![](https://assets.omscs.io/notes/41CFA250-2487-4089-A2D7-D01CC482495F.png)

### Multi-factor Authentication Quiz Solution
![](https://assets.omscs.io/notes/CC9A6A59-47B9-465A-BCAD-4F0257BE84A5.png)

Remember, a false positive occurs when a malicious user is granted access to the system as a valid user. The likelihood of this happening decreases when multiple authentication components are employed by the system.

### Chip and Pin Authentication Quiz
![](https://assets.omscs.io/notes/77924BCE-4594-4893-B02E-08E46A624821.png)

### Chip and Pin Authentication Quiz Solution
![](https://assets.omscs.io/notes/4668FB80-8C96-4083-A753-7E4A41F8CC1D.png)

Read more [here](http://www.darkreading.com/vulnerabilities---threats/flaws-in-emv-chip-and-pin-undercut-security/d/d-id/1269155) and [here](https://www.schneier.com/blog/archives/2014/05/preplay_attack_.html).

### Biometric Authentication Quiz
![](https://assets.omscs.io/notes/3D51F432-5BE0-41DC-BCE5-243BEEF20CA6.png)

### Biometric Authentication Quiz Solution
![](https://assets.omscs.io/notes/62C0DA99-A728-42B8-867F-D0FB6CEB9DA2.png)

As a basic example, consider someone recording your voice and playing it back to a voice-based authentication system.

## Access Control
### Data Confidentiality Quiz
![](https://assets.omscs.io/notes/AD434002-43B3-41CC-A837-4B2BBFA18017.png)

### Data Confidentiality Quiz Solution
![](https://assets.omscs.io/notes/C9D0D775-0D1F-4695-9F4F-8EBA71914E34.png)

Controlling read access is connected to data confidentiality, while controlling write access is connected to data integrity.

### Determining Access Quiz
![](https://assets.omscs.io/notes/104BA89A-BC90-4875-A0BD-48765D8DD073.png)

### Determining Access Quiz Solution
![](https://assets.omscs.io/notes/0E90ADD5-3CCB-4A69-9C9E-55E06E88A8E8.png)

Access control conflicts can be securely resolved by denying access.

### Discretionary Access Control Quiz
![](https://assets.omscs.io/notes/8C822B06-A689-4ABC-BC3C-69517F39029D.png)

### Discretionary Access Control Quiz Solution
![](https://assets.omscs.io/notes/69519ED2-526D-47DB-8CFF-B3A922D2DBDF.png)

Bob can write the contents of the file to a new file that he owns, and share that file with Charlie.

### ACE Quiz
![](https://assets.omscs.io/notes/38DA4583-E908-4834-A4A8-A30FB65A2754.png)

### ACE Quiz Solution
![](https://assets.omscs.io/notes/89BFDAE7-ED13-41D6-BB4C-01D5948DD108.png)

The presentation of the ticket is sufficient to gain access to the theater. No other access checks are required. This is closest in functionality to a capability.

### ACE Access Quiz
![](https://assets.omscs.io/notes/790A92B9-8315-4A52-8B83-9F7CF9F33947.png)

### ACE Access Quiz Solution
![](https://assets.omscs.io/notes/0D94E256-D8D9-4BCE-9E83-F7BFD18F7E20.png)

Negative access rights supersede positive access rights, so you can't terminate as soon as you find a positive access right. You can terminate as soon as you find a negative access right, though.

NB: The third option can't be true if the second option is true.

### Revocation of Rights Quiz
![](https://assets.omscs.io/notes/99C6BB65-DB67-42A9-A133-484EAEC0498C.png)

### Revocation of Rights Quiz Solution
![](https://assets.omscs.io/notes/06734230-A91A-4DCB-BBC0-35AF61DC9A09.png)

### Time to Check vs Time to Use Quiz
![](https://assets.omscs.io/notes/252D27FB-9B58-4DCD-AE9C-6D6B7C3143E9.png)

### Time to Check vs Time to Use Quiz Solution
![](https://assets.omscs.io/notes/B464C794-6718-40DB-BDAB-EAA956AD1C13.png)

As long as you had the permissions when you called `open`, you can access the file using the file descriptor.

### Unix File Sharing Quiz
![](https://assets.omscs.io/notes/88897E9D-9338-459B-B582-7A87A6EB74E6.png)

### Unix File Sharing Quiz Solution
![](https://assets.omscs.io/notes/8E7ED659-B2F6-4823-A54F-C312F6110482.png)

You would need to somehow add the descriptor to the per-process descriptor table for the process with which you wish to share the descriptor. Since the OS owns this table, mutating it is impossible.

### SetUID Bit Quiz
![](https://assets.omscs.io/notes/71AAA4B5-5DD3-414A-8317-8BB17007E533.png)

### SetUID Bit Quiz Solution
![](https://assets.omscs.io/notes/E2739829-4308-4DBE-8C7D-0AAF1025E54E.png)

The effective UID of a process executing a file with the setuid bit set is the owner of the file, not the user who created the process.

### RBAC Benefits Quiz
![](https://assets.omscs.io/notes/D1B82974-ED31-4162-B636-012F375BCE35.png)

### RBAC Benefits Quiz Solution
![](https://assets.omscs.io/notes/01A48AF0-F1FD-4085-A588-4BA0C746FE0C.png)

### Access Control Policy Quiz
![](https://assets.omscs.io/notes/7221A53F-3B6C-4CA2-9738-3A63FCA7CEFA.png)

### Access Control Policy Quiz Solution
![](https://assets.omscs.io/notes/5DEE9998-897C-4B46-8565-A383DD6FC069.png)

From a security standpoint, denying access is a fail-safe default. It never fails to keep your system secure.

## Mandatory Access Control
### DAC Quiz
![](https://assets.omscs.io/notes/FFAA8FAE-B0AC-421F-A71A-2B59F7D76D87.png)

### DAC Quiz Solution
![](https://assets.omscs.io/notes/CC4FCC5B-CC40-4ADC-8AC7-B14CEA595009.png)

DAC can't control information flow, so we must use MAC.

### Health Data Quiz
![](https://assets.omscs.io/notes/B190798D-AB66-4B7B-938B-ED38D21FBB4C.png)

### Health Data Quiz Solution
![](https://assets.omscs.io/notes/9EF783B9-6360-427A-918C-CDF9773C4034.png)

BLP is concerned with military/governmental intelligence. HIPAA is concerned with health information.

### Security Clearance Quiz
![](https://assets.omscs.io/notes/4492690A-933D-4088-BCCC-51031EA9A047.png)

### Security Clearance Quiz Solution
![](https://assets.omscs.io/notes/D0C61525-5A43-4B43-8C64-4CCBC4715B41.png)

Source: [Washington Post](https://www.washingtonpost.com/news/the-switch/wp/2014/03/24/5-1-million-americans-have-security-clearances-thats-more-than-the-entire-population-of-norway/?noredirect=on)

### Order Quiz
![](https://assets.omscs.io/notes/2F90AB65-3E72-4760-BB6B-28DB02993748.png)

### Order Quiz Solution
![](https://assets.omscs.io/notes/37633CE2-16DD-45D5-B67D-52318AF4DD6E.png)

Given any two real numbers, one number is always greater than the other.

### Label Domination Quiz
![](https://assets.omscs.io/notes/11C6E389-14C8-4928-B128-A743249D4F2A.png)

### Label Domination Quiz Solution
![](https://assets.omscs.io/notes/89DAADB0-D668-480D-8B6D-38C0037CCE42.png)

While `secret < top-secret` , `{Asia, Europe}` cannot be compared with `{Europe, South-America}`.

### Sensitive Data Quiz
![](https://assets.omscs.io/notes/65E58104-8D29-4E6C-AE31-FCB742D1C233.png)

### Sensitive Data Quiz Solution
![](https://assets.omscs.io/notes/34881303-A27C-4BB1-807C-03DE3A0016D9.png)

In order for `D1` to dominate `D2`, `D1` must have a higher sensitivity level than `D2`.

In addition, the compartment of `D1` must contain the compartment of `D2` in order to be 'greater' (based on the ordering rules for sets). For this to be the case, the compartment of `D2` must be a subset of ("narrower" than) the compartment of `D1`.

### Unclassified Documents Quiz
![](https://assets.omscs.io/notes/EA4A6F50-B773-4345-BD3C-28CFB3AEA7D4.png)

### Unclassified Documents Quiz Solution
![](https://assets.omscs.io/notes/3D70CF4F-3BC7-40D2-B75C-FB84BB1CE0D8.png)

Write-down says that individuals cannot write documents with a classification that is less than their security clearance. Therefore, unclassified documents cannot be written by individuals holding a security clearance of classified, secret, or top secret.

### Classified Data Quiz
![](https://assets.omscs.io/notes/2BE2011C-6B0A-4D48-BF24-575316A8F447.png)

### Classified Data Quiz Solution
![](https://assets.omscs.io/notes/A699ECFA-0934-4CCD-9C63-056FD1E46428.png)

Because of the write-up rule, individuals are allowed to write documents at a classification level that is greater than their clearance level. Individuals with unclassified security clearance are thus allowed to write top secret documents.

### BLP Model Quiz
![](https://assets.omscs.io/notes/C4229ADC-2062-4802-BD5C-8BA008F90F29.png)

### BLP Model Quiz Solution
![](https://assets.omscs.io/notes/3D182BB1-66B8-4F82-8795-E5BEEA1C6F11.png)

For example, if a user is writing to a top secret document, and the classification level suddenly changes to secret, the write-up rule is violated and information is flowing in the wrong direction.

### Clark Wilson Quiz
![](https://assets.omscs.io/notes/A286764A-C66E-4C60-9CE7-106440934312.png)

### Clark Wilson Quiz Solution
![](https://assets.omscs.io/notes/A4317935-9B6A-4DB8-869A-1644B8A403F0.png)

In mandatory access control, sharing decisions are not made at the discretion of the user.

### COI Quiz
![](https://assets.omscs.io/notes/FD528D21-BCC6-48D4-A1F4-179CB9A9470B.png)

### COI Quiz Solution
![](https://assets.omscs.io/notes/2A693A0B-93E6-4AE5-B6AB-3869601B5800.png)

Competition implies that there is a possibility for a conflict of interest. Chinese Wall is best at preventing these situations.

### RBAC Quiz
![](https://assets.omscs.io/notes/18AF82C6-AE0E-4A04-BE46-24C199FAC8DF.png)

### RBAC Quiz Solution
![](https://assets.omscs.io/notes/E32A017C-052D-4DF1-94CA-ABBD02770338.png)

In mandatory access control, the company decides who can share what.

### MAC Support Quiz
![](https://assets.omscs.io/notes/1F3AB8F6-7244-44E3-91BD-833C137AC8FD.png)

### MAC Support Quiz Solution
![](https://assets.omscs.io/notes/B94746DE-2747-401F-B607-68799681137C.png)

### Least Privilege Quiz
![](https://assets.omscs.io/notes/125DFCBE-E30F-4B38-AE98-DB12FA30C0DC.png)

### Least Privilege Quiz Solution
![](https://assets.omscs.io/notes/FC19D98D-46EB-46BE-8AE3-7C75BF6E482B.png)

The TCB provides high assurance, not certainty.

### TCB High Assurance Quiz
![](https://assets.omscs.io/notes/F33DDE22-EF71-4878-9A86-1153AE4C938B.png)

### TCB High Assurance Quiz Solution
![](https://assets.omscs.io/notes/47F700ED-F1EE-4693-B99C-5117AEEF93A2.png)

Security by obscurity violates open design.

### Design Principle Quiz
![](https://assets.omscs.io/notes/130DA7AD-F9EE-498B-807C-C00F7111C79B.png)

### Design Principle Quiz Solution
![](https://assets.omscs.io/notes/D70011C5-D8EA-404D-82A6-7A6C4A77DDDB.png)

A fail-safe default is one that provides security unless otherwise specified. In this case, the default should be traffic encryption.

### Reducing TCB Size Quiz
![](https://assets.omscs.io/notes/11F63B01-9D9D-4070-B054-C4DE0A004584.png)

### Reducing TCB Size Quiz Solution
![](https://assets.omscs.io/notes/B9687C3C-5D80-45A9-9112-224E955CDF88.png)

### Testing TCB Quiz
![](https://assets.omscs.io/notes/DFED8BC1-EB62-44EB-A00D-06864E69B0AE.png)

### Testing TCB Quiz Solution
![](https://assets.omscs.io/notes/5F87B5BC-DB54-413C-8348-BF6973C787F5.png)

Testing can't show the absence of problems.

### Model Checking Quiz
![](https://assets.omscs.io/notes/1DD38815-AC14-4050-8BE4-CD4B6545DE3B.png)

### Model Checking Quiz Solution
![](https://assets.omscs.io/notes/B90F59EF-3CF9-42B6-BC7C-6237B4AB68B2.png)

### TCSEC Divisions Quiz
![](https://assets.omscs.io/notes/812B3058-CB14-4745-9085-7D918AD2AE0F.png)

### TCSEC Divisions Quiz Solution
![](https://assets.omscs.io/notes/472F8C5A-752D-4F31-B25E-1AB70F353DDF.png)

### Earning an EAL4 Certification Quiz
![](https://assets.omscs.io/notes/1BD7FA8D-A4A3-420D-B034-5DE4ACFF0305.png)

### Earning an EAL4 Certification Quiz Solution
![](https://assets.omscs.io/notes/54D03A5C-FF37-40C9-A359-3F2B765910B4.png)

### Cost Benefit Certification Tradeoffs Quiz
![](https://assets.omscs.io/notes/0DB30C2E-0FDD-438F-8532-4B6CC06E7977.png)

### Cost Benefit Certification Tradeoffs Quiz Solution
![](https://assets.omscs.io/notes/FC3F201F-6A8B-4E3B-9725-E8128B9719E5.png)

## Database Security
### Database Threats Quiz
![](https://assets.omscs.io/notes/DF4376DB-23F1-4197-A713-0D67A365E539.png)

### Database Threats Quiz Solution
![](https://assets.omscs.io/notes/EEA0ABC9-F002-4A9D-8654-81E456D1921D.png)

[Source](http://www.oracle.com/us/products/database/2014-ioug-dba-security-superhero-2338955.pdf)

### Database Hacking Quiz
![](https://assets.omscs.io/notes/BC720089-2712-4976-B060-FF39DC587337.png)

### Database Hacking Quiz Solution
![](https://assets.omscs.io/notes/027DCEF8-3F17-4FD1-8D27-191328C18040.png)

### Key Value Quiz
![](https://assets.omscs.io/notes/83E4EFF2-3CED-4058-AD08-39D3DEFC3A62.png)

### Key Value Quiz Solution
![](https://assets.omscs.io/notes/66B99FB2-D304-43C2-979E-BDA1CAD672A8.png)

A primary key uniquely identifies a row.

### Database Views Quiz
![](https://assets.omscs.io/notes/12C1B7B6-9B61-4C2A-B9CB-55D63FB07E0A.png)

### Database Views Quiz Solution
![](https://assets.omscs.io/notes/8046AD01-9F33-468B-9F3E-2A1D04087814.png)

### Database Access Control Quiz
![](https://assets.omscs.io/notes/7D499BB8-5C13-4A36-8CF3-0C3E8F301532.png)

### Database Access Control Quiz Solution
![](https://assets.omscs.io/notes/11C78BAE-41F8-42FC-8AFE-F234639D2D20.png)

### Cascading Authorizations Quiz
![](https://assets.omscs.io/notes/31AD71A2-E008-405D-8F49-8C4A9CA746D9.png)

### Cascading Authorizations Quiz Solution
![](https://assets.omscs.io/notes/4A856303-A0BB-473A-8E98-41306F1E2AE4.png)

### DAC or MAC Quiz
![](https://assets.omscs.io/notes/5947BE2E-48E7-4792-A77C-432EBC939BF2.png)

### DAC or MAC Quiz Solution
![](https://assets.omscs.io/notes/6AED63B6-5A43-4EF8-BDCF-3624B7789381.png)

### SQL Login Quiz
![](https://assets.omscs.io/notes/29ADEB96-538D-470A-85E1-28D2D25B40AC.png)

### SQL Login Quiz Solution
![](https://assets.omscs.io/notes/6FF291D3-98CE-4AD1-93D7-9A93431D5335.png)

### SQL Login Quiz 2
![](https://assets.omscs.io/notes/7BA1E896-52B9-43EB-A710-2EB5C7170141.png)

### SQL Login Quiz 2 Solution
![](https://assets.omscs.io/notes/87FB43B8-EEE7-4BB8-A3CE-10DFA9911FAE.png)

### SQL Inference Attack Quiz
![](https://assets.omscs.io/notes/972B9CAC-ECD3-40CF-9187-8CA4B3F1E280.png)

### SQL Inference Attack Quiz Solution
![](https://assets.omscs.io/notes/379AB37B-1684-45F6-AD8D-54C00A35629B.png)

### SQL Inference Attack Quiz 2
![](https://assets.omscs.io/notes/0C1BADC4-C735-4958-9274-F9F2DB3E9411.png)

### SQL Inference Attack Quiz 2 Solution
![](https://assets.omscs.io/notes/13759837-A50F-4319-9A86-FDD985C5EE27.png)

Consider the case where one student from a region containing two students retrieves the grade information about that region.

## Malicious Code
### What is Malware Quiz
![](https://assets.omscs.io/notes/40637903-CAAE-402C-9F8D-DC289CB7EC62.png)

### What is Malware Quiz Solution
![](https://assets.omscs.io/notes/07625575-7DE3-4F7F-AEF7-5E0B1178E7A7.png)

### Host Required Malware Quiz 1
![](https://assets.omscs.io/notes/A4EDCDB2-1BCA-44CE-82D9-F9F87A38CED2.png)

### Host Required Malware Quiz 1 Solution
![](https://assets.omscs.io/notes/5FECA411-7C95-4E9C-B485-2FB274E512F5.png)

### Host Required Malware Quiz 2
![](https://assets.omscs.io/notes/21C54A27-F1F6-4A37-969F-A29DE164F9F5.png)

### Host Required Malware Quiz 2 Solution
![](https://assets.omscs.io/notes/049C97B7-000C-4F42-8755-89BDE3A06DB9.png)

### Types of Viruses Quiz
![](https://assets.omscs.io/notes/133BBEDD-CE14-4ED3-A8ED-48F539E3E52B.png)

### Types of Viruses Quiz Solution
![](https://assets.omscs.io/notes/6294734B-447D-4C84-9F5E-C80BD8923832.png)

Macro viruses run when an infected document is opened with a given application. Boot sector viruses run before the operating system is loaded.

### Rootkit Quiz
![](https://assets.omscs.io/notes/F9D17F35-7B72-4538-9425-77C62F298C1D.png)

### Rootkit Quiz Solution
![](https://assets.omscs.io/notes/F4D927F4-F0EF-4056-9F9C-3979A28E1375.png)

### Truth and Misconceptions Quiz
![](https://assets.omscs.io/notes/C55A0FCE-82C4-4243-83F9-9FE14B9B1982.png)

### Truth and Misconceptions Quiz Solution
![](https://assets.omscs.io/notes/FE1571D1-8225-4963-ABEA-379773BD8D9A.png)

### Worm Quiz
![](https://assets.omscs.io/notes/63C5BA47-1177-48B3-8C53-AB4B8BD90395.png)

### Worm Quiz Solution
![](https://assets.omscs.io/notes/60DAF027-9368-40B6-AE36-FC6EA78B32B8.png)

### Malware Prevention & Detection Quiz
![](https://assets.omscs.io/notes/36682CCE-48D2-43A0-B174-A5558BA230E6.png)

### Malware Prevention & Detection Quiz Solution
![](https://assets.omscs.io/notes/919A3EB0-92AE-4221-BFC5-D339E835C7E6.png)

### Most Expensive Worm Quiz
![](https://assets.omscs.io/notes/8C469D3D-9061-45F2-8B2F-53D35CBD5A30.png)

### Most Expensive Worm Quiz Solution
![](https://assets.omscs.io/notes/38A65997-26BC-4D80-A560-169AF0930940.png)

[Source](https://encyclopedia2.thefreedictionary.com/Top+10+Worst+Computer+Worms+of+All+Time)

## Modern Malware
### Bot Quiz
![](https://assets.omscs.io/notes/133D2EE2-25A2-4657-A7B4-78A70EDC2E60.png)

### Bot Quiz Solution
![](https://assets.omscs.io/notes/FF650996-73FA-4E4C-B893-FA0A8F302E79.png)

### DDoS Quiz
![](https://assets.omscs.io/notes/B4B116A3-24D3-40AB-86DE-DF49D439D91E.png)

### DDoS Quiz Solution
![](https://assets.omscs.io/notes/3F23779C-7FEB-4551-A120-ED3B7046EFF2.png)

Remember, the characteristics of DNS servers can be used to amplify the effects of DDoS attacks, not mitigate them.

### C&C Design Quiz
![](https://assets.omscs.io/notes/185071EA-CDCF-47EC-8D44-9F63D543C5DD.png)

### C&C Design Quiz Solution
![](https://assets.omscs.io/notes/FE123C3D-C49F-4AA5-80F0-0DF1EF468A48.png)

The second answer is false. Bot code can have logic bombs or other triggers that enable bot to attack without contacting a C&C server.

The third answer is also false. A botnet is more likely to be found using custom communication protocols, as admins observing the network are more likely to detect strange types of traffic flowing from their system.

### Botnet C&C Quiz
![](https://assets.omscs.io/notes/B94A4FF5-8F9D-4252-9849-4DFAFCAA5640.png)

### Botnet C&C Quiz Solution
![](https://assets.omscs.io/notes/F388379F-0461-46F3-9211-1ADA9775FEE1.png)

A single gmail account, hardcoded in bot code, is both easy to detect and easy to disrupt.

P2P traffic will easily stand out in an enterprise network where peer-to-peer communications are not typically allowed.

A news site can be hard to detect, because traffic to news websites is common. However, if the site is identified as being malicious, it can easily be blocked.

### APT Quiz
![](https://assets.omscs.io/notes/31C8957F-328A-463B-98E6-8D5FA5481366.png)

### APT Quiz Solution
![](https://assets.omscs.io/notes/012DC084-0287-4D85-9D3B-0C2003FB716A.png)

### Malware Analysis Quiz
![](https://assets.omscs.io/notes/A14989C9-C5D0-4F0D-B937-F9F9E8B01079.png)

### Malware Analysis Quiz Solution
![](https://assets.omscs.io/notes/C371FC26-E6A5-42D1-870F-5C4914E47789.png)

## Firewalls
### Firewalls Quiz
![](https://assets.omscs.io/notes/F9F12971-51F9-4D97-8CDD-ABD6DE61A09F.png)

### Firewalls Quiz Solution
![](https://assets.omscs.io/notes/CD0D727F-C0F6-4B52-9B85-95B0D5540FED.png)

### Firewall Features Quiz
![](https://assets.omscs.io/notes/C58A7F53-1221-4BCD-9F63-3DD25ED340E1.png)

### Firewall Features Quiz Solution
![](https://assets.omscs.io/notes/08146EF7-844E-4DF4-AF9B-46A4EFE810B9.png)

### Firewall Filtering Quiz
![](https://assets.omscs.io/notes/948B9D27-D7EE-499D-945D-B272DEF09A1C.png)

### Firewall Filtering Quiz Solution
![](https://assets.omscs.io/notes/448612E5-28F9-422A-ADBA-7661F4D4F1EF.png)

The first example follows the "default drop" rule, which is high security but requires new services to be expressly allowed. The second example follows the "default forward" rule, which is easier to use at the expense of security. The final approach sits in between the two in terms of security and ease of use.

### Packet Filtering Quiz
![](https://assets.omscs.io/notes/97AF2EAE-DC71-4E99-AF2D-49520F5D1BD1.png)

### Packet Filtering Quiz Solution
![](https://assets.omscs.io/notes/6C72F7E1-2A20-4826-8080-A48DEC8CEDB5.png)

### Filtering Quiz
![](https://assets.omscs.io/notes/5BE501CE-84FD-4BC6-A5A8-1334384E7466.png)

### Filtering Quiz Solution
![](https://assets.omscs.io/notes/1F34A051-C027-4F76-BEA7-4BF6151DE243.png)

### Personal Firewalls Quiz
![](https://assets.omscs.io/notes/318AE0E6-A077-413E-9B08-A6E3263B8E08.png)

### Personal Firewalls Quiz Solution
![](https://assets.omscs.io/notes/AE45FA72-0C13-4F06-A89A-620E2894EBFC.png)

If the device is not always protected by the corporate network, as is the case in scenarios 1 and 3, then the personal firewall is needed for additional security.

### Firewall Deployment Quiz
![](https://assets.omscs.io/notes/EFDA0A4D-B9D3-417D-9025-2E23F564DDE1.png)

### Firewall Deployment Quiz Solution
![](https://assets.omscs.io/notes/A765E6A6-3A0E-4F47-86B5-F56A9C0E3BFA.png)

### Stand Alone Firewall Quiz
![](https://assets.omscs.io/notes/DCDD7C22-F6A1-449E-A7B5-013C5D1324A4.png)

### Stand Alone Firewall Quiz Solution
![](https://assets.omscs.io/notes/F83D170A-A182-4CD1-A70E-A816AB4D8FD7.png)

## Intrusion Detection
### Intrusion Detection Quiz
![](https://assets.omscs.io/notes/6FCC8EA1-D76B-4CD2-A7B2-C959F599631A.png)

### Intrusion Detection Quiz Solution
![](https://assets.omscs.io/notes/D8BA0592-C705-4DEA-8677-C198872DAD54.png)

### Intruder Quiz
![](https://assets.omscs.io/notes/62299D09-AF06-4DCC-8C70-37251796390A.png)

### Intruder Quiz Solution
![](https://assets.omscs.io/notes/BE79FB0F-8998-4A34-9B1D-89C3DF2DFA2E.png)

### Types of Backdoors Quiz
![](https://assets.omscs.io/notes/7BB48E4A-080C-41DF-BDFF-981789BA55DC.png)

### Types of Backdoors Quiz Solution
![](https://assets.omscs.io/notes/72F9A46A-F7C2-43E0-84F0-BC956FF413A6.png)

Read more [here](http://www.infoworld.com/article/2606776/hacking/155947-Biggest-baddest-boldest-software-backdoors-of-all-time.html#slide3), [here](https://www.gnu.org/philosophy/proprietary-back-doors.html), and [here](https://www.eecs.berkeley.edu/~daw/teaching/cs261-f07/scribenotes/1025-brian.pdf).

### Analysis Detection Quiz
![](https://assets.omscs.io/notes/F83D983E-10A9-4BFC-9007-006DA276551C.png)

### Analysis Detection Quiz Solution
![](https://assets.omscs.io/notes/3804546D-535E-4812-99F9-68C4039BA79A.png)

### Signature Detection Quiz
![](https://assets.omscs.io/notes/54F22B6A-68FA-478A-9A18-6697555EE8C2.png)

### Signature Detection Quiz Solution
![](https://assets.omscs.io/notes/45F0F4C2-AE2D-4F2E-9598-779B6D797F58.png)

### Anomaly Quiz
![](https://assets.omscs.io/notes/B557672F-381D-4AA9-B3E0-79D35CA0CA65.png)

### Anomaly Quiz Solution
![](https://assets.omscs.io/notes/EFCDDFD7-05BB-4564-8CD3-6CA8FBF651E7.png)

### Statistical & Knowledge Based Approaches Quiz
![](https://assets.omscs.io/notes/FD8DAA8E-9BDA-49E7-B155-99D4ED73C602.png)

### Statistical & Knowledge Based Approaches Quiz Solution
![](https://assets.omscs.io/notes/795F294B-48FC-4667-89FB-BEFB856FF9B3.png)

### Machine Learning Quiz
![](https://assets.omscs.io/notes/F832A03B-6CE6-465D-87EB-1766FA05D423.png)

### Machine Learning Quiz Solution
![](https://assets.omscs.io/notes/B66DFC3A-5CAF-4FBF-ACCC-B2EE1F2F0F1E.png)

### Anomalous Behavior Quiz
![](https://assets.omscs.io/notes/73D531B9-DAB0-4B29-93CE-057BE5A1F4B0.png)

### Anomalous Behavior Quiz Solution
![](https://assets.omscs.io/notes/9E4397E7-D80E-4A34-8B6F-5F22F297369E.png)

### Zero Day Market Place Quiz
![](https://assets.omscs.io/notes/60C770A8-12A9-4FA4-A475-CECF25987C9D.png)

### Zero Day Market Place Quiz Solution
![](https://assets.omscs.io/notes/2AE76DB1-1D8B-448A-8256-C61796C19DE4.png)

### Attacks Quiz
![](https://assets.omscs.io/notes/F5CFF1A9-853F-4258-9A6A-C5ACDD8C643A.png)

### Attacks Quiz Solution
![](https://assets.omscs.io/notes/4D15090A-E7EB-4230-BD11-E816124BDA06.png)

### NIDS Quiz
![](https://assets.omscs.io/notes/6B45119B-AA0A-47F6-822D-A5FC37269B12.png)

### NIDS Quiz Solution
![](https://assets.omscs.io/notes/05B818DD-0EA3-4203-B87D-3DE4FD93663C.png)

### IDS Quiz
![](https://assets.omscs.io/notes/30738940-A839-4656-B153-027BD6CF97A0.png)

### IDS Quiz Solution
![](https://assets.omscs.io/notes/8FB406A3-4B50-49BB-AA37-C33F19784845.png)

### NIDS Sensor Deployed Quiz
![](https://assets.omscs.io/notes/599591ED-6BDC-4FCF-BA83-BBC590E815E7.png)

### NIDS Sensor Deployed Quiz Solution
![](https://assets.omscs.io/notes/63258409-141A-434F-B9CD-8DF34C46C864.png)

### Snort Quiz
![](https://assets.omscs.io/notes/73F79545-4C3F-44B2-A4EC-DA4D4E300729.png)

### Snort Quiz Solution
![](https://assets.omscs.io/notes/207F97E0-2041-461C-864F-27A2D73B4924.png)

### Honeypot Quiz
![](https://assets.omscs.io/notes/6BBDB4A2-6E49-4DD1-B761-1BED24EB3322.png)

### Honeypot Quiz Solution
![](https://assets.omscs.io/notes/C6889A78-B3F7-4738-B4CF-B81149D61644.png)

### IDS Quiz
![](https://assets.omscs.io/notes/EE0009BB-048C-4192-8372-0752194F9C8F.png)

### IDS Quiz Solution
![](https://assets.omscs.io/notes/67B4C307-4630-470A-9E6E-EDB4C4FDC0D8.png)

### IDS Attack Quiz
![](https://assets.omscs.io/notes/85CA9C14-3D97-4B61-BCCE-F2C703BCDC0D.png)

### IDS Attack Quiz Solution
![](https://assets.omscs.io/notes/B0C3AD98-1CF0-4438-9A0E-81511D82D085.png)

## Introduction to Cryptography
### Encryption Attack Quiz
![](https://assets.omscs.io/notes/DAF48208-84E4-496E-B228-B4C8B0B841CA.png)

### Encryption Attack Quiz Solution
![](https://assets.omscs.io/notes/462EA39F-5754-47D1-B624-335F35CF3647.png)

In a brute-force attack, the attacker must try all potential keys. The only way to make this task more difficult is to increase the length of the key, thus increasing the size of the keyspace.

### Simple Ciphers Quiz
![](https://assets.omscs.io/notes/88162C87-3BE8-476A-BC36-E9B325A11A04.png)

### Simple Ciphers Quiz Solution
![](https://assets.omscs.io/notes/B6279774-5618-4B04-8081-1499BCF75299.png)

Since "A" maps to "D", "B" maps to "E", and so forth, we can just "rewind" each letter in the ciphertext by three to obtain the plaintext.

### Monoalphabetic Cipher Quiz
![](https://assets.omscs.io/notes/693FC6D9-96D7-4E8D-8736-0D2D2CD8165D.png)

### Monoalphabetic Cipher Quiz Solution
![](https://assets.omscs.io/notes/43C05969-AD5E-4A44-A49D-590BD32B62FD.png)

### Vigenere Cipher Quiz
![](https://assets.omscs.io/notes/C188A430-4FD1-41CB-B6F3-1991645DB0E1.png)

### Vigenere Cipher Quiz Solution
![](https://assets.omscs.io/notes/4F4575D2-8431-473F-9F1B-AF4BC57359C6.png)

### Hash Function Quiz
![](https://assets.omscs.io/notes/333D362C-324B-4AE9-9256-66111A0EAA3B.png)

### Hash Function Quiz Solution
![](https://assets.omscs.io/notes/9FCFF378-D376-46B5-8734-E5DB63549DCA.png)

The **avalanche effect** states that a small change in the input to a hash function causes a large change to the output. We want this in place as a way to obscure similar passwords. Without the avalanche effect, an attacker may be able to deduce password `A` from its hash value if he knows that the hash of a string `B` is similar to `A`'s hash.

### Symmetric Encryption Quiz
![](https://assets.omscs.io/notes/1E31561D-622A-48AB-8B4B-D46F37A11AD1.png)

### Symmetric Encryption Quiz Solution
![](https://assets.omscs.io/notes/5F18ADCF-329B-4A37-9876-305990D371B2.png)

### Asymmetric Encryption Quiz
![](https://assets.omscs.io/notes/2CAA6C73-F6D0-4797-B4A7-FABFA269EFF6.png)

### Asymmetric Encryption Quiz Solution
![](https://assets.omscs.io/notes/1374D8F4-378E-4CD8-9B80-511E87EA2F3C.png)

### Encryption Quiz
![](https://assets.omscs.io/notes/623ADEEA-F8E3-4CC7-A61B-51EC26C8F93B.png)

### Encryption Quiz Solution
![](https://assets.omscs.io/notes/CB248B54-A4DA-49D9-A9DC-477AE73A38B3.png)

## Symmetric Encryption
### Block Cipher Quiz
![](https://assets.omscs.io/notes/F77DC130-7DC8-46BD-A0EF-6A05F934BF23.png)

### Block Cipher Quiz Solution
![](https://assets.omscs.io/notes/5A22576A-05B2-48C1-AE69-874601220654.png)

### XOR Quiz
![](https://assets.omscs.io/notes/E6D8649E-9459-4BE3-8091-6B4FB8C456FF.png)

### XOR Quiz Solution
![](https://assets.omscs.io/notes/9E317675-DB11-4A1E-AAC8-D59F6667ABB9.png)

"H" has an ASCII code of 72, which maps to `0b01001000`, and "i" has an ASCII code of 105, which maps to `0b01101001`. "F" maps to 15 (`0b1111`) and "A" maps to 11 (`0b1001`), so "FA" maps to `0b11111001` and "F2" maps to `0b11111001`.

We XOR two numbers bit-by-bit, and we return 0 when the bits match and 1 otherwise. Therefore `0b0100100001101001` XOR `0b1111100111110010` is `0b1011000110011011`.

### S Box Quiz
![](https://assets.omscs.io/notes/47A34B5B-85A1-45EE-BB2F-07EC4B1A59AB.png)

### S Box Quiz Solution
![](https://assets.omscs.io/notes/0C60D9C2-1E8B-45D3-8410-8C63C9F1FDE8.png)

### DES Quiz
![](https://assets.omscs.io/notes/FCF98268-BDC4-48AA-8E11-39B427244D6B.png)

### DES Quiz Solution
![](https://assets.omscs.io/notes/3233B23D-A5CA-4E0E-9818-C9FC4773221C.png)

### AES Encryption Quiz
![](https://assets.omscs.io/notes/194759AE-0DA0-4C26-87D6-66A9E764598A.png)

### AES Encryption Quiz Solution
![](https://assets.omscs.io/notes/A427A006-090C-4F5B-AA31-32FBA20D10C3.png)

### CBC Quiz
![](https://assets.omscs.io/notes/DBF9FA91-292C-4847-ABFB-2C1166D0D5CA.png)

### CBC Quiz Solution
![](https://assets.omscs.io/notes/5146C532-57F6-4F41-9D3E-2512206871DE.png)

## Public-Key Cryptography

### Additive Inverse Quiz
![](https://assets.omscs.io/notes/90F567FE-9F15-4966-A205-678D05E4DF66.png)

### Additive Inverse Quiz Solution
![](https://assets.omscs.io/notes/E00E3BB9-A148-4AFA-8A9E-DAFA95C4DC80.png)

In modular addition, a number $k$  has an inverse $k'$ such that $k + k' \pmod M = 0$. In this case, $M = 20$ and $k = 8$. Therefore, $k' = 12$ because $8 + 12 \pmod{20} = 0$.

### Modular Multiplication Quiz
![](https://assets.omscs.io/notes/89D8C09E-CF46-4E8F-8F14-B9F075C0302C.png)

### Modular Multiplication Quiz Solution
![](https://assets.omscs.io/notes/252A1D26-CED8-446B-B012-40592D172D03.png)

In modular multiplication, a number $k$  has an inverse $k'$ such that $k * k' \pmod M = 1$. In this case, $M = 17$ and $k = 3$. Therefore, $k' = 6$ because $3 * 6 \pmod{17} =  18 \pmod{17} = 1$.

### Totient Quiz
![](https://assets.omscs.io/notes/E9CACF9B-A69C-4D35-8FF1-1B8D1AC252ED.png)

### Totient Quiz Solution
![](https://assets.omscs.io/notes/4A80521F-0882-4BAC-A178-7A72A29A1531.png)

If $n = p * q$ and $p$ and $q$ are prime, then $\phi(n) = (p - 1) * (q - 1)$. For $n = 21$, $p = 3$ and $q = 7$, $\phi(n) = (3 - 1) * (7 - 1) = 2 * 6 = 12$.

### Modular Exponentiation Quiz
![](https://assets.omscs.io/notes/DBABA778-3D5F-46BA-BF46-4AA6CBF87024.png)

### Modular Exponentiation Quiz Solution
![](https://assets.omscs.io/notes/7396A649-2E25-4636-9B04-532FA86DC8C6.png)

We know that $x^y \pmod n = x^{y \pmod{\phi(n)}} \pmod n$. For $x = 7$, $y = 27$ and $n = 30$, $7^{27} \pmod{30} = 7^{27 \pmod{\phi(30)}} \pmod{30}$. We can calculate $\phi(30)$ as follows:  $\phi(30) = \phi(3) * \phi(10) = \phi(3) * \phi(2) * \phi(5) = 2 * 1 * 4 = 8$. Thus, $7^{27} \pmod{30} = 7^{27 \pmod 8} \pmod{30}$. If we divide 27 by 8, we are left with a remainder of 3, so $7^{27} \pmod{30} = 7^3 \pmod{30}$. $7^3 = 343$, which yields a remainder of 13 when divided by 30.

### RSA Quiz
![](https://assets.omscs.io/notes/0BDF0664-4A30-41C8-9EFC-CA0FEC5B9BAF.png)

### RSA Quiz Solution
![](https://assets.omscs.io/notes/9B9F10D9-B82B-4F16-8A44-B25CCADF7491.png)

$n = p * q = 11 * 3 = 33$ and $\phi(n) = (p - 1) * (q - 1) = 2 * 10 = 20$. $e$ and $d$ must be multiplicative inverses $\pmod{\phi(n)}$, so for $e = 7$, $d = 3$, since $21 \pmod{20} = 1$. Finally, public key ${e, n}$ is equal to ${7, 33}$, and private key, ${d, n}$ is equal to ${3, 33}$.

### RSA Encryption Quiz
![](https://assets.omscs.io/notes/FC5100D0-A94A-46DB-8DAB-F12DF35B30E1.png)

### RSA Encryption Quiz Solution
![](https://assets.omscs.io/notes/A38846E8-2C2B-4683-B7FF-6D847E9F23CE.png)

Encrypting message $m$ involves computing  $m^e \pmod n$, which is equivalent to $2^7 \pmod{33} = 128 \pmod{33} = 29$.  Decrypting ciphertext $C$ involves computing $C^d \pmod n$, which is equivalent to $29^3 \pmod{33} = 24389 \pmod{33} = 3$.

### RSA in Practice Quiz
![](https://assets.omscs.io/notes/63B9D9AB-3440-4F75-8417-FAF749B460D8.png)

### RSA in Practice Quiz Solution
![](https://assets.omscs.io/notes/3D62323C-0309-4B49-BEBB-E17D8C79A0BD.png)

Always use standard libraries, as they have been reviewed and tested by experts in the field.

### Diffie-Hellman Quiz
![](https://assets.omscs.io/notes/0ADA9333-D62C-4A27-8DA7-799BDBAF6512.png)

### Diffie-Hellman Quiz Solution
![](https://assets.omscs.io/notes/AA61E589-45F8-4F17-87B5-0FCE0DD5A99D.png)

Alice sends $\alpha^a \pmod q$ to Bob, which is equivalent to $5^6 \pmod{23} = 8$. Bob sends $\alpha^b \pmod q$ to Alice, which is equivalent to $5^{15} \pmod{23} = 19$.

### RSA, Diffie-Hellman Quiz
![](https://assets.omscs.io/notes/0DE9D182-0375-4A0C-BE6C-B6ECF5D66E4A.png)

### RSA, Diffie-Hellman Quiz Solution
![](https://assets.omscs.io/notes/BCAE9911-0D01-456E-837C-B92CB34B8BE0.png)

## Hashes
### Hash Size Quiz
![](https://assets.omscs.io/notes/4782A47E-5391-43F5-A80C-CA9F02FDBD71.png)

### Hash Size Quiz Solution
![](https://assets.omscs.io/notes/EC0A4B95-7A5E-4C5B-87AD-6D39D17FA04C.png)

Given a hash length $n$, an attacker needs to hash $2^{n / 2}$ messages to find a collision. For $n = 128$, an attacker needs to compute $2^{64}$ hashes.

### Hash Function Quiz
![](https://assets.omscs.io/notes/AD311597-0FE3-4399-B9A1-11A70E568C55.png)

### Hash Function Quiz Solution
![](https://assets.omscs.io/notes/137488B0-4ADC-4B1E-AD86-DFA5067E6565.png)

## Security Protocols
### Mutual Authentication Quiz
![](https://assets.omscs.io/notes/80FD51E1-A56A-41ED-A67C-73513A08A815.png)

### Mutual Authentication Quiz Solution
![](https://assets.omscs.io/notes/6F5B4FC5-A864-4ABF-A723-74B86A03E032.png)

### Security Protocols Quiz
![](https://assets.omscs.io/notes/55902D91-0F5A-4553-829E-34C88755CFFD.png)

### Security Protocols Quiz Solution
![](https://assets.omscs.io/notes/183F382E-5822-4207-AAB9-BA9CEC7B898B.png)

### Session Key Quiz
![](https://assets.omscs.io/notes/0A70D994-363F-4512-8333-3D30F130D0C3.png)

### Session Key Quiz Solution
![](https://assets.omscs.io/notes/F44F5C79-3691-440B-B5E9-72181E40A834.png)

### Kerberos Quiz
![](https://assets.omscs.io/notes/0327A697-D433-41EE-B0E4-54A3F830AFC7.png)

### Kerberos Quiz Solution
![](https://assets.omscs.io/notes/358A47CC-D72F-4BAB-BCCD-590496B92FBF.png)

## IPSec and TLS
### Spoofing Quiz
![](https://assets.omscs.io/notes/1DD688E5-257A-4BD1-A26F-EA39E51D9B39.png)

### Spoofing Quiz Solution
![](https://assets.omscs.io/notes/D5A3CBE4-FC07-4B05-9A8E-58657B7FB1DB.png)

If you spoof your IP address, responses to your packets will not reach you. Therefore, IP spoofing is only useful for unidirectional communication.

### IPSec Quiz
![](https://assets.omscs.io/notes/71C27E26-B59A-479C-B58D-E5DE2CB8C25C.png)

### IPSec Quiz Solution
![](https://assets.omscs.io/notes/ED223658-281B-41DC-B9FB-C1A4C7947B46.png)

### ESP Modes Quiz
![](https://assets.omscs.io/notes/3008B283-1683-4743-A65C-803E545D9BE3.png)

### ESP Modes Quiz Solution
![](https://assets.omscs.io/notes/FE6C0D73-4AD5-4227-ABC2-90E2C64533BD.png)

### ESP and AH Quiz
![](https://assets.omscs.io/notes/FD580F5D-A007-460F-B7C0-878B746040A9.png)

### ESP and AH Quiz Solution
![](https://assets.omscs.io/notes/5F059246-E05A-48FE-89DA-01D8F01B2249.png)

### IPSec Quiz
![](https://assets.omscs.io/notes/E4D8DF00-E68F-47D6-AEBD-1B28A0557F04.png)

### IPSec Quiz Solution
![](https://assets.omscs.io/notes/2A1B6B61-7F65-43B9-84D8-6B281D0FD29C.png)

### Diffie Hellman Quiz
![](https://assets.omscs.io/notes/0914FC25-D4BF-4506-A396-5CE9A634DE1D.png)

### Diffie Hellman Quiz Solution
![](https://assets.omscs.io/notes/70D29C1C-2681-4AD3-9215-1608F8762907.png)

### IKE Quiz
![](https://assets.omscs.io/notes/62A969AA-6E08-43A4-88D5-465C92149EE4.png)

### IKE Quiz Solution
![](https://assets.omscs.io/notes/8F57DD12-F29F-4F16-9039-41BC4E1A0509.png)

### TLS and SSL Quiz
![](https://assets.omscs.io/notes/BE0FFF58-FFF7-4072-8B4C-77297F71EFFD.png)

### TLS and SSL Quiz Solution
![](https://assets.omscs.io/notes/34823FD7-F6DD-46F3-A29D-2FEE62D8D7FA.png)

While transport layer protocols do rely on the IP layer, TLS does not specifically rely on IPSec.

## Wireless and Mobile Security
### Wifi Quiz
![](https://assets.omscs.io/notes/A1605EE1-CD3B-44F8-B316-087EB5CCDEBD.png)

### Wifi Quiz Solution
![](https://assets.omscs.io/notes/3FB90460-9F73-461D-AF2F-9A572F610D1D.png)

### Wifi Security Standards Quiz
![](https://assets.omscs.io/notes/9F9DCFAA-4E6E-4100-8875-AEBB630F432D.png)

### Wifi Security Standards Quiz Solution
![](https://assets.omscs.io/notes/7C57D6D4-3AB3-401F-8291-4762198BCC1E.png)

### Operating System Vulnerabilities Quiz
![](https://assets.omscs.io/notes/0BF73658-68A7-45E7-B8FF-6117B810C8B2.png)

### Operating System Vulnerabilities Quiz Solution
![](https://assets.omscs.io/notes/3BB6C671-DF45-44C8-A21D-620C92AF45ED.png)

Betcha thought it was gonna be all Microsoft, didn't you? Read more [here](https://techtalk.gfi.com/most-vulnerable-operating-systems-and-applications-in-2014/).

### Security Quiz
![](https://assets.omscs.io/notes/4AA42396-DE28-4F4E-A5E9-19038D09F56B.png)

### Security Quiz Solution
![](https://assets.omscs.io/notes/B9B9D6E5-BE56-49FF-A59F-C47ADFC8A716.png)

### App Store Security Quiz
![](https://assets.omscs.io/notes/F70A9C5D-E64F-4BBA-A8AC-4B827080A4AA.png)

### App Store Security Quiz Solution
![](https://assets.omscs.io/notes/F55BD9F8-0B42-44EE-ABC9-2653B6FE11E0.png)

Read more [here](https://www.computerworld.com/article/2483867/researchers-outwit-apple--plant-malware-in-the-app-store.html).

### iOS Security Quiz
![](https://assets.omscs.io/notes/CF5A41AA-2B88-4025-9A26-9C5386660D66.png)

### iOS Security Quiz Solution
![](https://assets.omscs.io/notes/9B84187A-9DAC-4F61-8E87-9EACE74CD93D.png)

Read more [here](https://drive.google.com/file/d/0BxxXk1d3yyuZOFlsdkNMSGswSGs/view).

### iOS Quiz
![](https://assets.omscs.io/notes/3A910142-A483-4840-B86C-17202FB1F483.png)

### iOS Quiz Solution
![](https://assets.omscs.io/notes/46D2028E-7DD1-4982-861E-7D31F2574142.png)

### Android Apps Quiz
![](https://assets.omscs.io/notes/FB9C919C-FAF9-467C-A2C8-C080760A7C84.png)

### Android Apps Quiz Solution
![](https://assets.omscs.io/notes/D4C6F94A-5A0A-4014-8D94-982837DEE5DB.png)

## Web Security
### Cookie Quiz
![](https://assets.omscs.io/notes/F6BDEF06-29AB-4349-832F-56EBC69D1D49.png)

### Cookie Quiz Solution
![](https://assets.omscs.io/notes/2CE3FD4D-3E64-4591-A9F3-D19A90B9C151.png)

Cookies are just strings of text. They are not compiled code, and therefore cannot infect a system the way a virus can.

### Web Security Quiz
![](https://assets.omscs.io/notes/532467B0-2F02-40A1-BEF9-C9B7E418FBB9.png)

### Web Security Quiz Solution
![](https://assets.omscs.io/notes/BD31DC8E-4CA2-49A9-8C52-AA394F2DCEF6.png)

### XSS Quiz
![](https://assets.omscs.io/notes/8DBE2B0F-CC6F-4437-9A92-1C3FB2F37165.png)

### XSS Quiz Solution
![](https://assets.omscs.io/notes/E9AC9C05-8E76-4DBF-B342-F55A1A723FA8.png)

### XSRF Quiz
![](https://assets.omscs.io/notes/01278C58-9179-459C-9DD1-A25AA8951AE0.png)

### XSRF Quiz Solution
![](https://assets.omscs.io/notes/9EC2B8EE-1317-434A-A103-89F4C1FE68DE.png)

### SQL Injection Quiz
![](https://assets.omscs.io/notes/669AD069-005A-400C-A12A-5E0F9C200658.png)

### SQL Injection Quiz Solution
![](https://assets.omscs.io/notes/A22C245A-EF36-478E-A72F-2F986CA67513.png)

## Cyber Security
### Network Use Policy Quiz
![](https://assets.omscs.io/notes/C4EF0BE1-E7EB-4EF2-95C7-6C350AE5378A.png)

### Network Use Policy Quiz Solution
![](https://assets.omscs.io/notes/66481383-5E3B-41E1-8872-16C2F922D983.png)

### Botnet Quiz
![](https://assets.omscs.io/notes/87796EC7-942D-4C51-A88A-D795E1D08008.png)

### Botnet Quiz Solution
![](https://assets.omscs.io/notes/BDBF525E-38FC-4589-B8F9-5D60D9BFC8ED.png)

### Security Audit Quiz
![](https://assets.omscs.io/notes/A0ACD1BC-3257-4E9D-B658-A38F2341B6D9.png)

### Security Audit Quiz Solution
![](https://assets.omscs.io/notes/955B7AA6-8925-4060-90FD-B15F77C7640A.png)

NOTE: answers 1 and 3 are correct.

### CISO Quiz
![](https://assets.omscs.io/notes/44C4B128-D47A-4F43-AEFB-8AC2A7DF7355.png)

### CISO Quiz Solution
![](https://assets.omscs.io/notes/6739A49C-41D1-4773-AB37-B79A90468145.png)

### Computer Use Policy Quiz
![](https://assets.omscs.io/notes/9771E45D-9638-4E05-82F6-A1C10CB72D05.png)

### Computer Use Policy Quiz Solution
![](https://assets.omscs.io/notes/6CEB54B3-7C84-476C-A25E-048670C9DFE2.png)

### Student Privacy Quiz
![](https://assets.omscs.io/notes/0AB2ABF9-9651-4AB1-A084-C5A26D7833A4.png)

### Student Privacy Quiz Solution
![](https://assets.omscs.io/notes/44B358FC-1EB0-42D2-AC0E-9129A51A793C.png)

### Anthem Breach Quiz
![](https://assets.omscs.io/notes/D3870811-2400-4AAC-80EC-F6DF688E235F.png)

### Anthem Breach Quiz Solution
![](https://assets.omscs.io/notes/8785FC32-D688-48B9-935A-B03C867CF522.png)

Read more [here](http://blogs.wsj.com/riskandcompliance/2015/03/02/crisis-of-the-week-anthems-breach-response/) and [here](http://www.latimes.com/business/hiltzik/la-fi-mh-anthem-is-warning-consumers-20150306-column.html).

### Security Breach Quiz
![](https://assets.omscs.io/notes/9978A76B-E7AB-47DE-892A-639CCA8A15ED.png)

### Security Breach Quiz Solution
![](https://assets.omscs.io/notes/CF8998BF-BD44-4ADC-9DCC-4C71DF43014B.png)

### Reducing Exposure Quiz
![](https://assets.omscs.io/notes/3F8AD3EE-7E5F-46F3-8662-D86A7381C385.png)

### Reducing Exposure Quiz Solution
![](https://assets.omscs.io/notes/6EEC39B8-9C40-473C-B2ED-6547F696CFAF.png)

### Cyber Insurance Quiz
![](https://assets.omscs.io/notes/E2BF4801-6F74-4CD9-8E2A-142E405723DE.png)

### Cyber Insurance Quiz Solution
![](https://assets.omscs.io/notes/A2F22984-714E-452C-8801-507291A5711A.png)

### Cyber Security Budgets Quiz
![](https://assets.omscs.io/notes/1C6C0BDF-579C-4B4A-89B2-5AE53DE6E845.png)

### Cyber Security Budgets Quiz Solution
![](https://assets.omscs.io/notes/5F82F572-BDB4-46BD-BC15-382A67CD15C8.png)

Read more [here](https://www.partnerre.com/assets/uploads/docs/cyber-survey-results.pdf).

### Proactive Security Quiz
![](https://assets.omscs.io/notes/4BEB9B1D-801B-4C94-BDA2-7547458C7620.png)

### Proactive Security Quiz Solution
![](https://assets.omscs.io/notes/C3D071BA-435F-43EA-ABC8-A3D3D8C417E7.png)

## Law, Ethics, and Privacy
### Legal Deterrents Quiz
![](https://assets.omscs.io/notes/2762F482-BE0A-4124-B408-52E8CF242DA8.png)

### Legal Deterrents Quiz Solution
![](https://assets.omscs.io/notes/C646AE0D-9888-4239-97C1-3A1146256E8E.png)

### Cost of Cybercrime Quiz
![](https://assets.omscs.io/notes/057806B3-A791-476B-86A5-038EE90E5789.png)

### Cost of Cybercrime Quiz Solution
![](https://assets.omscs.io/notes/6D22EA68-A8BE-4C7B-A409-DE34882F3328.png)

### Melissa Virus Quiz
![](https://assets.omscs.io/notes/1E28C362-6E6A-4677-A362-568C16915225.png)

### Melissa Virus Quiz Solution
![](https://assets.omscs.io/notes/12204048-15EC-4A75-89EE-83966EC45C6D.png)

### Unauthorized Access Quiz
![](https://assets.omscs.io/notes/0E4D483F-7A30-44CE-BF76-1BFC3C06BB0B.png)

### Unauthorized Access Quiz Solution
![](https://assets.omscs.io/notes/56C7B39C-4F63-4C1A-A02A-863642EC8401.png)

### DMCA Exclusions Quiz
![](https://assets.omscs.io/notes/C3F16DFB-FD7A-4E37-8D5C-B49D85D292A9.png)

### DMCA Exclusions Quiz Solution
![](https://assets.omscs.io/notes/BACA7BA9-90D0-4402-81DF-724AB70FEB5A.png)

### Computer Ethics Quiz
![](https://assets.omscs.io/notes/2D3BCFF6-7747-4664-B3BD-037CB1DAA9D2.png)

### Computer Ethics Quiz Solution
![](https://assets.omscs.io/notes/7C9A2833-34E5-4F26-8E01-E81F4ECC0B0F.png)

### Responsible Disclosure Quiz
![](https://assets.omscs.io/notes/DD897D09-0FCE-487F-9E2A-AE7B1BED3CD0.png)

### Responsible Disclosure Quiz Solution
![](https://assets.omscs.io/notes/63AB025B-A11C-43E2-80B2-74825F271520.png)

### Privacy Quiz
![](https://assets.omscs.io/notes/6222EA4E-3B0D-472F-991C-FBEEFACF61A5.png)

### Privacy Quiz Solution
![](https://assets.omscs.io/notes/1F9A054B-54D7-423A-979A-609AFF05841F.png)

Read more [here](https://www.pewresearch.org/internet/2015/05/20/americans-attitudes-about-privacy-security-and-surveillance/).

### Right to Be Forgotten Quiz
![](https://assets.omscs.io/notes/CCE71B10-21D1-492A-A2E5-7EDF4CAD7CC4.png)

### Right to Be Forgotten Quiz Solution
![](https://assets.omscs.io/notes/B5ADC3E6-8457-4465-93F3-56D856A5E848.png)

### EFF Quiz
![](https://assets.omscs.io/notes/D70E4126-197A-493A-BA09-CC58D8168CEF.png)

### EFF Quiz Solution
![](https://assets.omscs.io/notes/348B6806-8887-4721-BE27-1A1404BAA50A.png)

Read more [here](https://www.eff.org/who-has-your-back-government-data-requests-2015)

### Google Privacy Policy Quiz
![](https://assets.omscs.io/notes/64E48411-D40C-4D92-83B3-38F2EFA1B704.png)

### Google Privacy Policy Quiz Solution
![](https://assets.omscs.io/notes/4C61BFC4-01BA-4D4F-B9D0-BE25ED2BCEC5.png)

### Legal Deterrents Quiz
![](https://assets.omscs.io/notes/432B96FF-19C1-405F-A90E-302E9828A709.png)

### Legal Deterrents Quiz Solution
![](https://assets.omscs.io/notes/27460EF1-8AF8-4584-A28B-017A21AF6522.png)

### Fandango Quiz
![](https://assets.omscs.io/notes/F0D3B2E7-12CD-439C-AE8A-5A181E96F01C.png)

### Fandango Quiz Solution
![](https://assets.omscs.io/notes/2DF69546-F0D9-44EC-9646-6C087EFF93F9.png)

### Tracking Quiz
![](https://assets.omscs.io/notes/AA9789FF-1BD5-42A4-91C5-7894D1E4F442.png)

### Tracking Quiz Solution
![](https://assets.omscs.io/notes/C431A102-4377-4BB8-9C40-BA2D6CA46F6B.png)
