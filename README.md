# Cybersecurity Portfolio

Hi, I'm Abishek. I'm building my cybersecurity skills by working through networking labs, inspecting traffic, writing Linux tools, and documenting what my tests actually show.

**Current focus:** Networking fundamentals and practical labs. My Linux work is paused while I focus on networking, and I plan to resume it.

## Start here: selected work

| Work | What I did | What you can inspect |
|---|---|---|
| [Two-LAN routing and DHCP lab](networking-fundamentals/06-ip-routing/day-15-router-dhcp-practical-lab/README.md) | Planned two subnets, configured a router as the DHCP server, fixed disabled interfaces, and tested communication between LANs. | Address plan, Cisco commands, client settings, routing-table results, ping results, mistakes, and test limits. |
| [Wireshark traffic investigation](networking-fundamentals/02-osi-and-tcp-fundamentals/wireshark-packet-capture-tcp-udp/README.md) | Filtered a packet capture and examined conversations, UDP traffic, QUIC, and DNS. | My investigation process and what the observed traffic does and does not establish. |
| [ARP investigation](networking-fundamentals/04-arp/day-12-address-resolution-protocol/README.md) | Traced how a device finds a local MAC address and why traffic to another network uses the gateway's MAC address. | The request-and-reply flow and my troubleshooting explanations. |
| [Linux directory triage script](tools/README.md) | Built a Bash script that reports file attributes worth reviewing, including world-writable files and SUID/SGID permissions. | [Source code](tools/suspicious_hunter.sh), usage, development notes, and known limitations. |

These are learning labs and tools. A flagged file is a lead to investigate, not proof of malicious activity.

## Explore the repository

- [Networking fundamentals](networking-fundamentals/) — IP addressing, OSI and TCP/IP, Wireshark, subnetting, ARP, DHCP, and routing.
- [Linux fundamentals](linux-fundamentals/) — terminal use, permissions, Bash, scripts, and process observation. Currently paused.
- [GRC notes](grc/) — governance, risk, evidence, and understanding what an organization needs to protect.
- [Tools](tools/) — Bash directory triage script and its development notes.

## How I document my work

For each topic, I try to record the goal, my setup, the steps I took, the result I observed, mistakes I corrected, and what the evidence cannot yet prove. The detailed daily notes show how my understanding changes as I test it.

My aim is to develop the networking, Linux, investigation, and communication skills needed for security analyst and SOC work.

## Contact

**Location:** Hyderabad, India  
**Availability:** Open to cybersecurity internship opportunities

[GitHub profile](https://github.com/jmabishek)
