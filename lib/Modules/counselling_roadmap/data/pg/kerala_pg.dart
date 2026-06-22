import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData keralaPg = CounsellingStateData(
  name: "Kerala PG",
  heroTitle: "Kerala NEET PG Counselling",
  heroSubtitle: "Commissioner for Entrance Examinations (CEE)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "Stray Vacancy"],
  documents: const [
    "NEET PG Admit Card & Scorecard",
    "MBBS Degree & Marksheets",
    "CRRI (Internship) Certificate",
    "Permanent Registration (TC Medical Council / NMC)",
    "Proof of Date of Birth",
    "Nativity Certificate (Keralite proof)",
    "Non-Creamy Layer / Caste Certificate",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 500 to ₹ 1,000",
    registrationFee: "Included",
    securityDeposit: "College Specific",
    isSecurityRefundable: true,
  ),
  notes: const [],
  steps: const [],

  introCards: const [
    IntroCardData(
      icon: Icons.language,
      prefix: "Apply online strictly via ",
      highlight: "cee.kerala.gov.in",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.assignment_ind,
      iconColor: Colors.orange,
      prefix: "In-Service Quota is handled by ",
      highlight: "DME Kerala",
      highlightColor: Color(0xFFD97706),
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Online Registration & Document Upload via CEE"),
        RoundStepData(text: "Publishing of Kerala PG Merit List"),
        RoundStepData(text: "Online Option Registration (Choice Filling)"),
        RoundStepData(text: "First Phase Allotment"),
        RoundStepData(text: "Remit Fee online/Head Post Office & Report to College", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Option Confirmation is Mandatory"),
        RoundStepData(text: "Re-arrange/Delete/Add new options"),
        RoundStepData(text: "Second Phase Allotment"),
        RoundStepData(text: "Join college if allotted/upgraded"),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "291", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/SEBC", percentile: "40th", description: "257", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Nativity Criteria",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Keralite", value: "Eligible for State Merit & Communal Reservation"),
        RequirementRow(label: "Non-Keralite I & II", value: "Not eligible for Communal Reservation"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "Medical Council Registration",
      content: "Candidates must be registered with the Travancore-Cochin Medical Council (TCMC) or NMC. If registered outside Kerala, they must apply for TCMC registration.",
      icon: Icons.local_hospital,
      themeColor: Color(0xFF10B981),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Communal Reservation",
    subtitle: "Applicable to Keralite candidates",
    rows: [
      ReservationBarRow(label: "State Merit", abbreviation: "SM", percentage: 60.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "SEBC", abbreviation: "SEBC", percentage: 30.0, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "SC", abbreviation: "SC", percentage: 8.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "ST", abbreviation: "ST", percentage: 2.0, themeColor: Color(0xFF10B981)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "In-Service Quota",
      content: "A major portion of government seats are reserved for Medical Officers serving in Kerala Health Services/Medical Education.",
      icon: Icons.group,
      themeColor: Color(0xFFD97706),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "SEBC Breakdown",
      description: "Ezhavas (9%), Muslims (8%), Backward Hindu (3%), Latin Catholic (3%), etc.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "Application Fee",
      rows: [
        FeeRow(label: "General / SEBC", amount: 1000),
        FeeRow(label: "SC / ST", amount: 500),
      ],
      footnote: "Service quota candidates must pay an additional ₹1000.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Tuition Fee Remittance",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Fee must be paid to CEE before joining the college.",
        "Private college fees can be very high, check CEE notifications.",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "LIQUIDATED DAMAGES",
      description: "If a candidate leaves the course after the stipulated date.",
      penaltyAmount: "₹ 50 Lakhs",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Option Confirmation: If you do not click 'Confirm' during Phase 2, your previous options are wiped out and you won't be allotted a seat.",
      "Defect Rectification: CEE provides a short window to fix uploaded document errors. Missing this means losing reservation claims.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.assignment,
      title: "BOND DETAILS",
      description: "Government seat allottees must serve the Kerala Govt for 1 year (Senior Residency) or pay ₹50 Lakhs.",
      themeColor: Color(0xFFEAB308),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "No Upgradation post R2",
      content: "Candidates joining in Phase 2 cannot resign to participate in AIQ or other state counselling.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "Commissioner for Entrance Examinations",
    address: "5th Floor, Housing Board Buildings, Santhi Nagar, Trivandrum",
    phone: "0471-2525300",
    email: "ceekinfo.cee@kerala.gov.in",
    websiteUrl: "cee.kerala.gov.in",
    feeStructureUrl: "",
  ),
);
