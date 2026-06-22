import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData maharashtraUg = CounsellingStateData(
  name: "Maharashtra",

  heroTitle: "Maharashtra NEET UG 2025 Counselling",

  heroSubtitle:
      "Commissioner, State CET Cell, Maharashtra",

  totalRounds: 4,

  icon: Icons.account_balance_outlined,

  rounds: const [
    "Round 1",
    "Round 2",
    "Round 3",
    "Stray Vacancy Round",
  ],

  documents: const [
    "NEET UG 2025 Admit Card",
    "NEET UG 2025 Scorecard",
    "SSC Marksheet",
    "HSC Marksheet",
    "Nationality Certificate",
    "Domicile Certificate",
    "Aadhaar Card",
    "Medical Fitness Certificate",
    "Caste Certificate",
    "Caste Validity Certificate",
    "Non Creamy Layer Certificate",
    "EWS Certificate",
    "Passport Size Photographs",
  ],

  fees: const CounsellingFees(
    applicationFee: "₹1,000 - ₹6,000",
    registrationFee: "Included",
    securityDeposit: "Not Applicable",
    isSecurityRefundable: false,
  ),

  introCards: const [
    IntroCardData(
      icon: Icons.language,
      iconColor: Colors.blue,
      prefix: "Register only at ",
      highlight: "www.mahacet.org",
      highlightColor: Color(0xFFFF6B35),
      isHighlightBold: true,
      suffix: " — no other mode",
    ),

    IntroCardData(
      icon: Icons.account_balance,
      iconColor: Colors.blueGrey,
      prefix: "Competent Authority: ",
      highlight: "Commissioner, State CET Cell, Mumbai",
      highlightColor: Colors.black87,
      isHighlightBold: true,
      suffix: "",
    ),
    IntroCardData(
      icon: Icons.lock_outline,
      iconColor: Colors.orange,
      prefix: "Once preference form is ",
      highlight: "submitted — irrevocable.",
      highlightColor: Colors.red,
      isHighlightBold: true,
      suffix: " No changes allowed.",
    ),
  ],

  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF), // Blue
      steps: [
        RoundStepData(text: "Online registration on mahacet.org"),
        RoundStepData(text: "Pay application fee (non-refundable)"),
        RoundStepData(text: "Upload required documents"),
        RoundStepData(text: "Physical Document Verification"),
        RoundStepData(text: "State Merit List published"),
        RoundStepData(text: "Fill online preference form (choices)"),
        RoundStepData(text: "Selection list declared"),
        RoundStepData(text: "Join allotted college by last date", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488), // Teal
      steps: [
        RoundStepData(text: "Eligible candidates fill fresh preferences"),
        RoundStepData(text: "Candidates who joined in R1 can also participate"),
        RoundStepData(text: "Selection list declared"),
        RoundStepData(text: "Join allotted college by last date", type: RoundStepType.warning),
        RoundStepData(text: "Candidates who filled SRF (Status Retention) in R1 eligible"),
      ],
    ),
    RoundProcessData(
      badgeText: "R3",
      title: "Round 3",
      themeColor: Color(0xFFEA580C), // Orange
      steps: [
        RoundStepData(text: "Fresh registration allowed for new candidates"),
        RoundStepData(text: "Combined Merit List (R1 + R3 registrants)"),
        RoundStepData(text: "Inter-se round for reserved vacancies"),
        RoundStepData(text: "Fill fresh preference form"),
        RoundStepData(text: "Selection list declared"),
        RoundStepData(text: "After cut-off — NO FEE REFUND", type: RoundStepType.error),
        RoundStepData(text: "Penalty applies for lapse of seat", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "SVR",
      title: "Stray Vacancy Round",
      themeColor: Color(0xFFDC2626), // Red
      steps: [
        RoundStepData(text: "Online SVR for Govt/Aided/Corp colleges"),
        RoundStepData(text: "Institute Level Round for Private colleges only"),
        RoundStepData(text: "Preferences from previous rounds used"),
        RoundStepData(text: "Joining mandatory if selected", type: RoundStepType.warning),
        RoundStepData(text: "Any AYUSH AIQ reverted seats added to state pool"),
      ],
    ),
  ],

  reRegistrationRules: const [
    ReRegistrationInfo(
      title: "Must re-register for R3:",
      themeColor: Color(0xFFDC2626), // Red
      icon: Icons.close,
      points: [
        "Allotted in R2 but did NOT report to college",
        "Resigned after joining (including SRF in R1)",
        "Admission cancelled for any reason up to R2",
      ],
    ),
    ReRegistrationInfo(
      title: "Need NOT re-register for R3:",
      themeColor: Color(0xFF16A34A), // Green
      icon: Icons.check,
      points: [
        "Registered for R1 but not allotted",
        "Joined R1/R2 and wants to upgrade college",
        "Already registered — participate with same login",
      ],
    ),
    ReRegistrationInfo(
      title: "Schedule Note:",
      themeColor: Color(0xFFD97706), // Orange
      icon: null,
      points: [
        "All dates to be announced on www.mahacet.org",
        "NEET UG 2025 result valid only for AY 2025-26",
        "Check schedule regularly — cut-off dates vary by council",
      ],
    ),
  ],

  seatDistributions: const [
    SeatDistributionInfo(
      title: "MBBS / BDS",
      themeColor: Color(0xFF1E40AF), // Blue
      distributionPoints: [
        "15% → AIQ via MCC/DGHS, New Delhi",
        "85% → State Quota (Maharashtra)",
      ],
      highlightBoxText: "GOI NOMINEES: 16 (MEDICAL), 3 (DENTAL)",
    ),
    SeatDistributionInfo(
      title: "BAMS / BHMS / BUMS",
      themeColor: Color(0xFF0D9488), // Teal
      distributionPoints: [
        "15% → AIQ via AACCC",
        "85% → State Quota (Maharashtra)",
      ],
      highlightBoxText: "GOI NOMINEES: 5 SEATS (AYURVED)",
    ),
    SeatDistributionInfo(
      title: "Private / Minority Colleges",
      themeColor: Color(0xFFEA580C), // Orange
      distributionPoints: [
        "85% State Quota (CAP Round)",
        "15% Institutional Quota (All India)",
      ],
      highlightBoxText: "25% CONSTITUTIONAL RESERVATION",
    ),
    SeatDistributionInfo(
      title: "BNYS / BPTh / BOTh / BASLP / BP&O",
      themeColor: Color(0xFF16A34A), // Green
      distributionPoints: [
        "100% State quota filled by CAP",
        "15% Inst. quota filled by institute",
      ],
      highlightBoxText: "SELECTION BASED ON NEET UG MERIT",
    ),
  ],

  alerts: const [
    AlertInfo(
      title: "Selection on website only — fake letters not valid",
      description: "",
      type: AlertType.critical,
    ),
    AlertInfo(
      title: "False documents = cancellation + criminal prosecution",
      description: "",
      type: AlertType.critical,
    ),
    AlertInfo(
      title: "Category claim after application = NOT entertained",
      description: "",
      type: AlertType.critical,
    ),
    AlertInfo(
      title: "Ragging = expulsion from college",
      description: "",
      type: AlertType.critical,
    ),
    AlertInfo(
      title: "Legal jurisdiction: Maharashtra courts only",
      description: "",
      type: AlertType.critical,
    ),
  ],

  notes: const [
    "Registration is available only through mahacet.org.",
    "Only Maharashtra domicile candidates are eligible for State Quota seats.",
    "Preference form once submitted cannot be modified.",
    "Category claim cannot be changed after registration.",
    "NEET UG qualification is mandatory.",
    "False documents may lead to admission cancellation.",
    "NEET UG 2025 score is valid only for AY 2025-26.",
    "OMS candidates are not eligible for State Quota seats.",
    "EWS certificate must be issued in Maharashtra State format.",
    "Caste validity certificate is mandatory for reserved category candidates.",
  ],

  steps: const [
    CounsellingStep(
      title: "Round 1 Registration",
      description:
          "Register online and upload required documents.",
    ),
    CounsellingStep(
      title: "Document Verification",
      description:
          "Physical verification at designated centres.",
    ),
    CounsellingStep(
      title: "Merit List Publication",
      description:
          "State merit list released by CET Cell.",
    ),
    CounsellingStep(
      title: "Choice Filling",
      description:
          "Fill and lock college/course preferences.",
    ),
    CounsellingStep(
      title: "Round 1 Allotment",
      description:
          "Seat allotment based on merit and choices.",
    ),
    CounsellingStep(
      title: "Round 2",
      description:
          "Fresh choice filling and seat upgradation.",
    ),
    CounsellingStep(
      title: "Round 3",
      description:
          "Fresh registration and vacancy filling.",
    ),
    CounsellingStep(
      title: "Stray Vacancy Round",
      description:
          "Final admission round for remaining seats.",
    ),
  ],

  eligibility: const [
    EligibilityCriteria(
      category: "Open / EWS",
      requirement:
          "50th percentile in NEET UG and 50% PCB marks.",
    ),
    EligibilityCriteria(
      category: "SC / ST / OBC",
      requirement:
          "40th percentile in NEET UG and 40% PCB marks.",
    ),
    EligibilityCriteria(
      category: "PwBD General",
      requirement:
          "45th percentile in NEET UG and 45% PCB marks.",
    ),
    EligibilityCriteria(
      category: "Age Limit",
      requirement:
          "Must be born on or before 31 December 2008.",
    ),
    EligibilityCriteria(
      category: "Nationality",
      requirement:
          "Indian citizen with Maharashtra domicile.",
    ),
  ],

  reservations: const [
    ReservationCategory(
      category: "SC",
      percentage: "13%",
      description: "Scheduled Caste",
    ),
    ReservationCategory(
      category: "ST",
      percentage: "7%",
      description: "Scheduled Tribe",
    ),
    ReservationCategory(
      category: "DT-A",
      percentage: "3%",
      description: "Vimukta Jati",
    ),
    ReservationCategory(
      category: "NT-B",
      percentage: "2.5%",
      description: "Nomadic Tribe B",
    ),
    ReservationCategory(
      category: "NT-C",
      percentage: "3.5%",
      description: "Nomadic Tribe C",
    ),
    ReservationCategory(
      category: "OBC / NT-D",
      percentage: "19%",
      description: "Other Backward Classes",
    ),
    ReservationCategory(
      category: "SEBC",
      percentage: "10%",
      description: "Socially & Educationally Backward Class",
    ),
    ReservationCategory(
      category: "EWS",
      percentage: "10%",
      description: "Economically Weaker Section",
    ),
    ReservationCategory(
      category: "Female",
      percentage: "30%",
      description: "Parallel Reservation",
    ),
    ReservationCategory(
      category: "PWD",
      percentage: "5%",
      description: "Persons with Disabilities",
    ),
    ReservationCategory(
      category: "Orphan",
      percentage: "1%",
      description: "Orphan Reservation",
    ),
    ReservationCategory(
      category: "Hilly Area",
      percentage: "3%",
      description: "MBBS Government Colleges",
    ),
  ],


  percentiles: const [
    PercentileData(
      percentile: "50th",
      category: "Open / EWS Category",
      description: "Min 50 percentile in PCB combined. Also 50% marks in PCB at HSC (i.e. 150/300)",
      themeColor: Color(0xFFF97316), // Orange
    ),
    PercentileData(
      percentile: "40th",
      category: "SC / ST / OBC / DT-A / NT / SEBC",
      description: "Min 40 percentile in PCB combined. Also 40% marks in PCB at HSC (i.e. 120/300)",
      themeColor: Color(0xFF22C55E), // Green
    ),
    PercentileData(
      percentile: "45th",
      category: "PwBD – General Category",
      description: "Min 45 percentile in PCB. Also 45% marks in PCB at HSC (135/300). SC/ST/OBC PwBD = 40th percentile",
      themeColor: Color(0xFF3B82F6), // Blue
    ),
  ],

  coreRequirements: const [
    CoreRequirementData(
      title: "Nationality & Domicile",
      icon: Icons.public,
      themeColor: Color(0xFF1E3A8A), // Dark blue
      rows: [
        RequirementRow(label: "Citizenship", value: "Indian National required"),
        RequirementRow(label: "Domicile", value: "Maharashtra domicile required"),
        RequirementRow(label: "OCI/NRI (State Quota)", value: "OCI before 04/03/2021 + MH domicile/10yrs"),
        RequirementRow(label: "NRI/OCI (Inst. Quota)", value: "All India basis — no domicile needed"),
        RequirementRow(label: "OMS candidates", value: "Inst. Quota only — not state quota"),
      ],
    ),
    CoreRequirementData(
      title: "Age & Date of Birth",
      icon: Icons.calendar_today,
      themeColor: Color(0xFF0D9488), // Teal
      rows: [
        RequirementRow(label: "Minimum age", value: "Born on or before 31 Dec 2008"),
        RequirementRow(label: "Upper age limit", value: "NO UPPER LIMIT", isValueHighlight: true, highlightColor: Color(0xFF22C55E)),
        RequirementRow(label: "Proof of DOB", value: "SSC/Birth Certificate"),
        RequirementRow(label: "Cut-off date", value: "Last date of Physical Doc Verification"),
      ],
    ),
    CoreRequirementData(
      title: "Qualifying Examination (HSC)",
      icon: Icons.school,
      themeColor: Color(0xFFEA580C), // Orange
      rows: [
        RequirementRow(label: "Board", value: "Maharashtra State Board (or equiv.)"),
        RequirementRow(label: "Location", value: "Institution in Maharashtra State"),
        RequirementRow(label: "Subjects required", value: "Eng, Physics, Chemistry, Biology"),
        RequirementRow(label: "MBBS/BDS/BAMS/BHMS/BUMS Open", value: "Min 50% in PCB at HSC"),
        RequirementRow(label: "Reserved categories", value: "Min 40% in PCB at HSC"),
        RequirementRow(label: "BPTh/BOTh/BNYS etc.", value: "Passing grade only — no PCB % bar"),
      ],
    ),
    CoreRequirementData(
      title: "SSC (10th) Requirement",
      icon: Icons.assignment,
      themeColor: Color(0xFF16A34A), // Green
      rows: [
        RequirementRow(label: "Location", value: "Institution in Maharashtra State"),
        RequirementRow(label: "SSC outside MH (2017 or earlier)", value: "Eligible if HSC from MH + MH domicile"),
        RequirementRow(label: "Govt MH employee children", value: "Exception — Annexure C allowed"),
        RequirementRow(label: "GOI employee children", value: "Exception — parent posted in MH"),
        RequirementRow(label: "Defence personnel children", value: "MH domicile + posted outside OK"),
      ],
    ),
    CoreRequirementData(
      title: "MUHS Affiliation & Medical Fitness",
      icon: Icons.medical_services,
      themeColor: Color(0xFFDC2626), // Red
      rows: [
        RequirementRow(label: "University affiliation", value: "MUHS Nashik approval required"),
        RequirementRow(label: "Medical fitness", value: "Certificate from Registered Doctor"),
        RequirementRow(label: "Format", value: "Annexure-H prescribed format"),
        RequirementRow(label: "Revaluation marks", value: "Accepted up to last doc verification date"),
      ],
    ),
    CoreRequirementData(
      title: "Special Course Requirements",
      icon: Icons.book,
      themeColor: Color(0xFF7C3AED), // Purple
      rows: [
        RequirementRow(label: "BUMS", value: "Urdu/Arabic/Persian in SSC/HSC OR study in 1st year"),
        RequirementRow(label: "BP&O", value: "PCB and/or Mathematics at 12th"),
        RequirementRow(label: "BASLP", value: "PCB and/or Math/Comp.Sci at 12th"),
        RequirementRow(label: "OCI eligibility", value: "Status before 04/03/2021 + MH 10+12th"),
        RequirementRow(label: "NEET validity", value: "AY 2025-26 ONLY — cannot carry forward"),
      ],
    ),
  ],

  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "NOT Eligible (State Quota):",
      content: "Candidates who passed both SSC AND HSC from outside Maharashtra AND are not domicile of Maharashtra — except those under Institutional Quota, Defence & MKB exemptions.",
      themeColor: Color(0xFFEF4444), // Red
      icon: Icons.block,
    ),
    EligibilityHighlightData(
      title: "Category Claim is FINAL:",
      content: "Category must be claimed in the original online application form. Change from Open → Reserved after submission = not allowed. No retrospective claims.",
      themeColor: Color(0xFF3B82F6), // Blue
      icon: Icons.description,
    ),
    EligibilityHighlightData(
      title: "Institutional Quota (All India):",
      content: "15% seats in unaided private/minority colleges for MBBS/BDS/BAMS/BHMS/BUMS open to all candidates including NRI/OCI/OMS on NEET UG merit.",
      themeColor: Color(0xFF10B981), // Green
      icon: Icons.check_circle,
    ),
  ],
  constitutionalReservation: const ConstitutionalReservationData(
    title: "Constitutional Reservation – State Quota Seats",
    subtitle: "* Percentages are approximate as per Maharashtra rules. SEBC subject to Supreme Court/High Court orders. EWS: 10% of state quota seats in Govt/Corp/Aided/Private (excl. Minority). Female reservation is parallel – operates across all categories.",
    rows: [
      ReservationBarRow(label: "SC (+ Converted to Buddhism)", abbreviation: "SC", percentage: 13, themeColor: Color(0xFF1E3A8A)), // Dark Blue
      ReservationBarRow(label: "ST (incl. outside spec. area)", abbreviation: "ST", percentage: 7, themeColor: Color(0xFF047857)), // Dark Green
      ReservationBarRow(label: "DT-A (Vimukta Jati)", abbreviation: "DT-A", percentage: 3, themeColor: Color(0xFFD97706)), // Orange-Brown
      ReservationBarRow(label: "NT-B (Nomadic Tribes)", abbreviation: "NT-B", percentage: 2.5, themeColor: Color(0xFF7C3AED)), // Purple
      ReservationBarRow(label: "NT-C (Nomadic Tribes)", abbreviation: "NT-C", percentage: 3.5, themeColor: Color(0xFF6D28D9)), // Deep Purple
      ReservationBarRow(label: "NT-D / OBC incl. SBC", abbreviation: "19%", percentage: 19, themeColor: Color(0xFFEA580C)), // Orange
      ReservationBarRow(label: "SEBC", abbreviation: "10%", percentage: 10, themeColor: Color(0xFFD97706)), // Orange-Brown
      ReservationBarRow(label: "EWS (10% of state quota)", abbreviation: "10%", percentage: 10, themeColor: Color(0xFF6D28D9)), // Deep Purple
      ReservationBarRow(label: "Female Reservation (Parallel)", abbreviation: "30%", percentage: 30, themeColor: Color(0xFFBE185D)), // Pink/Magenta
    ],
  ),

  reservationRules: const [
    RuleHighlightData(
      title: "Inter-se for Vacant Reserved Seats:",
      content: "Group I: SC + ST → Group II: DT-A + NT-B → Group III: NT-C + NT-D + OBC(SBC)\nIf still vacant: combined group inter-se → then Open merit list.\nSEBC & EWS vacant seats go to General category.",
      themeColor: Color(0xFFD97706), // Yellow/Orange
      icon: Icons.warning_amber_rounded,
    ),
    RuleHighlightData(
      title: "Ear-Marking Rule (Applicable to Constitutional Res.):",
      content: "If a reserved candidate is admitted on Open merit seat, one seat is ear-marked for next reserve candidate in that category from state merit. Not applicable for Specified Reservations.",
      themeColor: Color(0xFF3B82F6), // Blue
      icon: Icons.info_outline,
    ),
    RuleHighlightData(
      title: "Specified Reservations — Allotted FIRST:",
      content: "PWD, Defence, MKB, Hilly Area, Orphan — these specified reservation seats are filled before Open/Constitutional seats. Any unfilled specified seats revert to respective category.",
      themeColor: Color(0xFF10B981), // Green
      icon: Icons.check_box_outlined,
    ),
  ],

  detailedReservations: const [
    DetailedReservationCategory(
      title: "SC & Converted to Buddhism",
      description: "Caste Cert + Caste Validity Cert required. SC category from Maharashtra only. Constitutional reservation.",
      themeColor: Color(0xFF1E3A8A), // Blue
    ),
    DetailedReservationCategory(
      title: "ST (Scheduled Tribe)",
      description: "Including those living outside specified tribal area. Caste Cert + Validity required. Central list applies.",
      themeColor: Color(0xFF047857), // Green
    ),
    DetailedReservationCategory(
      title: "DT-A / NT-B / NT-C / NT-D / OBC (incl. SBC)",
      description: "Non-Creamy Layer Certificate valid upto 31/03/2026 mandatory. Creamy Layer = NOT eligible.",
      themeColor: Color(0xFFEA580C), // Orange
    ),
    DetailedReservationCategory(
      title: "EWS — Economically Weaker Section",
      description: "10% of state quota seats. Family income < ₹8 lakh/year. EWS cert in STATE GOVT FORMAT only. Valid for 2025-26.",
      themeColor: Color(0xFF7C3AED), // Purple
    ),
    DetailedReservationCategory(
      title: "Defence (D1/D2/D3) — Specified",
      description: "D1: Ex-serviceman. D2: Serving soldier. D3: Ward of deceased/disabled. MH Domicile required (D1/D2). See Annexure-C.",
      themeColor: Color(0xFF059669), // Green
    ),
    DetailedReservationCategory(
      title: "PWD — Person with Disability (5%)",
      description: "5% of intake. Certificate from authorized Disability Assessment Board only (2025). 5 disability types under RPwD Act 2016. Parallel constitutional reservation.",
      themeColor: Color(0xFFDC2626), // Red
    ),
    DetailedReservationCategory(
      title: "MKB — Maharashtra-Karnataka Border Area",
      description: "Disputed border area residents. Specified reservation. Vacant seats revert to Open. Disputed area cert + Mother tongue cert needed.",
      themeColor: Color(0xFFD97706), // Orange/Brown
    ),
    DetailedReservationCategory(
      title: "HA — Hilly Area (MBBS only — 3%)",
      description: "3% at Govt/Aided/Corp MBBS colleges only. Parent domicile cert + SSC/HSC from hilly area required. Specified reservation.",
      themeColor: Color(0xFF0891B2), // Cyan/Teal
    ),
    DetailedReservationCategory(
      title: "Female Reservation (30% — Parallel)",
      description: "30% seats reserved for female candidates across ALL categories including Open, SC, ST, OBC, EWS, Defence, MKB. If females unavailable → male candidates of same category.",
      themeColor: Color(0xFFBE185D), // Pink
    ),
    DetailedReservationCategory(
      title: "Orphan (1%) — Specified",
      description: "1% of available seats. Certificate from Women & Child Welfare Dept. Parallel constitutional reservation applies. See Annexure-V.",
      themeColor: Color(0xFF6D28D9), // Deep Purple
    ),
    DetailedReservationCategory(
      title: "Minority (Jain / Muslim / Christian / Gujarati / Sindhi / Hindi)",
      description: "Minority seats filled first by respective minority candidates from MH. Remaining by general candidates. School leaving cert or religious place cert needed.",
      themeColor: Color(0xFF0F766E), // Dark Teal
    ),
    DetailedReservationCategory(
      title: "NRI / OCI / OMS — Institutional Quota",
      description: "15% inst. quota in private/minority MBBS/BDS/BAMS/BHMS/BUMS — All India basis. NRI must claim in online form. No state quota eligibility for OMS.",
      themeColor: Color(0xFF0369A1), // Light Blue
    ),
  ],

  reservationCriticalAlert: const AlertInfo(
    title: "Critical — Certificate Rules:",
    description: "Caste Validity Certificate is mandatory at Physical Document Verification for SC/ST/DT-A/NT-B/NT-C/NT-D/SEBC/OBC. Non-Creamy Layer Cert valid upto 31/03/2026 must be produced at doc verification itself — late production = treated as Open category. EWS certificate must be in State Government Format ONLY (Annexure T) — Central Govt formats NOT acceptable.",
    type: AlertType.critical,
  ),

  applicationFees: const [
    ApplicationFeeData(
      title: "MBBS / BDS / BAMS / BHMS / BUMS",
      themeColor: Color(0xFF047857), // Green
      footnote: "Fee paid by Demand Draft / Net Banking at respective college",
      rows: [
        FeeRow(label: "State Quota seats only", amount: 1000),
        FeeRow(label: "Institutional Quota seats only", amount: 5000),
        FeeRow(label: "Both State + Institutional Quota", amount: 6000, isTotal: true),
      ],
    ),
    ApplicationFeeData(
      title: "BNYS / BPTH / BOTh / BASLP / BP&O",
      themeColor: Color(0xFFDC2626), // Red
      footnote: "Application fee is non-refundable in all cases. Bank charges borne by candidate.",
      rows: [
        FeeRow(label: "State Quota seats (All seats under CAP)", amount: 1000),
        FeeRow(label: "Institutional Quota (15% in private — institute fills)", amount: 1000),
        FeeRow(label: "Both State + Institutional Quota", amount: 1000, isTotal: true),
      ],
    ),
  ],

  feePreferenceAlert: const AlertInfo(
    title: "Preference Form Code System:",
    description: "College code is 4-digit + suffix. Suffix S = State Quota (85% seats in all Govt/Aided + Private). Suffix N = 15% Institutional Quota (Private/Minority only).\nNRI/ward of NRI: can fill only 'N' suffix — NOT 'S' suffix. Check FRA fee structure at www.mahafra.org before filling preferences.",
    type: AlertType.warning,
  ),

  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Refund Conditions (College Fees)",
      themeColor: Color(0xFF10B981), // Green
      icon: Icons.check_circle,
      points: [
        "Cancel before cut-off date → Refund after deducting ₹1,500 only",
        "Application form fee (₹1,000/5,000/6,000) → Non-Refundable in all cases",
        "Candidate expires or becomes invalid within 90 days → No deduction",
        "Refund made by Dean/Principal of college based on cancellation letter",
      ],
    ),
    FeeRefundPolicyData(
      title: "No Refund Conditions",
      themeColor: Color(0xFFEF4444), // Red
      icon: Icons.cancel,
      points: [
        "Cancellation on or after cut-off date → Zero refund of course fees",
        "Application form processing fee is always non-refundable",
        "Application form fee not refunded if candidate found ineligible",
        "Vacancy in subsequent year not entertained — unfilled seats lapse",
      ],
    ),
  ],

  penalties: const [
    PenaltyCardData(
      title: "MBBS / BDS — GOVT/AIDED/CORP COLLEGE",
      description: "Lapse of seat (not joining last round) OR cancellation after cut-off",
      penaltyAmount: "₹ 10,00,000/-",
      themeColor: Color(0xFFEA580C),
    ),
    PenaltyCardData(
      title: "MBBS — SOCIAL RESPONSIBILITY BOND",
      description: "Leaving India within 5 years of degree (Govt/Corp/Aided colleges, NEET UG 2022 onwards)",
      penaltyAmount: "₹ 10,00,000/-",
      themeColor: Color(0xFFEA580C),
    ),
    PenaltyCardData(
      title: "BAMS / BHMS / BUMS — AYUSH COURSES",
      description: "Resigning seat after cut-off date from Govt/Aided/Private Unaided college",
      penaltyAmount: "₹ 3,00,000/-",
      themeColor: Color(0xFFEA580C),
    ),
    PenaltyCardData(
      title: "BNYS / BPTH / BOTh / BASLP / BP&O",
      description: "Resigning after cut-off from Govt/Aided/Private (includes 1st year tuition — pay difference if already paid)",
      penaltyAmount: "₹ 2,00,000/-",
      themeColor: Color(0xFFEA580C),
    ),
    PenaltyCardData(
      title: "SOCIAL RESPONSIBILITY SERVICE",
      description: "1-year compulsory service in Govt/LSG/Defence after internship. Applicable to Govt/Corp college MBBS + scholarship recipients of private MBBS (NEET 2022+)",
      penaltyAmount: "1 Year Service",
      themeColor: Color(0xFF047857), // Green
    ),
    PenaltyCardData(
      title: "SCHOLARSHIP DEPARTMENTS",
      description: "SC → Social Justice Dept. ST → Tribal Welfare. OBC/DT/NT → OBC Bahujan Welfare. Open/EWS/SEBC → Medical Education Dept.",
      penaltyAmount: "Category-wise",
      themeColor: Color(0xFF3B82F6), // Blue
    ),
  ],

  feeDisqualificationAlert: const AlertInfo(
    title: "Disqualification:",
    description: "Candidate allotted a seat in previous years who vacated/abandoned it after availing it — MUHS Nashik shall decide eligibility. Submitting false/non-genuine documents = cancellation of admission + forfeiture of fees + expulsion + possible criminal prosecution. Name deleted from State Merit List = ineligible for further rounds.",
    type: AlertType.critical,
  ),

  contactInfo: const ContactInfo(
    officeName: "State CET Cell Maharashtra",
    address:
        "8th Floor, New Excelsior Building, A.K. Nayak Marg, Fort, Mumbai - 400001",
    phone: "+91-22-22016157",
    email: "cetcell@mahacet.org",
    website: "https://mahacet.org",
  ),

  numberedAlerts: const [
    NumberedAlertData(
      title: "Preference Form = Final & Irrevocable",
      content: "Once the online preference form is submitted (Submit Button clicked), NO changes are possible. Verify every preference carefully. Wrong allotment due to wrong preferences = candidate's sole responsibility.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
    NumberedAlertData(
      title: "Category Claim Freezes at Registration",
      content: "Constitutional category (SC/ST/OBC/EWS etc.) must be claimed in original online application form. Change from Open to Reserve after submission = STRAIGHT AWAY REJECTED. Claim is permanent.",
      severity: AlertSeverity.critical,
      number: 2,
    ),
    NumberedAlertData(
      title: "Cut-off Date = Zero Refund",
      content: "If candidate cancels admission on or after the cut-off date declared by respective council, NO FEE REFUND is possible. Penalty applies for lapsing a seat after cut-off.",
      severity: AlertSeverity.critical,
      number: 3,
    ),
    NumberedAlertData(
      title: "EWS Certificate Format is Strict",
      content: "EWS certificate must be in State Government Format ONLY (Annexure T). Central Govt format = NOT accepted. Certificate must be valid for AY 2025-26 (issued by competent authority).",
      severity: AlertSeverity.warning,
      number: 4,
    ),
    NumberedAlertData(
      title: "NCL Certificate Deadline = Doc Verification",
      content: "Non-Creamy Layer cert for DT-A/NT-B/NT-C/NT-D/SEBC/OBC must be produced at document verification only. NCL certificate submitted after doc verification = treated as Open category. No exceptions.",
      severity: AlertSeverity.warning,
      number: 5,
    ),
    NumberedAlertData(
      title: "Only Official Website is Valid",
      content: "Selection shown on www.mahacet.org only is valid. Selection letters from unknown persons/agencies or unofficial websites = NOT valid. Do not trust any other source.",
      severity: AlertSeverity.warning,
      number: 6,
    ),
    NumberedAlertData(
      title: "Caste Validity Certificate Mandatory",
      content: "For all backward class candidates (SC/ST/DT-A/NT/SEBC/OBC), Caste Validity Certificate must be submitted at physical document verification. Without CVC = treated as general/open category candidate.",
      severity: AlertSeverity.warning,
      number: 7,
    ),
    NumberedAlertData(
      title: "OMS Students — Inst. Quota Only",
      content: "Candidates who studied 10th AND 12th outside Maharashtra and are not MH domicile are OMS. OMS candidates are NOT eligible for state quota — only 15% Institutional Quota seats in private/minority colleges.",
      severity: AlertSeverity.note,
      number: 8,
    ),
    NumberedAlertData(
      title: "NEET Result Valid for 2025-26 Only",
      content: "NEET UG 2025 result is valid only for AY 2025-26. It cannot be carried forward to next academic year for any Health Science course including MBBS, BDS, BAMS, BHMS, BUMS etc.",
      severity: AlertSeverity.note,
      number: 9,
    ),
  ],

  detailedContactInfo: const DetailedContactInfo(
    officeName: "Commissioner, State CET Cell, Maharashtra State, Mumbai",
    address: "8th Floor, New Excelsior Building, A.K. Nayak Marg, Fort, Mumbai - 400 001",
    phone: "+91-22-22016157/59/53/34/19/28",
    email: "cetcell@mahacet.org",
    websiteUrl: "www.mahacet.org",
    feeStructureUrl: "www.mahafra.org",
  ),

  documentChecklist: const [
    DocumentChecklistItem(name: "NEET UG 2025 Admit Card", isMandatory: true),
    DocumentChecklistItem(name: "NEET UG 2025 Marksheet", isMandatory: true),
    DocumentChecklistItem(name: "Online Application Form (from mahacet.org)", isMandatory: true),
    DocumentChecklistItem(name: "Nationality Certificate / Indian Passport / SLC", isMandatory: true),
    DocumentChecklistItem(name: "Domicile Certificate (MH)", isMandatory: true),
    DocumentChecklistItem(name: "SSC (10th) Certificate (for DOB)", isMandatory: true),
    DocumentChecklistItem(name: "HSC (12th) Marksheet", isMandatory: true),
    DocumentChecklistItem(name: "Medical Fitness Certificate (Annexure-H)", isMandatory: true),
    DocumentChecklistItem(name: "Govt. Photo ID (Aadhaar/PAN/Passport)", isMandatory: true),
    DocumentChecklistItem(name: "Caste Certificate (if claiming reservation)", isMandatory: false),
    DocumentChecklistItem(name: "Caste Validity Certificate (mandatory for reserved)", isMandatory: false),
    DocumentChecklistItem(name: "NCL Certificate valid upto 31/03/2026", isMandatory: false),
    DocumentChecklistItem(name: "EWS Certificate — State Govt Format only", isMandatory: false),
    DocumentChecklistItem(name: "Defence Category Certificate (Annexure-C)", isMandatory: false),
    DocumentChecklistItem(name: "PWD Certificate from authorized Board (2025)", isMandatory: false),
    DocumentChecklistItem(name: "MKB / HA / Orphan Certificates (if applicable)", isMandatory: false),
    DocumentChecklistItem(name: "Minority status proof (SLC/religious place cert)", isMandatory: false),
    DocumentChecklistItem(name: "Transfer order of parent (Rule 4.7 / 4.8 cases)", isMandatory: false),
  ],

  abbreviations: const [
    AbbreviationData(abbreviation: "MCC", fullForm: "Medical Counselling Committee (MBBS/BDS AIQ)"),
    AbbreviationData(abbreviation: "AACCC", fullForm: "Ayush Admissions Central Counseling Committee"),
    AbbreviationData(abbreviation: "MUHS", fullForm: "Maharashtra University of Health Sciences, Nashik"),
    AbbreviationData(abbreviation: "NMC", fullForm: "National Medical Commission"),
    AbbreviationData(abbreviation: "NCISM", fullForm: "National Commission for Indian System of Medicine"),
    AbbreviationData(abbreviation: "NCH", fullForm: "National Commission for Homoeopathy"),
    AbbreviationData(abbreviation: "DGHS", fullForm: "Directorate General of Health Services (AIQ MBBS)"),
    AbbreviationData(abbreviation: "DMER", fullForm: "Directorate of Medical Education & Research, MH"),
    AbbreviationData(abbreviation: "CAP", fullForm: "Centralized Admission Process"),
    AbbreviationData(abbreviation: "AIQ", fullForm: "All India Quota (15% MBBS/BDS/AYUSH seats)"),
    AbbreviationData(abbreviation: "AIR", fullForm: "All India Rank (NEET UG 2025)"),
    AbbreviationData(abbreviation: "OMS", fullForm: "Outside Maharashtra State candidate"),
    AbbreviationData(abbreviation: "NRI", fullForm: "Non-Resident Indian (Inst. Quota)"),
    AbbreviationData(abbreviation: "OCI", fullForm: "Overseas Citizen of India"),
    AbbreviationData(abbreviation: "EWS", fullForm: "Economically Weaker Section (10% state quota)"),
    AbbreviationData(abbreviation: "SEBC", fullForm: "Socially & Educationally Backward Classes"),
    AbbreviationData(abbreviation: "MKB", fullForm: "Maharashtra-Karnataka Disputed Border Area"),
    AbbreviationData(abbreviation: "HA", fullForm: "Hilly Area Reservation (MBBS only — 3%)"),
    AbbreviationData(abbreviation: "PWD", fullForm: "Person With Disability (5% specified reservation)"),
    AbbreviationData(abbreviation: "SRF", fullForm: "Status Retention Form (retain seat across rounds)"),
    AbbreviationData(abbreviation: "SVR", fullForm: "Stray Vacancy Round"),
    AbbreviationData(abbreviation: "CVC", fullForm: "Caste/Tribe Validity Certificate"),
    AbbreviationData(abbreviation: "NCL", fullForm: "Non-Creamy Layer Certificate"),
    AbbreviationData(abbreviation: "BNYS", fullForm: "Bachelor of Naturopathy & Yogic Sciences"),
    AbbreviationData(abbreviation: "BASLP", fullForm: "Bachelor of Audiology & Speech-Language Pathology"),
  ]
);