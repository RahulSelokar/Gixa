import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData rajasthanPg = CounsellingStateData(
  name: "Rajasthan PG",
  heroTitle: "Rajasthan NEET PG Counselling",
  heroSubtitle: "Office of the Chairman, NEET PG Medical Admission/Counseling Board",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "Stray Vacancy"],
  documents: const [
    "NEET PG Admit Card & Scorecard",
    "MBBS Marksheets & Degree Certificate",
    "NMC/RMC Registration Certificate",
    "Internship Completion Certificate",
    "Rajasthan Domicile Certificate (if applicable)",
    "Caste/Category Certificate",
    "NOC for In-Service Candidates",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 3,000",
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
      highlight: "rajpgmedical.com",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.receipt_long,
      iconColor: Colors.green,
      prefix: "Heavy Penalties for ",
      highlight: "Seat Resignation",
      highlightColor: Colors.red,
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Online Registration & Application Fee Payment"),
        RoundStepData(text: "Publishing of Provisional State Merit List"),
        RoundStepData(text: "Online Choice Filling"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Print Allotment Letter & Report to allotted college"),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Mandatory Payment of Security Deposit"),
        RoundStepData(text: "Fresh Choice Filling"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Physical Reporting and Document Verification", type: RoundStepType.warning),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "291", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/OBC/MBC", percentile: "40th", description: "257", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Eligibility Details",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "MBBS from Rajasthan", value: "Eligible for State Quota"),
        RequirementRow(label: "Rajasthan Domicile (MBBS Outside)", value: "Eligible for State Quota"),
        RequirementRow(label: "Other State Students", value: "Eligible for Private College Management Seats only"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "In-Service Doctors",
      content: "A significant quota exists for in-service candidates serving in rural/remote areas of Rajasthan, providing them incentive marks up to 30%.",
      icon: Icons.medical_services,
      themeColor: Color(0xFF10B981),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Vertical Reservation",
    subtitle: "State Govt Seats",
    rows: [
      ReservationBarRow(label: "UR", abbreviation: "UR", percentage: 36.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "OBC", abbreviation: "OBC", percentage: 21.0, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "SC", abbreviation: "SC", percentage: 16.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "ST", abbreviation: "ST", percentage: 12.0, themeColor: Color(0xFF10B981)),
      ReservationBarRow(label: "EWS", abbreviation: "EWS", percentage: 10.0, themeColor: Color(0xFF8B5CF6)),
      ReservationBarRow(label: "MBC", abbreviation: "MBC", percentage: 5.0, themeColor: Color(0xFFF59E0B)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "MBC Quota",
      content: "Rajasthan has a specific 5% reservation for Most Backward Classes (MBC).",
      icon: Icons.people,
      themeColor: Color(0xFFD97706),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "In-Service Quota",
      description: "Candidates must have an NOC from the Medical & Health Department of Rajasthan.",
      themeColor: Color(0xFF2563EB),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "Application Fee",
      rows: [
        FeeRow(label: "General", amount: 3000),
        FeeRow(label: "SC / ST / Category", amount: 1500),
      ],
      footnote: "Non-refundable application fee to be paid online.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit (Round 2 onwards)",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Government Colleges: ₹ 25,000",
        "Private Medical Colleges (MD/MS): ₹ 2,00,000",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "SEAT LEAVING PENALTY",
      description: "Resigning from a joined PG seat in Govt colleges carries a massive bond penalty.",
      penaltyAmount: "₹ 5 Lakhs",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Offline Mop-Up: Rajasthan's Mop-up round is often conducted physically. Candidates must be present at the venue with original documents and a demand draft.",
      "Round 2 Security: If you don't pay the security deposit before Round 2 choice filling, you cannot participate.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.assignment_turned_in,
      title: "RURAL BOND",
      description: "Candidates must serve the State Govt for a stipulated period or pay a high bond amount post-PG.",
      themeColor: Color(0xFFEAB308),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Bank Guarantee",
      content: "Private medical colleges in Rajasthan strictly require a Bank Guarantee for the remaining years' fees at the time of admission.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "Chairman, NEET PG Admission Board",
    address: "RUHS College of Dental Sciences, Jaipur",
    phone: "Check official portal",
    email: "Check official portal",
    websiteUrl: "rajpgmedical.com",
    feeStructureUrl: "",
  ),
);
