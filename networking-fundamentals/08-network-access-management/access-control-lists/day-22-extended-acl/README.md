# 🛡️ Day 22 — Access Control Management: Extended ACLs

<!-- portfolio-quick-review:start -->

## ⚡ Quick Review

* **Topic:** Access Control Management → Access Control Lists → Extended ACLs.
* **Problem:** Routing allows networks to communicate, but organizations need to control which devices can access specific servers and services.
* **What I practiced:** Configured, applied, modified, verified, and removed extended ACLs using Cisco Packet Tracer.
* **Main Focus:** Source IP, destination IP, protocols, port numbers, permit/deny rules, sequence numbers, and interface directions.
* **Lab Scenario:** Restricting access from an HR network to HR and IT servers.
* **Key Commands:** `ip access-list extended`, `permit`, `deny`, `ip access-group`, `show ip access-lists`.
* **Important Principle:** ACL rules are evaluated in sequence, and the first matching rule determines whether a packet is permitted or denied.
* **Verification:** Tested ACL configurations and observed their effects on network traffic in Packet Tracer.

**Main takeaway:** An ACL controls traffic based on configured matching conditions. Understanding which packets match, where the ACL is applied, and how the rules are ordered is essential for correct filtering.

**Scope:** This session covers extended IPv4 ACLs only. Standard ACLs and advanced ACL features are reserved for future study.

[Read the full learning notes ↓](#full-learning-notes)

---

<a id="full-learning-notes"></a>

<!-- portfolio-quick-review:end -->

# 🎯 1. What I Practiced

During this session, I worked with extended ACLs in Cisco Packet Tracer.

I practiced:

- Creating named extended ACLs.
- Understanding source and destination IP addresses.
- Using wildcard masks for source network matching.
- Filtering TCP traffic using destination port numbers.
- Allowing HTTPS while restricting other traffic.
- Understanding rule sequence numbers.
- Applying ACLs inbound and outbound.
- Modifying and removing individual ACL entries.
- Detaching ACLs without deleting their configurations.
- Understanding implicit deny.
- Verifying rules and examining match counters.
- Connecting ACL behavior with routing, ARP, and Ethernet switching.

**Objective:** Understand not only how to configure an extended ACL, but also why it permits or denies particular packets.

---

# 🧠 2. Understanding Access Control Management

In network security, access control determines which traffic or users are allowed to access particular resources.

The broader topics identified for study are:

```text
Network Security Fundamentals
          |
          |
          +── Network Access Control
          |
          +── Network Segmentation
          |
          +── Remote Access Control
```

Our current focus is:

```text
ACCESS CONTROL MANAGEMENT
          |
          v
   ACCESS CONTROL LISTS
          |
     +----+----+
     |         |
     v         v
  Standard   Extended
    ACL        ACL
     |         |
   Later    DAY 22 ✅
```

### What Is an ACL?

An **Access Control List (ACL)** is a collection of rules used to permit or deny network traffic.

Extended IPv4 ACLs can match:

- Source IP address.
- Destination IP address.
- IP protocol.
- TCP or UDP port numbers.
- Other protocol-specific information when supported.

### Why Do We Need ACLs?

Routing answers:

> Where should this packet go?

ACL filtering answers:

> Is this packet allowed to pass through this point in the network?

A router may know how to reach a server, but an ACL can prevent particular traffic from reaching it.

**Important:** An ACL filters traffic. It does not create routes, assign IP addresses, or guarantee that a permitted connection will succeed.

---

# 🗺️ 3. My Packet Tracer Lab

## Network Topology

```text
              HR DEPARTMENT
              192.168.1.0/24
                     |
                    PC0
                     |
                  Switch0
                     |
                   Fa0/0
               +-----------+
               |  Router0  |
               |   (B1R1)  |
               +-----------+
                   Fa0/1
                     |
                     |
                 HQ Router
                     |
                  Switch1
                  /     \
                 /       \
                /         \
          HR SERVER     IT SERVER
         192.168.0.100 192.168.0.120
```

### Lab Details

| Component | Purpose |
|---|---|
| HR network | `192.168.1.0/24` |
| Router0 | Applies traffic filtering for the HR network |
| Fa0/0 | Interface facing the HR LAN |
| HR server | `192.168.0.100` |
| IT server | `192.168.0.120` |
| HTTPS | TCP destination port 443 |
| HTTP | TCP destination port 80 |

**Note:** Only addressing relevant to the ACL exercise is shown. Other interface addresses and routing configurations are omitted.

### Initial Security Requirement

Allow HR network devices to access the HR server using HTTPS.

Restrict other IPv4 traffic originating from the HR network as specified by the ACL.

Rather than modifying the HQ router, the exercise applies filtering on Router0.

---

# 💻 4. My Original Extended ACL Configuration

## Step 1 — Create the ACL

**Device:** Router0

```cisco
en
conf t

ip access-list extended HR-SERVER
```

### Understanding the Command

| Component | Purpose |
|---|---|
| `ip access-list` | Create or enter an IPv4 ACL |
| `extended` | Select the extended ACL type |
| `HR-SERVER` | Name used to identify the ACL |

The ACL name is an identifier.

It does not determine which destination server is protected.

The actual filtering behavior depends on the rules inside the ACL.

The name does not require uppercase letters, but consistent spelling and capitalization should be maintained.

### Command Shortcut

```cisco
ip access-list ext HR-SERVER
```

Cisco IOS supports abbreviated keywords when the abbreviation is unambiguous.

---

## Step 2 — Permit HTTPS to the HR Server

```cisco
10 permit tcp 192.168.1.0 0.0.0.255 host 192.168.0.100 eq 443
```

### Understanding Each Component

| Component | Meaning |
|---|---|
| `10` | ACL sequence number |
| `permit` | Allow matching packets |
| `tcp` | Match TCP traffic |
| `192.168.1.0` | Source network |
| `0.0.0.255` | Source wildcard mask |
| `host` | Match one specific IP address |
| `192.168.0.100` | Destination HR server |
| `eq` | Equal to |
| `443` | Destination TCP port |

### What Am I Telling the Router?

Permit TCP packets:

```text
SOURCE:
192.168.1.0/24
       |
       |
       v
DESTINATION:
192.168.0.100
       |
       |
       v
DESTINATION PORT:
443 (HTTPS)
```

The rule matches TCP packets from the HR network to the HR server when the destination port is 443.

**Important distinction:** Matching TCP port 443 does not prove that the traffic is genuinely HTTPS. The ACL checks packet header information, not the application's identity.

---

# 🔢 5. Understanding Wildcard Masks

Original command:

```cisco
permit tcp 192.168.1.0 0.0.0.255 host 192.168.0.100 eq 443
```

The wildcard mask is:

```text
0.0.0.255
```

### Wildcard Rules

```text
0 → Corresponding bits must match.

1 → Corresponding bits can vary.
```

For a `/24` network:

```text
Subnet Mask:    255.255.255.0

Wildcard Mask:    0.0.0.255
```

### Matching Example

```text
192.168.1.10    ✅ Match
192.168.1.25    ✅ Match
192.168.1.100   ✅ Match
192.168.1.254   ✅ Match

192.168.2.10    ❌ No match
```

The first three octets must match `192.168.1`.

The final octet can contain any value from 0 to 255.

**Important:** The wildcard mask determines which address bits are checked or ignored. It does not directly specify the number of usable hosts.

### The `host` Keyword

```cisco
host 192.168.0.100
```

Equivalent to:

```cisco
192.168.0.100 0.0.0.0
```

All address bits must match.

Therefore, the destination must be exactly `192.168.0.100`.

---

# 🚫 6. Understanding Permit, Deny, and Sequence Numbers

My initial ACL:

```cisco
ip access-list extended HR-SERVER

10 permit tcp 192.168.1.0 0.0.0.255 host 192.168.0.100 eq 443

20 deny ip 192.168.1.0 0.0.0.255 any
```

### How Does the Router Evaluate These Rules?

```text
Packet Enters Interface
          |
          v
     Sequence 10
          |
     Does it match?
       /      \
     YES       NO
      |         |
      v         v
    PERMIT   Sequence 20
                |
           Does it match?
             /     \
           YES      NO
            |        |
            v        v
           DENY    IMPLICIT
                    DENY
```

**ACLs follow the first-match principle.**

Once a packet matches a rule, the router does not evaluate subsequent rules for that packet.

### Example — HTTP Request

```text
Source:       192.168.1.10
Destination:  192.168.0.100
Protocol:     TCP
Port:         80
```

**Sequence 10:** Does not match because port 80 is not port 443.

**Sequence 20:** Matches because the source belongs to `192.168.1.0/24` and the destination can be any IP address.

**Result:** DENY.

### Implicit Deny

Every IPv4 ACL has an automatic deny at the end.

Conceptually:

```cisco
deny ip any any
```

Therefore, if no configured rule matches an IPv4 packet evaluated by the ACL, the packet is denied.

This applies to both inbound and outbound IPv4 ACL evaluation.

It does not mean every router interface automatically blocks traffic when no ACL is applied.

---

# 🔄 7. Applying the ACL — Inbound vs Outbound

Creating an ACL is not enough.

The router must know where to apply it.

## Original Configuration

```cisco
interface fa0/0

ip access-group HR-SERVER in
```

### Understanding the Command

| Component | Meaning |
|---|---|
| `interface fa0/0` | Select Router0's Fa0/0 |
| `ip access-group` | Apply an IPv4 ACL to the interface |
| `HR-SERVER` | ACL being applied |
| `in` | Evaluate packets entering the interface |

### My Four-Part ACL Mental Model

```text
        ACL DESIGN
            |
      +-----+-----+
      |           |
      v           v
  Permit/Deny   Rule Order
      |           |
      +-----+-----+
            |
            v
      ACL APPLICATION
            |
      +-----+-----+
      |           |
      v           v
   Interface    Direction
```

These are four important design decisions, not four separate mandatory commands.

## Understanding Inbound

```text
HR PC
  |
  | Request
  v
Switch0
  |
  | INBOUND
  v
Fa0/0
  |
Router0
  |
Fa0/1
  |
  v
HQ Router
  |
  v
HR Server
```

`in` means packets entering Router0 through Fa0/0 are evaluated.

## Understanding Outbound

```text
HR Server
    |
    v
HQ Router
    |
    v
Router0
    |
    | OUTBOUND
    v
  Fa0/0
    |
    v
   PC0
```

`out` means packets leaving Router0 through Fa0/0 are evaluated.

### Important Observation

Applying the original ACL outbound on Fa0/0 would cause problems for return traffic.

The HTTPS response has:

```text
Source IP:      192.168.0.100
Destination IP: 192.168.1.10
Source Port:    443
```

Our original rules match source addresses from `192.168.1.0/24`.

The return packet has a different source address.

Therefore, neither explicit rule matches, and the implicit deny blocks the response.

**Key understanding:** Inbound and outbound directions are relative to the selected router interface, not the client or server.

---

# ➕ 8. Adding a New ACL Rule

During the lab, another permit statement was introduced for the IT server.

```cisco
11 permit tcp 192.168.1.0 0.0.0.255 host 192.168.0.120 eq 443
```

The ACL becomes:

```cisco
10 permit tcp 192.168.1.0 0.0.0.255 host 192.168.0.100 eq 443

11 permit tcp 192.168.1.0 0.0.0.255 host 192.168.0.120 eq 443

20 deny ip 192.168.1.0 0.0.0.255 any
```

### Why Sequence 11?

Sequence 11 is evaluated before sequence 20.

If the new permit rule were added as sequence 30:

```text
10 → Permit HR Server HTTPS

20 → Deny Remaining HR Network Traffic

30 → Permit IT Server HTTPS
```

Sequence 20 would deny matching HR traffic before sequence 30 could be reached.

Therefore, the IT server permit statement would be ineffective for that traffic.

**Important:** Sequence 11 is not special. Any unused number between 10 and 20 could establish the required ordering.

---

# 🔐 9. Designing a More Specific Security Policy

Consider a modified requirement:

- Allow HTTPS to the HR server.
- Deny other IPv4 traffic to the HR server.
- Allow HR devices to access other destinations.

### Appropriate ACL

```cisco
ip access-list extended HR-SERVER

10 permit tcp 192.168.1.0 0.0.0.255 host 192.168.0.100 eq 443

11 deny ip 192.168.1.0 0.0.0.255 host 192.168.0.100

20 permit ip 192.168.1.0 0.0.0.255 any
```

This is a separate policy example, not an additional set of rules to append to the original lab configuration.

### Why Does This Work?

**Sequence 10**

Permits HTTPS traffic to the HR server.

**Sequence 11**

Denies other IPv4 traffic from the HR network to the HR server.

**Sequence 20**

Permits remaining IPv4 traffic from the HR network to other destinations.

### Expected Results

| Traffic | Rule | Result |
|---|---|---|
| HR PC → HR Server HTTPS | 10 | ✅ Permit |
| HR PC → HR Server HTTP | 11 | ❌ Deny |
| HR PC → HR Server SSH | 11 | ❌ Deny |
| HR PC → HR Server ICMP Ping | 11 | ❌ Deny |
| HR PC → IT Server HTTPS | 20 | ✅ Permit |
| HR PC → IT Server HTTP | 20 | ✅ Permit |

These are ACL decisions, assuming the packets enter Fa0/0 and no other filtering interferes.

### Important Distinction — `tcp` vs `ip`

```cisco
permit tcp ...
```

Matches TCP traffic.

```cisco
permit ip ...
```

Matches IPv4 traffic regardless of whether the IP protocol is TCP, UDP, ICMP, or another IPv4 protocol.

### Security Lesson

A broad permit rule can unintentionally override an intended restriction if the required deny rule is missing or incorrectly ordered.

**The order and specificity of ACL rules directly affect network security.**

---

# 🛠️ 10. Modifying and Removing ACL Configurations

Understanding removal is just as important as configuration.

## Remove One Rule

Suppose sequence 11 is no longer required.

```cisco
en
conf t

ip access-list extended HR-SERVER

no 11

end
```

**Effect:** Removes only sequence 11.

Other ACL rules remain configured.

## Remove ACL from an Interface

```cisco
en
conf t

interface fa0/0

no ip access-group HR-SERVER in

end
```

**Effect:** Stops applying the ACL inbound on Fa0/0.

The ACL and its rules remain stored in the configuration.

## Reapply the ACL

```cisco
conf t

interface fa0/0

ip access-group HR-SERVER in

end
```

## Change Direction

To move the ACL from outbound to inbound:

```cisco
conf t

interface fa0/0

no ip access-group HR-SERVER out

ip access-group HR-SERVER in

end
```

**Important:** Adding the inbound command does not necessarily remove the outbound ACL assignment.

An interface can have separate inbound and outbound IPv4 ACLs.

## Delete the Entire ACL

First, detach the ACL from the interface.

```cisco
conf t

interface fa0/0

no ip access-group HR-SERVER in

exit

no ip access-list extended HR-SERVER

end
```

This removes the named ACL definition.

The interface IP address and routing configuration remain unchanged.

---

# 🔍 11. Verification Commands

| Command | Purpose |
|---|---|
| `show ip access-lists` | Display IPv4 ACLs and rule counters |
| `show ip access-lists HR-SERVER` | Display the specified ACL |
| `show ip interface fa0/0` | Check inbound/outbound ACL assignments |
| `show running-config` | Review configured rules and interfaces |
| `show ip interface brief` | Check interface IP addresses and status |
| `show ip route` | Verify routing information |
| `ping <destination>` | Test IP reachability, subject to filtering |

### Understanding Match Counters

Example:

```text
Extended IP access list HR-SERVER

10 permit tcp ... eq 443 (11 matches)

20 deny ip ... (32 matches)
```

The numbers represent packets that matched the corresponding ACL entries.

### Important Distinction

```text
ACL Permit Match
       ≠
Successful End-to-End Connection
```

A permit match does not confirm that:

- The destination server is reachable.
- The destination service is running.
- Return traffic is permitted.
- The application connection succeeded.

It confirms that traffic matched the permit rule.

---

# ✅ 12. What Works / What Doesn't

| Scenario | Result | Reason |
|---|---|---|
| ACL created but not applied | ❌ No filtering by that ACL | The ACL is not attached to the traffic path |
| ACL applied inbound on Fa0/0 | ✅ | Evaluates matching IPv4 packets entering Fa0/0 |
| ACL applied outbound on Fa0/0 | ✅ | Evaluates matching IPv4 packets leaving Fa0/0 |
| HTTPS matches `eq 443` | ✅ | Destination TCP port matches |
| HTTP matches an HTTPS-only rule | ❌ | Destination port is different |
| ICMP matches `permit tcp` | ❌ | Protocol does not match |
| ICMP matches `deny ip` | ✅ | ICMP is carried inside IPv4 |
| No configured ACL rule matches | ❌ Deny | Implicit deny |
| Permit statement after matching deny | ❌ Ineffective | First matching rule stops evaluation |
| New sequence inserted before deny | ✅ | New rule is evaluated earlier |
| `no 11` removes entire ACL | ❌ | Removes only sequence 11 |
| Detaching ACL deletes its rules | ❌ | ACL definition remains |
| ACL counter proves successful connection | ❌ | Counter only records matches |
| Same-subnet PCs require Router0 to communicate | ❌ Normally | Layer 2 switching handles local traffic |

---

# 🧩 13. Important Misconceptions Corrected

## Misconception 1 — ACL Name Controls the Destination

**Incorrect:** Naming an ACL `HR-SERVER` automatically restricts the HR server.

**Correct:** The name identifies the ACL. Its permit and deny statements define the traffic conditions.

## Misconception 2 — Unmatched Traffic Is Automatically Allowed

**Incorrect:** If no configured rule matches, the router permits the packet.

**Correct:** An applied IPv4 ACL has an implicit deny at the end.

## Misconception 3 — Outbound Rules Automatically Allow HTTPS Responses

**Incorrect:** An outbound ACL permits a server's response because the request was permitted elsewhere.

**Correct:** Traditional extended ACL rules are stateless. Return packets must satisfy the applicable rules independently.

## Misconception 4 — A Broad Permit Rule Is Always Safe

**Incorrect:** Adding `permit ip ... any` always solves unnecessary blocking.

**Correct:** It can also permit services that were intended to remain restricted.

## Misconception 5 — All Network Traffic Passes Through the Router

**Incorrect:** Router0's ACL inspects traffic between all devices in the HR LAN.

**Correct:** Traffic between devices in the same subnet and VLAN normally stays within the Layer 2 switching path.

### Connection to ARP and Ethernet Switching

This discussion reinforced three important mechanisms:

| Mechanism | Purpose |
|---|---|
| ARP | Discover the MAC address associated with an IPv4 address |
| MAC Learning | Learn which switch port leads to a MAC address |
| Unknown Unicast Flooding | Forward frames within the VLAN when the destination MAC is unknown |

A switch's MAC address table does not replace a PC's ARP cache.

ARP broadcasts may reach Router0, but ordinary IPv4 interface ACLs do not filter ARP frames.

**Key understanding:** An ACL can only evaluate traffic that reaches the relevant filtering point.

---

# 🔐 14. Cybersecurity Relevance

Extended ACLs are useful for controlling access between networks and services.

| Security Application | Purpose |
|---|---|
| Server Access Control | Restrict access to particular servers |
| Network Segmentation | Enforce permitted communication between subnets |
| Service Restrictions | Allow or deny traffic using protocol and port criteria |
| Least Privilege | Permit only the traffic required by a security policy |
| Incident Investigation | Investigate blocked traffic and ACL match counters |
| Router Security | Reduce unnecessary network reachability |

### Important Limitation

Traditional IPv4 extended ACLs are primarily **stateless packet filters**.

They do not automatically track complete application sessions like a stateful firewall.

This distinction will be explored in a later session.

---

# 📌 15. Lab Evidence and Scope

**Platform:** Cisco Packet Tracer

During the learning session, I practiced ACL configurations and verified their behavior in Packet Tracer while exploring different traffic scenarios.

The original classroom exercise included HTTP/HTTPS testing and ACL match-counter observations.

I also practiced changes to ACL rules, sequence numbers, and interface assignments during revision.

**Documentation scope:** This README records the configuration logic and understanding developed during the session. Packet Tracer files, screenshots, and detailed test logs are not included in this entry.

Results in the comparison tables describe the expected behavior of the stated configurations unless specifically identified as observed.

---

# 🧠 16. Key Takeaways

### My Extended ACL Mental Model

```text
          PACKET ARRIVES
                |
                v
     Does it traverse the
     ACL filtering point?
                |
                v
       Evaluate Rule 10
                |
          Match Found?
           /       \
         YES        NO
          |          |
          v          v
      PERMIT /    Next Rule
       DENY           |
                      v
                Match Found?
                 /      \
               YES       NO
                |         |
                v         v
             PERMIT /   Continue
              DENY        |
                          v
                    IMPLICIT DENY
```

### What I Now Understand

**1. ACL creation and application are different operations.**

Creating rules does not automatically filter traffic.

**2. The first matching rule decides the packet's fate.**

Rule order matters.

**3. Source and destination matching are independent conditions.**

Both must satisfy the rule, along with any protocol and port conditions.

**4. Inbound and outbound are relative to the router interface.**

The same ACL can behave differently depending on where it is applied.

**5. Permit does not guarantee communication success.**

Routing, return paths, and server availability still matter.

**6. ACL modifications require careful planning.**

Adding a broad permit or placing a rule after a deny can unintentionally change the security policy.

**7. ACL troubleshooting begins with packet flow.**

Before changing rules, determine whether the packet actually reaches the ACL and which rule it matches.

### Final Understanding

> Extended ACLs allow me to control IPv4 traffic using source addresses, destination addresses, protocols, and ports. Effective ACL configuration requires understanding packet direction, rule order, interface placement, and the consequences of every permit or deny statement.

---

# 🚀 17. Topics Reserved for Future Learning

The following topics were identified during Day 22 but were **not covered in depth**.

They will be studied separately rather than being treated as completed concepts.

| Pending Topic | What I Need to Understand |
|---|---|
| **Standard ACLs** | Source-only filtering, configuration, limitations, and practical examples |
| **ACL Placement Strategy** | Why extended ACLs are often placed near the source, exceptions, and choosing the correct interface |
| **Numbered ACLs** | Differences between numbered and named ACLs, numbering ranges, and configuration |
| **ACL Logging** | How logging works, what information is recorded, and operational limitations |
| **Advanced ACL Troubleshooting** | Diagnosing incorrect rule order, interface direction, unexpected denies, and asymmetric traffic |
| **Stateful vs Stateless Filtering** | How traditional ACLs differ from firewalls that track connection state |

### Future Learning Objective

Move beyond configuring individual ACL rules toward designing, verifying, and troubleshooting complete access-control policies.

**Current completed scope:** Extended ACL fundamentals, configuration, rule modification, traffic prediction, and basic verification.

**Not yet completed:** Standard ACLs, advanced placement design, numbered ACLs, logging, advanced troubleshooting, and stateful firewall concepts.

---

## ✅ Day 22 — Completed

**Topic:** Access Control Management  
**Subtopic:** Access Control Lists  
**Focus:** Extended ACLs  
**Platform:** Cisco Packet Tracer  
**Learning Approach:** Practical configuration, reasoning, verification, and troubleshooting.

**Final takeaway:** Understanding an ACL means knowing not just which command to enter, but why a packet matches a rule, where filtering happens, what changes when the configuration is modified, and how to investigate an unexpected result.
