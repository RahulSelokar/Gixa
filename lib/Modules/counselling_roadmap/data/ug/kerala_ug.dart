import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData keralaUg = CounsellingStateData(
  name: "Kerala",
  heroTitle: "Kerala NEET UG Counselling",
  heroSubtitle: "Commissioner for Entrance Examinations (CEE)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "Stray Vacancy"],
  documents: const [
    "KEAM Application Printout",
    "NEET UG Admit Card & Scorecard",
    "Proof of Date of Birth (SSLC)",
    "Original Mark List of Qualifying Exam",
    "Pass Certificate (if issued)",
    "Transfer Certificate & Conduct Certificate",
    "Nativity Proof (Keralite / NK I / NK II)",
    "Income/Community Certificate (for reservation)",
    "Physical Fitness Certificate",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 500 to ₹ 1,000",
    registrationFee: "Included in KEAM",
    securityDeposit: "₹ 1,00,000 (Private)",
    isSecurityRefundable: true,
  ),
  notes: const [],
  steps: const [],

  introCards: const [
    IntroCardData(
      icon: Icons.language,
      prefix: "Apply through KEAM Portal at ",
      highlight: "cee.kerala.gov.in",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.warning_amber,
      iconColor: Colors.orange,
      prefix: "Strict Nativity Rules: ",
      highlight: "Only 'Keralites' eligible for State Quota.",
      highlightColor: Colors.red,
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Phase 1 (Round 1)",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Register on KEAM and submit NEET Score"),
        RoundStepData(text: "State Rank List Published"),
        RoundStepData(text: "Online Option Registration (Choice Filling)"),
        RoundStepData(text: "First Phase Allotment Published"),
        RoundStepData(text: "Remit Tuition Fee online or at Head Post Office"),
        RoundStepData(text: "Report to college for admission", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Phase 2 (Round 2)",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Option Confirmation (Mandatory) to participate"),
        RoundStepData(text: "Re-arrange/Delete/Add new options"),
        RoundStepData(text: "Second Phase Allotment"),
        RoundStepData(text: "Remit balance fee and join college"),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General", percentile: "50th", description: "164", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/SEBC", percentile: "40th", description: "129", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Nativity (Domicile) Types",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Keralite", value: "Eligible for State Merit & Communal Reservation"),
        RequirementRow(label: "Non-Keralite I (NK I)", value: "Eligible for State Merit (Open) seats only"),
        RequirementRow(label: "Non-Keralite II (NK II)", value: "Eligible for Management/NRI seats only"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "Non-Keralite II (NK II)",
      content: "NK II candidates can only apply for Management Quota seats in Private Self-Financing Medical Colleges.",
      icon: Icons.public,
      themeColor: Color(0xFF10B981),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Communal Reservation",
    subtitle: "Applicable to Keralite candidates",
    rows: [
      ReservationBarRow(label: "State Merit", abbreviation: "SM", percentage: 60.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "SEBC (Ezhavas, Muslims, etc.)", abbreviation: "SEBC", percentage: 30.0, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "Scheduled Caste", abbreviation: "SC", percentage: 8.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "Scheduled Tribe", abbreviation: "ST", percentage: 2.0, themeColor: Color(0xFF10B981)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "EWS Quota",
      content: "10% seats reserved for Economically Weaker Sections from the General Category (State Merit).",
      icon: Icons.account_balance,
      themeColor: Color(0xFF059669),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "SEBC Breakdown",
      description: "Ezhavas (9%), Muslims (8%), Backward Hindu (3%), Latin Catholic/Anglo Indian (3%), Dheevara (2%), Viswakarma (2%), etc.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "KEAM Medical Registration",
      rows: [
        FeeRow(label: "General", amount: 750),
        FeeRow(label: "SC", amount: 300),
        FeeRow(label: "ST", amount: 0),
      ],
      footnote: "NRI quota candidates must pay an additional ₹5,000.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Tuition Fee Remittance",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Candidates must remit the tuition fee shown in the allotment memo to the CEE online or at Head Post Offices.",
        "Failure to remit the fee will result in cancellation of the allotment and options.",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "LIQUIDATED DAMAGES",
      description: "If a candidate discontinues the course after the final mop-up round or cut-off date.",
      penaltyAmount: "₹ 10 Lakhs",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Option Confirmation: In Phase 2, candidates MUST confirm their options online to be considered for allotment.",
      "Profile Defects: CEE gives time to rectify defects in Nativity/Community certificates. If not rectified, reservation is lost.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.description,
      title: "NRI PROOFS",
      description: "NRI quota requires Embassy Certificate, Employment Certificate, and Relationship Proof.",
      themeColor: Color(0xFFD97706),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Strict Nativity Proof",
      content: "Even for General category, proving Keralite status (SSLC birth place, passport, or Nativity cert) is mandatory for State Merit.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "Commissioner for Entrance Examinations",
    address: "5th Floor, Housing Board Buildings, Santhi Nagar, Thiruvananthapuram - 695 001",
    phone: "0471-2525300",
    email: "ceekinfo.cee@kerala.gov.in",
    websiteUrl: "cee.kerala.gov.in",
    feeStructureUrl: "",
  ),
);
