# 🌐 NETWORKING — DAY 05

## Understanding the OSI Model and How Data Moves Through a Network

**Learning Track:** Networking Fundamentals
**Focus:** OSI Model • Encapsulation • Decapsulation • PDU • TCP & UDP • Ports • IP Addressing • MAC Addressing • Ethernet • HTTP/HTTPS • FTP • DNS • SMTP • SSH • TLS • Network Troubleshooting

---

> [!IMPORTANT]
>
> ### 💡 The main idea I am taking from Day 5
>
> **The OSI model gives me a structured way to understand a complex network communication process by breaking it into seven layers, with each layer responsible for a specific part of communication.**
>
> Instead of seeing network communication as one large process, I can now trace data from an application all the way to physical signals and then reconstruct the same journey on the receiving side.

My current mental model is:

```text
APPLICATION DATA
       ↓
Application
Presentation
Session
       ↓
Transport      → Segment / Datagram
       ↓
Network        → Packet
       ↓
Data Link      → Frame
       ↓
Physical       → Bits
       ↓
NETWORK
       ↓
Receiver performs the reverse process
```

This was the point where networking started to feel less like separate terms and more like one connected system.

---

# 01 — 🧱 Why the OSI Model Exists

**OSI** stands for:

> **Open Systems Interconnection**

The OSI model is a seven-layer reference model standardized by the International Organization for Standardization (ISO).

My understanding of its purpose is simple:

> **Complex communication becomes easier to design, understand and troubleshoot when different responsibilities are separated into layers.**

The seven layers are:

```text
7 — Application
6 — Presentation
5 — Session
4 — Transport
3 — Network
2 — Data Link
1 — Physical
```

Each layer answers a different question.

```text
Application    → What network service does the application need?

Presentation   → How should the data be represented or protected?

Session        → How is the communication session managed?

Transport      → How should data move between application endpoints?

Network        → Where does the packet need to go?

Data Link      → How does it move across the current local link?

Physical       → How are the actual bits transmitted?
```

The OSI model is not something I imagine as seven separate programs inside a computer.

I see it as a **framework for understanding networking responsibilities**.

---

# 02 — 📦 Encapsulation and Decapsulation

One of the most important concepts I understood today is that data changes as it moves through the networking stack.

Suppose an application creates:

```text
"1234"
```

As the information moves downward, networking information is added around it.

```text
Application Data
      ↓

[TCP Header | Data]
      ↓
SEGMENT

[IP Header | TCP Header | Data]
      ↓
PACKET

[Ethernet Header | IP | TCP | Data | Trailer]
      ↓
FRAME

010101101001...
      ↓
BITS
```

This process is called:

> **Encapsulation**

The receiving system performs the reverse process.

```text
BITS
 ↓
FRAME
 ↓
PACKET
 ↓
SEGMENT
 ↓
APPLICATION DATA
```

This is:

> **Decapsulation**

So my easiest way to remember them is:

```text
Encapsulation
Data moves downward
+
networking information is added

Decapsulation
Data moves upward
+
networking information is processed/removed
```

---

# 03 — 📦 PDU: What the Data Is Called at Each Layer

I also learned the term:

> **PDU — Protocol Data Unit**

A PDU is basically the name given to the information being handled at a particular networking layer.

| OSI Layer    | PDU                |
| ------------ | ------------------ |
| Application  | Data               |
| Presentation | Data               |
| Session      | Data               |
| Transport    | Segment / Datagram |
| Network      | Packet             |
| Data Link    | Frame              |
| Physical     | Bits               |

My memory shortcut is:

```text
DATA
DATA
DATA
SEGMENT
PACKET
FRAME
BITS
```

The name changes because each layer is looking at the communication from a different responsibility.

---

# 04 — 🔍 What I Understand About Each Layer

Rather than memorizing definitions, I tried to understand what role each layer plays when I actually send something across a network.

| Layer            | My Current Understanding                                                                                                   |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------- |
| **Application**  | Provides network services used by applications through protocols such as HTTP, HTTPS, FTP, DNS, SMTP and SSH               |
| **Presentation** | Handles representation-related functions such as encoding, encryption and compression                                      |
| **Session**      | Represents establishing, maintaining and ending communication sessions                                                     |
| **Transport**    | Uses protocols such as TCP and UDP and identifies communication endpoints using port numbers                               |
| **Network**      | Uses logical IP addressing and routing to move packets between networks                                                    |
| **Data Link**    | Uses frames and local-link addressing such as MAC addresses; Ethernet and switches are strongly associated with this layer |
| **Physical**     | Transmits bits using electrical signals, light or radio                                                                    |

A useful distinction I learned is:

```text
IP Address
     ↓
Logical addressing across networks

MAC Address
     ↓
Local-link delivery between network interfaces

Port Number
     ↓
Identifies the application/service communication endpoint
```

This helped connect concepts I had studied on earlier networking days with the OSI model.

---

# 05 — 🌐 Application Protocols I Can Now Identify

I came across several protocols while studying the upper layers.

At this stage, I am focusing on understanding their basic purpose rather than trying to master their internal operation.

| Protocol  | Full Form                          | Basic Purpose                                          |
| --------- | ---------------------------------- | ------------------------------------------------------ |
| **HTTP**  | Hypertext Transfer Protocol        | Web communication                                      |
| **HTTPS** | Hypertext Transfer Protocol Secure | Web communication protected using TLS                  |
| **FTP**   | File Transfer Protocol             | Transferring files                                     |
| **DNS**   | Domain Name System                 | Resolving names such as `google.com` into IP addresses |
| **SMTP**  | Simple Mail Transfer Protocol      | Sending email                                          |
| **SSH**   | Secure Shell                       | Secure remote command-line access                      |

For example:

```text
google.com
    ↓
DNS
    ↓
IP Address
```

And:

```text
Browser
   ↓
HTTPS
   ↓
HTTP communication protected using TLS
```

I also learned that **SSL** stands for Secure Sockets Layer, while **TLS — Transport Layer Security — is its modern successor**.

For my current level, the important idea is:

> **TLS protects communication such as HTTPS by providing cryptographic security.**

---

# 06 — 🚚 TCP vs UDP

The Transport layer made more sense once I stopped thinking of TCP as simply "slow" and UDP as simply "fast."

### TCP — Transmission Control Protocol

TCP provides mechanisms for reliable communication.

Some of the important ideas I currently understand are:

```text
Sequencing
Acknowledgements
Retransmission
Error detection
Flow control
```

If information is missing during a TCP communication, TCP has mechanisms that can result in that information being retransmitted.

### UDP — User Datagram Protocol

UDP provides a simpler transport service.

It does not provide TCP's built-in guarantees for:

```text
Delivery
Ordering
Retransmission
```

Because there is less protocol overhead, UDP is useful for situations where low latency may be more important than recovering every lost piece of information.

The most important correction I made today was:

```text
TCP RELIABILITY ≠ SECURITY
```

TCP being reliable does not automatically mean its data is encrypted.

Security and reliability solve different problems.

---

## 🚪 Why Port Numbers Matter

A single computer can have many applications communicating at the same time.

For example:

```text
Computer
│
├── Browser
├── SSH
├── Email
└── Other Applications
```

The operating system needs a way to distinguish different communication endpoints.

That is where port numbers become important.

Some commonly associated service ports are:

```text
HTTP   → 80
HTTPS  → 443
SSH    → 22
```

Applications can also use temporary ports for individual connections.

My current mental model is:

```text
IP Address
   ↓
Which host?

Port Number
   ↓
Which communication endpoint/service?
```

---

# 07 — 🔐 Encoding vs Encryption vs Compression

These three initially sounded similar because all of them can change how data looks.

I now understand that they solve completely different problems.

### Encoding

Encoding represents information using an agreed format so systems can interpret it.

For example:

```text
Character
A

↓ ASCII representation

65

↓ Binary representation

01000001
```

**ASCII** stands for:

> **American Standard Code for Information Interchange**

Modern systems commonly use formats such as UTF-8 for representing much larger sets of characters.

### Encryption

Encryption changes readable information into a protected form that should require the correct cryptographic mechanism/key to recover.

```text
Readable Data
     ↓
Encryption
     ↓
Ciphertext
     ↓
Decryption
     ↓
Readable Data
```

Its main purpose is:

> **Confidentiality**

### Compression

Compression attempts to represent information using less storage or transmission space.

```text
Large Data
   ↓
Compression
   ↓
Smaller Representation
```

Depending on the compression method, the original data may be reconstructed exactly or approximately.

The distinction I want to remember is:

```text
ENCODING
→ Representation

ENCRYPTION
→ Protection / Confidentiality

COMPRESSION
→ Reduce Size
```

---

# 08 — 🛠️ Using the OSI Model for Troubleshooting

The biggest practical value I see in the OSI model is troubleshooting.

Instead of immediately saying:

> "The Internet is broken"

I can narrow the problem down layer by layer.

A common bottom-up approach is:

```text
Layer 1
Physical connection / signal
        ↓
Layer 2
Local-link communication
        ↓
Layer 3
IP configuration / routing
        ↓
Layer 4
TCP / UDP / Ports
        ↓
Upper Layers
Application and protocol behaviour
```

### Example 1 — Website Works by IP but Not by Name

Suppose communication to an IP address works but:

```text
google.com
```

cannot be resolved.

Because converting a domain name into an IP address requires DNS, I would investigate:

> **DNS / Application Layer**

Instead of assuming that the entire Internet connection has failed.

---

### Example 2 — FTP File Transfer Has Missing or Corrupted Data

FTP normally uses TCP.

If part of the communication needs reliable end-to-end recovery, the main OSI layer I would associate with this is:

> **Layer 4 — Transport**

because TCP provides mechanisms such as retransmission and sequencing.

I also learned an important nuance:

Layer 2 technologies can detect certain errors on an individual link, but TCP provides end-to-end reliability for the FTP communication.

---

### Example 3 — Wi-Fi Says Connected but the Gateway Cannot Be Reached

Seeing:

```text
Wi-Fi: Connected
```

does not prove that every lower networking layer is functioning correctly.

If I cannot reach my local gateway, I would work upward through:

```text
Layer 1
Signal / interface

Layer 2
Local-link communication

Layer 3
IP address
Subnet configuration
Gateway
```

This is much more useful than randomly changing settings.

---

# ✅ What I Can Explain After Day 5

After today's study, I can now explain:

* why the OSI model exists,
* all seven OSI layers in order,
* what each layer is broadly responsible for,
* how data is encapsulated and decapsulated,
* why data is called a segment, packet, frame or bits at different layers,
* the difference between TCP reliability and network security,
* the basic difference between TCP and UDP,
* why port numbers are needed,
* how IP addresses and MAC addresses solve different addressing problems,
* the basic purpose of HTTP, HTTPS, FTP, DNS, SMTP and SSH,
* the difference between encoding, encryption and compression,
* and how the OSI model can be used to narrow down network problems.

More importantly, I can now take a communication problem and ask:

```text
Where is communication failing?

Physical?
Local link?
IP/routing?
Transport?
Application?
```

That feels much more useful than simply memorizing the names of seven layers.

---

# 💭 Day 5 Reflection

Today connected many of the networking concepts I had already been studying.

Previously I was learning ideas such as:

```text
IP addresses
MAC addresses
Ports
Protocols
```

mostly as individual concepts.

The OSI model gave me a structure for placing them together.

Now I can see communication more like:

```text
Application creates data
        ↓
Transport manages endpoint-to-endpoint delivery
        ↓
Network provides IP addressing and routing
        ↓
Data Link handles the current local link
        ↓
Physical layer transmits the bits
```

The most valuable part of today's learning was not memorizing seven layer names.

It was learning to **trace what happens to data** and beginning to use the same model to reason about failures.

I also corrected several assumptions while studying:

```text
TCP reliable ≠ TCP automatically secure

Wi-Fi connected ≠ every network layer is working

MAC addressing ≠ end-to-end Internet addressing

Encoding ≠ Encryption ≠ Compression
```

Those distinctions made the OSI model much clearer.

---

# 🔜 Next Step — TCP/IP Model

My next networking topic is:

> **TCP/IP Model**

Now that I understand the seven-layer OSI reference model, I want to learn how the TCP/IP model represents real Internet communication and how its layers map back to OSI.

The question I want to answer next is:

```text
OSI gives me seven conceptual layers.

How does the TCP/IP model organize
the same communication in practice?
```

---

## 📌 Networking Journey

```text
Previous Days
     ↓
IP Addressing & Networking Fundamentals
     ↓
Day 5
OSI Model
     ↓
Next
TCP/IP Model
```

> **The goal of this journey is not to collect networking definitions. It is to build enough understanding that I can look at real communication, trace what is happening, identify where something is failing, and explain why.**
