import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData pondicherryPg = CounsellingStateData(
  name: "Pondicherry PG",
  heroTitle: "Puducherry NEET PG Counselling",
  heroSubtitle: "Centralised Admission Committee (CENTAC)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "Stray Vacancy"],
  documents: const [
    "NEET PG Admit Card & Scorecard",
    "MBBS Degree Certificate / Provisional Certificate",
    "Internship Completion Certificate",
    "State/National Medical Council Registration",
    "Residence / Domicile Certificate (for Govt Quota)",
    "Community Certificate (if applicable)",
    "Christian/Telugu/Malayalam Minority Certificate (if applicable)",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 1,500 to ₹ 3,000",
    registrationFee: "Included",
    securityDeposit: "₹ 25,000 to ₹ 2,00,000",
    isSecurityRefundable: true,
  ),
  notes: const [],
  steps: const [],

  introCards: const [
    IntroCardData(
      icon: Icons.language,
      prefix: "Apply online at ",
      highlight: "centacpuducherry.in",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.account_balance,
      iconColor: Colors.orange,
      prefix: "Open state for ",
      highlight: "Management & NRI Quotas",
      highlightColor: Color(0xFFD97706),
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Online Registration & Application Submission"),
        RoundStepData(text: "Publication of Draft Merit List (Raise objections if any)"),
        RoundStepData(text: "Publication of Final Merit List"),
        RoundStepData(text: "Course Preferences / Choice Filling"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Download Allotment Order & Report to College", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Payment of Security Deposit (Mandatory)"),
        RoundStepData(text: "Fresh Choice Filling"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Report to allotted college"),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "291", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/OBC/MBC", percentile: "40th", description: "257", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Quota Eligibility",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Govt Quota Seats", value: "Only UT of Puducherry Residents"),
        RequirementRow(label: "Management Quota Seats", value: "Open to All India Candidates"),
        RequirementRow(label: "NRI Quota Seats", value: "NRI / NRI Sponsored Candidates"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "Minority Quotas",
      content: "Puducherry has several private medical colleges offering Linguistic (Telugu/Malayalam) and Religious (Christian) minority quotas. You must upload the relevant proof during registration.",
      icon: Icons.groups,
      themeColor: Color(0xFF10B981),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Vertical Reservation",
    subtitle: "Govt Quota Seats (Puducherry Residents)",
    rows: [
      ReservationBarRow(label: "General (UR)", abbreviation: "UR", percentage: 50.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "OBC", abbreviation: "OBC", percentage: 11.0, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "MBC", abbreviation: "MBC", percentage: 18.0, themeColor: Color(0xFF0EA5E9)),
      ReservationBarRow(label: "SC", abbreviation: "SC", percentage: 16.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "EBC", abbreviation: "EBC", percentage: 2.0, themeColor: Color(0xFF10B981)),
      ReservationBarRow(label: "BCM", abbreviation: "BCM", percentage: 2.0, themeColor: Color(0xFF8B5CF6)),
      ReservationBarRow(label: "ST", abbreviation: "ST", percentage: 1.0, themeColor: Color(0xFFF59E0B)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "Horizontal Reservation",
      content: "Regional allocation applies (Puducherry, Karaikal, Mahe, Yanam) based on residence.",
      icon: Icons.map,
      themeColor: Color(0xFFD97706),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "Management Seats",
      description: "Management seats in private medical colleges are completely unreserved. Merit is the only criterion.",
      themeColor: Color(0xFF8B5CF6),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "Application Fee",
      rows: [
        FeeRow(label: "Govt Quota (UR/OBC)", amount: 1500),
        FeeRow(label: "Govt Quota (SC/ST)", amount: 750),
        FeeRow(label: "Management Quota (All)", amount: 3000),
        FeeRow(label: "NRI Quota", amount: 5000),
      ],
      footnote: "Non-refundable application processing fee.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit (Refundable)",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Government Colleges: ₹ 25,000",
        "Private Medical Colleges (Management): ₹ 2,00,000",
        "If an allotted seat in R2/Mop-Up is not joined, the deposit is forfeited.",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "DEPOSIT FORFEITURE",
      description: "If a seat is allotted in Round 2 but the candidate fails to join the allotted college.",
      penaltyAmount: "Full Deposit",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Dual Merit Lists: CENTAC publishes separate merit lists for Govt Quota, Management Quota, and NRI Quota. Ensure your name is on the correct list.",
      "Round 2 Security: You must pay the security deposit to participate in Round 2 choice filling. If you don't, you cannot fill choices.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.business,
      title: "PRIVATE COLLEGES",
      description: "Since Puducherry is an open UT, Management seats in its renowned private colleges are highly competitive.",
      themeColor: Color(0xFF10B981),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Mop-Up Round Strictness",
      content: "Candidates holding a seat in AIQ or State Quota after Round 2 are strictly NOT eligible for the Mop-Up round in Puducherry.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "CENTAC",
    address: "Kamarajar Manimandapam, Karuvadikuppam, Puducherry - 605 008",
    phone: "0413-2252566",
    email: "centacprof@gmail.com",
    websiteUrl: "centacpuducherry.in",
    feeStructureUrl: "",
  ),
);
