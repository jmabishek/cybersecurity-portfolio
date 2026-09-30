# 🛡️ GRC — DAY 05

## Understanding Risk, Controls and RBI Cybersecurity Requirements

**Learning Track:** Governance, Risk & Compliance  
**Focus:** Banking Security • Risk • Controls • Evidence • Accountability

---

## 💡 The Main Idea

**GRC connects a security weakness to its business consequences and the action needed to reduce the risk.**

My questions are:

> What could go wrong? What would it affect? Which controls would help? How do we verify them? Who is responsible?

This builds on my previous learning about business assets, data protection and appropriate access.

---

## 01 — 🏦 Why RBI Cybersecurity Requirements Matter

**RBI — Reserve Bank of India** is India's central bank and a banking regulator.

Banking cybersecurity needs to protect customer information, transactions and essential services.

I understand its main areas through this simple overview:

| Area | Purpose |
| --- | --- |
| **Governance** | Set policies, responsibilities and oversight. |
| **Risk** | Identify and assess what could go wrong. |
| **Protection** | Put safeguards in place. |
| **Detection** | Identify suspicious activity. |
| **Response** | Contain and investigate incidents. |
| **Resilience** | Continue or restore important services. |
| **Assurance** | Verify controls through evidence and reviews. |

These are learning categories, not the official RBI chapter headings.

### 📌 Regulatory Reference

The relevant reference is the **RBI Commercial Banks cybersecurity and technology directions, 2026**, issued on **31 July 2026**, effective immediately.

- Its scope excludes Small Finance Banks, Payments Banks and Local Area Banks; those institutions may have separate requirements.
- It covers governance, risk management, technical controls, recovery, monitoring and audit.
- Paragraph 182 requires cyber-incident reporting through **DAKSH within six hours of detection**, alongside proactive notification to **CERT-In**, India's national computer-security incident-response agency.

[Read the official RBI directions](https://rbi.org.in/scripts/NotificationUser.aspx?Id=13643&Mode=0)

---

## 02 — 📚 The GRC Terms I Connected Today

| Term | My Understanding |
| --- | --- |
| **Asset** | Something valuable that needs protection. |
| **Threat** | A potential cause of harm. |
| **Vulnerability** | A weakness that could be exploited. |
| **Risk** | Possible harm, assessed through likelihood and impact. |
| **Control** | A safeguard that reduces risk. |
| **Evidence** | Records or test results supporting a conclusion. |
| **Gap** | Something missing or ineffective. |
| **Risk Owner** | Person accountable for managing the risk. |
| **Control Owner** | Person or team responsible for the safeguard. |
| **Remediation** | Work that addresses a weakness. |
| **Residual Risk** | Risk remaining after considering controls. |
| **Risk Register** | A record of risks, owners, treatment and status. |

**A vulnerability is the weakness. Risk describes what could happen because of it.**

---

## 03 — ⚠️ Example: A Bank's Loan Application

Consider a hypothetical internet-facing loan application containing customer and **KYC — Know Your Customer** information.

A security assessment finds **SQL injection**: a weakness where user input can interfere with database commands.

| Element | Example |
| --- | --- |
| **Asset** | Loan application and customer data |
| **Threat** | An attacker exploiting the application |
| **Vulnerability** | SQL injection |
| **Business Impact** | Data exposure, manipulation, fraud or disruption |
| **Risk Owner** | Application / Business Owner |
| **Treatment** | Fix the weakness and verify the result |
| **Status** | Open until treatment is verified |

### My Risk Statement

> An attacker could exploit SQL injection to access or manipulate customer information, potentially causing fraud and loss of trust.

Possible controls include:

- **Parameterised queries:** keep input separate from database instructions.
- **WAF — Web Application Firewall:** filter suspicious web requests.
- **Least privilege:** limit database permissions.
- **Monitoring:** identify suspicious activity.
- **Retesting:** verify that remediation worked.

**A WAF does not repair unsafe code. No detected attack does not prove that the application is safe.**

---

## 04 — 🛡️ Three Types of Controls

| Type | Purpose | Example |
| --- | --- | --- |
| **Preventive** | Reduce the chance of an unwanted event. | MFA, restricted access, secure coding |
| **Detective** | Identify suspicious activity or weaknesses. | Logs, alerts, vulnerability scans |
| **Corrective** | Address a weakness or restore service. | Patching, remediation, recovery |

**MFA — Multi-Factor Authentication** uses different authentication factors, such as a password and a security key.

For an administrator portal with password-only access, old accounts and a missing patch:

- Enable MFA and disable unnecessary accounts.
- Review privileged activity and alert on abnormal logins.
- Apply the patch and verify remediation.

One risk often needs several controls.

---

## 05 — 🧾 Evidence and Accountability

A control being mentioned in a policy does not prove that it works.

| Control | Evidence I Would Request |
| --- | --- |
| MFA | Enforcement settings and login-test results |
| Account removal | Account inventory and deactivation records |
| Patching | Installed version and verification results |
| Monitoring | Logs, alerts and review records |
| Application fix | Code review and retest results |

Every action needs an **owner, target date and verification criteria**.

Outsourcing hosting also creates **third-party risk**. Depending heavily on one provider creates **concentration risk**. The bank still needs to oversee its responsibilities.

---

## 📝 My Reflection

The underlying reasoning was familiar: understand what matters, identify possible harm and choose appropriate protection.

Today I connected that reasoning to formal terminology and structured records.

**My main takeaway: identify the risk, select controls, request evidence, assign responsibility and verify the outcome.**
