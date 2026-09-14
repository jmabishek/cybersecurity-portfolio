# 🌐 Advanced IP Subnetting and VLSM

## Day 10 — Networking Fundamentals

Today I continued my IPv4 subnetting learning from Day 9.

Day 9 focused on building the subnetting foundation:

- CIDR notation
- Network and host portions
- Block sizes
- Network addresses
- Broadcast addresses
- Usable host ranges
- Subnet boundaries
- Basic subnet masks
- Determining whether IP addresses belong to the same subnet

Today I moved beyond those foundations and focused on understanding **how subnetting actually works at the bit level and how subnets are designed in real networks**.

The main concepts I explored were:

- Reinforcing subnetting terminology
- Converting CIDR prefixes into subnet masks
- Understanding why values such as `192`, `224`, and `240` appear in subnet masks
- Bitwise AND and how computers determine the network address
- Borrowing host bits
- Calculating the number of subnets
- FLSM — Fixed Length Subnet Mask
- VLSM — Variable Length Subnet Mask
- Parent networks and child subnets
- VLSM allocation rules
- Checking whether multiple subnets fit inside a parent network
- Determining the required parent network size
- Understanding networks larger than `/24`
- `/23`, `/22`, `/21`, and `/20`
- Subnet boundaries moving into the third octet
- Finding the network of a random IP address with CIDR notation
- Understanding the level of subnetting required for cybersecurity work

---

# 1. Quick Terminology Reinforcement

Before moving deeper into subnetting, I reinforced several terms that are easy to confuse.

```text
/24
/26
/27
/28
```

These values are called:

**CIDR prefix lengths**

Example:

```text
192.168.1.10/26
```

The `/26` means:

```text
26 network bits
6 host bits
```

---

## Subnet Mask

A value such as:

```text
255.255.255.192
```

is called a:

**Subnet Mask**

It identifies which bits belong to the network and which bits belong to hosts.

---

## Block Size

A subnet may contain:

```text
128 addresses
64 addresses
32 addresses
16 addresses
8 addresses
```

These are the subnet's:

**Block sizes**

Example:

```text
/26

32 - 26 = 6 host bits

2^6 = 64

Block Size = 64 addresses
```

---

## Subnet Boundary

A subnet cannot begin at any random IP address.

Its valid starting positions depend on its block size.

For a block size of:

```text
32
```

valid boundaries are:

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

Therefore:

```text
192.168.1.64
```

can be a valid network address for a 32-address block.

But:

```text
192.168.1.70
```

cannot.

---

## Important Difference

I reinforced the difference between these three concepts:

```text
Block Size
    ↓
How large the subnet is


Subnet Boundary
    ↓
Where a subnet of that size is allowed to begin


Network Address
    ↓
The actual first address of the particular subnet
```

Example:

```text
Block size = 32

Possible boundaries:

0
32
64
96
128
160
192
224
```

If the subnet starts at:

```text
64
```

then:

```text
Network Address = .64
Broadcast       = .95
Next Boundary   = .96
```

---

# 2. CIDR to Subnet Mask — Why `/26` Becomes `192`

Previously I knew:

```text
/26 = 255.255.255.192
```

Today I reinforced exactly where the value `192` comes from.

A `/26` subnet mask contains:

```text
26 ones
followed by
6 zeros
```

Binary:

```text
11111111.11111111.11111111.11000000
```

The final octet is:

```text
11000000
```

The binary place values are:

```text
128 64 32 16 8 4 2 1
```

Therefore:

```text
1   1   0  0 0 0 0 0
128 64
```

So:

```text
128 + 64 = 192
```

Therefore:

```text
/26 = 255.255.255.192
```

---

# 3. `/27` and `/28`

The same logic applies to other CIDR prefixes.

## `/27`

Binary mask:

```text
11111111.11111111.11111111.11100000
```

Last octet:

```text
11100000
```

Calculation:

```text
128 + 64 + 32
=
224
```

Therefore:

```text
/27 = 255.255.255.224
```

---

## `/28`

Binary:

```text
11110000
```

Calculation:

```text
128 + 64 + 32 + 16
=
240
```

Therefore:

```text
/28 = 255.255.255.240
```

---

## Pattern

```text
/25 → 10000000 → 128
/26 → 11000000 → 192
/27 → 11100000 → 224
/28 → 11110000 → 240
/29 → 11111000 → 248
/30 → 11111100 → 252
```

This means I no longer need to memorize these numbers blindly.

I understand where they come from.

---

# 4. Bitwise AND

Another concept I explored was:

**Bitwise AND**

A computer can use an IP address together with its subnet mask to determine the network address.

AND follows four simple rules:

```text
1 AND 1 = 1

1 AND 0 = 0

0 AND 1 = 0

0 AND 0 = 0
```

Only:

```text
1 AND 1
```

produces:

```text
1
```

---

# 5. Why Bitwise AND Is Used

Consider:

```text
IP Address:
192.168.1.130/26

Subnet Mask:
255.255.255.192
```

Focus on the final octet.

`130` in binary:

```text
10000010
```

`192` in binary:

```text
11000000
```

Perform AND:

```text
IP:       10000010
Mask:     11000000
          --------
Result:   10000000
```

`10000000` in decimal is:

```text
128
```

Therefore the network address is:

```text
192.168.1.128
```

---

## Connection to the Boundary Method

I already knew that `/26` has:

```text
Block Size = 64
```

Its boundaries are:

```text
0
64
128
192
```

The address:

```text
130
```

belongs inside:

```text
128–191
```

Therefore:

```text
Network = .128
```

Bitwise AND gives the same result.

```text
Boundary Method
       ↓
Useful human method


Bitwise AND
       ↓
Binary operation used to determine the network portion
```

The important understanding for cybersecurity is not performing hundreds of binary calculations manually.

The important idea is:

```text
IP Address
     AND
Subnet Mask
     ↓
Network Address
```

---

# 6. Borrowing Host Bits

Today I learned more clearly why changing a CIDR prefix creates additional subnets.

Consider:

```text
192.168.1.0/24
```

A `/24` contains:

```text
24 network bits
8 host bits
```

Visual:

```text
NNNNNNNN.NNNNNNNN.NNNNNNNN.HHHHHHHH
```

Now change:

```text
/24
```

to:

```text
/26
```

The network portion gained two bits.

Those bits came from the host portion.

This is called:

**Borrowing host bits**

Before:

```text
/24

Network bits = 24
Host bits    = 8
```

After:

```text
/26

Network bits = 26
Host bits    = 6
```

Therefore:

```text
Borrowed bits = 2
```

---

# 7. Borrowed Bits Create Subnets

Two borrowed bits can have four combinations:

```text
00
01
10
11
```

Therefore:

```text
2^2 = 4 subnets
```

Meanwhile:

```text
6 host bits remain
```

So:

```text
2^6 = 64 addresses per subnet
```

Therefore splitting:

```text
192.168.1.0/24
```

into `/26` networks produces:

```text
192.168.1.0/26

192.168.1.64/26

192.168.1.128/26

192.168.1.192/26
```

Each subnet contains:

```text
64 total addresses
62 traditional usable host addresses
```

---

## Borrowing Formula

```text
Number of subnets
=
2^(borrowed bits)
```

Example:

```text
/24 → /27
```

Borrowed:

```text
27 - 24 = 3 bits
```

Therefore:

```text
2^3 = 8 subnets
```

Remaining host bits:

```text
32 - 27 = 5
```

Addresses per subnet:

```text
2^5 = 32
```

So:

```text
Borrowed bits       = 3
Remaining host bits = 5
Number of subnets   = 8
Addresses/subnet    = 32
```

---

# 8. FLSM — Fixed Length Subnet Mask

FLSM stands for:

**Fixed Length Subnet Mask**

FLSM means every subnet uses:

- The same CIDR prefix
- The same subnet mask
- The same block size
- The same address capacity

Example:

```text
192.168.10.0/24
```

Suppose I want four equally sized networks.

Borrow two bits:

```text
/24 → /26
```

This gives:

```text
2^2 = 4 subnets
```

The four networks are:

```text
192.168.10.0/26
192.168.10.64/26
192.168.10.128/26
192.168.10.192/26
```

Each has:

```text
64 total addresses
62 usable traditional host addresses
```

Visual:

```text
Parent /24

┌──────────────────────┐
│ /26                  │
├──────────────────────┤
│ /26                  │
├──────────────────────┤
│ /26                  │
├──────────────────────┤
│ /26                  │
└──────────────────────┘
```

Everything is equal-sized.

---

# 9. Problem With FLSM

Imagine departments require:

```text
Engineering = 50 hosts
Finance     = 25 hosts
Security    = 10 hosts
Management  = 5 hosts
```

Engineering requires a subnet capable of supporting 50 hosts.

A `/26` provides:

```text
62 usable traditional host addresses
```

If FLSM is used, all departments would receive `/26` networks.

```text
Engineering → /26 → 62 usable
Finance     → /26 → 62 usable
Security    → /26 → 62 usable
Management  → /26 → 62 usable
```

This wastes a large amount of address space.

That leads to:

**VLSM**

---

# 10. VLSM — Variable Length Subnet Mask

VLSM stands for:

**Variable Length Subnet Mask**

VLSM allows different subnet sizes inside the same parent network.

Instead of:

```text
/26
/26
/26
/26
```

VLSM may use:

```text
/25
/27
/28
/29
```

depending on host requirements.

Visual:

```text
FLSM

┌──────────────┐
│ /26          │
├──────────────┤
│ /26          │
├──────────────┤
│ /26          │
├──────────────┤
│ /26          │
└──────────────┘


VLSM

┌────────────────────────┐
│ /25                    │
├──────────────┐
│ /27          │
├──────────┐
│ /28      │
├──────┐
│ /29  │
└──────┘
```

The core idea:

> Allocate subnet sizes based on actual host requirements instead of giving every network the same amount of address space.

---

# 11. Core VLSM Rules

I learned three important VLSM design rules.

## Rule 1 — Allocate Largest Networks First

Suppose requirements are:

```text
60 hosts
25 hosts
10 hosts
5 hosts
```

Allocate:

```text
60 first
25 second
10 third
5 last
```

The reason is that large subnets have fewer possible valid starting boundaries.

For example:

```text
Block Size 64
```

has boundaries:

```text
0
64
128
192
```

But block size `8` has many more possibilities:

```text
0
8
16
24
32
40
48
56
...
```

Therefore large subnets are harder to place.

Smaller subnets can fit into smaller remaining spaces.

---

# 12. A Free Address Is Not Automatically a Valid Boundary

Suppose the next unused IP is:

```text
192.168.10.96
```

and I need a `/26`.

A `/26` has:

```text
Block Size = 64
```

Valid boundaries:

```text
0
64
128
192
```

Therefore:

```text
.96
```

may be unused, but it is:

```text
NOT a valid /26 network boundary
```

The next valid boundary is:

```text
.128
```

Important rule:

> Free IP address does not automatically mean valid network address.

---

# 13. Subnets Must Not Overlap

Suppose this subnet already exists:

```text
192.168.10.64/26
```

Its range is:

```text
192.168.10.64
through
192.168.10.127
```

Creating:

```text
192.168.10.96/27
```

would attempt to use:

```text
192.168.10.96
through
192.168.10.127
```

But those addresses already belong to the `/26`.

Visual:

```text
Existing /26

64 -------------------------------- 127
                96 ------------ 127
                     New /27
                        ❌
```

This is:

**Subnet overlap**

Network designs should avoid overlapping address ranges.

---

# 14. Parent Network and Child Subnets

In VLSM there is usually an original network being divided.

Example:

```text
172.16.20.0/24
```

This is the:

**Parent Network**

Its range is:

```text
172.16.20.0
through
172.16.20.255
```

Inside it, I may create:

```text
172.16.20.0/25
172.16.20.128/26
172.16.20.192/27
```

These are:

**Child Subnets**

Visual:

```text
Parent Network

172.16.20.0/24
        │
        ├── /25
        │
        ├── /26
        │
        └── /27
```

Every child subnet must remain inside the parent network's address space.

---

# 15. Tracking Used and Remaining Address Space

Suppose:

```text
Parent:
192.168.1.0/24
```

Allocate:

```text
192.168.1.0/25
```

This consumes:

```text
.0 – .127
```

Remaining:

```text
.128 – .255
```

Then allocate:

```text
192.168.1.128/26
```

Consumes:

```text
.128 – .191
```

Remaining:

```text
.192 – .255
```

Then allocate:

```text
192.168.1.192/27
```

Consumes:

```text
.192 – .223
```

Remaining:

```text
.224 – .255
```

The remaining range itself is:

```text
192.168.1.224/27
```

---

## Boundary vs Remaining Range

Another distinction I reinforced:

```text
.128
```

is the:

**Next available boundary**

while:

```text
.128 – .255
```

is the:

**Remaining unused address space**

These terms should not be confused.

---

# 16. Checking Whether a VLSM Design Fits

Before assigning IP addresses, I can check whether all required subnet blocks fit inside the parent network.

Example:

```text
Parent:
10.10.10.0/24
```

Requirements:

```text
120 hosts
60 hosts
30 hosts
20 hosts
```

First account for network and broadcast addresses in traditional subnet calculations.

```text
120 + 2 = 122
60  + 2 = 62
30  + 2 = 32
20  + 2 = 22
```

But simply adding:

```text
122 + 62 + 32 + 22 = 238
```

is NOT enough.

Subnets must use valid binary block sizes.

Therefore:

```text
120 hosts → block 128 → /25

60 hosts  → block 64  → /26

30 hosts  → block 32  → /27

20 hosts  → block 32  → /27
```

Now calculate actual consumption:

```text
128 + 64 + 32 + 32
=
256
```

A `/24` contains:

```text
256 addresses
```

Therefore:

```text
Required  = 256
Available = 256

Fits exactly ✅
```

There is no remaining address space.

---

# 17. Important VLSM Planning Lesson

This calculation taught me an important distinction:

```text
Host Requirement
       ≠
Actual Address Consumption
```

Example:

```text
20 hosts
```

requires:

```text
20 + 2 = 22 addresses
```

But there is no 22-address subnet block.

The next valid power of two is:

```text
32
```

Therefore the actual subnet consumes:

```text
32 addresses
```

Subnet blocks follow powers of two:

```text
2
4
8
16
32
64
128
256
512
1024
...
```

---

# 18. Determining the Required Parent Network

Suppose subnet requirements are:

```text
150 hosts
70 hosts
40 hosts
20 hosts
```

Convert them into blocks:

```text
150 hosts → 256-address block
70 hosts  → 128-address block
40 hosts  → 64-address block
20 hosts  → 32-address block
```

Total:

```text
256 + 128 + 64 + 32
=
480 addresses
```

A `/24` contains:

```text
256 addresses
```

Therefore:

```text
480 > 256
```

A `/24` is too small.

The next binary network capacity is:

```text
512
```

Since:

```text
512 = 2^9
```

we need:

```text
9 host bits
```

IPv4 has 32 total bits:

```text
32 - 9 = 23
```

Therefore:

```text
Required parent = /23
```

So:

```text
/24 → 256 addresses ❌

/23 → 512 addresses ✅
```

---

# 19. Networks Larger Than `/24`

Until this point, most of my subnetting work happened inside the fourth octet.

Example:

```text
192.168.1.X
```

But prefixes such as:

```text
/23
/22
/21
/20
```

change the host portion inside the:

**Third octet**

This was an important progression in my subnetting understanding.

---

# 20. Understanding `/23`

Consider:

```text
192.168.10.0/23
```

A `/23` means:

```text
23 network bits
9 host bits
```

Across the octets:

```text
8 network bits
+
8 network bits
+
7 network bits
=
23
```

Therefore the bit structure becomes:

```text
NNNNNNNN.NNNNNNNN.NNNNNNNH.HHHHHHHH
```

Notice:

```text
1 host bit
```

exists inside the third octet.

---

# 21. `/23` Subnet Mask

Binary:

```text
11111111.11111111.11111110.00000000
```

Convert:

```text
11111111 = 255
11111111 = 255
11111110 = 254
00000000 = 0
```

Therefore:

```text
/23 = 255.255.254.0
```

The interesting octet is now:

```text
Third octet
```

because:

```text
254
```

appears there.

---

# 22. Third-Octet Block Size for `/23`

Use:

```text
256 - 254 = 2
```

Therefore `/23` networks move in jumps of:

```text
2
```

in the third octet.

Valid `/23` boundaries include:

```text
192.168.0.0
192.168.2.0
192.168.4.0
192.168.6.0
192.168.8.0
192.168.10.0
192.168.12.0
...
```

Therefore:

```text
192.168.10.0/23
```

covers third-octet values:

```text
10
11
```

Range:

```text
192.168.10.0
through
192.168.11.255
```

Next `/23`:

```text
192.168.12.0
```

---

# 23. Why `/23` Covers Two Third-Octet Values

The final bit of the third octet belongs to the host portion.

For decimal `10`:

```text
10 = 00001010
```

With `/23`:

```text
0000101 0
^^^^^^^ ^
Network Host
```

That host bit can be:

```text
0
or
1
```

Therefore:

```text
00001010 = 10

00001011 = 11
```

That is why the same `/23` includes:

```text
192.168.10.x

and

192.168.11.x
```

---

# 24. `/22`, `/21`, and `/20`

The same pattern continues.

```text
Prefix   Host bits in 3rd octet   Third-octet span

/24               0                       1

/23               1                       2

/22               2                       4

/21               3                       8

/20               4                      16
```

As the prefix becomes smaller:

```text
/24
↓
/23
↓
/22
↓
/21
↓
/20
```

the network becomes:

**larger**

because more bits become available for hosts.

---

# 25. Understanding `/22`

Example:

```text
172.16.8.0/22
```

A `/22` has:

```text
32 - 22 = 10 host bits
```

Eight are in the fourth octet.

Therefore:

```text
2 host bits
```

exist in the third octet.

Visual:

```text
NNNNNNNN.NNNNNNNN.NNNNNNHH.HHHHHHHH
```

Two bits produce:

```text
2^2 = 4
```

third-octet values.

If the network starts at:

```text
8
```

then those four values are:

```text
8
9
10
11
```

Therefore:

```text
Network:
172.16.8.0

Broadcast:
172.16.11.255

Next Network:
172.16.12.0
```

---

# 26. `/22` Subnet Mask and Block Size

A `/22` mask is:

```text
255.255.252.0
```

Interesting octet:

```text
252
```

Calculate:

```text
256 - 252 = 4
```

Therefore valid third-octet boundaries are:

```text
0
4
8
12
16
20
24
28
...
```

If the subnet starts at:

```text
8
```

the range is:

```text
8–11
```

Then:

```text
12
```

starts the next `/22`.

---

# 27. Example — 700 Hosts

Suppose I need:

```text
700 hosts
```

Traditional subnet planning:

```text
700 + 2 = 702
```

Available powers of two:

```text
512  ❌
1024 ✅
```

Therefore:

```text
Block = 1024
```

Since:

```text
1024 = 2^10
```

there are:

```text
10 host bits
```

Therefore:

```text
32 - 10 = /22
```

If the available network starts at:

```text
172.16.8.0
```

the subnet becomes:

```text
172.16.8.0/22
```

It covers:

```text
172.16.8.x
172.16.9.x
172.16.10.x
172.16.11.x
```

Network:

```text
172.16.8.0
```

Broadcast:

```text
172.16.11.255
```

Next subnet:

```text
172.16.12.0
```

---

# 28. Understanding `/21`

A `/21` has:

```text
32 - 21 = 11 host bits
```

Eight host bits exist in the fourth octet.

Therefore:

```text
3 host bits
```

exist in the third octet.

So:

```text
2^3 = 8
```

third-octet values belong to each `/21`.

Valid third-octet boundaries:

```text
0
8
16
24
32
40
48
...
```

Ranges:

```text
0–7

8–15

16–23

24–31

32–39

...
```

---

# 29. Finding the Network of a Random IP

Example:

```text
172.16.19.147/21
```

For `/21`:

```text
Third-octet block size = 8
```

Boundaries:

```text
0
8
16
24
32
...
```

The third octet of the IP is:

```text
19
```

`19` belongs inside:

```text
16–23
```

Therefore:

```text
Network Address:
172.16.16.0
```

The next subnet begins at:

```text
172.16.24.0
```

Therefore the broadcast of the current subnet is:

```text
172.16.23.255
```

Usable range:

```text
172.16.16.1
through
172.16.23.254
```

---

# 30. Understanding `/20`

Example:

```text
10.20.45.77/20
```

A `/20` has:

```text
12 host bits
```

Of those:

```text
8 host bits → fourth octet

4 host bits → third octet
```

Therefore:

```text
2^4 = 16
```

third-octet values exist inside one `/20`.

Valid boundaries:

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

The third octet in the IP is:

```text
45
```

It belongs inside:

```text
32–47
```

Therefore:

```text
Network:
10.20.32.0

Broadcast:
10.20.47.255

Next Subnet:
10.20.48.0
```

---

# 31. Important Distinction — Total Addresses vs Octet Block Size

For `/20`:

```text
32 - 20 = 12 host bits
```

Total addresses:

```text
2^12 = 4096
```

But the third-octet block size is:

```text
16
```

These are not the same thing.

```text
4096
=
Total IP addresses in the entire /20 subnet


16
=
Jump between subnet boundaries in the third octet
```

This distinction is important when subnetting across multiple octets.

---

# 32. Useful Prefix Pattern

A useful mental pattern I learned is:

```text
/24 → 1 third-octet value

/23 → 2 third-octet values

/22 → 4 third-octet values

/21 → 8 third-octet values

/20 → 16 third-octet values
```

Corresponding third-octet block sizes:

```text
/24 → 1

/23 → 2

/22 → 4

/21 → 8

/20 → 16
```

---

# 33. Subnetting Workflow I Can Now Use

When given a host requirement:

```text
1. Determine required hosts

2. Account for network and broadcast addresses
   for traditional host subnet calculations

3. Choose the smallest valid power-of-two block

4. Determine host bits

5. Calculate CIDR prefix

6. Determine subnet mask

7. Find valid subnet boundary

8. Determine:
   - Network address
   - First usable IP
   - Last usable IP
   - Broadcast address

9. Find the next valid boundary
```

For VLSM:

```text
1. List all host requirements

2. Convert each requirement into a valid block size

3. Sort from largest to smallest

4. Check whether all blocks fit inside the parent network

5. Allocate the largest subnet first

6. Continue from the next valid boundary

7. Ensure every subnet:
   - Starts on a valid boundary
   - Stays inside the parent network
   - Does not overlap another subnet

8. Track the remaining unused address space
```

---

# 34. Why This Matters in Cybersecurity

My goal is cybersecurity rather than becoming a dedicated network engineer.

Therefore the most important skill is not simply solving subnet arithmetic.

I need to understand what IP ranges represent when I encounter them in real security environments.

Subnetting appears in:

```text
Firewall rules

Access Control Lists — ACLs

Security Groups

Cloud VPC networks

VPN configurations

Network segmentation

Routing tables

IDS/IPS alerts

SIEM logs

Nmap scanning

Server access controls

Incident investigations
```

Example firewall rule:

```text
ALLOW TCP 22
SOURCE: 192.168.10.0/24
```

This means SSH access is permitted from systems belonging to:

```text
192.168.10.0/24
```

Understanding CIDR allows me to determine exactly which IP addresses are affected by security rules.

---

# 35. Example Security Scenario

Suppose a server has:

```text
Server:
192.168.10.130/26
```

Another system has:

```text
192.168.10.170
```

A `/26` has block size:

```text
64
```

Boundaries:

```text
0
64
128
192
```

The range containing `130` is:

```text
128–191
```

The address:

```text
170
```

also belongs inside:

```text
128–191
```

Therefore both systems belong to the same subnet.

This type of understanding is useful when investigating:

- Host communication
- Firewall traffic
- Network segmentation
- Suspicious connections
- Routing behavior
- Security alerts

---

# 36. Current Subnetting Knowledge

After Day 10, I now understand:

```text
✅ Why subnetting exists

✅ Network bits and host bits

✅ CIDR notation

✅ CIDR prefix lengths

✅ Subnet masks

✅ Binary subnet-mask values

✅ Network addresses

✅ Broadcast addresses

✅ Usable host ranges

✅ Block sizes

✅ Subnet boundaries

✅ Valid and invalid subnet starting positions

✅ Calculating host capacity

✅ Finding which subnet contains an IP

✅ Determining whether IPs belong to the same subnet

✅ Basic local-vs-remote network decisions

✅ Bitwise AND concept

✅ Borrowing host bits

✅ Calculating the number of subnets

✅ FLSM fundamentals

✅ VLSM fundamentals

✅ Largest-to-smallest VLSM allocation

✅ Parent networks

✅ Child subnets

✅ Detecting overlapping subnets

✅ Tracking remaining address space

✅ Checking whether VLSM requirements fit inside a parent

✅ Determining the required parent prefix

✅ Networks larger than /24

✅ /23 addressing

✅ /22 addressing

✅ /21 addressing

✅ /20 addressing

✅ Third-octet subnet boundaries

✅ Finding network and broadcast addresses from random IP/CIDR combinations
```

---

# 37. Topics I Do Not Need to Over-Practice Right Now

For an entry-level cybersecurity role, I do not need to spend excessive time repeatedly solving the same subnet arithmetic.

My current foundation is sufficient to begin applying subnetting to security topics.

More advanced networking topics can be explored later when required:

```text
Wildcard masks

Route summarization

Supernetting

/31 point-to-point networks

/32 host routes

IPv6 subnetting

Complex enterprise subnet design
```

These are useful topics, but they are not currently more important than learning how networking concepts interact with cybersecurity systems.

---

# 38. Current Cybersecurity-Relevant Subnetting Level

At this stage, I should be able to understand common questions such as:

```text
What does /24 mean?

What is a subnet mask?

How many addresses does /26 contain?

What is a network address?

What is a broadcast address?

What is the usable host range?

Are two IP addresses in the same subnet?

What network contains this IP?

Why do organizations subnet networks?

What is the difference between FLSM and VLSM?

How does a computer identify its network?

What is bitwise AND?

How are host bits borrowed?

Why does /23 span multiple third-octet values?

What range does a firewall CIDR rule affect?
```

This is sufficient subnetting depth for me to continue into practical beginner cybersecurity networking topics such as:

```text
Routing

Default gateways

Firewalls

ACLs

Network segmentation

NAT/PAT

Server communication

Security monitoring

IDS/IPS traffic analysis
```

---

# 39. Final Mental Model

The biggest connection I built today is:

```text
IPv4 Address
      │
      ▼
CIDR Prefix
      │
      ▼
Network Bits + Host Bits
      │
      ├───────────────┐
      ▼               ▼
Subnet Mask        Host Capacity
      │               │
      ▼               ▼
Block Size       Required Addresses
      │               │
      └───────┬───────┘
              ▼
       Subnet Boundary
              │
              ▼
        Network Address
              │
              ▼
        Usable Hosts
              │
              ▼
       Broadcast Address
```

For multiple networks:

```text
Parent Network
      │
      ▼
Host Requirements
      │
      ▼
Convert to Valid Blocks
      │
      ▼
Largest → Smallest
      │
      ▼
Assign Valid Boundaries
      │
      ▼
Avoid Overlap
      │
      ▼
Track Remaining Space
      │
      ▼
Complete VLSM Design
```

And when the network becomes larger than `/24`:

```text
/24
 │
 ▼
Fourth-octet subnetting

/23
 │
 ▼
2 third-octet values

/22
 │
 ▼
4 third-octet values

/21
 │
 ▼
8 third-octet values

/20
 │
 ▼
16 third-octet values
```

---

# 40. Day 10 Takeaway

Day 9 gave me the basic mechanics of subnetting.

Day 10 helped me connect those mechanics into a broader subnet-design model.

I moved from simply calculating:

```text
Network
Broadcast
Host Range
```

to understanding:

```text
Why subnet masks contain specific binary values

How the operating system identifies a network

How borrowing bits creates additional subnets

Why FLSM and VLSM exist

How multiple subnets can be designed inside a parent network

Why block sizes must be used instead of simply counting requested hosts

How to determine whether a parent network has enough capacity

How networks larger than /24 span multiple third-octet values

How to determine the subnet of an arbitrary IP address

How subnetting connects directly to cybersecurity systems
```

At this point, my goal is no longer to repeatedly practice the same subnet calculations.

The next step is to apply this networking knowledge to real cybersecurity concepts such as:

**routing, default gateways, firewall rules, ACLs, network segmentation, server communication, and traffic analysis.**
