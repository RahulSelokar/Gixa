import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData tamilNaduPg = CounsellingStateData(
  name: "Tamil Nadu PG",
  heroTitle: "Tamil Nadu NEET PG Counselling",
  heroSubtitle: "Selection Committee, Directorate of Medical Education (DME)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "Stray Vacancy"],
  documents: const [
    "NEET PG Admit Card & Scorecard",
    "MBBS Degree Certificate / Provisional Certificate",
    "CRRI (Internship) Completion Certificate",
    "Tamil Nadu Medical Council Registration",
    "Nativity Certificate (if applicable)",
    "Community Certificate (issued by TN Govt)",
    "TNPSC / MRB order (for in-service candidates)",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 3,000",
    registrationFee: "Included",
    securityDeposit: "₹ 30,000 to ₹ 2,00,000",
    isSecurityRefundable: true,
  ),
  notes: const [],
  steps: const [],

  introCards: const [
    IntroCardData(
      icon: Icons.language,
      prefix: "Apply online at ",
      highlight: "tnmedicalselection.net",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.school,
      iconColor: Colors.orange,
      prefix: "Separate applications for ",
      highlight: "Govt Quota & Mgmt Quota",
      highlightColor: Color(0xFFD97706),
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Online Registration & Document Upload"),
        RoundStepData(text: "Publishing of State Merit List"),
        RoundStepData(text: "Online Choice Filling & Locking"),
        RoundStepData(text: "Provisional Allotment Publication"),
        RoundStepData(text: "Download Allotment Order after paying Tuition Fee online"),
        RoundStepData(text: "Physical Reporting to College", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Re-allotment/Upgradation for R1 joined candidates"),
        RoundStepData(text: "Fresh Choice Filling"),
        RoundStepData(text: "Seat Allotment & Reporting"),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "291", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/OBC", percentile: "40th", description: "257", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Nativity Criteria",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "MBBS in TN", value: "Eligible for State Quota (Nativity Cert NOT req)"),
        RequirementRow(label: "Native of TN (MBBS outside)", value: "Eligible for State Quota (Nativity Cert Req)"),
        RequirementRow(label: "Other State Students", value: "Eligible for Management Quota Only"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "In-Service Quota",
      content: "50% of the State Quota seats in Govt Medical Colleges are reserved for In-Service candidates (Medical Officers in TN Govt service).",
      icon: Icons.local_hospital,
      themeColor: Color(0xFF10B981),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Communal Reservation (69% Policy)",
    subtitle: "Applicable to State Quota Seats",
    rows: [
      ReservationBarRow(label: "OC", abbreviation: "OC", percentage: 31.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "BC", abbreviation: "BC", percentage: 26.5, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "BCM", abbreviation: "BCM", percentage: 3.5, themeColor: Color(0xFF0EA5E9)),
      ReservationBarRow(label: "MBC/DNC", abbreviation: "MBC", percentage: 20.0, themeColor: Color(0xFF8B5CF6)),
      ReservationBarRow(label: "SC", abbreviation: "SC", percentage: 15.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "SCA", abbreviation: "SCA", percentage: 3.0, themeColor: Color(0xFFF59E0B)),
      ReservationBarRow(label: "ST", abbreviation: "ST", percentage: 1.0, themeColor: Color(0xFF10B981)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "PwD Reservation",
      content: "5% horizontal reservation is provided for Persons with Benchmark Disabilities.",
      icon: Icons.accessible,
      themeColor: Color(0xFF2563EB),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "Service vs Non-Service",
      description: "After communal reservation, the seats are strictly divided between Service (50%) and Non-Service (50%) candidates.",
      themeColor: Color(0xFF10B981),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "Application Fee",
      rows: [
        FeeRow(label: "Govt Quota", amount: 3000),
        FeeRow(label: "Management Quota", amount: 5000),
        FeeRow(label: "SC/SCA/ST (TN Native)", amount: 0),
      ],
      footnote: "Non-refundable application processing fee.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit Amounts",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Government Colleges: ₹ 30,000",
        "Private Medical Colleges (MD/MS): ₹ 2,00,000",
        "SC/SCA/ST candidates with income < 2.5L are exempted.",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "DISCONTINUATION PENALTY",
      description: "Penalty for resigning a PG seat after the final cut-off date.",
      penaltyAmount: "₹ 15 Lakhs",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Tuition Fee Download: The allotment order can only be downloaded AFTER paying the heavy tuition fee amount online through the portal.",
      "Dual Applications: If you want both Govt Quota and Management Quota, you MUST fill out two separate applications.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.assignment_turned_in,
      title: "BOND REQUIREMENTS",
      description: "All non-service candidates must execute a bond to serve the TN Govt for a specific period (usually 2 years) or pay ₹40 Lakhs.",
      themeColor: Color(0xFFDC2626),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Round 2 Upgradation",
      content: "If you are upgraded in Round 2, your Round 1 seat is automatically cancelled and you cannot claim it back.",
      severity: AlertSeverity.warning,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "Selection Committee, DME",
    address: "162, Periyar E.V.R. High Road, Kilpauk, Chennai - 600010",
    phone: "044-28361674",
    email: "Check portal",
    websiteUrl: "tnmedicalselection.net",
    feeStructureUrl: "",
  ),
);
