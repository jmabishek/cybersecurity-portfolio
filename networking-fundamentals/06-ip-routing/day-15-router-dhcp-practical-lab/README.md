# 🌐 Day 15 — Practical IP Routing Lab: Router as DHCP Server for Two LANs

## 📂 Packet Tracer lab file

[Download the two-LAN router and DHCP lab](day-15-two-lan-router-dhcp.pkt) and open it in Cisco Packet Tracer. The configuration, address plan, tests, and limits are documented below.

## 📌 Lab overview

Today I built and tested a two-LAN network in Cisco Packet Tracer. This was primarily a practical lab: I configured router interfaces, made the router serve DHCP addresses to both LANs, added PCs and servers, diagnosed configuration mistakes, and verified communication between the LANs.

On Day 14, I practiced routing between directly connected networks and used separate server devices to provide DHCP. In this lab, **the router itself provides DHCP**, so the PCs do not depend on a separate DHCP server device.

I practiced the topology in Packet Tracer Student and a newer Packet Tracer version. I also extended the original layout with more PCs and server devices to test my understanding.

---

## 🎯 What I practiced

- Designing two nonoverlapping IPv4 LANs.
- Choosing subnet sizes from actual host requirements.
- Configuring two router interfaces with IP addresses and subnet masks.
- Enabling interfaces with `no shutdown`.
- Creating a separate DHCP pool on the router for each LAN.
- Providing clients with an IP address, mask, gateway, and DNS server address through DHCP.
- Checking interfaces and directly connected routes.
- Confirming that PCs obtained DHCP settings from the router.
- Testing communication between PCs in different LANs.
- Exploring `ping` and `tracert` as troubleshooting commands.
- Understanding what a switch VLAN does—and what it does **not** automatically configure.
- Keeping statically addressed servers separate from dynamically assigned client addresses.

---

## 🏢 Main topology

```text
LAN A PCs ── Switch ── Fa0/0 [ Router ] Fa0/1 ── Switch ── LAN B PCs
                         │                   │
                   Router DHCP pool A   Router DHCP pool B
```

The router has an interface in each subnet. Each switch connects the devices in its local LAN. The router forwards packets between the two different IP networks.

I also added extra PCs and servers while experimenting. A server can have a static IP address and run a configured service; simply adding a Server-PT device does not automatically make it a DHCP or DNS server.

---

## 🧮 Address planning: an unfamiliar network

I was given the address block:

```text
10.47.36.0/24
```

The requirements were:

| Requirement | LAN A | LAN B |
|---|---:|---:|
| PCs needing DHCP | 40 | 18 |
| Statically addressed server | 1 | 1 |
| Router gateway | 1 | 1 |
| Minimum usable addresses needed | 42 | 20 |

I allocated the larger LAN first.

### LAN A: `/26`

LAN A needs at least 42 usable addresses. A `/26` provides 64 total addresses and 62 usable host addresses:

```text
2^(32 − 26) = 64 total addresses
64 − 2 = 62 usable addresses
```

| LAN A item | Value |
|---|---|
| Network | `10.47.36.0/26` |
| Subnet mask | `255.255.255.192` |
| Full address range | `10.47.36.0–10.47.36.63` |
| Usable host range | `10.47.36.1–10.47.36.62` |
| Broadcast address | `10.47.36.63` |
| Router gateway used | `10.47.36.62` |
| DNS address advertised in DHCP | `10.47.36.61` |

**Important distinction:** 64 is the address block size; 62 is the number of usable host addresses. A `/28` would provide only 16 total addresses and 14 usable hosts, so it would be too small for LAN A.

### LAN B: `/27`

LAN B needs at least 20 usable addresses. A `/27` provides 32 total addresses and 30 usable host addresses:

```text
2^(32 − 27) = 32 total addresses
32 − 2 = 30 usable addresses
```

| LAN B item | Value |
|---|---|
| Network | `10.47.36.64/27` |
| Subnet mask | `255.255.255.224` |
| Full address range | `10.47.36.64–10.47.36.95` |
| Usable host range | `10.47.36.65–10.47.36.94` |
| Broadcast address | `10.47.36.95` |
| Router gateway used | `10.47.36.94` |
| DNS address advertised in DHCP | `10.47.36.93` |

The two address ranges do not overlap:

```text
LAN A: 10.47.36.0–10.47.36.63
LAN B: 10.47.36.64–10.47.36.95
```

Using different subnet sizes for the two LANs is **VLSM**: Variable-Length Subnet Masking.

---

## 🔧 Router interface configuration

My router used `FastEthernet0/0` for LAN A and `FastEthernet0/1` for LAN B.

```cisco
enable
configure terminal

interface fastEthernet0/0
 ip address 10.47.36.62 255.255.255.192
 no shutdown
exit

interface fastEthernet0/1
 ip address 10.47.36.94 255.255.255.224
 no shutdown
exit

end
write memory
```

I initially assigned the interface IP addresses but forgot `no shutdown`. The command:

```cisco
show ip interface brief
```

then showed both interfaces as:

```text
administratively down / down
```

That meant the interfaces had been configured but were still disabled. After entering `no shutdown` under **each** interface, both changed to:

```text
up / up
```

This taught me that assigning an IP address and enabling the interface are separate steps.

### Why the interface addresses matter

- `10.47.36.62/26` places Fa0/0 inside LAN A.
- `10.47.36.94/27` places Fa0/1 inside LAN B.
- Each PC uses the router interface **in its own subnet** as its default gateway.
- When both interfaces are up, the router knows both networks are directly connected.

---

## 📬 Configuring the router as a DHCP server

I created a separate DHCP pool for each LAN. The configuration matching my lab is:

```cisco
enable
configure terminal

ip dhcp excluded-address 10.47.36.62
ip dhcp excluded-address 10.47.36.94

ip dhcp pool LANA
 network 10.47.36.0 255.255.255.192
 default-router 10.47.36.62
 dns-server 10.47.36.61
exit

ip dhcp pool LANB
 network 10.47.36.64 255.255.255.224
 default-router 10.47.36.94
 dns-server 10.47.36.93
exit

end
write memory
```

If I actually assign the advertised DNS addresses to servers as **static IPs**, I must exclude those addresses too:

```cisco
configure terminal
ip dhcp excluded-address 10.47.36.61
ip dhcp excluded-address 10.47.36.93
end
write memory
```

The screenshots show those DNS addresses being handed to PCs, but do not prove that DNS service was configured and functioning on servers at those addresses. Advertising a DNS server IP through DHCP does **not** create a DNS server. I will test DNS separately when I configure it.

### What the DHCP commands mean

| Command | Purpose |
|---|---|
| `ip dhcp pool LANA` | Creates or enters a named router DHCP pool |
| `network 10.47.36.0 255.255.255.192` | Identifies the subnet served by that pool |
| `default-router 10.47.36.62` | Supplies LAN A clients with their local gateway |
| `dns-server 10.47.36.61` | Supplies a DNS server address; DNS must be configured separately |
| `ip dhcp excluded-address 10.47.36.62` | Prevents the router from leasing its reserved gateway address |
| `write memory` / `wr` | Saves the running configuration |

The pool names `LANA` and `LANB` are labels for administration. The `network` command identifies the clients' subnet. `default-router` supplies the gateway they use when the destination is outside that subnet.

**CLI syntax lesson:** On this router, the accepted form was the network address followed by a dotted-decimal mask:

```cisco
network 10.47.36.0 255.255.255.192
```

My attempts to put `/26` into this DHCP `network` command produced an invalid-input error. `/26` is useful subnet notation in documentation, but this command expected a subnet mask.

---

## 🖥️ DHCP evidence from the PCs

I checked the PCs using:

```text
ipconfig /all
```

| Setting | PC0 in LAN A | PC7 in LAN B |
|---|---|---|
| Assigned IP | `10.47.36.1` | `10.47.36.65` |
| Mask | `255.255.255.192` | `255.255.255.224` |
| Default gateway | `10.47.36.62` | `10.47.36.94` |
| DHCP server | `10.47.36.62` | `10.47.36.94` |
| DNS address received | `10.47.36.61` | `10.47.36.93` |

The **DHCP server addresses match the router's local interface addresses**. That is evidence that the router provided the client configuration for both LANs.

It does not, by itself, establish that a DNS lookup works. DHCP assignment and DNS resolution are separate tests.

---

## 🛣️ Routing-table verification

I used:

```cisco
show ip route
```

The router displayed these connected networks:

```text
C 10.47.36.0/26  is directly connected, FastEthernet0/0
C 10.47.36.64/27 is directly connected, FastEthernet0/1
```

`C` means **connected**: the network is attached to an active router interface with an address in that network. I did not need a static route to make these two LANs communicate through this one router.

The routing table also said:

```text
Gateway of last resort is not set
```

That means there was no default route for unknown destinations. It did **not** prevent routing between LAN A and LAN B, because the router already had a connected route for each one. It also means I should not expect this topology alone to reach the public internet.

---

## ✅ Proof of communication between the LANs

After checking DHCP and enabling both router interfaces, I tested traffic in **both directions**.

### From PC0 in LAN A to PC7 in LAN B

```text
PC0: 10.47.36.1/26
Destination PC7: 10.47.36.65/27

ping 10.47.36.65
```

The screenshot shows four replies:

```text
Sent = 4, Received = 4, Lost = 0 (0% loss)
```

### From PC7 in LAN B to PC0 in LAN A

```text
PC7: 10.47.36.65/27
Destination PC0: 10.47.36.1/26

ping 10.47.36.1
```

This also returned:

```text
Sent = 4, Received = 4, Lost = 0 (0% loss)
```

These two successful tests show that the selected PCs can communicate across the subnet boundary through the router. The `ipconfig /all` results separately show that both selected PCs received DHCP configuration from the router.

### What happens to the packet

For PC0 to reach PC7:

1. PC0 sees that `10.47.36.65` is outside its own `10.47.36.0/26` subnet.
2. PC0 sends the packet toward its default gateway, `10.47.36.62`.
3. The local switch forwards the frame to the router.
4. The router checks the destination IP against its routing table.
5. The connected route for `10.47.36.64/27` points toward Fa0/1.
6. The router sends a new local frame toward PC7 on LAN B.
7. PC7 replies through its gateway, `10.47.36.94`, to reach PC0.

The IP packet's source and destination identify the communicating PCs. The Ethernet MAC addresses used for local delivery change as the packet passes through the router.

---

## 🔍 New troubleshooting command: `tracert`

On a **Packet Tracer PC**, the path-tracing command is:

```text
tracert <destination-IP-or-name>
```

On Cisco router IOS, the corresponding command is generally:

```cisco
traceroute <destination-IP-or-name>
```

A trace uses probes with increasing **TTL**, or *time to live*, to reveal routers along a path. TTL is reduced by a router when it forwards an IP packet. When a probe's TTL expires, a responding router may identify itself, allowing the trace to show a hop.

For this lab, I can try:

```text
tracert 10.47.36.65
```

from a LAN A PC. There is only **one router between the two LANs**, so this is a short routed path.

A `*` or `Request timed out` on a trace means that a particular probe did not receive the expected response within the time limit. It does not automatically prove that the destination is unreachable. My successful pings are stronger evidence that these selected PCs can exchange traffic.

Tracing a name such as `google.com` adds another requirement: the name must first resolve through a working DNS server. Reaching Google would additionally require internet connectivity and an appropriate route, neither of which is established by this two-LAN lab.

---

## 🧩 Where VLAN fits into this lab

A **VLAN**, or *Virtual LAN*, is a Layer 2 grouping of switch ports into a broadcast domain. On a Packet Tracer switch, ports can belong to the default **VLAN 1** even when I have not created any new VLANs.

In this topology, each switch connects devices on its own side of the router. The router interfaces separate the two IP networks. The screenshots do **not** show commands creating separate VLAN IDs, assigning switch ports to new VLANs, configuring a trunk, or configuring router subinterfaces. I therefore cannot claim that I implemented VLAN-based segmentation or *router-on-a-stick* in this lab.

The practical distinction I learned is:

| Item | Job |
|---|---|
| Switch port / VLAN membership | Determines the Layer 2 broadcast group |
| Device IP and subnet mask | Determine the device's Layer 3 network |
| Default gateway | Gives a device a path to other IP networks |
| Router DHCP pool | Automatically supplies clients with network settings |

A server being connected to a switch or included in a VLAN does not automatically receive an IP address or start DHCP or DNS. I must configure those separately.

---

## 🛠️ Mistakes and how I corrected them

| Observation | Cause or lesson | Correction |
|---|---|---|
| Both router interfaces displayed `administratively down/down` | Assigning an IP did not enable the interfaces | Enter `no shutdown` under each interface |
| DHCP `network` command rejected `/26` notation | The command expected a network address and dotted-decimal mask | Use `network 10.47.36.0 255.255.255.192` |
| Some commands were rejected at the prompt | Cisco commands depend on the current CLI mode and exact syntax | Read the prompt and use `exit`, `end`, or `enable` as appropriate |
| A gateway address was also potentially available in a pool | Static infrastructure addresses must not be leased to clients | Use `ip dhcp excluded-address` |
| A DNS address appeared in DHCP output | DHCP can advertise an address even when DNS service has not been verified | Configure and test DNS separately |

Useful router checks:

```cisco
show ip interface brief
show ip route
show ip dhcp pool
show ip dhcp binding
show ip dhcp conflict
show running-config
```

Useful PC checks:

```text
ipconfig /all
ping <local-gateway>
ping <remote-PC>
tracert <remote-PC>
```

---

## 🔐 Why this matters for cybersecurity

A security analyst needs to distinguish an addressing failure from a routing failure:

- **Wrong mask:** A client may incorrectly decide whether a destination is local.
- **Wrong gateway:** A client may be unable to leave its subnet.
- **Disabled router interface:** A connected path may not be available.
- **Wrong DHCP pool:** Clients may receive unsuitable IP settings.
- **Conflicting or unreserved address:** A static device and DHCP client may compete for one IP.
- **Incorrect DNS address:** IP-based pings may work while name lookups fail.
- **Unexpected VLAN membership:** Devices may be in an unintended Layer 2 broadcast group.

Checking the client configuration, interfaces, route table, and actual traffic provides evidence for where communication succeeds or fails.

---

## 🧠 My Day 15 takeaway

This lab moved me from recognizing a routing diagram to configuring and checking one myself. I calculated `/26` and `/27` networks from host requirements, assigned router gateway addresses, corrected disabled interfaces, configured router-based DHCP for both LANs, confirmed the clients' assigned settings, and proved communication between a PC in each LAN with successful pings in both directions.

I also learned the limits of that evidence: the lab proves communication between the tested PCs and router-based DHCP assignment. DNS service, internet access, and newly configured VLAN segmentation require their own configuration and tests.

**Next topic:** configure a real DNS service, then test both IP-based communication and name-based communication.
