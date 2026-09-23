# 🌐 Day 14 — IP Routing, Directly Connected Networks, DHCP Integration, ARP and ICMP

<!-- portfolio-quick-review:start -->
## ⚡ Quick review

- **Problem:** Connect two IPv4 subnets and supply clients with suitable network settings.
- **Actions:** I configured two /27 LANs, router interfaces and local DHCP servers, then used ping and Packet Tracer Simulation Mode.
- **Result:** I documented directly connected routing, ARP/ICMP behavior and troubleshooting of masks, DHCP settings and an APIPA address.
- **Evidence:** Address tables, Cisco commands, DHCP settings and the troubleshooting walkthrough below.
- **Limitations:** The original simulation file is not attached. Static routes, multiple routers, DHCP relay and routing protocols were not configured.

[Read the full learning notes ↓](#full-learning-notes)

---

<a id="full-learning-notes"></a>
<!-- portfolio-quick-review:end -->

## 📌 Overview

Today I built and analyzed a Cisco Packet Tracer network containing two different IPv4 subnets connected by a router.

I divided the original `192.168.10.0/24` network into smaller `/27` subnets, configured two router interfaces, assigned default gateways, configured DHCP services for both subnets, and tested communication between devices.

I also used Packet Tracer Simulation Mode to observe how ARP, ICMP, switching, and routing work together when a device communicates with another network.

---

## 🎯 Learning Objectives

By completing this lab, I learned how to:

- Explain the purpose of IP routing.
- Distinguish same-network communication from different-network communication.
- Understand the role of a default gateway.
- Divide an IPv4 network into smaller subnets.
- Identify network, usable-host, and broadcast addresses.
- Configure Cisco router interfaces through the CLI.
- Understand directly connected routes.
- Read basic Cisco routing-table entries.
- Configure DHCP pools for separate subnets.
- Reserve addresses for routers and servers.
- Diagnose an APIPA address caused by DHCP failure.
- Understand how ARP and ICMP work during a routed ping.
- Explain why MAC addresses change while IP addresses remain the same.
- Understand the basic purpose of STP.
- Distinguish FLSM from VLSM.

---

# 1. What Is IP Routing?

**IP routing** is the process of selecting a path and forwarding IP packets between different networks.

A switch mainly forwards Ethernet frames inside a local network using MAC addresses. A router connects different IP networks and forwards packets based on their destination IP addresses.

```text
Same network
Device → Switch → Destination

Different network
Device → Switch → Default Gateway → Router → Other Network
```

If the destination is in the sender's local subnet, the sender communicates with it directly.

If the destination is in another subnet, the sender forwards the packet to its default gateway.

---

# 2. What Is a Default Gateway?

A **default gateway** is the router interface connected to a device's local network.

A host uses its default gateway when the destination is outside its own subnet.

Example:

```text
Host IP:         192.168.10.10
Subnet mask:     255.255.255.224
Default gateway: 192.168.10.30
```

If the host wants to reach another address inside `192.168.10.0/27`, it communicates locally through the switch.

If it wants to reach an address inside `192.168.10.32/27`, it sends the frame to the MAC address of `192.168.10.30`, which is its router interface.

## Important distinction

```text
Destination IP  = final destination device
Destination MAC = next device on the current local network
```

For a remote destination:

- The destination IP belongs to the final remote device.
- The destination MAC initially belongs to the default gateway.

---

# 3. Network Design

I divided the following network:

```text
192.168.10.0/24
```

into `/27` subnets.

The `/27` subnet mask is:

```text
255.255.255.224
```

## Block-size calculation

```text
Block size = 256 - 224
Block size = 32
```

Therefore, the subnet boundaries are:

```text
0, 32, 64, 96, 128, 160, 192, 224
```

I used the first two `/27` subnets.

---

# 4. First Subnet — Left LAN

```text
Network: 192.168.10.0/27
```

| Address type | Address |
|---|---|
| Network ID | `192.168.10.0` |
| First usable | `192.168.10.1` |
| Last usable | `192.168.10.30` |
| Broadcast | `192.168.10.31` |
| Subnet mask | `255.255.255.224` |
| Total addresses | `32` |
| Usable addresses | `30` |

I assigned:

```text
Client pool:       192.168.10.1–192.168.10.28
DHCP/DNS server:   192.168.10.29
Default gateway:   192.168.10.30
Broadcast address: 192.168.10.31
```

Visual address map:

```text
192.168.10.0      192.168.10.1–28      192.168.10.29      192.168.10.30      192.168.10.31
┌────────────┬───────────────────────┬──────────────────┬──────────────────┬─────────────────┐
│ Network ID │ DHCP client addresses │ DHCP/DNS server  │ Router gateway   │ Broadcast       │
└────────────┴───────────────────────┴──────────────────┴──────────────────┴─────────────────┘
```

---

# 5. Second Subnet — Right LAN

```text
Network: 192.168.10.32/27
```

| Address type | Address |
|---|---|
| Network ID | `192.168.10.32` |
| First usable | `192.168.10.33` |
| Last usable | `192.168.10.62` |
| Broadcast | `192.168.10.63` |
| Subnet mask | `255.255.255.224` |
| Total addresses | `32` |
| Usable addresses | `30` |

I assigned:

```text
Client pool:       192.168.10.33–192.168.10.60
DHCP/DNS server:   192.168.10.61
Default gateway:   192.168.10.62
Broadcast address: 192.168.10.63
```

Visual address map:

```text
192.168.10.32     192.168.10.33–60     192.168.10.61      192.168.10.62      192.168.10.63
┌────────────┬───────────────────────┬──────────────────┬──────────────────┬─────────────────┐
│ Network ID │ DHCP client addresses │ DHCP/DNS server  │ Router gateway   │ Broadcast       │
└────────────┴───────────────────────┴──────────────────┴──────────────────┴─────────────────┘
```

---

# 6. Address-Allocation Calculation

Each `/27` subnet contains:

```text
2^(32 - 27) = 2^5 = 32 total addresses
```

After removing the network and broadcast addresses:

```text
32 - 2 = 30 usable addresses
```

From the 30 usable addresses, I reserved:

```text
1 address for the router
1 address for the server
```

Therefore:

```text
30 - 1 - 1 = 28 DHCP client addresses
```

The DHCP server and DNS server use the same IP because both services run on the same server device.

Using the same IP for DHCP and DNS does not consume two addresses.

---

# 7. Lab Topology

```text
Left-side clients
       │
       ▼
    Switch 0
       │
       ▼
Router G0/0
192.168.10.30/27
       │
       │  Routing between subnets
       │
Router G0/1
192.168.10.62/27
       │
       ▼
    Switch 1
       │
       ├── Right-side clients
       │
       └── DHCP/DNS server
```

The router separates the two broadcast domains and routes packets between them.

---

# 8. Cisco Router Configuration

## Entering privileged and configuration modes

```cisco
enable
configure terminal
```

Abbreviated:

```cisco
en
conf t
```

## Meaning of `configure terminal`

```text
configure terminal
```

means that the router should accept configuration commands through the current terminal session.

The `t` in `conf t` means **terminal**.

## Complete router configuration

```cisco
enable
configure terminal

hostname R1

interface gigabitEthernet 0/0
ip address 192.168.10.30 255.255.255.224
no shutdown
exit

interface gigabitEthernet 0/1
ip address 192.168.10.62 255.255.255.224
no shutdown
exit

end
write memory
```

Abbreviated version:

```cisco
en
conf t

hostname R1

int g0/0
ip add 192.168.10.30 255.255.255.224
no shut
exit

int g0/1
ip add 192.168.10.62 255.255.255.224
no shut
exit

end
wr
```

Depending on the router model, the interfaces might be named:

```text
FastEthernet0/0
FastEthernet0/1
```

Their abbreviated forms are:

```cisco
int fa0/0
int fa0/1
```

---

# 9. Understanding the Router Commands

| Command | Purpose |
|---|---|
| `enable` | Enters privileged EXEC mode |
| `configure terminal` | Enters global configuration mode |
| `hostname R1` | Changes the router's hostname |
| `interface g0/0` | Selects a router interface |
| `ip address` | Assigns an IP address and subnet mask |
| `no shutdown` | Administratively enables the interface |
| `exit` | Moves back one configuration level |
| `end` | Returns directly to privileged EXEC mode |
| `write memory` | Saves the running configuration |
| `show ip interface brief` | Shows interface IP addresses and states |
| `show ip route` | Displays the routing table |
| `show running-config` | Displays the active configuration |

## Cisco CLI modes

```text
Router>                 User EXEC mode
Router#                 Privileged EXEC mode
Router(config)#         Global configuration mode
Router(config-if)#      Interface configuration mode
```

---

# 10. Directly Connected Networks

When a router interface:

1. Has a valid IP address,
2. Has a subnet mask,
3. Is administratively enabled, and
4. Has an active link,

the corresponding network is automatically added to the routing table.

My router directly connects to:

```text
192.168.10.0/27
192.168.10.32/27
```

Therefore, I did not need static routes or a dynamic routing protocol for communication between these two networks.

Both networks connect directly to the same router.

---

# 11. Verifying Router Interfaces

Command:

```cisco
show ip interface brief
```

Expected important information:

```text
Interface              IP-Address       Status    Protocol
GigabitEthernet0/0     192.168.10.30    up        up
GigabitEthernet0/1     192.168.10.62    up        up
```

## Understanding interface states

```text
up/up
```

means both the physical interface and line protocol are operating.

```text
administratively down/down
```

usually means that `no shutdown` has not been entered.

```text
up/down
```

means the physical connection exists, but there is a Layer 2 or protocol problem.

---

# 12. Understanding the Routing Table

Command:

```cisco
show ip route
```

The routing table helps the router answer:

```text
What destination network contains this IP?
Where should the packet go next?
Which interface should the packet leave through?
How was this route learned?
```

Expected connected routes:

```text
C 192.168.10.0/27 is directly connected, GigabitEthernet0/0
C 192.168.10.32/27 is directly connected, GigabitEthernet0/1
```

Expected local routes may include:

```text
L 192.168.10.30/32 is directly connected, GigabitEthernet0/0
L 192.168.10.62/32 is directly connected, GigabitEthernet0/1
```

## Common route codes

| Code | Meaning |
|---|---|
| `C` | Connected network |
| `L` | Router's local interface address |
| `S` | Static route |
| `R` | Route learned through RIP |
| `O` | Route learned through OSPF |
| `D` | Route learned through EIGRP |

In this lab, the important codes were:

```text
C = Connected network
L = Local router-interface address
```

I did not configure RIP, OSPF, EIGRP, or static routes in this lab.

---

# 13. Gateway of Last Resort

The **gateway of last resort** is the router's default route.

It is used when no more specific route matches the destination IP.

If the router displays:

```text
Gateway of last resort is not set
```

it means that no default route is configured.

This does not prevent communication between the two lab networks because the router already knows both networks as directly connected routes.

---

# 14. How the Router Processes a Packet

When the router receives a frame:

1. It accepts the frame on the incoming interface.
2. It removes the incoming Ethernet header.
3. It reads the destination IP address inside the packet.
4. It searches the routing table.
5. It selects the best matching route.
6. It determines the outgoing interface or next hop.
7. It decreases the packet's TTL.
8. It creates a new Ethernet frame.
9. It forwards the packet through the selected interface.

```text
Receive frame
     ↓
Remove Layer 2 header
     ↓
Read destination IP
     ↓
Search routing table
     ↓
Choose best route
     ↓
Select outgoing interface
     ↓
Build a new Layer 2 frame
     ↓
Forward packet
```

---

# 15. Longest-Prefix Match

A router may have multiple routes that could match a destination.

The router chooses the route with the longest matching prefix because it represents the most specific destination network.

Example:

```text
192.168.10.0/24
192.168.10.32/27
```

For destination `192.168.10.40`, both routes could match, but `/27` is more specific.

Therefore, the router selects:

```text
192.168.10.32/27
```

I learned the basic idea of longest-prefix matching, but advanced route selection will be explored later.

---

# 16. DHCP Configuration — Left Subnet

The left DHCP/DNS server uses a static address:

```text
IP address:      192.168.10.29
Subnet mask:     255.255.255.224
Default gateway: 192.168.10.30
DNS server:      192.168.10.29
```

The left DHCP pool is:

```text
Pool name:               LEFT_LAN
Default gateway:         192.168.10.30
DNS server:              192.168.10.29
Start IP address:        192.168.10.1
Subnet mask:             255.255.255.224
Maximum number of users: 28
```

The pool distributes:

```text
192.168.10.1–192.168.10.28
```

It does not distribute:

```text
192.168.10.29  DHCP/DNS server
192.168.10.30  Router/default gateway
192.168.10.31  Broadcast address
```

---

# 17. DHCP Configuration — Right Subnet

The right DHCP/DNS server uses a static address:

```text
IP address:      192.168.10.61
Subnet mask:     255.255.255.224
Default gateway: 192.168.10.62
DNS server:      192.168.10.61
```

The right DHCP pool is:

```text
Pool name:               RIGHT_LAN
Default gateway:         192.168.10.62
DNS server:              192.168.10.61
Start IP address:        192.168.10.33
Subnet mask:             255.255.255.224
Maximum number of users: 28
```

The pool distributes:

```text
192.168.10.33–192.168.10.60
```

It does not distribute:

```text
192.168.10.61  DHCP/DNS server
192.168.10.62  Router/default gateway
192.168.10.63  Broadcast address
```

---

# 18. DHCP and Routing Relationship

DHCP provides clients with:

- IP address
- Subnet mask
- Default gateway
- DNS server
- Lease information

The subnet mask tells the client which destinations are local.

The default gateway tells the client where to send packets destined for other networks.

A wrong DHCP subnet mask can cause the client to make incorrect local-versus-remote decisions.

For example, a client in this lab incorrectly receiving:

```text
255.255.255.0
```

instead of:

```text
255.255.255.224
```

may incorrectly believe that both `/27` networks form one local `/24` network.

---

# 19. Diagnosing Duplicate DHCP Pools

Packet Tracer servers may contain a default pool such as:

```text
serverPool
```

If an old `/24` pool remains active while a new `/27` pool is added, a client may receive settings from the wrong pool.

The solution is to:

1. Select the unwanted pool.
2. Remove it.
3. Keep one correct pool for the local subnet.
4. Save the intended pool.
5. Request DHCP again on the client.

Each local DHCP server in this lab should have only the intended `/27` pool.

---

# 20. Understanding APIPA

During troubleshooting, one device received an address similar to:

```text
169.254.22.120
```

This is an **APIPA — Automatic Private IP Addressing** address.

APIPA uses:

```text
169.254.0.0/16
```

A device assigns itself an APIPA address when it cannot obtain a valid address from DHCP.

APIPA indicates that I should inspect:

- Physical cable and link state
- DHCP service state
- DHCP server's static IP
- Server subnet mask
- DHCP pool
- Available leases
- Duplicate or incorrect pools
- Client and server network placement

An APIPA address does not mean that the DHCP server assigned the address. The client generated it for itself after DHCP failed.

---

# 21. Why DHCP Servers Use Static Addresses

A DHCP server should use a known static IP address.

If the DHCP server depended on DHCP for its own address:

- Its address could change.
- Clients might receive an incorrect DNS address.
- Network management would become unreliable.
- The server could fail to provide leases properly.

Infrastructure devices such as routers, DHCP servers, DNS servers, printers, and firewalls commonly use static or reserved addresses.

---

# 22. DHCP Broadcasts and Routers

A DHCP Discover is initially sent as a broadcast because the client does not yet have a usable IP address and does not know the DHCP server.

Routers do not forward Layer 2 broadcasts by default.

In my lab, each subnet had its own DHCP server:

```text
Left subnet  → Left DHCP server
Right subnet → Right DHCP server
```

Therefore, DHCP relay was not required.

If one DHCP server were expected to serve clients in both subnets, the router would require DHCP relay configuration using a command such as:

```cisco
ip helper-address <DHCP-server-IP>
```

That configuration was not required for the final two-server design.

---

# 23. What Is ICMP?

**ICMP** stands for **Internet Control Message Protocol**.

ICMP is used to test reachability and report network conditions.

The `ping` command uses:

```text
ICMP Echo Request
ICMP Echo Reply
```

Common ICMP messages include:

| ICMP message | Purpose |
|---|---|
| Echo Request | Tests whether a destination is reachable |
| Echo Reply | Confirms reachability |
| Destination Unreachable | Reports an unreachable destination |
| Time Exceeded | Reports that the TTL reached zero |
| Redirect | Suggests a better route |

ICMP does not use TCP or UDP port numbers.

It is carried directly inside an IP packet:

```text
Ethernet frame
└── IP packet
    └── ICMP message
```

---

# 24. ARP and ICMP During a Routed Ping

I cleared a device's ARP table and observed the packet exchange in Packet Tracer Simulation Mode.

The source wanted to ping a device in another subnet.

Before sending the ICMP packet, the source performed this decision:

```text
Is the destination in my subnet?
              ↓
             No
              ↓
Send the packet to my default gateway
              ↓
Do I know the gateway's MAC address?
              ↓
             No
              ↓
Send an ARP Request
```

## Observed sequence

```text
1. Source creates an ICMP Echo Request.
2. Source determines that the destination is remote.
3. Source broadcasts an ARP Request for the gateway's MAC.
4. The local switch floods the ARP broadcast.
5. The router interface recognizes its own IP.
6. The router sends a unicast ARP Reply.
7. The source stores the gateway IP-to-MAC mapping.
8. The source sends the ICMP packet to the gateway's MAC.
9. The router reads the destination IP.
10. The router searches its routing table.
11. The router forwards the packet through the other interface.
12. The destination sends an ICMP Echo Reply.
13. The router forwards the reply to the original source.
```

---

# 25. IP and MAC Addresses During Routing

When a packet travels between the two subnets, the source and destination IP addresses normally remain associated with the original endpoints.

The source and destination MAC addresses change when the packet moves through the router.

## First LAN

```text
Source MAC:      Source computer
Destination MAC: Default gateway

Source IP:       Source computer
Destination IP: Final remote device
```

## Second LAN

```text
Source MAC:      Router's outgoing interface
Destination MAC: Final remote device

Source IP:       Original source computer
Destination IP: Final remote device
```

The router removes the old Ethernet frame and builds a new frame for the outgoing network.

```text
IP addresses identify the end-to-end communication.
MAC addresses identify local, hop-by-hop delivery.
```

---

# 26. ARP, Switching, Routing and ICMP Compared

| Technology | Primary purpose | Addressing |
|---|---|---|
| ARP | Finds a local or next-hop MAC address | IPv4 address to MAC address |
| Switching | Forwards frames inside a LAN | MAC addresses |
| Routing | Forwards packets between networks | IP networks and addresses |
| ICMP | Tests reachability and reports network conditions | IP addresses |
| DHCP | Automatically provides network configuration | UDP ports 67 and 68 |

The protocols cooperate during communication:

```text
DHCP provides the configuration
            ↓
Subnet mask determines local or remote
            ↓
ARP finds the next-hop MAC
            ↓
Switch forwards the local frame
            ↓
Router selects the destination network
            ↓
ICMP tests end-to-end reachability
```

---

# 27. Understanding the “Bad Mask” Error

I initially attempted to configure:

```cisco
ip address 192.168.10.63 255.255.255.224
```

Cisco rejected it with:

```text
Bad mask /27 for address 192.168.10.63
```

For the subnet:

```text
192.168.10.32/27
```

the addresses are:

```text
Network ID:    192.168.10.32
Usable hosts:  192.168.10.33–192.168.10.62
Broadcast:     192.168.10.63
```

`192.168.10.63` is a broadcast address and cannot be assigned to a router interface.

The correct router address was:

```text
192.168.10.62/27
```

---

# 28. Understanding the Overlapping-Network Error

I also tested a larger subnet mask and received an overlap error.

If one interface uses:

```text
192.168.10.30/27
```

and another interface uses:

```text
192.168.10.63/25
```

the `/25` network includes:

```text
192.168.10.0–192.168.10.127
```

That range contains the first interface's `/27` network.

Cisco rejects this because two different router interfaces should not normally belong to overlapping IP networks.

Each router interface must represent a separate, unambiguous Layer 3 network.

---

# 29. FLSM — Fixed-Length Subnet Masking

**FLSM** means every subnet uses the same subnet mask.

My final design used:

```text
Left subnet:  192.168.10.0/27
Right subnet: 192.168.10.32/27
```

Both use:

```text
255.255.255.224
```

Both subnets contain:

```text
32 total addresses
30 usable addresses
```

This is an FLSM design because both subnets have equal sizes.

---

# 30. VLSM — Variable-Length Subnet Masking

**VLSM** means different subnets can use different subnet masks based on their host requirements.

The subnet mask changes when the required subnet size changes.

```text
More required hosts
→ larger address block
→ shorter prefix

Fewer required hosts
→ smaller address block
→ longer prefix
```

## Block-size relationship

```text
Block size = 256 - mask octet
Mask octet = 256 - block size
```

| Block size | Usable hosts | Prefix | Subnet mask |
|---:|---:|---:|---|
| 4 | 2 | `/30` | `255.255.255.252` |
| 8 | 6 | `/29` | `255.255.255.248` |
| 16 | 14 | `/28` | `255.255.255.240` |
| 32 | 30 | `/27` | `255.255.255.224` |
| 64 | 62 | `/26` | `255.255.255.192` |

## Example

A LAN requiring 20 hosts needs:

```text
/27
32 total addresses
30 usable addresses
255.255.255.224
```

A LAN requiring 10 hosts needs:

```text
/28
16 total addresses
14 usable addresses
255.255.255.240
```

These two LANs would use different masks.

That would be a VLSM design.

When using VLSM, the largest required subnet should normally be allocated first to reduce address fragmentation and overlap mistakes.

---

# 31. Important Subnetting Rule

For every subnet:

```text
First address = Network ID
Last address  = Broadcast address
Middle range  = Usable host addresses
```

The network and broadcast addresses cannot be assigned to:

- PCs
- Servers
- Router interfaces
- Printers
- Other hosts

Only addresses inside the usable range can be assigned.

---

# 32. Basic STP Observation

While analyzing traffic in Packet Tracer, I also observed STP messages.

**STP** stands for **Spanning Tree Protocol**.

STP operates at Layer 2 and prevents switching loops when multiple redundant paths exist between switches.

Without STP, a broadcast could circulate repeatedly through a loop because an Ethernet frame does not have the same hop-limiting TTL mechanism as an IP packet.

STP can logically block a redundant path while keeping it available as a backup.

My routing topology did not contain a switching loop. The STP traffic appeared because Cisco switches run STP automatically in the background.

STP was not responsible for routing the ICMP packet.

---

# 33. Troubleshooting Method Used

I learned to troubleshoot from the nearest point outward instead of changing random settings.

## Client-side checks

```text
1. Does the client have a valid IP?
2. Is the subnet mask correct?
3. Is the default gateway correct?
4. Did the client receive APIPA?
```

## Connectivity checks

```text
1. Ping the local gateway.
2. Ping the router's remote interface.
3. Ping the final remote host.
```

## Router checks

```cisco
show ip interface brief
show ip route
show running-config
```

## DHCP checks

```text
1. Is the DHCP service enabled?
2. Does the server have a static IP?
3. Is the pool in the correct subnet?
4. Is the pool mask correct?
5. Is the gateway correct?
6. Are infrastructure addresses excluded?
7. Does an incorrect duplicate pool still exist?
```

## Packet Tracer Simulation Mode

Simulation Mode helps identify:

- Which protocol was generated
- Which device received the frame or packet
- Where the packet was forwarded
- Where the packet was dropped
- Whether ARP occurred before ICMP
- Whether the reply successfully returned

---

# 34. Common Mistakes and Corrections

| Mistake | Why it fails | Correction |
|---|---|---|
| Assigning `.63/27` | `.63` is the broadcast address | Use `.62` or another usable address |
| Using `/24` on a `/27` client | Client makes incorrect subnet decisions | Use `255.255.255.224` |
| Using 30 DHCP users starting at `.33` | Includes server and gateway addresses | Use 28 users ending at `.60` |
| Keeping duplicate DHCP pools | Client may receive incorrect settings | Remove the unused pool |
| Giving the DHCP server a dynamic address | Server address may be unavailable or change | Configure a static address |
| Forgetting `no shutdown` | Router interface remains disabled | Enter `no shutdown` |
| Configuring overlapping networks | Router cannot separate the interfaces correctly | Use non-overlapping subnet ranges |
| Assuming first ping failure always means routing failure | ARP resolution may delay the first ping | Repeat the ping and inspect Simulation Mode |
| Randomly changing subnet masks | Creates broadcast, network, or overlap errors | Calculate the subnet boundary first |

---

# 35. Security Relevance

Understanding routing is important in cybersecurity because security controls depend on knowing how traffic moves.

Routing knowledge helps with:

- Firewall rule analysis
- Access-control list troubleshooting
- Network segmentation
- Incident-response packet tracing
- Detecting incorrect or malicious routes
- Understanding lateral movement
- Identifying unauthorized DHCP servers
- Diagnosing gateway impersonation and ARP attacks
- Interpreting ICMP behavior
- Understanding where monitoring tools should be placed

A security analyst should be able to answer:

```text
Where did this packet originate?
Which subnet contains the destination?
Which gateway should receive it?
Which router interface should forward it?
Was the traffic routed, blocked, or misdirected?
```

---

# 36. What This Lab Proves

Through this lab, I demonstrated that I can:

- Convert a host requirement into a subnet size.
- Divide a `/24` network into `/27` subnets.
- Avoid assigning network and broadcast addresses.
- Configure two router interfaces.
- Enable router interfaces.
- Connect two directly attached networks.
- Understand automatically generated connected routes.
- Design separate DHCP pools for separate subnets.
- Reserve infrastructure addresses.
- Diagnose incorrect subnet masks.
- Diagnose an APIPA address.
- Recognize overlapping network configurations.
- Observe ARP before routed ICMP traffic.
- Explain hop-by-hop MAC changes.
- Distinguish FLSM from VLSM.
- Use Packet Tracer for practical network troubleshooting.

---

# 37. Current Scope and Next Steps

This lab covered:

```text
One router
Two directly connected networks
Two /27 subnets
Local DHCP service on each subnet
ARP and ICMP packet analysis
```

Topics for future routing labs include:

- Static routes
- Default routes
- Multiple-router topologies
- DHCP relay using `ip helper-address`
- RIP
- OSPF
- Route metrics
- Administrative distance
- Access Control Lists
- NAT and PAT
- Advanced longest-prefix matching

These topics were not configured in this lab and will be explored separately.

---

# 38. Revision Questions

1. What is the purpose of IP routing?
2. When does a host use its default gateway?
3. Why does a remote destination use the router's MAC address?
4. What is the subnet mask for `/27`?
5. What is the block size for `/27`?
6. What are the first two `/27` subnet boundaries?
7. Why can `.63` not be assigned in `192.168.10.32/27`?
8. What causes a connected route to appear automatically?
9. What do `C` and `L` mean in a Cisco routing table?
10. Why was no static route required in this lab?
11. What does APIPA indicate?
12. Why should a DHCP server use a static IP?
13. Why must router and server addresses be excluded from DHCP leases?
14. What is the difference between ARP and ICMP?
15. Which addresses change when a router forwards a packet?
16. What is the difference between FLSM and VLSM?
17. Why should the largest VLSM subnet be allocated first?
18. What problem does STP prevent?
19. Why might the first ping fail while later pings succeed?
20. Which commands verify interfaces and routes?

---

# 39. Quick Revision Summary

```text
Original network: 192.168.10.0/24

Subnet 1:
Network:  192.168.10.0/27
Clients:  192.168.10.1–28
Server:   192.168.10.29
Gateway:  192.168.10.30
Broadcast:192.168.10.31

Subnet 2:
Network:  192.168.10.32/27
Clients:  192.168.10.33–60
Server:   192.168.10.61
Gateway:  192.168.10.62
Broadcast:192.168.10.63

Mask:       255.255.255.224
Block size: 32
Total:      32 per subnet
Usable:     30 per subnet
DHCP users: 28 per subnet
```

Core communication logic:

```text
Same subnet
→ ARP for the destination
→ Switch forwards locally

Different subnet
→ ARP for the default gateway
→ Switch forwards to router
→ Router checks destination IP
→ Router searches routing table
→ Router forwards through outgoing interface
→ New Ethernet frame is created
```

---

# 40. Reflection

This lab helped me connect several networking concepts that I had previously studied separately.

Subnetting determined the size and boundaries of each network. DHCP provided hosts with the correct network configuration. ARP resolved the MAC address needed for local delivery. The switch forwarded frames inside each LAN. The router used its routing table to move packets between the two subnets. ICMP allowed me to test whether the complete path worked.

The most important lesson was that successful routing depends on every part being consistent:

```text
Correct IP address
+ Correct subnet mask
+ Correct default gateway
+ Active router interface
+ Correct routing-table entry
+ Correct DHCP pool
= Successful inter-network communication
```

I also learned that troubleshooting should be based on evidence. Errors such as `Bad mask`, overlapping networks, APIPA addresses, incorrect DHCP masks, and failed pings each point toward a specific part of the network configuration.

Day 14 established my foundation in directly connected IP routing and prepared me for static routes, multiple routers, DHCP relay, routing protocols, and network-security controls.
