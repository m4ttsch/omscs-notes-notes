---
id: information-security-the-security-mindset
title: The Security Mindset
course: information-security
lecture: the-security-mindset
---

# The Security Mindset

## Why Cyber Security?
Before considering why we care about cyber security, it's important to understand why we would care about security in general.

Essentially, we worry about security when we have something of value which is at risk of being harmed.

In order to understand the importance of cyber security, we need to consider the digital assets that we maintain and the threats those assets face.

For example, individuals store a lot of sensitive data online, such as financial information and medical information. If criminals get their hands on this data, they can monetize it and profit from it.

More broadly, communities rely on the internet for critical resources, making them attractive targets for adversaries.

Smart grids, which control the electrical power generation and distribution, are one such community asset. If computers control the smart grid, then whoever controls those computer controls an extremely important resource.

At a more general level, businesses and governments use the internet to carry out their daily activities, many of which involve storing proprietary and/or classified information. If hackers or adversaries gain access to this information, the consequences could be economically or politically disastrous.

## Security Impact Quiz
![](https://assets.omscs.io/notes/Screen%20Shot%202019-08-20%20at%208.42.25%20PM.png)

## Security Impact Quiz Solution
No one right solution. I think the important thing to understand here is that no company is safe from a breach, and many companies that we interact with on a daily basis have suffered security breaches.

## Cyber Assets at Risk
In order to define the security mindset, we need to consider:

- Threats (who are the bad actors?)
- Vulnerabilities (what weaknesses can they exploit?)
- Attack (how will the bad actors exploit the weaknesses?)

A **threat source** refers to an individual or entity that wishes to do us harm in our online lives.

**Cybercriminals** want to profit from our sensitive data for financial gain.

**Hacktivists** mount attacks in accordance with some political or philosophical agenda (think Edward Snowden).

**Nation states** thwart cyber security in order to gain political advantage through espionage.

## Vulnerabilities and Attacks
Threat actors exploit vulnerabilities to launch attacks.

An example of a vulnerability is a weak password. A threat actor can likely guess a weak password, and use that password to *compromise* your account.

If the threat actor is able to compromise an entire digital system instead of just a single account - by gaining access to a centralized server or database, for example - we refer to this compromise as a *security breach*.

An **attack** is a successful exploitation of a vulnerability by a threat source, resulting in a system that has been compromised.

Unfortunately, vulnerabilities are very hard to get rid of completely. They are found in software, networks and, frequently, humans.

### Trivial Example
Many of us ride our bikes.

Our bikes are an important asset to us: they cost money and they help us get around. In addition, there are threats against bikes. People steal bikes.

If you just leave a bike lying around, it is seriously vulnerable. Someone can just pick it up and walk away.

One way we can chose to protect our bike is by locking it - by the wheel - to a sturdy or heavy object.

In this case, the thief is not going to fight the security you have in place (the lock), but rather will unscrew the lock from the frame and walk away with the bike minus the wheel.

The vulnerability we have here is that while we have secured the wheel, we have left the rest of the bike (which is still valuable) unsecured.

We never realized that we had to protect more than just the wheel.

## A Real World Example
The [Target data breach](https://en.wikipedia.org/wiki/History_of_Target_Corporation#2013_security_breach) of 2013 is one of the most widely publicized security breaches.

When thinking about security breaches there are different questions to ask:

- What is of value?
- What is the threat source?
- What vulnerability was exploited?

In this attack, the information of value was credit card data that was available on the point-of-sale systems present in Target stores.

The threat source was cybercriminals wishing to profit off of this information.

In this case, the vulnerability was human.

The attack began with a [phishing](https://en.wikipedia.org/wiki/Phishing) message sent to a member of the HVAC company that was contracting for Target. Through the phishing attacks, the criminals were able to get credentials to get onto Target's network, at which point they were able to install malware on the point-of-sale systems in order to siphon off the credit card numbers.

## Black Market Prices Quiz
![](https://assets.omscs.io/notes/E8C3B157-9CC2-43BB-B761-89A237C8A7E5.png)

## Black Market Prices Quiz Solution
![](https://assets.omscs.io/notes/E405BEDE-4306-4A65-91C9-AD0296201E67.png)

I think the point here is not to remember the exact numbers, but rather to understand that this information can be purchased relatively cheaply. This makes sense given that millions of records can be retrieved in a single breach.

## Sony Pictures Quiz
![](https://assets.omscs.io/notes/3430D19A-B3A4-4978-B9D1-D2CCFFBB7676.png)

## Sony Pictures Quiz Solution
![](https://assets.omscs.io/notes/E35AAD32-24F6-494C-A37F-8DF068591D26.png)

Read more [here](https://en.wikipedia.org/wiki/Sony_Pictures_hack)

## Revisiting Threats, Vulnerabilities and Risk
The following diagram succinctly illustrates the relationship between assets,  vulnerabilities, threats, and risk.

![](https://assets.omscs.io/notes/CCD7D070-44CA-4A73-B2A5-7C5D08503901.png)

## What Should We Do in Cyber Security?
There are different things that we can hope to achieve in the field of cyber security.

First, we can try to make threats go away. This is not an easy feat to achieve, but we can try to discourage criminal activity by introducing computer abuse laws.

We can reduce vulnerabilities, but we are never going to have zero vulnerabilities. Complex systems are error-prone, and some of those errors will expose vulnerabilities that can be exploited.

Alternatively, we can strive to meet various security requirements of sensitive information. The most common requirements are confidentiality, integrity, and availability.

If the data is sensitive in the sense that it cannot be disclosed to unauthorized parties, then a **confidentiality** requirement is present.

If no one should be able to modify or corrupt the data, the data is said to have an **integrity** requirement.

If the data is critical in the sense that we must always have access to it - your bank account data, for instance - then the data has an **availability** requirement.

These three requirements comprise the **CIA triad**.

While these three requirements are primarily concerned with the data aspects of cyber security, cyber attacks can also have physical consequences. The most well-known case of this is [Stuxnet](https://en.wikipedia.org/wiki/Stuxnet).

## Security Requirements Quiz
![](https://assets.omscs.io/notes/38ACE867-7D38-47CD-A9BB-52AA9B654980.png)

## Security Requirements Quiz Solution
![](https://assets.omscs.io/notes/1ED304D4-8E4A-43E3-9209-62B58C7AD5E5.png)

Since data breaches involve the disclosure of information to unauthorized parties, these breaches violate confidentiality.

## What Should the Good Guys Do?
The good guys have many different jobs.

We have to worry about *prevention*, which means keeping the bad guys out of our systems.

Since prevention is not guaranteed, we want to *detect* the inevitable compromise as quickly as possible.

After detection, we must make sure that we *respond* to the compromise, which may include *recovery* of lost or corrupted data.

Finally, we must provide some *remediation* to ensure that the same attack doesn't happen again.

Cybersecurity consists of *policies*, which describe what needs to be done on each of these fronts, and *mechanisms*, which describe how the policies will be carried out.

## Losses Due to Cyber Crime Quiz
![](https://assets.omscs.io/notes/015A31E9-BB3F-4406-A5CD-A4A246C12321.png)

## Losses Due to Cyber Crime Quiz Solution
![](https://assets.omscs.io/notes/0405619E-94F9-42E9-8E7F-5CB07EB9CBF2.png)

## How Do We Address Cyber Security?
One way to reduce vulnerability is to follow design principles that are good for security.

**Economy of mechanism** means the design of security measures built into the system should be as simple and small as possible.

**Fail-safe default** means that access decisions should be explicitly granted rather than explicitly denied. The default situation is lack of access, and the security controls identify conditions under which access is granted.

**Complete mediation** says that every access to a resource must be checked against the access controls. No access should proceed unmonitored.

**Open design** means the design of a security mechanism - for example, encryption algorithms - should be open rather than secret. Security by obscurity is a false promise.

**Least privilege** means that every process or user of the system should operate with the least set of privileges required to perform a task. This ensures that damage inflicted by a corrupted user or process is contained.

**Psychological acceptability** means that security mechanisms should not interfere unduly with the work of users, while at the same time meet the needs of those who authorize access. Security mechanisms that excessively hinder the usability or accessibility of resources are likely to be turned off.

These principles come from the paper [Design Principles for Secure Systems](http://www.cs.cornell.edu/courses/cs513/2005fa/NL02.html)

## Security Mindset Quiz
![](https://assets.omscs.io/notes/980D23F6-7ADD-4C3A-BB92-FA6FD53BF9E7.png)

## Security Mindset Quiz Solution
![](https://assets.omscs.io/notes/D8E63E79-4288-4ECA-97E1-CA3270A46652.png)
