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
┌─────────────────────────────────────────────────────────┐
│                    USER / APPLICATION                   │
└──────────────────────────┬──────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│  LAYER 7 — APPLICATION                                 │
│  HTTP • HTTPS • FTP • DNS • SMTP • SSH                 │
├─────────────────────────────────────────────────────────┤
│  LAYER 6 — PRESENTATION                                │
│  Encoding • Encryption • Compression                   │
├─────────────────────────────────────────────────────────┤
│  LAYER 5 — SESSION                                     │
│  Establish • Maintain • Terminate                      │
├─────────────────────────────────────────────────────────┤
│  LAYER 4 — TRANSPORT                                   │
│  TCP • UDP • Port Numbers                              │
├─────────────────────────────────────────────────────────┤
│  LAYER 3 — NETWORK                                     │
│  IP Addressing • Routing                               │
├─────────────────────────────────────────────────────────┤
│  LAYER 2 — DATA LINK                                   │
│  Frames • MAC Addresses • Ethernet                     │
├─────────────────────────────────────────────────────────┤
│  LAYER 1 — PHYSICAL                                    │
│  Bits • Electrical • Light • Radio                     │
└──────────────────────────┬──────────────────────────────┘
                           │
                           ▼
                     PHYSICAL NETWORK
```

On the receiving side, the same communication is interpreted in the opposite direction.

---

# 01 — 🧱 Why Does the OSI Model Exist?

**OSI** stands for:

> **Open Systems Interconnection**

The OSI model was standardized by:

> **ISO — International Organization for Standardization**

The basic problem it helps solve is **complexity**.

Modern communication can involve:

```text
┌──────────────────────┐   ┌──────────────────────┐
│     Applications     │   │  Operating Systems   │
└──────────────────────┘   └──────────────────────┘

┌──────────────────────┐   ┌──────────────────────┐
│ Network Interfaces   │   │       Routers        │
└──────────────────────┘   └──────────────────────┘

┌──────────────────────┐   ┌──────────────────────┐
│       Switches       │   │      Protocols       │
└──────────────────────┘   └──────────────────────┘

┌──────────────────────┐   ┌──────────────────────┐
│   Cables / Wi-Fi     │   │ Servers / Vendors    │
└──────────────────────┘   └──────────────────────┘
```

Trying to understand all of that as one giant communication process would be difficult.

The OSI model separates the responsibilities.

```text
                COMPLEX NETWORK COMMUNICATION
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
      Understand        Design         Troubleshoot
          │                │                │
          └────────────────┼────────────────┘
                           │
                           ▼
                    SEVEN OSI LAYERS
```

Another important purpose is standardization.

Networking equipment and software may be created by different companies, but common networking standards allow these systems to communicate.

My simple understanding is:

> **The OSI model gives networking engineers a common framework for describing which part of communication is responsible for what.**

It is important for me not to imagine the OSI model as seven physical programs running independently inside a computer.

It is mainly a:

> **Reference Model**

---

# 02 — 🪜 The Seven OSI Layers

The seven layers from highest to lowest are:

```text
┌───────┬──────────────────────┬─────────────────────────────────────┐
│ Layer │ Name                 │ Main Question                       │
├───────┼──────────────────────┼─────────────────────────────────────┤
│   7   │ Application          │ What network service is needed?     │
│   6   │ Presentation         │ How is data represented/protected?  │
│   5   │ Session              │ How is communication maintained?    │
│   4   │ Transport            │ How should endpoints communicate?   │
│   3   │ Network              │ Where should the packet travel?     │
│   2   │ Data Link            │ Where should the local frame go?    │
│   1   │ Physical             │ How are the bits transmitted?       │
└───────┴──────────────────────┴─────────────────────────────────────┘
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

---

# 03 — 📦 Following One Piece of Data Through the OSI Model

The best way for me to understand OSI was to stop memorizing definitions and follow actual data.

Suppose I create:

```text
┌───────────────────┐
│       DATA        │
│       1234        │
└───────────────────┘
```

As it moves downward through the networking stack, it changes form.

```text
┌─────────────────────────────────────────────────────┐
│                  APPLICATION DATA                   │
│                       1234                          │
└──────────────────────────┬──────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────┐
│                TRANSPORT LAYER                      │
│        [ TCP Header | 1234 ]                        │
│                   SEGMENT                           │
└──────────────────────────┬──────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────┐
│                  NETWORK LAYER                      │
│     [ IP Header | TCP Header | 1234 ]               │
│                    PACKET                           │
└──────────────────────────┬──────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────┐
│                DATA LINK LAYER                      │
│ [ Ethernet | IP | TCP | Data | Trailer ]            │
│                     FRAME                           │
└──────────────────────────┬──────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────┐
│                 PHYSICAL LAYER                      │
│            0101101010010110...                      │
│                      BITS                           │
└─────────────────────────────────────────────────────┘
```

At the destination, the same communication is interpreted in reverse.

```text
┌──────────────┐
│     BITS     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│    FRAME     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│    PACKET    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   SEGMENT    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│     DATA     │
└──────────────┘
```

This journey gave me a stronger understanding of OSI than simply remembering seven layer names.

---

# 04 — 📥 Encapsulation and Decapsulation

Two important terms describe this process:

> **Encapsulation**

and:

> **Decapsulation**

## Encapsulation

Encapsulation happens as information moves downward through the networking stack.

Instead of imagining it only as a downward arrow, I think of it as **putting one package inside another package**.

```text
Original Data

┌──────────────────────────────┐
│             DATA             │
│             1234             │
└──────────────────────────────┘
```

Transport adds its information:

```text
┌────────────────────────────────────────────┐
│ TCP HEADER │             DATA              │
│            │             1234              │
└────────────────────────────────────────────┘

                 SEGMENT
```

Network adds another layer:

```text
┌────────────────────────────────────────────────────┐
│ IP HEADER │ TCP HEADER │            DATA           │
│           │            │            1234           │
└────────────────────────────────────────────────────┘

                       PACKET
```

Data Link wraps it again:

```text
┌──────────────────────────────────────────────────────────────────┐
│ ETHERNET │ IP │ TCP │              DATA              │ TRAILER   │
│ HEADER   │    │     │              1234              │           │
└──────────────────────────────────────────────────────────────────┘

                              FRAME
```

Finally, the physical layer transmits the frame as bits.

```text
010101101010100101101010...
```

So my understanding is:

> **Encapsulation is the process of wrapping data with networking information required by the lower layers.**

---

## Decapsulation

The receiver performs the reverse process.

```text
╔══════════════════════════════════╗
║             FRAME                ║
║  Ethernet + IP + TCP + Data      ║
╚══════════════════════════════════╝
                │
       Remove / Process Layer 2
                ▼
╔══════════════════════════════════╗
║             PACKET               ║
║        IP + TCP + Data           ║
╚══════════════════════════════════╝
                │
       Remove / Process Layer 3
                ▼
╔══════════════════════════════════╗
║            SEGMENT               ║
║           TCP + Data             ║
╚══════════════════════════════════╝
                │
       Remove / Process Layer 4
                ▼
╔══════════════════════════════════╗
║              DATA                ║
╚══════════════════════════════════╝
```

Therefore:

```text
┌───────────────────────┐    ┌─────────────────────────┐
│     ENCAPSULATION     │    │     DECAPSULATION      │
├───────────────────────┤    ├─────────────────────────┤
│ Adds / wraps info     │    │ Processes/removes info │
│ Sender side           │    │ Receiver side           │
│ Moves downward        │    │ Moves upward             │
└───────────────────────┘    └─────────────────────────┘
```

---

# 05 — 📦 What Is a PDU?

Another new term I wanted to understand was:

> **PDU — Protocol Data Unit**

A PDU is the name used for information at a particular networking layer.

```text
┌──────────────────────┬──────────────────────┐
│ OSI Layer            │ PDU                  │
├──────────────────────┼──────────────────────┤
│ Application          │ Data                 │
│ Presentation         │ Data                 │
│ Session              │ Data                 │
├──────────────────────┼──────────────────────┤
│ Transport            │ Segment / Datagram   │
├──────────────────────┼──────────────────────┤
│ Network              │ Packet               │
├──────────────────────┼──────────────────────┤
│ Data Link            │ Frame                │
├──────────────────────┼──────────────────────┤
│ Physical             │ Bits                 │
└──────────────────────┴──────────────────────┘
```

My visual memory pattern is:

```text
       UPPER LAYERS
┌─────────────────────┐
│        DATA         │
│ Layers 7 / 6 / 5    │
└─────────────────────┘

      TRANSPORT
┌─────────────────────┐
│ SEGMENT / DATAGRAM  │
└─────────────────────┘

       NETWORK
┌─────────────────────┐
│       PACKET        │
└─────────────────────┘

      DATA LINK
┌─────────────────────┐
│        FRAME        │
└─────────────────────┘

       PHYSICAL
┌─────────────────────┐
│        BITS         │
└─────────────────────┘
```

One terminology correction I made is:

```text
Segmentation  → Process
Segment       → PDU
```

For TCP, the Layer 4 PDU is commonly called a:

> **Segment**

For UDP, it is commonly called a:

> **Datagram**

---

# 06 — 🖥️ Layer 7: Application Layer

The Application Layer is the layer closest to the software used by the user.

Initially it is easy to think:

```text
Chrome = Application Layer
Gmail  = Application Layer
```

A more accurate understanding is:

> **The Application Layer represents networking services and protocols that applications use to communicate.**

For example:

```text
┌──────────────────────┐
│       Browser        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│     HTTP / HTTPS     │
│ Application Protocol│
└──────────┬───────────┘
           │
           ▼
       NETWORKING
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

At this stage, my goal is not to master every protocol internally.

My mental structure is:

```text
┌───────────────────────┐
│    PROTOCOL NAME      │
└──────────┬────────────┘
           │
           ▼
┌───────────────────────┐
│ What problem does it  │
│ solve in networking?  │
└───────────────────────┘
```

---

# 07 — 🌐 Understanding the Application Protocols

## HTTP

**HTTP — Hypertext Transfer Protocol**

HTTP is used for web communication.

```text
┌───────────────────┐
│      Browser      │
└─────────┬─────────┘
          │ Request
          ▼
┌───────────────────┐
│    Web Server     │
└─────────┬─────────┘
          │ Response
          ▼
┌───────────────────┐
│      Browser      │
└───────────────────┘
```

---

## HTTPS

**HTTPS — Hypertext Transfer Protocol Secure**

HTTPS protects web communication using TLS.

```text
┌──────────────┐
│     HTTP     │
└──────┬───────┘
       │
       │ + TLS Protection
       ▼
┌──────────────┐
│    HTTPS     │
└──────────────┘
```

---

## FTP

**FTP — File Transfer Protocol**

FTP is designed for transferring files.

```text
        FILE TRANSFER

┌───────────────────┐
│    My Computer    │
└─────────┬─────────┘
          │
          │ Upload
          ▼
┌───────────────────┐
│    FTP Server     │
└───────────────────┘
```

or:

```text
┌───────────────────┐
│    FTP Server     │
└─────────┬─────────┘
          │
          │ Download
          ▼
┌───────────────────┐
│    My Computer    │
└───────────────────┘
```

Traditional FTP itself does not provide modern encrypted protection, so secure alternatives are commonly used when security is required.

For my current level:

> **FTP = File Transfer**

---

## DNS

**DNS — Domain Name System**

Humans prefer names such as:

```text
google.com
```

Networking needs IP addresses.

```text
┌──────────────────┐
│    google.com    │
│ Human-Friendly   │
└────────┬─────────┘
         │
         │ DNS Resolution
         ▼
┌──────────────────┐
│    IP Address    │
│ Network-Friendly │
└──────────────────┘
```

This becomes extremely useful during troubleshooting.

---

## SMTP

**SMTP — Simple Mail Transfer Protocol**

SMTP is primarily associated with sending email.

```text
┌──────────────────┐
│ My Email Client  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ My Mail Server   │
└────────┬─────────┘
         │
         ▼
┌──────────────────────┐
│ Recipient Mail Server│
└──────────────────────┘
```

---

## SSH

**SSH — Secure Shell**

SSH allows secure remote command-line access.

```text
┌──────────────────┐
│    My Laptop     │
└────────┬─────────┘
         │
         │ Secure Shell
         ▼
┌──────────────────┐
│ Remote Linux     │
│ Server           │
└──────────────────┘
```

A command may eventually look like:

```bash
ssh user@192.168.1.20
```

SSH is especially important for:

```text
┌───────────────────┐  ┌───────────────────┐
│ Linux Admin       │  │ Cloud Systems     │
└───────────────────┘  └───────────────────┘

┌───────────────────┐  ┌───────────────────┐
│ Cybersecurity     │  │ DevOps / Servers  │
└───────────────────┘  └───────────────────┘
```

---

# 08 — 🎨 Layer 6: Presentation Layer

The Presentation Layer deals with how information is represented.

Three responsibilities commonly associated with it are:

```text
┌───────────────────┐
│     ENCODING      │
│ Representation    │
└───────────────────┘

┌───────────────────┐
│    ENCRYPTION     │
│ Confidentiality   │
└───────────────────┘

┌───────────────────┐
│   COMPRESSION     │
│ Reduce Data Size  │
└───────────────────┘
```

These initially sounded similar to me because all three can change how data appears.

They actually solve very different problems.

---

## Encoding

Encoding changes information into an agreed representation.

Example:

```text
┌─────────────┐
│ Character A │
└──────┬──────┘
       │ ASCII
       ▼
┌─────────────┐
│     65      │
└──────┬──────┘
       │ Binary
       ▼
┌─────────────┐
│  01000001   │
└─────────────┘
```

**ASCII** stands for:

> **American Standard Code for Information Interchange**

Modern systems commonly use Unicode encodings such as UTF-8.

The important idea is:

> **Encoding = Representation / Compatibility**

Encoding is not designed to hide information.

---

## Encryption

Encryption protects information from being understood by unauthorized parties.

```text
┌──────────────────┐
│  Readable Data   │
└────────┬─────────┘
         │ Encryption
         ▼
┌──────────────────┐
│    Ciphertext    │
│ Not Human-Readable│
└────────┬─────────┘
         │ Decryption
         ▼
┌──────────────────┐
│  Readable Data   │
└──────────────────┘
```

The main goal is:

> **Confidentiality**

---

## SSL and TLS

**SSL — Secure Sockets Layer**

**TLS — Transport Layer Security**

TLS is the modern successor to SSL.

```text
          WEB COMMUNICATION

┌──────────────┐      ┌──────────────┐
│     HTTP     │  +   │     TLS      │
│ Web Protocol │      │ Protection   │
└──────────────┘      └──────────────┘
          \              /
           \            /
            ▼          ▼
          ┌──────────────┐
          │    HTTPS     │
          └──────────────┘
```

For my current level, TLS is a useful example of cryptographic protection rather than something I need to force into one literal physical OSI layer.

---

## Compression

Compression reduces how much space information requires.

```text
┌────────────────────┐
│     Large Data     │
│ ██████████████████ │
└─────────┬──────────┘
          │ Compression
          ▼
┌────────────────────┐
│    Smaller Data    │
│ ████████           │
└────────────────────┘
```

Two broad types are:

```text
┌─────────────────────────┐
│ LOSSLESS COMPRESSION    │
├─────────────────────────┤
│ Exact reconstruction    │
│ GZIP • ZIP • PNG        │
└─────────────────────────┘

┌─────────────────────────┐
│ LOSSY COMPRESSION       │
├─────────────────────────┤
│ Some information lost   │
│ JPEG • MP3 • Video      │
└─────────────────────────┘
```

The distinction I want to remember is:

```text
┌──────────────┬────────────────────────┐
│ Encoding     │ Representation         │
├──────────────┼────────────────────────┤
│ Encryption   │ Confidentiality        │
├──────────────┼────────────────────────┤
│ Compression  │ Reduce Size            │
└──────────────┴────────────────────────┘
```

---

# 09 — 🤝 Layer 5: Session Layer

The Session Layer represents communication-session management.

```text
        SESSION LIFECYCLE

┌───────────────────────┐
│       ESTABLISH       │
│ Begin Communication   │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│       MAINTAIN        │
│ Continue Communication│
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│       TERMINATE       │
│ End Communication     │
└───────────────────────┘
```

Modern Internet protocols do not always map cleanly into separate OSI Session and Presentation layers.

So I use Layer 5 mainly to understand the **responsibility** rather than searching for a physical Session Layer device.

---

# 10 — 🚚 Layer 4: Transport Layer

The Transport Layer introduced:

```text
┌─────────────────────┐
│         TCP         │
│ Reliable Transport  │
└─────────────────────┘

┌─────────────────────┐
│         UDP         │
│ Simpler Transport   │
└─────────────────────┘

┌─────────────────────┐
│    PORT NUMBERS     │
│ Endpoint Identifier │
└─────────────────────┘
```

---

## TCP — Transmission Control Protocol

TCP provides mechanisms for reliable communication.

```text
┌─────────────────────────────────────────────┐
│                  TCP                        │
├─────────────────────────────────────────────┤
│ Sequencing                                  │
│ Acknowledgements                            │
│ Retransmission                              │
│ Error Detection                             │
│ Flow Control                                │
└─────────────────────────────────────────────┘
```

Suppose data belongs in this order:

```text
┌───┐ ┌───┐ ┌───┐ ┌───┐
│ 1 │ │ 2 │ │ 3 │ │ 4 │
└───┘ └───┘ └───┘ └───┘
```

But the receiver sees:

```text
┌───┐ ┌───┐       ┌───┐
│ 1 │ │ 2 │       │ 4 │
└───┘ └───┘       └───┘

          Missing 3
```

TCP reliability mechanisms can detect that something is missing and allow retransmission.

---

## TCP Reliable Does Not Mean TCP Secure

```text
┌──────────────────────────┐
│       RELIABILITY        │
│ Did the data arrive?     │
│ Is it ordered correctly? │
└──────────────────────────┘

               ≠

┌──────────────────────────┐
│        SECURITY          │
│ Is the data protected?   │
│ Is it encrypted?         │
└──────────────────────────┘
```

A TCP connection can carry unencrypted information.

So:

> **Reliability ≠ Security**

---

## UDP — User Datagram Protocol

UDP provides a simpler transport service.

```text
┌──────────────────────────────────────┐
│                 UDP                  │
├──────────────────────────────────────┤
│ No built-in delivery guarantee       │
│ No built-in ordering guarantee       │
│ No built-in retransmission           │
│ Lower transport overhead             │
└──────────────────────────────────────┘
```

Examples can include:

```text
┌─────────────┐ ┌─────────────┐
│     DNS     │ │   Gaming    │
└─────────────┘ └─────────────┘

┌─────────────┐ ┌─────────────┐
│ Voice / VoIP│ │ Streaming   │
└─────────────┘ └─────────────┘
```

Instead of memorizing:

```text
TCP = Slow
UDP = Fast
```

I prefer:

```text
┌────────────────────────────┬────────────────────────────┐
│ TCP                        │ UDP                        │
├────────────────────────────┼────────────────────────────┤
│ Reliability mechanisms     │ Fewer reliability features │
│ More protocol overhead     │ Lower transport overhead   │
└────────────────────────────┴────────────────────────────┘
```

---

# 11 — 🚪 Why Port Numbers Exist

A single computer can run many network applications.

```text
                   ONE COMPUTER
                        │
         ┌──────────────┼──────────────┐
         │              │              │
         ▼              ▼              ▼
    ┌─────────┐    ┌─────────┐    ┌─────────┐
    │ Browser │    │   SSH   │    │  Email  │
    └─────────┘    └─────────┘    └─────────┘
         │              │              │
         └──────────────┼──────────────┘
                        │
                   PORT NUMBERS
```

An IP address helps identify the host.

A port helps identify the communication endpoint.

```text
┌───────────────────┐
│    IP ADDRESS     │
│    Which host?    │
└───────────────────┘

┌───────────────────┐
│    PORT NUMBER    │
│ Which endpoint?   │
└───────────────────┘
```

Some common examples are:

```text
┌─────────┬──────────────┐
│ Service │ TCP Port     │
├─────────┼──────────────┤
│ HTTP    │ 80           │
│ HTTPS   │ 443          │
│ SSH     │ 22           │
└─────────┴──────────────┘
```

A client application can also use a temporary ephemeral port.

```text
┌──────────────────────────┐
│ My Laptop                │
│ 192.168.1.20:53021       │
└────────────┬─────────────┘
             │
             │ HTTPS Connection
             ▼
┌──────────────────────────┐
│ Web Server               │
│ 203.x.x.x:443            │
└──────────────────────────┘
```

---

# 12 — 🛣️ Layer 3: Network Layer

The Network Layer connects:

```text
┌──────────────────┐       ┌──────────────────┐
│  IP ADDRESSING   │       │     ROUTING      │
│ Logical Address  │       │ Path Selection   │
└─────────┬────────┘       └─────────┬────────┘
          │                           │
          └─────────────┬─────────────┘
                        ▼
                 ┌─────────────┐
                 │   LAYER 3   │
                 │   NETWORK   │
                 └─────────────┘
```

The PDU is:

> **Packet**

Routers are strongly associated with Layer 3.

```text
┌──────────────┐
│  Source Host │
└──────┬───────┘
       │ Packet
       ▼
┌──────────────┐
│   Router 1   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Router 2   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Destination  │
└──────────────┘
```

A correction I made:

```text
Incorrect:
Network Layer = Assigns IP Addresses

Better:
Network Layer = Uses IP addressing
and routing
```

Actual IP configuration may come from DHCP, static configuration or provider/network configuration.

---

# 13 — 🔗 Layer 2: Data Link Layer

The Data Link Layer deals with communication across the current network link.

```text
                  DATA LINK LAYER

       ┌────────────┬────────────┬────────────┐
       │            │            │            │
       ▼            ▼            ▼            ▼
   ┌───────┐    ┌───────┐    ┌────────┐   ┌────────┐
   │ Frame │    │  MAC  │    │Ethernet│   │ Switch │
   └───────┘    └───────┘    └────────┘   └────────┘
```

The PDU is:

> **Frame**

---

## MAC Address

**MAC — Media Access Control**

A MAC address is associated with a network interface.

```text
                 LAPTOP
                   │
          ┌────────┴────────┐
          │                 │
          ▼                 ▼
┌─────────────────┐ ┌─────────────────┐
│ Wi-Fi Interface │ │Ethernet Interface│
│ MAC Address A   │ │ MAC Address B   │
└─────────────────┘ └─────────────────┘
```

The important distinction is:

```text
┌─────────────────────────┐
│       IP ADDRESS        │
│ Logical network address │
│ Across networks         │
└─────────────────────────┘

             VS

┌─────────────────────────┐
│       MAC ADDRESS       │
│ Local-link addressing   │
│ Current network segment │
└─────────────────────────┘
```

---

## IP vs MAC During Routing

Suppose traffic travels:

```text
             INTERNET PATH

┌──────────┐
│  Laptop  │
└────┬─────┘
     │
     ▼
┌──────────┐
│ Home     │
│ Router   │
└────┬─────┘
     │
     ▼
┌──────────┐
│ ISP      │
│ Router   │
└────┬─────┘
     │
     ▼
┌──────────┐
│ Other    │
│ Routers  │
└────┬─────┘
     │
     ▼
┌──────────┐
│ Server   │
└──────────┘
```

Layer 3 keeps the idea of the final destination.

Layer 2 framing changes for each local link.

```text
LINK 1

┌──────────────┐       ┌──────────────┐
│ Laptop MAC   │ ───▶  │ Router MAC   │
└──────────────┘       └──────────────┘


LINK 2

┌─────────────────┐    ┌─────────────────┐
│ Router Interface│ ─▶ │ Next-Hop MAC    │
└─────────────────┘    └─────────────────┘
```

So:

```text
IP  → End-to-end logical destination
MAC → Local-link / next-hop delivery
```

---

# 14 — ⚡ Layer 1: Physical Layer

The Physical Layer is responsible for transmitting raw bits.

```text
                          BITS
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
┌────────────────┐ ┌────────────────┐ ┌────────────────┐
│ Copper Cable   │ │ Fiber Optic    │ │     Wi-Fi      │
│ Electrical     │ │ Light Pulses   │ │ Radio Waves    │
└────────────────┘ └────────────────┘ └────────────────┘
```

The PDU is:

> **Bits**

A message that began as readable application data can eventually become:

```text
010101101001011001010...
```

and then be carried as physical signals.

---

## NIC

**NIC — Network Interface Card**

or more generally:

> **Network Interface Controller**

A NIC allows a device to connect to a network.

```text
┌──────────────────────────────┐
│            DEVICE            │
│                              │
│  ┌────────────────────────┐  │
│  │      Wi-Fi NIC         │  │
│  └────────────────────────┘  │
│                              │
│  ┌────────────────────────┐  │
│  │    Ethernet NIC        │  │
│  └────────────────────────┘  │
└──────────────────────────────┘
```

NICs interact heavily with both Layer 1 and Layer 2 responsibilities.

---

# 15 — 🌍 Tracing Communication from My Laptop to a Website

Suppose I open a website using HTTPS.

Instead of thinking of it as one direct action, I now visualize it like this:

```text
┌─────────────────────────────────────────────────────┐
│                    MY LAPTOP                        │
│                                                     │
│  ┌──────────────────────────────────────────────┐   │
│  │ APPLICATION                                  │   │
│  │ Browser → HTTP / HTTPS                       │   │
│  └────────────────────┬─────────────────────────┘   │
│                       │                             │
│  ┌────────────────────▼─────────────────────────┐   │
│  │ PRESENTATION / SECURITY FUNCTIONS            │   │
│  │ Encoding / TLS / Compression                 │   │
│  └────────────────────┬─────────────────────────┘   │
│                       │                             │
│  ┌────────────────────▼─────────────────────────┐   │
│  │ TRANSPORT                                    │   │
│  │ TCP + Source/Destination Ports               │   │
│  └────────────────────┬─────────────────────────┘   │
│                       │                             │
│  ┌────────────────────▼─────────────────────────┐   │
│  │ NETWORK                                      │   │
│  │ Source IP + Destination IP                   │   │
│  └────────────────────┬─────────────────────────┘   │
│                       │                             │
│  ┌────────────────────▼─────────────────────────┐   │
│  │ DATA LINK                                    │   │
│  │ Source MAC + Next-Hop MAC                    │   │
│  └────────────────────┬─────────────────────────┘   │
│                       │                             │
│  ┌────────────────────▼─────────────────────────┐   │
│  │ PHYSICAL                                     │   │
│  │ Bits → Electrical / Light / Radio            │   │
│  └────────────────────┬─────────────────────────┘   │
└───────────────────────┼─────────────────────────────┘
                        │
                        ▼
                 ┌──────────────┐
                 │ Home Router  │
                 └──────┬───────┘
                        │
                        ▼
                 ┌──────────────┐
                 │     ISP      │
                 └──────┬───────┘
                        │
                        ▼
                 ┌──────────────┐
                 │   Internet   │
                 │   Routers    │
                 └──────┬───────┘
                        │
                        ▼
                 ┌──────────────┐
                 │ Web Server   │
                 └──────────────┘
```

At the destination, the server performs decapsulation and processes the request.

This helped me understand that:

```text
Application
     │
     │ does NOT directly jump to
     ▼
Internet
```

There are multiple networking responsibilities underneath one simple user action.

---

# 16 — 🧪 The FTP Corruption Question

One scenario that made the Transport Layer clearer was:

> **A file is being transferred using FTP and part of the transmission is lost or corrupted. Which OSI layer provides reliable recovery?**

FTP normally uses TCP.

```text
┌─────────────────────┐
│         FTP         │
│ File Transfer       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│         TCP         │
│ Reliable Transport  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   TRANSPORT LAYER   │
│      Layer 4        │
└─────────────────────┘
```

Layer 2 can detect certain frame-level errors.

TCP provides end-to-end reliability.

```text
┌──────────────────────────┐
│ Layer 2                  │
│ Frame Error Detection    │
└──────────────────────────┘

              VS

┌──────────────────────────┐
│ Layer 4 — TCP            │
│ End-to-End Reliability   │
│ Retransmission           │
└──────────────────────────┘
```

Therefore the expected answer is:

> **Transport Layer — TCP**

---

# 17 — 🛠️ Using OSI for Network Troubleshooting

One of the most practical reasons I want to understand OSI is troubleshooting.

Instead of seeing:

```text
┌─────────────────────────┐
│   "Internet Not Working"│
└─────────────────────────┘
```

as one giant problem, I can divide the investigation.

```text
                      NETWORK ISSUE
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
         ▼                 ▼                 ▼
┌────────────────┐ ┌────────────────┐ ┌────────────────┐
│ Layer 1        │ │ Layer 2        │ │ Layer 3        │
│ Signal/Cable   │ │ Local Link     │ │ IP / Routing   │
└────────────────┘ └────────────────┘ └────────────────┘
                                                │
                           ┌────────────────────┼────────────────────┐
                           │                                         │
                           ▼                                         ▼
                  ┌────────────────┐                      ┌────────────────┐
                  │ Layer 4        │                      │ Upper Layers   │
                  │ TCP/UDP/Ports  │                      │ DNS/App/etc.   │
                  └────────────────┘                      └────────────────┘
```

This gives me a structured way to narrow the problem instead of randomly changing settings.

---

## Example 1 — Wi-Fi Connected but Gateway Cannot Be Reached

```text
┌──────────────────────────┐
│ Wi-Fi: Connected         │
│ IP: 192.168.1.20         │
│ Gateway: 192.168.1.1     │
└────────────┬─────────────┘
             │
             │ ping gateway
             ▼
┌──────────────────────────┐
│      REQUEST TIMEOUT     │
└──────────────────────────┘
```

I would investigate:

```text
┌──────────────────────┐
│ LAYER 1              │
│ Signal / Interface   │
└──────────────────────┘

┌──────────────────────┐
│ LAYER 2              │
│ Wi-Fi / Local Link   │
│ MAC / ARP Behaviour  │
└──────────────────────┘

┌──────────────────────┐
│ LAYER 3              │
│ IP / Mask / Gateway  │
└──────────────────────┘
```

Seeing `Wi-Fi Connected` does not prove every network layer is functioning.

---

## Example 2 — IP Works but Domain Name Does Not

```text
┌──────────────────────┐
│ ping 8.8.8.8         │
│       WORKS          │
└──────────────────────┘

             BUT

┌──────────────────────┐
│ google.com           │
│ Cannot Resolve       │
└──────────────────────┘
```

What is different?

```text
┌──────────────────────┐
│ 8.8.8.8              │
│ Already an IP        │
└──────────────────────┘

┌──────────────────────┐
│ google.com           │
│ Needs DNS Resolution │
└──────────────────────┘
```

So I would investigate:

> **DNS — Application Layer**

---

## Example 3 — Streaming Is Buffering

```text
                       BUFFERING
                           │
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
    ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
    │ Layer 1     │ │ Layer 2     │ │ Layer 3     │
    │ Weak Wi-Fi? │ │ Local issue?│ │ Routing?    │
    └─────────────┘ └─────────────┘ └─────────────┘
                                           │
                    ┌──────────────────────┼──────────────────────┐
                    │                                             │
                    ▼                                             ▼
             ┌─────────────┐                              ┌─────────────┐
             │ Layer 4     │                              │ Upper Layer │
             │ Ports/TCP?  │                              │ DNS/App?    │
             └─────────────┘                              └─────────────┘
```

The OSI model does not automatically tell me the answer.

It gives me a **method for narrowing the possibilities**.

---

# 18 — 🧠 Devices and Layers: Useful but Not Absolute

A beginner OSI map often looks like:

```text
┌───────────────┬────────────────────┐
│ Layer         │ Common Association │
├───────────────┼────────────────────┤
│ Transport     │ Firewall           │
│ Network       │ Router             │
│ Data Link     │ Switch             │
│ Physical      │ Hub / Cable        │
└───────────────┴────────────────────┘
```

This is useful, but not absolute.

Modern devices can work across multiple layers.

```text
┌────────────────────────────┐
│      MODERN FIREWALL       │
├────────────────────────────┤
│ Layer 3 Information        │
│ Layer 4 Ports/Protocols    │
│ Layer 7 Application Data   │
└────────────────────────────┘
```

Some switches can also perform Layer 3 routing.

So I treat device mappings as:

> **Common or traditional associations, not permanent boundaries.**

---

# 19 — 📝 Quick Revision Map

This is the compact diagram I want to be able to reconstruct without notes.

```text
╔════════════════════════════════════════════════════╗
║                 OSI MODEL                         ║
╠═══════╦══════════════════╦════════════════════════╣
║ Layer ║ Name             ║ Main Concepts          ║
╠═══════╬══════════════════╬════════════════════════╣
║   7   ║ Application      ║ HTTP / HTTPS / DNS     ║
║       ║                  ║ FTP / SMTP / SSH       ║
╠═══════╬══════════════════╬════════════════════════╣
║   6   ║ Presentation     ║ Encoding / Encryption  ║
║       ║                  ║ Compression            ║
╠═══════╬══════════════════╬════════════════════════╣
║   5   ║ Session          ║ Session Management     ║
╠═══════╬══════════════════╬════════════════════════╣
║   4   ║ Transport        ║ TCP / UDP / Ports      ║
║       ║ PDU              ║ Segment / Datagram     ║
╠═══════╬══════════════════╬════════════════════════╣
║   3   ║ Network          ║ IP / Routing           ║
║       ║ PDU              ║ Packet                 ║
╠═══════╬══════════════════╬════════════════════════╣
║   2   ║ Data Link        ║ MAC / Ethernet / Switch║
║       ║ PDU              ║ Frame                  ║
╠═══════╬══════════════════╬════════════════════════╣
║   1   ║ Physical         ║ Electrical / Light     ║
║       ║ PDU              ║ Radio / Bits           ║
╚═══════╩══════════════════╩════════════════════════╝
```

Addressing model:

```text
┌───────────────────────────────────────────────┐
│          NETWORK COMMUNICATION IDENTITY       │
├─────────────────┬─────────────────────────────┤
│ PORT            │ Which service / endpoint?   │
├─────────────────┼─────────────────────────────┤
│ IP ADDRESS      │ Which logical destination?  │
├─────────────────┼─────────────────────────────┤
│ MAC ADDRESS     │ Which local-link interface? │
└─────────────────┴─────────────────────────────┘
```

PDU model:

```text
        ┌───────────────┐
        │     DATA      │
        │ Layers 7–5    │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │    SEGMENT    │
        │    Layer 4    │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │    PACKET     │
        │    Layer 3    │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │     FRAME     │
        │    Layer 2    │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │      BITS     │
        │    Layer 1    │
        └───────────────┘
```

---

# 20 — ⚠️ Important Corrections I Made While Learning

```text
┌────────────────────────────────────────────────────────┐
│ TCP                                                    │
├────────────────────────────────────────────────────────┤
│ ❌ TCP = Secure                                        │
│ ✅ TCP = Reliable transport                            │
│ Security requires separate protection                  │
└────────────────────────────────────────────────────────┘
```

```text
┌────────────────────────────────────────────────────────┐
│ MAC ADDRESS                                            │
├────────────────────────────────────────────────────────┤
│ ❌ End-to-end Internet address                         │
│ ✅ Local-link address associated with an interface     │
└────────────────────────────────────────────────────────┘
```

```text
┌────────────────────────────────────────────────────────┐
│ IP ADDRESS                                             │
├────────────────────────────────────────────────────────┤
│ ❌ Network Layer automatically assigns IPs             │
│ ✅ Layer 3 uses IP addressing and routing              │
└────────────────────────────────────────────────────────┘
```

```text
┌────────────────────────────────────────────────────────┐
│ ENCODING                                               │
├────────────────────────────────────────────────────────┤
│ ❌ Encoding = Encryption                               │
│ ✅ Encoding = Representation                           │
└────────────────────────────────────────────────────────┘
```

```text
┌────────────────────────────────────────────────────────┐
│ WI-FI CONNECTED                                        │
├────────────────────────────────────────────────────────┤
│ ❌ Every network layer is definitely working           │
│ ✅ Other Layer 2 / Layer 3 issues may still exist      │
└────────────────────────────────────────────────────────┘
```

These corrections were important because networking terms can sound related while solving very different problems.

---

# 21 — 💭 Day 5 Reflection

Before studying the OSI model, I already understood several networking concepts individually.

```text
                    WHAT I ALREADY KNEW

┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ IP Addresses │ │ MAC Addresses│ │ Port Numbers │
└──────────────┘ └──────────────┘ └──────────────┘

┌──────────────┐ ┌──────────────┐
│   Routers    │ │  Protocols   │
└──────────────┘ └──────────────┘
```

The OSI model gave those concepts a structure.

```text
                      OSI MODEL
                          │
       ┌──────────────────┼───────────────────┐
       │                  │                   │
       ▼                  ▼                   ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Protocols   │     │ Addressing  │     │ Devices     │
│ HTTP/TCP    │     │ Port/IP/MAC │     │Router/Switch│
└─────────────┘     └─────────────┘     └─────────────┘
       │                  │                   │
       └──────────────────┼───────────────────┘
                          ▼
               ONE COMMUNICATION MODEL
```

Now I can visualize both sending and receiving.

```text
               SENDER                         RECEIVER

        ┌───────────────┐               ┌───────────────┐
        │ Application   │               │ Application   │
        └───────┬───────┘               └───────▲───────┘
                │                               │
        ┌───────▼───────┐               ┌───────┴───────┐
        │ Transport     │               │ Transport     │
        └───────┬───────┘               └───────▲───────┘
                │                               │
        ┌───────▼───────┐               ┌───────┴───────┐
        │ Network       │               │ Network       │
        └───────┬───────┘               └───────▲───────┘
                │                               │
        ┌───────▼───────┐               ┌───────┴───────┐
        │ Data Link     │               │ Data Link     │
        └───────┬───────┘               └───────▲───────┘
                │                               │
        ┌───────▼───────┐               ┌───────┴───────┐
        │ Physical      │═══════════════▶│ Physical      │
        └───────────────┘    NETWORK    └───────────────┘

         ENCAPSULATION                  DECAPSULATION
```

This was also the point where I started seeing OSI as a troubleshooting framework rather than something that exists only for memorization.

Instead of:

```text
"The network is down."
```

I can begin asking:

```text
                 WHERE IS IT FAILING?

        ┌───────────────────────────────┐
        │ Physical connection working? │
        └──────────────┬────────────────┘
                       │
                       ▼
        ┌───────────────────────────────┐
        │ Local-link communication?     │
        └──────────────┬────────────────┘
                       │
                       ▼
        ┌───────────────────────────────┐
        │ IP addressing / routing?      │
        └──────────────┬────────────────┘
                       │
                       ▼
        ┌───────────────────────────────┐
        │ TCP / UDP / Ports working?    │
        └──────────────┬────────────────┘
                       │
                       ▼
        ┌───────────────────────────────┐
        │ DNS / Application problem?    │
        └───────────────────────────────┘
```

The biggest idea I want to carry forward from Day 5 is:

> **Every OSI layer solves a different communication problem. Understanding those responsibilities allows me to trace communication and troubleshoot failures logically instead of treating networking as one giant black box.**

---

# 🔜 What I Want to Learn Next

My next topic is:

> **TCP/IP Model**

The question I want to answer next is:

```text
┌───────────────────────────────────────────────────────┐
│                    NEXT QUESTION                      │
├───────────────────────────────────────────────────────┤
│ OSI explains communication using seven layers.        │
│                                                       │
│ How does the TCP/IP model organize the same           │
│ Internet communication in practice?                   │
└───────────────────────────────────────────────────────┘
```

I also want to understand this mapping:

```text
┌─────────────────────┐          ┌─────────────────────┐
│      OSI MODEL      │          │    TCP/IP MODEL    │
│      7 Layers       │   ⇄      │   Fewer Layers     │
│ Reference Model     │          │ Internet Protocols │
└─────────────────────┘          └─────────────────────┘
```

Concepts such as:

```text
┌────────┐  ┌────────┐  ┌────────┐  ┌──────────┐
│ HTTP   │  │ TCP    │  │  IP    │  │ Ethernet │
└────────┘  └────────┘  └────────┘  └──────────┘
```

should appear again, but organized differently.

---

# 📌 Networking Journey Map

Instead of seeing my networking journey only as a straight sequence of days, I now see the concepts building around one central goal:

```text
                         ┌───────────────────────┐
                         │ NETWORKING FUNDAMENTALS│
                         └───────────┬───────────┘
                                     │
             ┌───────────────────────┼────────────────────────┐
             │                       │                        │
             ▼                       ▼                        ▼
┌────────────────────────┐ ┌────────────────────────┐ ┌────────────────────────┐
│ ADDRESSING FOUNDATION  │ │ NETWORK STRUCTURE      │ │ COMMUNICATION MODEL    │
│                        │ │                        │ │                        │
│ Day 1                  │ │ Day 3                  │ │ Day 5                  │
│ IP / MAC / Ports       │ │ Network ID             │ │ OSI Model              │
│ Protocol Basics        │ │ Broadcast ID           │ │ Encapsulation          │
│                        │ │ Subnet Mask             │ │ PDU / Troubleshooting  │
└────────────┬───────────┘ └────────────┬───────────┘ └────────────┬───────────┘
             │                          │                          │
             ▼                          ▼                          ▼
┌────────────────────────┐ ┌────────────────────────┐ ┌────────────────────────┐
│ ADDRESS REPRESENTATION │ │ INTERNET CONNECTIVITY  │ │ NEXT STEP              │
│                        │ │                        │ │                        │
│ Day 2                  │ │ Day 4                  │ │ TCP/IP Model           │
│ IPv4                   │ │ Private / Public IP    │ │ OSI ↔ TCP/IP Mapping   │
│ Binary                 │ │ Gateway / NAT          │ │ Real Internet Stack    │
│ Address Classes        │ │ Routing                │ │                        │
└────────────────────────┘ └────────────────────────┘ └────────────────────────┘
```

This better represents how I actually see the journey now.

The topics are not isolated days.

They connect together:

```text
Addressing
    +
Subnet / Network Structure
    +
Routing
    +
Protocols
    +
OSI Communication Model
    =
Understanding How Network Communication Works
```

> **My goal with this networking journey is not simply to memorize definitions. I want to understand why each concept exists, connect it with the concepts I already know, test my assumptions, and eventually be able to trace and troubleshoot real network communication logically.**
