# 🌐 NETWORKING — DAY 03

## Same vs Different Networks, Network ID, Broadcast ID, Subnet Mask, Ping and Packet Tracer

**Learning Track:** Networking Fundamentals  
**Focus:** Same Network • Different Network • Switch • Router • Network Portion • Host Portion • Host Capacity • Network ID • Broadcast ID • Valid Host Range • Subnet Mask • `ncpa.cpl` • `ipconfig` • `ping` • TTL • Packet Tracer

---

> [!IMPORTANT]
>
> ### 💡 The main idea I am taking from Networking Day 3
>
> **Before a device sends data, it needs to determine whether the destination belongs to the same network or another network. Devices inside the same local network can communicate locally, while communication between different networks requires routing.**
>
> I also learned that an IPv4 network contains special addresses such as the **Network ID** and **Broadcast ID**, and that a **subnet mask** helps distinguish the network portion from the host portion of an IP address.
>
> My current mental model is:
>
> ```text
> Destination IP
>       ↓
> Is it in my network?
>       ↓
> ┌───────────────┐
> │               │
> YES             NO
> │               │
> ↓               ↓
> Local           Router /
> Communication   Default Gateway
> │               │
> ↓               ↓
> Switch          Other Network
> ```
>
> And for IPv4 addressing:
>
> ```text
> IPv4 Address
>      +
> Subnet Mask
>      ↓
> Network Portion
>      +
> Host Portion
>      ↓
> Network ID
> Valid Host Addresses
> Broadcast ID
> ```

---

# 01 — 🏨 Understanding Networks Using the Building Analogy

I used a building or hotel analogy to understand how communication differs between the same network and different networks.

Suppose two families are staying in rooms:

```text
101
102
```

Both rooms are on the same floor.

They do not need to use an elevator just to move between those rooms.

But suppose the room numbers are:

```text
101
201
```

Now the rooms are on different floors.

To move from one floor to another, an elevator is required.

I connected this analogy with networking.

```text
Same Floor
    ↓
Same Network
    ↓
Local Communication

Different Floor
    ↓
Different Network
    ↓
Router Required
```

The analogy helped me remember the basic purpose of a router.

A router allows communication **between different networks**.

---

# 02 — 🖥️ Same Network Communication

One example I used to understand this was:

```text
Computer A
192.168.10.1

Computer B
192.168.10.2
```

Using the default Class C network structure:

```text
192.168.10.1
N   N   N  H

192.168.10.2
N   N   N  H
```

The network portion is the same:

```text
192.168.10
```

Only the host portion changes:

```text
1
2
```

Therefore these devices belong to the same network under the classful example being used.

Conceptually:

```text
192.168.10.1
      │
      │
    SWITCH
      │
      │
192.168.10.2
```

The important idea I learned is:

> **Devices belonging to the same local network do not require a router simply to communicate with one another.**

A switch can provide connectivity between the devices inside that local network.

---

# 03 — 🔀 Different Network Communication

Now consider:

```text
Computer A
192.168.10.1

Computer B
192.168.20.1
```

Under the default Class C structure:

```text
192.168.10.1
└───────┬──────┘
    Network
192.168.10


192.168.20.1
└───────┬──────┘
    Network
192.168.20
```

The network portions are different:

```text
192.168.10
      ≠
192.168.20
```

Therefore communication must move between networks.

Conceptually:

```text
192.168.10.1
      │
    Switch
      │
    Router
      │
    Switch
      │
192.168.20.1
```

The simple rule I learned is:

```text
Same Network
     ↓
Local Communication


Different Network
     ↓
Router Required
```

---

# 04 — ⚠️ Same IP Class Does Not Automatically Mean Same Network

An important distinction I understood is that two IPv4 addresses can both fall inside the historical Class C range without belonging to the same network.

For example:

```text
192.168.10.1
192.168.20.1
```

Both begin with:

```text
192
```

and therefore both fall inside the historical Class C first-octet range.

However, using the default Class C structure:

```text
N.N.N.H
```

their network portions are:

```text
192.168.10
192.168.20
```

which are different.

Therefore:

```text
Same IP Class
      ≠
Automatically Same Network
```

The network and host boundary must also be considered.

---

# 05 — 🧱 Revisiting Network and Host Portions

From Day 2, I learned the traditional classful structures:

```text
Class A
N.H.H.H

Class B
N.N.H.H

Class C
N.N.N.H
```

where:

```text
N = Network Portion

H = Host Portion
```

The **network portion** identifies the network.

The **host portion** identifies a particular device/interface within that network.

---

# 06 — 🏠 Class C Network and Host Portion

For a traditional Class C example:

```text
192.168.1.25
```

the structure is:

```text
N   . N   . N . H

192 . 168 . 1 . 25
```

Therefore:

```text
Network portion
=
192.168.1

Host portion
=
25
```

The Class C host portion contains:

```text
8 bits
```

Therefore the total number of address combinations in that host portion is:

```text
2⁸
=
256
```

---

# 07 — 🏢 Class B Network and Host Portion

For a traditional Class B example:

```text
172.16.10.25
```

the structure is:

```text
N   . N  . H  . H

172 . 16 . 10 . 25
```

Therefore:

```text
Network portion
=
172.16

Host portion
=
10.25
```

The host portion contains:

```text
16 bits
```

Therefore:

```text
2¹⁶
=
65,536 total addresses
```

---

# 08 — 🏙️ Class A Network and Host Portion

For a traditional Class A example:

```text
10.20.30.40
```

the structure is:

```text
N  . H  . H  . H

10 . 20 . 30 . 40
```

Therefore:

```text
Network portion
=
10

Host portion
=
20.30.40
```

The host portion contains:

```text
24 bits
```

Therefore:

```text
2²⁴
=
16,777,216 total addresses
```

---

# 09 — 🔢 Total Addresses Based on Host Bits

The address capacities I studied were:

| Traditional Class | Host Bits | Total Address Combinations |
| ----------------- | --------: | -------------------------: |
| Class C           | 8 bits    | 2⁸ = 256                   |
| Class B           | 16 bits   | 2¹⁶ = 65,536               |
| Class A           | 24 bits   | 2²⁴ = 16,777,216           |

At first, these numbers represent all possible combinations in the host portion.

However, not every address can normally be assigned to a host.

Two addresses have special purposes:

```text
Network ID
Broadcast ID
```

---

# 10 — 🪪 What Is a Network ID?

The **Network ID**, also called the **Network Address**, identifies the network itself.

It is created when:

> **All bits in the host portion are 0.**

For the Class C example:

```text
192.168.1.x
```

the Network ID is:

```text
192.168.1.0
```

Binary idea:

```text
Host portion
00000000
```

Therefore:

```text
192.168.1.0
       ↑
Host bits = all 0
```

This address represents the network itself rather than an ordinary individual host.

So it is not normally assigned to a laptop or other host device.

---

# 11 — 📢 What Is a Broadcast ID?

The **Broadcast ID** is the final address in the network range.

It is created when:

> **All bits in the host portion are 1.**

For:

```text
192.168.1.x
```

the Broadcast ID is:

```text
192.168.1.255
```

because:

```text
11111111
=
255
```

Conceptually:

```text
One Sender
    ↓
Broadcast
    ↓
All Hosts in That Network
```

So the Broadcast ID is used when communication is intended for all hosts in that broadcast network.

It is not normally assigned to one ordinary host device.

---

# 12 — ✅ Valid Host Addresses

The addresses between the Network ID and Broadcast ID are the normal assignable host range.

For example:

```text
Network:
192.168.1.x
```

Network ID:

```text
192.168.1.0
```

First valid host:

```text
192.168.1.1
```

Last valid host:

```text
192.168.1.254
```

Broadcast ID:

```text
192.168.1.255
```

So the structure becomes:

```text
192.168.1.0
     ↓
NETWORK ID


192.168.1.1
      ↓
First Valid Host

       ...

192.168.1.254
      ↓
Last Valid Host


192.168.1.255
      ↓
BROADCAST ID
```

---

# 13 — ➖ Why Do We Subtract Two Addresses?

A Class C host portion has:

```text
8 bits
```

Therefore:

```text
2⁸ = 256
```

But two addresses have special purposes:

```text
1 → Network ID

1 → Broadcast ID
```

Therefore:

```text
256 - 2
=
254
```

So under the traditional Class C example:

```text
Total addresses = 256

Valid host addresses = 254
```

The same logic gives:

| Traditional Class | Total Addresses | Valid Hosts |
| ----------------- | --------------: | ----------: |
| Class C           | 256             | 254         |
| Class B           | 65,536          | 65,534      |
| Class A           | 16,777,216      | 16,777,214  |

The basic formula I learned is:

```text
2^(Host Bits) - 2
```

where the two removed addresses are:

```text
Network ID
+
Broadcast ID
```

---

# 14 — 📝 Address Range Practice — Class C

For the example network:

```text
192.168.1.x
```

the beginning of the range looks like:

```text
192.168.1.0   ← Network ID
192.168.1.1   ← Valid Host
192.168.1.2   ← Valid Host
192.168.1.3   ← Valid Host
192.168.1.4   ← Valid Host
192.168.1.5   ← Valid Host
```

The end of the range looks like:

```text
192.168.1.253 ← Valid Host
192.168.1.254 ← Last Valid Host
192.168.1.255 ← Broadcast ID
```

This exercise helped me understand that I should not simply memorize:

```text
0 → 255
```

I should understand what the beginning and ending addresses actually mean.

---

# 15 — 📝 Address Range Practice — Class B

For the traditional Class B example:

```text
172.16.x.x
```

the Network ID is:

```text
172.16.0.0
```

The beginning of the range is:

```text
172.16.0.0   ← Network ID
172.16.0.1   ← Valid Host
172.16.0.2   ← Valid Host
172.16.0.3   ← Valid Host
172.16.0.4   ← Valid Host
172.16.0.5   ← Valid Host
```

The end is:

```text
172.16.255.253 ← Valid Host
172.16.255.254 ← Last Valid Host
172.16.255.255 ← Broadcast ID
```

Therefore:

```text
Valid Host Range

172.16.0.1
      ↓
172.16.255.254
```

---

# 16 — 📝 Address Range Practice — Class A

For the traditional Class A example:

```text
10.x.x.x
```

the Network ID is:

```text
10.0.0.0
```

The beginning of the range is:

```text
10.0.0.0   ← Network ID
10.0.0.1   ← Valid Host
10.0.0.2   ← Valid Host
10.0.0.3   ← Valid Host
10.0.0.4   ← Valid Host
10.0.0.5   ← Valid Host
```

The end is:

```text
10.255.255.253 ← Valid Host
10.255.255.254 ← Last Valid Host
10.255.255.255 ← Broadcast ID
```

Therefore:

```text
Valid Host Range

10.0.0.1
    ↓
10.255.255.254
```

---

# 17 — 🎭 What Is a Subnet Mask?

Another major concept I learned was the:

> **Subnet Mask**

My beginner-friendly understanding is:

> **A subnet mask tells a system which bits belong to the network portion and which bits belong to the host portion of an IPv4 address.**

The rule I learned is:

```text
1 → Network bit

0 → Host bit
```

So a mask provides a way for the computer to distinguish:

```text
NETWORK
   vs
HOST
```

---

# 18 — 🔢 Why Does 255 Represent Network Bits?

From Day 2, I already know:

```text
255
=
11111111
```

All eight bits are:

```text
1
```

In a subnet mask:

```text
1 = Network
```

Therefore:

```text
255
       ↓
11111111
       ↓
8 Network Bits
```

Similarly:

```text
0
      ↓
00000000
      ↓
8 Host Bits
```

So I should not remember:

```text
255 = One Network
```

The technically stronger understanding is:

> **255 represents an octet containing eight network bits set to 1 in the subnet mask.**

---

# 19 — 🏠 Default Class C Subnet Mask

The default Class C mask I studied is:

```text
255.255.255.0
```

In binary:

```text
11111111.11111111.11111111.00000000
```

Breaking it down:

```text
11111111   11111111   11111111   00000000
    N          N          N           H
```

Therefore:

```text
Network bits = first 24 bits

Host bits = last 8 bits
```

This matches the traditional Class C structure:

```text
N.N.N.H
```

---

# 20 — 🏢 Default Class B Subnet Mask

The default Class B mask I studied is:

```text
255.255.0.0
```

Binary:

```text
11111111.11111111.00000000.00000000
```

Conceptually:

```text
N.N.H.H
```

Therefore:

```text
First two octets
=
Network portion

Last two octets
=
Host portion
```

---

# 21 — 🏙️ Default Class A Subnet Mask

The default Class A mask I studied is:

```text
255.0.0.0
```

Binary:

```text
11111111.00000000.00000000.00000000
```

Conceptually:

```text
N.H.H.H
```

Therefore:

```text
First octet
=
Network portion

Last three octets
=
Host portion
```

---

# 22 — 🧠 Connecting IP Address and Subnet Mask

One useful way I now visualize the relationship is:

```text
IP Address
192.168.10.25

Subnet Mask
255.255.255.0
```

The mask tells me:

```text
255      255      255       0
 ↓        ↓        ↓        ↓
Network  Network  Network   Host
```

So:

```text
192 . 168 . 10 . 25
 N     N     N     H
```

Therefore:

```text
Network Portion
192.168.10

Host Portion
25
```

The subnet mask is therefore not another IP address assigned to a device.

Its job is to help define the network/host boundary.

---

# 23 — 🔗 Putting the Whole Address Range Together

For:

```text
IP Example:
192.168.1.25

Subnet Mask:
255.255.255.0
```

the basic classful model gives:

```text
Network Portion
192.168.1

Host Portion
25
```

The complete network range becomes:

```text
192.168.1.0
       ↓
Network ID

192.168.1.1
       ↓
First Valid Host

...

192.168.1.25
       ↓
Example Host

...

192.168.1.254
       ↓
Last Valid Host

192.168.1.255
       ↓
Broadcast ID
```

This was the point where the concepts from Day 2 started connecting together.

---

# 24 — 🪟 Checking Network Connections Using `ncpa.cpl`

I also learned a Windows shortcut for viewing network adapters.

Press:

```text
Windows + R
```

Then enter:

```text
ncpa.cpl
```

This opens the Windows:

> **Network Connections**

window.

Depending on the computer, I may see adapters such as:

```text
Ethernet

Wi-Fi

Other network adapters
```

This provides a graphical way to inspect the network interfaces available on the system.

---

# 25 — 💻 Checking IP Configuration Using `ipconfig`

Another command I practiced was:

```cmd
ipconfig
```

This command can show important Layer 3 configuration information for Windows network adapters.

Typical information includes:

```text
IPv4 Address

Subnet Mask

Default Gateway
```

For example:

```text
IPv4 Address   : 192.168.1.50

Subnet Mask    : 255.255.255.0

Default Gateway: 192.168.1.1
```

This connected the networking concepts I was learning directly with values configured on a real computer.

---

# 26 — 🚪 Understanding the Default Gateway at My Current Level

I connected the router concept with the **Default Gateway**.

My current beginner mental model is:

```text
My Computer
     ↓
Destination in my network?
     │
 ┌───┴────┐
 │        │
YES       NO
 │        │
 ↓        ↓
Local    Default
Network  Gateway
          ↓
        Router
          ↓
      Other Network
```

I will study routing and gateways more deeply as I progress through networking fundamentals.

---

# 27 — 📡 Testing Connectivity Using `ping`

I also practiced using the `ping` command.

Example:

```cmd
ping 192.168.1.1
```

Another example I used was:

```cmd
ping 8.8.8.8
```

A Windows ping reply can look similar to:

```text
Reply from 8.8.8.8: bytes=32 time=16ms TTL=117
```

The important fields I observed were:

```text
Reply from

bytes

time

TTL
```

---

# 28 — 📦 Understanding `bytes=32`

A Windows ping may display:

```text
bytes=32
```

This refers to the amount of ICMP Echo data being used by the Windows ping command.

An important distinction for me is:

```text
IPv4 Address Size
=
32 bits


Windows Ping Data
=
32 bytes
```

These are separate concepts.

I should not confuse:

```text
32 bits
```

with:

```text
32 bytes
```

---

# 29 — ⏱️ Understanding Ping Time

A ping response may show:

```text
time<1ms
```

or:

```text
time=16ms
```

`ms` means:

> **Milliseconds**

This gives me an indication of the round-trip delay between sending the ping request and receiving the response.

Conceptually:

```text
My Computer
     ↓
Ping Request
     ↓
Destination
     ↓
Ping Reply
     ↓
My Computer
```

The reported time relates to that round trip.

---

# 30 — ⏳ Understanding TTL

Another field I learned about was:

> **TTL — Time To Live**

A packet starts with a TTL value.

When the packet is forwarded through routers, the TTL is reduced.

A simplified model is:

```text
Packet Starts
TTL = 64

     ↓ Router

TTL = 63

     ↓ Router

TTL = 62

     ↓ Router

TTL = 61
```

This mechanism helps prevent packets from circulating forever if a routing problem or loop occurs.

When TTL eventually reaches zero, the packet is discarded.

---

# 31 — ⚠️ My Technical Clarification About TTL

While learning about TTL, I encountered common values such as:

```text
64
128
255
```

were used as a quick way to discuss local versus routed communication.

After reviewing the concept, I learned an important clarification:

> **64, 128 and 255 are commonly encountered initial TTL values, but seeing one of those exact values is not by itself proof that a destination is on the same LAN.**

A received TTL can be thought of approximately as:

```text
Initial TTL
    -
Routers Traversed
    =
Received TTL
```

For example, if a reply appears with:

```text
TTL = 117
```

it suggests that the reply has likely passed through routed hops from whatever initial TTL value the sender used.

So the idea I want to remember is:

```text
TTL
 ↓
Reduced as routers forward packets
```

rather than memorizing:

```text
64 / 128 / 255
=
Always Local Network
```

---

# 32 — 🧪 Cisco Packet Tracer Lab

I also practiced these ideas using:

> **Cisco Packet Tracer**

The basic lab contained:

```text
PC 1
 │
 │
Switch
 │
 ├──────── PC 2
 │
 └──────── PC 3
```

The PCs were configured with addresses belonging to the network being practiced.

A simple Class C-style example would be:

```text
PC 1
192.168.1.1

PC 2
192.168.1.2

PC 3
192.168.1.3
```

with the mask:

```text
255.255.255.0
```

This allowed me to connect the theory of:

```text
Same Network
+
Host Addresses
+
Switch
```

with an actual network simulation.

---

# 33 — 📣 Broadcast Testing in Packet Tracer

The broadcast address used for the example network was:

```text
192.168.1.255
```

for the network:

```text
192.168.1.x
```

The lab used the broadcast address to demonstrate communication directed toward the network's broadcast destination.

Conceptually:

```text
One Device
    ↓
Broadcast Address
192.168.1.255
    ↓
Devices in the Broadcast Network
```

One thing I am keeping in mind is that actual operating systems and network devices may restrict or ignore certain broadcast ping behavior.

The important Day 3 concept was understanding **what the broadcast address represents**.

---

# 34 — 🔌 Switch vs Router — My Current Understanding

The easiest way for me to remember this concept is:

```text
SWITCH
   ↓
Connects devices within a local Layer 2 network
   ↓
Uses MAC-address information for frame forwarding
```

and:

```text
ROUTER
   ↓
Connects different IP networks
   ↓
Makes forwarding decisions using Layer 3 addressing
```

At my current level:

```text
Same Network
     ↓
Local forwarding
     ↓
Switch


Different Network
     ↓
Routing
     ↓
Router
```

---

# 35 — 🔄 Connecting Day 1, Day 2 and Day 3

My networking knowledge is now connecting across the three days.

## Day 1

I learned:

```text
Protocols

IP Address

MAC Address

Port Number

IPv4

IPv6
```

---

## Day 2

I learned:

```text
IPv4 = 32 bits

4 Octets

Binary ↔ Decimal

Class A / B / C / D / E

Network Portion

Host Portion
```

---

## Day 3

I learned:

```text
Same Network
vs
Different Network

Switch
vs
Router

Network ID

Broadcast ID

Valid Host Range

Host Capacity

Subnet Mask

ipconfig

ping

TTL

Packet Tracer Practice
```

The topics are no longer feeling like isolated definitions.

They are starting to form one networking model.

---

# 36 — 🧠 My Current End-to-End Mental Model

Suppose I have:

```text
IP Address:
192.168.10.25

Subnet Mask:
255.255.255.0
```

I can currently reason about it as:

```text
192 . 168 . 10 . 25
 N      N     N    H
```

Therefore:

```text
Network Portion
=
192.168.10

Host Portion
=
25
```

The network range in the classful example is:

```text
192.168.10.0
        ↓
Network ID


192.168.10.1
        ↓
First Valid Host

        ...

192.168.10.254
        ↓
Last Valid Host


192.168.10.255
        ↓
Broadcast ID
```

And if the computer wants to communicate:

```text
Destination
     ↓
Same Network?
     │
 ┌───┴────┐
 │        │
YES       NO
 │        │
 ↓        ↓
Local    Router /
Network  Gateway
```

This is the biggest connection I made during Networking Day 3.

---

# 37 — 🧪 Commands Practiced / Introduced

| Command / Shortcut | What I Currently Use It For |
| ------------------ | --------------------------- |
| `ncpa.cpl`         | Open Windows Network Connections |
| `ipconfig`         | View IP address, subnet mask and default gateway |
| `ping <IP>`        | Test IP connectivity and observe replies |
| `ping 127.0.0.1`   | Mentioned in the study material for local TCP/IP testing |
| `ping 8.8.8.8`     | Test connectivity toward an Internet IP |
| `ping 192.168.1.1` | Test connectivity to an example local address/gateway |

I will study additional networking commands as I continue progressing through networking fundamentals.

---

# 38 — ⚠️ Scope of My Day 3 Learning

The IP Fundamentals study material contains additional topics including:

```text
Reserved & Special Addresses

Private vs Public IP Addresses

NAT

Unicast

Multicast

Broadcast in more detail

Additional Commands

Practice Q&A
```

However, I have intentionally **not included those topics in detail in Day 3** because I have not yet studied and practiced them deeply enough.

I want this portfolio to represent what I actually understand and practice rather than copying material before learning it.

---

# 39 — ✅ What I Can Explain After Day 3

After completing Day 3, I should be able to explain:

- Why devices in the same network can communicate locally.
- Why communication between different networks requires routing.
- The basic difference between a switch and a router.
- The network and host portions in traditional Class A, B and C addressing.
- Why Class C has 8 host bits.
- Why Class B has 16 host bits.
- Why Class A has 24 host bits.
- How total host-address combinations are calculated.
- What the Network ID represents.
- Why the Network ID has all-zero host bits.
- What the Broadcast ID represents.
- Why the Broadcast ID has all-one host bits.
- Why two addresses are removed from the normal host range in the classful examples.
- Why Class C traditionally provides 254 valid host addresses.
- Why Class B traditionally provides 65,534 valid host addresses.
- Why Class A traditionally provides 16,777,214 valid host addresses.
- What a subnet mask is used for.
- Why `255` in a subnet mask corresponds to eight `1` bits.
- Why `0` in a subnet mask corresponds to eight `0` host bits.
- The default masks studied for Class A, B and C.
- How to inspect basic Windows IP information.
- What `ping` is used for.
- What `bytes`, `time` and `TTL` mean in a basic ping response.
- How TTL changes across routed hops.
- How to build a simple switched network in Cisco Packet Tracer.

---

# 40 — 📌 Day 3 Quick Reference

```text
CLASS A

Structure:
N.H.H.H

Host Bits:
24

Default Mask:
255.0.0.0

Total Addresses:
16,777,216

Valid Hosts:
16,777,214
```

```text
CLASS B

Structure:
N.N.H.H

Host Bits:
16

Default Mask:
255.255.0.0

Total Addresses:
65,536

Valid Hosts:
65,534
```

```text
CLASS C

Structure:
N.N.N.H

Host Bits:
8

Default Mask:
255.255.255.0

Total Addresses:
256

Valid Hosts:
254
```

Special host-bit patterns:

```text
Host Bits = All 0
        ↓
Network ID
```

```text
Host Bits = All 1
        ↓
Broadcast ID
```

Subnet mask:

```text
1
↓
Network Bit

0
↓
Host Bit
```

Communication:

```text
Same Network
↓
Local Communication
↓
Switch
```

```text
Different Network
↓
Routing Required
↓
Router
```

---

# 41 — 🎯 Day 3 Reflection

Day 3 helped me move from simply identifying IPv4 classes to understanding **how devices decide whether communication is local or needs to move to another network**.

The building and elevator analogy made the idea easier to visualize:

```text
Same Floor
↓
No Elevator Needed

Different Floor
↓
Elevator Needed
```

which maps conceptually to:

```text
Same Network
↓
Local Communication

Different Network
↓
Router
```

The most important new connection for me was understanding that an IP address cannot be considered alone.

I also need information describing the:

```text
Network Portion
+
Host Portion
```

and the subnet mask helps represent that boundary.

I now understand why a network range has:

```text
Network ID
       ↓
Valid Host Addresses
       ↓
Broadcast ID
```

and why the first and last addresses in the classful examples are not assigned as ordinary host addresses.

The Packet Tracer exercise also helped connect these concepts with an actual simulated network rather than only memorizing definitions.

My next step is to continue exploring the remaining IP fundamentals, including reserved/special addresses, private and public addressing, and different communication types such as unicast, multicast and broadcast.
