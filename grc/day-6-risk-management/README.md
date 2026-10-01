# 🛡️ GRC Day 6 — Risk Management in IT & Cloud Hosting

📅 **Date:** 1 October 2026  
🎯 **Focus:** Risk assessment, risk scoring, hosting decisions, and case studies.

## 🧠 What I Learned

Risk assessment helps answer three questions:

- **What could go wrong?**
- **How likely is it to happen?**
- **How much damage could it cause?**

Risk management uses that assessment to choose actions and continuously review whether they work.

I explored these ideas through Swiggy, Netflix, SBI Bank, and Aadhaar.

## 🔄 Five Steps of Risk Management

| Step | Meaning | Example |
|---|---|---|
| Identify | Find what could go wrong. | A server may fail during peak demand. |
| Analyze | Estimate likelihood and impact. | How likely is failure, and what would it affect? |
| Evaluate | Decide whether the risk is acceptable. | Would the outage cause serious business damage? |
| Treat | Choose how to handle the risk. | Add capacity, backups, or alternative systems. |
| Monitor | Review risks and check controls regularly. | Watch server load and test recovery. |

**Treat** means handling the risk. A **threat** is something that could cause harm, such as an attacker or a power failure.

Risk treatment can involve avoiding, reducing, sharing/transferring, or accepting a risk.

## 📊 Risk Score and Risk Matrix

A common scoring method is:

**Risk Score = Likelihood × Impact**

This helps prioritize risks. It is a simplified assessment method, not a universal formula for every situation.

### Scoring Scale

| Score | Likelihood | Impact |
|---|---|---|
| 1 | Very rare | Negligible — barely noticeable |
| 2 | Unlikely | Minor — small inconvenience |
| 3 | Possible | Moderate — noticeable disruption |
| 4 | Likely | Major — serious damage |
| 5 | Almost certain | Catastrophic — devastating damage |

### How I Read the Matrix

Find the **likelihood row**, then the **impact column**. Their intersection gives the score.

| Likelihood ↓ / Impact → | 1 | 2 | 3 | 4 | 5 |
|---|---:|---:|---:|---:|---:|
| 5 — Almost certain | 5 | 10 | 15 | 20 | 25 |
| 4 — Likely | 4 | 8 | 12 | 16 | 20 |
| 3 — Possible | 3 | 6 | 9 | 12 | 15 |
| 2 — Unlikely | 2 | 4 | 6 | 8 | 10 |
| 1 — Very rare | 1 | 2 | 3 | 4 | 5 |

The example matrix I studied uses these categories:

- 🟢 **1–4: Low** — monitor.
- 🟡 **5–9: Medium** — plan improvements.
- 🟠 **10–14: High** — act soon.
- 🔴 **15–25: Critical** — act immediately.

**Example:** If a salary-day server failure is rated likelihood **4** and impact **5**, its score is **20 — Critical**.

These ratings need justification. Organizations may define different scales and thresholds, and a low score does not override legal requirements.

## ☁️ On-Premises and Cloud Hosting

| Hosting model | Meaning | Main consideration |
|---|---|---|
| On-premises | Infrastructure operated in facilities controlled by the organization. | Greater direct control, with responsibility for capacity and maintenance. |
| Cloud | Computing resources supplied through a cloud provider. | Flexible capacity, with security and compliance responsibilities still remaining. |
| Hybrid | A combination of on-premises and cloud systems. | Different workloads can use different hosting arrangements. |

**Auto-scaling** adjusts computing capacity according to demand and configured rules.

**Disaster recovery** means restoring services after a serious disruption.

Cloud provides tools for both, but they must be configured and tested. Cloud hosting still uses physical servers in data centers.

## 🛵 Case Study 1 — Swiggy

**Scenario:** Food-ordering demand can rise sharply during busy evenings, festivals, or major events.

- **Risk:** Insufficient capacity could slow the application or cause failed orders.
- **Impact:** Lost sales, unhappy customers, and disruption to restaurants and delivery partners.
- **Possible controls:** Auto-scaling, traffic distribution across servers, monitoring, and recovery planning.

**My understanding:** Cloud flexibility can help handle changing demand. However, provider outages, security mistakes, and unexpected costs must also be managed.

On-premises systems can scale too, but purchasing and installing additional hardware usually requires more planning.

## 🎬 Case Study 2 — Netflix

Netflix began in **1997** and introduced streaming in **2007**.

In **2008**, database corruption prevented DVD shipments for three days. This helped motivate its move toward more resilient cloud systems.

Netflix completed its streaming-service cloud migration in **January 2016**, after roughly seven years. It rebuilt much of its technology rather than simply copying existing systems into the cloud.

- **Risk:** Rapid growth and simultaneous viewing demand could overwhelm systems.
- **Approach:** Scalable cloud computing and systems designed to continue operating when individual components fail.
- **Video delivery:** Netflix uses **Open Connect**, its content delivery network, to deliver video efficiently.

A **content delivery network (CDN)** distributes content through servers closer to viewers.

**My understanding:** Supporting many viewers requires computing capacity, efficient video delivery, and failure recovery. The growth discussed around COVID-19 highlighted why capacity planning matters.

## 🏦 Case Study 3 — SBI Bank

Banking systems handle sensitive information and transactions. Failures can affect customers’ money, access to services, and trust.

The main considerations I explored were:

- Protecting customer information.
- Keeping transaction records accurate.
- Maintaining service availability.
- Meeting regulatory and audit requirements.

**Data residency** means the geographic location where data is stored.

RBI requires payment-system data to be stored in India, subject to its specified exceptions and clarifications. This is not a blanket rule that all company data can never leave India or that foreign cloud providers are automatically prohibited.

**My understanding:** Banking hosting decisions must consider the workload, data location, access controls, recovery arrangements, and applicable regulations.

The hosting examples discussed are learning scenarios, not a verified map of SBI’s internal infrastructure.

## 🪪 Case Study 4 — Aadhaar

**Biometrics** are physical characteristics used for identity verification, such as fingerprints and iris patterns.

A password can be replaced after exposure. Physical biometric characteristics cannot be changed in the same way, making misuse especially serious.

Controls I explored included:

- Restricting access to sensitive information.
- Encrypting data — protecting it so unauthorized people cannot read it.
- Separating sensitive systems through network controls.
- Monitoring authentication activity.
- Using biometric locking and OTP-based authentication.

**OTP** means **One-Time Password**: a temporary code used for verification.

UIDAI’s biometric lock prevents fingerprint, iris, and face authentication while locked.

**My understanding:** Biometric locking is an authentication control. It does not mean the database is physically disconnected from the internet. A claim that Aadhaar fingerprints were stolen also requires evidence about a specific incident.

## 🕰️ Tool Explored — Wayback Machine

The **Internet Archive’s Wayback Machine** shows archived versions of websites.

I explored an archived Netflix page from **January 1999**, showing its earlier DVD-rental service.

It helps me observe:

- Earlier website designs.
- Changes in products and services.
- Parts of an organization’s historical digital footprint.

An archived page shows what was captured at that time. It does not necessarily prove the company’s founding date or provide a complete history.

## ✅ My Reflection

I can now explain the difference between identifying a risk, scoring it, deciding whether it is acceptable, and treating it.

The four cases helped me understand that hosting decisions depend on business needs:

- **Swiggy:** Handling changing order demand.
- **Netflix:** Supporting growth and efficient video delivery.
- **SBI:** Protecting financial services and meeting regulations.
- **Aadhaar:** Protecting sensitive identity information.

My main takeaway is that choosing cloud or on-premises hosting does not complete risk management. Controls must be implemented, tested, and monitored.

## 🔗 References

- [Netflix History](https://www.netflix.com/tudum/articles/netflix-trivia-25th-anniversary)
- [Netflix Cloud Migration](https://about.netflix.com/en/news/completing-the-netflix-cloud-migration)
- [Netflix Open Connect](https://openconnect.netflix.com/en/)
- [RBI — Storage of Payment System Data](https://www.rbi.org.in/commonman/english/scripts/FAQs.aspx?Id=2995)
- [UIDAI — Biometric Lock/Unlock](https://uidai.gov.in/en/contact-support/have-any-question/925-english-uk/faqs/aadhaar-online-services/biometric-lock-unlock.html)
- [AWS — Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/)
- [Wayback Machine](https://web.archive.org/)
