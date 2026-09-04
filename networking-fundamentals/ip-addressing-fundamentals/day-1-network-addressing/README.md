# 🌐 NETWORKING — DAY 01

## Understanding Protocols, Addressing, IPv4, IPv6, MAC Addresses and Ports

**Learning Track:** Networking Fundamentals
**Focus:** Protocols • Addressing • Source & Destination • IP Address • IPv4 • IPv6 • Dotted Decimal Notation • Binary • Hexadecimal • MAC Address • Port Numbers • Ephemeral Ports • OSI Layers • ARPANET

---

> [!IMPORTANT]
>
> ### 💡 The one idea I am taking from Networking Day 1
>
> **Network communication needs both rules and addressing. Protocols define the rules used for communication, while different types of addresses help identify where communication comes from, where it needs to go, and which service should handle it.**
>
> My current mental model is:
>
> ```text
> Communication
>      ↓
> Protocols define the rules
>      ↓
> Addressing identifies source and destination
>      ↓
> Port Number → Which service / endpoint?
>      ↓
> IP Address → Which host / network?
>      ↓
> MAC Address → Which interface on the local network?
> ```

---

# 01 — 📡 What Is a Protocol?

The first concept introduced in today's networking class was **protocol**.

My beginner-friendly understanding is:

> **A protocol is a set of rules that devices follow when communicating with each other.**

Simply connecting two devices does not automatically mean they can understand each other.

Both sides need to follow agreed communication rules.

I relate this to human communication.

If two people speak completely different languages and neither understands the other, communication becomes difficult even though both people can speak and hear.

Networking works in a similar way.

```text
Device A
   ↓
Common Communication Rules
   ↓
Device B
```

Different protocols solve different networking problems.

Some examples I came across are:

| Protocol | Basic Purpose                              |
| -------- | ------------------------------------------ |
| HTTP     | Web communication                          |
| HTTPS    | Secure web communication                   |
| TCP      | Reliable transport communication           |
| UDP      | Transport communication with less overhead |
| IP       | Network-layer communication and addressing |
| DNS      | Helps translate names into IP addresses    |
| DHCP     | Helps devices obtain network configuration |

At this stage, I do not need to master every protocol.

The important idea is:

> **Protocols provide agreed rules that make communication possible.**

---

# 02 — 📍 What Is Addressing?

The word **addressing** became easier for me when I connected it with normal delivery.

If something has to be sent, two important questions appear:

```text
Where is it coming from?
        ↓
SOURCE

Where should it go?
        ↓
DESTINATION
```

So my current understanding is:

> **Network addressing is the mechanism used to identify the source and destination involved in communication.**

Networking does not use only one type of address.

Different layers solve different addressing problems.

The three important identifiers I studied today are:

```text
Port Number
IP Address
MAC Address
```

---

# 03 — 🧱 Different Networking Layers Use Different Identifiers

One important thing I learned is that:

```text
MAC Address ≠ IP Address ≠ Port Number
```

They perform different jobs.

```text
┌────────────────────────────────┐
│ Layer 4 — Transport            │
│                                │
│ PORT NUMBER                    │
│ Which service / endpoint?      │
├────────────────────────────────┤
│ Layer 3 — Network              │
│                                │
│ IP ADDRESS                     │
│ Which host / network?          │
├────────────────────────────────┤
│ Layer 2 — Data Link            │
│                                │
│ MAC ADDRESS                    │
│ Which local network interface? │
└────────────────────────────────┘
```

The simplest way I currently remember them is:

```text
PORT → Service / communication endpoint

IP   → Logical network addressing

MAC  → Local network interface
```

---

# 04 — 💻 Software / Logical and Hardware Addressing

In class, addressing was introduced using two broad categories.

```text
Software / Logical Addressing
├── IP Address
└── Port Number

Hardware / Link Addressing
└── MAC Address
```

This helped me understand the basic difference.

However, I also learned that the technically stronger way to remember them is through their networking layers:

```text
Layer 4 → Port Number

Layer 3 → IP Address

Layer 2 → MAC Address
```

This makes it easier to understand why each one exists.

---

# 05 — 🌍 What Is an IP Address?

**IP** stands for:

> **Internet Protocol**

An IP address is a **logical network address**.

My current understanding is:

> **An IP address helps identify a host or network location involved in communication.**

For example:

```text
192.168.1.10
```

is an example of an IPv4 address.

An IP address is different from a factory hardware identifier because it can change depending on the network and configuration.

---

# 06 — 🔄 Why Can an IP Address Change?

One example discussed in today's class was moving between networks.

Suppose my phone connects to one Wi-Fi network.

Later I disconnect and connect to another network.

I should not expect both networks to give me exactly the same IP configuration.

For example:

```text
Home Wi-Fi
     ↓
One IP configuration

College Wi-Fi
     ↓
Another IP configuration

Mobile Data
     ↓
Another network configuration
```

Initially, I connected IP changes mainly with physical movement.

But I learned that:

> **Physical movement is not required for an IP address to change.**

An IP can also change because of things such as:

* disconnecting and reconnecting,
* changing Wi-Fi networks,
* mobile-network session changes,
* network reassignment,
* provider-side changes,
* network configuration changes.

I also corrected another assumption.

Weak signal does not automatically mean:

```text
Weak Signal = New IP
```

Instead, poor network conditions may contribute to reconnection or session changes, and those events may result in IP reassignment.

---

# 07 — 🔢 What Is IPv4?

**IPv4** stands for:

> **Internet Protocol Version 4**

IPv4 is one version of the Internet Protocol used for Layer 3 addressing and communication.

IPv4 uses:

```text
32 bits
```

A typical IPv4 address looks like:

```text
192.168.1.10
```

The address contains four decimal sections separated by dots.

This format is called:

> **Dotted Decimal Notation**

For example:

```text
192 . 168 . 1 . 10
```

Each section represents 8 bits.

```text
8 bits + 8 bits + 8 bits + 8 bits
              =
           32 bits
```

Each 8-bit section is often called an:

> **Octet**

So an IPv4 address contains four octets.

---

# 08 — 🔢 Why Do We Use Dotted Decimal Notation?

Computers ultimately work using binary values.

The IPv4 address:

```text
192.168.1.10
```

can also be represented as binary:

```text
192       168       1         10

11000000.10101000.00000001.00001010
```

Remembering long strings such as:

```text
11000000101010000000000100001010
```

would be difficult for humans.

So IPv4 addresses are normally written using the human-friendly:

> **Dotted Decimal Notation**

```text
192.168.1.10
```

My current understanding is:

```text
IPv4 Address
     ↓
32-bit value
     ↓
Can be represented in binary
     ↓
Normally written for humans
using dotted decimal notation
```

My mentor introduced the idea of converting decimal IPv4 values into binary, but the detailed conversion will be covered in the next class.

---

# 09 — 🌐 How Many IPv4 Addresses Exist?

IPv4 uses 32 bits.

So the theoretical number of possible combinations is:

```text
2³²
```

which equals:

```text
4,294,967,296
```

or approximately:

> **4.3 billion IPv4 addresses**

At first, this sounds like an enormous number.

But the Internet continued growing.

More devices became connected:

```text
Desktop Computers
       ↓
Laptops
       ↓
Mobile Phones
       ↓
Servers
       ↓
Smart TVs
       ↓
Cloud Systems
       ↓
IoT Devices
```

Eventually, the IPv4 address space became too limited for long-term Internet growth.

This became one of the main reasons for developing IPv6.

---

# 10 — 6️⃣ What Is IPv6?

**IPv6** stands for:

> **Internet Protocol Version 6**

IPv6 is another version of the Internet Protocol.

IPv6 performs the same broad Layer 3 role as IPv4, but it uses a much larger address size.

IPv4 uses:

```text
32 bits
```

IPv6 uses:

```text
128 bits
```

An IPv6 address can look like:

```text
2001:db8:85a3:0000:0000:8a2e:0370:7334
```

Unlike IPv4, which is normally written using dotted decimal notation, IPv6 is normally written using:

> **Hexadecimal notation**

---

# 11 — 🔡 What Is Hexadecimal?

Hexadecimal uses sixteen symbols:

```text
0 1 2 3 4 5 6 7 8 9 A B C D E F
```

IPv6 groups are separated using:

```text
:
```

rather than dots.

Example:

```text
2001:db8:85a3:0000:0000:8a2e:0370:7334
```

IPv6 can also be written in shortened forms.

For example:

```text
2001:db8:85a3::8a2e:370:7334
```

The detailed IPv6 compression rules are something I can learn later.

For Day 1, the important difference is:

```text
IPv4
↓
32 bits
↓
Dotted decimal notation


IPv6
↓
128 bits
↓
Hexadecimal notation
```

---

# 12 — ❓ Why Was IPv6 Needed?

IPv6 was developed largely because IPv4 has a limited address space.

IPv4 theoretically provides approximately:

```text
4.3 billion addresses
```

As Internet usage expanded, billions of devices became connected.

Examples include:

* mobile phones,
* laptops,
* servers,
* cloud infrastructure,
* smart devices,
* cameras,
* TVs,
* IoT devices.

So the basic problem became:

```text
Internet Growth
      ↓
More Connected Devices
      ↓
More IP Addresses Needed
      ↓
IPv4 Address Space Becomes Limited
      ↓
Need for Much Larger Address Space
      ↓
IPv6
```

IPv6 uses 128 bits, giving it an extremely large address space.

---

# 13 — 📱 Are IPv4 and IPv6 Used by Different Devices?

Initially, I wondered whether IPv4 was used by normal laptops and mobile phones while IPv6 was used for some other type of device.

I learned that this is not correct.

The same device can support:

```text
IPv4
+
IPv6
```

at the same time.

For example:

```text
             My Phone
                │
       ┌────────┴────────┐
       ↓                 ↓
     IPv4              IPv6
```

The same phone, laptop or server can communicate using either IPv4 or IPv6 depending on the network and destination.

A system that supports both is commonly described as:

> **Dual Stack**

So:

```text
IPv4 ≠ Old Devices Only

IPv6 ≠ New Devices Only
```

Both are Internet Protocol versions that can exist on the same device.

---

# 14 — 🔍 My IP Observation Task

As part of today's class, my mentor asked me to check my public IP information using an online IP-checking website.

The website showed:

```text
IPv4 Address

IPv6 Address
```

I was asked to observe whether these values change over time.

The real task is not simply copying the address.

The questions I need to investigate are:

> **Does my IPv4 change?**

> **Does my IPv6 change?**

> **How frequently do they change?**

> **Does changing location cause it?**

> **Can the address change even if I remain in the same location?**

> **What happens when I disconnect and reconnect?**

A simple observation table I can use is:

| Test | Connection            | IPv4   | IPv6   | Changed? | Observation       |
| ---- | --------------------- | ------ | ------ | -------- | ----------------- |
| 1    | Mobile Data           | Record | Record | —        | Initial test      |
| 2    | Mobile Data           | Record | Record | Check    | Checked later     |
| 3    | Mobile Data Reconnect | Record | Record | Check    | After reconnect   |
| 4    | Wi-Fi                 | Record | Record | Check    | Different network |

I learned that IP addresses can change because of network reassignment, reconnection, provider behaviour, network changes and session/configuration changes.

Physical distance alone does not determine the IP address.

---

# 15 — 🌎 What Does the IPv4 Shown by an IP Website Mean?

One important thing I learned is that the IPv4 shown by an external IP-checking website may not necessarily be the same IPv4 address I see inside my local network settings.

For example, my laptop may have something like:

```text
192.168.1.20
```

inside my Wi-Fi network.

But an external website may show something different.

The website is generally showing the **public-facing IP information** that it sees when my connection reaches the Internet.

The difference between:

```text
Private IP
```

and:

```text
Public IP
```

is something I want to study properly in a future session.

---

# 16 — 🔌 What Is a MAC Address?

**MAC** stands for:

> **Media Access Control**

A MAC address is associated with a network interface.

For example, my laptop may have:

```text
Wi-Fi Adapter
```

and that adapter has a MAC address.

A MAC address can look like:

```text
00:1A:2B:3C:4D:5E
```

One useful correction to my original understanding is:

> A laptop does not necessarily have only one MAC address.

It may contain several network interfaces.

For example:

```text
Laptop
│
├── Wi-Fi Adapter
│      ↓
│   MAC Address
│
└── Ethernet Adapter
       ↓
    MAC Address
```

So it is more accurate to associate the MAC address with a network interface.

---

# 17 — 🧠 Is a MAC Address Always Permanent?

My initial understanding from class was:

> **The MAC address comes with the physical network hardware and remains permanent.**

This is useful as a beginner explanation.

However, I also learned an important technical detail.

A network interface generally has a factory-assigned MAC address, but modern systems can sometimes:

* override it,
* spoof it,
* randomize it.

Therefore, the better statement is:

> **A network interface commonly has a factory-assigned MAC address, but the address presented to a network can sometimes be changed or randomized by software.**

---

# 18 — 🚪 What Is a Port Number?

Port numbers were another important concept I wanted to understand.

A port number is a logical identifier used at the transport layer.

It helps distinguish different network services and communication endpoints.

Suppose my laptop has one IP:

```text
192.168.1.10
```

but I am using:

```text
Chrome
Telegram
Zoom
Spotify
```

These applications do not each require their own laptop IP address.

The same host IP can support many communications.

Port numbers help distinguish them.

---

# 19 — 🏢 My Building and Room Analogy

The analogy that made ports easier for me was a building.

Suppose several people living in the same apartment building order food.

Everyone may have the same building address.

But the delivery needs to reach the correct room.

So I remember it like this:

```text
Building Address
       ↓
IP Address

Room / Endpoint
       ↓
Port Number
```

The building address gets the delivery to the correct location.

The room number helps identify where inside that location it needs to go.

Similarly:

```text
One Laptop IP
      │
      ├── Chrome communication
      ├── Zoom communication
      ├── Telegram communication
      └── Other communication
```

Port numbers help distinguish different communications.

---

# 20 — ⚠️ A Misunderstanding I Corrected

At one point, I thought:

> **Every application has a different IP address.**

That is not correct.

For example:

```text
Laptop IP
192.168.1.10
       │
       ├── Chrome
       ├── Telegram
       ├── Zoom
       └── Spotify
```

All of these can communicate while the laptop continues using the same host IP address.

This helped me understand why ports are needed.

---

# 21 — 🔢 Port Number Range

Port numbers use 16 bits.

The numerical range is:

```text
0 — 65535
```

The port range is commonly divided into categories.

### Well-Known Ports

```text
0 — 1023
```

Examples:

| Port | Common Service |
| ---: | -------------- |
|   22 | SSH            |
|   53 | DNS            |
|   80 | HTTP           |
|  443 | HTTPS          |

---

### Registered Ports

```text
1024 — 49151
```

These can be associated with particular applications and services.

---

### Dynamic / Ephemeral Ports

```text
49152 — 65535
```

These are commonly used for temporary client-side communication.

---

# 22 — ⏳ What Is an Ephemeral Port?

The word **ephemeral** means:

> **Temporary or short-lived.**

Suppose my laptop has:

```text
IP:
192.168.1.10
```

and Chrome starts a connection.

My operating system might assign a temporary source port such as:

```text
54231
```

Together, they can be written:

```text
192.168.1.10:54231
```

The colon is important.

Correct:

```text
192.168.1.10:54231
```

Incorrect:

```text
192.168.1.10.54231
```

The dots are part of the IPv4 address.

The colon separates:

```text
IP : PORT
```

---

# 23 — 🌐 Client Port vs Service Port

Suppose my browser accesses an HTTPS service.

My side might temporarily use:

```text
192.168.1.10:54231
```

while the destination service uses:

```text
Server-IP:443
```

Here:

```text
192.168.1.10
```

is my laptop IP.

```text
54231
```

is a temporary source port.

```text
443
```

is the commonly used HTTPS destination port.

One misunderstanding I corrected was:

> **443 is Google's IP address.**

That is incorrect.

`443` is a:

> **Port number**

commonly associated with HTTPS.

---

# 24 — 🔄 Can Port Numbers Change?

Yes.

Suppose a browser communication currently uses:

```text
54231
```

as its temporary client-side port.

If I close the application and later reconnect, it is not guaranteed to use exactly the same port again.

The operating system can select another available temporary port.

For example:

```text
First Communication
192.168.1.10:54231

Later Communication
192.168.1.10:52791
```

My current understanding is:

```text
Client Ports
→ Often temporary

Server / Service Ports
→ Often predictable or configured
```

A server port can also be configured differently, so ports are not permanent hardware identifiers.

---

# 25 — 🧠 IP vs Port vs MAC

My current comparison is:

| Identifier  | Layer               | Main Purpose                                 |
| ----------- | ------------------- | -------------------------------------------- |
| Port Number | Layer 4 — Transport | Identify service / communication endpoint    |
| IP Address  | Layer 3 — Network   | Logical network addressing                   |
| MAC Address | Layer 2 — Data Link | Identify network interface on the local link |

My easiest mental model is:

```text
IP
↓
Which building / network location?

PORT
↓
Which room / service?

MAC
↓
Which network interface locally?
```

So:

```text
MAC ≠ IP ≠ PORT
```

Each one exists to solve a different networking problem.

---

# 26 — 🛰️ ARPANET

Today's class also introduced the history of networking.

**ARPANET** stands for:

> **Advanced Research Projects Agency Network**

ARPANET was an early computer network funded by the United States Department of Defense's:

> **Advanced Research Projects Agency — ARPA**

It connected research institutions involved in ARPA-funded work and played an important role in the development of modern computer networking.

A simplified timeline is:

```text
1960s
Networking Research
      ↓
1969
ARPANET Begins Operating
      ↓
1970s
Networking and TCP/IP Research Develops
      ↓
1983
ARPANET Transitions to TCP/IP
      ↓
Modern Internet Networking Continues Growing
      ↓
1990
ARPANET Is Retired
```

One important distinction I learned is:

```text
ARPANET ≠ DARPA
```

ARPANET was the network.

ARPA was the agency.

The agency later became known as:

> **DARPA — Defense Advanced Research Projects Agency**

So:

```text
Agency
ARPA → DARPA

Network
ARPANET
```

---

# 27 — 🔎 Important Corrections From Today's Learning

Today's learning helped me correct several assumptions.

### ❌ Earlier Thought

Every application needs its own IP address.

### ✅ Corrected Understanding

Multiple applications can communicate while using the same host IP address. Ports help distinguish transport-layer communication.

---

### ❌ Earlier Thought

`443` can be an IP address.

### ✅ Corrected Understanding

`443` is a port number commonly associated with HTTPS.

---

### ❌ Earlier Thought

IP and port should be written using only dots.

### ✅ Corrected Understanding

The common notation is:

```text
IP:PORT
```

Example:

```text
192.168.1.10:54231
```

---

### ❌ Earlier Thought

A temporary client port belongs permanently to an application.

### ✅ Corrected Understanding

Temporary ports can change and can later be reused.

---

### ❌ Earlier Thought

A MAC address can never change.

### ✅ Corrected Understanding

Network hardware commonly has a factory-assigned MAC address, but software can sometimes override, spoof or randomize it.

---

### ❌ Earlier Thought

Physical movement is required for an IP address to change.

### ✅ Corrected Understanding

Network reassignment, reconnection, provider behaviour and network configuration changes can also result in a different IP.

---

### ❌ Earlier Thought

IPv4 is for one type of device and IPv6 is for another.

### ✅ Corrected Understanding

The same phone, laptop, server or other system can support both IPv4 and IPv6.

---

# 28 — 🔐 Why This Matters for Cybersecurity

I am learning networking as part of my cybersecurity journey.

Networking concepts such as:

```text
Source IP
Destination IP
Source Port
Destination Port
Protocol
MAC Address
```

appear frequently in cybersecurity.

Understanding them will later help me understand:

* firewall rules,
* network logs,
* suspicious connections,
* scanning,
* service exposure,
* network monitoring,
* intrusion detection,
* security investigations.

Before identifying abnormal communication, I first need to understand what normal network addressing means.

---

# 29 — 🧠 My Networking Day 1 Mental Model

After today's class and my follow-up learning, this is the model I want to remember:

```text
                 NETWORKING
                     │
                     ▼
                 PROTOCOLS
          Rules for communication
                     │
                     ▼
                 ADDRESSING
            Source + Destination
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
      PORT           IP           MAC
     Layer 4       Layer 3       Layer 2
        │            │            │
   Service /      Logical       Local
   Endpoint       Network      Interface
                     │
             ┌───────┴───────┐
             ▼               ▼
           IPv4             IPv6
             │               │
          32 bits         128 bits
             │               │
      Dotted Decimal     Hexadecimal
```

---

# 30 — 🎯 What I Want to Learn Next

Today's class gave me the basic addressing foundation.

The next concepts I want to understand gradually are:

```text
Decimal to Binary Conversion

Binary to Decimal Conversion

IPv4 Address Structure

IPv6 Address Structure

Public IP vs Private IP

Static IP vs Dynamic IP

Subnet Mask

Default Gateway

DHCP

NAT

CGNAT

ARP

OSI Model

TCP/IP Model
```

I want to learn these slowly and understand how they connect instead of memorising definitions separately.

---

# 📌 Day 1 Recap

My main takeaways from Networking Day 1 are:

```text
Protocol
→ Rules used for communication

Addressing
→ Identifies source and destination

IP Address
→ Layer 3 logical network addressing

IPv4
→ Internet Protocol Version 4
→ 32 bits
→ Dotted decimal notation

IPv6
→ Internet Protocol Version 6
→ 128 bits
→ Hexadecimal notation

MAC Address
→ Layer 2 local network interface addressing

Port Number
→ Layer 4 transport identifier

Ephemeral Port
→ Temporary client-side port

ARPANET
→ Advanced Research Projects Agency Network
```

The biggest improvement in my understanding today is that I no longer see:

```text
IPv4
IPv6
IP
MAC
Port
```

as unrelated terms that I need to memorise.

I am starting to understand **why each one exists and which networking problem each one solves.**
