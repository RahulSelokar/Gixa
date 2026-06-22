import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData jharkhandPg = CounsellingStateData(
  name: "Jharkhand PG",
  heroTitle: "Jharkhand NEET PG Counselling",
  heroSubtitle: "Jharkhand Combined Entrance Competitive Examination Board (JCECEB)",
  totalRounds: 3,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round"],
  documents: const [
    "NEET PG Admit Card & Scorecard",
    "MBBS Marksheets & Degree Certificate",
    "NMC/SMC Permanent Registration",
    "Internship Completion Certificate",
    "Local/Permanent Resident Certificate of Jharkhand",
    "Caste Certificate (if applicable)",
    "NOC from Employer (if in-service)",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 1,000 to ₹ 1,250",
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
      icon: Icons.assignment_late,
      iconColor: Colors.orange,
      prefix: "Caste/Residency Certificates must be from ",
      highlight: "Jharkhand Authorities only",
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
        RoundStepData(text: "Publication of State Merit List"),
        RoundStepData(text: "Online Choice Filling & Locking"),
        RoundStepData(text: "Provisional Seat Allotment Letter Download"),
        RoundStepData(text: "Document Verification at Nodal Center/College", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Fresh Choice Filling for Upgradation"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Report to newly allotted college (previous seat cancelled)"),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "291", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "ST/SC/BC-I/BC-II", percentile: "40th", description: "257", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Residency (Domicile)",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Local/Permanent Resident", value: "Eligible for State Quota Seats"),
        RequirementRow(label: "MBBS from Jharkhand", value: "Eligible for State Quota"),
        RequirementRow(label: "Other State Students", value: "Not eligible for State Govt seats"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "Medical Council Registration",
      content: "Candidates must be registered with the Medical Council of India/NMC or the Jharkhand State Medical Council.",
      icon: Icons.medical_services,
      themeColor: Color(0xFF10B981),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Vertical Reservation",
    subtitle: "Applicable to Jharkhand State Quota Seats",
    rows: [
      ReservationBarRow(label: "UR", abbreviation: "UR", percentage: 40.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "ST", abbreviation: "ST", percentage: 26.0, themeColor: Color(0xFF10B981)),
      ReservationBarRow(label: "SC", abbreviation: "SC", percentage: 10.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "BC-I", abbreviation: "BC-I", percentage: 8.0, themeColor: Color(0xFF3B82F6)),
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
      description: "5% horizontal reservation is provided for Persons with Benchmark Disabilities.",
      themeColor: Color(0xFF2563EB),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "Application Fee",
      rows: [
        FeeRow(label: "General / EWS / BC-I / BC-II", amount: 1250),
        FeeRow(label: "SC / ST / Female", amount: 1000),
      ],
      footnote: "Non-refundable. Must be paid online during registration.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Details regarding the security deposit for Choice Filling are notified by JCECEB before the choice filling window opens.",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "BOND PENALTY",
      description: "Candidates admitted to PG courses in Govt colleges must serve the state for a specified period or pay a bond amount.",
      penaltyAmount: "₹ 30 Lakhs",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Certificate Format: Uploading certificates (like caste/residential) not issued by designated Jharkhand authorities will lead to rejection.",
      "Round 2 Upgradation Risk: If you opt for upgradation in R2 and get a new seat, you lose your R1 seat instantly.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.assignment,
      title: "RURAL SERVICE",
      description: "Govt PG seat holders must mandatorily serve in rural/difficult areas of Jharkhand for 3 years post-PG.",
      themeColor: Color(0xFFEAB308),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Official Website Notices",
      content: "All notices regarding counselling dates, merit lists, and seat matrix are published only on jceceb.jharkhand.gov.in.",
      severity: AlertSeverity.note,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "JCECEB Board",
    address: "Science & Technology Campus, Sirkha Toli, Namkum-Tupudana Road, Namkum, Ranchi",
    phone: "Check portal",
    email: "jceceboard@gmail.com",
    websiteUrl: "jceceb.jharkhand.gov.in",
    feeStructureUrl: "",
  ),
);
