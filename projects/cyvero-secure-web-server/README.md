# CYVERO — Secure Web Server Deployment & Access Control

**Project:** Linux Cybersecurity Project — Phase 1  
**Name:** Jogi Mokarla Abishek  
**Batch:** 24

## Project Overview

I deployed an Apache web server on Kali Linux and configured
UFW firewall rules to control which devices could access it.

I also monitored web server logs and firewall logs to verify
successful and blocked connections.

## Technologies Used

- Kali Linux
- Apache2
- UFW Firewall
- HTML and CSS
- VirtualBox
- Ubuntu and Windows 7
- Windows 11
- Android Mobile

## Network Setup

| Device | IP Address | Purpose |
|---|---|---|
| Kali Linux | 10.0.2.15 | Apache Server |
| Ubuntu | 10.0.2.3 | Authorized Client |
| Windows 7 | 10.0.2.4 | Blocked Client |
| Windows 11 | 10.103.94.113 | Physical Client |
| Android | USB Tethering | Mobile Client |

## What I Implemented

1. Configured Apache2 on Kali Linux.
2. Created a custom website using HTML and CSS.
3. Connected Ubuntu and Windows 7 using VirtualBox NAT Network.
4. Configured UFW with a default-deny incoming policy.
5. Allowed authorized clients to access TCP port 80.
6. Blocked unauthorized HTTP connections.
7. Monitored Apache access logs and UFW firewall logs.
8. Configured VirtualBox port forwarding to test Windows 11 and mobile access.

## Firewall Configuration

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 10.0.2.3 to any port 80 proto tcp
sudo ufw enable
sudo ufw status verbose
```

## Log Monitoring

Apache access logs:

```bash
sudo tail -f /var/log/apache2/access.log
```

Firewall block logs:

```bash
sudo journalctl -k -f | grep --line-buffered 'UFW BLOCK'
```

## Results

- Successfully hosted the CYVERO website.
- Verified access from Ubuntu.
- Blocked Windows 7 using UFW.
- Identified blocked connection attempts in firewall logs.
- Accessed the website from Windows 11 and an Android phone.
- Verified successful HTTP requests using Apache logs.

## Documentation

The complete project report is available in:

`documentation/CYVERO_Phase1_Report.pdf`

## Author

**Jogi Mokarla Abishek**  
CYVERO — Batch 24

