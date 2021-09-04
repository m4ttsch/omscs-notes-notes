---
id: computer-networks-old-spam
title: Spam
course: computer-networks-old
lecture: spam
---

# Spam

## Spam

While we don't really interact with spam these days outside of our spam folder, it remains a scourge for network operators.

For example, removing spam primarily relies on filters that separate good traffic from bad traffic, and someone has to design and update those filters.

Even if mail has been classified as spam, it can still pose a threat to mail servers.

If a mail server accepts the delivery of a piece of mail, the internet's mail protocols dictate that the server must keep it for the user.

Since the vast majority of internet mail traffic is spam, this requirement means that spam mail can potentially consume a significant amount of storage space on email servers.

Finally, spam can create security problems for users who receive and interact with spam emails.

Spam messages often contain payloads that can be harmful, such as malware. Alternatively, many spam messages are **phishing attacks**: attempts to steal private or sensitive information, like passwords.

How can we separate the spam from the "ham"?

### Content-based filtering

Content-based filtering looks at what is being said in the email. For example, a content-based filter might reject mail containing particular words, like "viagra" or "Rolex".

Unfortunately, there are [many different spellings of viagra](http://cockeyed.com/lessons/viagra/viagra.html). In addition, message content can be carried not only in text, but in images, excel spreadsheets, audio and movies.

Those maintaining the filters suffer a relatively high cost because the filters must be continuously updated as content changes and the means of carrying the content becomes more sophisticated.

In short, content-based filters are easy to evade and expensive to maintain.

### Blacklisting

Alternatively, a filter might make a decision about whether an email address is spam based on the IP address of the sender. This method is often called **blacklisting**.

When a sender sends an email to the receiver, the receiver sends a query for that IP address to a DNS-based blacklist, such as [spamhaus](https://www.spamhaus.org/).

If the IP address appears in the blacklist, the receiver can decide to terminate the connection and not receive the mail at all, thereby saving the operator the trouble of having to store the message.

IP blacklists are also relatively easy to evade.

A spammer could hijack an IP prefix for a very short period of time, send the spam from an IP address from within that IP prefix, and then withdraw the prefix at the end of the attack.

This allows the attackers to use ephemeral IP addresses, essentially rendering IP blacklists ineffective.

### Behavioral Features

We can also construct filters based on behavioral features, or how the mail is sent.

Behavioral features include the geographic locations of sender and receiver, the set of target recipients, the sender's upstream ISP, or our inference as to whether the sender is a member of a botnet.

We can look at single packet features; in other words, features that a receiver could make a decision on just based on the first packet that a sender sends.

Such single packet features include the distance between sender and receiver, the local time at the sender, the sender's AS, and the density in IP space in terms of how many other mail senders are nearby.

If we are willing to look beyond a single packet, and look at a single message, the number of recipients and the length of the message also proved effective at distinguishing spammers from legitimate senders.

We can also look at aggregates, or group of email messages. For example, looking at the variation in message length across blocks of messages can be useful for distinguishing spam from spam.

Putting these features together in a system called [SNARE: spatiotemporal network-level automated reputation engine](https://www.usenix.org/legacy/event/sec09/tech/full_papers/hao.pdf) achieved a 70% spam detection rate with a false positive rate of 0.1%.

This level of accuracy is good enough to be used in practice, and provides comparable performance to state of the art IP-based blacklists like spamhaus.

The advantage over spamhaus is that SNARE only uses network-level features, thus making it less susceptible to the ephemeral nature of IP-based blacklists.

The challenges of building filters around behavioral features is that we first have to understand network behavior and then build classifiers using network-level features to execute the filtering.
