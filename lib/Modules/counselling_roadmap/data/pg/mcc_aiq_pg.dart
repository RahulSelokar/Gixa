import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData mccAiqPg = CounsellingStateData(
  name: "MCC AIQ PG",
  heroTitle: "MCC AIQ NEET PG Counselling",
  heroSubtitle: "Medical Counseling Committee (MCC) - 50% AIQ & 100% Deemed",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Round 3", "Stray Vacancy"],
  documents: const [
    "NEET PG Admit Card & Scorecard",
    "MBBS Degree Certificate / Provisional Certificate",
    "Internship Completion Certificate",
    "Permanent/Provisional Registration Certificate (NMC/SMC)",
    "Class 10 Certificate (Date of Birth proof)",
    "Category Certificate (if applicable)",
    "Valid ID Proof (Aadhaar/PAN/Passport)",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 1,000 (Govt) / ₹ 5,000 (Deemed)",
    registrationFee: "Included",
    securityDeposit: "₹ 25,000 (Govt) / ₹ 2,00,000 (Deemed)",
    isSecurityRefundable: true,
  ),
  notes: const [],
  steps: const [],

  introCards: const [
    IntroCardData(
      icon: Icons.language,
      prefix: "Register online strictly at ",
      highlight: "mcc.nic.in",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.account_balance,
      iconColor: Colors.purple,
      prefix: "100% seats of ",
      highlight: "Deemed & Central Universities",
      highlightColor: Color(0xFF9333EA),
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Online Registration & Payment of Security Deposit"),
        RoundStepData(text: "Choice Filling & Option Locking"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Free Exit allowed if not joining", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Fresh Registration & Choice Filling"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Security forfeiture if allotted seat is not joined", type: RoundStepType.error),
      ],
    ),
    RoundProcessData(
      badgeText: "R3",
      title: "Round 3 (Mop-Up)",
      themeColor: Color(0xFFEA580C),
      steps: [
        RoundStepData(text: "Fresh Registration & Choice Filling"),
        RoundStepData(text: "If seat allotted, joining is mandatory"),
        RoundStepData(text: "Cannot participate in any further counselling if allotted in R3", type: RoundStepType.error),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "291", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/OBC", percentile: "40th", description: "257", themeColor: Color(0xFFEAB308)),
    PercentileData(category: "Gen-PwD", percentile: "45th", description: "274", themeColor: Color(0xFF10B981)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Eligibility Criteria",
      icon: Icons.verified,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "MBBS Registration", value: "Permanent/Provisional NMC/SMC Registration is mandatory"),
        RequirementRow(label: "Internship Cut-off", value: "Must complete internship by NMC stipulated deadline"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "Open to All States",
      content: "All candidates who qualified NEET PG are eligible for 50% AIQ and 100% Deemed Universities regardless of their MBBS passing state.",
      icon: Icons.public,
      themeColor: Color(0xFF10B981),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Reservation in 50% AIQ",
    subtitle: "Central Educational Institutions",
    rows: [
      ReservationBarRow(label: "Unreserved (UR)", abbreviation: "UR", percentage: 40.5, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "OBC (NCL)", abbreviation: "OBC", percentage: 27.0, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "Scheduled Caste", abbreviation: "SC", percentage: 15.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "EWS", abbreviation: "EWS", percentage: 10.0, themeColor: Color(0xFF8B5CF6)),
      ReservationBarRow(label: "Scheduled Tribe", abbreviation: "ST", percentage: 7.5, themeColor: Color(0xFF10B981)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "PwD Reservation",
      content: "5% horizontal reservation across all categories for Persons with Benchmark Disabilities.",
      icon: Icons.accessible,
      themeColor: Color(0xFF2563EB),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "No Reservation in Deemed Universities",
      description: "Deemed Universities do NOT have OBC/SC/ST/EWS reservation. They have 85% Management Quota and 15% NRI Quota seats.",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "Non-Refundable Fee",
      rows: [
        FeeRow(label: "Govt (UR/EWS)", amount: 1000),
        FeeRow(label: "Govt (SC/ST/OBC)", amount: 500),
        FeeRow(label: "Deemed (All Categories)", amount: 5000),
      ],
      footnote: "Required for registration on the MCC portal.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit rules",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "AIQ Govt/Central Univ (UR/EWS): ₹ 25,000",
        "AIQ Govt/Central Univ (SC/ST/OBC): ₹ 10,000",
        "Deemed Universities: ₹ 2,00,000",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "SECURITY FORFEITURE",
      description: "If a candidate is allotted a seat in Round 2 or Round 3 and fails to join.",
      penaltyAmount: "Full Deposit",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Stray Vacancy Risk: You cannot participate in the Stray Vacancy round if you hold any seat (State or AIQ).",
      "Payment Account: The ₹ 2,00,000 deposit refund will strictly be credited back to the exact bank account used for payment.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.block,
      title: "BLOCKING SEATS",
      description: "Do not block seats in R3. Joining is mandatory and non-joining results in debarment from the NEET PG exam for 1 year.",
      themeColor: Color(0xFFDC2626),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Round 2 Upgradation",
      content: "If you upgrade in Round 2, your Round 1 seat is cancelled immediately. You must report to the newly allotted college.",
      severity: AlertSeverity.warning,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "Medical Counseling Committee (MCC)",
    address: "DGHS, MoHFW, Nirman Bhawan, New Delhi",
    phone: "1800 102 7637",
    email: "adgme@nic.in",
    websiteUrl: "mcc.nic.in",
    feeStructureUrl: "",
  ),
);
