# 🌐 NETWORKING — DAY 06

## TCP/IP → TCP Header → Ports → Sockets → NAT/PAT → Real Connections

**Learning Track:** Networking Fundamentals  
**Focus:** TCP/IP Model • Transport Layer • TCP • UDP • TCP Header • Sequence Numbers • Acknowledgments • TCP Flags • Ports • Ephemeral Ports • 5-Tuple • Sockets • NAT • PAT • TCP States • Netstat • Process Identification

---

> [!IMPORTANT]
>
> ### 💡 The main idea I am taking from Networking Day 6
>
> **An IP address gets communication to a machine, but TCP/UDP ports and sockets help the operating system deliver that communication to the correct endpoint.**
>
> What made this topic click for me was seeing the same concepts directly on my own laptop using `netstat`.
>
> I was no longer looking at:
>
> ```text
> IP addresses
> ports
> TCP
> sockets
> processes
> ```
>
> as separate topics.
>
> They became one connected flow:
>
> ```text
> Application
>      │
>      ▼
> Socket
>      │
>      ▼
> TCP / UDP
>      │
>      ▼
> Port
>      │
>      ▼
> IP
>      │
>      ▼
> Network
> ```

---

# 01 — 🧱 Where TCP/IP Fits Into My Networking Model

I previously studied the OSI model.

Today I focused on how the practical TCP/IP model organizes the same communication process.

```text
┌─────────────────────────────┬─────────────────────────────┐
│ OSI MODEL                   │ TCP/IP MODEL                │
├─────────────────────────────┼─────────────────────────────┤
│ Application                 │                             │
│ Presentation                │ Application                 │
│ Session                     │                             │
├─────────────────────────────┼─────────────────────────────┤
│ Transport                   │ Transport                   │
├─────────────────────────────┼─────────────────────────────┤
│ Network                     │ Internet                    │
├─────────────────────────────┼─────────────────────────────┤
│ Data Link                   │ Network Access              │
│ Physical                    │                             │
└─────────────────────────────┴─────────────────────────────┘
```

My current mental model is:

```text
APPLICATION
"What application-level protocol is being used?"

HTTP / HTTPS / SSH / DNS / SMTP
                 │
                 ▼
TRANSPORT
"How are the application endpoints communicating?"

TCP / UDP + Ports
                 │
                 ▼
INTERNET
"Which host/network should this reach?"

IP Addressing + Routing
                 │
                 ▼
NETWORK ACCESS
"How does it move across the local link?"

Ethernet / Wi-Fi / MAC / Frames
```

One correction that became important for me:

> The Transport layer does not inspect an application and randomly decide whether TCP or UDP looks better.

The application or application protocol is designed to use a particular transport mechanism, and the operating system provides those networking services.

---

# 02 — 🚚 Why the Transport Layer Matters

The Transport layer finally connected two ideas for me:

```text
IP Address
     +
Port Number
```

An IP address answers roughly:

> **Which host/interface?**

A port answers roughly:

> **Which communication endpoint/service on that host?**

So:

```text
IP only
192.168.1.20

does not tell the whole story.
```

A much more useful view is:

```text
192.168.1.20:53127
               │
               └── Port
```

This is one reason the Transport layer is so important.

A single computer may simultaneously run:

```text
Chrome
Firefox
SSH
Email
Windows services
DNS-related communication
other applications
```

They can all use the same IP address.

Ports and sockets help the operating system keep their communication separated.

---

# 03 — ⚖️ TCP vs UDP — The Difference I Actually Care About

I do not want to remember only:

> TCP = reliable  
> UDP = fast

That hides the reason they behave differently.

## TCP — Transmission Control Protocol

TCP maintains communication state and provides mechanisms such as:

- sequence tracking,
- acknowledgments,
- retransmission,
- ordered delivery,
- flow control,
- congestion control.

My mental model is:

```text
TCP

"I care about tracking this communication
and knowing what happened to the data."
```

---

## UDP — User Datagram Protocol

UDP provides a much simpler datagram transport mechanism.

It does not itself provide TCP-style:

- connection establishment,
- ordered byte-stream delivery,
- acknowledgments,
- retransmission,
- flow control.

My mental model is:

```text
UDP

"Here is a datagram.
Send it toward the destination."
```

This does **not** mean reliability can never exist when UDP is used.

A protocol or application running above UDP can implement additional mechanisms when required.

---

# 04 — 🤝 TCP Connection Establishment

TCP is connection-oriented.

Before normal application communication begins, TCP normally establishes the connection using the three-way handshake.

```text
CLIENT                                      SERVER

   │                                           │
   │  SYN                                      │
   ├──────────────────────────────────────────►│
   │                                           │
   │              SYN + ACK                    │
   │◄──────────────────────────────────────────┤
   │                                           │
   │  ACK                                      │
   ├──────────────────────────────────────────►│
   │                                           │
   │          CONNECTION ESTABLISHED           │
```

The important correction for me was:

```text
SYN ≠ SEQ
```

`SYN` is a TCP flag.

`SEQ` refers to the Sequence Number field.

---

# 05 — 🔢 Sequence Numbers and Acknowledgments

This is where TCP reliability started making practical sense to me.

TCP sequence numbers are not simply:

```text
Packet 1
Packet 2
Packet 3
```

TCP tracks positions in a **byte stream**.

Suppose TCP sends:

```text
Sequence Number = 5000
Data Length      = 100 bytes
```

The transmitted bytes represent approximately:

```text
5000 ──────────────────────────────► 5099
```

The receiver can then respond:

```text
ACK = 5100
```

Meaning:

> **I have successfully received everything before 5100. Byte 5100 is what I expect next.**

My simplest mental model:

```text
SEQ
=
Where do these bytes belong?

ACK
=
What byte do I expect next?
```

This also helps TCP detect gaps and retransmit missing information when necessary.

---

# 06 — 📦 What a TCP Segment Looks Like

A TCP segment contains:

```text
┌───────────────────────────────────────────────────┐
│                    TCP HEADER                     │
│                                                   │
│ Source Port                                       │
│ Destination Port                                  │
│ Sequence Number                                   │
│ Acknowledgment Number                             │
│ Data Offset                                       │
│ Reserved                                          │
│ Flags                                             │
│ Window Size                                       │
│ Checksum                                          │
│ Urgent Pointer                                    │
│ Options                                           │
│ Padding                                           │
├───────────────────────────────────────────────────┤
│                                                   │
│              APPLICATION DATA                     │
│                                                   │
│ HTTP / SSH / other application information       │
│                                                   │
└───────────────────────────────────────────────────┘
```

An important distinction:

```text
IP HEADER
├── Source IP
└── Destination IP


TCP HEADER
├── Source Port
├── Destination Port
├── Sequence Number
├── Acknowledgment Number
├── Flags
├── Window
├── Checksum
└── ...
```

The source and destination IP addresses are **not TCP header fields**.

They belong to the IP header.

---

# 07 — 🧠 TCP Header — My Practical Mental Map

Instead of memorizing every field as a random box, I now connect every important field to one question.

| TCP Field | Size | How I Remember It |
|---|---:|---|
| Source Port | 16 bits | Which local communication endpoint sent this? |
| Destination Port | 16 bits | Which destination endpoint should receive it? |
| Sequence Number | 32 bits | Where do these bytes belong? |
| Acknowledgment Number | 32 bits | What byte do I expect next? |
| Data Offset | 4 bits | How large is this TCP header / where does payload begin? |
| Reserved | 3 bits | Bits reserved for protocol use/extensions |
| Flags | 9 bits | What is happening with this TCP segment/connection? |
| Window Size | 16 bits | How much data can the receiver currently accept? |
| Checksum | 16 bits | Was the TCP information corrupted? |
| Urgent Pointer | 16 bits | Used with URG for urgent-data handling |
| Options | 0–40 bytes | Extra TCP capabilities |
| Padding | Variable | Filler for header alignment |
| Data | Variable | Actual application payload |

---

# 08 — 🏳️ TCP Flags

The flags I currently care about most are:

```text
SYN
ACK
FIN
RST
```

### SYN

Used when establishing/synchronizing a TCP connection.

```text
SYN
=
"Let's establish this TCP communication."
```

### ACK

Indicates that the Acknowledgment Number field is valid.

```text
ACK 5100
=
"I expect byte 5100 next."
```

### FIN

Used for graceful connection termination.

```text
FIN
=
"I am finished. Let's close this connection properly."
```

### RST

Immediately resets/aborts the connection.

```text
RST
=
"Stop/reset this connection."
```

I also recognize:

```text
PSH
URG
ECE
CWR
NS
```

but I do not need deep knowledge of every advanced flag yet.

---

# 09 — 🪟 Window Size — Flow Control

Window Size finally made sense when I stopped treating it as just another header number.

The receiving machine may effectively say:

```text
"I currently have room for this much more data."
```

Example:

```text
Receiver

Available receive capacity
████████████████░░░░░░░

       │
       ▼

Advertised Window
```

TCP uses this for:

> **Flow Control**

The purpose is to prevent the sender from overwhelming the receiver.

I now separate:

```text
FLOW CONTROL
Protect the receiver

        ≠

CONGESTION CONTROL
Protect/manage the network
```

The receive window can change while the connection is active.

---

# 10 — ✅ Checksum

The TCP checksum helps detect accidental corruption.

Conceptually:

```text
SENDER

TCP Header + Data
       │
       ▼
Calculate checksum
       │
       ▼
Transmit


RECEIVER

Received Header + Data
       │
       ▼
Verify checksum
       │
       ▼
Mismatch?
Possible corruption
```

Checksum is:

```text
Error detection
```

It is **not** encryption.

---

# 11 — 📐 Data Offset, Options and Padding

These fields initially looked unimportant, but now I understand why they exist.

## Data Offset

TCP headers are not always the same size.

```text
Minimum TCP Header
20 bytes
```

TCP options can extend the header.

```text
Maximum TCP Header
60 bytes
```

So Data Offset tells the receiver:

> **How long is this TCP header, and therefore where does the actual payload begin?**

It does **not** mean:

> where the next TCP segment begins.

---

## Options

TCP options allow additional TCP capabilities.

Examples I currently recognize:

```text
MSS
Maximum Segment Size

SACK
Selective Acknowledgment

Window Scaling
Allows larger effective TCP receive windows

Timestamps
Additional timing-related TCP information
```

I do not need to memorize their binary formats yet.

---

## Padding

Padding is simply:

> **Filler used to align the TCP header correctly on a 32-bit boundary.**

It is not filtering and it does not identify received data.

---

# 12 — 🔌 What a Network Port Actually Is

A TCP/UDP port is not a physical connector like:

```text
USB Port
Ethernet Port
```

It is a **logical identifier** used by the networking stack.

TCP and UDP port fields are:

```text
16 bits
```

Therefore:

```text
2^16 = 65,536 possible values
```

The range is:

```text
0 → 65,535
```

There are 65,536 values because counting starts at zero.

---

# 13 — 🗂️ Port Number Ranges

IANA organizes ports into three broad ranges:

```text
┌───────────────────┬─────────────────────────────────┐
│ Range             │ Category                        │
├───────────────────┼─────────────────────────────────┤
│ 0 – 1023          │ Well-Known / System Ports       │
│ 1024 – 49151      │ Registered / User Ports         │
│ 49152 – 65535     │ Dynamic / Private / Ephemeral   │
└───────────────────┴─────────────────────────────────┘
```

The last range is commonly associated with temporary client ports.

However, the actual ephemeral-port range can depend on the operating system configuration.

---

# 14 — 🔑 Ports I Want in Muscle Memory

I do **not** want to memorize hundreds of ports.

These are the ones I currently want to recognize quickly:

| Port | Service | Purpose |
|---:|---|---|
| 20/21 | FTP | File transfer |
| 22 | SSH | Secure remote access |
| 23 | Telnet | Insecure remote access |
| 25 | SMTP | Email transfer |
| 53 | DNS | Name resolution |
| 67/68 | DHCP | IP configuration |
| 80 | HTTP | Web |
| 110 | POP3 | Email retrieval |
| 123 | NTP | Time synchronization |
| 143 | IMAP | Email access |
| 161/162 | SNMP | Network monitoring |
| 389 | LDAP | Directory services |
| 443 | HTTPS | Secure web |
| 445 | SMB | Windows file sharing |

Secure/related ports I want to recognize:

```text
465 → SMTP with implicit TLS
587 → Mail submission
636 → LDAPS
993 → IMAPS
995 → POP3S
```

Good-to-recognize ports:

```text
1433 → Microsoft SQL Server
1521 → Oracle
2049 → NFS
3306 → MySQL
3389 → RDP
5432 → PostgreSQL
5900 → VNC
6379 → Redis
8080 → Common alternative HTTP port
8443 → Common alternative HTTPS-style port
```

---

# 15 — 💻 Client Port vs Server Port

This was one of my biggest questions.

Suppose my browser connects to an HTTPS server.

```text
MY LAPTOP                              WEB SERVER

192.168.1.20:53127  ───────────────►  142.x.x.x:443
              │                                  │
              │                                  │
       Temporary Client Port              HTTPS Service Port
```

My computer does **not** need to use port `443` as its own source port.

Typically:

```text
CLIENT
Temporary / Ephemeral Source Port

SERVER
Known or Configured Service Port
```

Example:

```text
53127 → 443
```

means roughly:

```text
Client-side temporary port
        ↓
HTTPS service
```

But I also learned not to create the false rule:

> Every client always uses an ephemeral port.

Some protocols have predefined ports on both sides.

For example:

```text
DHCP Server → UDP 67
DHCP Client → UDP 68
```

---

# 16 — 🧩 The TCP 5-Tuple

Port `443` alone does not identify one TCP connection.

A TCP connection can be distinguished using:

```text
Source IP
Source Port
Destination IP
Destination Port
Protocol
```

Example:

```text
192.168.1.20:53127
        │
        │ TCP
        ▼
142.x.x.x:443
```

This can be represented as:

```text
Source IP        = 192.168.1.20
Source Port      = 53127
Destination IP   = 142.x.x.x
Destination Port = 443
Protocol         = TCP
```

Now compare:

```text
192.168.1.20:53127 → Server:443

192.168.1.20:53128 → Server:443
```

They are different connections because the source ports differ.

This helped answer another question I had:

> **How can millions of people use port 443 at the same time?**

Because the connection is not identified by:

```text
443
```

alone.

The complete combination is different.

---

# 17 — 🌍 How Large Websites Handle Huge Numbers of Connections

Large services do not need a unique port for every customer.

They can have:

```text
Client A:50100 ─────┐
                    │
Client B:52001 ─────┼────► Server :443
                    │
Client C:53002 ─────┘
```

And at larger scale:

```text
                         INTERNET
                            │
                            ▼
                     LOAD BALANCER
                            │
            ┌───────────────┼───────────────┐
            │               │               │
            ▼               ▼               ▼
        Server A        Server B        Server C
          :443            :443            :443
```

Multiple servers can independently listen on port `443`.

Large systems may use:

- many IP addresses,
- load balancers,
- many physical servers,
- virtual machines,
- containers,
- backend services.

---

# 18 — 🔌 Socket — The Missing Link Between Program and Network

A socket is an operating-system networking communication endpoint/interface used by applications.

My mental model is:

```text
Application
    │
    ▼
Socket
    │
    ▼
TCP / UDP
    │
    ▼
Port
    │
    ▼
IP
    │
    ▼
Network Interface
```

A socket is **not the same thing as a port**.

```text
Port
=
Number associated with an endpoint

Socket
=
OS networking communication endpoint/interface
```

An application can open multiple sockets.

For example:

```text
Chrome
  │
  ├── Socket → Local Port 53127 → Server:443
  │
  ├── Socket → Local Port 53128 → Server:443
  │
  └── Socket → Local Port 53129 → Another Server:443
```

---

# 19 — 👂 Listening Socket vs Established Socket

## Listening

A server may have a socket waiting for new connections.

```text
SSH Server
    │
    ▼
TCP :22
    │
    ▼
LISTENING
```

Meaning:

> **I am waiting for clients to connect.**

---

## Established

After a client connects:

```text
Client:54000
      │
      ▼
Server:22

ESTABLISHED
```

Meaning:

> **There is currently an active TCP connection between these endpoints.**

One listening socket can accept many different client connections.

---

# 20 — 🏠 NAT — Network Address Translation

Private IP addresses can be reused.

Two different homes may both have:

```text
192.168.1.10
```

without conflict.

Why?

Because those addresses only need to be unique inside their respective private networks.

When traffic reaches the Internet, NAT can translate the private addressing to public-facing addressing.

```text
Laptop
192.168.1.10
     │
     ▼
Router
Public IP
     │
     ▼
Internet
```

---

# 21 — 🔄 PAT — Port Address Translation

PAT helped me understand how multiple internal devices can share one public IPv4 address.

Example:

```text
LAPTOP
192.168.1.10:51000
        │
        ▼
        │
        │     ROUTER / PAT
        │
        ▼
Public-IP:61001
        │
        ▼
Internet
```

Another device:

```text
PHONE
192.168.1.20:51000
        │
        ▼
Public-IP:61002
```

The router maintains mappings such as:

```text
192.168.1.10:51000
        ↕
Public-IP:61001


192.168.1.20:51000
        ↕
Public-IP:61002
```

If traffic returns to:

```text
Public-IP:61002
```

the router knows which internal communication it belongs to.

This made ports feel much more important than simply memorizing:

```text
443 = HTTPS
22  = SSH
```

---

# 22 — 🧪 Practical Lab — Seeing It on My Own Laptop

After learning the theory, I wanted to verify whether my actual Windows machine showed the same behavior.

I used:

```cmd
netstat -na
```

This showed:

```text
Proto
Local Address
Foreign Address
State
```

Then I used:

```cmd
netstat -ano
```

The additional:

```text
-o
```

showed the:

> **PID — Process ID**

---

## Example of How I Now Read Netstat

A sanitized example:

```text
TCP
192.168.x.x:49483
Remote-IP:443
ESTABLISHED
```

I can now mentally translate this as:

```text
Protocol
    │
    └── TCP

Local Endpoint
    │
    ├── Private IPv4 address
    └── Local port 49483

Remote Endpoint
    │
    ├── Remote IP
    └── Port 443 → HTTPS-related service

State
    │
    └── ESTABLISHED
```

My interpretation:

> **My machine currently has an active TCP connection from a local client port to a remote service using port 443.**

---

# 23 — 🔍 Mapping a Connection Back to the Process

`netstat -ano` gave me the PID.

I then used:

```cmd
tasklist /FI "PID eq <PID>"
```

This allowed me to connect:

```text
NETWORK CONNECTION
        │
        ▼
PID
        │
        ▼
APPLICATION / PROCESS
```

During my own testing I was able to observe processes such as:

```text
chrome.exe
msedge.exe
firefox.exe
svchost.exe
```

owning different network connections.

This was one of the most useful parts of today's practice because it connected the abstract idea:

```text
Application → Socket → TCP/UDP → Port
```

to real processes running on my computer.

---

# 24 — 🌐 IPv4 and IPv6 in Netstat

My machine showed both IPv4 and IPv6 connections.

IPv4 looked similar to:

```text
192.168.x.x:49483
```

IPv6 appeared inside square brackets:

```text
[IPv6-address]:47700
```

But the mental model remains the same:

```text
IP Address
    +
Port
    +
Protocol
    +
Remote Endpoint
```

The address format changed.

The networking concept did not.

---

# 25 — 👂 What `0.0.0.0` and `[::]` Taught Me

I saw entries similar to:

```text
0.0.0.0:445
LISTENING
```

In this context:

```text
0.0.0.0
```

roughly means the service is bound broadly across applicable IPv4 interfaces rather than one specific local IPv4 address.

For IPv6 I saw:

```text
[::]:445
```

which represents the equivalent broad IPv6 binding concept.

This is very different from an active connection such as:

```text
192.168.x.x:53127 → Remote-IP:443
```

---

# 26 — 🔄 TCP States I Observed

The main states I currently want to recognize are:

```text
LISTENING
ESTABLISHED
TIME_WAIT
CLOSE_WAIT
```

## LISTENING

```text
"Waiting for an incoming TCP connection."
```

## ESTABLISHED

```text
"TCP communication is currently active."
```

## TIME_WAIT

```text
"The connection has finished,
but TCP temporarily keeps state
before completely forgetting it."
```

This helps prevent delayed information from an old connection from interfering with a later connection.

## CLOSE_WAIT

```text
"The remote side has closed its side,
but the local application still needs
to finish closing the socket."
```

Many persistent `CLOSE_WAIT` connections may indicate an application is not closing sockets correctly.

---

# 27 — 🌀 UDP Looked Different in Netstat

One practical difference became obvious immediately.

TCP showed states such as:

```text
LISTENING
ESTABLISHED
TIME_WAIT
```

UDP entries did not show the same TCP connection states.

That fits directly with what I learned:

```text
TCP
Connection-oriented
Maintains TCP connection state

UDP
Connectionless
Does not use the TCP state machine
```

---

# 28 — ⚡ UDP Port 443 Was an Important Observation

I originally associated:

```text
443
```

only with:

```text
HTTPS over TCP
```

But while looking at my own browser connections, I also saw browsers communicating using:

```text
UDP → Remote Port 443
```

This gave me an important correction:

> **HTTPS does not always mean TCP.**

Modern browsers may use:

```text
HTTP/3
   │
   ▼
QUIC
   │
   ▼
UDP
```

I do not need deep QUIC knowledge yet.

The important lesson is:

> **Never infer the Transport protocol from the port number alone.**

I should check both:

```text
Protocol
+
Port
```

---

# 29 — 🧠 The Complete Mental Model I Have Now

Today's concepts finally connect into one picture:

```text
┌──────────────────────────────────────────────┐
│                APPLICATION                   │
│ Chrome / Firefox / SSH / other software      │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│                   SOCKET                     │
│ OS communication endpoint                    │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│              TRANSPORT LAYER                 │
│                                              │
│ TCP / UDP                                    │
│ Ports                                        │
│ Sequence / ACK                               │
│ Flags                                        │
│ Window / Checksum                            │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│               INTERNET LAYER                 │
│                                              │
│ Source IP                                    │
│ Destination IP                               │
│ Routing                                      │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│              NETWORK ACCESS                  │
│                                              │
│ Ethernet / Wi-Fi / Frames / MAC              │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
                    NETWORK
```

---

# 30 — 🔐 Why This Matters for Cybersecurity

Ports are not just numbers I need for an exam.

If a machine shows:

```text
PORT 22
LISTENING
```

I should think:

```text
SSH service may be accepting connections.
```

If I see:

```text
PORT 3389
```

I should recognize:

```text
RDP
Remote Desktop
```

If I see:

```text
PORT 445
```

I should think:

```text
SMB
Windows file-sharing related service
```

This is the foundation for concepts I will encounter later:

```text
Open Ports
       │
       ▼
Listening Services
       │
       ▼
Exposed Services
       │
       ▼
Attack Surface
       │
       ▼
Firewall Rules
       │
       ▼
Service Enumeration
       │
       ▼
Network Monitoring
```

Tools such as:

```text
netstat
ss
Wireshark
Nmap
firewalls
IDS / IPS
```

will make much more sense now because I understand what normal network communication looks like first.

---

# 31 — 🛡️ My Current Cybersecurity Interpretation

If I see:

```text
TCP
192.168.x.x:53127
Remote-IP:443
ESTABLISHED
```

I can now say:

> My machine currently has an established TCP connection from a local client-side port to a remote HTTPS service.

If I add the PID:

```text
PID → chrome.exe
```

I can connect:

```text
Chrome
   │
   ▼
Process
   │
   ▼
Socket
   │
   ▼
Local IP : Local Port
   │
   ▼
TCP
   │
   ▼
Remote IP : 443
```

That is much more useful to me than simply memorizing:

> Port 443 = HTTPS.

---

# 32 — ✅ What I Can Explain Confidently After Day 6

At this point I can explain:

- why the TCP/IP model has layers,
- how TCP/IP relates to OSI,
- why applications use TCP or UDP,
- why TCP is connection-oriented,
- why sequence and acknowledgment numbers exist,
- how TCP can detect missing/out-of-order data,
- what the important TCP header fields mean,
- why TCP headers can vary from 20 to 60 bytes,
- what TCP flags such as SYN, ACK, FIN and RST mean,
- why Window Size exists,
- what a checksum is for,
- what a logical network port actually is,
- why ports range from 0 to 65535,
- the three IANA port ranges,
- why clients commonly use temporary ports,
- why servers commonly listen on stable/configured ports,
- why thousands of clients can use the same server port,
- what a TCP 5-tuple represents,
- what a socket is,
- the difference between listening and established sockets,
- why private addresses can repeat,
- what NAT and PAT do,
- how PAT uses port mappings,
- how to read basic `netstat` output,
- how to identify a network connection's PID,
- how to map the PID to a real process,
- the difference between LISTENING, ESTABLISHED, TIME_WAIT and CLOSE_WAIT,
- why UDP looks different from TCP in `netstat`,
- and why port 443 does not automatically mean TCP.

---

# 33 — 🧪 Commands I Practiced

```cmd
netstat -na
```

Displays numerical addresses, ports, connections and listening endpoints.

```cmd
netstat -ano
```

Adds the owning:

```text
PID
Process ID
```

To identify the process:

```cmd
tasklist /FI "PID eq <PID>"
```

For Windows services hosted inside a process:

```cmd
tasklist /svc /FI "PID eq <PID>"
```

---

# 34 — 📌 Terminology I Want to Retain

| Term | My Current Understanding |
|---|---|
| TCP | Connection-oriented Transport protocol |
| UDP | Connectionless Transport protocol |
| Segment | TCP transport unit containing header + payload |
| Sequence Number | Position of bytes in TCP's byte stream |
| ACK Number | Next byte expected by receiver |
| Port | Logical Transport-layer identifier |
| Ephemeral Port | Temporary client-side port |
| Socket | OS networking communication endpoint |
| Listening Socket | Waiting for incoming connections |
| Established Socket | Active TCP communication endpoint |
| 5-Tuple | Source IP + source port + destination IP + destination port + protocol |
| NAT | Network Address Translation |
| PAT | Port Address Translation |
| PID | Process ID |
| LISTENING | Waiting for connections |
| ESTABLISHED | Active TCP connection |
| TIME_WAIT | Closed connection waiting before final cleanup |
| CLOSE_WAIT | Remote side closed; local application still needs to close |
| Checksum | Corruption-detection mechanism |
| Window Size | Receiver's advertised capacity for flow control |
| Data Offset | TCP header length / location where payload begins |

---

# 35 — 🚀 What I Want to Build on Next

Today was mainly about understanding **normal network behavior**.

I now want to build on this foundation progressively.

My next steps are to become faster at recognizing:

```text
Common Ports
      │
      ▼
Connections
      │
      ▼
Processes
      │
      ▼
Expected vs Unexpected Network Behavior
```

Then I can move deeper into tools such as:

```text
Wireshark
Nmap
Firewalls
IDS / IPS
```

with a better question in mind:

> **What is this machine actually communicating with, through which protocol and port, which process owns the connection, and is that behavior expected?**

That is the networking mindset I want to continue developing.

---

# 🧭 Day 6 Final Mental Model

```text
                  APPLICATION
                       │
                       ▼
                     SOCKET
                       │
                       ▼
                 TCP / UDP
                       │
                ┌──────┴──────┐
                │             │
              PORT         TCP STATE
                │
                ▼
            IP ADDRESS
                │
                ▼
          NETWORK TRAFFIC
                │
                ▼
              ROUTER
             NAT / PAT
                │
                ▼
            INTERNET
                │
                ▼
          REMOTE SERVICE
```

### The sentence I want to remember

> **An IP gets traffic toward the machine, a port helps identify the communication endpoint, a socket connects the process to the networking stack, and TCP keeps track of the connection.**

---

**Networking Day 6 — TCP/IP, TCP, Ports and Real Connections ✅**
