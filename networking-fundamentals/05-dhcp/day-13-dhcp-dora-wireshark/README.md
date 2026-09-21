# 🌐 Day 13 — DHCP, DORA, and Wireshark Packet Analysis

## 📌 Overview

Today I studied **DHCP (Dynamic Host Configuration Protocol)** and learned how a device automatically receives the network configuration it needs to communicate.

Without DHCP, an administrator would have to manually configure every device. DHCP automates this process and reduces configuration errors such as duplicate or incorrect IP addresses.

I also captured DHCP traffic in Wireshark and identified a complete **DORA** exchange: Discover, Offer, Request, and Acknowledgement.

---

## 🎯 Why DHCP Is Needed

When a new device connects to a network, it may not yet know:

- Its IPv4 address
- Its subnet mask
- The default gateway
- The DNS server
- How long it may use the assigned address

A DHCP server can provide all this information automatically.

```text
New device
    │
    │ Requests network configuration
    ▼
DHCP server
    │
    ├── IP address
    ├── Subnet mask
    ├── Default gateway
    ├── DNS server
    └── Lease duration
```

---

## 🧠 Important DHCP Terminology

| Term | Meaning |
|---|---|
| DHCP client | A device requesting network configuration |
| DHCP server | A service that leases addresses and supplies network settings |
| Lease | Temporary permission to use an IP address |
| Scope or pool | Range of addresses available for DHCP assignment |
| Exclusion | An address or range that the server must not lease dynamically |
| Reservation | An address kept for one specific client identifier, commonly a MAC address |
| Renewal | Extension of an existing lease |
| Release | The client voluntarily returns its leased address |
| DHCP relay | A device that forwards DHCP messages between different networks |

---

## 🔄 The DORA Process

**DORA** describes the normal four-message process used when a client needs DHCP configuration.

```text
CLIENT                                        DHCP SERVER
   │                                                │
   │──── DHCP Discover ────────────────────────────▶│
   │     "Is a DHCP server available?"              │
   │                                                │
   │◀─── DHCP Offer ────────────────────────────────│
   │     "I can offer this address."                 │
   │                                                │
   │──── DHCP Request ─────────────────────────────▶│
   │     "I want to use the offered address."        │
   │                                                │
   │◀─── DHCP ACK ──────────────────────────────────│
   │     "Approved. The address is leased to you."  │
```

### 1️⃣ DHCP Discover

The client does not yet have an IPv4 address and does not know the DHCP server’s address.

Therefore, it broadcasts a DHCP Discover message to locate available DHCP servers.

Typical addressing during DHCP Discover:

```text
Source IP:        0.0.0.0
Destination IP:   255.255.255.255
Source UDP port:  68
Destination port: 67
```

`0.0.0.0` is used because the client does not yet have an IPv4 address.

`255.255.255.255` is the local broadcast address. The client broadcasts because it does not know which device is the DHCP server.

### 2️⃣ DHCP Offer

A DHCP server that receives the Discover message can respond with a DHCP Offer.

The Offer can contain:

- An available IP address
- Subnet mask
- Default gateway
- DNS server
- Lease duration
- DHCP server identifier

Depending on the client’s state and broadcast settings, the Offer may be delivered through broadcast or unicast.

### 3️⃣ DHCP Request

The client sends a DHCP Request indicating that it wants to use the offered address.

This message can also inform other DHCP servers that their offers were not selected.

### 4️⃣ DHCP Acknowledgement

The selected server sends a DHCP ACK.

ACK means **Acknowledgement**. It confirms that the client may use the leased address and supplied configuration.

A DHCP ACK does not mean the address was released.

- **Lease:** The client temporarily receives the address.
- **Release:** The client returns the address to the DHCP server.

---

## 🚪 UDP Ports Used by DHCP

DHCP uses UDP at the Transport layer.

| Endpoint | UDP port |
|---|---:|
| DHCP server | 67 |
| DHCP client | 68 |

The initial client message normally travels like this:

```text
UDP 68 → UDP 67
```

A server response normally travels like this:

```text
UDP 67 → UDP 68
```

DHCP does not establish a TCP connection. It uses UDP and handles missing responses through timeouts and retransmissions.

---

## 🗂️ DHCP Pool, Exclusion, and Reservation

Consider this example:

```text
DHCP pool:      192.168.10.100–192.168.10.200
Excluded range: 192.168.10.100–192.168.10.120
Reservation:    192.168.10.150 → AA:BB:CC:11:22:33
```

### DHCP pool

The pool is the range of addresses available for DHCP assignment.

In this example, the configured pool is:

```text
192.168.10.100–192.168.10.200
```

### Exclusion

An exclusion tells the DHCP server not to lease particular addresses dynamically.

In this example:

```text
192.168.10.100–192.168.10.120
```

cannot be assigned to ordinary DHCP clients.

Excluded addresses may be kept for statically configured devices such as:

- Routers
- Servers
- Switches
- Access points
- Printers

### Reservation

A reservation connects one IP address with a particular client identifier, commonly a MAC address.

```text
AA:BB:CC:11:22:33 → 192.168.10.150
```

The client matching that identifier should receive `192.168.10.150`.

DHCP does not understand that the device is physically a printer. It only recognizes the configured identifier. If the reservation were configured for a laptop’s MAC address, that laptop could receive the reserved address instead.

These pool, exclusion, and reservation numbers are not universal DHCP rules. They are selected by the network administrator.

---

## ⏳ DHCP Lease and Renewal

A dynamically assigned address is normally leased for a limited amount of time.

Before the lease expires, the client attempts to renew it.

An existing client may exchange only:

```text
DHCP Request → DHCP ACK
```

The client may not need Discover and Offer because it already knows:

- Its existing address
- The DHCP server
- Its lease information
- Its previously supplied network configuration

This explains why a Wireshark capture started after a device is already connected may show only Request and ACK.

The server may respond with:

- **DHCP ACK:** The client may continue using the address.
- **DHCP NAK:** The client must stop using the address and obtain valid configuration.

Request and ACK can also appear when a restarted client remembers its previous lease and asks whether it can reuse that address.

---

## 💻 Capturing DHCP With Wireshark on Windows

### Step 1 — Select the active interface

I selected the Wi-Fi interface that was carrying my computer’s network traffic.

Choosing the wrong interface could result in an empty or incomplete capture.

### Step 2 — Start Wireshark capture

I started the capture before running the DHCP commands.

DHCP messages can happen very quickly. If the capture is started too late, some messages may be missed.

### Step 3 — Release the existing address

I opened Command Prompt as administrator and used:

```bat
ipconfig /release
```

This command gives up the existing DHCP lease and temporarily removes the computer’s DHCP configuration.

Internet access may temporarily stop after running this command.

### Step 4 — Request configuration again

I then used:

```bat
ipconfig /renew
```

This tells the computer to request DHCP configuration again.

Because the previous address was released, this process can produce a complete DORA exchange.

### Step 5 — Display the configuration

I used:

```bat
ipconfig /all
```

This command displays information such as:

- IPv4 address
- Subnet mask
- Default gateway
- DHCP server
- DNS servers
- Lease obtained time
- Lease expiration time
- Physical or MAC address

`ipconfig /all` only displays the configuration. It does not initiate the DORA process.

### Step 6 — Filter DHCP packets

I used this Wireshark display filter:

```wireshark
dhcp
```

Some older versions of Wireshark and older tutorials may use:

```wireshark
bootp
```

DHCP was developed using the earlier BOOTP message format, which is why the name BOOTP may still appear in some tools and documentation.

---

## 🔬 Evidence From My Wireshark Capture

My Wireshark capture contained the complete DORA process.

| Packet | Message | Source | Destination | Ports | Transaction ID |
|---:|---|---|---|---|---|
| 418 | Discover | `0.0.0.0` | Broadcast | UDP 68 → 67 | `0x192365e0` |
| 555 | Offer | `192.168.29.1` | Client | UDP 67 → 68 | `0x192365e0` |
| 556 | Request | `0.0.0.0` | Broadcast | UDP 68 → 67 | `0x192365e0` |
| 561 | ACK | `192.168.29.1` | Client | UDP 67 → 68 | `0x192365e0` |

The matching Transaction ID proves that these four messages belong to the same DHCP conversation.

```text
Discover  → Transaction ID 0x192365e0
Offer     → Transaction ID 0x192365e0
Request   → Transaction ID 0x192365e0
ACK       → Transaction ID 0x192365e0
```

I also observed a DHCP Release:

```text
DHCP Release
Transaction ID: 0x87606ad4
```

This appeared after releasing the existing DHCP configuration.

Another Request and ACK exchange appeared with a different Transaction ID:

```text
DHCP Request → Transaction ID 0x15aeb261
DHCP ACK     → Transaction ID 0x15aeb261
```

This Request and ACK belong to a separate DHCP exchange.

Packets should not be grouped only because they appear close together in Wireshark. The **DHCP Transaction ID** must be checked to determine whether packets belong to the same conversation.

For example:

```text
Discover → Transaction ID 0x12345678
Offer    → Transaction ID 0x12345678

Request  → Transaction ID 0x87654321
ACK      → Transaction ID 0x87654321
```

These four packets do not form one complete DORA conversation because the Transaction IDs are different.

---

## 🏠 DHCP on My Home Wi-Fi

On a home network, the Wi-Fi router commonly performs several roles:

```text
Home router
├── Wireless access point
├── Router and default gateway
├── DHCP server
├── NAT/PAT device
└── Often a DNS forwarder
```

In my capture, `192.168.29.1` acted as the DHCP server.

The client received the address:

```text
192.168.29.6
```

A complete DORA process does not necessarily happen every time a device reconnects to Wi-Fi.

If the device still has a valid or remembered lease, it may attempt to renew or reuse the address with:

```text
DHCP Request → DHCP ACK
```

Running `ipconfig /release` followed by `ipconfig /renew` allowed me to intentionally generate and capture DHCP activity.

---

## 🌍 Why DHCP Provides Other Network Settings

DHCP provides more than an IP address.

### IP address — Who is the device?

The IP address identifies the device logically on the network.

Example:

```text
192.168.29.6
```

### Subnet mask — What is local?

The subnet mask helps the client determine whether a destination is:

- Inside its local network
- Outside its local network

Example configuration:

```text
IP address:  192.168.29.6
Subnet mask: 255.255.255.0
Prefix:      /24
```

The local network is:

```text
192.168.29.0/24
```

A destination such as `192.168.29.20` is local.

A destination such as `8.8.8.8` is outside the local network.

The subnet mask and routing table determine whether a destination is local or remote. DNS does not make that decision.

### Default gateway — How does the device leave its network?

The default gateway is the router used to reach destinations outside the local subnet.

Example:

```text
Default gateway: 192.168.29.1
```

If a laptop wants to communicate with `8.8.8.8`, it sends the packet toward the default gateway.

Without a default gateway, the laptop may communicate locally but generally cannot reach outside networks.

### DNS server — How are names resolved?

DNS stands for **Domain Name System**.

DNS translates human-readable domain names into IP addresses.

```text
google.com → IP address
```

Computers use destination IP addresses to send packets. Therefore, when a user enters `google.com`, the computer asks its configured DNS server for the corresponding IP address.

DHCP tells the client which DNS server it should use.

The supplied DNS server might be:

- The home router
- The internet service provider’s DNS server
- A public DNS server such as `8.8.8.8`

Without working DNS, direct communication using IP addresses might still work, but domain names may fail.

### Lease duration — How long may the address be used?

The lease duration tells the client how long it may use the assigned address before renewal is required.

---

## 🔗 Connection Between DHCP, Subnetting, ARP, and Routing

Suppose DHCP provides this configuration:

```text
IP address:      192.168.29.6
Subnet mask:     255.255.255.0
Default gateway: 192.168.29.1
DNS server:      8.8.8.8
```

The laptop first uses the subnet mask to determine that `8.8.8.8` is outside its local network.

It therefore sends the DNS packet toward the default gateway.

Ethernet communication requires a destination MAC address. If the gateway’s MAC address is not already stored in the ARP cache, the laptop uses ARP.

```text
ARP Request:
Who has 192.168.29.1?
Tell 192.168.29.6
```

The router responds with its MAC address.

The outgoing frame then contains:

```text
Destination MAC: Default gateway’s MAC address
Destination IP:  8.8.8.8
```

These destinations are different because:

- The destination MAC identifies the next device on the local link.
- The destination IP identifies the final remote endpoint.

The laptop does not learn Google’s MAC address. It only needs the MAC address of its local default gateway.

---

## 🔁 What Happens at Every Router Hop?

The laptop initially creates a frame like this:

```text
Ethernet frame
├── Source MAC: Laptop MAC
├── Destination MAC: Home router MAC
└── IP packet
    ├── Source IP: Laptop private IP
    └── Destination IP: Remote server IP
```

The home router:

1. Receives the frame.
2. Removes the original Layer 2 frame information.
3. Examines the destination IP address.
4. Checks its routing table.
5. Selects the next hop.
6. Creates a new Layer 2 frame for the next link.

The next frame may contain:

```text
Source MAC:      Router’s outgoing-interface MAC
Destination MAC: Next-hop device’s MAC
```

The laptop’s MAC address does not travel across the internet.

MAC addresses are used hop by hop on local links. IP addresses are used to route packets between networks.

The reply from the remote server does not have to travel through exactly the same routers in reverse. Internet routing can be asymmetric, meaning the forward and return paths may be different.

---

## 🧾 Important Network Tables

Different devices use different tables for different purposes.

| Table or cache | Purpose |
|---|---|
| ARP cache | Maps local IPv4 addresses to local MAC addresses |
| Switch MAC table | Maps MAC addresses to switch ports |
| Routing table | Determines the next hop or interface for an IP network |
| NAT/PAT table | Maps external connections back to internal devices and ports |
| DHCP lease table | Records addresses leased to DHCP clients |

A laptop may have an ARP entry such as:

```text
192.168.29.1 → Home router MAC
```

It will not normally have:

```text
Google IP → Google MAC
```

For remote networks, the routing table tells the laptop to use its default gateway.

---

## 🌉 DHCP Relay and IP Helper

A DHCP Discover is normally a local broadcast.

Routers do not forward local broadcasts between networks by default.

Consider this environment:

```text
Client network: 192.168.10.0/24
DHCP server:    192.168.50.10
```

The client and DHCP server are on different networks.

A DHCP relay or IP helper is configured on the router to forward the DHCP message.

```text
DHCP client
192.168.10.0/24
      │
      │ Broadcast DHCP Discover
      ▼
Router / DHCP relay
      │
      │ Forwards DHCP request
      ▼
DHCP server
192.168.50.10
```

The DHCP relay does not select or assign the IP address.

The actual DHCP server:

- Selects the appropriate scope
- Chooses an available address
- Creates the lease
- Supplies the network configuration

The relay allows the client and server to communicate across a router. It also supplies information that helps the server identify the client’s network and choose the correct DHCP scope.

---

## ⚠️ APIPA Is Not DHCP

APIPA stands for **Automatic Private IP Addressing**.

If a Windows device cannot reach a DHCP server, it may assign itself an address from:

```text
169.254.0.0/16
```

APIPA is:

- Self-assigned by the client
- Link-local
- Not supplied by the DHCP server
- Usually limited to communication on the local link
- Normally unable to provide internet access
- Often evidence that DHCP failed

APIPA normally does not supply:

- A useful default gateway
- Full internet connectivity
- Complete DHCP configuration

---

## ❌ Misconceptions Corrected

| Misconception | Correct understanding |
|---|---|
| DHCP means Dynamic Host Control Protocol | DHCP means **Dynamic Host Configuration Protocol** |
| DHCP ACK means the IP was released | ACK confirms the lease and configuration |
| Every Wi-Fi connection performs full DORA | A client may renew or validate an existing lease using Request and ACK |
| DNS decides whether a destination is local | The subnet mask and routing table determine local versus remote |
| DHCP reservations are universal | Administrators choose the pools, exclusions, and reservations |
| A reservation recognizes that a device is a printer | It matches a configured client identifier, commonly a MAC address |
| `ipconfig /all` triggers DHCP | It only displays the current network configuration |
| APIPA is supplied by DHCP | APIPA is self-assigned when DHCP cannot be reached |
| A remote server sees the laptop’s MAC | MAC addresses remain local and change at routed hops |
| DHCP relay assigns the client’s IP | The DHCP server assigns it; the relay forwards the messages |

---

## ✅ What I Learned

- Why automatic network configuration is necessary
- What DHCP provides to a client
- How the DORA process assigns a lease
- Why DHCP uses UDP ports 67 and 68
- The difference between a pool, exclusion, reservation, lease, renewal, and release
- Why an existing client may show only Request and ACK
- How to force and capture DHCP activity on Windows
- How to filter DHCP traffic in Wireshark
- How to group DHCP packets using their Transaction ID
- How DHCP connects to subnetting, DNS, ARP, default gateways, and routing
- Why remote IP and local destination MAC addresses can be different
- Why a DHCP relay is required when the server is on another network
- Why APIPA is different from DHCP configuration

---

## 📝 Final Reflection

DHCP is more than a service that gives a device an IP address. It supplies the network configuration that allows the device to identify its local network, reach remote networks, resolve domain names, and determine how long it may use an address.

Capturing DHCP traffic in Wireshark connected the protocol theory to real network packets. I observed DHCP Release, the complete Discover–Offer–Request–ACK process, and a separate Request–ACK exchange.

The matching Transaction ID allowed me to prove which packets belonged to the same DHCP conversation. This practical capture also connected DHCP with concepts I previously studied, including subnetting, UDP ports, ARP, MAC addresses, default gateways, routing, and NAT.
