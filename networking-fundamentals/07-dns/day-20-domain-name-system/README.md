# 🌐 Day 20 — DNS (Domain Name System)

<!-- portfolio-quick-review:start -->

## ⚡ Quick Review

* **Problem:** Computers communicate using IP addresses, but users normally access services using domain names.
* **What I configured:** A DNS server, a web server, and a client in Cisco Packet Tracer.
* **Result:** Successfully resolved `www.cyvero.in` to `192.168.0.100` and accessed the website using its domain name.
* **Protocols involved:** DNS, UDP, IP, ARP, Ethernet, TCP, and HTTP.
* **Key understanding:** DNS discovers the destination IP address. Routing delivers packets between networks. ARP resolves the MAC address needed on the local Ethernet link.
* **Verification:** Packet Tracer website access and `nslookup` queries for DNS records.

**Main takeaway:** DNS resolution does not establish a website connection. It provides addressing information that other protocols use to communicate.

[Read the full learning notes ↓](#full-learning-notes)

---

<a id="full-learning-notes"></a>

<!-- portfolio-quick-review:end -->

# 🎯 1. What I Practiced

* Configured a DNS server in Cisco Packet Tracer.
* Created an `A` record linking a hostname to a web server IP.
* Configured a client to use the DNS server.
* Accessed a website using its domain name.
* Practiced DNS queries using `nslookup`.
* Studied how DNS interacts with ARP, IP routing, UDP, and HTTP.
* Understood DNS encapsulation, caching, TTL, and troubleshooting.

The objective was to understand **what actually happens to packets when a computer accesses a website using its domain name**.

---

# 🧠 2. DNS — Core Understanding

**DNS stands for Domain Name System.**

Its purpose is to resolve domain names into network information, including IP addresses.

Example:

```text
www.cyvero.in
      |
      | DNS Lookup
      v
192.168.0.100
```

DNS does not physically deliver packets to the destination.

It provides information that allows applications to communicate with the appropriate server.

### DNS vs IP vs ARP

| Technology | Purpose                                                   |
| ---------- | --------------------------------------------------------- |
| DNS        | Resolves domain names into IP addresses                   |
| IP         | Provides logical addressing and enables routing           |
| ARP        | Resolves an IPv4 address to a MAC address on a local link |
| Routing    | Determines where packets should be forwarded              |
| HTTP       | Transfers web content                                     |

**Important distinction:**

```text
DNS → Which IP belongs to this domain?

Routing → Which path should the packet take?

ARP → Which local MAC address should receive the frame?

HTTP → Request and receive the webpage.
```

DNS doesn't replace any of these protocols.

---

# 🔄 3. How DNS Resolution Works

Consider:

```text
www.netflix.com
```

A typical DNS lookup follows this process:

```text
User enters domain name
          |
          v
Browser / OS checks available caches
          |
          | Cache miss
          v
Recursive DNS Resolver
          |
          | Checks its cache
          |
          | If necessary:
          v
Root DNS Server
          |
          | Referral to .com
          v
TLD DNS Server
          |
          | Referral to authoritative DNS
          v
Authoritative DNS Server
          |
          | DNS Answer
          v
Recursive DNS Resolver
          |
          | Returns Answer
          v
Client
```

### Important Components

| Component                | Responsibility                                      |
| ------------------------ | --------------------------------------------------- |
| Stub Resolver            | Client-side component that sends DNS queries        |
| Recursive Resolver       | Finds the requested DNS information                 |
| Root DNS Server          | Directs the resolver toward the correct TLD         |
| TLD Server               | Identifies authoritative DNS servers for the domain |
| Authoritative DNS Server | Provides authoritative records for the domain       |

**TLD = Top-Level Domain**, such as `.com`, `.org`, or `.in`.

### What Actually Happens?

The recursive resolver normally queries the relevant DNS servers in sequence.

The root and TLD servers usually provide referrals, rather than directly forwarding the client's original query to the next server.

The resolver then returns the answer to the client.

### ✅ What Works / What Doesn't

| Scenario                                              | Result           | Reason                                                                   |
| ----------------------------------------------------- | ---------------- | ------------------------------------------------------------------------ |
| DNS answer exists in browser or OS cache              | ✅                | Another lookup may be unnecessary                                        |
| Answer exists in recursive resolver cache             | ✅                | Resolver can respond without repeating the complete lookup               |
| Resolver has no cached answer                         | ✅                | It can query the DNS hierarchy                                           |
| Root server directly provides every website IP        | ❌                | Root servers mainly provide referrals                                    |
| Default gateway automatically performs DNS resolution | ❌                | A normal gateway forwards packets; DNS resolution is a separate function |
| DNS server is not reachable                           | ❌                | The client cannot obtain a fresh answer from that server                 |
| DNS resolves correctly but web server is down         | ❌ Website access | DNS success doesn't guarantee HTTP connectivity                          |

**Key understanding:** The resolver performs the lookup. The default gateway simply forwards packets when the resolver is on another network.

---

# 🧪 4. My Cisco Packet Tracer DNS Lab

## Network Topology

My recorded lab used a DNS server and web server on the `192.168.0.0/24` network, with a client accessing the server through routing.

```text
             CLIENT NETWORK
             192.168.1.0/24
                    |
                 Client PC
                    |
                    |
             Router / Routing
                    |
                    |
           192.168.0.0/24
              SERVER LAN
                    |
          Gateway: 192.168.0.254
                    |
              +-----+-----+
              |           |
              |           |
          DNS Server   Web Server
       192.168.0.101   192.168.0.100
              |           |
              |           |
          DNS Service   HTTP Service
              |           |
              +-----+-----+
                    |
               www.cyvero.in
```

**Topology note:** The client-side network is shown as `192.168.1.0/24` in my original routing explanation. The exact client IP, client gateway, and router-to-router interface addresses were not recorded in the README, so they are not invented here.

## Recorded Lab Configuration

| Component                  | Configuration   |
| -------------------------- | --------------- |
| DNS Server IP              | `192.168.0.101` |
| DNS Server Subnet Mask     | `255.255.255.0` |
| DNS Server Default Gateway | `192.168.0.254` |
| Web Server IP              | `192.168.0.100` |
| Domain Name                | `www.cyvero.in` |
| DNS Record                 | `A`             |
| Client DNS Setting         | `192.168.0.101` |
| Web Service                | HTTP            |

### Step 1 — Configure the DNS Server

In Cisco Packet Tracer:

```text
Server
  |
  v
Desktop
  |
  v
IP Configuration
```

Configure:

```text
IP Address      : 192.168.0.101
Subnet Mask     : 255.255.255.0
Default Gateway : 192.168.0.254
```

The default gateway allows the DNS server to send responses to clients on other networks.

### Step 2 — Enable DNS Service

```text
Server
  |
  v
Services
  |
  v
DNS
  |
  v
On
```

Create the following DNS record:

```text
Name    : www.cyvero.in
Type    : A Record
Address : 192.168.0.100
```

Click **Add**.

The DNS server now has a record associating the hostname with the web server's IPv4 address.

### Step 3 — Configure the Client

```text
PC
 |
 v
Desktop
 |
 v
IP Configuration
 |
 v
DNS Server: 192.168.0.101
```

The client must have:

* A valid IP address and subnet mask.
* A working route to the DNS server.
* The DNS server IP configured.
* A valid default gateway if the destination is on another network.

The client's IP does **not** need to match the DNS server's IP.

### Step 4 — Configure the Web Server

The web server uses:

```text
IP Address: 192.168.0.100
```

For website access, HTTP service must be enabled:

```text
Web Server
    |
    v
Services
    |
    v
HTTP
    |
    v
On
```

### Step 5 — Test

Open the client's browser:

```text
http://www.cyvero.in
```

### ✅ Recorded Result

The website loaded successfully using its domain name.

This demonstrated that:

1. The client could reach the DNS server.
2. The DNS server returned the configured `A` record.
3. The client could reach the web server.
4. HTTP service was accessible.

**Important:** This Packet Tracer lab used a manually configured DNS record. The DNS server could answer directly; it did not need to contact public root, TLD, or authoritative servers.

---

# 📦 5. DNS Packet Flow — What Actually Happens?

This was the most important part of my revision.

Consider the recorded lab:

```text
Client PC
    |
    | DNS Request
    v
DNS Server: 192.168.0.101
    |
    | DNS Response
    v
Web Server IP: 192.168.0.100
```

The client already knows its configured DNS server IP.

It does **not** yet know the web server's IP.

## Step 1 — Check DNS Cache

The browser or operating system checks whether it already has a valid DNS answer.

```text
Domain name found in cache?
          |
       +--+--+
       |     |
      YES    NO
       |     |
       v     v
   Use IP   DNS Query
```

If a usable cached answer exists, a fresh DNS request might not be necessary.

## Step 2 — Determine the Next Hop

The client knows:

```text
Destination DNS IP: 192.168.0.101
```

If this IP belongs to another network, the client forwards the packet through its default gateway.

But Ethernet requires a destination MAC address.

If the gateway's MAC isn't cached, the client uses ARP.

```text
PC
 |
 | ARP Request (Broadcast)
 | "Who has my default gateway IP?"
 |
 v
Default Gateway
 |
 | ARP Reply (Unicast)
 | "Here is my MAC address."
 |
 v
PC
```

**ARP is separate from DNS.**

The ARP request is not placed inside the DNS packet.

If the DNS server were on the same local Ethernet network, the client would normally ARP for the DNS server's MAC instead.

Even a direct PC-to-router Ethernet connection uses MAC addressing.

## Step 3 — Build the DNS Query

Traditional DNS normally uses:

```text
Protocol         : UDP
Destination Port : 53
Source Port      : Temporary client port
```

Example:

```text
Source IP        : <Client-IP>
Destination IP   : 192.168.0.101

Source Port      : 53000
Destination Port : 53
```

`53000` is an example temporary source port, not a fixed DNS client port.

### DNS Encapsulation

```text
APPLICATION LAYER
+------------------------+
| DNS Query              |
| www.cyvero.in          |
| Type: A                |
+------------------------+
             |
             v
TRANSPORT LAYER
+------------+-----------+
| UDP Header | DNS Query |
+------------+-----------+
             |
             v
NETWORK LAYER
+-----------+------------+-----------+
| IP Header | UDP Header | DNS Query |
+-----------+------------+-----------+
             |
             v
DATA LINK LAYER
+-----------------+--------------------------+---------+
| Ethernet Header | IP Packet                | Trailer |
+-----------------+--------------------------+---------+
             |
             v
        Physical Link
```

The Ethernet frame contains the IP packet, which contains the UDP datagram, which contains the DNS query.

UDP adds a header to the DNS message. It does not perform TCP-style segmentation.

## Step 4 — Router Forwards the Packet

For a DNS server on another network:

```text
IP Destination: 192.168.0.101

Ethernet Destination MAC:
Current next-hop device
```

The router receives the Ethernet frame and examines the IP packet.

It checks its routing table and selects the next hop.

If necessary, the router uses ARP to discover the next-hop MAC on its outgoing Ethernet network.

```text
PC
 |
 | IP Destination: DNS Server
 | MAC Destination: Gateway
 v
Router
 |
 | IP Destination: DNS Server
 | MAC Destination: Next Ethernet Hop
 v
DNS Server
```

### Important Rules

**Destination IP:** Normally remains `192.168.0.101` throughout this routed DNS request.

**Destination MAC:** Changes when a router sends the packet over the next Ethernet link.

**ARP:** Discovers the MAC address required for the next local Ethernet delivery.

Normal routing does not replace the destination IP with the next-hop IP.

## Step 5 — DNS Server Sends the Response

The DNS server looks up:

```text
www.cyvero.in
      |
      v
192.168.0.100
```

It responds to the client.

For the example UDP ports:

```text
DNS Request
------------

Source Port      : 53000
Destination Port : 53


DNS Response
------------

Source Port      : 53
Destination Port : 53000
```

The destination IP of the DNS response is the client IP.

The client receives the answer:

```text
www.cyvero.in → 192.168.0.100
```

DNS resolution is complete.

## Step 6 — Establish the HTTP Connection

Now the browser knows the website server's IP.

```text
Client PC
    |
    | TCP Connection
    | Destination: 192.168.0.100
    | Port: 80
    v
Web Server
    |
    | HTTP Response
    v
Webpage
```

The normal HTTP-over-TCP connection begins with a three-way handshake:

```text
Client             Web Server
   |                    |
   |-------- SYN ------>|
   |<----- SYN/ACK -----|
   |-------- ACK ------>|
   |                    |
   |---- HTTP Request ->|
   |<--- HTTP Response -|
```

**DNS provides the IP address. HTTP retrieves the webpage.**

This is why successful DNS resolution alone does not guarantee that a website will load.

---

# 🔌 6. DNS, HTTP, and HTTPS Ports

| Protocol        | Transport     | Port | Purpose                            |
| --------------- | ------------- | ---- | ---------------------------------- |
| Traditional DNS | UDP           | 53   | Common DNS queries                 |
| Traditional DNS | TCP           | 53   | DNS queries when TCP is needed     |
| HTTP            | TCP           | 80   | Unencrypted web communication      |
| HTTPS           | TCP           | 443  | Encrypted web communication        |
| HTTP/3 (HTTPS)  | QUIC over UDP | 443  | Modern encrypted web communication |

### Why Does DNS Normally Use UDP?

UDP does not require a TCP three-way handshake before sending a traditional DNS query.

This reduces connection setup overhead.

TCP is also supported for DNS, including zone transfers and queries that require TCP.

**The DNS protocol and the website protocol are separate.**

---

# 🗂️ 7. DNS Records — Commands and Purpose

I practiced querying DNS records using `nslookup`.

| Record  | Meaning            | Purpose                                     |
| ------- | ------------------ | ------------------------------------------- |
| `A`     | Address            | Hostname → IPv4                             |
| `AAAA`  | IPv6 Address       | Hostname → IPv6                             |
| `NS`    | Name Server        | Identifies authoritative name servers       |
| `MX`    | Mail Exchanger     | Identifies mail servers                     |
| `CNAME` | Canonical Name     | Alias for another hostname                  |
| `SOA`   | Start of Authority | Administrative information about a DNS zone |

### Commands

**Basic DNS lookup**

```cmd
nslookup google.com
```

Queries DNS for the hostname using the default lookup behavior.

**IPv4 Address**

```cmd
nslookup -type=A google.com
```

Requests IPv4 address records.

**IPv6 Address**

```cmd
nslookup -type=AAAA google.com
```

Requests IPv6 address records.

**Name Servers**

```cmd
nslookup -type=NS netflix.com
```

Identifies authoritative name servers for the domain.

**Mail Servers**

```cmd
nslookup -type=MX gmail.com
```

Identifies mail exchangers for the domain.

**CNAME**

```cmd
nslookup -type=CNAME www.netflix.com
```

Queries for a hostname alias, if one exists.

**SOA**

```cmd
nslookup -type=SOA google.com
```

Requests administrative DNS zone information.

### Important Distinctions

```text
A     → IPv4 Address
AAAA  → IPv6 Address
NS    → Authoritative Name Servers
MX    → Mail Servers
CNAME → Hostname Alias
SOA   → DNS Zone Information
```

`AAAA` does not convert IPv4 to IPv6.

`MX` does not contain the contents of emails.

`NS` identifies name servers; it does not display the route packets travel.

`nslookup` performs DNS queries, not network-path tracing.

DNS is also used for services other than websites, including email infrastructure and service discovery.

---

# ⏳ 8. DNS Cache and TTL

**TTL = Time To Live**

DNS caching prevents unnecessary repeated lookups.

Example:

```text
www.cyvero.in → 192.168.0.100

TTL = 300 seconds
```

The record can normally be cached for up to five minutes.

### Example

```text
DNS Record Received
TTL = 300 seconds
        |
        | 100 seconds pass
        v
Remaining TTL = 200 seconds
        |
        | 200 more seconds pass
        v
TTL Expires
        |
        v
Fresh DNS Lookup Normally Required
```

### Important Discovery

The client and recursive resolver maintain separate DNS caches.

```text
Authoritative DNS
      |
      | TTL = 300
      v
Recursive Resolver Cache
      |
      | After 100 seconds
      | Remaining TTL = 200
      v
Client Cache
```

**What works / What doesn't**

| Scenario                                     | Result                                                  |
| -------------------------------------------- | ------------------------------------------------------- |
| Client has a valid cached record             | Normally uses the cached answer                         |
| Client cache expires                         | Normally performs another DNS lookup                    |
| Recursive resolver has a valid cached record | Can answer without querying authoritative servers again |
| Recursive resolver cache expires             | Normally refreshes its information                      |
| DNS cache lasts forever                      | ❌ Incorrect                                             |

Some resolvers can temporarily serve expired cached answers under special conditions, but ordinary DNS caching follows TTL limits.

### Useful Windows Commands

View the operating system's DNS cache:

```cmd
ipconfig /displaydns
```

Clear the Windows DNS resolver cache:

```cmd
ipconfig /flushdns
```

Inspect DNS server settings:

```cmd
ipconfig /all
```

---

# 🛠️ 9. Configuring and Removing DNS in Packet Tracer

DNS service configuration is normally performed through the Packet Tracer server interface, not through the Cisco router's `router rip` or `router ospf` commands.

### Configure

```text
Server → Services → DNS → On
```

Add:

```text
Name    : www.cyvero.in
Type    : A
Address : 192.168.0.100
```

Configure the client DNS server:

```text
PC → Desktop → IP Configuration

DNS Server: 192.168.0.101
```

### Remove or Change

**Remove a DNS record:**

```text
Server → Services → DNS
Select Record → Remove
```

**Disable DNS service:**

```text
Server → Services → DNS → Off
```

**Change the client's DNS server:**

```text
PC → Desktop → IP Configuration
```

Replace the DNS server address with another valid DNS server or change the DHCP configuration that supplies it.

### Important Rules

* Removing an `A` record does not remove the web server.
* Disabling DNS does not automatically stop HTTP service.
* Changing DNS does not change the client's IP address.
* DNS configuration does not replace routing configuration.

---

# ✅ 10. What Works / What Doesn't

These were the most important practical distinctions from my revision.

| Scenario                                                     | Works?           | Explanation                                          |
| ------------------------------------------------------------ | ---------------- | ---------------------------------------------------- |
| PC and DNS server in the same Ethernet subnet                | ✅                | They can communicate locally using ARP               |
| PC and DNS server on different networks                      | ✅                | Routing must provide connectivity                    |
| PC directly connected to router without a switch             | ✅                | Ethernet MAC addressing still applies                |
| PC uses router's MAC to reach remote DNS server              | ✅                | Router is the next Ethernet hop                      |
| PC ARPs directly for a remote DNS server's MAC               | ❌ Normally       | ARP operates on the local link                       |
| Router forwards the client's ARP broadcast to another subnet | ❌ Normally       | Routers don't forward ordinary ARP broadcasts        |
| DNS query travels inside a UDP datagram                      | ✅                | Traditional DNS commonly uses UDP                    |
| ARP request is encapsulated inside the DNS packet            | ❌                | ARP is a separate protocol and frame                 |
| DNS resolution succeeds but HTTP service is disabled         | ❌ Website access | DNS and HTTP are separate services                   |
| DNS server IP and website server IP are different            | ✅                | DNS and web services can run on different devices    |
| DNS cache can avoid repeated queries                         | ✅                | Until the cached record expires                      |
| `nslookup` displays network hops to the destination          | ❌                | It queries DNS information, not packet routes        |
| Successful ping to DNS server guarantees domain resolution   | ❌                | DNS service and the requested record must still work |
| Successful DNS resolution guarantees a working website       | ❌                | Routing, transport, and web service must also work   |

---

# 🔍 11. DNS Verification and Troubleshooting

When a website doesn't open, I should identify whether the problem is DNS, routing, or HTTP.

| Check                   | Command / Action            | Purpose                                            |
| ----------------------- | --------------------------- | -------------------------------------------------- |
| Client configuration    | `ipconfig /all`             | Check IP, gateway, DNS settings                    |
| DNS server reachability | `ping 192.168.0.101`        | Test basic IP connectivity                         |
| Domain resolution       | `nslookup www.cyvero.in`    | Request the website's DNS address                  |
| DNS record              | Server → Services → DNS     | Confirm the `A` record                             |
| Router reachability     | `sh ip route`               | Check routing information                          |
| Website availability    | Open `http://192.168.0.100` | Test HTTP access without needing a hostname lookup |
| Domain-based access     | Open `http://www.cyvero.in` | Test DNS-dependent website access                  |

### Practical Diagnosis

**Case 1: Website works using IP, but not domain**

```text
http://192.168.0.100   ✅
http://www.cyvero.in   ❌
```

Likely areas to investigate:

* DNS server configuration.
* DNS record.
* Client DNS settings.
* DNS cache.

**Case 2: DNS resolves, but website doesn't open**

```text
nslookup www.cyvero.in   ✅
Website access           ❌
```

Investigate:

* Web server availability.
* HTTP service.
* Routing to the web server.
* Firewall or access-control restrictions.

**Case 3: DNS server is unreachable**

```text
ping 192.168.0.101   ❌
```

Investigate:

* Client IP and subnet mask.
* Default gateway.
* Router interfaces.
* Routing tables.
* DNS server network configuration.

A failed ping alone does not prove DNS is unavailable because ICMP can be blocked.

**Troubleshooting principle:** First identify which part of communication failed. Don't assume every website failure is a DNS failure.

---

# 🔐 12. Cybersecurity Relevance

DNS is useful for investigating suspicious network activity.

| Security Scenario      | How DNS Knowledge Helps                             |
| ---------------------- | --------------------------------------------------- |
| Phishing               | Examine suspicious domain names and DNS records     |
| Malware communication  | Investigate unusual or repeated DNS queries         |
| DNS tunneling          | Identify abnormal DNS traffic patterns              |
| DNS spoofing           | Investigate unexpected or manipulated DNS responses |
| Network outages        | Separate DNS failures from routing failures         |
| Incident investigation | Correlate DNS activity with IP connections          |

### Practical Example

Suppose a security analyst observes:

```text
PC → Unknown Domain
         |
         v
DNS Query
         |
         v
Suspicious IP Address
         |
         v
Repeated Network Connections
```

DNS logs and packet captures can help identify which domains a system attempted to resolve.

However, a DNS query alone does not prove malicious activity. It must be investigated alongside other network evidence.

---

# 🧠 13. What I Learned Beyond Configuration

The most important outcome of this lab was understanding how DNS interacts with other networking protocols.

### My Final Mental Model

```text
User enters www.cyvero.in
           |
           v
Check DNS Cache
           |
           | Cache Miss
           v
Prepare DNS Query
           |
           v
UDP Port 53
           |
           v
IP Destination: DNS Server
           |
           v
ARP for Local Next-Hop MAC
(if needed)
           |
           v
Ethernet Frame
           |
           v
Router Forwards Packet
           |
           v
DNS Server Receives Query
           |
           v
DNS Response Returns
           |
           v
Client Learns Web Server IP
           |
           v
TCP Connection to Port 80
           |
           v
HTTP Request / Response
           |
           v
Website Loads
```

### Key Takeaways

**DNS:** Resolves domain names into network information.

**ARP:** Finds the MAC address needed for local Ethernet delivery.

**Routing:** Determines how IP packets reach other networks.

**UDP:** Commonly transports traditional DNS queries using port 53.

**TCP:** Provides reliable transport for the HTTP connection used in this lab.

**HTTP:** Retrieves website content from the web server.

**TTL:** Limits how long DNS information can normally be cached.

**`nslookup`:** Queries DNS records for investigation and troubleshooting.

---

# 📌 14. Lab Evidence and Scope

### Successfully Practiced

* Configured the DNS server at `192.168.0.101`.
* Created an `A` record for `www.cyvero.in`.
* Associated the hostname with web server `192.168.0.100`.
* Configured the client to use the DNS server.
* Successfully accessed `http://www.cyvero.in`.
* Practiced `nslookup` queries using public domains, including Google and Netflix.
* Investigated IPv4, IPv6, name-server, mail-server, and hostname-alias records.

### Understanding Strengthened Through Revision

* DNS cache vs recursive resolver cache.
* Recursive DNS resolution vs local Packet Tracer DNS.
* DNS query encapsulation.
* ARP before Ethernet packet delivery.
* Next-hop MAC vs final destination IP.
* DNS request and response port numbers.
* DNS resolution vs TCP/HTTP communication.
* TTL expiration and repeat DNS queries.

**Evidence limitation:** The original lab notes document successful name-based website access and `nslookup` practice. They do not include a recorded Wireshark DNS packet capture, so the packet-flow diagrams above explain expected protocol behavior rather than claiming an observed capture.

---

## ✅ Day 20 — DNS Completed

This lab helped me move beyond memorizing DNS record types.

I can now explain:

* **What DNS does and what it does not do.**
* **Why routing and ARP are still necessary.**
* **How DNS messages are encapsulated and transmitted.**
* **Why DNS uses UDP port 53 in typical traditional queries.**
* **How to configure and test a DNS server in Packet Tracer.**
* **How to identify DNS problems separately from IP connectivity and web-service problems.**

**Final takeaway:**

> DNS tells a device where a service can be found. IP routing and local-link delivery get packets there, while the application protocol handles the actual service communication.

