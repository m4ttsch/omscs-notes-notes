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

## Operating System Security
### Secure OS Quiz 1
![](../assets/3E4E1A33-04F6-49C8-A8BE-5C9B97CD9F46.png)

[Mac vs PC Security](https://usa.kaspersky.com/resource-center/threats/mac-vs-pc#.VRLACxDF-Hw)

### Secure OS Quiz 1 Solution
![](../assets/A47F089A-E76B-45FB-8EAB-67A1410CD42A.png)

### Secure OS Quiz 2
![](../assets/8FB30729-124D-4073-9C7B-E9B8BE6B98AE.png)

### Secure OS Quiz 2 Solution
![](../assets/14FB0734-2CED-4A50-97FE-789C608E61C3.png)

A system call requires control transfer from the calling process into the OS, which then must perform authentication/authorization checks before granting access and transferring control back.

This is more costly than a regular call, which incurs none of this overhead.

### Secure OS Quiz 3
![](../assets/B1E759C2-2BDC-4F1D-87CC-D0FF65033E40.png)

### Secure OS Quiz 3 Solution
![](../assets/9F2E641A-BA27-4DEB-8754-E4C12B164432.png)

Processes run on behalf of users. Users must login to the system to run applications/processes.

### User Isolation Quiz
![](../assets/65EE949F-30AB-462D-ABAF-766E03061E1B.png)

### User Isolation Quiz Solution
![](../assets/2CF867D1-BB5E-4D7F-A303-4A6F0A5CC1AD.png)

### Revisiting Stack Overflow Quiz
![](../assets/5D690072-1177-4D13-9415-4E98EDD4BC2A.png)

### Revisiting Stack Overflow Quiz Solution
![](../assets/D1ECF899-825E-4B79-89D3-4B6B2A5A64FC.png)

### Execution Privilege Level Quiz
![](../assets/71D72E8A-2857-48A2-8D0C-0B88F2A66C77.png)

### Execution Privilege Level Quiz Solution
![](../assets/3716BF8E-4D50-43B3-936E-318EABBFDDB4.png)

### TCB Requirements Quiz
![](../assets/B91C6769-2EB6-41EC-884C-9BECF16EAA16.png)

### TCB Requirements Quiz Solution
![](../assets/449C3685-5396-4F92-A070-F09425449193.png)

In this case, we have tampered with the TCB by turning off the check. The access still proceeds through the operating system, and is still technically correct (i.e. the access wasn’t permitted because of a bug).

### Size of Security Code
![](../assets/D40FCB93-786B-464E-B73E-ED5EAE001FE2.png)

### Size of Security Code Solution
![](../assets/A944CF7D-097D-4359-B600-BAB6F6E3BB8F.png)

I think the point being made here is that the increase in complexity may be accompanied by an increase in vulnerability.

### Hypervisor Code Size Quiz
![](../assets/8AE1A120-4AD3-44D6-9A06-C19DB78BC670.png)

### Hypervisor Code Size Quiz Solution
![](../assets/32D8E299-1B81-442E-8468-5834F515C381.png)

Again, the argument being made here is that using a hypervisor as a TCB, with fewer lines of code than a full-fledged operating system, might be a more secure choice.

## Authentication
### Authentication Quiz
![](../assets/196A1024-D729-4CE2-BA23-5C8D8CD10B6B.png)

### Authentication Quiz Solution
![](../assets/57996615-B926-4F51-BF29-E3372F1A5C63.png)

If someone steals your phone, you will be thankful for your lock screen/passcode.

### Login Attacks Quiz
![](../assets/5A9CA9D1-FD6A-413F-9DF6-43B0D94BBE71.png)

### Login Attacks Quiz Solution
![](../assets/DBB01EA0-AF2A-4894-96DF-5D34EEC42A10.png)

Remember, the positive event is gaining access to the system. A false positive is gaining access erroneously. An attacker authenticating as someone else is a false positive.

### Implementation Quiz
![](../assets/6E147430-22A9-4286-A6F3-475688360A5A.png)

### Implementation Quiz Solution
![](../assets/CC89677E-5EA4-41E8-899B-5697A658BA99.png)

### Password Popularity Quiz
![](../assets/7E55E7C7-D42D-49D1-8BD8-426BFA142037.png)

### Password Popularity Quiz Solution
![](../assets/3F2C0344-3371-466B-B6CF-D7D1E177661C.png)

If we are attacking systems, we might get the best bang for our buck trying these passwords.

### Password Quiz
![](../assets/24F5D97B-1D55-46CD-B2D8-8E795B30BA8F.png)

### Password Quiz Solution
![](../assets/31FE2544-CBD2-4906-B310-7F05DC21E645.png)

A trusted path ensures that there is no application between the user and the operating system. Without this path, malicious programs may intercept login credentials.

### Hashed Passwords Quiz
![](../assets/C4A2AD00-738F-455D-830F-718C3ED2205D.png)

### Hashed Passwords Quiz Solution
![](../assets/2F6B2EAE-5899-4DE4-B41A-49697B251132.png)

### Hash Function Characteristics Quiz
![](../assets/3F37F04D-3EC1-4EA7-A0F4-C3EE3098D70D.png)

### Hash Function Characteristics Quiz Solution
![](../assets/245963DD-ABEE-4364-96FA-16B7753AAD9C.png)

### Unique PINS Quiz
![](../assets/C7E9CD09-30CD-4A70-A3E8-12CA15DB1769.png)

### Unique PINS Quiz Solution
![](../assets/B3B14694-D6EC-4C26-B0F3-C00DBB302AB8.png)

With ten options for the first digit, ten options for the second digit, and so on, the total number of four digit pins is 10 * 10 * 10 * 10, or `10^4`, or 10,000.

### Brute Force Quiz
![](../assets/F88846E5-1F09-4695-9ABA-9C6786066E21.png)

### Brute Force Quiz Solution
![](../assets/0EA2B5B0-F329-4B96-80EA-1BF697743D43.png)

With 72 options for each other six characters, the total number of unique passwords is 72^6, which is the number of attempts the hacker will have to make in the very worst case.

### Touch Screen Passwords Quiz
![](../assets/AB789F7E-C3A5-4938-B5C9-58BF3C3424D9.png)

### Touch Screen Passwords Quiz Solution
![](../assets/D02FF363-D3A3-4D71-B4E6-E5A137CE04A8.png)

Basically, the idea here is that attackers will likely not have to exhaustively search the space of possible patterns because biases exist that greatly shrink this space into a much smaller space of much more probable patterns.

### Multi-factor Authentication Quiz
![](../assets/41CFA250-2487-4089-A2D7-D01CC482495F.png)

### Multi-factor Authentication Quiz Solution
![](../assets/CC9A6A59-47B9-465A-BCAD-4F0257BE84A5.png)

Remember, a false positive occurs when a malicious user is granted access to the system as a valid user. The likelihood of this happening decreases when multiple authentication components are employed by the system.

### Chip and Pin Authentication Quiz
![](../assets/77924BCE-4594-4893-B02E-08E46A624821.png)

### Chip and Pin Authentication Quiz Solution
![](../assets/4668FB80-8C96-4083-A753-7E4A41F8CC1D.png)

Read more [here](http://www.darkreading.com/vulnerabilities---threats/flaws-in-emv-chip-and-pin-undercut-security/d/d-id/1269155) and [here](https://www.schneier.com/blog/archives/2014/05/preplay_attack_.html).

### Biometric Authentication Quiz
![](../assets/3D51F432-5BE0-41DC-BCE5-243BEEF20CA6.png)

### Biometric Authentication Quiz Solution
![](../assets/62C0DA99-A728-42B8-867F-D0FB6CEB9DA2.png)

As a basic example, consider someone recording your voice and playing it back to a voice-based authentication system.

## Access Control
### Data Confidentiality Quiz
![](../assets/AD434002-43B3-41CC-A837-4B2BBFA18017.png)

### Data Confidentiality Quiz Solution
![](../assets/C9D0D775-0D1F-4695-9F4F-8EBA71914E34.png)

Controlling read access is connected to data confidentiality, while controlling write access is connected to data integrity.

### Determining Access Quiz
![](../assets/104BA89A-BC90-4875-A0BD-48765D8DD073.png)

### Determining Access Quiz Solution
![](../assets/0E90ADD5-3CCB-4A69-9C9E-55E06E88A8E8.png)

Access control conflicts can be securely resolved by denying access.

### Discretionary Access Control Quiz
![](../assets/8C822B06-A689-4ABC-BC3C-69517F39029D.png)

### Discretionary Access Control Quiz Solution
![](../assets/69519ED2-526D-47DB-8CFF-B3A922D2DBDF.png)

Bob can write the contents of the file to a new file that he owns, and share that file with Charlie.

### ACE Quiz
![](../assets/38DA4583-E908-4834-A4A8-A30FB65A2754.png)

### ACE Quiz Solution
![](../assets/89BFDAE7-ED13-41D6-BB4C-01D5948DD108.png)

The presentation of the ticket is sufficient to gain access to the theater. No other access checks are required. This is closest in functionality to a capability.

### ACE Access Quiz
![](../assets/790A92B9-8315-4A52-8B83-9F7CF9F33947.png)

### ACE Access Quiz Solution
![](../assets/0D94E256-D8D9-4BCE-9E83-F7BFD18F7E20.png)

Negative access rights supersede positive access rights, so you can’t terminate as soon as you find a positive access right. You can terminate as soon as you find a negative access right, though.

NB: The third option can’t be true if the second option is true.

### Revocation of Rights Quiz
![](../assets/99C6BB65-DB67-42A9-A133-484EAEC0498C.png)

### Revocation of Rights Quiz Solution
![](../assets/06734230-A91A-4DCB-BBC0-35AF61DC9A09.png)

### Time to Check vs Time to Use Quiz
![](../assets/252D27FB-9B58-4DCD-AE9C-6D6B7C3143E9.png)

### Time to Check vs Time to Use Quiz Solution
![](../assets/B464C794-6718-40DB-BDAB-EAA956AD1C13.png)

As long as you had the permissions when you called `open`, you can access the file using the file descriptor.

### Unix File Sharing Quiz
![](../assets/88897E9D-9338-459B-B582-7A87A6EB74E6.png)

### Unix File Sharing Quiz Solution
![](../assets/8E7ED659-B2F6-4823-A54F-C312F6110482.png)

You would need to somehow add the descriptor to the per-process descriptor table for the process with which you wish to share the descriptor. Since the OS owns this table, mutating it is impossible.

### SetUID Bit Quiz
![](../assets/71AAA4B5-5DD3-414A-8317-8BB17007E533.png)

### SetUID Bit Quiz Solution
![](../assets/E2739829-4308-4DBE-8C7D-0AAF1025E54E.png)

The effective UID of a process executing a file with the setuid bit set is the owner of the file, not the user who created the process.

### RBAC Benefits Quiz
![](../assets/D1B82974-ED31-4162-B636-012F375BCE35.png)

### RBAC Benefits Quiz Solution
![](../assets/01A48AF0-F1FD-4085-A588-4BA0C746FE0C.png)

### Access Control Policy Quiz
![](../assets/7221A53F-3B6C-4CA2-9738-3A63FCA7CEFA.png)

### Access Control Policy Quiz Solution
![](../assets/5DEE9998-897C-4B46-8565-A383DD6FC069.png)

From a security standpoint, denying access is a fail-safe default. It never fails to keep your system secure.

## Mandatory Access Control
### DAC Quiz
![](../assets/FFAA8FAE-B0AC-421F-A71A-2B59F7D76D87.png)

### DAC Quiz Solution
![](../assets/CC4FCC5B-CC40-4ADC-8AC7-B14CEA595009.png)

DAC can’t control information flow, so we must use MAC.

### Health Data Quiz
![](../assets/B190798D-AB66-4B7B-938B-ED38D21FBB4C.png)

### Health Data Quiz Solution
![](../assets/9EF783B9-6360-427A-918C-CDF9773C4034.png)

BLP is concerned with military/governmental intelligence. HIPAA is concerned with health information.

### Security Clearance Quiz
![](../assets/4492690A-933D-4088-BCCC-51031EA9A047.png)

### Security Clearance Quiz Solution
![](../assets/D0C61525-5A43-4B43-8C64-4CCBC4715B41.png)

Source: [Washington Post](https://www.washingtonpost.com/news/the-switch/wp/2014/03/24/5-1-million-americans-have-security-clearances-thats-more-than-the-entire-population-of-norway/?noredirect=on)

### Order Quiz
![](../assets/2F90AB65-3E72-4760-BB6B-28DB02993748.png)

### Order Quiz Solution
![](../assets/37633CE2-16DD-45D5-B67D-52318AF4DD6E.png)

Given any two real numbers, one number is always greater than the other.

### Label Domination Quiz
![](../assets/11C6E389-14C8-4928-B128-A743249D4F2A.png)

### Label Domination Quiz Solution
![](../assets/89DAADB0-D668-480D-8B6D-38C0037CCE42.png)

While `secret < top-secret` , `{Asia, Europe}` cannot be compared with `{Europe, South-America}`.

### Sensitive Data Quiz
![](../assets/65E58104-8D29-4E6C-AE31-FCB742D1C233.png)

### Sensitive Data Quiz Solution
![](../assets/34881303-A27C-4BB1-807C-03DE3A0016D9.png)

In order for `D1` to dominate `D2`, `D1` must have a higher sensitivity level than `D2`.

In addition, the compartment of `D1` must contain the compartment of `D2` in order to be ‘greater’ (based on the ordering rules for sets). For this to be the case, the compartment of `D2` must be a subset of (“narrower” than) the compartment of `D1`.

### Unclassified Documents Quiz
![](../assets/EA4A6F50-B773-4345-BD3C-28CFB3AEA7D4.png)

### Unclassified Documents Quiz Solution
![](../assets/3D70CF4F-3BC7-40D2-B75C-FB84BB1CE0D8.png)

Write-down says that individuals cannot write documents with a classification that is less than their security clearance. Therefore, unclassified documents cannot be written by individuals holding a security clearance of classified, secret, or top secret.

### Classified Data Quiz
![](../assets/2BE2011C-6B0A-4D48-BF24-575316A8F447.png)

### Classified Data Quiz Solution
![](../assets/A699ECFA-0934-4CCD-9C63-056FD1E46428.png)

Because of the write-up rule, individuals are allowed to write documents at a classification level that is greater than their clearance level. Individuals with unclassified security clearance are thus allowed to write top secret documents.

### BLP Model Quiz
![](../assets/C4229ADC-2062-4802-BD5C-8BA008F90F29.png)

### BLP Model Quiz Solution
![](../assets/3D182BB1-66B8-4F82-8795-E5BEEA1C6F11.png)

For example, if a user is writing to a top secret document, and the classification level suddenly changes to secret, the write-up rule is violated and information is flowing in the wrong direction.

### Clark Wilson Quiz
![](../assets/A286764A-C66E-4C60-9CE7-106440934312.png)

### Clark Wilson Quiz Solution
![](../assets/A4317935-9B6A-4DB8-869A-1644B8A403F0.png)

In mandatory access control, sharing decisions are not made at the discretion of the user.

### COI Quiz
![](../assets/FD528D21-BCC6-48D4-A1F4-179CB9A9470B.png)

### COI Quiz Solution
![](../assets/2A693A0B-93E6-4AE5-B6AB-3869601B5800.png)

Competition implies that there is a possibility for a conflict of interest. Chinese Wall is best at preventing these situations.

### RBAC Quiz
![](../assets/18AF82C6-AE0E-4A04-BE46-24C199FAC8DF.png)

### RBAC Quiz Solution
![](../assets/E32A017C-052D-4DF1-94CA-ABBD02770338.png)

In mandatory access control, the company decides who can share what.

### MAC Support Quiz
![](../assets/1F3AB8F6-7244-44E3-91BD-833C137AC8FD.png)

### MAC Support Quiz Solution
![](../assets/B94746DE-2747-401F-B607-68799681137C.png)

### Least Privilege Quiz
![](../assets/125DFCBE-E30F-4B38-AE98-DB12FA30C0DC.png)

### Least Privilege Quiz Solution
![](../assets/FC19D98D-46EB-46BE-8AE3-7C75BF6E482B.png)

The TCB provides high assurance, not certainty.

### TCB High Assurance Quiz
![](../assets/F33DDE22-EF71-4878-9A86-1153AE4C938B.png)

### TCB High Assurance Quiz Solution
![](../assets/47F700ED-F1EE-4693-B99C-5117AEEF93A2.png)

Security by obscurity violates open design.

### Design Principle Quiz
![](../assets/130DA7AD-F9EE-498B-807C-C00F7111C79B.png)

### Design Principle Quiz Solution
![](../assets/D70011C5-D8EA-404D-82A6-7A6C4A77DDDB.png)

A fail-safe default is one that provides security unless otherwise specified. In this case, the default should be traffic encryption.

### Reducing TCB Size Quiz
![](../assets/11F63B01-9D9D-4070-B054-C4DE0A004584.png)

### Reducing TCB Size Quiz Solution
![](../assets/B9687C3C-5D80-45A9-9112-224E955CDF88.png)

### Testing TCB Quiz
![](../assets/DFED8BC1-EB62-44EB-A00D-06864E69B0AE.png)

### Testing TCB Quiz Solution
![](../assets/5F87B5BC-DB54-413C-8348-BF6973C787F5.png)

Testing can’t show the absence of problems.

### Model Checking Quiz
![](../assets/1DD38815-AC14-4050-8BE4-CD4B6545DE3B.png)

### Model Checking Quiz Solution
![](../assets/B90F59EF-3CF9-42B6-BC7C-6237B4AB68B2.png)

### TCSEC Divisions Quiz
![](../assets/812B3058-CB14-4745-9085-7D918AD2AE0F.png)

### TCSEC Divisions Quiz Solution
![](../assets/472F8C5A-752D-4F31-B25E-1AB70F353DDF.png)

### Earning an EAL4 Certification Quiz
![](../assets/1BD7FA8D-A4A3-420D-B034-5DE4ACFF0305.png)

### Earning an EAL4 Certification Quiz Solution
![](../assets/54D03A5C-FF37-40C9-A359-3F2B765910B4.png)

### Cost Benefit Certification Tradeoffs Quiz
![](../assets/0DB30C2E-0FDD-438F-8532-4B6CC06E7977.png)

### Cost Benefit Certification Tradeoffs Quiz Solution
![](../assets/FC3F201F-6A8B-4E3B-9725-E8128B9719E5.png)

## Database Security
### Database Threats Quiz
![](../assets/DF4376DB-23F1-4197-A713-0D67A365E539.png)

### Database Threats Quiz Solution
![](../assets/EEA0ABC9-F002-4A9D-8654-81E456D1921D.png)

[Source](http://www.oracle.com/us/products/database/2014-ioug-dba-security-superhero-2338955.pdf)

### Database Hacking Quiz
![](../assets/BC720089-2712-4976-B060-FF39DC587337.png)

### Database Hacking Quiz Solution
![](../assets/027DCEF8-3F17-4FD1-8D27-191328C18040.png)

### Key Value Quiz
![](../assets/83E4EFF2-3CED-4058-AD08-39D3DEFC3A62.png)

### Key Value Quiz Solution
![](../assets/66B99FB2-D304-43C2-979E-BDA1CAD672A8.png)

A primary key uniquely identifies a row.

### Database Views Quiz
![](../assets/12C1B7B6-9B61-4C2A-B9CB-55D63FB07E0A.png)

### Database Views Quiz Solution
![](../assets/8046AD01-9F33-468B-9F3E-2A1D04087814.png)

### Database Access Control Quiz
![](../assets/7D499BB8-5C13-4A36-8CF3-0C3E8F301532.png)

### Database Access Control Quiz Solution
![](../assets/11C78BAE-41F8-42FC-8AFE-F234639D2D20.png)

### Cascading Authorizations Quiz
![](../assets/31AD71A2-E008-405D-8F49-8C4A9CA746D9.png)

### Cascading Authorizations Quiz Solution
![](../assets/4A856303-A0BB-473A-8E98-41306F1E2AE4.png)

### DAC or MAC Quiz
![](../assets/5947BE2E-48E7-4792-A77C-432EBC939BF2.png)

### DAC or MAC Quiz Solution
![](../assets/6AED63B6-5A43-4EF8-BDCF-3624B7789381.png)

### SQL Login Quiz
![](../assets/29ADEB96-538D-470A-85E1-28D2D25B40AC.png)

### SQL Login Quiz Solution
![](../assets/6FF291D3-98CE-4AD1-93D7-9A93431D5335.png)

### SQL Login Quiz 2
![](../assets/7BA1E896-52B9-43EB-A710-2EB5C7170141.png)

### SQL Login Quiz 2 Solution
![](../assets/87FB43B8-EEE7-4BB8-A3CE-10DFA9911FAE.png)

### SQL Inference Attack Quiz
![](../assets/972B9CAC-ECD3-40CF-9187-8CA4B3F1E280.png)

### SQL Inference Attack Quiz Solution
![](../assets/379AB37B-1684-45F6-AD8D-54C00A35629B.png)

### SQL Inference Attack Quiz 2
![](../assets/0C1BADC4-C735-4958-9274-F9F2DB3E9411.png)

### SQL Inference Attack Quiz 2 Solution
![](../assets/13759837-A50F-4319-9A86-FDD985C5EE27.png)

Consider the case where one student from a region containing two students retrieves the grade information about that region.

## Malicious Code
### What is Malware Quiz
![](../assets/40637903-CAAE-402C-9F8D-DC289CB7EC62.png)

### What is Malware Quiz Solution
![](../assets/07625575-7DE3-4F7F-AEF7-5E0B1178E7A7.png)

### Host Required Malware Quiz 1
![](../assets/A4EDCDB2-1BCA-44CE-82D9-F9F87A38CED2.png)

### Host Required Malware Quiz 1 Solution
![](../assets/5FECA411-7C95-4E9C-B485-2FB274E512F5.png)

### Host Required Malware Quiz 2
![](../assets/21C54A27-F1F6-4A37-969F-A29DE164F9F5.png)

### Host Required Malware Quiz 2 Solution
![](../assets/049C97B7-000C-4F42-8755-89BDE3A06DB9.png)

### Types of Viruses Quiz
![](../assets/133BBEDD-CE14-4ED3-A8ED-48F539E3E52B.png)

### Types of Viruses Quiz Solution
![](../assets/6294734B-447D-4C84-9F5E-C80BD8923832.png)

Macro viruses run when an infected document is opened with a given application. Boot sector viruses run before the operating system is loaded.

### Rootkit Quiz
![](../assets/F9D17F35-7B72-4538-9425-77C62F298C1D.png)

### Rootkit Quiz Solution
![](../assets/F4D927F4-F0EF-4056-9F9C-3979A28E1375.png)

### Truth and Misconceptions Quiz
![](../assets/C55A0FCE-82C4-4243-83F9-9FE14B9B1982.png)

### Truth and Misconceptions Quiz Solution
![](../assets/FE1571D1-8225-4963-ABEA-379773BD8D9A.png)

### Worm Quiz
![](../assets/63C5BA47-1177-48B3-8C53-AB4B8BD90395.png)

### Worm Quiz Solution
![](../assets/60DAF027-9368-40B6-AE36-FC6EA78B32B8.png)

### Malware Prevention & Detection Quiz
![](../assets/36682CCE-48D2-43A0-B174-A5558BA230E6.png)

### Malware Prevention & Detection Quiz Solution
![](../assets/919A3EB0-92AE-4221-BFC5-D339E835C7E6.png)

### Most Expensive Worm Quiz
![](../assets/8C469D3D-9061-45F2-8B2F-53D35CBD5A30.png)

### Most Expensive Worm Quiz Solution
![](../assets/38A65997-26BC-4D80-A560-169AF0930940.png)

[Source](https://encyclopedia2.thefreedictionary.com/Top+10+Worst+Computer+Worms+of+All+Time)
