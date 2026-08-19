🛡️ GRC — DAY 02

A Backup Can Restore Systems. It Cannot Pull Stolen Data Back.

Learning Track: Governance, Risk & Compliance
Focus: Critical Information Infrastructure • NCIIPC • Electronic Evidence • IT Act awareness • Ransomware • Data Exfiltration

[!IMPORTANT]

The one idea I am taking from Day 2

Recovering a system does not automatically mean the incident is over.

If an attacker copied customer data before I restored the server, the server may be working again — but the attacker may still have the data.

That means I have to think about more than:

“Is the system running again?”

I also have to ask:

What was accessed? What left the environment? What was changed? How did the attacker get in? Can the same path be used again? Who needs to know?

📍 Where Day 2 Started

Day 2 did not feel completely separate from Day 1.

Day 1 taught me to think about authorization, scope and responsibility before using technical capability.

Day 2 started showing me what those ideas look like when real systems, electronic evidence, customer data and incidents are involved.

My instructor roughly grouped some of the discussion around three areas:

Classroom idea

How I currently understand it

Cybercrime

Certain actions against computers, systems, networks or data can have legal consequences.

Organizational responsibility

When an organization holds other people's data, a breach is not only a technical problem. There can also be legal, regulatory and business responsibilities.

Electronic evidence

A digital file is not useful as evidence only because somebody says, “This is the file.” Its source, production and reliability matter.

I am still learning the exact legal framework, so I do not want to turn these into oversimplified one-section definitions.

01 — Critical Information Infrastructure

One part of the session was about systems that are important enough that their failure can affect much more than one company or one laptop.

The examples discussed included areas such as:

power and energy,

banking and financial services,

telecommunications,

transportation and aviation,

government systems,

strategic/public-sector systems.

My beginner-level understanding is:

Some digital systems support services that society depends on. A serious cyberattack against them can create consequences far beyond the computer that was compromised.

For example:

A normal workstation fails
        ↓
One employee may be affected

A critical service fails
        ↓
Operations may stop
        ↓
Large numbers of people may be affected
        ↓
Economic / public-safety / national consequences may follow

This is why I am starting to understand cybersecurity as something larger than protecting files on a personal computer.

02 — NCIIPC

The organization introduced in class was:

NCIIPC — National Critical Information Infrastructure Protection Centre

I initially struggled to remember the full name, but the purpose made more sense than the expansion.

My current understanding is that NCIIPC is India's national nodal body for protection of Critical Information Infrastructure (CII) and operates under the broader national cybersecurity structure associated with NTRO — National Technical Research Organisation.

I do not need to memorize every internal function today.

What matters to me at this stage is the relationship:

flowchart TD
    A[Important national / societal services] --> B[Depend on digital infrastructure]
    B --> C[Some systems qualify as Critical Information Infrastructure]
    C --> D[NCIIPC has a national role in protecting CII]

The class also discussed functions in terms of threat awareness, mitigation, coordination and engagement with stakeholders.

I am treating those as my classroom learning framework, not as a claim that I have memorized the complete statutory function list.

03 — The Fake Shopping Website Example

My instructor showed us an example involving a website designed to look like a familiar shopping platform.

The visual lesson was simple but useful:

A website looking legitimate does not prove that it is legitimate.

A victim can see familiar branding, product images, payment instructions or a convincing interface and assume everything is normal.

The advice from class was to be careful when money is involved and to avoid blindly moving a transaction into unofficial channels such as random Telegram or WhatsApp conversations simply because somebody claims to represent a company.

This connected back to Day 1 in an unexpected way.

Day 1 was:

Access does not prove authorization.

Day 2 added another version:

Appearance does not prove authenticity.

A fake site can imitate what I expect to see.

So I should verify the channel, identity and context instead of trusting appearance alone.

04 — IT Act Awareness: Know What Kind of Actions Matter

My instructor showed several legal topics connected to cyber activity.

The point was not to memorize dozens of section numbers.

Some of the ideas mentioned included:

unauthorized access or damage involving computer systems,

copying or extracting data without permission,

protection of data held by organizations,

electronic evidence,

tampering with certain computer source code,

intermediary safe-harbour concepts.

I am intentionally not pretending I understand all of these after one session.

Section 43 — Connection to Day 1

Section 43 of the Information Technology Act is still the easiest one for me to connect to my Day 1 understanding because it deals with specified acts involving computers, systems, networks and data when done without permission, including unauthorized access and certain copying, damage and interference activities.

The lesson I keep coming back to is still:

Technical capability is not permission.

Section 65 — Source Code Tampering

I originally remembered this as simply:

“Tampering with source code is illegal.”

That sentence is too broad.

My corrected understanding is that IT Act Section 65 concerns knowingly or intentionally concealing, destroying or altering computer source code when that source code is required by law to be kept or maintained.

So I should not turn a specific legal provision into a blanket statement that “editing source code is illegal.”

05 — Electronic Evidence: A File Needs Context

This was one of the parts I tried to explain in my own words.

Suppose CCTV footage is being used as electronic evidence.

My classroom understanding was that I should care about questions such as:

What device/system produced the record?
For example: CCTV/DVR, phone or another computer/communication device.

What was the system normally being used for?
For example: a CCTV system installed to continuously record a particular location.

Was the system operating properly during the relevant period?

Can we establish what electronic record was produced and how it was produced?

Is the required certificate/signature information present from the responsible persons?

The important thing I understood was not the number of bullet points.

It was this:

Electronic evidence needs provenance and reliability. We should be able to explain where it came from and the conditions under which it was produced.

⚖️ Accuracy Note — “65B” vs Current Section 63

[!NOTE]
Classroom terminology: Section 65B was used while explaining electronic evidence.

Current-law note I verified afterward: The Bharatiya Sakshya Adhiniyam, 2023 (BSA) came into force on 1 July 2024. Its Section 63 contains the current provision on admissibility of electronic records.

I am keeping the old 65B terminology in my learning history because that is what was discussed in class, but I do not want to incorrectly present it as the current section number.

Section 63 includes ideas such as:

regular use of the relevant computer/communication device,

information being supplied in the ordinary course of activity,

proper operation of the device or whether a malfunction affected accuracy,

identifying the electronic record and describing how it was produced,

device particulars,

certification by the persons specified by the law.

So my classroom explanation was conceptually pointing in the right direction, but it was not an exact five-rule legal checklist.

06 — Evidence Tampering: The Knife/Fingerprint Analogy

When I was tested on evidence integrity, the analogy that came naturally to me was:

Changing CCTV evidence is like trying to brush fingerprints off a murder weapon.

My point was not that the two situations are legally identical.

The analogy helped me think about integrity.

If somebody removes three seconds from a video before investigators receive it, I should no longer blindly treat that copy as unchanged.

Those three seconds might contain something important — or they might not.

The bigger issue is that the evidence has been altered.

Extra concept I learned after class — cryptographic hashes

This was not part of my instructor's Day 2 teaching. It was introduced during my follow-up discussion.

A cryptographic hash can act like a calculated digital fingerprint of a file.

Original CCTV file
        ↓
     SHA-256
        ↓
Fingerprint A

File changed
        ↓
     SHA-256
        ↓
Fingerprint B

If the hashes are different, the files are not byte-for-byte identical.

A hash by itself does not tell me who changed the file, what they removed or why they changed it.

For now, that is enough for me to know.

07 — The Bank Ransomware Scenario

The most memorable part of Day 2 was the ransomware example.

My instructor asked us to imagine a bank with customer information stored on its systems.

A malicious actor compromises the environment and interferes with the organization's data or systems.

The attacker may encrypt information or systems so that the organization cannot normally use them and then demand money.

The scenario also introduced another possibility:

The attacker may copy the customer data first and threaten to leak or sell it.

That changed how I thought about backups.

My first instinct could be:

“The bank has backups. Restore everything. Problem solved.”

But that only addresses one part of the incident.

flowchart TD
    A[Attacker gains unauthorized access] --> B{What does the attacker do?}
    B --> C[Encrypt / disrupt systems]
    B --> D[Copy data out]
    C --> E[Organization may lose availability]
    D --> F[Attacker possesses a copy of sensitive data]
    E --> G[Backup may help restore operations]
    F --> H[Backup cannot pull stolen copies back]

This became one of my strongest Day 2 lessons:

Recovery and incident resolution are not the same thing.

08 — The Question I Asked My Instructor

The ransomware story made me ask something immediately:

If the organization pays, how does it know the attacker will actually give the decryption key?

And even if a key is provided:

How does the organization know the attacker deleted every stolen copy of the customer data?

My instructor told me that I did not need to go that deep yet and that the immediate learning goal was simply to understand ransomware.

I am keeping that question in this portfolio because it shows where my thinking went.

I now understand why the question matters:

Paying money
    ≠
Proof that systems will recover

Receiving a decryption key
    ≠
Proof that stolen data was deleted

Restoring from backup
    ≠
Proof that the attack path was fixed

I am not trying to decide ransomware-payment policy after one class.

The lesson is simply that a ransomware incident creates technical, operational, legal and business questions at the same time.

09 — Encryption, Decryption and Exfiltration

I mixed these words up during my first explanation, so this correction is important enough to keep.

At first I thought the word “siphoning” meant converting data through encryption.

That was incorrect.

Here is how I now separate the terms:

Term

My simple understanding

Encryption

Transform readable data into ciphertext so it cannot normally be read without the required key/process.

Decryption

Convert encrypted ciphertext back into readable information using the required key/process.

Exfiltration

Copy or move data out of the environment where it belongs to another location without authorization.

The easiest way for me to remember exfiltration is:

EXFILTRATION = DATA GOING OUT.

For example:

Company database
      |
      | unauthorized copy
      ↓
==============================
   Company security boundary
==============================
      ↓
Attacker-controlled location

        = DATA EXFILTRATION

The original database can still exist inside the company.

Copying the information out is enough for exfiltration to have occurred.

And encryption does not need to happen for exfiltration to occur.

That distinction is now clear to me.

10 — Why a Backup Does Not End the Incident

I was asked this scenario:

A bank has perfect offline backups. An attacker steals five million customer records, encrypts the live servers and demands money. The bank restores the systems within two hours. Is the incident solved?

My answer was no.

My reasoning:

1. The attacker may still possess the customer data

Restoring my copy does not delete the attacker's copy.

2. The original entry path may still exist

If I only restore systems but never determine how the compromise happened, the weakness, stolen credential or other access path may remain.

3. Recovery does not answer the accountability questions

The organization still has to understand what happened, what information was affected, what obligations apply and what actions are required.

So I now think about ransomware recovery like this:

SYSTEM RESTORED
      ↓
Good — availability may be back
      ↓
But ask:

Was data stolen?
Was access removed?
Was the root cause fixed?
Was evidence preserved?
Who needs to be notified?
What controls need to change?

11 — Organizational Data Responsibility: What I Had Mixed Up

During class I connected organizational responsibility for customer data with Section 43A and the DPDP Act as though they were the same thing.

They are not the same thing.

[!WARNING]

Legal terminology correction

The Digital Personal Data Protection Act, 2023 (DPDP Act) is a separate Act. It is not another name for IT Act Section 43A.

The DPDP framework is being brought into force in phases.

Status note — checked 19 August 2026

The official commencement note says different provisions of the DPDP Act begin at different times. The provision in Section 44(2) that amends the IT Act by omitting Section 43A is scheduled for commencement 18 months after 13 November 2025.

So I should not write:

DPDP = Section 43A

Instead, at my current level I will remember:

IT Act, 2000
    └── Section 43A is part of the older IT Act data-protection framework

DPDP Act, 2023
    └── Separate personal-data-protection legislation
        with a phased commencement schedule

I am deliberately avoiding simplistic statements such as:

“A breach happens, therefore the company automatically gets fined ₹100 crore or ₹200 crore.”

Real regulatory consequences depend on the applicable law, the provision in force, the facts of the incident and the regulatory process.

12 — RansomLook: Seeing Ransomware as a Real-World Problem

My instructor also showed us RansomLook as a reference.

Instead of ransomware remaining only as a classroom word, the site gave me a way to see that ransomware groups, claimed victims and leak activity are tracked in the real world.

I am recording this carefully:

I was shown RansomLook as a classroom reference. I am not claiming that I learned ransomware investigation or threat-intelligence analysis from one demonstration.

That distinction matters to me because this portfolio should show what I genuinely learned — not inflate one exposure into a skill.

13 — The Authorization Principle Still Survives Day 2

I was given another scope scenario after the session:

I am authorized to assess Server A at a power company. I notice that Server B may be vulnerable. Because this is critical infrastructure, should I investigate Server B immediately “to protect the country”?

My answer was no.

The fact that the system is important does not automatically expand my authority.

My reasoning was:

I observe something concerning
        ↓
Server B is outside my written scope
        ↓
I do NOT investigate it further
        ↓
Document what I actually observed
        ↓
Report / escalate it
        ↓
Let the authorized owner decide the next action

There may be facts I do not know.

Maybe another team owns the system.

Maybe the issue is already known.

Maybe there is another investigation happening.

Maybe testing the system could create operational risk.

So Day 2 reinforced Day 1 instead of replacing it:

A serious vulnerability gives me a reason to report. It does not manufacture authorization.

14 — What I Thought vs What I Understand Now

What I initially thought / said

What I understand now

“Siphoning” means encrypting data.

Encryption changes data into ciphertext. Unauthorized copying/moving of data out is exfiltration.

Restoring a ransomware victim from backup basically solves the problem.

Backup may restore operations, but stolen data, attacker access and root cause can remain unresolved.

If the attacker asks for less money than a possible fine, the company will naturally pay.

Ransom payment is not a simple arithmetic decision and does not guarantee recovery or deletion of stolen data.

DPDP is basically Section 43A.

The DPDP Act, 2023 is separate legislation. The transition from the older Section 43A framework is subject to the statutory commencement schedule.

Section 65B is the current electronic-evidence section.

That is the familiar provision from the old Indian Evidence Act. Under the current Bharatiya Sakshya Adhiniyam, electronic-record admissibility is addressed in Section 63.

Electronic evidence is acceptable if I satisfy exactly five remembered points.

The concepts I remembered are useful, but the law contains specific conditions and certification requirements; my classroom five-point explanation is not a substitute for the actual provision.

Tampering with any source code is automatically illegal under Section 65.

Section 65 has specific conditions, including source code that is legally required to be kept or maintained.

If a system belongs to critical infrastructure, urgency might justify going outside scope.

Criticality increases responsibility; it does not erase authorization boundaries.

15 — How This Connects to My Systems-First Roadmap

My Linux/Bash roadmap is still paused at:

linux-fundamentals/
└── level-8-process-management/
    └── 8.1-process-observation/

I am not abandoning or restarting it.

GRC is giving me another layer that will eventually connect to the systems work.

For example:

flowchart LR
    A[Linux processes] --> B[Logs / system activity]
    B --> C[Incident evidence]
    C --> D[Integrity / preservation]
    D --> E[Incident response]
    E --> F[Risk / compliance / accountability]

Another connection:

Technical layer:
Who logged in?
What process ran?
What file changed?
What connection was created?

GRC / investigation layer:
Was the activity authorized?
What was the scope?
What information was affected?
What evidence proves what happened?
Who is responsible for responding?
What requirement applies?

This is starting to show me why learning the operating system first was not wasted time.

Technical evidence ultimately comes from real systems.

16 — What I Am NOT Claiming After Day 2

I want this portfolio to stay honest.

After two GRC sessions, I am not claiming that I can:

interpret Indian cyber law professionally,

perform digital forensics,

certify electronic evidence,

investigate ransomware incidents,

make ransomware-payment decisions,

conduct CII security assessments,

perform regulatory compliance audits.

What I can say is that I have started building the mental model required to learn those subjects properly.

I can now explain in my own words:

why critical infrastructure changes the impact of cyber risk,

what NCIIPC is broadly responsible for,

why electronic evidence needs context and reliability,

why evidence integrity matters,

what ransomware is at a beginner level,

why backup recovery does not automatically end an incident,

the difference between encryption, decryption and exfiltration,

why organizational data responsibility cannot be reduced to a single remembered fine,

why authorization and scope still apply even when a system is important.

17 — My Day 2 Incident Thinking Model

This is the simplest way I can represent today's learning:

flowchart TD
    A[Something suspicious happens] --> B[What system / data is affected?]
    B --> C[Was access authorized?]
    C --> D[Did data leave the environment?]
    D --> E[Was data encrypted, altered or made unavailable?]
    E --> F[What evidence exists?]
    F --> G[Can I establish where that evidence came from?]
    G --> H[Can operations be recovered?]
    H --> I[Has the attack path / root cause been addressed?]
    I --> J[What legal, regulatory or organizational response is required?]

Day 1 made me ask:

“Am I authorized?”

Day 2 added:

“What actually happened to the system and the data — and can I prove it?”

💭 Reflection

The ransomware example changed my thinking the most today.

Before this session, I could easily imagine cybersecurity recovery as:

Something broke → restore backup → continue working

Now I see why that is incomplete.

If an attacker stole information, restoring my own copy does not remove theirs.

If I restore the server without understanding how the attacker entered, I may only be restoring the environment for them to attack again.

If evidence was changed, I may lose confidence in what actually happened.

And if I am investigating any of these things, Day 1 still applies: I need authorization and scope.

So the bigger lesson I am carrying forward is:

Cybersecurity is not only about getting control of a machine back. It is also about understanding what happened, protecting the people/data affected, preserving evidence, fixing the cause and acting within the right authority.

📚 References I Used to Verify the Legal / Technical Corrections

These references are not a replacement for my classroom notes. I used them to avoid putting inaccurate section numbers or terminology into this portfolio.

Information Technology Act, 2000 — India Code: https://www.indiacode.nic.in/handle/123456789/18594

IT Act Section 43 — India Code: https://www.indiacode.nic.in/show-data?abv=CEN&actid=AC_CEN_45_76_00001_200021_1517807324077&orderno=48&orgactid=AC_CEN_45_76_00001_200021_1517807324077&sectionId=13057&sectionno=43&statehandle=123456789%2F1362

IT Act Section 65 — India Code: https://www.indiacode.nic.in/show-data?actid=AC_CEN_45_76_00001_200021_1517807324077&orderno=75

Bharatiya Sakshya Adhiniyam, 2023 — India Code: https://www.indiacode.nic.in/handle/123456789/20063

BSA Section 63 — Admissibility of Electronic Records: https://www.indiacode.nic.in/show-data?abv=CEN&actid=AC_CEN_5_23_00049_2023-47_1719292804654&orderno=63&orgactid=AC_CEN_5_23_00049_2023-47_1719292804654&statehandle=123456789%2F1362

Digital Personal Data Protection Act, 2023 — India Code: https://www.indiacode.nic.in/handle/123456789/22037

DPDP Rules / Enforcement Timeline — MeitY: https://www.meity.gov.in/documents/act-and-policies/digital-personal-data-protection-rules-2025-gDOxUjMtQWa

CERT-In: https://www.cert-in.org.in/

RansomLook: https://www.ransomlook.io/

➡️ Next

My instructor said the next session will begin introducing cybersecurity roles, specializations and the requirements for entering different roles.

I will keep that as the next coaching entry rather than pretending to know the role map in advance.

My separate Systems-First Linux roadmap remains paused at Level 8.1 — Process Observation and will resume independently.
