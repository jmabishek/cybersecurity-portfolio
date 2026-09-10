# 🌐 NETWORKING — DAY 02

## IPv4 Address Format, Decimal–Binary Conversion and IP Address Classes

**Learning Track:** Networking Fundamentals
**Focus:** IPv4 • 32-bit Addressing • Octets • Dotted Decimal Notation • Binary • Decimal Conversion • Class A • Class B • Class C • Class D • Class E • Network Portion • Host Portion

---

> [!IMPORTANT]
>
> ### 💡 The main idea I am taking from Networking Day 2
>
> **An IPv4 address is a 32-bit logical address divided into four 8-bit octets. Binary is how the address is represented internally, while dotted-decimal notation makes it easier for humans to read.**
>
> I also learned how the historical IPv4 class system divided addresses into network and host portions.
>
> My current mental model is:
>
> ```text
> IPv4 Address
>       ↓
> 32 bits total
>       ↓
> 4 octets × 8 bits
>       ↓
> Each octet = 0–255
>       ↓
> Binary ↔ Decimal
>       ↓
> Human-readable dotted decimal
>       ↓
> Historical IPv4 Classes
> A / B / C / D / E
> ```

---

# 01 — 📍 Revisiting IPv4

From Day 1, I already understood that an IP address is a **logical network address** used at the Network Layer.

Today I went deeper into how an IPv4 address is constructed.

IPv4 uses:

```text
32 bits
```

Those 32 bits are divided into:

```text
4 groups × 8 bits
```

Each 8-bit group is called an:

> **Octet**

Therefore:

```text
8 bits + 8 bits + 8 bits + 8 bits
              =
            32 bits
```

Example:

```text
192.168.1.25
```

can be viewed as:

```text
192      168       1        25
 ↓        ↓        ↓        ↓
Octet 1  Octet 2  Octet 3  Octet 4
8 bits   8 bits   8 bits   8 bits
```

---

# 02 — 🔢 Why Does an Octet Range From 0 to 255?

An octet contains **8 binary bits**.

Each bit can have only two possible values:

```text
0
or
1
```

Eight bits therefore provide:

```text
2⁸ = 256 possible combinations
```

However, counting starts from zero.

Therefore the possible decimal values are:

```text
0 → 255
```

The smallest possible octet is:

```text
00000000
```

which equals:

```text
0
```

The largest possible octet is:

```text
11111111
```

which equals:

```text
255
```

Therefore every IPv4 octet must be between:

```text
0 and 255
```

---

# 03 — 🧮 Binary Place Values

To understand IPv4 properly, I practiced converting between decimal and binary.

An 8-bit octet has the following place values:

```text
128   64   32   16   8   4   2   1
 ↓     ↓    ↓    ↓   ↓   ↓   ↓   ↓
Bit   Bit  Bit  Bit  Bit Bit Bit Bit
```

Each position containing `1` contributes its value.

A position containing `0` contributes nothing.

For example:

```text
11000000
```

Using the place values:

```text
128   64   32   16   8   4   2   1
 1     1    0    0   0   0   0   0
```

Calculation:

```text
128 + 64 = 192
```

Therefore:

```text
11000000 = 192
```

---

# 04 — 🔄 Binary to Decimal Conversion

Some conversions I practiced were:

| Binary     | Calculation                        | Decimal |
| ---------- | ---------------------------------- | ------: |
| `10000000` | 128                                |     128 |
| `11000000` | 128 + 64                           |     192 |
| `10100000` | 128 + 32                           |     160 |
| `11111111` | 128 + 64 + 32 + 16 + 8 + 4 + 2 + 1 |     255 |
| `00001010` | 8 + 2                              |      10 |

This helped me understand that an IPv4 address written in decimal is simply a more readable representation of binary values.

---

# 05 — 🔄 Decimal to Binary Conversion

I also practiced converting decimal numbers back into binary.

For example:

```text
192
```

can be created using:

```text
128 + 64 = 192
```

Therefore:

```text
192 = 11000000
```

Another example:

```text
168
```

Calculation:

```text
128 + 32 + 8 = 168
```

Binary:

```text
10101000
```

Another example:

```text
10
```

Calculation:

```text
8 + 2 = 10
```

Binary:

```text
00001010
```

Some conversions I practiced:

```text
192 → 11000000

168 → 10101000

10  → 00001010

255 → 11111111

172 → 10101100
```

---

# 06 — 📝 IPv4 Dotted-Decimal Notation

Computers can represent IPv4 addresses in binary.

For example:

```text
11000000.10101000.00000001.00011001
```

Reading and remembering this is difficult for humans.

Therefore IPv4 is normally represented using:

> **Dotted-decimal notation**

The same address becomes:

```text
192.168.1.25
```

The relationship is:

```text
11000000 → 192
10101000 → 168
00000001 → 1
00011001 → 25
```

Giving:

```text
11000000.10101000.00000001.00011001

                    ↓

              192.168.1.25
```

This made the purpose of dotted-decimal notation much clearer to me.

It does not create a different address.

It provides a human-readable representation of the same 32-bit IPv4 address.

---

# 07 — 🗂️ Historical IPv4 Address Classes

Today I also learned about the historical **classful IPv4 addressing system**.

IPv4 addresses were traditionally divided into five classes:

```text
Class A
Class B
Class C
Class D
Class E
```

The class could be identified by looking at the **first octet**.

| Class   | First-Octet Range | Main Purpose                       |
| ------- | ----------------: | ---------------------------------- |
| Class A |             1–126 | Historically large networks        |
| Class B |           128–191 | Historically medium-sized networks |
| Class C |           192–223 | Historically smaller networks      |
| Class D |           224–239 | Multicast                          |
| Class E |           240–255 | Reserved / experimental            |

Two ranges require special attention:

```text
0.x.x.x
```

has special/reserved purposes.

And:

```text
127.x.x.x
```

is reserved for **loopback**.

A well-known loopback address is:

```text
127.0.0.1
```

which represents the local computer itself.

---

# 08 — 🧠 Remembering the Class Boundaries

The ranges I practiced were:

```text
Class A →   1 – 126

127     →   Loopback

Class B → 128 – 191

Class C → 192 – 223

Class D → 224 – 239

Class E → 240 – 255
```

The important boundary values are:

```text
126 → last Class A value

128 → Class B begins
191 → Class B ends

192 → Class C begins
223 → Class C ends

224 → Class D begins
239 → Class D ends

240 → Class E begins
```

Practicing the boundaries helped me identify classes faster instead of trying to guess based on the appearance of an address.

---

# 09 — 🏢 Class A — Network and Host Portion

In traditional Class A addressing:

```text
N.H.H.H
```

where:

```text
N = Network portion
H = Host portion
```

Example:

```text
50.20.30.40
```

The division is:

```text
Network        Host
   ↓             ↓
  50      .   20.30.40
```

Therefore:

```text
Network portion = 50

Host portion = 20.30.40
```

Class A historically provided a relatively small number of network identifiers but a very large host-address space within each network.

---

# 10 — 🏢 Class B — Network and Host Portion

Traditional Class B addressing uses:

```text
N.N.H.H
```

Example:

```text
150.25.60.70
```

Division:

```text
Network        Host
   ↓             ↓
150.25    .    60.70
```

Therefore:

```text
Network portion = 150.25

Host portion = 60.70
```

Class B historically provided a balance between the number of networks and the number of hosts available within each network.

---

# 11 — 🏠 Class C — Network and Host Portion

Traditional Class C addressing uses:

```text
N.N.N.H
```

Example:

```text
200.100.50.25
```

Division:

```text
Network             Host
   ↓                  ↓
200.100.50     .      25
```

Therefore:

```text
Network portion = 200.100.50

Host portion = 25
```

Compared with Class A and Class B, Class C dedicates more of the address to identifying the network and less to identifying hosts.

---

# 12 — 🌐 What Do Network and Host Mean?

One concept I wanted to understand instead of simply memorizing was the meaning of:

```text
Network portion
```

and:

```text
Host portion
```

My current understanding is:

> **The network portion identifies the network to which an address belongs, while the host portion identifies an individual host/interface within that network.**

Conceptually:

```text
Network
   │
   ├── Host 1
   ├── Host 2
   ├── Host 3
   └── Host 4
```

For example, under the traditional Class C model:

```text
192.168.1.25
```

can be viewed as:

```text
192.168.1 → Network portion

25        → Host portion
```

This helped me understand why different class structures provide different amounts of space for hosts.

---

# 13 — 📊 Why Class A Had More Host Capacity

The three traditional structures can be compared as:

```text
Class A
N.H.H.H

1 network octet
3 host octets
```

```text
Class B
N.N.H.H

2 network octets
2 host octets
```

```text
Class C
N.N.N.H

3 network octets
1 host octet
```

Therefore:

```text
Class A → More bits available for hosts

Class B → Medium host-address space

Class C → Smaller host-address space
```

One terminology correction I learned was that this should be described as **host capacity/address space**, not bandwidth.

Bandwidth refers to how much data a network connection can carry.

---

# 14 — 📡 Class D — Multicast

Class D covers first-octet values:

```text
224–239
```

Class D is different from Classes A, B and C.

It is associated with:

> **Multicast addressing**

Multicast means communication intended for a **group of receivers** rather than one ordinary individual host address.

Therefore I should not try to divide Class D addresses using the normal:

```text
Network + Host
```

Class A/B/C model.

I will study multicast in more detail when unicast, multicast and broadcast are introduced.

---

# 15 — 🧪 Class E — Reserved / Experimental

Class E covers:

```text
240–255
```

These addresses were historically reserved for experimental or special purposes rather than normal Class A/B/C host addressing.

Therefore Class E also should not be treated using the normal Class A/B/C network-host division.

---

# 16 — ⚠️ Classes Do Not Mean Wi-Fi, Mobile Data, LAN or WAN

One misconception I corrected today was thinking that the classes might directly correspond to technologies such as:

```text
Class A → WAN

Class B → Mobile Data

Class C → Wi-Fi / LAN
```

That interpretation is incorrect.

The class system does **not** describe the physical connection technology.

For example, a Wi-Fi network may use an address such as:

```text
192.168.1.20
```

but this does not mean:

```text
Wi-Fi = Class C
```

It only means that this particular IPv4 address falls within the historical Class C first-octet range.

Similarly, addresses beginning with `10` can also appear on private networks and Wi-Fi networks.

Therefore:

> **The type of network connection and the historical IPv4 address class are separate concepts.**

---

# 17 — 📱 Real-World Observation

While practicing today, I observed addresses on devices connected through different networks.

One address format I came across was similar to:

```text
192.168.1.1
```

This helped connect classroom theory with addresses that actually appear on real devices.

Instead of immediately assuming:

```text
192 = Wi-Fi
```

I now understand that I should first analyze the address itself.

For traditional class identification:

```text
192
```

falls within:

```text
192–223
```

therefore it belongs to the historical **Class C** range.

The actual reason a device receives a particular IP address depends on how that network has been configured.

---

# 18 — 🆕 Classful Addressing vs Modern Networking

An important clarification I learned is that:

> **Class A, B and C addressing is a historical IPv4 addressing model.**

Modern networks generally use **classless addressing and CIDR prefixes** rather than depending only on fixed Class A/B/C boundaries.

For example, modern addresses may appear as:

```text
192.168.1.1/24
```

At this stage, I only understand that the number after `/` relates to how the network portion is defined.

I have intentionally left deeper CIDR and subnetting concepts for a later networking lesson so that I can first build a strong foundation in IPv4 addressing.

---

# 19 — 🧪 Class Identification Practice

I practiced identifying classes using the first octet.

Examples:

```text
25.10.20.30
```

First octet:

```text
25
```

Therefore:

```text
Class A
```

---

```text
150.20.30.40
```

First octet:

```text
150
```

Therefore:

```text
Class B
```

---

```text
200.5.6.7
```

First octet:

```text
200
```

Therefore:

```text
Class C
```

---

```text
228.10.5.1
```

First octet:

```text
228
```

Therefore:

```text
Class D
```

---

```text
250.10.20.30
```

First octet:

```text
250
```

Therefore:

```text
Class E
```

---

# 20 — 🧩 Putting Everything Together

Consider:

```text
192.168.10.25
```

### Step 1 — Identify the first octet

```text
192
```

### Step 2 — Determine the historical class

```text
192–223 → Class C
```

### Step 3 — Apply the traditional Class C structure

```text
N.N.N.H
```

### Step 4 — Separate network and host portions

```text
Network = 192.168.10

Host = 25
```

### Step 5 — Understand its binary representation

```text
192 = 11000000
168 = 10101000
10  = 00001010
25  = 00011001
```

Therefore:

```text
192.168.10.25
```

is represented in binary as:

```text
11000000.10101000.00001010.00011001
```

This exercise connected several concepts from today's class together.

---

# 21 — 📚 Terminology Learned Today

| Term                | My Understanding                                                          |
| ------------------- | ------------------------------------------------------------------------- |
| **IPv4**            | 32-bit Internet Protocol addressing system                                |
| **Bit**             | Binary digit containing `0` or `1`                                        |
| **Octet**           | Group of 8 bits                                                           |
| **Dotted Decimal**  | Human-readable IPv4 notation such as `192.168.1.1`                        |
| **Binary**          | Base-2 representation using `0` and `1`                                   |
| **Decimal**         | Base-10 numbering system used in normal IPv4 notation                     |
| **Network Portion** | Part identifying the network                                              |
| **Host Portion**    | Part identifying a host/interface within the network                      |
| **Class A**         | Historical range `1–126`                                                  |
| **Class B**         | Historical range `128–191`                                                |
| **Class C**         | Historical range `192–223`                                                |
| **Class D**         | `224–239`, used for multicast                                             |
| **Class E**         | `240–255`, historically reserved/experimental                             |
| **Loopback**        | Addressing used by a device to refer to itself, including `127.0.0.1`     |
| **CIDR**            | Modern classless method of defining network prefixes; to be studied later |

---

# 22 — ✅ What I Can Do After Day 2

After today's study and practice, I can:

* Explain why IPv4 contains 32 bits.
* Explain why IPv4 is divided into four octets.
* Explain why each octet ranges from 0 to 255.
* Recognize dotted-decimal IPv4 notation.
* Use binary place values `128 64 32 16 8 4 2 1`.
* Convert basic binary octets into decimal.
* Convert decimal octet values into binary.
* Identify historical IPv4 Classes A–E using the first octet.
* Recognize the special role of `127.x.x.x`.
* Separate traditional Class A/B/C addresses into network and host portions.
* Explain why Class A historically allowed more host-address space than Class C.
* Explain the basic purpose of Class D and Class E.
* Avoid confusing IP classes with Wi-Fi, LAN, WAN or mobile-data technologies.
* Recognize that classful IPv4 addressing is historical and that modern networking uses classless addressing.

---

# 23 — 🧠 My Reflection

Before this lesson, an address such as:

```text
192.168.1.25
```

mostly looked like four decimal numbers separated by dots.

After studying how IPv4 is constructed, I can now mentally connect it to:

```text
32-bit IPv4 address
        ↓
Four octets
        ↓
8 bits per octet
        ↓
Binary values
        ↓
Decimal representation
        ↓
Dotted-decimal IPv4 address
```

I also understand that the historical IPv4 classes were designed around different divisions between **network identification** and **host identification**.

The most useful realization for me was that I should not simply memorize addresses.

I should be able to look at an IPv4 address and reason about:

```text
How is it represented?

What does each octet mean?

How can its decimal value be represented in binary?

Which historical class range does its first octet belong to?

Under classful addressing, which part identifies the network?

Which part identifies the host?
```

This gives me a stronger foundation before moving into concepts such as subnet masks, network IDs, broadcast addresses, public/private IP addressing and modern subnetting.

---

## 🔜 Next Learning Direction

The next networking topics will build on this foundation:

```text
Network ID
Broadcast ID
Subnet Mask
Public vs Private IPv4
Unicast
Multicast
Broadcast
CIDR
Subnetting
```

For now, my focus is to make IPv4 structure, binary conversion and historical class identification comfortable enough that I can recognize them without relying only on memorization.
