import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData jharkhandUg = CounsellingStateData(
  name: "Jharkhand",
  heroTitle: "Jharkhand NEET UG Counselling",
  heroSubtitle: "Jharkhand Combined Entrance Competitive Examination Board (JCECEB)",
  totalRounds: 3,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round"],
  documents: const [
    "NEET UG Admit Card & Scorecard",
    "Class 10 & 12 Marksheets & Passing Certificates",
    "Local/Permanent Resident Certificate of Jharkhand",
    "Caste Certificate (if applicable)",
    "Income & Asset Certificate (for EWS)",
    "Disability Certificate (if applicable)",
    "Aadhaar Card / Valid ID Proof",
    "Passport Size Photographs",
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
      prefix: "Apply online at ",
      highlight: "jceceb.jharkhand.gov.in",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.file_copy,
      iconColor: Colors.orange,
      prefix: "State Merit List is prepared before ",
      highlight: "Choice Filling",
      highlightColor: Color(0xFF059669),
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Online Registration & Application Submission"),
        RoundStepData(text: "Publication of State Merit List"),
        RoundStepData(text: "Online Choice Filling for Seat Allotment"),
        RoundStepData(text: "Provisional Seat Allotment Letter Download"),
        RoundStepData(text: "Document Verification at Nodal Center/Allotted College", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Fresh Choice Filling for Upgradation"),
        RoundStepData(text: "If upgraded, previous seat is automatically cancelled"),
        RoundStepData(text: "Report to newly allotted college"),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "164", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "ST/SC/BC-I/BC-II", percentile: "40th", description: "129", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Residency (Domicile)",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Local / Permanent Resident", value: "Eligible for 85% State Quota Seats"),
        RequirementRow(label: "Other State Students", value: "NOT eligible for State Quota (Except Mgmt/NRI seats)"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "Caste Certificate Strictness",
      content: "Caste certificates must be issued by a competent authority (Circle Officer / Sub Divisional Officer / Deputy Commissioner) of Jharkhand state only.",
      icon: Icons.policy,
      themeColor: Color(0xFFDC2626),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Vertical Reservation",
    subtitle: "Applicable to Jharkhand State Quota Seats",
    rows: [
      ReservationBarRow(label: "Unreserved (UR)", abbreviation: "UR", percentage: 40.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "Scheduled Tribe", abbreviation: "ST", percentage: 26.0, themeColor: Color(0xFF10B981)),
      ReservationBarRow(label: "Scheduled Caste", abbreviation: "SC", percentage: 10.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "BC-I (EBC)", abbreviation: "BC-I", percentage: 8.0, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "BC-II", abbreviation: "BC-II", percentage: 6.0, themeColor: Color(0xFF0EA5E9)),
      ReservationBarRow(label: "EWS", abbreviation: "EWS", percentage: 10.0, themeColor: Color(0xFF8B5CF6)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "PTG Quota",
      content: "Primitive Tribal Group (PTG) candidates are given preference within the ST quota seats.",
      icon: Icons.group_add,
      themeColor: Color(0xFF10B981),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "PwD Reservation",
      description: "5% horizontal reservation is provided for Persons with Disabilities as per NMC guidelines.",
      themeColor: Color(0xFF2563EB),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "Registration Fee",
      rows: [
        FeeRow(label: "General / EWS / BC-I / BC-II", amount: 1000),
        FeeRow(label: "SC / ST / Female Candidates", amount: 500),
      ],
      footnote: "Divyang (PwD) candidates are usually exempted from the application fee.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Details regarding security deposit for Choice Filling are notified by JCECEB before the choice filling window opens.",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "DOCUMENT MISMATCH",
      description: "If a candidate fails to produce the original residential or caste certificate during admission, the seat is instantly cancelled.",
      penaltyAmount: "Seat Cancellation",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Incomplete Application: Uploading blurred or incorrect certificates during registration will lead to rejection from the State Merit List.",
      "Round 2 Upgradation Risk: If you opt for upgradation in R2 and are allotted a new seat, you lose all rights to your R1 seat immediately.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.assignment_late,
      title: "MEDICAL FITNESS",
      description: "A Medical Fitness certificate from a registered medical practitioner is mandatory at the time of reporting.",
      themeColor: Color(0xFFEAB308),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Official Website Check",
      content: "All notices regarding counselling dates, merit lists, and seat matrix are published only on the official JCECEB website.",
      severity: AlertSeverity.note,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "JCECEB Board",
    address: "Science & Technology Campus, Sirkha Toli, Namkum-Tupudana Road, Namkum, Ranchi - 834010",
    phone: "9264473891 / 9264473893",
    email: "jceceboard@gmail.com",
    websiteUrl: "jceceb.jharkhand.gov.in",
    feeStructureUrl: "",
  ),
);
