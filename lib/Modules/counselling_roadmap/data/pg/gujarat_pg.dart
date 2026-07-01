import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData gujaratPg = CounsellingStateData(
  name: "Gujarat PG",
  heroTitle: "Gujarat NEET PG Counselling",
  heroSubtitle: "Admission Committee for Professional Post Graduate Medical Educational Courses (ACPPGMEC)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "Stray Vacancy"],
  documents: const [
    "NEET PG Admit Card & Scorecard",
    "MBBS Degree & Marksheets",
    "GMC / NMC Registration Certificate",
    "12 Months Internship Completion Certificate",
    "School Leaving Certificate (Birth Place proof)",
    "Non-Creamy Layer (NCL) for SEBC (issued by Gujarat Govt)",
    "Caste Certificate (if applicable)",
    "PIN Purchase Receipt",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 3,000 (PIN)",
    registrationFee: "Included in PIN",
    securityDeposit: "₹ 25,000 (Govt) / ₹ 2,00,000 (Private)",
    isSecurityRefundable: true,
  ),
  notes: const [],
  steps: const [],

  introCards: const [
    IntroCardData(
      icon: Icons.language,
      prefix: "Purchase PIN online at ",
      highlight: "medadmgujarat.org",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.verified,
      iconColor: Colors.orange,
      prefix: "Document Verification at ",
      highlight: "Help Centers is Mandatory",
      highlightColor: Colors.red,
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Online purchase of 14-digit PIN"),
        RoundStepData(text: "Online Registration & Document Upload"),
        RoundStepData(text: "Physical Document Verification at Help Center"),
        RoundStepData(text: "Publication of Merit List"),
        RoundStepData(text: "Online Choice Filling"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Fee Payment & Reporting to Help Center", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Give Online Consent to participate in R2"),
        RoundStepData(text: "Payment of Security Deposit"),
        RoundStepData(text: "Fresh Choice Filling"),
        RoundStepData(text: "Seat Allotment & Upgradation"),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "291", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/SEBC", percentile: "40th", description: "257", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Eligibility",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "MBBS from Gujarat", value: "Eligible for State Quota"),
        RequirementRow(label: "MBBS outside Gujarat", value: "Not eligible (Closed State)"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "Institutional Quota",
      content: "Many universities (like MS University, Gujarat University) have specific institutional quotas where preference is given to students who passed MBBS from that specific university.",
      icon: Icons.school,
      themeColor: Color(0xFF10B981),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Vertical Reservation",
    subtitle: "Applicable to State Quota Seats",
    rows: [
      ReservationBarRow(label: "SEBC (OBC)", abbreviation: "SEBC", percentage: 27.0, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "Scheduled Tribe", abbreviation: "ST", percentage: 15.0, themeColor: Color(0xFF10B981)),
      ReservationBarRow(label: "Scheduled Caste", abbreviation: "SC", percentage: 7.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "EWS", abbreviation: "EWS", percentage: 10.0, themeColor: Color(0xFF8B5CF6)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "PwD Reservation",
      content: "5% horizontal reservation is provided for candidates with benchmark disabilities.",
      icon: Icons.accessible,
      themeColor: Color(0xFF2563EB),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "In-Service Medical Officers",
      description: "Specific quota of seats in Degree/Diploma courses is reserved for Medical Officers serving in the state government.",
      themeColor: Color(0xFF8B5CF6),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "PIN Purchase & Deposit",
      rows: [
        FeeRow(label: "Non-Refundable PIN Fee", amount: 3000),
      ],
      footnote: "Required to start the registration process online.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit (Round 2)",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Government Colleges: ₹ 25,000",
        "GMERS/SFI Colleges: ₹ 2,00,000",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "SEAT LEAVING PENALTY",
      description: "If a candidate resigns from a joined PG seat in Gujarat.",
      penaltyAmount: "₹ 5 Lakhs",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "No Physical Verification = No Merit List: Buying the PIN and filling forms online is not enough. You must go to the Help Center in person with original documents.",
      "Consent for R2: If you want to upgrade or even retain your R1 seat and participate in R2, you MUST log in and give 'Online Consent' during the specified window.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.local_hospital,
      title: "BOND SERVICE",
      description: "1 year rural service bond is mandatory for Govt college PG students. The bond penalty is ₹40 Lakhs.",
      themeColor: Color(0xFFDC2626),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Non-Creamy Layer (NCL)",
      content: "SEBC candidates must submit the NCL certificate issued specifically by the Gujarat Government (in Gujarati format), NOT the Central Govt OBC certificate.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "ACPPGMEC",
    address: "GMERS Medical College, Gandhinagar",
    phone: "Check portal",
    email: "Check portal",
    websiteUrl: "medadmgujarat.org",
    feeStructureUrl: "",
  ),
);
