# 🌐 Day 20 — DNS (Domain Name System)

<!-- portfolio-quick-review:start -->
## ⚡ Quick review

- **Problem:** Computers communicate using IP addresses, but users normally access services using names such as `www.netflix.com`.
- **Actions:** I studied DNS resolution, configured a DNS server and website in Cisco Packet Tracer, tested name-based access, and practiced DNS queries using `nslookup`.
- **Result:** I successfully resolved domain names to IP addresses, accessed a Packet Tracer website using its domain name, and queried IPv4, IPv6, name-server, mail-server, and alias information.
- **Key understanding:** DNS resolves names into network information. `A` returns IPv4, `AAAA` returns IPv6, `NS` identifies name servers, and `MX` identifies mail servers.
- **Evidence:** Packet Tracer DNS configuration, working website test, and `nslookup` queries for Google and Netflix.

[Read the full learning notes ↓](#full-learning-notes)

---

<a id="full-learning-notes"></a>
<!-- portfolio-quick-review:end -->

## 📌 What changed today?

Until now, most of my networking practice used IP addresses directly.

For example:

```text
ping 192.168.1.1
```

But real users normally do not type the IP address of every website.

Instead, we use names:

```text
www.netflix.com
www.google.com
```

Today I learned how **DNS connects those names with IP addresses**.

My basic mental model became:

```text
Domain Name
    ↓
DNS
    ↓
IP Address
    ↓
Network communication
```

---

## 🎯 What I practiced

- Understanding the purpose of DNS.
- Understanding recursive DNS resolution.
- Learning why DNS normally uses port `53`.
- Configuring a DNS server in Cisco Packet Tracer.
- Creating an `A` record for a website.
- Configuring a client to use a DNS server.
- Opening a website using its domain name instead of its IP address.
- Using `nslookup` to inspect DNS information.
- Querying `A`, `AAAA`, `NS`, and `MX` records.
- Understanding `CNAME` aliases.
- Understanding the difference between authoritative and non-authoritative DNS responses.
- Connecting DNS with concepts I already learned such as routing, IP addressing, UDP, and ARP.

---

## 🧠 What is DNS?

**DNS** stands for:

> **Domain Name System**

DNS allows a hostname such as:

```text
www.netflix.com
```

to be resolved into an IP address that a computer can use.

A simplified example is:

```text
www.example.com
        ↓
       DNS
        ↓
192.0.2.10
```

DNS is therefore similar to a directory that connects a name with network information.

---

## 🔄 How DNS resolution works

A simplified DNS lookup can be represented as:

```text
Client
  ↓
Recursive DNS Resolver
  ↓
Root DNS Server
  ↓
TLD DNS Server
  ↓
Authoritative DNS Server
  ↓
Answer returned to resolver
  ↓
Client
```

One important point I learned is that the root, TLD, and authoritative servers do not normally keep forwarding my request from one server to another.

The **recursive resolver** performs those lookups for the client.

### Root DNS server

The root server can guide the resolver toward the correct Top-Level Domain.

For:

```text
www.netflix.com
```

the root server can direct the resolver toward the DNS infrastructure responsible for:

```text
.com
```

### TLD server

**TLD** means:

> **Top-Level Domain**

Examples include:

```text
.com
.org
.net
.in
.edu
```

The `.com` DNS infrastructure can then direct the resolver toward the DNS servers responsible for the requested domain.

### Authoritative DNS server

The authoritative DNS server contains DNS information for the domain.

It can answer questions such as:

```text
What IPv4 address belongs to this hostname?

What IPv6 address belongs to this hostname?

Which server receives email for this domain?
```

---

## 🔌 DNS port and transport

DNS normally uses:

```text
UDP port 53
```

The client usually uses a temporary source port while the DNS server listens on port `53`.

Example:

```text
Client:53128
      ↓
DNS Server:53
```

DNS can also use:

```text
TCP port 53
```

when TCP is required.

My current mental model is:

```text
DNS → usually UDP 53
DNS → can also use TCP 53
```

---

## 🧪 My Packet Tracer DNS lab

I practiced DNS using a routed Packet Tracer topology.

The DNS server was configured with:

```text
IP Address      : 192.168.0.101
Subnet Mask     : 255.255.255.0
Default Gateway : 192.168.0.254
```

I enabled the DNS service from:

```text
Server
  ↓
Services
  ↓
DNS
  ↓
On
```

I then created this DNS record:

```text
Name    : www.cyvero.in
Type    : A Record
Address : 192.168.0.100
```

This means:

```text
www.cyvero.in
      ↓
192.168.0.100
```

---

## 🌍 Testing the website

The client PC was configured to use:

```text
DNS Server: 192.168.0.101
```

I then opened:

```text
http://www.cyvero.in
```

instead of entering the web server's IP address directly.

The process was:

```text
Client
   ↓
"Where is www.cyvero.in?"
   ↓
DNS Server
192.168.0.101
   ↓
A record lookup
   ↓
192.168.0.100
   ↓
Address returned to client
```

After DNS returned the address, the browser connected to the web server.

```text
www.cyvero.in
      ↓ DNS
192.168.0.100
      ↓ HTTP
Website
```

The website loaded successfully.

---

## ⭐ DNS and HTTP are different jobs

This was an important distinction for me.

DNS first discovers the destination:

```text
www.cyvero.in
      ↓
192.168.0.100
```

After that, the browser communicates with the web server.

```text
Client
   ↓
Web Server
```

DNS does not carry the webpage itself.

Its main job here is helping the client discover where the service is located.

---

## 🛣️ Why routing still matters

My client and DNS server were on different IP networks.

For example:

```text
Client Network
192.168.1.0/24

      ↓
   Routers
      ↓

DNS Network
192.168.0.0/24
```

Because they were on different networks, the DNS packet still depended on routing.

So DNS does not replace the networking concepts I previously learned.

It runs on top of them.

```text
DNS
 ↓
UDP / TCP
 ↓
IP
 ↓
Routing
 ↓
Ethernet
```

If the client cannot reach the DNS server at Layer 3, the DNS query cannot succeed.

---

## 🔎 Using `nslookup`

I practiced DNS queries using:

```cmd
nslookup
```

`nslookup` is a DNS query and troubleshooting utility.

It can answer questions such as:

```text
What IPv4 address belongs to this domain?

What IPv6 address belongs to this domain?

Which name servers are responsible for this domain?

Which mail servers receive email for this domain?
```

It is important not to confuse DNS with MAC-address resolution.

```text
DNS:
Domain Name → IP Address

ARP:
IPv4 Address → MAC Address
```

`nslookup` queries DNS records. It does not discover a remote device's Ethernet MAC address.

---

## 📚 DNS records I practiced

| Record | Meaning | What I use it for |
|---|---|---|
| `A` | Address Record | Hostname → IPv4 address |
| `AAAA` | IPv6 Address Record | Hostname → IPv6 address |
| `NS` | Name Server | Find DNS servers responsible for a domain |
| `MX` | Mail Exchanger | Find mail servers responsible for a domain |
| `CNAME` | Canonical Name | Make one hostname an alias of another hostname |
| `SOA` | Start of Authority | View administrative information about a DNS zone |

---

## 🅰️ A record — IPv4

An `A` record is used for IPv4.

Example:

```cmd
nslookup -type=A google.com
```

I read this command as:

> “Ask DNS for the IPv4 address associated with `google.com`.”

Mental shortcut:

```text
A → IPv4
```

---

## 🅰️🅰️🅰️🅰️ AAAA record — IPv6

An `AAAA` record, pronounced **Quad-A**, is used for IPv6.

Example:

```cmd
nslookup -type=AAAA www.netflix.com
```

I read this as:

> “Ask DNS for the IPv6 addresses associated with `www.netflix.com`.”

Mental shortcut:

```text
A     → IPv4
AAAA  → IPv6
```

One important correction I learned is that this does **not** convert an IPv4 address into IPv6.

They are separate DNS record types.

---

## 🏢 NS record — Name Server

`NS` means:

> **Name Server**

I can use it to identify the name servers responsible for a domain.

Example:

```cmd
nslookup -type=NS netflix.com
```

I read this as:

> “Which DNS servers are responsible for `netflix.com`?”

Conceptually:

```text
netflix.com
    ↓
NS records
    ↓
Authoritative Name Servers
```

---

## 📧 MX record — Mail Exchanger

`MX` means:

> **Mail Exchanger**

It identifies servers responsible for receiving email for a domain.

Example:

```cmd
nslookup -type=MX gmail.com
```

I read this as:

> “Which mail servers receive email for `gmail.com`?”

Conceptually:

```text
user@gmail.com
      ↓
MX lookup
      ↓
Mail Servers
```

---

## 🔗 CNAME — Canonical Name

A `CNAME` record allows one hostname to act as an alias for another hostname.

While testing Netflix, I saw a result similar to:

```text
www.netflix.com
      ↓
www.prod.ftl.netflix.com
```

This means the familiar hostname can point toward another canonical hostname.

That hostname can then have its own address records.

```text
www.netflix.com
      ↓
CNAME
      ↓
Canonical Hostname
      ↓
A / AAAA
      ↓
IP Address
```

---

## 🏛️ SOA — Start of Authority

I also encountered an **SOA** record.

SOA means:

> **Start of Authority**

It contains administrative information about a DNS zone.

Some of the fields I observed included:

```text
Primary DNS server
Serial number
Refresh timer
Retry timer
Expiration timer
TTL
```

For now, my main understanding is:

```text
SOA = administrative information about a DNS zone
```

---

## ✅ Authoritative vs non-authoritative answer

While using `nslookup`, I saw:

```text
Non-authoritative answer:
```

This does not mean that the result is false.

It means the DNS server responding to me is not the authoritative DNS server that directly controls that DNS zone.

For example:

```text
My PC
  ↓
Local / ISP DNS Resolver
  ↓
Cached or upstream answer
```

The resolver can still give me the correct result.

It is simply not the original authoritative source for the domain.

---

## ⏳ DNS caching and TTL

DNS results can be cached so that every request does not need to repeat the complete DNS lookup.

Example:

```text
First Request

Client
 ↓
Resolver
 ↓
DNS hierarchy
 ↓
Answer
```

The resolver may temporarily store that answer.

A later request may then be:

```text
Client
 ↓
Resolver Cache
 ↓
Answer
```

This improves performance and reduces unnecessary DNS traffic.

### TTL

**TTL** means:

> **Time To Live**

TTL controls how long a DNS response may remain cached before it should be refreshed.

Example:

```text
TTL = 60
```

means the DNS information may normally remain cached for approximately:

```text
60 seconds
```

before another lookup may be required.

---

## 🧪 Commands I practiced

Basic lookup:

```cmd
nslookup google.com
```

Query IPv4:

```cmd
nslookup -type=A google.com
```

Query IPv6:

```cmd
nslookup -type=AAAA google.com
```

Netflix IPv4:

```cmd
nslookup -type=A www.netflix.com
```

Netflix IPv6:

```cmd
nslookup -type=AAAA www.netflix.com
```

Find name servers:

```cmd
nslookup -type=NS netflix.com
```

Find mail servers:

```cmd
nslookup -type=MX gmail.com
```

I can also enter interactive mode:

```cmd
nslookup
```

and then change the query type:

```text
set type=A
google.com

set type=AAAA
www.netflix.com

set type=NS
netflix.com

set type=MX
gmail.com
```

---

## 🧠 How I now read each command

Instead of memorizing commands blindly, I try to identify the question I am asking DNS.

```cmd
nslookup -type=A google.com
```

means:

```text
Give me Google's IPv4 address.
```

```cmd
nslookup -type=AAAA www.netflix.com
```

means:

```text
Give me Netflix's IPv6 address.
```

```cmd
nslookup -type=NS netflix.com
```

means:

```text
Which name servers are responsible for netflix.com?
```

```cmd
nslookup -type=MX gmail.com
```

means:

```text
Which mail servers receive email for gmail.com?
```

This makes the commands easier for me to remember because I understand what each query is actually requesting.

---

## 🔍 My troubleshooting order

If a hostname is not working, I can now separate a DNS problem from a general network problem.

I would check:

1. Does the client have a valid IP address?
2. Does it have the correct default gateway?
3. Is a DNS server configured?
4. Can the client reach the DNS server?
5. Can `nslookup` resolve the hostname?
6. Does an `A` or `AAAA` record exist?
7. If DNS works, can the client reach the returned IP address?
8. Is the actual application service such as HTTP available?

Useful commands:

```cmd
ipconfig /all
ping <DNS-server-IP>
nslookup <hostname>
nslookup -type=A <hostname>
nslookup -type=AAAA <hostname>
```

This helps me avoid immediately blaming DNS when the actual issue could be routing, addressing, or the application itself.

---

## 🔐 Why DNS matters for cybersecurity

DNS is important in cybersecurity because almost every normal user interaction with internet services begins with a name lookup.

Understanding DNS helps when investigating:

```text
Suspicious domains
Malware communication
Phishing domains
DNS failures
Incorrect DNS configuration
Unexpected DNS responses
Command-and-control traffic
```

For example, if a system repeatedly resolves an unusual domain, the DNS traffic itself can provide useful evidence during an investigation.

DNS is therefore not only a convenience for users — it is also an important source of network visibility.

---

## 🔗 Connecting DNS with what I already learned

DNS helped connect several earlier networking concepts.

```text
User enters domain
        ↓
DNS resolves IP
        ↓
UDP/TCP transports query
        ↓
IP handles addressing
        ↓
Router selects path
        ↓
ARP helps reach the local next hop
        ↓
Destination is reached
```

The difference between DNS and ARP is now especially clear to me:

```text
DNS
Name → IP

ARP
IPv4 → MAC
```

They solve different problems at different parts of communication.

---

## 🧠 My Day 20 takeaway

Today I moved from simply knowing that DNS “converts names into IP addresses” to actually configuring and querying DNS.

I configured a DNS server in Packet Tracer, created an `A` record, configured a client to use that DNS server, and successfully opened a website using its hostname.

I also practiced `nslookup` and learned how to intentionally ask DNS for different information:

```text
A      → IPv4
AAAA   → IPv6
NS     → Name Servers
MX     → Mail Servers
CNAME  → Alias
SOA    → DNS Zone Information
```

The most useful realization was that DNS is only one part of the communication process.

DNS can tell a device **where a service is**, but IP addressing, routing, transport protocols, and the application itself still need to work for the communication to succeed.

**Next practice:** Capture DNS traffic in Wireshark and connect the `nslookup` commands I practiced today with the actual DNS query and response packets on the network.
