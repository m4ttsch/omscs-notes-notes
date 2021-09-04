---
id: computer-networks-old-dns
title: DNS
course: computer-networks-old
lecture: dns
---

# DNS

## Domain Name System

The purpose of the **domain name system** (DNS) is to map human-readable names - such as www.gatech.edu - to IP addresses - such as 130.207.160.173.

While the human-readable name is much easier for us to read and interpret, the IP address is needed to send traffic to the intended destination.

### DNS Query Walkthrough

A client might want to lookup a domain name, like www.gatech.edu. A networked application's source code may invoke this lookup with the `gethostbyname` function.

The client typically has a _stub resolver_. This resolver takes the domain name and issues a query to a _local DNS resolver_. The local DNS resolver is typically configured automatically when a host is assigned an IP address, through a protocol called the **Domain Host Configuration Protocol** ([DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol)) .

The client query is typically sent _recursively_. This means that the client doesn't want to receive intermediate referrals from DNS servers trying to resolve the query. The client only cares about the final answer.

The local resolver, on the other hand, will perform iterative queries.

Each fully qualified domain name is expected to end with a "dot" (.), indicating the root of the DNS hierarchy.

The IP addresses for the root servers - those that are authoritative for the root - may already be configured in the local DNS resolver.

In the case of www.gatech.edu, the local DNS resolver may issue a query for an A record to the root server - say, a.root-servers.net - which may respond with an NS (referral) record with a value of c.edu-servers.net.

Now the local resolver will issue the same A record query to the edu servers. This query may give another referral to the authoritative servers for the GATech domain space.

Finally, the local resolver will issue the same query to the authoritative server for the GATech hierarchy, at which point it may receive the actual IP address that corresponds to the domain name in question.

![](https://assets.omscs.io/notes/FD099829-5459-48C5-978C-04801A6CA9E8.png)

### Caching and TTL

This process of referrals can be pretty slow. A typical DNS query may require round trips to multiple servers that are authoritative for different parts of the hierarchy.

We can reduce the number of round trips we must take to respond to any query by introducing a cache at the local resolver.

This cache would store the NS records for each level of the hierarchy as well as the A records.

Each of the records would be cached for a particular amount of time. Each reply from a DNS server has a **time to live** (TTL) attribute that indicates how long each requested record can be saved before they need to be looked up again.

Caching allows for quick responses from the local DNS resolver, especially for repeated mappings. For example, if multiple hosts are connected to the same resolver, and one of them requests a popular site - like facebook.com - the DNS server can then cache that record, which will speed up the (inevitable) lookup requests for all of the other hosts.

Some queries can reuse parts of the lookup. For example, it is unlikely that the authoritative name server for the root is going to change very often. That record might be cached for hours, days or even weeks.

The mapping for a local name - like www.gatech.edu - might change more frequently, so those TTLs might be smaller.

## Record Types

**A records** map names to IP addresses.

**NS records**, or name server records, map domain names to the authoritative name server for that domain. This can be helpful when a particular DNS server doesn't know the answer to a query, but can refer the caller to the authoritative server for that space of the domain system.

**MX records** show the mail server for a domain.

Occasionally, one name is just an alias for another. For example, www.gatech.edu has a slightly different "real" name. The **CNAME record** is basically just a pointer from an alias to another domain name that needs to be looked up.

The **PTR record** maps IPs address to domain names. This is sometimes referred to as a **reverse lookup**.

Finally, a **AAAA record** maps a domain name to an IPv6 address.

## Dig

We can issue DNS queries and see responses with a command line utility called **dig**.

From the man pages:

> dig (domain information groper) is a flexible tool for interrogating DNS name servers. It performs DNS lookups and displays the answers that are returned from the name server(s) that were queried.

### Example 1 (GATech A)

Here is an example of a lookup for an A record for www.gatech.edu.

```bash
Matts-MBP:~ mschlenker$ dig www.gatech.edu

; <<>> DiG 9.10.6 <<>> www.gatech.edu
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55527
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.gatech.edu.			IN	A

;; ANSWER SECTION:
www.gatech.edu.		60	IN	CNAME	tlweb.gtm.gatech.edu.
tlweb.gtm.gatech.edu.	30	IN	A	130.207.160.173

;; Query time: 68 msec
;; SERVER: 192.168.1.1#53(192.168.1.1)
;; WHEN: Sat Feb 09 09:17:48 EST 2019
;; MSG SIZE  rcvd: 83

```

In the "QUESTION SECTION", you can see our query. We are looking for an A record for www.gatech.edu.

In the "ANSWER SECTION", you can see the response to our query. Our initial query response is a CNAME record, which maps www.gatech.edu to tlweb.gtm.gatech.edu. We then issue an A record query for tlweb.gtm.gatech.edu, the response to which is `130.207.160.173`.

The numbers "60" and "30" for the CNAME and A record entries, respectively, indicate the TTL in seconds that the entry can be stored in the cache.

### Example 2 (NYTimes A)

Here is an example of an A record query for nytimes.com.

```bash
Matts-MBP:~ mschlenker$ dig nytimes.com

; <<>> DiG 9.10.6 <<>> nytimes.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 32575
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;nytimes.com.			IN	A

;; ANSWER SECTION:
nytimes.com.		374	IN	A	151.101.129.164
nytimes.com.		374	IN	A	151.101.193.164
nytimes.com.		374	IN	A	151.101.65.164
nytimes.com.		374	IN	A	151.101.1.164

;; Query time: 37 msec
;; SERVER: 192.168.1.1#53(192.168.1.1)
;; WHEN: Sat Feb 09 09:27:03 EST 2019
;; MSG SIZE  rcvd: 104
```

The interesting thing to note here is that in the response to our A record query, we see four IP addresses. This is typically performed when a service wants to perform load balancing.

The client can use any one of these. It might prefer the first one, but if we issue the query again, the IP addresses may come back in a different order.

### Example 3 (NS)

Here is an example of an NS record query for gatech.edu.

```bash
Matts-MBP:~ mschlenker$ dig ns gatech.edu

; <<>> DiG 9.10.6 <<>> ns gatech.edu
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 17865
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;gatech.edu.			IN	NS

;; ANSWER SECTION:
gatech.edu.		86400	IN	NS	dns3.gatech.edu.
gatech.edu.		86400	IN	NS	dns1.gatech.edu.
gatech.edu.		86400	IN	NS	dns2.gatech.edu.

;; Query time: 49 msec
;; SERVER: 192.168.1.1#53(192.168.1.1)
;; WHEN: Sat Feb 09 09:30:25 EST 2019
;; MSG SIZE  rcvd: 96
```

In the "QUESTION SECTION", we can see that we have an NS record query instead of an A record query. In the "ANSWER SECTION", we can see that we have received the names of three name servers, any of which can answer authoritatively for subdomains of gatech.edu

### Example 4 (MX)

Here is an example of an MX record query for gatech.edu.

```bash
Matts-MBP:~ mschlenker$ dig mx gatech.edu

; <<>> DiG 9.10.6 <<>> mx gatech.edu
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 53726
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;gatech.edu.			IN	MX

;; ANSWER SECTION:
gatech.edu.		60	IN	MX	10 mxip2a.gatech.edu.
gatech.edu.		60	IN	MX	10 mxip1a.gatech.edu.

;; Query time: 44 msec
;; SERVER: 192.168.1.1#53(192.168.1.1)
;; WHEN: Sat Feb 09 14:00:05 EST 2019
;; MSG SIZE  rcvd: 85
```

In the "QUESTION SECTION", we can see that we have an MX record query. In the "ANSWER SECTION", we have two MX records corresponding the mail servers for gatech.edu.

In addition to the TTL, we also have a notion of priority: 10 for each of the mail servers. This priority value allows administrators to define a primary mail server and a backup.

### Example 5 (trace)

Here is an example of an A record query for gatech.edu with a trace.

```bash
Matts-MBP:~ mschlenker$ dig +trace +nodnssec gatech.edu

; <<>> DiG 9.10.6 <<>> +trace +nodnssec gatech.edu
;; global options: +cmd
.			80179	IN	NS	a.root-servers.net.
.			80179	IN	NS	b.root-servers.net.
.			80179	IN	NS	c.root-servers.net.
.			80179	IN	NS	d.root-servers.net.
.			80179	IN	NS	e.root-servers.net.
.			80179	IN	NS	f.root-servers.net.
.			80179	IN	NS	g.root-servers.net.
.			80179	IN	NS	h.root-servers.net.
.			80179	IN	NS	i.root-servers.net.
.			80179	IN	NS	j.root-servers.net.
.			80179	IN	NS	k.root-servers.net.
.			80179	IN	NS	l.root-servers.net.
.			80179	IN	NS	m.root-servers.net.
;; Received 239 bytes from 192.168.1.1#53(192.168.1.1) in 20 ms

edu.			172800	IN	NS	l.edu-servers.net.
edu.			172800	IN	NS	b.edu-servers.net.
edu.			172800	IN	NS	c.edu-servers.net.
edu.			172800	IN	NS	m.edu-servers.net.
edu.			172800	IN	NS	f.edu-servers.net.
edu.			172800	IN	NS	h.edu-servers.net.
edu.			172800	IN	NS	a.edu-servers.net.
edu.			172800	IN	NS	k.edu-servers.net.
edu.			172800	IN	NS	e.edu-servers.net.
edu.			172800	IN	NS	g.edu-servers.net.
edu.			172800	IN	NS	d.edu-servers.net.
edu.			172800	IN	NS	j.edu-servers.net.
edu.			172800	IN	NS	i.edu-servers.net.
;; Received 834 bytes from 192.112.36.4#53(g.root-servers.net) in 57 ms

gatech.edu.		172800	IN	NS	dns1.gatech.edu.
gatech.edu.		172800	IN	NS	dns2.gatech.edu.
gatech.edu.		172800	IN	NS	dns3.gatech.edu.
;; Received 144 bytes from 192.12.94.30#53(e.edu-servers.net) in 24 ms

gatech.edu.		300	IN	A	130.207.160.173
gatech.edu.		86400	IN	NS	dns1.gatech.edu.
gatech.edu.		86400	IN	NS	dns3.gatech.edu.
gatech.edu.		86400	IN	NS	dns2.gatech.edu.
;; Received 216 bytes from 130.207.244.81#53(dns2.gatech.edu) in 34 ms
```

The local resolver issues a query to to the root server, which responds with an NS record for the edu server. The query is issued again to the edu server, which responds with an NS record for the GATech server. The final query is issued to the GATech DNS server, which responds with the A record for gatech.edu

### Example 6 (PTR)

Here is an example of how to map an IP address back to a name; that is, given an IP address, find the PTR record that points to the domain name.

```bash
Matts-MBP:~ mschlenker$ dig +trace +nodnssec -x 130.207.7.36

; <<>> DiG 9.10.6 <<>> +trace +nodnssec -x 130.207.7.36
;; global options: +cmd
.			508851	IN	NS	a.root-servers.net.
.			508851	IN	NS	b.root-servers.net.
.			508851	IN	NS	c.root-servers.net.
.			508851	IN	NS	d.root-servers.net.
.			508851	IN	NS	e.root-servers.net.
.			508851	IN	NS	f.root-servers.net.
.			508851	IN	NS	g.root-servers.net.
.			508851	IN	NS	h.root-servers.net.
.			508851	IN	NS	i.root-servers.net.
.			508851	IN	NS	j.root-servers.net.
.			508851	IN	NS	k.root-servers.net.
.			508851	IN	NS	l.root-servers.net.
.			508851	IN	NS	m.root-servers.net.
;; Received 239 bytes from 192.168.1.1#53(192.168.1.1) in 19 ms

in-addr.arpa.		172800	IN	NS	a.in-addr-servers.arpa.
in-addr.arpa.		172800	IN	NS	b.in-addr-servers.arpa.
in-addr.arpa.		172800	IN	NS	c.in-addr-servers.arpa.
in-addr.arpa.		172800	IN	NS	d.in-addr-servers.arpa.
in-addr.arpa.		172800	IN	NS	e.in-addr-servers.arpa.
in-addr.arpa.		172800	IN	NS	f.in-addr-servers.arpa.
;; Received 430 bytes from 2001:500:9f::42#53(l.root-servers.net) in 21 ms

130.in-addr.arpa.	86400	IN	NS	x.arin.net.
130.in-addr.arpa.	86400	IN	NS	y.arin.net.
130.in-addr.arpa.	86400	IN	NS	arin.authdns.ripe.net.
130.in-addr.arpa.	86400	IN	NS	z.arin.net.
130.in-addr.arpa.	86400	IN	NS	r.arin.net.
130.in-addr.arpa.	86400	IN	NS	u.arin.net.
;; Received 174 bytes from 199.180.182.53#53(a.in-addr-servers.arpa) in 104 ms

207.130.in-addr.arpa.	86400	IN	NS	dns1.gatech.edu.
207.130.in-addr.arpa.	86400	IN	NS	dns2.gatech.edu.
207.130.in-addr.arpa.	86400	IN	NS	dns3.gatech.edu.
;; Received 121 bytes from 199.180.180.63#53(r.arin.net) in 104 ms

36.7.207.130.in-addr.arpa. 28800 IN	PTR	granite.cc.gatech.edu.
207.130.in-addr.arpa.	86400	IN	NS	dns3.gatech.edu.
207.130.in-addr.arpa.	86400	IN	NS	dns1.gatech.edu.
207.130.in-addr.arpa.	86400	IN	NS	dns2.gatech.edu.
;; Received 250 bytes from 2610:148:1f01:f400::3#53(dns2.gatech.edu) in 48 ms
```

When we ask the root server about this particular IP address, we are referred to a special top level domain `in-addr.arpa` which maintains referrals to authoritative servers that are maintained by the respective internet routing registries, such as ARIN, RIPE, or APNIC.

After our initial referral to `in-addr.arpa`, we see another referral to `130.in-addr.arpa` where the "130" corresponds to the first octet of the IP address in question: `130.207.7.36`.

Next, we ask ARIN about `130.in-addr.arpa`, and we receive a referral to `207.130.in-addr.arpa`. Because `130.207` is allocated gatech.edu, ARIN knows to point us to dns{1,2,3}.gatech.edu.

Next, we issue the request to dns2.gatech.edu and we can finally get the PTR record because this server knows the reverse mapping for `130.207.7.36` and the name - `granite.cc.gatech.edu` - that points to this IP address.
