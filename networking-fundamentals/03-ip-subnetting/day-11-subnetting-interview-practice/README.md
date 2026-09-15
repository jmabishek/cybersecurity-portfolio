# 🌐 Advanced IP Subnetting — VLSM, Network Boundaries & Interview Practice

> **Goal:** Move beyond basic subnet creation and learn how to analyze any random IPv4 address, identify its subnet, calculate network/broadcast addresses, and solve practical VLSM problems across both the 3rd and 4th octets.

---

## 🧠 My Mental Model

Subnetting is not just about dividing a `/24`.

The real idea is:

```text
IP Address + Subnet Mask
          │
          ▼
   Find the subnet boundary
          │
          ▼
┌─────────────────────────┐
│ Network ID              │
│ Usable Host Range       │
│ Broadcast ID            │
│ Next Subnet             │
└─────────────────────────┘
```

The subnet mask tells me **which part of the IP identifies the network** and which part is available for hosts.

---

# 🔹 1. VLSM Refresher

## What is VLSM?

**VLSM = Variable Length Subnet Masking**

It allows different subnet sizes inside the same parent network.

Instead of giving every department the same number of addresses:

```text
Department A ─── same size
Department B ─── same size
Department C ─── same size
```

VLSM allows:

```text
Department A ─────────────── Large subnet
Department B ─────── Medium subnet
Department C ─── Small subnet
Department D ─ Very small subnet
```

This reduces wasted IPv4 addresses.

---

# 🔹 2. Important VLSM Rule

Allocate the **largest requirement first**.

Example:

```text
A → 900 hosts
B → 400 hosts
C → 120 hosts
D → 50 hosts
E → 20 hosts
```

Allocation order:

```text
900
 ↓
400
 ↓
120
 ↓
50
 ↓
20
```

---

# 🔹 3. Host Requirement → Prefix

The basic formula:

```text
2^host_bits - 2 ≥ required hosts
```

The `-2` represents:

```text
1 address → Network ID
1 address → Broadcast ID
```

Example:

```text
Need 120 hosts

2^6 - 2 = 62      ❌
2^7 - 2 = 126     ✅
```

So:

```text
Host bits = 7

32 - 7 = /25
```

Therefore:

```text
120 hosts → /25
```

---

# 🔢 Useful Prefix Reference

| Prefix | Subnet Mask | Total Addresses | Usable Hosts |
|---|---|---:|---:|
| `/20` | `255.255.240.0` | 4096 | 4094 |
| `/21` | `255.255.248.0` | 2048 | 2046 |
| `/22` | `255.255.252.0` | 1024 | 1022 |
| `/23` | `255.255.254.0` | 512 | 510 |
| `/24` | `255.255.255.0` | 256 | 254 |
| `/25` | `255.255.255.128` | 128 | 126 |
| `/26` | `255.255.255.192` | 64 | 62 |
| `/27` | `255.255.255.224` | 32 | 30 |
| `/28` | `255.255.255.240` | 16 | 14 |

---

# 🔹 4. Subnetting Is NOT Limited to the 4th Octet

Earlier I mainly worked with networks such as:

```text
192.168.10.0/24
```

Example:

```text
/25 → .0 - .127
/26 → .128 - .191
/27 → .192 - .223
/28 → .224 - .239
```

These subnet boundaries are happening in the **4th octet**.

But larger networks can require the subnet boundary to move into the **3rd octet**.

Example:

```text
172.16.0.0/22
```

Subnet mask:

```text
255.255.252.0
```

Interesting octet:

```text
255.255.252.0
        ↑
    3rd octet
```

Block size:

```text
256 - 252 = 4
```

Valid third-octet boundaries:

```text
0
4
8
12
16
20
...
```

So:

```text
172.16.0.0/22
```

contains:

```text
172.16.0.x
172.16.1.x
172.16.2.x
172.16.3.x
```

Broadcast:

```text
172.16.3.255
```

Next subnet:

```text
172.16.4.0
```

---

# 🎯 5. Block Size vs Reserved Addresses

These are NOT the same thing.

Example:

```text
/22
```

Total addresses:

```text
2^10 = 1024
```

But the **third-octet increment** is:

```text
256 - 252 = 4
```

So:

```text
Reserved addresses = 1024
Third-octet increment = 4
```

Another example:

```text
/26
```

Total addresses:

```text
64
```

Fourth-octet increment:

```text
256 - 192 = 64
```

Sometimes the values happen to match, but conceptually they mean different things.

---

# 🔥 6. Mixed VLSM Across 3rd and 4th Octets

Given:

```text
172.20.0.0/20
```

Requirements:

```text
A → 900 hosts
B → 400 hosts
C → 120 hosts
D → 50 hosts
E → 20 hosts
```

---

## 🅰 Department A — 900 Hosts

Minimum needed:

```text
900 + 2 = 902
```

Next power of 2:

```text
1024
```

Therefore:

```text
Prefix = /22
Mask   = 255.255.252.0
```

Block:

```text
172.20.0.0/22
```

Range:

```text
Network ID  : 172.20.0.0

172.20.0.x
172.20.1.x
172.20.2.x
172.20.3.x

Broadcast   : 172.20.3.255
Next free   : 172.20.4.0
```

---

## 🅱 Department B — 400 Hosts

Minimum:

```text
400 + 2 = 402
```

Next power of 2:

```text
512
```

Therefore:

```text
Prefix = /23
Mask   = 255.255.254.0
```

Allocation:

```text
Network ID  : 172.20.4.0
Broadcast   : 172.20.5.255
Next free   : 172.20.6.0
```

---

## 🅲 Department C — 120 Hosts

```text
120 + 2 = 122
```

Next power:

```text
128
```

Therefore:

```text
Prefix = /25
Mask   = 255.255.255.128
```

Allocation:

```text
Network ID  : 172.20.6.0
Broadcast   : 172.20.6.127
Next free   : 172.20.6.128
```

---

## 🅳 Department D — 50 Hosts

```text
50 + 2 = 52
```

Next power:

```text
64
```

Therefore:

```text
Prefix = /26
Mask   = 255.255.255.192
```

Allocation:

```text
Network ID  : 172.20.6.128
Broadcast   : 172.20.6.191
Next free   : 172.20.6.192
```

---

## 🅴 Department E — 20 Hosts

```text
20 + 2 = 22
```

Next power:

```text
32
```

Therefore:

```text
Prefix = /27
Mask   = 255.255.255.224
```

Allocation:

```text
Network ID  : 172.20.6.192
Broadcast   : 172.20.6.223
Next free   : 172.20.6.224
```

---

# 🗺 Final VLSM Layout

```text
172.20.0.0/20
│
├──────── A : 900 hosts
│           172.20.0.0/22
│           172.20.0.0 → 172.20.3.255
│
├──────── B : 400 hosts
│           172.20.4.0/23
│           172.20.4.0 → 172.20.5.255
│
├──────── C : 120 hosts
│           172.20.6.0/25
│           172.20.6.0 → 172.20.6.127
│
├──────── D : 50 hosts
│           172.20.6.128/26
│           172.20.6.128 → 172.20.6.191
│
├──────── E : 20 hosts
│           172.20.6.192/27
│           172.20.6.192 → 172.20.6.223
│
└──────── Next free
            172.20.6.224
```

This helped me understand that VLSM does not remain fixed in one octet.

The subnet boundary depends on the prefix being used.

---

# 🧠 7. Random IP → Find Its Network

This is an important interview-style subnetting skill.

Instead of being given:

```text
192.168.10.0/27
```

I might be given a random host:

```text
192.168.50.181/27
```

and asked:

```text
What network does this host belong to?
```

---

# ⚡ My Fast Subnet Method

```text
Given IP + Prefix
       │
       ▼
Convert prefix → subnet mask
       │
       ▼
Find interesting octet
       │
       ▼
Block size = 256 - mask value
       │
       ▼
Find boundaries
       │
       ▼
Locate the IP inside a block
       │
       ├── Block start = Network ID
       │
       └── Next block - 1 = Broadcast ID
```

---

# 🧪 Example 1 — Random `/27`

Given:

```text
192.168.50.181/27
```

Mask:

```text
255.255.255.224
```

Block size:

```text
256 - 224 = 32
```

Boundaries:

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

The IP has:

```text
4th octet = 181
```

181 lies inside:

```text
160 ───────────────── 191
          ↑
         181
```

Therefore:

```text
Network ID     : 192.168.50.160
Broadcast ID   : 192.168.50.191

First usable   : 192.168.50.161
Last usable    : 192.168.50.190

Total addresses: 32
Usable hosts   : 30
```

---

# 🧪 Example 2 — Random `/20`

Given:

```text
172.16.77.143/20
```

Mask:

```text
255.255.240.0
```

Block size:

```text
256 - 240 = 16
```

Third-octet boundaries:

```text
0
16
32
48
64
80
96
...
```

Third octet of the IP:

```text
77
```

77 falls between:

```text
64 ─────────────── 79
        ↑
       77
```

Therefore:

```text
Network ID     : 172.16.64.0
Broadcast ID   : 172.16.79.255

First usable   : 172.16.64.1
Last usable    : 172.16.79.254

Total addresses: 4096
Usable hosts   : 4094
```

---

# 🧪 Example 3 — Random `/21`

Given:

```text
10.25.142.201/21
```

Mask:

```text
255.255.248.0
```

Block size:

```text
256 - 248 = 8
```

Third-octet boundaries:

```text
0
8
16
24
...
128
136
144
152
...
```

142 belongs to:

```text
136 ───────────── 143
          ↑
         142
```

Therefore:

```text
Network ID     : 10.25.136.0
Broadcast ID   : 10.25.143.255

First usable   : 10.25.136.1
Last usable    : 10.25.143.254

Total addresses: 2048
Usable hosts   : 2046
```

---

# 🧪 Example 4 — Mask Given Instead of CIDR

Given:

```text
IP   : 10.10.199.70
Mask : 255.255.252.0
```

Convert mask:

```text
255.255.252.0 = /22
```

Block size:

```text
256 - 252 = 4
```

Relevant boundaries:

```text
...
188
192
196
200
204
...
```

199 falls inside:

```text
196 ─────── 199
             ↑
            199
```

Therefore:

```text
CIDR           : /22
Network ID     : 10.10.196.0
Broadcast ID   : 10.10.199.255

First usable   : 10.10.196.1
Last usable    : 10.10.199.254

Total addresses: 1024
Usable hosts   : 1022
```

---

# 🧪 Example 5 — `/21` From a Mask

Given:

```text
IP   : 172.18.173.77
Mask : 255.255.248.0
```

CIDR:

```text
/21
```

Block size:

```text
256 - 248 = 8
```

173 falls into:

```text
168 ───────── 175
       ↑
      173
```

Therefore:

```text
Network ID     : 172.18.168.0
Broadcast ID   : 172.18.175.255

First usable   : 172.18.168.1
Last usable    : 172.18.175.254

Total addresses: 2048
Usable hosts   : 2046
```

---

# 🧪 Example 6 — Random `/26`

Given:

```text
IP   : 192.168.77.130
Mask : 255.255.255.192
```

CIDR:

```text
/26
```

Block size:

```text
256 - 192 = 64
```

Boundaries:

```text
0
64
128
192
```

130 belongs inside:

```text
128 ─────────── 191
 ↑
130
```

Therefore:

```text
Network ID     : 192.168.77.128
Broadcast ID   : 192.168.77.191

First usable   : 192.168.77.129
Last usable    : 192.168.77.190

Total addresses: 64
Usable hosts   : 62
```

---

# 🚨 8. Boundary Mistake I Learned to Avoid

Given:

```text
10.44.231.199/20
```

Mask:

```text
255.255.240.0
```

Block size:

```text
16
```

Boundaries:

```text
192
208
224
240
```

I initially selected:

```text
208 - 223 ❌
```

But the third octet is:

```text
231
```

231 belongs to:

```text
224 ───────────── 239
        ↑
       231
```

Correct subnet:

```text
Network ID    : 10.44.224.0
Broadcast ID  : 10.44.239.255
```

### 🔑 Lesson

Always find:

> **The largest valid subnet boundary that is less than or equal to the IP octet.**

---

# 🕵️ 9. Same Subnet or Different Subnet?

Interviewers may give two IPs and ask whether they can communicate locally without routing.

Example:

```text
IP 1: 172.31.46.190/22
IP 2: 172.31.47.220/22
```

`/22`:

```text
255.255.252.0
```

Block size:

```text
4
```

Relevant subnet:

```text
172.31.44.0
       ↓
172.31.47.255
```

Both IPs belong to:

```text
172.31.44.0/22
```

Therefore:

```text
Same subnet? ✅ YES
```

Network ID of both:

```text
172.31.44.0
```

---

# 🚧 10. Is the Given IP Really a Network ID?

An interviewer might intentionally give something that looks like a network.

Example:

```text
172.20.18.0/21
```

Question:

```text
Is this really the Network ID?
```

`/21`:

```text
255.255.248.0
```

Block size:

```text
8
```

Valid third-octet boundaries:

```text
0
8
16
24
32
40
...
```

`18` is NOT a boundary.

It belongs to:

```text
16 ─────────── 23
```

Therefore:

```text
172.20.18.0/21
```

is an IP inside this subnet:

```text
Network ID    : 172.20.16.0
Broadcast ID  : 172.20.23.255
```

---

# 💡 11. Network ID vs Host IP

Just because an address ends in `.0` does NOT automatically mean it is a Network ID.

Example:

```text
172.20.18.0/21
```

The `.0` at the end may make it look like a network address.

But the subnet mask determines the real network boundary.

The actual network is:

```text
172.20.16.0/21
```

So:

```text
".0 means network" ❌

Subnet mask determines network ✅
```

---

# 🔢 12. Calculating Total & Usable Hosts

Never calculate host count from block size alone.

Use:

```text
Host bits = 32 - prefix
```

Then:

```text
Total addresses = 2^(host bits)
```

Traditionally:

```text
Usable hosts = total - 2
```

Example `/21`:

```text
32 - 21 = 11 host bits

2^11 = 2048 total addresses

2048 - 2 = 2046 usable hosts
```

Example `/20`:

```text
32 - 20 = 12 host bits

2^12 = 4096 total

4096 - 2 = 4094 usable
```

---

# 🧩 13. The "Interesting Octet"

The octet where the subnet mask is neither `255` nor `0` is useful for quick manual subnetting.

Example:

```text
255.255.248.0
        ↑
```

The third octet is the interesting octet.

Example:

```text
255.255.255.192
            ↑
```

The fourth octet is the interesting octet.

Then:

```text
Block size = 256 - mask value
```

---

# ⚡ 14. Fast Interview Workflow

When given:

```text
IP + CIDR
```

I use:

```text
CIDR
 ↓
Subnet mask
 ↓
Interesting octet
 ↓
Block size
 ↓
Subnet boundaries
 ↓
Find where IP belongs
 ↓
Network ID
 ↓
Next boundary - 1
 ↓
Broadcast ID
 ↓
Network + 1
 ↓
First usable
 ↓
Broadcast - 1
 ↓
Last usable
```

---

# 🧠 15. Interview Questions I Can Now Solve

### Find NID/BID

```text
Given:
192.168.10.173/27

Find:
Network ID
Broadcast ID
Usable range
```

---

### Find CIDR from mask

```text
255.255.252.0
```

Answer:

```text
/22
```

---

### Find subnet mask from CIDR

```text
/21
```

Answer:

```text
255.255.248.0
```

---

### Same subnet?

```text
IP A = x.x.x.x/prefix
IP B = x.x.x.x/prefix
```

Find each Network ID.

```text
Same NID → Same subnet ✅

Different NID → Different subnet ❌
```

---

### Valid Network Address?

Given:

```text
172.20.18.0/21
```

Check whether the third octet is on a valid `/21` boundary.

---

### Smallest subnet for host requirement

Example:

```text
Need 50 hosts
```

```text
2^5 - 2 = 30 ❌
2^6 - 2 = 62 ✅

Prefix = /26
```

---

### Find usable-host count

Example:

```text
/22

32 - 22 = 10 host bits

2^10 = 1024

1024 - 2 = 1022 usable
```

---

# 🎯 16. Key Patterns I Now Recognize

```text
/20 → block 16 in 3rd octet

/21 → block 8 in 3rd octet

/22 → block 4 in 3rd octet

/23 → block 2 in 3rd octet

/24 → one complete 4th-octet range

/25 → block 128 in 4th octet

/26 → block 64 in 4th octet

/27 → block 32 in 4th octet

/28 → block 16 in 4th octet
```

This makes subnet boundaries much faster to recognize.

---

# 🚦 17. My Current Subnetting Workflow

```text
                 ┌──────────────┐
                 │   Given IP   │
                 └──────┬───────┘
                        │
                        ▼
                ┌───────────────┐
                │ Prefix / Mask │
                └───────┬───────┘
                        │
                        ▼
              ┌──────────────────┐
              │ Interesting Octet│
              └────────┬─────────┘
                       │
                       ▼
               ┌───────────────┐
               │  Block Size   │
               └───────┬───────┘
                       │
                       ▼
              ┌──────────────────┐
              │ Find IP Boundary │
              └────────┬─────────┘
                       │
             ┌─────────┴──────────┐
             ▼                    ▼
       ┌────────────┐       ┌────────────┐
       │ Network ID │       │ Broadcast  │
       └────────────┘       └────────────┘
             │                    │
             ▼                    ▼
        First Host            Last Host
```

---

# 🛡️ Why This Matters in Cybersecurity

Subnetting is useful beyond networking exams.

In cybersecurity it helps with:

```text
🔎 Network reconnaissance
🧭 Understanding network architecture
🔥 Firewall rule analysis
📦 Packet analysis
🛡️ Network segmentation
🌐 Routing analysis
🚨 SOC investigations
🧪 Vulnerability assessments
📡 Wireshark traffic analysis
```

If I see:

```text
Source IP      : 172.16.34.20
Destination IP : 172.16.38.50
Mask           : /21
```

I should be able to determine whether those hosts are:

```text
Same subnet?
        or
Separated by a router?
```

That makes subnetting a practical networking and cybersecurity skill rather than only a mathematical exercise.

---

# 📝 What I Learned

```text
✅ VLSM allocation

✅ Allocate largest subnet first

✅ Choose the correct prefix based on host requirements

✅ Calculate total and usable addresses

✅ Convert CIDR ↔ subnet mask

✅ Calculate subnet block size

✅ Understand third-octet subnet boundaries

✅ Understand fourth-octet subnet boundaries

✅ Move between large and small subnet allocations

✅ Find Network ID from a random host IP

✅ Find Broadcast ID from a random host IP

✅ Find first and last usable host

✅ Determine whether two IPs are in the same subnet

✅ Identify invalid network boundaries

✅ Understand why an address ending in .0 is not always a Network ID

✅ Solve subnetting questions when only the subnet mask is provided

✅ Recognize common subnet patterns quickly

✅ Apply subnetting logic to interview-style problems
```

---

# 🔬 Next Topics

The next concepts I want to strengthen are:

```text
IP Address
    │
    ▼
Binary Representation
    │
    ▼
Bitwise AND
    │
    ▼
Network ID
```

and then:

```text
🔹 Binary subnet calculations
🔹 Bitwise AND
🔹 Subnet overlap detection
🔹 Route selection / longest-prefix matching
🔹 /31 point-to-point networks
🔹 /32 host routes
🔹 More timed subnetting interview problems
```

---

# 🧠 Final Mental Model

```text
Subnetting is not about memorizing random ranges.

             PREFIX
                │
                ▼
          SUBNET MASK
                │
                ▼
           BLOCK SIZE
                │
                ▼
           BOUNDARIES
                │
                ▼
       ┌────────┴────────┐
       ▼                 ▼
   NETWORK ID       BROADCAST ID
       │                 │
       └───────┬─────────┘
               ▼
          HOST RANGE
```

Once I know the boundary, the rest of the subnet becomes predictable.

---

## 🚀 Progress

**Basic addressing → CIDR → subnet masks → subnet boundaries → VLSM → 3rd/4th-octet allocation → random-IP subnet analysis → interview-style subnetting**

The goal is no longer just to calculate subnets.

The goal is to look at an IP address and subnet mask and understand **exactly where that device belongs in the network.**
