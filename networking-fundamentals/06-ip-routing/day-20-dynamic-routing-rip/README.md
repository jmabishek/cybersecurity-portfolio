# 🌐 Day 20 — Dynamic Routing with RIP

<!-- portfolio-quick-review:start -->

## ⚡ Quick Review

* **Problem:** Static routing requires manually configuring routes to remote networks.
* **What I practiced:** Removed static routes, configured RIP on three routers, and verified dynamically learned networks.
* **Result:** Remote networks appeared in routing tables with the code `R`.
* **Routing Protocol:** RIP — Routing Information Protocol.
* **Metric:** Hop count.
* **Administrative Distance:** 120.
* **Maximum usable metric:** 15 hops.
* **Key Understanding:** RIP automatically exchanges routing information between participating routers, reducing the need to configure every remote route manually.

**Main takeaway:** RIP learns remote network routes dynamically. The `network` command enables RIP participation on matching interfaces; it does not manually create a static route.

[Read the full learning notes ↓](#full-learning-notes)

---

<a id="full-learning-notes"></a>

<!-- portfolio-quick-review:end -->

# 🎯 1. What I Practiced

* Removed previously configured static routes.
* Enabled RIP on Cisco routers.
* Configured RIPv2.
* Advertised connected networks.
* Understood the purpose of the `network` command.
* Verified RIP-learned routes.
* Compared RIPv1 and RIPv2.
* Understood hop count and Administrative Distance.
* Learned `no auto-summary`.
* Learned how to remove individual RIP networks and the entire RIP process.
* Understood why RIP is not suitable for many large networks.

**Objective:** Understand how routers learn remote networks dynamically instead of manually configuring every route.

---

# 🧠 2. Static Routing vs RIP

Before learning RIP, I configured routes manually.

Example:

```cisco
ip route 192.168.1.0 255.255.255.0 200.200.200.1
```

This tells the router:

> To reach network `192.168.1.0/24`, forward packets toward `200.200.200.1`.

With RIP, participating routers exchange routing information and learn remote networks automatically.

```text
STATIC ROUTING

Administrator configures route
           |
           v
Router installs route
           |
           v
Packets forwarded


DYNAMIC ROUTING (RIP)

Routers exchange routes
           |
           v
Router learns remote networks
           |
           v
Routes installed automatically
           |
           v
Packets forwarded
```

### Comparison

| Static Routing                          | RIP                                           |
| --------------------------------------- | --------------------------------------------- |
| Routes configured manually              | Routes learned dynamically                    |
| Uses `ip route`                         | Uses `router rip`                             |
| Routing-table code `S`                  | Routing-table code `R`                        |
| Administrator specifies next hop        | RIP learns next hops                          |
| Changes require manual maintenance      | RIP can react to route changes                |
| Useful for simple, predictable networks | Useful for small dynamic-routing environments |

**Important:** Static routing and RIP can operate on the same router.

Enabling RIP does not automatically remove existing static routes.

---

# 🗺️ 3. My Three-Router Packet Tracer Lab

## Network Topology

```text
         LAN 1
    192.168.1.0/24
           |
           |
        Router0
           |
           |
    200.200.200.0/24
           |
           |
       HQ Router
           |
           +----------- LAN 0
           |         192.168.0.0/24
           |
    100.100.100.0/24
           |
           |
        Router2
           |
           |
         LAN 2
    192.168.2.0/24
```

### Network Details

| Network            | Purpose      |
| ------------------ | ------------ |
| `192.168.1.0/24`   | Router0 LAN  |
| `200.200.200.0/24` | Router0 ↔ HQ |
| `192.168.0.0/24`   | HQ LAN       |
| `100.100.100.0/24` | HQ ↔ Router2 |
| `192.168.2.0/24`   | Router2 LAN  |

Every router already knows its directly connected networks.

The challenge is learning networks connected to other routers.

### Before RIP

Router0 knows:

```text
C 192.168.1.0/24
C 200.200.200.0/24
```

Router0 does not automatically know how to reach:

```text
192.168.0.0/24
192.168.2.0/24
```

That's why routing information must be configured or learned.

---

# 🔧 4. RIP Configuration — Practical Commands

## Step 1 — Remove Old Static Routes

To observe routes being learned through RIP, I removed the static routes used for the same destinations.

Example on HQ:

```cisco
en
conf t

no ip route 192.168.1.0 255.255.255.0 200.200.200.1
no ip route 192.168.2.0 255.255.255.0 100.100.100.1

end
```

**Important:** Removing static routes is not mandatory to enable RIP.

I removed them for this lab to verify that remote networks were being learned dynamically.

A static route with Administrative Distance 1 normally takes priority over a RIP route with AD 120 when both refer to the same destination prefix.

## Step 2 — Configure RIP on Router0

Router0 connects to:

```text
192.168.1.0/24
200.200.200.0/24
```

Configuration:

```cisco
en
conf t

router rip
version 2
no auto-summary

network 192.168.1.0
network 200.200.200.0

end
wr
```

## Step 3 — Configure RIP on HQ

HQ connects to:

```text
192.168.0.0/24
200.200.200.0/24
100.100.100.0/24
```

Configuration:

```cisco
en
conf t

router rip
version 2
no auto-summary

network 192.168.0.0
network 200.200.200.0
network 100.100.100.0

end
wr
```

## Step 4 — Configure RIP on Router2

Router2 connects to:

```text
192.168.2.0/24
100.100.100.0/24
```

Configuration:

```cisco
en
conf t

router rip
version 2
no auto-summary

network 192.168.2.0
network 100.100.100.0

end
wr
```

### Original Lab vs Improved Configuration

In my original recorded lab, Router0 explicitly used `version 2`, while the HQ and Router2 configuration blocks did not explicitly include that command.

The updated configurations above represent a cleaner RIPv2 setup:

* Explicitly enable RIPv2 on all participating routers.
* Disable automatic classful summarization.
* Include the required connected networks.

These are recommended revised configurations, not a claim that every command appeared in my original lab.

---

# 🧠 5. Understanding Every RIP Command

| Command               | Purpose                                          |
| --------------------- | ------------------------------------------------ |
| `router rip`          | Enables or enters RIP configuration              |
| `version 2`           | Specifies RIPv2                                  |
| `no auto-summary`     | Disables automatic classful route summarization  |
| `network 192.168.1.0` | Enables RIP participation on matching interfaces |
| `end`                 | Returns to privileged EXEC mode                  |
| `wr`                  | Saves the configuration                          |
| `sh ip route`         | Displays the routing table                       |
| `sh ip protocols`     | Displays routing protocol information            |

## What Does `network` Actually Do?

Consider:

```cisco
network 192.168.1.0
```

This does **not** mean:

> Create a new route to 192.168.1.0.

Instead, it tells RIP to include matching connected interfaces in the routing process.

The directly connected network can then be advertised through other RIP-enabled interfaces.

For example:

```text
Router0
   |
   | Connected LAN
   | 192.168.1.0/24
   |
   | RIP Advertisement
   v
  HQ
   |
   | Learns route
   v
192.168.1.0/24 via Router0
```

### Important Distinction

```cisco
ip route 192.168.1.0 255.255.255.0 200.200.200.1
```

Manually creates a route.

```cisco
network 192.168.1.0
```

Makes matching connected interfaces participate in RIP.

**One technical detail:** Traditional Cisco RIP `network` statements use classful network matching. They are not the same as OSPF `network` statements, which use wildcard masks.

---

# 🔄 6. Why Must We Include Router-to-Router Networks?

Suppose Router0 has:

```text
LAN: 192.168.1.0/24
        |
     Router0
        |
WAN: 200.200.200.0/24
        |
       HQ
```

Configuration:

```cisco
router rip
version 2

network 192.168.1.0
```

### Will RIP Updates Reach HQ?

❌ Not through the `200.200.200.0/24` link with this configuration alone.

Why?

RIP has only been enabled on interfaces matching `192.168.1.0`.

The router-to-router interface is not participating in RIP.

### Correct Configuration

```cisco
router rip
version 2

network 192.168.1.0
network 200.200.200.0
```

Now RIP can exchange routing information over the router-to-router connection, assuming HQ is also configured correctly.

**Important:** Router0 and HQ may still communicate using their directly connected interface IP addresses even without RIP.

What fails is RIP route exchange over the unconfigured interface.

---

# 🔢 7. RIP Metric — Hop Count

RIP uses **hop count** to select routes.

A hop is a router-routing step toward the destination network.

Consider:

```text
Router0 ---- HQ ---- Router2 ---- LAN
```

Router0 reaches Router2's LAN through two routing hops.

```text
Destination: 192.168.2.0/24

RIP Metric: 2
```

### Example — Choosing a Path

```text
PATH A

Router0 → HQ → Destination

Hop Count = 1


PATH B

Router0 → Router2 → Router3 → HQ → Destination

Hop Count = 3
```

✅ RIP prefers Path A because it has fewer hops.

### RIP Limitation

RIP does not calculate path quality using bandwidth.

For example:

```text
Path A: 1 hop, 10 Mbps

Path B: 2 hops, 1 Gbps
```

RIP normally prefers Path A because it has fewer hops, even though its connection is slower.

**This is one reason OSPF can be more suitable for complex networks.**

---

# ⚠️ 8. RIP's 15-Hop Limitation

RIP supports a maximum usable metric of 15.

```text
1 hop      ✅ Reachable
2 hops     ✅ Reachable
...
15 hops    ✅ Reachable

16 hops    ❌ Unreachable
```

In RIP:

**16 means infinity or an unreachable route.**

### Important Correction

This does not mean:

* RIP supports only 15 routers in an entire organization.
* RIP supports only 15 LANs.
* RIP supports only 15 IP networks.

The limitation applies to the **hop-count metric of a route**.

A network can contain more than 15 routers while still having reachable routes whose RIP metrics remain within the limit.

---

# 📊 9. Reading RIP Routing Tables

Verification command:

```cisco
sh ip route
```

### Recorded Lab Result

HQ learned routes similar to:

```text
R 192.168.1.0/24 [120/1] via 200.200.200.1

R 192.168.2.0/24 [120/1] via 100.100.100.1
```

### Understanding the Output

```text
R 192.168.1.0/24 [120/1] via 200.200.200.1
```

| Value            | Meaning                   |
| ---------------- | ------------------------- |
| `R`              | Route learned through RIP |
| `192.168.1.0/24` | Destination network       |
| `120`            | Administrative Distance   |
| `1`              | Hop-count metric          |
| `200.200.200.1`  | Next-hop router IP        |

## Administrative Distance vs Metric

These are different concepts.

**Administrative Distance (AD):** Determines preference between different routing information sources for the same destination prefix.

**Metric:** Determines which route is preferable within a routing protocol.

### Common Cisco Administrative Distances

| Route Source       | Default AD |
| ------------------ | ---------: |
| Directly Connected |          0 |
| Static             |          1 |
| OSPF               |        110 |
| RIP                |        120 |

**Lower Administrative Distance is preferred when comparing routes to the same destination prefix.**

Example:

```text
RIP:  [120/2]

OSPF: [110/20]
```

✅ OSPF normally wins because AD 110 is lower than 120.

However, RIP's metric `2` and OSPF's cost `20` are different types of measurements.

They should not be directly compared.

Also, routers use the longest matching destination prefix when selecting a forwarding route.

---

# 🆚 10. RIPv1 vs RIPv2

| Feature                          | RIPv1     | RIPv2     |
| -------------------------------- | --------- | --------- |
| IPv4 support                     | ✅         | ✅         |
| Includes subnet masks in updates | ❌         | ✅         |
| Supports VLSM                    | ❌         | ✅         |
| Classless routing updates        | ❌         | ✅         |
| Update delivery                  | Broadcast | Multicast |
| Authentication support           | ❌         | ✅         |
| Maximum usable metric            | 15        | 15        |

### Why Use RIPv2?

Consider:

```text
192.168.1.0/24

192.168.2.0/26
```

These networks use different subnet masks.

RIPv1 does not include subnet masks in its advertisements.

RIPv2 includes subnet masks and therefore supports classless routing information.

### What About RIPv3 and RIPv4?

For Cisco IPv4 RIP configuration, the standard version options are RIPv1 and RIPv2.

IPv6 uses a related protocol called **RIPng (RIP Next Generation)**.

RIPng is not configured by simply entering `version 3` under IPv4 RIP.

---

# 🔍 11. Understanding `no auto-summary`

RIPv2 supports subnet masks, but automatic classful summarization can still cause problems.

### Example

Suppose a router has:

```text
10.1.1.0/24

10.1.2.0/24
```

When advertising these routes across a classful network boundary, automatic summarization can advertise:

```text
10.0.0.0/8
```

This is much larger than the original networks.

It can incorrectly suggest that the router can reach addresses it does not actually know.

### Solution

```cisco
router rip
version 2
no auto-summary
```

This disables automatic classful summarization.

### Important Distinction

`version 2`:

Supports advertising subnet masks.

`no auto-summary`:

Prevents automatic summarization at classful boundaries.

`no auto-summary` does **not** enable interfaces or advertise networks by itself.

We still require the correct `network` statements.

---

# 🔌 12. How RIP Exchanges Routing Information

RIPv2 normally uses:

```text
Transport Protocol: UDP

Destination Port: 520

Multicast Address: 224.0.0.9
```

Routers send periodic RIP routing updates, normally every 30 seconds.

### Example

```text
Router0                         HQ
   |                             |
   | RIP Update                  |
   | 192.168.1.0/24              |
   |---------------------------->|
   |                             |
   |                    HQ learns route
   |                             |
   |<----------------------------|
   | RIP Update                  |
   | 192.168.0.0/24              |
   |                             |
```

### Does RIP Run for Every Data Packet?

❌ No.

RIP exchanges routing information to maintain routes.

When a router forwards a normal packet, it uses its existing routing or forwarding information.

```text
RIP learns route
       |
       v
Route installed
       |
       v
PC sends packet
       |
       v
Router forwards packet
```

RIP does not need to exchange a new routing update for every forwarded packet.

---

# ⏳ 13. RIP Updates and Convergence

**Convergence** means routers updating their routing information after a network change until they have a consistent view of reachable routes.

Example:

```text
Router0 ---- HQ ---- Router2
```

If the connection between HQ and Router2 fails:

```text
Router0 ---- HQ   X   Router2
```

RIP must detect the failure and update affected routes.

It does not necessarily happen immediately.

### Common RIP Timers

| Timer     | Typical Value | Purpose                                        |
| --------- | ------------- | ---------------------------------------------- |
| Update    | 30 seconds    | Periodic routing updates                       |
| Invalid   | 180 seconds   | Route considered invalid after missing updates |
| Hold-down | 180 seconds   | Helps control unstable route changes           |
| Flush     | 240 seconds   | Removes stale routing information              |

The exact values depend on configuration and platform.

### Recorded Lab Observation

During practice, a RIP route appeared as:

```text
R 192.168.2.0/24 is possibly down
```

This indicated that the router was treating the learned route as potentially unavailable.

**Important:** Dynamic routing can respond to topology changes, but it does not guarantee zero packet loss.

---

# 🔐 14. RIP and Passive Interfaces

Normally, RIP sends routing updates through RIP-enabled interfaces.

But a LAN containing ordinary PCs does not need RIP routing updates.

Example:

```text
LAN PCs
   |
Fa0/0
 Router0
Fa0/1
   |
  HQ
```

We can stop RIP updates from being sent through the LAN-facing interface.

```cisco
router rip
passive-interface FastEthernet0/0
```

Shortcut:

```cisco
pass fa0/0
```

Assuming `Fa0/0` connects to the PC LAN.

### Important Rules

* The LAN can still be advertised through other RIP-enabled interfaces.
* The router continues routing packets for that LAN.
* RIP updates are not sent through the passive interface.
* The router-to-router interface should not be made passive if normal RIP update exchange is required there.

This command is optional for the basic connectivity lab but useful for cleaner network configuration.

---

# ❌ 15. Removing RIP Configurations

## Remove the Entire RIP Process

```cisco
en
conf t

no router rip

end
wr
```

### What Happens?

* RIP configuration is removed.
* Routes learned through that RIP process are removed.
* Interface IP addresses remain unchanged.
* Directly connected networks remain available.
* Static routes remain configured.

## Remove Only One Network

Suppose:

```cisco
router rip
network 192.168.1.0
network 200.200.200.0
```

Remove:

```cisco
no network 192.168.1.0
```

### What Happens?

* The specified network statement is removed from RIP.
* RIP can remain active on other participating interfaces.
* The corresponding directly connected network is not deleted.

**Important:** Removing a RIP `network` command does not remove the interface IP address.

---

# ✅ 16. What Works / What Doesn't

| Scenario                                                  | Works? | Reason                                                                      |
| --------------------------------------------------------- | ------ | --------------------------------------------------------------------------- |
| Routers exchange RIP updates over enabled interfaces      | ✅      | Both interfaces participate in RIP                                          |
| RIP learns remote networks automatically                  | ✅      | Routers exchange routing information                                        |
| RIP routes appear with `R`                                | ✅      | `R` identifies RIP-learned routes                                           |
| `network` manually creates static routes                  | ❌      | It enables RIP participation                                                |
| Only the LAN network is enabled in RIP                    | ⚠️     | Router-to-router interface must also participate for updates over that link |
| Different subnet masks with RIPv2                         | ✅      | RIPv2 carries subnet-mask information                                       |
| RIPv1 reliably supports VLSM                              | ❌      | RIPv1 does not advertise subnet masks                                       |
| RIP supports routes with metric 16                        | ❌      | Metric 16 means unreachable                                                 |
| RIP always selects the fastest physical link              | ❌      | RIP uses hop count                                                          |
| RIP and static routing exist together                     | ✅      | Both can be configured                                                      |
| RIP automatically removes static routes                   | ❌      | Static routes remain unless removed                                         |
| Removing RIP deletes connected networks                   | ❌      | Interface configurations remain                                             |
| Making a LAN interface passive prevents LAN advertisement | ❌      | The LAN can still be advertised through other active RIP interfaces         |
| RIP updates are exchanged for every forwarded packet      | ❌      | RIP maintains routing information separately from data forwarding           |

---

# 🛠️ 17. Verification and Troubleshooting

Although RIP was successfully practiced, verification is important before declaring a configuration complete.

| Command           | Purpose                                                              |
| ----------------- | -------------------------------------------------------------------- |
| `sh ip int br`    | Check interface IP addresses and status                              |
| `sh ip route`     | Inspect the routing table                                            |
| `sh ip protocols` | Check RIP version, networks, timers, and routing information sources |
| `sh run`          | Inspect the running configuration                                    |
| `ping <IP>`       | Test connectivity                                                    |
| `wr`              | Save configuration                                                   |

### Quick Verification

**1. Check interfaces**

```cisco
sh ip int br
```

Expected: Required interfaces should normally show `up/up`.

**2. Check routing protocol**

```cisco
sh ip protocols
```

Verify:

```text
Routing Protocol is "rip"
```

Confirm the expected RIP version and participating networks.

**3. Check routing table**

```cisco
sh ip route
```

Look for:

```text
R 192.168.2.0/24 [120/2]
```

**4. Test connectivity**

```cisco
ping 192.168.2.10
```

Use the actual destination IP from the lab.

### Important Lesson

A route appearing in the routing table does not guarantee that a destination PC is reachable.

The network still requires:

* Working interfaces.
* Correct addressing.
* Valid forward and return routes.
* Proper default gateways on end devices.
* No blocking security rules.

---

# 🔐 18. Cybersecurity Relevance

Understanding RIP helps identify routing-related problems during network investigations.

| Scenario                 | Relevance                                                  |
| ------------------------ | ---------------------------------------------------------- |
| Missing routes           | Identify routing failures                                  |
| Network outages          | Understand how routers respond to link failures            |
| Unexpected route changes | Investigate possible incorrect or malicious advertisements |
| Route manipulation       | Understand risks from unauthorized routing updates         |
| Network monitoring       | Recognize RIP packets and routing activity                 |
| Segmentation testing     | Confirm whether networks have valid routes between them    |

RIP is generally not preferred for modern large enterprise routing designs because of its scalability, convergence, and metric limitations.

However, understanding it provides a useful foundation for studying OSPF and network security.

---

# 🧠 19. What I Learned Beyond Configuration

The most important improvement in my understanding was learning what each RIP command actually changes.

### My Mental Model

```text
Router Interfaces Configured
             |
             v
Directly Connected Networks Exist
             |
             v
Enable RIP
             |
             v
Choose RIPv2
             |
             v
Enable RIP on Required Interfaces
             |
             v
Routers Exchange Routing Updates
             |
             v
Remote Networks Learned
             |
             v
Routing Table Updated
             |
             v
Packets Forwarded
```

### Key Takeaways

**`router rip`**

Enters RIP configuration.

**`version 2`**

Selects RIPv2.

**`network`**

Enables RIP on matching connected interfaces.

**`no auto-summary`**

Disables automatic classful route summarization.

**`sh ip route`**

Shows installed routes.

**`sh ip protocols`**

Shows routing protocol information.

**`no network`**

Removes a particular RIP network statement.

**`no router rip`**

Removes the entire RIP configuration.

**Hop Count**

RIP's route-selection metric.

**Administrative Distance 120**

RIP's default route-source preference value on Cisco routers.

---

# 📌 20. Lab Evidence and Scope

### Successfully Practiced

* Three-router Packet Tracer topology.
* Removal of previously configured static routes.
* RIP configuration across Router0, HQ, and Router2.
* Dynamic learning of remote LAN networks.
* RIP routing-table verification.
* Interpretation of `R` routing entries.
* Interpretation of `[120/1]` and `[120/2]`.
* Observation of a route becoming possibly unavailable.

### Understanding Strengthened Through Revision

* Difference between static and dynamic routing.
* Why router-to-router networks must participate in RIP.
* RIPv1 vs RIPv2.
* RIP's 15-hop limitation.
* Administrative Distance vs metric.
* Purpose of `no auto-summary`.
* RIP update behavior.
* Passive-interface configuration.
* Removing individual RIP networks.
* Removing the entire RIP process.
* Why forward and return routes are both necessary for successful communication.

**Evidence note:** The recorded routing results come from the original Packet Tracer lab. Additional commands introduced during revision are presented as improved configuration practices, not as previously captured experimental results.

---

## ✅ Day 20 — Dynamic Routing with RIP Completed

This lab helped me move from manually configuring routes to understanding how routers exchange routing information dynamically.

I can now explain:

* Why RIP exists.
* How RIP discovers remote networks.
* Why `network` differs from `ip route`.
* How RIP chooses routes.
* Why RIP has a 15-hop limitation.
* Why RIPv2 is preferable to RIPv1.
* How to configure, verify, modify, and remove RIP.
* Why successful routing requires both forward and return paths.

**Final Takeaway:**

> Static routing tells a router exactly where to forward packets. RIP allows routers to exchange routing information and learn remote networks automatically, using hop count to compare available paths.


