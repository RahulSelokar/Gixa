import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData mccAiqUg = CounsellingStateData(
  name: "MCC AIQ",
  heroTitle: "MCC AIQ UG Counselling",
  heroSubtitle: "All India Quota — MBBS & BDS seats",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Round 3", "Stray Round"],
  
  alerts: const [
    AlertInfo(
      title: "Choices once LOCKED cannot be changed — not even by MCC",
      description: "",
      type: AlertType.critical,
    ),
    AlertInfo(
      title: "Do NOT share NTA credentials or OTP with anyone",
      description: "",
      type: AlertType.critical,
    ),
    AlertInfo(
      title: "R3 joining is PERMANENT — no exit allowed",
      description: "",
      type: AlertType.critical,
    ),
    AlertInfo(
      title: "AFMC: MCC only registers — AFMC allots independently",
      description: "",
      type: AlertType.critical,
    ),
    AlertInfo(
      title: "Court cases must be in Delhi jurisdiction only",
      description: "",
      type: AlertType.critical,
    ),
  ],
  documents: const [
    "MCC Allotment Letter",
    "NTA Admit Card",
    "NTA Result / Rank Letter",
    "Class 10 Certificate + Marksheet",
    "Class 10+2 Certificate + Marksheet",
    "Date of Birth Certificate",
    "8 Passport-size Photographs",
    "Photo ID (Aadhaar/PAN/Passport)",
    "SC/ST Certificate (if applicable)",
    "OBC-NCL Central List Certificate",
    "EWS Certificate (if applicable)",
    "PwD Certificate (NMC-approved)",
  ],
  fees: const CounsellingFees(applicationFee: "", registrationFee: "", securityDeposit: "", isSecurityRefundable: false),
  notes: const [],
  steps: const [],

  // 1. Overview (Timeline & Basic Info)
  introCards: const [
    IntroCardData(
      icon: Icons.description,
      iconColor: Colors.blue,
      prefix: "Qualify NEET-UG - Get Rank Letter from ",
      highlight: "NTA portal",
      highlightColor: Color(0xFFFF6B35),
      isHighlightBold: true,
      suffix: "",
    ),
    // IntroCardData(
    //   icon: Icons.mobile_friendly,
    //   iconColor: Colors.green,
    //   prefix: "Download ",
    //   highlight: "Sandes App",
    //   highlightColor: Color(0xFF10B981),
    //   isHighlightBold: true,
    //   suffix: " on NTA-registered mobile for OTP",
    // ),
    IntroCardData(
      icon: Icons.vpn_key,
      iconColor: Colors.orange,
      prefix: "Keep ",
      highlight: "NTA Roll No., Reg. No. & Password",
      highlightColor: Color(0xFFF59E0B),
      isHighlightBold: true,
      suffix: " ready",
    ),
    IntroCardData(
      icon: Icons.account_balance,
      iconColor: Colors.teal,
      prefix: "Keep bank account/card ",
      highlight: "ACTIVE",
      highlightColor: Color(0xFF0D9488),
      isHighlightBold: true,
      suffix: " for security refund",
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1 - First Allotment",
      themeColor: Color(0xFF2563EB), // Blue
      steps: [
        RoundStepData(text: "Register on mcc.nic.in (NTA email/mobile)"),
        RoundStepData(text: "Pay Reg. Fee + Security Deposit"),
        RoundStepData(text: "Fill unlimited choices in preference order"),
        RoundStepData(text: "Lock choices before deadline"),
        RoundStepData(text: "Allotment result published"),
        RoundStepData(text: "If allotted → Report physically to college"),
        RoundStepData(text: "Choose upgrade willingness (Yes/No)"),
        RoundStepData(text: "Free Exit option available (no penalty)"),
        RoundStepData(text: "If not allotted → eligible for R2 directly"),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2 - Second Allotment",
      themeColor: Color(0xFF0D9488), // Teal
      steps: [
        RoundStepData(text: "R1 unallotted → no fresh registration needed"),
        RoundStepData(text: "New candidates → fresh registration + full fees"),
        RoundStepData(text: "Fill FRESH CHOICES (R1 choices = null)"),
        RoundStepData(text: "Lock choices before deadline"),
        RoundStepData(text: "Allotment result published"),
        RoundStepData(text: "If upgraded → get R1 relieving → join R2"),
        RoundStepData(text: "Choose upgrade willingness to R3"),
        RoundStepData(text: "Allotted but not joined → FORFEITURE", type: RoundStepType.error),
      ],
    ),
    RoundProcessData(
      badgeText: "R3",
      title: "Round 3 - Mop-Up / Final Upgrade",
      themeColor: Color(0xFFD97706), // Amber/Orange
      steps: [
        RoundStepData(text: "R1/R2 unallotted → directly eligible"),
        RoundStepData(text: "New/resigned → fresh reg + full fees"),
        RoundStepData(text: "Fill FRESH CHOICES (R2 choices = null)"),
        RoundStepData(text: "Vacant R2 seats form the seat matrix"),
        RoundStepData(text: "Category conversion happens in R3"),
        RoundStepData(text: "If upgraded → get R2 relieving → join R3"),
        RoundStepData(text: "Once JOINED → FINAL. Cannot resign.", type: RoundStepType.warning),
        RoundStepData(text: "Allotted not joined → Forfeit + ELIMINATED", type: RoundStepType.error),
      ],
    ),
    RoundProcessData(
      badgeText: "SV",
      title: "Stray Vacancy - Last Opportunity",
      themeColor: Color(0xFFDC2626), // Red
      steps: [
        RoundStepData(text: "Fresh Registration for ALL candidates"),
        RoundStepData(text: "Centre-State data shared → already allotted = ELIMINATED", type: RoundStepType.warning),
        RoundStepData(text: "Only R3 vacant seats available"),
        RoundStepData(text: "Seat holders NOT eligible", type: RoundStepType.error),
        RoundStepData(text: "R3 allotted + not reported → NOT eligible", type: RoundStepType.error),
        RoundStepData(text: "If allotted → MUST join", type: RoundStepType.warning),
        RoundStepData(text: "Not joining → Forfeit, no more rounds", type: RoundStepType.error),
      ],
    ),
  ],

  // 2. Eligibility
  percentiles: const [
    PercentileData(
      percentile: "50%",
      category: "UR / General / EWS",
      description: "Min. aggregate in Physics + Chemistry + Biology/Biotech. Must pass each subject individually. English compulsory.",
      themeColor: Color(0xFF3B82F6),
    ),
    PercentileData(
      percentile: "40%",
      category: "SC / ST / OBC-NCL / PwD",
      description: "Min. aggregate in Physics + Chemistry + Biology/Biotech. Must pass each subject individually. English compulsory.",
      themeColor: Color(0xFF22C55E),
    ),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "15% ALL INDIA QUOTA\n(Govt. Medical/Dental)",
      icon: Icons.account_balance,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Domicile", value: "FREE"),
        RequirementRow(label: "Eligibility", value: "Any NEET-UG qualified"),
        RequirementRow(label: "Reservation", value: "SC 15% ST 7.5% OBC 27% EWS 10% PwD 5%"),
      ],
    ),
    CoreRequirementData(
      title: "100% DEEMED UNIVERSITIES",
      icon: Icons.school,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Domicile", value: "FREE"),
        RequirementRow(label: "Eligibility", value: "Any NEET-UG qualified"),
        RequirementRow(label: "Reservation", value: "NONE (check Minority seats)"),
      ],
    ),
    CoreRequirementData(
      title: "100% ALL AIIMS",
      icon: Icons.local_hospital,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Domicile", value: "FREE"),
        RequirementRow(label: "Eligibility", value: "Any NEET-UG qualified"),
        RequirementRow(label: "Reservation", value: "SC 15% ST 7.5% OBC 27% EWS 10% PwD 5%"),
      ],
    ),
    CoreRequirementData(
      title: "JIPMER (Open + State Quota)",
      icon: Icons.health_and_safety,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Open seats", value: "FREE"),
        RequirementRow(label: "State Quota", value: "Puducherry domicile"),
        RequirementRow(label: "Reservation", value: "SC 15% ST 7.5% OBC 27% EWS 10% PwD 5%"),
      ],
    ),
    CoreRequirementData(
      title: "DELHI UNIVERSITY\n(LHMC/UCMS/MAMC/MAIDS)",
      icon: Icons.domain,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "15% AIQ", value: "FREE"),
        RequirementRow(label: "85% State Quota", value: "Class 11-12 in NCT Delhi"),
        RequirementRow(label: "CW Seats", value: "State Quota only — verify with DU"),
      ],
    ),
    CoreRequirementData(
      title: "AMU (Open + Internal)",
      icon: Icons.menu_book,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Open seats", value: "FREE · PwD 5% only"),
        RequirementRow(label: "Internal", value: "AMU students only"),
        RequirementRow(label: "SC/ST/OBC", value: "No reservation in Open"),
      ],
    ),
    CoreRequirementData(
      title: "BHU (100% Open)",
      icon: Icons.import_contacts,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Domicile", value: "FREE"),
        RequirementRow(label: "Eligibility", value: "Any NEET-UG qualified"),
        RequirementRow(label: "Reservation", value: "SC 15% ST 7.5% OBC 27% EWS 10% PwD 5%"),
      ],
    ),
    CoreRequirementData(
      title: "ESIC — IP Quota",
      icon: Icons.shield,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Domicile", value: "FREE"),
        RequirementRow(label: "Special", value: "ESIC IP Certificate needed"),
        RequirementRow(label: "Reservation", value: "SC 15% ST 7.5% OBC 27% EWS 10% PwD 5%"),
      ],
    ),
    CoreRequirementData(
      title: "VMMC/SJH · ABVIMS/RML\n(Central Institutes)",
      icon: Icons.apartment,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "15% AIQ", value: "FREE"),
        RequirementRow(label: "85% State Quota", value: "Class 11-12 in NCT Delhi"),
        RequirementRow(label: "CW Seats", value: "State only — 5% horizontal"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "CATEGORY CONVERSION IN ROUND 3",
      content: "Occurs after exhaustion of the original category:",
      tags: [
        "ST(PwD) → ST",
        "SC(PwD) → SC",
        "UR(PwD) → UR",
        "OBC(PwD) → OBC",
        "ST → SC",
        "SC → UR",
        "EWS → UR",
        "NRI / Min. → UR",
        "ST(CW) → ST",
        "SC(CW) → SC",
        "UR(CW) → UR",
        "OBC(CW) → OBC",
      ],
      icon: Icons.swap_horiz,
      themeColor: Color(0xFF6B7280),
    ),
    EligibilityHighlightData(
      title: "OCI Cardholder Rule (SC Order 03.02.2023)",
      content: "OCI cardholders who obtained OCI status before 04.03.2021 are treated at par with Indian citizens — eligible for UR seats AND NRI seats in all MCC-conducted counsellings.",
      icon: Icons.public,
      themeColor: Color(0xFF3B82F6),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "All Seats Handled by MCC",
    subtitle: "15% AIQ / Central Institutes / AIIMS / JIPMER",
    rows: [
      ReservationBarRow(label: "OBC-NCL", abbreviation: "OBC", percentage: 27, themeColor: Color(0xFF3B82F6)), // Blue
      ReservationBarRow(label: "EWS", abbreviation: "EWS", percentage: 10, themeColor: Color(0xFFF59E0B)), // Amber
      ReservationBarRow(label: "SC", abbreviation: "SC", percentage: 15, themeColor: Color(0xFFEF4444)), // Red
      ReservationBarRow(label: "ST", abbreviation: "ST", percentage: 7.5, themeColor: Color(0xFF10B981)), // Green
      ReservationBarRow(label: "PwD (Horiz.)", abbreviation: "PwD", percentage: 5, themeColor: Color(0xFF22C55E)), // Green
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "AIQ / AIIMS / BHU / JIPMER / ESIC",
      content: "Reservation policies strictly apply to these institutions as per central guidelines. Horizontal reservation (5%) applied across all categories for PwD.",
      themeColor: Color(0xFF3B82F6),
      icon: Icons.gavel,
    ),
    RuleHighlightData(
      title: "Deemed Universities",
      content: "Deemed Universities have NO reservation. Check minority status for specific institution quotas.",
      themeColor: Color(0xFFEF4444),
      icon: Icons.warning_rounded,
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "New Delhi",
      description: "VMMC & Safdarjung Hospital (All except Visual & Intellectual)\nABVIMS & RML Hospital (All except ENT)\nLady Hardinge Medical College (All disabilities)",
      themeColor: Color(0xFF6B7280),
    ),
    DetailedReservationCategory(
      title: "Kolkata",
      description: "IPGMER (All disabilities)",
      themeColor: Color(0xFF6B7280),
    ),
    DetailedReservationCategory(
      title: "Chennai",
      description: "Madras Medical College (All disabilities)",
      themeColor: Color(0xFF6B7280),
    ),
    DetailedReservationCategory(
      title: "Mumbai",
      description: "Grant Govt. Medical College (All disabilities)\nAIPMR (Locomotor only)",
      themeColor: Color(0xFF6B7280),
    ),
    DetailedReservationCategory(
      title: "Varanasi",
      description: "IMS, BHU (All except Intellectual)",
      themeColor: Color(0xFF6B7280),
    ),
    DetailedReservationCategory(
      title: "Nagpur",
      description: "AIIMS Nagpur (All disabilities)",
      themeColor: Color(0xFF6B7280),
    ),
    DetailedReservationCategory(
      title: "Jaipur",
      description: "SMS Medical College (All except some seats)",
      themeColor: Color(0xFF6B7280),
    ),
    DetailedReservationCategory(
      title: "Goa",
      description: "Goa Medical College (All except Speech)",
      themeColor: Color(0xFF6B7280),
    ),
    DetailedReservationCategory(
      title: "Mysuru",
      description: "AISH (Speech & Hearing only)",
      themeColor: Color(0xFF6B7280),
    ),
  ],

  // 4. CAP Rounds & Fees
  applicationFees: const [
    ApplicationFeeData(
      title: "AIQ / AIIMS / JIPMER / CENTRAL UNIV / ESIC / B.SC NURSING",
      themeColor: Color(0xFF0D9488), // Teal
      rows: [
        FeeRow(label: "UR / EWS — Registration Fee", amount: 1000),
        FeeRow(label: "UR / EWS — Security Deposit", amount: 10000),
        FeeRow(label: "UR / EWS Total", amount: 11000, isTotal: true),
        FeeRow(label: "SC/ST/OBC/PwD — Reg. Fee", amount: 500),
        FeeRow(label: "SC/ST/OBC/PwD — Security", amount: 5000),
        FeeRow(label: "SC/ST/OBC/PwD Total", amount: 5500, isTotal: true),
      ],
    ),
    ApplicationFeeData(
      title: "DEEMED UNIVERSITIES (ALL CATEGORIES)",
      themeColor: Color(0xFF991B1B), // Dark Red
      footnote: "Registration fee is NON-REFUNDABLE in all cases.",
      rows: [
        FeeRow(label: "Registration Fee (Non-Refundable)", amount: 5000),
        FeeRow(label: "Security Deposit (Refundable)", amount: 200000),
        FeeRow(label: "Total to Pay at Registration", amount: 205000, isTotal: true),
      ],
    ),
  ],
  feePreferenceAlert: const AlertInfo(
    title: "Rule:",
    description: "If applying for both Govt. and Deemed seats, pay ONLY the Deemed fee (higher amount). No double payment. Security deposit goes ONLY back to the same account/card used — keep it active until refund is received.",
    type: AlertType.warning,
  ),
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit IS Refunded When...",
      themeColor: Color(0xFF059669), // Green
      icon: Icons.check_circle,
      points: [
        "Did not get any seat in all 4 rounds",
        "Free exit taken from Round 1 (voluntary, no allotment needed)",
        "Allotted but not joined in Round 1 (free exit option)",
        "Refund auto-initiated after all rounds complete — no request needed",
        "Timeline: Within 15 working days of MCC notification, max 30 days",
      ],
    ),
    FeeRefundPolicyData(
      title: "Security Deposit is FORFEITED When...",
      themeColor: Color(0xFFDC2626), // Red
      icon: Icons.cancel,
      points: [
        "Allotted in Round 2 or later and did NOT join",
        "Allotted in Stray Vacancy Round and did NOT join",
        "Did not report after Round 3 allotment",
        "Wrong information furnished → admission cancelled",
        "Failed to produce original documents at time of joining",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "REFUND ACCOUNT",
      description: "Goes ONLY to original payment source. No transfers allowed.",
      penaltyAmount: "Original Acct Only",
      themeColor: Color(0xFFD97706),
    ),
    PenaltyCardData(
      title: "NRI ACCOUNTS",
      description: "Cannot pay from NRI a/c. Transfer to NRO first. Refund → NRO only.",
      penaltyAmount: "NRO Account",
      themeColor: Color(0xFFD97706),
    ),
    PenaltyCardData(
      title: "INTEREST",
      description: "MCC pays ZERO interest on any security deposit held.",
      penaltyAmount: "0% Interest",
      themeColor: Color(0xFFD97706),
    ),
    PenaltyCardData(
      title: "CHARGEBACK",
      description: "DO NOT initiate bank chargeback — blocks MCC from refunding you indefinitely.",
      penaltyAmount: "DO NOT DO IT",
      themeColor: Color(0xFFDC2626),
    ),
    PenaltyCardData(
      title: "DUPLICATE PAYMENT",
      description: "Excess refunded after 10 days; minus 50% of reg fee or ₹500 (whichever less).",
      penaltyAmount: "Partial Refund",
      themeColor: Color(0xFFD97706),
    ),
    PenaltyCardData(
      title: "FINANCIAL CUSTODIAN",
      description: "HLL Lifecare Ltd - financemcc@lifecarehll.com - 1800-102-7637",
      penaltyAmount: "HLL Lifecare",
      themeColor: Color(0xFF2563EB),
    ),
  ],

  // 5. Alerts & Quick Ref
  numberedAlerts: const [
    NumberedAlertData(
      title: "Choice Locking is Final.",
      content: "Choices once locked cannot be changed under any circumstances — not even by MCC. Review every choice meticulously before locking.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
    NumberedAlertData(
      title: "Never share credentials.",
      content: "Do not share your NTA Roll No., Password or OTP with anyone — agents, friends, or relatives. Misuse leads to wrong allotment.",
      severity: AlertSeverity.critical,
      number: 2,
    ),
    NumberedAlertData(
      title: "Round 3 is Permanent.",
      content: "Once you join a Round 3 seat, you absolutely CANNOT resign or upgrade. Be 100% sure before joining R3.",
      severity: AlertSeverity.critical,
      number: 3,
    ),
    NumberedAlertData(
      title: "Deemed fees can be extreme.",
      content: "Confirm fee structure directly with the college before locking Deemed choices. MCC takes NO responsibility for fee disputes.",
      severity: AlertSeverity.critical,
      number: 4,
    ),
    NumberedAlertData(
      title: "No bank chargebacks.",
      content: "Initiating a chargeback through your bank will prevent MCC from refunding your security deposit — causing indefinite delays.",
      severity: AlertSeverity.critical,
      number: 5,
    ),
    NumberedAlertData(
      title: "OBC = Central List NCL only.",
      content: "State OBC lists are NOT accepted. Certificate must specify Non-Creamy Layer (NCL) status from Central OBC List.",
      severity: AlertSeverity.critical,
      number: 6,
    ),
    NumberedAlertData(
      title: "Wrong category = cancellation.",
      content: "If wrong domicile or category is found at any stage — candidature is cancelled and security deposit is forfeited immediately.",
      severity: AlertSeverity.critical,
      number: 7,
    ),
    NumberedAlertData(
      title: "AFMC has medical standards.",
      content: "Admissions have been cancelled for not meeting AFMC-specific medical eligibility. Verify from AFMC website BEFORE registering on MCC.",
      severity: AlertSeverity.critical,
      number: 8,
    ),
    NumberedAlertData(
      title: "Free Exit vs Upgrade.",
      content: "To RETAIN R1 seat while attempting R2 upgrade, you MUST physically report at R1 college and give willingness — just exiting won't save the seat.",
      severity: AlertSeverity.warning,
      number: 9,
    ),
  ],
  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Relieving letter from previous college is mandatory before joining upgraded college.",
      "Even same-college category upgrade (e.g. SC→UR) needs fresh relieving + new admission letter.",
      "Regional language certificates need attested English/Hindi translation — some states accept English only.",
      "Name discrepancies across documents require an affidavit proving all belong to same person.",
      "Sessions are IP-tracked — if internet drops, session expires. Use stable laptop connection.",
      "MCC sends NO individual notifications. Bookmark mcc.nic.in and check daily.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.bar_chart,
      title: "STRATEGY",
      description: "Make a rank-vs-college spreadsheet using previous year opening/closing ranks before choice filling.",
      themeColor: Color(0xFF10B981), // Emerald
    ),
    // StrategyCardData(
    //   icon: Icons.phone_android,
    //   title: "SANDES APP",
    //   description: "Download Sandes App before registration opens. MCC OTPs come only through this government app.",
    //   themeColor: Color(0xFF3B82F6), // Blue
    // ),
    StrategyCardData(
      icon: Icons.description,
      title: "DOCUMENTS",
      description: "Scan and keep PDF copies of ALL documents ready before registration opens — don't scramble last minute.",
      themeColor: Color(0xFFF59E0B), // Amber
    ),
    StrategyCardData(
      icon: Icons.account_balance,
      title: "STATE+CENTRAL",
      description: "Plan timelines if appearing in both AIQ and State counsellings — data is shared after R3.",
      themeColor: Color(0xFFEAB308), // Yellow
    ),
    StrategyCardData(
      icon: Icons.account_balance_wallet,
      title: "BANK ACCOUNT",
      description: "Keep payment card/account ACTIVE till refund is received — closed accounts cause long delays.",
      themeColor: Color(0xFF14B8A6), // Teal
    ),
  ],
);
