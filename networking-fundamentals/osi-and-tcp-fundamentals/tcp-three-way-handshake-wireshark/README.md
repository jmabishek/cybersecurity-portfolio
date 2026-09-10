# 🌐 NETWORKING — DAY 07

## TCP Segments → TCP Header → Three-Way Handshake → Wireshark Packet Analysis

**Learning Track:** Networking Fundamentals  
**Focus:** TCP Segments • TCP Header • Sequence Numbers • Acknowledgments • TCP Flags • Three-Way Handshake • Connection Termination • Wireshark • Packet Capture • Display Filters

---

> [!IMPORTANT]
>
> ## 💡 My Main Realization Today
>
> Until now, I understood TCP mostly as a concept:
>
> ```text
> Client
>   │
>   ├── SYN
>   ├── SYN-ACK
>   └── ACK
>   │
>   ▼
> Connection Established
> ```
>
> Today I was able to connect that theory with an actual packet capture in Wireshark.
>
> I could see that things such as:
>
> ```text
> Source Port
> Destination Port
> Sequence Number
> Acknowledgment Number
> Flags
> Window Size
> Header Length
> Checksum
> TCP Options
> ```
>
> are not just fields in a diagram.
>
> They are actual values carried inside real TCP segments.
>
> My biggest realization was:
>
> > **The TCP three-way handshake is not an abstract process happening somewhere in the background. I can actually capture the SYN, SYN-ACK and ACK packets and inspect the values that create the connection.**

---

# 01 — 🔗 Connecting Day 6 to Day 7

In my previous networking work, I studied:

```text
TCP/IP
   │
   ▼
TCP / UDP
   │
   ▼
TCP Header
   │
   ▼
Ports
   │
   ▼
Sockets
   │
   ▼
Connections
```

I understood the purpose of fields such as:

```text
SEQ
ACK
Flags
Window
Checksum
Data Offset
Options
```

Today I moved from:

```text
"What does this field mean?"
```

to:

```text
"Where can I actually see this field
inside real network traffic?"
```

The answer was:

```text
Wireshark
```

---

# 02 — 📦 What I Now Understand as a TCP Segment

A TCP segment is not simply "the data being sent."

Conceptually:

```text
┌───────────────────────────────────────┐
│              TCP HEADER               │
│                                       │
│ Source Port                           │
│ Destination Port                      │
│ Sequence Number                       │
│ Acknowledgment Number                 │
│ Data Offset / Header Length           │
│ Flags                                 │
│ Window Size                           │
│ Checksum                              │
│ Urgent Pointer                        │
│ Options                               │
│ Padding                               │
├───────────────────────────────────────┤
│                                       │
│          TCP APPLICATION DATA         │
│          if data is present           │
│                                       │
└───────────────────────────────────────┘
```

My important realization is:

```text
TCP Segment
=
TCP Header
+
TCP Data
```

But the data portion does not always have to contain application data.

For example, a TCP SYN used to establish a connection may show:

```text
TCP Segment Len = 0
```

That does **not** mean nothing was transmitted.

The packet still contains networking headers and TCP control information.

For example:

```text
Ethernet Header
       +
IP Header
       +
TCP Header
       +
TCP Options
```

can all exist even when:

```text
TCP application payload = 0 bytes
```

---

# 03 — 🧱 TCP Header Became Real to Me

Before using Wireshark, I viewed the TCP header mainly like this:

```text
Source Port
Destination Port
Sequence
Acknowledgment
Flags
Window
Checksum
Options
```

After capturing traffic, I could expand:

```text
Transmission Control Protocol
```

inside Wireshark and inspect these fields directly.

This changed my understanding from:

```text
TCP Header = textbook diagram
```

to:

```text
TCP Header = real metadata
used by two TCP endpoints
to manage a connection
```

---

# 04 — 🔌 Source and Destination Ports

One of the captures I examined showed communication similar to:

```text
Client Port  →  Server Port

4049         →  443
```

I can now read this as:

```text
4049
│
└── source-side TCP port

443
│
└── HTTPS service port
```

The source port does not simply mean:

> "This is Chrome."

Instead, the port participates in identifying a transport-layer communication endpoint.

A single application may have several TCP connections simultaneously.

Example:

```text
Application
    │
    ├── TCP connection using local port A
    ├── TCP connection using local port B
    └── TCP connection using local port C
```

---

# 05 — 🤝 TCP Three-Way Handshake

TCP normally establishes a connection before normal application data is exchanged.

The process is:

```text
CLIENT                                    SERVER

   │                                        │
   │ SYN                                    │
   │ Seq = X                                │
   ├───────────────────────────────────────►│
   │                                        │
   │                           SYN + ACK    │
   │                           Seq = Y      │
   │                           Ack = X + 1  │
   │◄───────────────────────────────────────┤
   │                                        │
   │ ACK                                    │
   │ Seq = X + 1                            │
   │ Ack = Y + 1                            │
   ├───────────────────────────────────────►│
   │                                        │
   │           TCP ESTABLISHED              │
```

The three steps are:

```text
1. SYN
2. SYN + ACK
3. ACK
```

---

# 06 — 🏳️ SYN Is a Flag, Not a Sequence Number

An important distinction I want to maintain is:

```text
SYN ≠ SEQ
```

`SYN` is a TCP flag.

`SEQ` is the TCP Sequence Number field.

The SYN flag means that the endpoint is participating in TCP connection establishment and sequence-number synchronization.

Example:

```text
Flags: SYN
Sequence Number: X
```

These are two different pieces of information inside the same TCP segment.

---

# 07 — 🔢 Sequence Numbers — My New Realization

Earlier I understood Sequence Numbers as positions inside TCP's byte stream.

For example:

```text
SEQ = 7200
Length = 150 bytes
```

would represent approximately:

```text
7200 ───────────────────────► 7349
```

and the next expected byte could be:

```text
ACK = 7350
```

Today I learned another very important detail.

## Real TCP sequence numbers do not normally begin at zero.

Each side chooses an Initial Sequence Number.

Conceptually:

```text
CLIENT ISN = X
SERVER ISN = Y
```

The client and server choose their sequence spaces independently.

---

# 08 — 🤯 Why Wireshark Showed Seq = 0

This initially looked confusing.

Wireshark showed:

```text
Sequence Number: 0
(relative sequence number)
```

but underneath I could also see:

```text
Sequence Number (raw): 2524728285
```

This made something click.

The actual TCP sequence number was:

```text
2524728285
```

Wireshark displayed it as:

```text
0
```

for easier analysis.

So instead of forcing me to mentally follow numbers such as:

```text
2524728285
2524728286
2524728420
...
```

Wireshark can represent the beginning as:

```text
0
1
...
```

This is called:

```text
Relative Sequence Numbering
```

My mental model is now:

```text
REAL TCP NUMBER

2524728285
      │
      ▼
Wireshark relative representation
      │
      ▼
      0
```

---

# 09 — ➕ Why SYN Causes ACK = SEQ + 1

This was another important realization.

Suppose:

```text
CLIENT

SYN
SEQ = 8000
```

The server responds:

```text
SERVER

SYN + ACK
SEQ = 3000
ACK = 8001
```

Why `8001`?

Because:

> **The SYN itself consumes one position in TCP's sequence-number space.**

Therefore:

```text
8000 + 1
=
8001
```

Similarly, the client's final acknowledgment would be:

```text
ACK = 3001
```

because the server's SYN also consumes one sequence number.

So:

```text
CLIENT                            SERVER

SYN
SEQ 8000
───────────────────────────────►

                     SYN + ACK
                     SEQ 3000
                     ACK 8001
◄───────────────────────────────

ACK
SEQ 8001
ACK 3001
───────────────────────────────►
```

---

# 10 — ✅ What ACK Actually Means

I do not want to think of ACK as:

> "I received packet number X."

TCP sequence numbers track a byte stream.

My current mental model is:

```text
ACK = N
```

means approximately:

> **I have received everything before N that I am acknowledging, and N is the sequence position I expect next.**

During the handshake, ACK also confirms the sequence-space synchronization.

Example:

```text
SYN
SEQ = X

          ↓

SYN + ACK
ACK = X + 1
```

---

# 11 — 🪟 Window Size in a Real Packet

I also saw a TCP window value in Wireshark.

The receive window relates to:

```text
TCP Flow Control
```

My mental model:

```text
RECEIVER
   │
   │ advertises available receive capacity
   ▼
SENDER
```

The receiver is effectively telling the sender:

> **This is how much additional TCP data I currently have room to receive according to my advertised window.**

This protects the receiver from being overwhelmed.

I continue to separate:

```text
FLOW CONTROL
→ manages receiver capacity

CONGESTION CONTROL
→ manages network congestion
```

---

# 12 — 📐 Header Length / Data Offset Became Clearer

In one SYN packet I captured, Wireshark showed:

```text
TCP Header Length = 32 bytes
```

Earlier I learned:

```text
Minimum TCP header
=
20 bytes
```

So why was this one:

```text
32 bytes?
```

Because the TCP header contained:

```text
TCP Options
```

This finally made Data Offset practical.

Data Offset/Header Length tells the receiver:

```text
How long is the TCP header?
        │
        ▼
Where does TCP payload begin?
```

So:

```text
20-byte fixed header
       +
TCP options
       =
larger TCP header
```

---

# 13 — ⚙️ TCP Options I Saw

The SYN packet I examined contained options including:

```text
MSS
Window Scale
SACK Permitted
```

This was useful because I had previously learned that TCP Options extend TCP's capabilities.

Now I saw them being exchanged during actual TCP connection establishment.

---

## MSS

```text
MSS
=
Maximum Segment Size
```

It communicates information about the maximum TCP payload size that an endpoint is prepared to receive in a segment under that negotiation.

Example observed:

```text
MSS = 1440
```

---

## Window Scale

```text
Window Scale
```

allows TCP to represent effective receive windows larger than the original 16-bit window field alone allows.

I do not need to calculate this manually yet.

My mental model:

```text
Window field
     +
Window scaling
     ↓
larger usable receive window
```

---

## SACK Permitted

```text
SACK
=
Selective Acknowledgment
```

SACK allows TCP endpoints to communicate more detailed information about which blocks of data have successfully arrived.

For example:

```text
1000–1999 ✅

2000–2999 ❌

3000–3999 ✅
```

TCP can communicate that later data arrived even though an earlier section is missing.

For now, I mainly want to recognize:

```text
SACK_PERM
```

when I see it in a SYN.

---

# 14 — ✅ Checksum — What It Actually Does

The TCP checksum is used for:

```text
Error Detection
```

Its purpose is to help detect accidental corruption affecting TCP information during transmission.

The important correction for me was:

```text
Checksum is NOT sent
as a separate packet first.
```

Instead:

```text
Sender
   │
   ├── calculates checksum
   │
   ├── stores checksum in TCP header
   │
   ▼
sends TCP segment
```

The receiver then verifies it.

Conceptually:

```text
TCP Header + Data
       │
       ▼
Checksum calculation
       │
       ▼
Checksum stored in header
       │
       ▼
Segment transmitted
       │
       ▼
Receiver verifies
```

The checksum:

```text
detects corruption
```

but does not:

```text
repair corruption
```

If a TCP segment is invalid because of corruption, it can be discarded, and TCP's reliability mechanisms can eventually cause the missing information to be retransmitted.

---

# 15 — 🦈 What Wireshark Is

Wireshark is a:

> **Packet capture and packet analysis tool.**

My computer may already be generating traffic from:

```text
Browser
DNS
Operating-system services
Updates
Applications
Background processes
```

Wireshark lets me capture network traffic passing through a selected interface and inspect it.

Conceptually:

```text
Applications
      │
      ▼
Operating System
      │
      ▼
Wi-Fi / Ethernet
      │
      ▼
Network
```

Wireshark gives me visibility into packets moving through the selected network interface.

---

# 16 — 📡 Choosing the Network Interface

When Wireshark opens, it may show interfaces such as:

```text
Wi-Fi
Ethernet
Bluetooth
Loopback
...
```

An interface represents a networking path/device available to the computer.

Since I was using Wi-Fi, I captured from:

```text
Wi-Fi
```

My basic workflow was:

```text
Open Wireshark
       │
       ▼
Select active Wi-Fi interface
       │
       ▼
Start Capture
```

---

# 17 — 🧪 Generating Traffic Intentionally

Instead of waiting for random traffic, I can intentionally generate a TCP connection.

For example:

```bash
curl http://example.com
```

`curl` is a command-line network client.

Here I am telling it to request:

```text
http://example.com
```

Because normal HTTP uses:

```text
TCP Port 80
```

this gives me predictable traffic to analyze.

Conceptually:

```text
curl
  │
  ▼
Operating System
  │
  ▼
TCP Socket
  │
  ▼
TCP connection
  │
  ▼
Web Server :80
```

The important point is:

> `curl` is not a Wireshark command.

I use `curl` to **generate traffic**, and Wireshark captures that traffic.

---

# 18 — 🔎 What a Wireshark Display Filter Does

Wireshark may capture hundreds or thousands of packets.

A **Display Filter** does not create network traffic.

It tells Wireshark:

> **Only display packets that match this condition.**

For example:

```text
tcp.flags.syn == 1
```

I can read this logically:

```text
tcp
│
└── inspect TCP


tcp.flags
│
└── inspect TCP flags


tcp.flags.syn
│
└── inspect SYN


== 1
│
└── SYN is set
```

Therefore:

```text
tcp.flags.syn == 1
```

means:

> **Show TCP packets where the SYN flag is set.**

---

# 19 — 🔬 Filters I Practiced

## Show packets with SYN set

```text
tcp.flags.syn == 1
```

This may show both:

```text
SYN
```

and:

```text
SYN + ACK
```

because both contain the SYN flag.

---

## Show FIN packets

```text
tcp.flags.fin == 1
```

Meaning:

> Show TCP packets where FIN is set.

---

## Show ACK without SYN

```text
tcp.flags.ack == 1 && tcp.flags.syn == 0
```

Meaning:

```text
ACK = ON
AND
SYN = OFF
```

This can produce many results because ACK is used heavily during normal TCP communication.

---

## Focus on traffic involving particular TCP ports

Example:

```text
tcp.port == 54321 && tcp.port == 80
```

where `54321` would be replaced with the actual client port I observed.

This can help me study communication involving:

```text
Client Port ↔ Server Port
```

---

# 20 — 🖥️ Understanding the Wireshark Screen

The Wireshark interface became easier when I separated it into three areas.

```text
┌──────────────────────────────────────────┐
│              PACKET LIST                 │
│                                          │
│ No. Time Source Destination Protocol     │
├──────────────────────────────────────────┤
│             PACKET DETAILS               │
│                                          │
│ Ethernet                                 │
│ IP                                       │
│ TCP                                      │
├──────────────────────────────────────────┤
│              RAW BYTES                   │
│                                          │
│ 00 01 02 AF ...                          │
└──────────────────────────────────────────┘
```

---

## Packet List

This gives a quick overview of each packet.

Important columns include:

```text
Source
Destination
Protocol
Length
Info
```

---

## Packet Details

When I select a packet and expand:

```text
Transmission Control Protocol
```

I can inspect TCP fields directly.

Example:

```text
Source Port
Destination Port
Sequence Number
Acknowledgment Number
Header Length
Flags
Window Size
Checksum
Options
```

---

## Raw Bytes

The bottom section displays the actual captured bytes.

For my current learning level, I am focusing mainly on:

```text
Packet List
+
Packet Details
```

rather than manually decoding raw hexadecimal bytes.

---

# 21 — 🔍 Reading a SYN Packet

A SYN may look approximately like:

```text
4049 → 443
[SYN]
Seq=0
Win=65535
Len=0
MSS=1440
WS=256
SACK_PERM
```

I can now break this apart.

```text
4049
→ Client/source port

443
→ HTTPS destination port

SYN
→ Requesting TCP connection establishment

Seq=0
→ Wireshark relative sequence number

Win=65535
→ Advertised TCP receive window field

Len=0
→ No TCP application payload in this SYN

MSS=1440
→ Maximum Segment Size option

WS=256
→ Window Scale option

SACK_PERM
→ Selective Acknowledgment supported
```

This is much more useful to me than simply memorizing:

```text
SYN → SYN-ACK → ACK
```

because I can now understand what is inside the packet.

---

# 22 — 👀 What I Verified in a Real Handshake

While analyzing captured TCP traffic, I could identify:

```text
PACKET 1
Client → Server
SYN
```

followed by:

```text
PACKET 2
Server → Client
SYN + ACK
```

and then:

```text
PACKET 3
Client → Server
ACK
```

I also expanded the TCP fields and compared:

```text
Sequence Number
Acknowledgment Number
```

The important pattern I verified was:

```text
Client SYN sequence
        │
        ▼
Server ACK = Client sequence + 1
```

and:

```text
Server SYN sequence
        │
        ▼
Client ACK = Server sequence + 1
```

This was the first time I directly connected the mathematical relationship:

```text
SEQ + 1
```

with real packet values.

---

# 23 — 🛑 FIN and TCP Connection Closing

TCP connection establishment and TCP termination solve different problems.

Connection establishment:

```text
SYN
   ↓
SYN + ACK
   ↓
ACK
```

Connection closing can involve:

```text
FIN
ACK
FIN
ACK
```

Conceptually:

```text
SIDE A                           SIDE B

FIN
──────────────────────────────►

                         ACK
◄──────────────────────────────

                         FIN
◄──────────────────────────────

ACK
──────────────────────────────►
```

`FIN` means roughly:

> **I have finished sending data in this direction.**

I can look for FIN packets using:

```text
tcp.flags.fin == 1
```

---

# 24 — 🚨 FIN vs RST

I currently distinguish:

```text
FIN
=
graceful TCP closing
```

from:

```text
RST
=
TCP connection reset / abrupt termination
```

I do not need advanced reset analysis yet, but I want to recognize the difference when I see the flags.

---

# 25 — 🧠 My Current TCP Mental Model

My current understanding connects together like this:

```text
APPLICATION
Chrome / curl / another program
        │
        ▼
SOCKET
OS-managed networking endpoint
        │
        ▼
TCP
Ports + sequence tracking + ACKs
        │
        ▼
TCP SEGMENT
Header + optional application data
        │
        ▼
IP
Source and destination addressing
        │
        ▼
NETWORK INTERFACE
Wi-Fi / Ethernet
        │
        ▼
NETWORK
```

When TCP starts:

```text
SYN
 ↓
SYN-ACK
 ↓
ACK
```

When data is transferred:

```text
SEQ
ACK
Window
Checksum
```

help TCP manage the communication.

When communication finishes gracefully:

```text
FIN / ACK
```

can be used to close it.

---

# 26 — 🔄 My Understanding Before vs Now

## Before

```text
TCP handshake
=
SYN
SYN-ACK
ACK
```

I knew the pattern.

---

## Now

```text
SYN
│
├── TCP flag
├── Source Port
├── Destination Port
├── Initial Sequence Number
├── Window
├── Checksum
├── TCP Options
└── Header Length
```

Then:

```text
SYN-ACK
│
├── Server's own sequence number
├── ACK of client's SYN
└── ACK = client's sequence + 1
```

Then:

```text
ACK
│
├── acknowledges server SYN
└── ACK = server sequence + 1
```

So my understanding changed from:

```text
memorizing three packet names
```

to:

```text
understanding what those packets
are actually communicating.
```

---

# 27 — 🛡️ Why This Matters in Cybersecurity

Wireshark is useful because network behavior can be investigated instead of guessed.

A successful TCP connection may begin:

```text
SYN
 ↓
SYN-ACK
 ↓
ACK
```

But if I repeatedly observe:

```text
SYN
 ↓
no response

SYN
 ↓
no response

SYN
 ↓
no response
```

that tells me the expected TCP establishment process is not completing.

That alone does **not** prove an attack.

Possible explanations could include:

```text
Service unavailable
Firewall filtering
Routing/connectivity problem
Host unavailable
Other network behavior
```

The important cybersecurity habit is:

```text
Observe
   ↓
Collect evidence
   ↓
Understand protocol behavior
   ↓
Investigate context
   ↓
Then make a conclusion
```

rather than:

```text
Unknown packet
=
Attack
```

---

# 28 — 🧪 My Beginner Wireshark Workflow

For now, I want a small repeatable process.

```text
1. Open Wireshark
        │
        ▼
2. Select active interface
        │
        ▼
3. Start capture
        │
        ▼
4. Generate known traffic
        │
        ▼
5. Stop capture
        │
        ▼
6. Apply a simple display filter
        │
        ▼
7. Identify source and destination
        │
        ▼
8. Identify ports
        │
        ▼
9. Check TCP flags
        │
        ▼
10. Inspect SEQ and ACK
        │
        ▼
11. Inspect TCP header fields
        │
        ▼
12. Explain what happened
```

The final step is important.

I do not want to only know:

```text
which Wireshark filter to type
```

I want to be able to explain:

```text
why I used the filter
+
what the resulting packets mean
```

---

# 29 — 🧩 Questions I Can Now Answer

After this practice, I should be able to explain:

- What is a TCP segment?
- What information exists inside a TCP header?
- Why does TCP perform a three-way handshake?
- What does SYN mean?
- What does ACK mean?
- What is the difference between SYN and SEQ?
- Why does ACK become `SEQ + 1` during the handshake?
- Why does a SYN consume one sequence number?
- Why can Wireshark display Sequence Number `0` when the actual number is much larger?
- What is a raw sequence number?
- What does TCP Segment Length `0` mean?
- Why can a TCP header be larger than 20 bytes?
- What are TCP Options?
- What is MSS?
- What is Window Scaling?
- What does SACK Permitted mean?
- What is the TCP receive window?
- What is the purpose of the TCP checksum?
- What does FIN mean?
- What does Wireshark capture?
- What is a network interface?
- What is a Wireshark display filter?
- How can I identify SYN packets?
- How can I identify FIN packets?
- How can I recognize a TCP handshake in a packet capture?

---

# 30 — 🎯 Final Mental Model

```text
             APPLICATION
                  │
                  ▼
                SOCKET
                  │
                  ▼
                 TCP
                  │
        ┌─────────┴─────────┐
        │                   │
      HEADER              DATA
        │
        ├── Ports
        ├── SEQ
        ├── ACK
        ├── Flags
        ├── Window
        ├── Checksum
        └── Options
                  │
                  ▼
             TCP SEGMENT
                  │
                  ▼
                  IP
                  │
                  ▼
         NETWORK INTERFACE
                  │
                  ▼
               NETWORK


TCP CONNECTION START

CLIENT                         SERVER

SYN
SEQ = X
──────────────►

                 SYN + ACK
                 SEQ = Y
                 ACK = X+1
        ◄──────────────

ACK
ACK = Y+1
──────────────►

        ESTABLISHED
```

---

# ✅ Day 07 Takeaway

The most important thing I learned today was not simply another Wireshark command.

It was connecting:

```text
TCP theory
+
TCP header
+
TCP segments
+
sequence numbers
+
acknowledgments
+
flags
+
real packet capture
```

into one mental model.

Before this exercise, the TCP handshake looked like:

```text
SYN → SYN-ACK → ACK
```

Now when I see a SYN packet, I think:

```text
Who sent it?
        │
Which destination?
        │
Which ports?
        │
What sequence number?
        │
Which flags are set?
        │
What is the receive window?
        │
Which TCP options were offered?
        │
What should the next packet acknowledge?
```

That is the level of TCP understanding I want to continue building from.
