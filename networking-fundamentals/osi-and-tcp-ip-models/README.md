# 🌐 NETWORKING — DAY 05

## Understanding the OSI Model — How Data Travels Through Seven Networking Layers

**Learning Track:** Networking Fundamentals
**Focus:** OSI Model • Seven Layers • Encapsulation • Decapsulation • PDU • HTTP • HTTPS • FTP • DNS • SMTP • SSH • Encoding • Encryption • Compression • TCP • UDP • Port Numbers • IP Addressing • Routing • MAC Addressing • Ethernet • Frames • Packets • Bits • Network Troubleshooting

---

> [!IMPORTANT]
>
> ### 💡 The main idea I am taking from Networking Day 5
>
> **Network communication looks extremely complex when viewed as one complete process. The OSI model makes that complexity easier to understand by separating communication into seven layers, where each layer has a different responsibility.**
>
> The biggest change in my understanding today was that concepts I had previously studied separately — protocols, ports, IP addresses, MAC addresses, routers and switches — now fit into one complete communication process.

My current mental model is:

```text
USER / APPLICATION
        │
        ▼
┌──────────────────────────────┐
│ 7 — Application              │
│ Network services/protocols   │
├──────────────────────────────┤
│ 6 — Presentation             │
│ Representation / protection  │
├──────────────────────────────┤
│ 5 — Session                  │
│ Communication management     │
├──────────────────────────────┤
│ 4 — Transport                │
│ TCP / UDP / Ports            │
├──────────────────────────────┤
│ 3 — Network                  │
│ IP Addressing / Routing      │
├──────────────────────────────┤
│ 2 — Data Link                │
│ Frames / MAC / Local Link    │
├──────────────────────────────┤
│ 1 — Physical                 │
│ Bits / Signals / Media       │
└──────────────────────────────┘
        │
        ▼
     NETWORK
```

On the receiving side, the process happens in the opposite direction.

---

# 01 — 🧱 Why Does the OSI Model Exist?

**OSI** stands for:

> **Open Systems Interconnection**

The OSI model was standardized by:

> **ISO — International Organization for Standardization**

The basic problem it helps solve is complexity.

Modern communication can involve:

```text
Applications
Operating Systems
Network Interfaces
Switches
Routers
Cables
Wi-Fi
Protocols
Servers
Different Vendors
Different Technologies
```

Trying to understand everything as one giant process would be difficult.

Instead, the OSI model separates networking responsibilities into seven logical layers.

```text
Complex Network Communication
              ↓
       Divide Responsibilities
              ↓
          Seven Layers
              ↓
Understand / Design / Troubleshoot
Communication More Systematically
```

Another important purpose is standardization.

Networking equipment and software may be created by different companies, but common networking standards allow those systems to communicate with each other.

My simple understanding is:

> **The OSI model gives networking engineers a common framework for describing what part of communication is responsible for what.**

It is important for me not to imagine the OSI model as seven separate physical programs sitting inside my computer.

It is mainly a:

> **Reference Model**

It helps describe networking responsibilities.

---

# 02 — 🪜 The Seven OSI Layers

The seven layers from highest to lowest are:

```text
7 — Application
6 — Presentation
5 — Session
4 — Transport
3 — Network
2 — Data Link
1 — Physical
```

A simple first-level understanding is:

| Layer            | Main Responsibility                                       |
| ---------------- | --------------------------------------------------------- |
| 7 — Application  | Network services used by applications                     |
| 6 — Presentation | Data representation, encoding, encryption and compression |
| 5 — Session      | Managing communication sessions                           |
| 4 — Transport    | End-to-end transport using TCP/UDP and ports              |
| 3 — Network      | Logical addressing and routing using IP                   |
| 2 — Data Link    | Local-link communication using frames and MAC addresses   |
| 1 — Physical     | Sending bits through electrical, optical or radio signals |

The layers started making more sense when I connected them to questions.

```text
Application
→ What network service is being used?

Presentation
→ How should the information be represented or protected?

Session
→ How is the communication maintained?

Transport
→ How should data be delivered between endpoints?

Network
→ Which network destination should it reach?

Data Link
→ Where should this frame go on the current local link?

Physical
→ How are the actual bits transmitted?
```

---

# 03 — 📦 Following One Piece of Data Through the OSI Model

The best way for me to understand OSI was to stop memorizing definitions and follow actual data.

Suppose I create some data:

```text
1234
```

or imagine that I want to send information describing four different pens.

At the beginning, it is simply:

```text
DATA
```

That data begins at the upper layers.

As it moves downward through the networking stack, different networking information is added.

The data gradually becomes:

```text
Data
 ↓
Segment
 ↓
Packet
 ↓
Frame
 ↓
Bits
```

Then those bits are transmitted.

At the destination, the receiving system works in reverse:

```text
Bits
 ↓
Frame
 ↓
Packet
 ↓
Segment
 ↓
Data
```

This finally allows the receiving application to interpret the original information.

This entire journey gave me a much stronger understanding of the OSI model than simply remembering seven names.

---

# 04 — 📥 Encapsulation and Decapsulation

Two important terms that describe this process are:

> **Encapsulation**

and:

> **Decapsulation**

## Encapsulation

Encapsulation happens as information moves downward through the networking stack.

Each relevant layer adds information needed for its own responsibility.

A simplified example:

```text
Original Data

1234
```

Transport Layer:

```text
[TCP Header | 1234]
```

This becomes a:

```text
SEGMENT
```

Network Layer:

```text
[IP Header | TCP Header | 1234]
```

This becomes a:

```text
PACKET
```

Data Link Layer:

```text
[Ethernet Header | IP Header | TCP Header | 1234 | Trailer]
```

This becomes a:

```text
FRAME
```

Physical Layer:

```text
0101101010010110...
```

These are:

```text
BITS
```

So my current understanding is:

> **Encapsulation is not simply data moving downward. It is the process of wrapping the data with networking information needed by different layers.**

---

## Decapsulation

The receiving system performs the reverse process.

```text
BITS
 ↓
Data Link processes the Frame
 ↓
Network processes the Packet
 ↓
Transport processes the Segment
 ↓
Upper layers process the Data
 ↓
Application receives usable information
```

Therefore:

```text
ENCAPSULATION
     ↓
Wrapping / adding information
while moving downward


DECAPSULATION
     ↓
Processing / removing that information
while moving upward
```

---

# 05 — 📦 What Is a PDU?

Another new term I wanted to understand was:

> **PDU — Protocol Data Unit**

A PDU is the name used for the information being handled at a particular networking layer.

The PDU names are:

| OSI Layer    | PDU                |
| ------------ | ------------------ |
| Application  | Data               |
| Presentation | Data               |
| Session      | Data               |
| Transport    | Segment / Datagram |
| Network      | Packet             |
| Data Link    | Frame              |
| Physical     | Bits               |

My quick memory structure is:

```text
Layer 7 → DATA
Layer 6 → DATA
Layer 5 → DATA

Layer 4 → SEGMENT / DATAGRAM

Layer 3 → PACKET

Layer 2 → FRAME

Layer 1 → BITS
```

One terminology correction I made is:

```text
Segmentation = Process

Segment = PDU
```

For TCP, the Layer 4 PDU is commonly called a:

```text
Segment
```

For UDP, it is commonly called a:

```text
Datagram
```

---

# 06 — 🖥️ Layer 7: Application Layer

The Application Layer is the layer closest to the software used by the user.

Initially, it is easy to think:

```text
Chrome = Application Layer
Gmail = Application Layer
```

A more accurate understanding is:

> **The Application Layer represents networking services and protocols that applications use to communicate.**

For example:

```text
Browser
   │
   ↓
HTTP / HTTPS
   │
   ↓
Network Communication
```

Some important protocols I came across are:

| Protocol | Full Form                          | Basic Purpose                     |
| -------- | ---------------------------------- | --------------------------------- |
| HTTP     | Hypertext Transfer Protocol        | Web communication                 |
| HTTPS    | Hypertext Transfer Protocol Secure | Protected web communication       |
| FTP      | File Transfer Protocol             | File transfer                     |
| DNS      | Domain Name System                 | Name-to-IP resolution             |
| SMTP     | Simple Mail Transfer Protocol      | Sending email                     |
| SSH      | Secure Shell                       | Secure remote command-line access |

At this stage, I do not need to know the internal details of every protocol.

My goal is to recognize:

```text
Protocol Name
      ↓
What Networking Problem Does It Solve?
```

---

# 07 — 🌐 Understanding the Application Protocols

## HTTP

**HTTP — Hypertext Transfer Protocol**

HTTP is used for web communication.

Conceptually:

```text
Browser
   │
   │ Request
   ▼
Web Server
   │
   │ Response
   ▼
Browser
```

For example, the browser may request a webpage and the web server sends the required information back.

---

## HTTPS

**HTTPS — Hypertext Transfer Protocol Secure**

HTTPS protects web communication using cryptographic security, normally through TLS.

My simple model is:

```text
HTTP Communication
        +
TLS Protection
        ↓
HTTPS
```

---

## FTP

**FTP — File Transfer Protocol**

FTP is designed for transferring files between systems.

Example:

```text
My Computer
     │
     │ Upload report.txt
     ▼
FTP Server
```

or:

```text
FTP Server
     │
     │ Download file
     ▼
My Computer
```

Traditional FTP itself does not provide modern encrypted protection, so secure alternatives are commonly used when security is required.

For my current level:

```text
FTP
 ↓
File Transfer
```

is the main idea I need to remember.

---

## DNS

**DNS — Domain Name System**

Humans prefer names such as:

```text
google.com
```

Computers need network addressing.

DNS helps resolve:

```text
google.com
     ↓
IP Address
```

This becomes extremely useful during troubleshooting.

If:

```text
IP Address Works
```

but:

```text
Domain Name Does Not Work
```

DNS becomes an important suspect.

---

## SMTP

**SMTP — Simple Mail Transfer Protocol**

SMTP is primarily associated with:

```text
Sending Email
```

Simplified:

```text
My Email Client
       ↓
Mail Server
       ↓
Recipient's Mail Server
```

---

## SSH

**SSH — Secure Shell**

SSH allows secure remote access to another system's command line.

Conceptually:

```text
My Laptop
    │
    │ SSH
    ▼
Remote Linux Server
```

A command may eventually look like:

```bash
ssh user@192.168.1.20
```

This protocol is especially important for:

```text
Linux Administration
Cloud Systems
Cybersecurity
Servers
DevOps
```

---

# 08 — 🎨 Layer 6: Presentation Layer

The Presentation Layer helps deal with how information is represented.

Three responsibilities commonly associated with this layer are:

```text
Encoding / Translation

Encryption / Decryption

Compression / Decompression
```

These initially sounded similar to me because all three can change how data looks.

But they solve completely different problems.

---

## Encoding

Encoding changes information into an agreed representation.

For example:

```text
A
```

can be represented using ASCII as:

```text
65
```

which can be represented in binary as:

```text
01000001
```

**ASCII** stands for:

> **American Standard Code for Information Interchange**

Modern systems commonly use Unicode encodings such as UTF-8 because they can represent far more languages and symbols.

The important idea is:

```text
Encoding
   ↓
Representation / Compatibility
```

Encoding is not designed to hide information.

---

## Encryption

Encryption protects information from being easily understood by unauthorized parties.

Conceptually:

```text
Readable Data
     ↓
Encryption
     ↓
Unreadable Ciphertext
     ↓
Decryption
     ↓
Readable Data
```

The goal is mainly:

> **Confidentiality**

---

## SSL and TLS

I also came across:

```text
SSL
TLS
```

**SSL** stands for:

> **Secure Sockets Layer**

**TLS** stands for:

> **Transport Layer Security**

TLS is the modern successor to SSL.

TLS is used to provide cryptographic protection for communication such as HTTPS.

A simple memory connection is:

```text
HTTP
 +
TLS
 ↓
HTTPS
```

In real modern networking, protocols do not always fit perfectly into one OSI layer, so I currently treat TLS at the OSI level as a useful conceptual example of data protection rather than forcing it into one physical "Presentation Layer program."

---

## Compression

Compression reduces how much space information requires.

Conceptually:

```text
Large Data
    ↓
Compression
    ↓
Smaller Representation
    ↓
Transmission / Storage
```

The receiving side can then decompress the information.

Examples I came across include:

```text
GZIP
JPEG
Compressed Audio / Video
```

There are two broad ideas I want to remember.

### Lossless Compression

The original information can be reconstructed exactly.

Examples include formats/methods such as:

```text
GZIP
ZIP
PNG
```

### Lossy Compression

Some information may intentionally be discarded to achieve greater size reduction.

Examples include:

```text
JPEG
MP3
Many Video Codecs
```

Therefore:

```text
Encoding
→ Representation

Encryption
→ Confidentiality

Compression
→ Reduce Size
```

These are not interchangeable terms.

---

# 09 — 🤝 Layer 5: Session Layer

The Session Layer represents communication-session management.

My current understanding is:

```text
Establish
   ↓
Maintain
   ↓
Terminate
```

For example:

```text
System A
   │
   │ Establish Communication
   ▼
System B

Communication Continues

System A
   │
   │ Session Ends
   ▼
System B
```

The useful idea for me is:

> **Some mechanism has to manage the lifecycle of an ongoing communication session.**

Modern Internet protocols do not always map cleanly into separate OSI Session and Presentation layers.

Applications and protocols may perform these responsibilities themselves.

So I use Layer 5 mainly to understand the responsibility rather than searching for a physical "Session Layer device."

---

# 10 — 🚚 Layer 4: Transport Layer

The Transport Layer introduced two extremely important protocols:

```text
TCP
UDP
```

It is also where:

```text
Port Numbers
```

become important.

---

## TCP — Transmission Control Protocol

TCP stands for:

> **Transmission Control Protocol**

TCP provides mechanisms for reliable communication.

Important concepts include:

```text
Sequencing
Acknowledgements
Retransmission
Error Detection
Flow Control
```

Suppose data logically belongs in this order:

```text
1
2
3
4
```

Networking does not mean every piece must always arrive exactly as expected.

TCP provides mechanisms that allow the receiver to reconstruct the communication correctly.

For example:

```text
Received:

1
3
4
```

The missing information can be detected through TCP's reliability mechanisms and retransmission can occur.

TCP also maintains ordering information.

This is why TCP is described as:

> **Reliable**

---

## TCP Reliable Does Not Mean TCP Secure

One assumption I corrected was:

```text
TCP = Secure
UDP = Not Secure
```

That is incorrect.

TCP provides reliability.

It does not automatically provide encryption.

Therefore:

```text
Reliability ≠ Security
```

A TCP connection can carry completely unencrypted data.

Encryption must be provided separately by suitable protocols or security mechanisms.

---

## UDP — User Datagram Protocol

UDP stands for:

> **User Datagram Protocol**

UDP provides a much simpler transport service.

It does not provide TCP's built-in guarantees for:

```text
Delivery
Ordering
Retransmission
```

This means UDP has less protocol overhead.

It can therefore be useful for applications where low delay may be more important than recovering every lost piece of information.

Common examples can include:

```text
DNS
Online Gaming
Voice Communication
Video / Streaming Technologies
```

depending on the particular application and protocol design.

Instead of remembering:

```text
TCP = Slow
UDP = Fast
```

I prefer:

```text
TCP
→ More reliability mechanisms
→ More protocol overhead

UDP
→ Fewer built-in reliability mechanisms
→ Lower transport overhead
```

---

# 11 — 🚪 Why Port Numbers Exist

One computer can run many network applications simultaneously.

For example:

```text
Laptop
│
├── Browser
├── SSH Client
├── Email
├── Game
└── Other Applications
```

An IP address helps identify the host/network location.

But the operating system still needs to know:

> **Which communication endpoint should receive this data?**

That is where:

> **Port Numbers**

become important.

My simple mental model is:

```text
IP Address
    ↓
Which Host?

Port Number
    ↓
Which Service / Communication Endpoint?
```

Some well-known examples are:

```text
HTTP  → TCP Port 80

HTTPS → TCP Port 443

SSH   → TCP Port 22
```

These service ports do not mean every application always uses one permanently fixed port on both sides.

Client applications often use temporary:

> **Ephemeral Ports**

For example:

```text
My Laptop
192.168.1.20:53021
        │
        ▼
Web Server
203.x.x.x:443
```

Here:

```text
443
```

identifies the HTTPS service at the server.

The client-side port may be temporary.

---

# 12 — 🛣️ Layer 3: Network Layer

The Network Layer is where I connect two major concepts:

```text
IP Addressing
Routing
```

The major protocol family associated with this layer is:

> **IP — Internet Protocol**

The PDU at this layer is:

> **Packet**

A router is strongly associated with Layer 3.

My simplified model is:

```text
Source IP
     ↓
Packet
     ↓
Routers
     ↓
Destination IP
```

Routers examine network-layer information and decide where packets should go next.

---

## Does the Network Layer Assign IP Addresses?

One assumption I corrected is:

> "The Network Layer assigns IP addresses."

A better statement is:

> **Layer 3 uses logical IP addressing for communication and routing.**

Actual IP configuration may come from mechanisms such as:

```text
DHCP
Static Configuration
ISP / Network Configuration
```

I will explore those mechanisms separately.

For OSI, the important connection is:

```text
Layer 3
   ↓
IP Addressing + Routing
```

---

# 13 — 🔗 Layer 2: Data Link Layer

The Data Link Layer deals with communication across the current network link.

Important concepts associated with Layer 2 are:

```text
Frames
MAC Addresses
Ethernet
Switches
```

The PDU is:

> **Frame**

A switch commonly examines Layer 2 information to forward frames within a local network.

---

## MAC Address

**MAC** stands for:

> **Media Access Control**

A MAC address is associated with a network interface.

For example:

```text
Laptop
│
├── Wi-Fi Interface
│      ↓
│   MAC Address
│
└── Ethernet Interface
       ↓
    MAC Address
```

The distinction that became important to me is:

```text
IP Address
   ↓
Logical addressing across networks

MAC Address
   ↓
Communication on the current local link
```

MAC addressing should not be thought of as normal end-to-end Internet addressing.

---

## IP vs MAC During Routing

Suppose communication travels:

```text
Laptop
   ↓
Home Router
   ↓
ISP Router
   ↓
Other Routers
   ↓
Destination Server
```

The destination IP helps identify the final network destination.

But Layer 2 framing is recreated as communication moves across different network links.

Simplified:

```text
LOCAL LINK 1

Laptop MAC
     ↓
Router MAC
```

Then another link may use different Layer 2 addresses.

```text
LOCAL LINK 2

Router Interface
      ↓
Next-Hop Interface
```

This helped me separate two ideas:

```text
IP
→ End-to-end logical network addressing

MAC
→ Current-link delivery
```

---

## Ethernet

Ethernet is one major Layer 2 technology used in wired networks.

A simplified Ethernet frame contains information such as:

```text
Destination MAC
Source MAC
Payload
Error-Detection Information
```

Layer 2 can also detect corruption of individual frames using mechanisms such as:

> **FCS — Frame Check Sequence**

which commonly uses:

> **CRC — Cyclic Redundancy Check**

For my current level, I only need to remember:

```text
Layer 2
→ Frames
→ MAC Addresses
→ Local-Link Communication
→ Error Detection
```

---

# 14 — ⚡ Layer 1: Physical Layer

The Physical Layer is responsible for transmitting raw bits.

The PDU is:

> **Bits**

The bits may be carried using different physical mechanisms.

Examples include:

```text
Copper Ethernet
      ↓
Electrical Signals


Fiber-Optic Cable
      ↓
Light


Wi-Fi
      ↓
Radio Waves
```

So information that began as:

```text
1234
```

can eventually be represented and transmitted as physical signals carrying:

```text
010101101001...
```

Devices/components commonly associated with Layer 1 include:

```text
Cables
Connectors
Repeaters
Hubs
Physical Signaling Components
```

---

## NIC

Another term I came across is:

> **NIC — Network Interface Card**

or more generally:

> **Network Interface Controller**

A NIC allows a device to connect to a network.

Examples include:

```text
Wi-Fi Adapter

Ethernet Adapter
```

A NIC interacts with responsibilities around both:

```text
Layer 1
and
Layer 2
```

because it deals with physical transmission as well as link-layer communication.

---

# 15 — 🌍 Tracing Communication from My Laptop to a Website

I wanted to combine all seven layers into one practical example.

Suppose I open a website using HTTPS.

At a simplified level:

```text
I request a website
       │
       ▼
APPLICATION
HTTP / HTTPS communication
       │
       ▼
PRESENTATION-RELATED FUNCTIONS
Data representation / TLS protection
       │
       ▼
SESSION-RELATED FUNCTIONS
Communication/session management
       │
       ▼
TRANSPORT
TCP
Source Port + Destination Port
       │
       ▼
NETWORK
Source IP + Destination IP
       │
       ▼
DATA LINK
Local Source MAC + Next-Hop MAC
Frame
       │
       ▼
PHYSICAL
Bits transmitted as signals
```

The traffic may then cross several routers.

Conceptually:

```text
My Laptop
    ↓
Home Network
    ↓
Default Gateway / Router
    ↓
ISP
    ↓
Internet Routers
    ↓
Destination Network
    ↓
Server
```

At the destination, decapsulation happens.

```text
Bits
 ↓
Frame processed
 ↓
Packet processed
 ↓
TCP segment processed
 ↓
Upper-layer data processed
 ↓
Application receives request
```

The response then travels back through another communication process.

This example helped me understand that networking is not:

```text
Application → Internet
```

There are multiple responsibilities working together underneath what looks like one simple user action.

---

# 16 — 🧪 The FTP Corruption Question

One scenario that made the Transport Layer easier to understand was:

> **A file is being transferred using FTP and part of the transmission is lost or corrupted. Which OSI layer is responsible for reliable recovery?**

FTP normally runs over:

```text
TCP
```

TCP belongs to:

> **Layer 4 — Transport**

Therefore, for this type of OSI troubleshooting question, the expected answer is:

```text
Transport Layer
      ↓
TCP
      ↓
Reliable Delivery
      ↓
Retransmission if required
```

Initially, it may also seem that the Data Link Layer should be involved because Layer 2 has frame error detection.

That idea is not completely unrelated.

Layer 2 can detect errors affecting a frame on an individual network link.

However:

```text
Layer 2
→ Link-level frame error detection

TCP
→ End-to-end reliable delivery
```

For an FTP transfer requiring retransmission and reliable recovery, the important answer is:

> **Transport Layer — TCP**

This example helped me understand why different layers can detect different kinds of problems without performing the same job.

---

# 17 — 🛠️ Using OSI for Network Troubleshooting

One of the most practical reasons I want to understand OSI is troubleshooting.

Instead of seeing:

```text
Internet Not Working
```

as one giant problem, I can investigate communication layer by layer.

A common bottom-up approach is:

```text
Layer 1
Physical
   ↓
Layer 2
Data Link
   ↓
Layer 3
Network
   ↓
Layer 4
Transport
   ↓
Upper Layers
Application / Protocol Behaviour
```

This helps narrow down possibilities before randomly changing settings.

---

## Example 1 — Wi-Fi Is Connected but Gateway Cannot Be Reached

Suppose:

```text
Wi-Fi
Connected

IP Address
192.168.1.20

Default Gateway
192.168.1.1
```

But:

```bash
ping 192.168.1.1
```

fails.

Seeing:

```text
Wi-Fi Connected
```

does not mean every network layer is automatically working.

I would investigate:

```text
Layer 1
→ Signal / Physical Interface

Layer 2
→ Wi-Fi Association
→ Local-Link Communication
→ MAC / ARP-related communication

Layer 3
→ IP Address
→ Subnet Mask
→ Gateway Configuration
```

This prevents me from immediately blaming an application such as the browser.

---

## Example 2 — IP Works but Domain Name Does Not

Suppose:

```bash
ping 8.8.8.8
```

works.

But communication using:

```text
google.com
```

fails because the name cannot be resolved.

The difference is important.

```text
8.8.8.8
→ Already an IP address

google.com
→ Requires name resolution
```

That points me toward:

> **DNS**

DNS is mainly considered an:

> **Application Layer protocol**

So:

```text
IP Communication Works
        +
Domain Resolution Fails
        ↓
Investigate DNS
```

This is much more precise than saying:

```text
Internet Is Broken
```

---

## Example 3 — Streaming Is Buffering

If a streaming application starts buffering, the OSI model gives me a structured troubleshooting path.

```text
Layer 1
→ Weak Wi-Fi?
→ Cable/interface problem?

Layer 2
→ Local-link issue?
→ Wireless contention?

Layer 3
→ Routing problem?
→ Gateway / ISP path issue?

Layer 4
→ Transport connectivity problem?
→ Ports or firewall behaviour?

Upper Layers
→ DNS?
→ Application/server/service problem?
```

The OSI model does not automatically tell me the answer.

Instead:

> **It gives me a disciplined way to narrow down where the problem may exist.**

---

# 18 — 🧠 Devices and Layers: Useful but Not Absolute

A beginner OSI table often shows:

```text
Layer 4 → Firewall

Layer 3 → Router

Layer 2 → Switch

Layer 1 → Hub
```

This is useful as an introduction, but I learned not to interpret it as:

```text
Router can ONLY work at Layer 3

Firewall can ONLY work at Layer 4

Switch can ONLY work at Layer 2
```

Modern networking devices can perform functions across multiple layers.

For example:

```text
Modern Firewall
→ Layer 3 information
→ Layer 4 ports/protocols
→ Sometimes Layer 7 application information
```

and some switches can also perform:

```text
Layer 3 Routing
```

So I use the device mapping as:

> **The layer the device is traditionally or primarily associated with for that function.**

---

# 19 — 📝 Quick Revision Map

This is the compact version I want to be able to reconstruct without notes.

```text
┌─────────────────────────────────────────────┐
│ Layer 7 — APPLICATION                       │
│ HTTP / HTTPS / FTP / DNS / SMTP / SSH      │
│ PDU: Data                                   │
├─────────────────────────────────────────────┤
│ Layer 6 — PRESENTATION                      │
│ Encoding / Encryption / Compression         │
│ PDU: Data                                   │
├─────────────────────────────────────────────┤
│ Layer 5 — SESSION                           │
│ Establish / Maintain / Terminate            │
│ PDU: Data                                   │
├─────────────────────────────────────────────┤
│ Layer 4 — TRANSPORT                         │
│ TCP / UDP / Port Numbers                    │
│ PDU: Segment / Datagram                     │
├─────────────────────────────────────────────┤
│ Layer 3 — NETWORK                           │
│ IP Addressing / Routing                     │
│ Device: Router                              │
│ PDU: Packet                                 │
├─────────────────────────────────────────────┤
│ Layer 2 — DATA LINK                         │
│ MAC / Ethernet / Frames                     │
│ Device: Switch                              │
│ PDU: Frame                                  │
├─────────────────────────────────────────────┤
│ Layer 1 — PHYSICAL                          │
│ Electrical / Light / Radio Signals          │
│ Cables / Hubs / Physical Interfaces         │
│ PDU: Bits                                   │
└─────────────────────────────────────────────┘
```

My PDU memory pattern is:

```text
DATA
DATA
DATA
SEGMENT
PACKET
FRAME
BITS
```

And the addressing connection I now understand is:

```text
PORT
 ↓
Which service / communication endpoint?


IP
 ↓
Which logical network destination?


MAC
 ↓
Which interface / next hop on the local link?
```

---

# 20 — ⚠️ Important Corrections I Made While Learning

Some of the most useful progress came from correcting assumptions rather than simply adding new terms.

### TCP

```text
Incorrect:
TCP = Secure

Better:
TCP = Reliable transport

Security requires separate protection.
```

---

### MAC Address

```text
Incorrect:
MAC Address = End-to-End Internet Address

Better:
MAC Address = Local-link addressing
associated with network interfaces
```

---

### IP Address

```text
Incorrect:
Network Layer automatically assigns IP addresses

Better:
Layer 3 uses IP addresses for
logical addressing and routing
```

---

### Encoding

```text
Incorrect:
Encoding = Encrypting information

Better:
Encoding = Representing information
according to an agreed format
```

---

### Wi-Fi

```text
Incorrect:
Wi-Fi Connected = Networking is completely working

Better:
Association may exist while other
Layer 2 / Layer 3 problems still remain
```

These corrections were important because networking terminology can sound similar while describing completely different responsibilities.

---

# 21 — 💭 Day 5 Reflection

Before studying the OSI model, I understood several networking concepts individually.

I already had ideas about:

```text
IP Addresses

MAC Addresses

Ports

Routers

Protocols

Local Networks
```

But they were still somewhat separate pieces in my mind.

The OSI model gave those concepts a structure.

Now when I imagine sending data, I can visualize:

```text
Application creates information
           ↓
Upper layers prepare/manage it
           ↓
TCP/UDP handles transport
           ↓
IP handles logical addressing/routing
           ↓
Layer 2 prepares the local-link frame
           ↓
Physical layer transmits bits
```

And when the information reaches its destination:

```text
Bits
 ↓
Frame
 ↓
Packet
 ↓
Segment
 ↓
Data
 ↓
Application
```

This was also the first point where I started seeing the OSI model as a troubleshooting tool rather than something that exists only to memorize seven layer names.

If a communication problem occurs, I can begin asking:

```text
Is the physical connection working?

Can the local link communicate?

Is IP addressing/routing working?

Is the required transport connection working?

Is DNS or another application protocol failing?
```

That is a much more structured way of thinking than simply saying:

```text
"The network is down."
```

The biggest idea I want to carry forward from Day 5 is:

> **Every layer solves a different communication problem, and understanding where each responsibility belongs makes both network communication and network troubleshooting easier to reason about.**

---

# 🔜 What I Want to Learn Next

My next topic is:

> **TCP/IP Model**

Now that I understand the seven-layer OSI reference model, the next question I want to answer is:

```text
If OSI explains networking using seven layers,
how does the TCP/IP model represent
real Internet communication?
```

I also want to understand how:

```text
OSI Model
        ↕
TCP/IP Model
```

map to each other.

My current expectation is that concepts such as:

```text
HTTP
TCP / UDP
IP
Ethernet
```

will appear again, but organized differently.

That will be the next step in connecting the reference model I learned today with the protocol suite used by the Internet.

---

## 📌 Networking Journey

```text
Day 1
Network Addressing Foundations
        ↓
Day 2
IPv4, Binary and Address Classes
        ↓
Day 3
Network ID, Broadcast ID and Subnet Mask
        ↓
Day 4
Special IPs, Private/Public Addressing,
Routing, Gateway and NAT
        ↓
Day 5
OSI Model
        ↓
Next
TCP/IP Model
```

> **My goal with this networking journey is not simply to memorize definitions. I want to understand why each concept exists, connect it with the concepts I already know, test my assumptions, and eventually be able to trace and troubleshoot real network communication logically.**
