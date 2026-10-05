# 🌐 Day 19 — ARP 2: Layer 2, Ethernet and MAC Learning

## 📌 Today's Focus

Today I continued my understanding of **ARP** by looking deeper into what happens at **Layer 2 — the Data Link Layer** of the OSI model.

The main topics I covered were:

* Layer 2 — Data Link Layer
* Ethernet
* MAC addresses
* 48-bit MAC address structure
* OUI — Organizationally Unique Identifier
* Identifying a device manufacturer using its MAC address
* Switches
* MAC address tables
* Switch port learning
* ARP broadcast
* ARP reply
* Broadcast vs unicast
* How ARP and Ethernet switching work together

This lesson connected directly with my previous **Day 12 ARP** learning.

---

# 🧠 Layer 2 — Data Link Layer

Layer 2 of the OSI model is called the **Data Link Layer**.

One of its major responsibilities in Ethernet networks is local delivery using **MAC addresses**.

```text
OSI Layer 3
IP Address
     │
     ▼
OSI Layer 2
MAC Address
     │
     ▼
Physical transmission
```

IP addresses help identify devices across networks.

MAC addresses are used to deliver Ethernet frames across the current local network or Layer 2 link.

---

# 🌐 Ethernet

**Ethernet** is one of the most widely used Layer 2 networking technologies.

It is heavily used in:

```text
LAN — Local Area Network
MAN — Metropolitan Area Network
WAN — Wide Area Network
```

Ethernet is most commonly associated with LANs, but Ethernet technologies can also be used by service providers across metropolitan and wide-area networks.

Ethernet speeds can include:

```text
10 Mbps
100 Mbps
1 Gbps
10 Gbps
and higher
```

For example:

```text
1 Gbps = 1 Gigabit per second
```

This describes the link's theoretical transmission rate, not necessarily the actual application download speed.

---

# 🌍 Other Layer 2 Technologies

Ethernet is not the only technology associated with Layer 2 communication.

Some WAN technologies and protocols include:

* **PPP — Point-to-Point Protocol**
* **HDLC — High-Level Data Link Control**
* **L2TP — Layer 2 Tunneling Protocol**

PPP and HDLC have historically been used on point-to-point WAN links.

L2TP is a tunneling protocol used to carry Layer 2 traffic across another network.

Compared with modern high-speed Ethernet links, older WAN links were often associated with lower bandwidth.

---

# 🪪 MAC Address

A **MAC address** is a Layer 2 hardware address used for communication on an Ethernet network.

MAC stands for:

> **Media Access Control**

A traditional Ethernet MAC address contains:

```text
48 bits
```

Because hexadecimal represents four bits per digit:

```text
48 bits ÷ 4 = 12 hexadecimal digits
```

Example:

```text
00:1A:2B:3C:4D:5E
```

---

# 🔢 MAC Address Structure

A MAC address is commonly explained as two sections:

```text
48-bit MAC Address

┌──────────────────────┬──────────────────────┐
│ First 24 bits        │ Last 24 bits         │
│ OUI                  │ Device-specific part │
└──────────────────────┴──────────────────────┘
```

Example:

```text
00:1A:2B : 3C:4D:5E
────────   ────────
   OUI       Device
             portion
```

---

# 🏢 OUI — Organizationally Unique Identifier

**OUI** stands for:

> **Organizationally Unique Identifier**

The OUI is traditionally the first **24 bits** of a MAC address assigned to an organization/vendor.

It can help identify the manufacturer associated with a MAC address block.

For example:

```text
MAC Address
00:50:56:XX:XX:XX

First 24 bits
00:50:56
```

An OUI lookup can reveal which organization owns that prefix.

---

# 🔍 Practical — Finding My MAC Address

On Windows I used:

```cmd
ipconfig /all
```

This command displays detailed network configuration information including:

```text
IPv4 Address
Subnet Mask
Default Gateway
DNS Servers
Physical Address
```

The **Physical Address** shown for a network adapter is its MAC address.

Example:

```text
Physical Address . . . . . : 00-1A-2B-3C-4D-5E
```

---

# 🔎 OUI Lookup

After identifying a MAC address, I learned that I can take its OUI portion and use an **OUI lookup tool** to identify the organization associated with it.

The Wireshark website provides an OUI lookup tool.

Conceptually:

```text
MAC Address
     │
     ▼
Extract OUI
First 24 bits
     │
     ▼
OUI Lookup
     │
     ▼
Possible manufacturer/vendor
```

This can provide clues about what kind of device may be present on a network.

However, the MAC address normally does **not guarantee the exact device model**.

It mainly helps identify the vendor or organization associated with that MAC prefix.

---

# 🔀 Switches at Layer 2

A traditional Ethernet switch primarily works at:

```text
OSI Layer 2
Data Link Layer
```

The switch examines MAC addresses to decide through which port an Ethernet frame should be forwarded.

For example:

```text
PC1 ───── Fa0/1
             │
         ┌───▼────┐
         │ Switch │
         └───┬────┘
             │
PC2 ───── Fa0/2

PC3 ───── Fa0/3
```

To perform efficient forwarding, the switch maintains a table.

---

# 📒 MAC Address Table

The switch maintains a:

> **MAC Address Table**

It is also commonly called a:

> **CAM Table**

CAM stands for:

> **Content Addressable Memory**

A simplified table might look like:

| MAC Address      | Switch Port |
| ---------------- | ----------- |
| `AAAA.AAAA.AAAA` | `Fa0/1`     |
| `BBBB.BBBB.BBBB` | `Fa0/2`     |
| `CCCC.CCCC.CCCC` | `Fa0/3`     |

The important mapping is:

```text
MAC Address → Switch Port
```

The switch does **not normally store IP-to-MAC mappings in this Layer 2 MAC table**.

That is the job of ARP on hosts and routers.

---

# 🧩 ARP Table vs MAC Address Table

This was the most important distinction from today's lesson.

## Computer ARP Cache

A computer maintains:

```text
IP Address → MAC Address
```

Example:

```text
192.168.1.3 → CC:CC:CC:CC:CC:CC
```

This answers:

> Which MAC address belongs to this IPv4 address?

---

## Switch MAC Address Table

A switch maintains:

```text
MAC Address → Switch Port
```

Example:

```text
CC:CC:CC:CC:CC:CC → Fa0/3
```

This answers:

> Through which switch port can I reach this MAC address?

---

## Router Routing Table

A router maintains routing information such as:

```text
Destination Network → Next Hop / Exit Interface
```

Therefore:

| Device      | Table         | Main Mapping                 |
| ----------- | ------------- | ---------------------------- |
| PC / Router | ARP Cache     | IPv4 → MAC                   |
| Switch      | MAC/CAM Table | MAC → Port                   |
| Router      | Routing Table | Network → Next Hop/Interface |

---

# 🧪 My Three-PC Switch Lab

I created a simple network with:

```text
PC1
 │
 │ Fa0/1
 │
┌▼──────────────┐
│    Switch     │
└┬──────┬───────┘
 │      │
 │      │
PC2    PC3
Fa0/2  Fa0/3
```

Suppose PC1 wants to ping PC3.

Initially:

```text
PC1 knows PC3's IP address.

But...

PC1 may not know PC3's MAC address.
```

Before PC1 can send the actual ICMP Echo Request through Ethernet, it needs the destination MAC address.

This causes ARP resolution.

---

# 🔄 Step 1 — PC1 Checks Its ARP Cache

PC1 first checks whether it already has an entry such as:

```text
PC3 IP → PC3 MAC
```

If the MAC address is already cached, ARP does not need to run again immediately.

If the mapping is missing, PC1 sends an ARP Request.

---

# 📢 Step 2 — PC1 Creates the ARP Broadcast

PC1 asks:

```text
Who has PC3's IP address?
```

The Ethernet destination MAC becomes:

```text
FF:FF:FF:FF:FF:FF
```

This is the Ethernet **broadcast MAC address**.

An important point I understood today is:

> The switch does not decide that the ARP Request should become a broadcast.

The source PC itself creates the Ethernet frame with:

```text
Destination MAC:
FF:FF:FF:FF:FF:FF
```

The switch receives an Ethernet frame that is already addressed as a broadcast.

---

# 🧠 Step 3 — The Switch Learns PC1's MAC

When the ARP frame arrives through:

```text
Fa0/1
```

the switch examines the **source MAC address**.

Suppose PC1 has:

```text
AA:AA:AA:AA:AA:AA
```

The switch learns:

```text
AA:AA:AA:AA:AA:AA → Fa0/1
```

and adds it to its MAC address table.

---

# ⭐ Core Switch Learning Rule

A major concept I learned is:

> **A switch learns MAC addresses by examining the SOURCE MAC address of frames arriving on its ports.**

Conceptually:

```text
Frame arrives on Fa0/1
        │
        ▼
Source MAC = AA:AA:AA:AA:AA:AA
        │
        ▼
Switch learns
        │
        ▼
AA:AA:AA:AA:AA:AA → Fa0/1
```

The source MAC tells the switch:

> “This MAC address can be reached through the port from which this frame arrived.”

---

# 📡 Step 4 — The Switch Floods the ARP Broadcast

The switch sees:

```text
Destination MAC:
FF:FF:FF:FF:FF:FF
```

Because it is a Layer 2 broadcast, the switch floods it through the other relevant ports in the same broadcast domain.

```text
                Switch
              /        \
             /          \
           PC2          PC3
```

The frame is not normally sent back out through the same port from which it entered.

Therefore:

```text
PC broadcasts the frame.

Switch floods the broadcast frame.
```

These are related but different actions.

---

# 👀 Step 5 — PCs Examine the ARP Request

PC2 receives the broadcast.

It checks the target IPv4 address.

If the requested address does not belong to PC2:

```text
PC2 ignores the request.
```

PC3 also receives the broadcast.

PC3 sees:

```text
Requested IP = My IP
```

Therefore PC3 prepares an ARP Reply.

---

# 📩 Step 6 — PC3 Sends an ARP Reply

PC3 responds with information equivalent to:

```text
That IP address belongs to my MAC address.
```

Unlike the ARP Request, the normal ARP Reply is usually:

```text
UNICAST
```

It is sent directly toward PC1's MAC address.

Example:

```text
Source MAC:
CC:CC:CC:CC:CC:CC

Destination MAC:
AA:AA:AA:AA:AA:AA
```

---

# 🧠 Step 7 — Switch Learns PC3's MAC

When PC3's reply enters the switch through `Fa0/3`, the switch examines its source MAC.

It learns:

```text
CC:CC:CC:CC:CC:CC → Fa0/3
```

The MAC table may now look like:

| MAC Address         | Port    |
| ------------------- | ------- |
| `AA:AA:AA:AA:AA:AA` | `Fa0/1` |
| `CC:CC:CC:CC:CC:CC` | `Fa0/3` |

Notice that PC2 may still be missing.

Why?

Because the switch learns from **source MAC addresses of frames it receives**.

If PC2 has not transmitted a frame, the switch has not yet learned where PC2 is located.

---

# 💾 Step 8 — PC1 Updates Its ARP Cache

PC1 receives PC3's ARP Reply.

PC1 can now store:

```text
PC3 IP → PC3 MAC
```

Example:

```text
192.168.1.3 → CC:CC:CC:CC:CC:CC
```

Now PC1 knows both:

```text
Destination IP
Destination MAC
```

---

# 🏓 Step 9 — The Actual Ping Happens

ARP itself is not the ping.

ARP resolves the required Layer 2 address first.

After ARP resolution:

```text
PC1
 │
 │ ICMP Echo Request
 ▼
Switch
 │
 ▼
PC3
```

PC1 creates an Ethernet frame containing:

```text
Source MAC      = PC1 MAC
Destination MAC = PC3 MAC
```

Inside that frame, the IP packet contains:

```text
Source IP      = PC1 IP
Destination IP = PC3 IP
```

Inside the IP packet is the:

```text
ICMP Echo Request
```

---

# 🚚 How the Switch Forwards the Ping

The switch receives the frame and checks the:

```text
Destination MAC
```

Suppose it sees:

```text
CC:CC:CC:CC:CC:CC
```

It searches its MAC table:

```text
CC:CC:CC:CC:CC:CC → Fa0/3
```

The switch now knows exactly where the destination is located.

Instead of flooding the frame everywhere, it forwards it only through:

```text
Fa0/3
```

This is normal **unicast forwarding**.

---

# 🔁 Complete ARP + Switching Flow

```text
PC1 wants to ping PC3
        │
        ▼
PC1 checks ARP cache
        │
        ▼
Does PC1 know PC3 MAC?
        │
       NO
        │
        ▼
PC1 sends ARP Request
Destination MAC:
FF:FF:FF:FF:FF:FF
        │
        ▼
Switch receives frame
        │
        ├── Learns PC1 MAC → Fa0/1
        │
        ▼
Switch floods ARP broadcast
        │
        ├────► PC2
        │
        └────► PC3
                 │
                 ▼
          PC3 recognizes its IP
                 │
                 ▼
          PC3 sends ARP Reply
               Unicast
                 │
                 ▼
        Switch receives reply
                 │
                 ├── Learns PC3 MAC → Fa0/3
                 │
                 ▼
        PC1 receives ARP Reply
                 │
                 ▼
        PC1 stores:
        PC3 IP → PC3 MAC
                 │
                 ▼
        ICMP Echo Request
                 │
                 ▼
        Switch checks MAC table
                 │
                 ▼
        Sends frame only to Fa0/3
                 │
                 ▼
                PC3
```

---

# 📣 Broadcast vs Unicast

## Broadcast

A broadcast is intended for devices within the local Layer 2 broadcast domain.

Ethernet broadcast MAC:

```text
FF:FF:FF:FF:FF:FF
```

Example:

```text
ARP Request → Broadcast
```

---

## Unicast

A unicast frame is intended for one specific destination MAC address.

Example:

```text
ARP Reply → normally unicast
ICMP traffic after ARP resolution → unicast Ethernet frames
```

---

# 💻 Cisco Switch Command

In Cisco IOS I used:

```text
Switch> enable
Switch# show mac address-table
```

This displays the switch's learned MAC addresses and the ports associated with them.

A simplified output may look like:

```text
Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
1       aaaa.aaaa.aaaa    DYNAMIC     Fa0/1
1       cccc.cccc.cccc    DYNAMIC     Fa0/3
```

The important information is:

```text
MAC Address → Port
```

---

# 🔍 Dynamic MAC Learning

The entries learned automatically by the switch are normally shown as:

```text
DYNAMIC
```

This means the switch learned them by observing Ethernet frames rather than having them manually configured.

The process is:

```text
Frame arrives
      │
      ▼
Read source MAC
      │
      ▼
Associate source MAC
with incoming port
      │
      ▼
Store/update MAC table
```

---

# 🧠 ARP and Switching Work Together

This lesson helped me understand that ARP and Ethernet switching solve two different problems.

ARP answers:

```text
I know the IP address.
What is its MAC address?
```

The switch answers:

```text
I know the MAC address.
Which port should I use?
```

Combined:

```text
Destination IP
      │
      │ ARP
      ▼
Destination MAC
      │
      │ Switch MAC Table
      ▼
Destination Switch Port
```

This was the main connection I was missing earlier.

---

# 🌐 Same Network vs Different Network

The three-PC lab works without a router because all devices are assumed to be inside the same subnet.

Example:

```text
PC1: 192.168.1.1/24
PC2: 192.168.1.2/24
PC3: 192.168.1.3/24
```

PC1 can ARP directly for PC3.

But if PC1 wants to communicate with:

```text
8.8.8.8
```

PC1 does not ARP for the MAC address of `8.8.8.8`.

Instead it sends the packet toward its **default gateway**.

It may use ARP to learn:

```text
Default Gateway IP → Router MAC
```

This connects today's Layer 2 lesson with my previous routing labs.

---

# ⚠️ Important Corrections I Learned

### 1. The switch does not store IP → MAC mappings in its normal MAC table

Incorrect:

```text
Switch:
IP → MAC
```

Correct:

```text
PC/Router ARP cache:
IP → MAC

Switch MAC table:
MAC → Port
```

---

### 2. The switch does not create the ARP broadcast

The PC creates an Ethernet frame addressed to:

```text
FF:FF:FF:FF:FF:FF
```

The switch then **floods** that broadcast.

---

### 3. A switch learns from the source MAC

The main learning rule is:

```text
Incoming Source MAC
        +
Incoming Switch Port
        │
        ▼
MAC Address Table
```

The destination MAC is mainly used to decide where the frame should be forwarded.

---

### 4. ARP does not send the actual ping

The sequence is:

```text
ARP resolution
      ↓
MAC address learned
      ↓
ICMP Echo Request
      ↓
ICMP Echo Reply
```

ARP prepares the Layer 2 information required before the actual ICMP exchange.

---

### 5. OUI does not always reveal the exact device

An OUI lookup can identify the organization associated with a MAC prefix.

It does not reliably tell me:

```text
Exact laptop model
Exact phone model
Exact operating system
Exact user
```

It is mainly a vendor/manufacturer clue.

---

# 🔐 Why This Matters for Cybersecurity

Understanding MAC addresses and switches is important because many attacks and security controls operate inside the local network.

Examples include:

* ARP spoofing
* ARP poisoning
* Man-in-the-middle attacks
* MAC flooding
* Rogue devices
* Network reconnaissance
* VLAN attacks
* Switch security
* Dynamic ARP Inspection
* DHCP Snooping
* Port Security

Before learning these attacks, I need to understand normal Layer 2 behaviour.

If I know how:

```text
ARP should work
MAC learning should work
Switch forwarding should work
```

then abnormal Layer 2 behaviour becomes easier to recognize.

---

# 🧠 My Day 19 Takeaway

My biggest understanding from today's lesson is:

```text
PC:
IP → MAC

Switch:
MAC → Port

Router:
Network → Next Hop
```

When PC1 wants to communicate with PC3:

```text
ARP discovers PC3's MAC
        ↓
Switch learns device MAC locations
        ↓
Switch forwards Ethernet frames
        ↓
Actual ICMP communication happens
```

The most important switch rule I learned is:

> **A switch learns a device's MAC address from the source MAC address of frames arriving on a switch port.**

And the biggest connection to my previous ARP lesson is:

> **ARP tells the computer which MAC address to use, while the switch MAC table tells the switch which port leads to that MAC address.**

---

## ⚡ Quick Review

```text
Layer 2              → Data Link Layer

Ethernet             → Layer 2 networking technology

MAC Address           → 48-bit Layer 2 address

OUI                   → Organizationally Unique Identifier

OUI size              → Traditionally first 24 bits

ARP                   → IPv4 address → MAC address

ARP Request           → Broadcast

Broadcast MAC         → FF:FF:FF:FF:FF:FF

ARP Reply             → Normally unicast

Switch learns from    → Source MAC address

Switch MAC Table      → MAC address → Port

Cisco command         → show mac address-table

Ping                  → ICMP

Same subnet           → Communicate through Layer 2 switch

Different subnet      → Send toward default gateway
```

---

## 🔗 Connection to Previous Learning

This lesson extends:

```text
Day 12 — Address Resolution Protocol
```

Day 12 answered:

> How does a computer discover a MAC address from an IPv4 address?

Day 19 added:

> After the computer learns that MAC address, how does the Ethernet switch know where to send the frame?

Together:

```text
IP Address
     │
    ARP
     ▼
MAC Address
     │
Switch MAC Table
     ▼
Switch Port
     │
     ▼
Destination Device
```

That completes the Layer 2 delivery picture I was trying to understand.
