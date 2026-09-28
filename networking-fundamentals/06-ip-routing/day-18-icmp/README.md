# 🌐 Day 18 — ICMP, Ping, Traceroute, and Network Troubleshooting

<!-- portfolio-quick-review:start -->
## ⚡ Quick review

- **Problem:** A failed connection does not immediately tell me whether the cause is a routing problem, an expired packet lifetime, filtering, or an unresponsive destination.
- **Approach:** Understand ICMP messages, control ping tests, examine traceroute responses, and inspect packets in Wireshark.
- **Reviewed observations:** Echo requests and replies, an outgoing request with TTL 128, a deliberately limited request with TTL 1, Time Exceeded responses, and successful ping examples with different data sizes.
- **Key understanding:** An ICMP message provides specific feedback. A timeout provides less information because it only tells me that the expected response did not arrive in time.
- **Scope:** IPv4 troubleshooting with Windows commands. Commands below form a repeatable practice reference; expected behaviour is distinguished from observed results.

[Read the full learning notes ↓](#full-learning-notes)

---

<a id="full-learning-notes"></a>
<!-- portfolio-quick-review:end -->

## 📌 What changed from Day 17?

On [Day 17](../day-17-default-static-routing/README.md), I studied how routers use default and specific static routes to forward traffic.

Day 18 focuses on understanding the feedback I receive when testing those paths.

Previously, I used `ping` to check connectivity. Now I am learning:

- What ping sends and receives.
- Why a packet can expire before reaching its destination.
- How traceroute discovers responding hops.
- What different error messages actually establish.
- How command options change a test.
- How Wireshark and netstat support troubleshooting.

> **My mental model:** Routing decides where a packet goes next. ICMP can report what happened to that packet. Diagnostic tools help me collect and interpret that feedback.

---

## 🎯 Learning objectives

- Explain the purpose of ICMP.
- Recognize common ICMPv4 message types.
- Distinguish message Type, Code, and IP TTL.
- Explain ping as a request-and-reply test.
- Understand how TTL prevents packets circulating indefinitely.
- Explain traceroute using separate probes with increasing starting TTLs.
- Distinguish data size, request count, and response waiting time.
- Interpret basic ICMP fields in Wireshark.
- Use netstat for local connection information and protocol statistics.
- Avoid drawing conclusions that the evidence does not support.

---

## 🧠 What is ICMP?

**ICMP** stands for **Internet Control Message Protocol**.

A protocol is an agreed set of rules for how devices exchange and interpret messages.

IP delivers packets through interconnected networks, but delivery can fail. A router may lack a usable route, or a packet may exhaust its lifetime before reaching its destination.

ICMP provides messages that can report these problems. It also supports diagnostic exchanges such as Echo Request and Echo Reply.

### A delivery analogy

Imagine sending a parcel:

- The parcel’s address identifies the destination.
- Sorting centres decide where to send it next.
- A failure notice may explain why delivery could not continue.
- A receipt can confirm that a test parcel arrived.

In networking:

| Delivery idea | Networking concept |
|---|---|
| Addressed parcel | IP packet |
| Sorting centre | Router |
| Forwarding instructions | Routing table |
| Delivery problem notice | ICMP error |
| Request for a response | ICMP Echo Request |
| Response from the recipient | ICMP Echo Reply |

The analogy has a limit: an ICMP error is not guaranteed to arrive. Some packets disappear without a useful report.

**ICMP reports information; it does not repair a missing route or make IP delivery reliable.**

---

## 🧱 Where ICMP fits

ICMP supports the **network layer, Layer 3**, in the OSI model.

An ordinary IPv4 ping carried over Ethernet contains:

| Part | Purpose |
|---|---|
| Ethernet header | MAC addressing for the current local link |
| IPv4 header | Source IP, destination IP, TTL, and protocol identification |
| ICMP header | Type, Code, and other message information |
| Echo data | Data included in the test |

There is no TCP or UDP header in an ordinary ICMP Echo Request.

### Does ICMP use ports?

No. ICMP does not have TCP-style or UDP-style source and destination ports.

The IPv4 **Protocol** field identifies the protocol carried inside the IP packet:

| Value | Protocol |
|---:|---|
| `1` | ICMP |
| `6` | TCP |
| `17` | UDP |

These values are **protocol numbers**, not port numbers.

Echo messages include an **identifier** and **sequence number** that help match responses to requests.

> ICMP is the protocol. Ping and traceroute are tools that use network messages to perform diagnostic tests.

---

## 📨 What do 8, 0, 3, and 11 mean?

These numbers are values in the ICMPv4 **Type field**.

A field is a named piece of information inside a packet.

The Type field answers:

> “What kind of ICMP message is this?”

| Type | Name | Meaning |
|---:|---|---|
| `8` | Echo Request | A request for an echo response |
| `0` | Echo Reply | The response to an Echo Request |
| `3` | Destination Unreachable | A delivery problem with a more specific reason |
| `11` | Time Exceeded | A lifetime limit was exceeded |

These are standardized labels. They are not handshake stages, hop counts, or TTL values.

### This is different from the TCP handshake

TCP uses SYN → SYN/ACK → ACK to establish connection state.

An ICMP Echo Request and Echo Reply do not establish a TCP connection.

Sending Type 8 does not prove that the destination received it. Receiving the matching Type 0 provides the positive response.

### Type versus Code

- **Type:** broad message category.
- **Code:** more specific reason within that category.

| Type | Code | Meaning |
|---:|---:|---|
| `8` | `0` | Echo Request |
| `0` | `0` | Echo Reply |
| `3` | `0` | Network unreachable |
| `3` | `1` | Host unreachable |
| `3` | `3` | Port unreachable |
| `3` | `4` | Fragmentation needed, but Don’t Fragment is set |
| `11` | `0` | TTL expired in transit |
| `11` | `1` | Fragment reassembly timed out |

For this lesson, **TTL expiry means Type 11, Code 0**.

ICMP can report a port-related error involving another protocol, such as UDP. That does not mean ICMP itself uses ports.

These assignments apply to ICMPv4. ICMPv6 has different type numbers.

---

## ⏳ TTL: why packets cannot travel forever

**TTL** stands for **Time to Live**.

For ordinary routing troubleshooting, I treat TTL as the packet’s **forwarding budget**.

The sender chooses an initial TTL. Each forwarding router reduces it, normally by one. A router must not forward a packet whose TTL expires.

### Example: starting TTL 3

| Device | TTL behaviour |
|---|---|
| Source PC | Sends with TTL `3` |
| Router A | Reduces TTL to `2` and forwards |
| Router B | Reduces TTL to `1` and forwards |
| Router C | TTL expires; discards the packet instead of forwarding it |

Router C normally generates an ICMP Time Exceeded message back toward the source.

### Why is TTL necessary?

Incorrect routes can create a loop:

- Router A forwards a packet to Router B.
- Router B forwards it back to Router A.
- The process repeats.

TTL limits how long that packet can keep circulating.

### Important corrections

- TTL **decreases** as a packet travels.
- Ordinary Layer 2 switches do not decrease IP TTL.
- TTL is in the **IP header**, not the ICMP Type field.
- Echo Requests do not always use TTL 1.
- Common starting values include `64`, `128`, and `255`.
- The maximum IPv4 TTL is **255**, not 256, because the field is eight bits.
- An expired TTL does not prove the destination is offline.
- An expired TTL does not prove the remaining route is correct.

> A correct route can still produce Time Exceeded when I deliberately send a packet with too little TTL.

---

## ↔️ How ping works

Ping tests whether an Echo Request can produce an Echo Reply that returns to the sender.

1. My computer creates an ICMP Echo Request.
2. The request travels toward the destination.
3. If the destination receives and answers it, it generates an Echo Reply.
4. The reply travels back.
5. Ping matches the reply to its request and reports the result.

Both the forward and return paths matter.

A request reaching the destination does not guarantee that its reply can reach me.

### Reading a reply

Example from the reviewed output:

```text
Reply from 8.8.8.8: bytes=1400 time=14ms TTL=118
```

| Part | Meaning |
|---|---|
| `Reply from 8.8.8.8` | Reported source of the Echo Reply |
| `bytes=1400` | Echo data size |
| `time=14ms` | Approximately 14 milliseconds for the round trip |
| `TTL=118` | Remaining TTL of the received reply |

**RTT** means **round-trip time**: the time from sending a probe to receiving its response.

RTT is not download speed or bandwidth.

### The request and reply have separate TTLs

The destination creates a new IP packet for its reply and chooses a starting TTL for it.

Changing my outgoing request’s TTL does not require the reply to use that same TTL.

Therefore:

> `ping -i 32` changes the request’s starting TTL. The `TTL=` printed in a successful reply describes the received reply.

A received TTL alone does not establish the exact hop count unless the original starting TTL is known.

### What successful ping proves

It supports the conclusion that an ICMP echo exchange succeeded at that moment.

It does not prove that:

- A website is working.
- An application port is open.
- Every packet will succeed.
- The network has high bandwidth.

A device can also provide working applications while blocking ping.

---

## 🚦 Understanding failures

| Result | What it establishes | What it does not establish |
|---|---|---|
| Echo Reply | A matching echo response returned | Every service is working |
| Destination Unreachable | A device reported a delivery problem | The cause is always a missing route |
| Time Exceeded, Code 0 | The packet exhausted its TTL | The destination is offline |
| Request timed out | No expected response arrived before the waiting deadline | Which device caused the failure |

### Destination Unreachable

A missing route is one possible cause.

For example, a router may have no usable specific route and no usable default route for a destination. It cannot continue forwarding and may report the problem.

Other reasons exist, so I should inspect the Code instead of assuming every Type 3 message means the same thing.

### Time Exceeded

For Type 11, Code 0, the packet’s TTL expired.

Possible causes include:

- A deliberately small starting TTL.
- A longer path than the packet’s TTL allows.
- A routing loop.

### Request timed out

A timeout is the tool’s observation that it waited without receiving the expected response.

It is not a separate ICMP Type called “Request Timed Out.”

Possible explanations include a lost request, lost reply, filtering, a missing return route, or a destination that does not answer echo requests.

### Where errors appear

Windows ping can display messages such as:

```text
Reply from <router-IP>: Destination host unreachable.
```

```text
Reply from <router-IP>: TTL expired in transit.
```

The wording depends on the error and implementation.

**“Reply from” does not automatically mean success. I must read the entire message.**

---

## 🛣️ How traceroute discovers hops

A **probe** is a test packet.

Windows `tracert` sends separate ICMP Echo probes with progressively larger starting TTL values.

For a destination behind two routers:

| Starting TTL | Expected event | Expected response |
|---:|---|---|
| `1` | Expires at the first router | Time Exceeded |
| `2` | Expires at the second router | Time Exceeded |
| `3` | Reaches the destination | Echo Reply |

Each probe starts a new journey. An expired packet is not revived.

### Why TTL both increases and decreases

| Situation | Behaviour |
|---|---|
| One packet moving through routers | TTL decreases |
| Successive groups of probes created by traceroute | Starting TTL increases |

### Reading the output

Windows tracert normally shows:

- A hop number.
- Three round-trip measurements.
- A responding IP address or resolved hostname.

Each time measures a round trip from my computer to that responding hop and back.

It is not the time between two adjacent routers.

### What does `*` mean?

A response did not arrive within the waiting period.

Some routers forward traffic but do not respond to these probes, or they limit their responses.

A silent hop followed by responding later hops does not prove the silent router is broken.

### What traceroute cannot guarantee

- It does not display the full return path.
- Paths can change between probes.
- Different traffic can take different paths.
- A hop’s hostname does not reveal whether it used a static or dynamic route.

Windows uses `tracert`. Many Linux `traceroute` implementations use UDP probes by default and support an ICMP option. Command options are not interchangeable between operating systems.

---

## 🔧 Windows command reference

The commands below use Windows Command Prompt syntax.

### 1. Identify local network settings

```bat
ipconfig /all
```

Identify:

- IPv4 address.
- Subnet mask.
- Default gateway.
- DNS servers.

The default gateway is the local router used for destinations outside my subnet when the relevant route points through it.

### 2. Compare local, Internet, and hostname reachability

```bat
ping <actual-default-gateway-IP>
ping -4 8.8.8.8
ping -4 google.com
```

Replace the gateway placeholder with the actual address.

These tests check different things:

- Gateway test: local router reachability.
- Internet IP test: an external echo exchange without needing a hostname lookup.
- Hostname test: includes name resolution before the echo exchange.

If the IP test works but a hostname test reports that it cannot find the host, name resolution needs investigation.

A hostname resolving successfully and then timing out is a different observation.

### 3. Control request count

```bat
ping -4 -n 5 8.8.8.8
```

`-n 5` sends five requests.

### 4. Control data size

```bat
ping -4 -n 3 -l 100 8.8.8.8
ping -4 -n 3 -l 1400 8.8.8.8
```

`-l` is a lowercase letter L. It sets echo data size in bytes.

It does not set the number of requests.

### 5. Control response waiting time

```bat
ping -4 -n 3 -w 1000 8.8.8.8
```

`-w 1000` sets a response waiting period of 1,000 milliseconds.

This is different from TTL. Waiting longer does not give an expired packet more hops.

### 6. Run a continuous test

```bat
ping -4 -t 8.8.8.8
```

Stop with:

```text
Ctrl+C
```

This can help observe intermittent responses. It is not a bandwidth test.

### 7. Set the outgoing TTL

```bat
ping -4 -n 2 -i 1 8.8.8.8
ping -4 -n 2 -i 2 8.8.8.8
ping -4 -n 2 -i 3 8.8.8.8
```

`-i` sets the request’s starting TTL.

A remote destination behind a router cannot receive a request that expires at that router. An error response may return, but silence is also possible.

### 8. Trace the path

```bat
tracert -4 -d 8.8.8.8
```

- `-4`: use IPv4.
- `-d`: skip resolving hop IP addresses into names.

Limit the investigation:

```bat
tracert -4 -d -h 5 -w 1000 8.8.8.8
```

- `-h 5`: explore only up to TTL 5.
- `-w 1000`: wait up to 1,000 milliseconds per response.

The hop limit restricts the test. It does not shorten the actual route.

### 9. Combine options correctly

```bat
ping -4 -n 3 -i 32 -l 1400 8.8.8.8
```

I read this as:

> “Send three IPv4 Echo Requests to 8.8.8.8, each with starting TTL 32 and 1,400 bytes of echo data.”

Each number needs the option that defines its purpose.

---

## 📦 Packet size, MTU, and fragmentation

**MTU** means **Maximum Transmission Unit**.

For a link, it is the largest IP packet that can be carried without IP fragmentation.

**Fragmentation** splits an IPv4 packet into smaller pieces. The destination must reassemble them.

The **path MTU** is the smallest link MTU along the path.

### Echo data is not the whole IP packet

With a basic IPv4 header:

```text
IPv4 packet size = 20-byte IPv4 header + 8-byte ICMP Echo header + echo data
```

| Ping data size | Basic IPv4 packet size |
|---:|---:|
| `100` | `128` bytes |
| `1400` | `1428` bytes |
| `1472` | `1500` bytes |
| `1500` | `1528` bytes |

A 1,500-byte MTU is common, but not universal.

### Test without fragmentation

```bat
ping -4 -n 2 -f -l 1400 8.8.8.8
ping -4 -n 2 -f -l 1472 8.8.8.8
ping -4 -n 2 -f -l 1500 8.8.8.8
```

`-f` sets the IPv4 **Don’t Fragment** flag.

If a router needs to fragment the packet to forward it but fragmentation is prohibited, it can report **Type 3, Code 4**.

A locally detected size problem can also be reported by the sending system.

> This experiment asks whether a packet fits through the path without being split. It does not test how many requests the destination can handle.

A timeout alone does not establish an MTU limit. A large ping succeeding without `-f` does not prove that fragmentation was unnecessary.

---

## 🔎 Netstat: inspecting the local computer

Netstat provides connection information, routing information, and protocol counters.

It does not perform the same test as ping or traceroute.

| Tool | Main purpose |
|---|---|
| `ping` | Test echo responses and round-trip time |
| `tracert` | Discover responding hops using limited-TTL probes |
| `netstat` | Inspect local connections, endpoints, routes, and statistics |
| Wireshark | Inspect captured packets |

### Connections and process IDs

```bat
netstat -ano
```

| Option | Meaning |
|---|---|
| `-a` | Show active connections and listening endpoints |
| `-n` | Display numeric addresses and ports |
| `-o` | Include process IDs |

A **PID**, or process ID, identifies a running process. It helps connect a network entry with a program.

An ICMP ping does not create an `ESTABLISHED` TCP connection.

### Local routing table

```bat
netstat -r
```

This displays my computer’s routing table, not the routing tables of remote routers.

### ICMP counters

```bat
netstat -s -p icmp
```

- `-s`: show protocol statistics.
- `-p icmp`: select ICMP.

Comparing counters before and after a test can help observe activity, but these are system-wide counters rather than a packet-by-packet record of one command.

---

## 🔬 Inspecting ICMP in Wireshark

Select the active network adapter, start capturing, and use this display filter:

```text
icmp
```

Useful filters:

| Purpose | Display filter |
|---|---|
| ICMPv4 | `icmp` |
| Echo Request fields | `icmp.type == 8` |
| Echo Reply fields | `icmp.type == 0` |
| Destination Unreachable | `icmp.type == 3` |
| Time Exceeded | `icmp.type == 11` |
| TTL expiry | `icmp.type == 11 && icmp.code == 0` |

### What I inspect

1. Source and destination IP addresses.
2. The outer ICMP Type and Code.
3. The relevant IPv4 TTL.
4. Echo identifier and sequence number.
5. Any original packet quoted inside an error.

### Why an error can contain an Echo Request

An ICMP error includes information from the packet that caused the error.

For a TTL-expired Echo Request, the received packet can contain:

| Part | Meaning |
|---|---|
| Outer IPv4 header | Error report travelling from the router toward my PC |
| Outer ICMP header | Time Exceeded |
| Quoted original IPv4 header | My original packet toward the destination |
| Quoted original ICMP header | Echo Request |

Therefore, seeing Type 8 inside a Time Exceeded packet is not a contradiction.

I must distinguish the **outer error** from the **quoted original request**. A display filter may also match a quoted inner field.

### IP addresses versus MAC addresses

The source IP of the outer error identifies the reporting device’s IP address.

The Ethernet source MAC seen by my PC belongs to the sender on the current local link. It does not identify a distant reporting router across multiple routed hops.

This connects to my ARP learning: MAC delivery is local to each link.

---

## ✅ Reviewed observations

The reviewed examples support the following observations:

| Observation | Interpretation |
|---|---|
| Requests from `192.168.1.26` to `8.8.8.8` and replies in the reverse direction | Echo exchanges were visible |
| An outgoing request had TTL `128` | Echo Requests do not always start with TTL 1 |
| A later outgoing request had TTL `1` | The probe was deliberately restricted |
| Time Exceeded responses came from `192.168.1.1` | The first router reported expiry |
| A Time Exceeded packet included the original Echo Request | ICMP errors quote the triggering packet |
| Ping examples with 100, 1,000, and 1,400 data bytes received replies | Those displayed size tests succeeded |
| The displayed 1,500-byte test was interrupted before a result | It does not establish a failure or exact MTU |

These observations do not establish that every command in this reference was completed.

### Connection to the previous routing lab

The reviewed trace toward an HQ server showed:

```text
1    192.168.2.254
2    100.100.100.2
3    192.168.0.101
```

This represents:

- Branch 2 router.
- HQ router.
- Destination server.

It contains **two intermediate routers followed by the destination**, not three intermediate routers.

---

## 🧪 Repeatable practice checklist

These are verification tasks, not additional claimed results.

- [ ] Identify the local IPv4 address, mask, gateway, and DNS servers.
- [ ] Compare gateway, Internet-IP, and hostname ping tests.
- [ ] Explain the difference between `-n`, `-l`, `-i`, and `-w`.
- [ ] Observe a normal Echo Request and Echo Reply.
- [ ] Send a TTL-1 probe and inspect the result.
- [ ] Compare limited-TTL ping responses with traceroute.
- [ ] Explain the three timing columns in tracert.
- [ ] Compare packet sizes with Don’t Fragment enabled.
- [ ] Inspect ICMP counters using netstat.
- [ ] Distinguish an outer ICMP error from its quoted original packet.

### Optional missing-route experiment

In a saved copy of the Packet Tracer routing lab:

1. Confirm a working ping.
2. Remove a necessary forward route from one router.
3. Check that a default route does not still cover the destination.
4. Repeat the ping.
5. Inspect the forwarding failure and any ICMP report in Simulation Mode.
6. Restore the route and verify connectivity.

This isolates a known routing problem instead of assuming why an arbitrary Internet destination failed to respond.

---

## ⚠️ Misconceptions I corrected

| Misconception | Correct understanding |
|---|---|
| ICMP means Internet Monitoring Control Protocol | Internet Control Message Protocol |
| 8, 0, 3, and 11 are handshake stages | They are ICMPv4 Type values |
| TTL increases at each router | It decreases as the packet travels |
| Maximum TTL is 256 | Maximum IPv4 TTL is 255 |
| Every Echo Request uses TTL 1 | The sender chooses the initial TTL |
| Destination Unreachable always means no route | Type 3 has several possible reasons |
| Time Exceeded proves the route is correct | It only identifies the reported lifetime problem |
| Timeout and Time Exceeded are the same | One is a waiting outcome; the other is an ICMP message |
| `-l 1400` sends 1,400 requests | It sets 1,400 data bytes per request |
| The printed reply TTL is my request’s TTL | It belongs to the received reply |
| Successful ping means the application is working | It establishes an echo exchange |
| A traceroute `*` proves a router is broken | It means no response arrived before the deadline |
| Netstat captures packets | It displays local networking information and counters |

---

## 🔍 My troubleshooting order

1. **Check local configuration:** address, mask, gateway, and DNS.
2. **Test the gateway:** determine whether an echo exchange with the local router works.
3. **Test an external IP:** examine reachability beyond the local network.
4. **Test a hostname:** distinguish name-resolution failures from later response failures.
5. **Read the actual message:** reply, unreachable, TTL expiry, or timeout.
6. **Inspect responding hops:** use tracert without assuming every silent hop is broken.
7. **Check the return path:** a reply also needs routing.
8. **Inspect local information:** use netstat where relevant.
9. **Inspect packets:** use Wireshark to examine Type, Code, and addresses.
10. **Change one variable:** repeat with a different count, TTL, size, or waiting period.

A failed test gives me an observation to investigate. It does not automatically identify the cause.

---

## 🔐 Why this matters for cybersecurity

These skills help separate routing problems, filtering, host behaviour, and application failures.

For example:

- An ICMP response can reveal a reachable device or responding router.
- A timeout can result from filtering, but does not prove filtering.
- Echo reachability does not establish that a service is available or secure.
- ICMP error messages can provide useful context during packet analysis.
- Packet-size problems can affect applications even when small pings work.

Blocking all ICMP can interfere with useful diagnostics and network functions such as path MTU discovery.

My goal is to interpret the evidence accurately instead of treating every failed connection as an attack or every successful ping as proof that everything works.

---

## 🧠 My Day 18 takeaway

Day 17 focused on forwarding decisions. Day 18 connects those decisions to the messages I see during troubleshooting.

My core understanding is:

> Ping tests an echo exchange. Traceroute uses deliberately limited packet lifetimes to discover responding hops. ICMP reports specific information, while a timeout leaves several possible explanations.

The most useful habit is to ask:

**“What does this result prove, what does it only suggest, and what should I test next?”**

### Quick self-check

1. A request starts with TTL 2 and travels through Router A and Router B before the destination. Where does it expire?
2. Why can ping fail even when the request reaches the destination?
3. How does `-l 1400` differ from `-n 1400`?
4. Why might an ICMP error contain an Echo Request header?
5. Does a silent traceroute hop prove that forwarding stopped there?

<details>
<summary>Check my reasoning</summary>

1. It expires at Router B. Router A reduces TTL to 1; Router B cannot forward it farther.
2. The reply may have no usable return path, be filtered, or otherwise fail to arrive.
3. `-l 1400` sets data bytes per request; `-n 1400` sets the number of requests.
4. The error quotes information from the original packet that caused it.
5. No. A router can forward traffic without returning a diagnostic response.

</details>

---

## 📚 References

- [Microsoft: ping command](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/ping)
- [Microsoft: tracert command](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tracert)
- [Microsoft: netstat command](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netstat)
- [IANA: ICMP Type and Code assignments](https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml)
- [RFC 792: Internet Control Message Protocol](https://www.rfc-editor.org/rfc/rfc792)
- [RFC 1191: Path MTU Discovery](https://www.rfc-editor.org/rfc/rfc1191)
- [Wireshark: ICMP display-filter fields](https://www.wireshark.org/docs/dfref/i/icmp.html)

RFC 792 is the original ICMP specification. Some historical messages in it are obsolete; this README focuses on the diagnostic messages relevant to this lesson.
