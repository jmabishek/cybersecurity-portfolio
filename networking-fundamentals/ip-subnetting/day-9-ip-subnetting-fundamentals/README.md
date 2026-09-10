# 🌐 IP Subnetting Foundations

## Day 9 — Networking Fundamentals

Today I focused on building a strong foundation in **IPv4 subnetting**.

Before starting subnetting, I briefly reviewed the **UDP header and UDP characteristics**, which connected quickly with my previous packet-capture work in Wireshark.

The main focus of today's learning was understanding:

- Why subnetting exists
- How IP address space can be divided efficiently
- Network and host portions of an IP address
- Network and broadcast addresses
- Usable host addresses
- Block sizes
- Subnet boundaries
- Basic CIDR notation such as `/24` and `/26`
- Basic subnet-mask concepts
- How a device determines whether another IP is local or on a different network
- How routers become involved when communicating between different subnets

---

# 1. Quick UDP Review

UDP stands for:

**User Datagram Protocol**

UDP is a **connectionless transport-layer protocol**.

Unlike TCP, UDP does not:

- Establish a connection before sending data
- Perform a three-way handshake
- Guarantee packet delivery
- Guarantee packet ordering
- Retransmit lost packets
- Acknowledge every packet

UDP focuses on:

- Low latency
- Low overhead
- Fast transmission
- Best-effort delivery

This makes UDP useful where speed is more important than perfect delivery.

Examples include:

- DNS
- DHCP
- SNMP
- TFTP
- VoIP
- Online gaming
- Video/audio streaming

---

## UDP Header

The UDP header contains four fields.

```text
┌────────────────────────┬────────────────────────┐
│ Source Port            │ Destination Port       │
│ 16 bits                │ 16 bits                │
├────────────────────────┼────────────────────────┤
│ Length                 │ Checksum               │
│ 16 bits                │ 16 bits                │
└────────────────────────┴────────────────────────┘
```

Each field is 16 bits.

Therefore:

```text
4 × 16 bits = 64 bits
64 bits = 8 bytes
```

So the UDP header size is:

**8 bytes**

---

## TCP vs UDP — Simple Mental Model

```text
TCP
│
├── Reliable
├── Connection-oriented
├── Ordered delivery
├── Acknowledgements
└── More overhead


UDP
│
├── Connectionless
├── Best-effort delivery
├── No ordering guarantee
├── No handshake
└── Low overhead / low latency
```

I had already captured TCP and UDP traffic in Wireshark during previous networking sessions, so today's UDP section was mainly a quick reinforcement before moving into subnetting.

---

# 2. What Is Subnetting?

My interview-ready definition:

> **Subnetting is the process of dividing a larger IP network into smaller logical networks called subnets to improve IP address utilization, network management, routing, and segmentation.**

A simpler mental model:

```text
Large Network
      │
      ▼
Divide it
      │
      ▼
Smaller Networks
      │
      ▼
Subnets
```

---

# 3. Why Does Subnetting Exist?

One of the major reasons is:

**Efficient IP address management.**

Imagine an organization has:

```text
HQ       = 200 computers
Branch 1 = 50 computers
Branch 2 = 25 computers
Branch 3 = 10 computers
```

If every department were given a network with 254 usable addresses, a huge number of IP addresses would remain unused.

For example:

```text
Branch 3 needs only 10 computers.

If it receives 254 usable IPs:

254 - 10 = 244 unused IPs
```

That is inefficient.

Subnetting allows us to create appropriately sized networks instead.

Example:

```text
HQ       → 254 usable hosts
Branch 1 → 62 usable hosts
Branch 2 → 30 usable hosts
Branch 3 → 14 usable hosts
```

This greatly reduces wasted address space.

---

# 4. Other Benefits of Subnetting

Subnetting is not only about saving IP addresses.

It also helps with:

### Network organization

Different departments can have separate logical networks.

```text
                 Router
               /   |   \
              /    |    \
            HR     IT   Finance
             │      │      │
          Subnet  Subnet  Subnet
```

### Network segmentation

Departments or systems can be separated logically.

### Routing

Routers can route traffic between different subnets.

### Broadcast control

Smaller broadcast domains reduce unnecessary broadcast traffic.

### Security

Different network segments can have different policies and controls.

---

# 5. IPv4 Has 32 Bits

An IPv4 address contains:

**32 bits**

It is divided into four octets.

```text
192 . 168 . 1 . 173
 │     │     │    │
8bit  8bit  8bit 8bit
```

Therefore:

```text
8 + 8 + 8 + 8 = 32 bits
```

---

# 6. Network Part and Host Part

An IPv4 address logically contains two parts:

```text
┌───────────────────────┬───────────────────────┐
│ Network Portion       │ Host Portion          │
└───────────────────────┴───────────────────────┘
```

The:

**Network portion**

identifies the network.

The:

**Host portion**

identifies an individual device inside that network.

---

# 7. What Does `/24` Mean?

An address may be written like:

```text
192.168.1.10/24
```

The `/24` is called the:

**CIDR prefix length**

CIDR stands for:

**Classless Inter-Domain Routing**

`/24` means:

> The first 24 bits are network bits.

IPv4 contains 32 bits total.

Therefore:

```text
32 total bits
-24 network bits
----------------
 8 host bits
```

So:

```text
/24

Network bits = 24
Host bits    = 8
```

---

# 8. What Does `/26` Mean?

Same logic:

```text
/26
```

means:

```text
26 network bits
```

IPv4 has 32 bits.

Therefore:

```text
32 - 26 = 6
```

So:

```text
Network bits = 26
Host bits    = 6
```

---

# 9. Host Bits Determine Address Capacity

The number of addresses available is:

```text
2^(number of host bits)
```

For `/24`:

```text
32 - 24 = 8 host bits

2^8 = 256 addresses
```

For `/26`:

```text
32 - 26 = 6 host bits

2^6 = 64 addresses
```

Therefore:

```text
/24 → 256 total addresses
/25 → 128 total addresses
/26 → 64 total addresses
/27 → 32 total addresses
/28 → 16 total addresses
/29 → 8 total addresses
/30 → 4 total addresses
```

---

# 10. Why Are Two Addresses Normally Reserved?

For the traditional subnetting examples I practiced today, two addresses in each subnet have special purposes.

### Network Address

The first address identifies the subnet itself.

### Broadcast Address

The last address is used to address all hosts in that subnet.

Therefore:

```text
Usable Hosts
=
Total Addresses - 2
```

Example:

```text
64 total addresses

64 - 2 = 62 usable host addresses
```

---

# 11. Network Address, Host Range and Broadcast

Suppose a block contains:

```text
192.168.1.128 → 192.168.1.191
```

Then:

```text
Network Address:
192.168.1.128

First Usable Host:
192.168.1.129

Last Usable Host:
192.168.1.190

Broadcast Address:
192.168.1.191
```

Visual representation:

```text
192.168.1.128
      │
      │ Network Address
      ▼
┌──────────────────────────────────┐
│ 129                              │
│ 130                              │
│ ...                              │
│ 189                              │
│ 190                              │
└──────────────────────────────────┘
      ▲
      │ Usable Hosts

192.168.1.191
      │
      └── Broadcast Address
```

---

# 12. Block Sizes

Subnet sizes occur in powers of two.

Important values:

```text
256
128
64
32
16
8
4
2
1
```

These come from binary:

```text
2^8 = 256
2^7 = 128
2^6 = 64
2^5 = 32
2^4 = 16
2^3 = 8
2^2 = 4
2^1 = 2
2^0 = 1
```

---

# 13. Selecting a Block Size

I learned not to simply choose the mathematically closest number.

Instead:

> **Choose the smallest power-of-two block that is large enough for the required hosts plus the network and broadcast addresses.**

Example:

```text
Hosts required = 50
```

Account for:

```text
50 hosts
+ 1 Network Address
+ 1 Broadcast Address
---------------------
52 addresses required
```

Available blocks:

```text
32 ❌ Too small
64 ✅ Enough
128
256
```

Therefore:

```text
Block size = 64
```

Usable hosts:

```text
64 - 2 = 62
```

---

# 14. Understanding Subnet Boundaries

This was one of the most important concepts I learned today.

A subnet cannot start at any random IP address.

Its starting point depends on its block size.

For example:

```text
Block Size = 16
```

The address space is divided into:

```text
0–15
16–31
32–47
48–63
64–79
80–95
96–111
112–127
128–143
144–159
...
```

Therefore valid network starting positions include:

```text
0
16
32
48
64
80
96
112
128
144
...
```

---

# 15. Why `.120` Cannot Start a 16-Address Subnet

Consider:

```text
112–127
```

That is already one complete 16-address block.

`.120` is inside that block.

```text
112                     127
│                         │
├─────────────────────────┤
        one subnet
         ↑
        120
```

Therefore `.120` cannot become the beginning of another overlapping 16-address subnet.

The next valid 16-address boundary is:

```text
128
```

---

# 16. Block Size Determines Boundaries

An important realization:

The same number may be valid for one block size and invalid for another.

Example:

For block size `8`:

```text
112–119
120–127
128–135
```

Therefore:

```text
120 ✅ valid starting point
```

But for block size `16`:

```text
112–127
128–143
```

Therefore:

```text
120 ❌ not a valid starting point
```

So:

> **Whether an address is a valid network address depends on the subnet/block size.**

---

# 17. Finding Boundaries

A simple method I practiced:

If:

```text
Block size = 16
```

start from zero and keep adding 16:

```text
0
16
32
48
64
80
96
112
128
...
```

If:

```text
Block size = 32
```

then:

```text
0
32
64
96
128
160
192
224
```

Those values represent valid starting boundaries.

---

# 18. Broadcast and Next Network Formula

One small calculation that I need to remember:

```text
Broadcast
=
Network Address + Block Size - 1
```

And:

```text
Next Network
=
Network Address + Block Size
```

Example:

```text
Network = 128
Block = 64
```

Then:

```text
Next Network
= 128 + 64
= 192
```

Broadcast:

```text
192 - 1 = 191
```

Therefore:

```text
Network   = 128
Broadcast = 191
Next      = 192
```

---

# 19. Practical Organization Example

The example I worked through involved:

```text
HQ       → 200 hosts
Branch 1 → 50 hosts
Branch 2 → 25 hosts
Branch 3 → 10 hosts
```

A more efficient allocation could look like:

```text
HQ:
192.168.0.0

254 usable addresses
200 required
54 spare
```

For Branch 1:

```text
50 hosts required

50 + 2 = 52

Block size = 64

Network:
192.168.1.0

Range:
192.168.1.0 – 192.168.1.63

Usable:
192.168.1.1 – 192.168.1.62

Broadcast:
192.168.1.63

Spare:
62 - 50 = 12
```

Branch 2:

```text
25 hosts required

25 + 2 = 27

Block size = 32

Network:
192.168.1.64

Range:
192.168.1.64 – 192.168.1.95

Usable:
192.168.1.65 – 192.168.1.94

Broadcast:
192.168.1.95

Spare:
30 - 25 = 5
```

Branch 3:

```text
10 hosts required

10 + 2 = 12

Block size = 16

Network:
192.168.1.96

Range:
192.168.1.96 – 192.168.1.111

Usable:
192.168.1.97 – 192.168.1.110

Broadcast:
192.168.1.111

Spare:
14 - 10 = 4
```

Next available boundary:

```text
192.168.1.112
```

---

# 20. Comparing Waste Before and After Subnetting

If every department received 254 usable addresses:

```text
HQ:
254 - 200 = 54 spare

B1:
254 - 50 = 204 spare

B2:
254 - 25 = 229 spare

B3:
254 - 10 = 244 spare
```

Total unused usable addresses:

```text
54 + 204 + 229 + 244
=
731
```

With more appropriate subnet sizes:

```text
HQ = 54 spare
B1 = 12 spare
B2 = 5 spare
B3 = 4 spare
```

Total:

```text
54 + 12 + 5 + 4
=
75 spare addresses
```

This clearly demonstrated why subnetting improves IP address utilization.

---

# 21. What Is a Subnet Mask?

A subnet mask is a **32-bit value used with an IPv4 address to identify which portion belongs to the network and which portion belongs to hosts.**

Interview definition:

> **A subnet mask is a 32-bit value used with an IPv4 address to identify the network and host portions of the address. It helps a device determine whether a destination belongs to the local subnet or must be reached through a router.**

---

# 22. Why Does a Computer Need a Subnet Mask?

Suppose my computer has:

```text
IP:
192.168.1.10

Subnet:
192.168.1.0
```

It wants to communicate with:

```text
192.168.1.50
```

If both addresses belong to the same subnet:

```text
Computer A
192.168.1.10
      │
      ▼
Computer B
192.168.1.50
```

They can normally communicate locally.

But suppose the destination is:

```text
192.168.2.50
```

and it belongs to another subnet.

Then:

```text
Computer
192.168.1.10
      │
      ▼
Default Gateway / Router
      │
      ▼
Different Network
192.168.2.50
```

So one important job of the subnet mask is helping the computer determine:

```text
Destination IP
      │
      ▼
Same subnet?
    /      \
  YES      NO
   │        │
   ▼        ▼
Local    Send toward
network  default gateway/router
```

---

# 23. Subnetting vs Subnet Mask

I learned that these two terms are related but not identical.

### Subnetting

Subnetting is the process of:

```text
Large network
      ↓
Divide
      ↓
Smaller logical networks
```

### Subnet Mask

The subnet mask tells devices:

```text
Which bits = Network

Which bits = Host
```

Mental model:

```text
SUBNETTING
"How should I divide my network?"

        ↓

SUBNET MASK
"How does a computer recognize that division?"
```

---

# 24. `/24` and the Subnet Mask

A `/24` mask contains:

```text
24 network bits
8 host bits
```

Binary:

```text
11111111.11111111.11111111.00000000
```

Each:

```text
11111111
```

equals:

```text
255
```

Therefore:

```text
/24
=
255.255.255.0
```

---

# 25. `/26` and the Subnet Mask

`/26` means:

```text
26 network bits
6 host bits
```

Binary mask:

```text
11111111.11111111.11111111.11000000
```

The final octet:

```text
11000000
```

Using binary values:

```text
128 64 32 16 8 4 2 1
 1   1  0  0 0 0 0 0
```

Therefore:

```text
128 + 64 = 192
```

So:

```text
/26
=
255.255.255.192
```

---

# 26. Why `/26` Gives 64 Addresses

IPv4:

```text
32 bits
```

`/26`:

```text
26 network bits
```

Remaining:

```text
32 - 26 = 6 host bits
```

Six bits provide:

```text
2^6 = 64
```

Therefore:

```text
/26
      ↓
6 host bits
      ↓
2^6
      ↓
64 total addresses
      ↓
62 normally usable hosts
```

---

# 27. Subnet-Mask Block-Size Shortcut

For:

```text
255.255.255.192
```

I learned the shortcut:

```text
256 - 192 = 64
```

Therefore:

```text
Block size = 64
```

That creates:

```text
0–63
64–127
128–191
192–255
```

---

# 28. Important Correction — IP Alone Is Not Enough

An IP address by itself does not tell me its subnet size.

For example:

```text
192.168.1.173
```

alone is not enough to determine whether its network is:

```text
192.168.1.0
```

or:

```text
192.168.1.128
```

etc.

I also need information such as:

```text
/24
/26
```

or the corresponding subnet mask.

Example:

```text
192.168.1.173/26
```

gives enough information to calculate the subnet.

---

# 29. Free IP vs Valid Network Boundary

Another important concept:

> **A free IP address is not automatically a valid place to start a new subnet.**

Suppose addresses before:

```text
192.168.1.138
```

are already allocated.

If `.138` belongs to an existing subnet, another computer in that same subnet may potentially use `.138`.

But if I want to create an entirely new 32-address subnet, `.138` cannot simply become the network address.

For a block size of 32:

```text
0–31
32–63
64–95
96–127
128–159
160–191
...
```

`.138` sits inside:

```text
128–159
```

So a new subnet must start from an appropriate free subnet boundary and must not overlap an existing subnet.

---

# 30. Subnet Planning Should Happen Before Host Allocation

A better network-design process is:

```text
Determine departments
        ↓
Determine host requirements
        ↓
Calculate subnet sizes
        ↓
Allocate subnet ranges
        ↓
Assign individual device IPs
```

Rather than:

```text
Randomly assign IP addresses
        ↓
Try to build subnets afterward
```

Planning first prevents overlapping or wasted address ranges.

---

# 31. Private vs Public IP Addresses

I also reinforced how to identify private IPv4 addresses.

RFC 1918 private IPv4 ranges are:

```text
10.0.0.0
through
10.255.255.255
```

```text
172.16.0.0
through
172.31.255.255
```

```text
192.168.0.0
through
192.168.255.255
```

Example:

```text
172.20.5.173
```

is private because it belongs to:

```text
172.16.0.0 – 172.31.255.255
```

---

# 32. Important Distinction — Subnet Mask Does NOT Decide Public vs Private

I initially considered whether the subnet mask determines whether an IP is private or public.

It does not.

These are different concepts:

```text
IP ADDRESS RANGE
       │
       ▼
Private or Public?
```

while:

```text
SUBNET MASK
       │
       ▼
Which network/subnet does this IP belong to?
```

---

# 33. Day 9 Practical Assignment

I analyzed:

```text
IP:
172.20.5.173

Prefix:
/26
```

First:

```text
IPv4 bits = 32
```

`/26` means:

```text
Network bits = 26
Host bits    = 6
```

Therefore:

```text
2^6 = 64 total addresses
```

Normally usable:

```text
64 - 2 = 62
```

Subnet mask:

```text
255.255.255.192
```

Block size:

```text
64
```

Possible ranges:

```text
0–63
64–127
128–191
192–255
```

`.173` belongs to:

```text
128–191
```

Therefore:

```text
Network Address:
172.20.5.128

First Usable:
172.20.5.129

Last Usable:
172.20.5.190

Broadcast:
172.20.5.191

Next subnet boundary:
172.20.5.192
```

`172.20.5.173` is therefore a:

**normal usable host address**

---

# 34. Same-Subnet Communication

Compare:

```text
172.20.5.173
172.20.5.150
```

Both belong to:

```text
128–191
```

Therefore:

```text
Same subnet ✅
```

They can normally communicate locally without routing their packets through the default gateway.

---

# 35. Different-Subnet Communication

Compare:

```text
172.20.5.173
172.20.5.200
```

`.173` belongs to:

```text
128–191
```

`.200` belongs to:

```text
192–255
```

Therefore:

```text
Different subnets ✅
```

Communication between them requires routing.

Conceptually:

```text
172.20.5.173
      │
      ▼
Default Gateway / Router
      │
      ▼
172.20.5.200
```

---

# 36. Mini Network Design Challenge

Requirement:

```text
12 computers
```

Account for special addresses:

```text
12
+ Network Address
+ Broadcast Address
=
14 addresses required
```

Smallest block that fits:

```text
16 addresses
```

Suppose I use a new available address space:

```text
172.20.6.x
```

A valid 16-address subnet could be:

```text
Network:
172.20.6.0

Usable:
172.20.6.1 – 172.20.6.14

Broadcast:
172.20.6.15

Next subnet:
172.20.6.16
```

This reinforced an important rule:

```text
Block size = 16

Possible subnet boundaries:
0
16
32
48
64
...
```

The block size tells me the spacing between valid network boundaries.

It does NOT mean:

```text
"Block size 16 → I must start at 16"
```

If `.0–.15` is available:

```text
0–15 ✅
```

If that block is occupied, I could use another available valid boundary:

```text
16–31
32–47
48–63
...
```

provided it does not overlap an existing subnet.

---

# 37. My Current Subnetting Mental Model

```text
How many hosts are required?
        │
        ▼
Account for Network + Broadcast
        │
        ▼
Choose smallest suitable
power-of-two block
        │
        ▼
Determine valid subnet boundaries
        │
        ▼
Choose an available boundary
that does not overlap
        │
        ▼
First address
=
Network Address
        │
        ▼
Addresses in between
=
Usable Hosts
        │
        ▼
Last address
=
Broadcast Address
        │
        ▼
Next number
=
Next subnet boundary
```

---

# 38. Local vs Remote Mental Model

The combination of:

```text
IP Address
+
Subnet Mask
```

allows a device to determine its network.

Conceptually:

```text
Destination IP
      │
      ▼
Compare network/subnet
      │
      ▼
Same subnet?
   ┌──┴──┐
   │     │
  YES    NO
   │     │
   ▼     ▼
Local   Send to
traffic default gateway
```

This helped me understand that subnetting is not just a mathematical exercise.

The information is actually used by computers to make networking decisions.

---

# 39. Key Terms Learned

### IPv4

Internet Protocol version 4.

Uses 32-bit addresses.

---

### Octet

One 8-bit section of an IPv4 address.

Example:

```text
192 . 168 . 1 . 10

192 = octet
168 = octet
1   = octet
10  = octet
```

---

### Subnet

A smaller logical network created from a larger IP network.

---

### Subnetting

The process of dividing networks into smaller subnets.

---

### Network Address / Network ID

The first address of a subnet that identifies the network itself.

---

### Broadcast Address

The last address of a traditional IPv4 subnet, used to target all hosts in that broadcast domain.

---

### Host Address

An address assigned to a device inside a subnet.

---

### Subnet Mask

A 32-bit value that identifies the network and host portions of an IPv4 address.

---

### CIDR

Classless Inter-Domain Routing.

Uses prefix notation such as:

```text
/24
/26
/28
```

---

### Prefix Length

The number after `/`.

Example:

```text
/26
```

means:

```text
26 network bits
```

---

### Block Size

The total number of addresses contained in a particular subnet block.

---

### Default Gateway

Usually a router interface that a host sends packets toward when the destination is outside its local subnet.

---

### FLSM

Fixed Length Subnet Masking.

All created subnets use the same subnet size.

I have not studied this deeply yet.

---

### VLSM

Variable Length Subnet Masking.

Different subnet sizes can be used according to different host requirements.

My HQ / Branch example gave me initial exposure to this idea, but I have not studied VLSM deeply yet.

---

# 40. What I Can Now Do

After this session, I can:

- Explain why subnetting exists
- Explain network and host portions
- Explain `/24` and `/26` at a basic level
- Calculate host bits from a CIDR prefix
- Calculate address capacity from host bits
- Identify block sizes
- Identify subnet boundaries
- Find the subnet containing a given IP
- Identify the network address
- Identify the broadcast address
- Calculate usable host ranges
- Determine the next subnet boundary
- Explain the purpose of a subnet mask
- Identify same-subnet communication
- Identify when routing is required
- Recognize common private IPv4 ranges
- Explain why free IP addresses are not automatically valid subnet boundaries
- Perform basic subnet planning based on host requirements

---

# 41. Topics Still To Learn

I have completed the **Subnetting Foundations**, but subnetting is not finished.

Next topics include:

```text
CIDR ↔ Subnet Mask Calculation
             │
             ▼
Binary Subnet Calculations
             │
             ▼
Bitwise AND
             │
             ▼
Borrowing Network/Host Bits
             │
             ▼
Number of Subnets
             │
             ▼
FLSM
             │
             ▼
VLSM in Depth
             │
             ▼
Complex Network Design
             │
             ▼
Practical Configuration
and Troubleshooting
```

Current progress:

```text
Why subnetting exists               ✅
Network vs host idea                ✅
Network / broadcast addresses       ✅
Usable-host calculation             ✅
Block sizes                         ✅
Subnet boundaries                   ✅
CIDR basic meaning (/24, /26)       ✅
Subnet-mask basic meaning           ✅
/26 → 6 host bits → 64 addresses    ✅
Find subnet containing an IP        ✅
Same subnet vs different subnet     ✅
Local vs router decision            ✅
Private vs public IP recognition    ✅

CIDR ↔ mask calculation             🟡 Beginning
Binary subnet calculations          🟡 Beginning
Bitwise AND                         ⏳ Not learned yet
Borrowing subnet bits               ⏳ Not learned yet
Number of subnets                   ⏳ Not learned yet
FLSM                                ⏳ Not learned yet
VLSM                                🟡 Basic exposure
Complex subnet design               ⏳ Not learned yet
Practical troubleshooting           ⏳ Later
```

---

# 42. Day 9 Key Takeaway

The biggest idea I took away from this session is:

> **Subnetting divides a larger IP network into smaller logical networks, while the subnet mask tells devices which portion of an IPv4 address identifies the network and which portion identifies the host.**

My simplified subnetting workflow is:

```text
Host Requirement
       ↓
Required Address Capacity
       ↓
Block Size
       ↓
Valid Boundary
       ↓
Network Address
       ↓
Usable Host Range
       ↓
Broadcast Address
       ↓
Next Subnet
```

And the key formulas I practiced are:

```text
Total IPv4 bits = 32

Host bits
=
32 - CIDR prefix

Total addresses
=
2^(host bits)

Normally usable hosts
=
Total addresses - 2

Broadcast
=
Network + Block Size - 1

Next subnet
=
Network + Block Size
```

---

## ✅ Day 9 Status

**IP Subnetting Foundations — Completed**

Today was focused on understanding the reasoning behind subnetting rather than memorizing subnet tables.

The next stage will be learning how to derive subnet masks and CIDR prefixes confidently, followed by binary subnetting, bitwise AND, FLSM, VLSM, and practical network design.
