import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData upUpgmcPg = CounsellingStateData(
  name: "UP PG",
  heroTitle: "UP NEET PG Counselling",
  heroSubtitle: "Directorate General of Medical Education (UPDGME)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "Stray Vacancy"],
  documents: const [
    "NEET PG Admit Card & Scorecard",
    "MBBS Marksheets & Degree Certificate",
    "NMC/UP SMC Registration Certificate",
    "Internship Completion Certificate",
    "UP Domicile Certificate (if applicable)",
    "Caste/Category Certificate (issued by UP Govt)",
    "NOC from Employer (if in-service)",
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
      prefix: "Register online via ",
      highlight: "upneet.gov.in",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.public,
      iconColor: Colors.orange,
      prefix: "UP is an ",
      highlight: "Open State for Private PG Seats",
      highlightColor: Color(0xFFD97706),
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Online Registration & Payment of ₹3000 Fee"),
        RoundStepData(text: "Payment of Security Deposit via CTS Bank Node"),
        RoundStepData(text: "Online Document Verification"),
        RoundStepData(text: "Declaration of State Merit List"),
        RoundStepData(text: "Online Choice Filling & Locking"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Physical Reporting to Nodal Center", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Fresh Registration for unregistered candidates"),
        RoundStepData(text: "Mandatory Fresh Choice Filling"),
        RoundStepData(text: "Seat Allotment & Upgradation"),
        RoundStepData(text: "Reporting to allotted college/nodal center"),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "291", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/OBC", percentile: "40th", description: "257", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Eligibility",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "MBBS from UP", value: "Eligible for Govt & Private Seats"),
        RequirementRow(label: "UP Domicile (MBBS outside)", value: "Eligible for Govt & Private Seats"),
        RequirementRow(label: "Non-UP Candidates", value: "Eligible for Private Management Seats Only"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "In-Service Quota",
      content: "PMHS (Provincial Medical Health Services) candidates working in UP receive incentive marks (up to 30%) based on their years of service in remote/difficult areas.",
      icon: Icons.local_hospital,
      themeColor: Color(0xFF10B981),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Vertical Reservation",
    subtitle: "Applicable to Govt Medical Colleges",
    rows: [
      ReservationBarRow(label: "UR", abbreviation: "UR", percentage: 50.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "OBC", abbreviation: "OBC", percentage: 27.0, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "SC", abbreviation: "SC", percentage: 21.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "ST", abbreviation: "ST", percentage: 2.0, themeColor: Color(0xFF10B981)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "No Reservation in Private",
      content: "Private Medical Colleges in UP do not offer any caste-based reservation. All seats are unreserved/open.",
      icon: Icons.cancel,
      themeColor: Color(0xFFDC2626),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "Private Minority Colleges",
      description: "Minority medical colleges have specific quotas reserved for minority students (e.g., Muslim/Jain minority).",
      themeColor: Color(0xFF8B5CF6),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "Registration Fee",
      rows: [FeeRow(label: "All Candidates", amount: 3000)],
      footnote: "Non-refundable application fee payable online.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit (Refundable)",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Government Colleges: ₹ 30,000",
        "Private Colleges (Clinical): ₹ 2,00,000",
        "Private Colleges (Pre/Para Clinical): ₹ 1,00,000",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "SECURITY FORFEITURE",
      description: "If a seat is allotted in Round 2 or Mop-Up and the candidate fails to join the allotted college.",
      penaltyAmount: "Full Deposit",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Nodal Center Verification: Even after online verification, candidates might need to report to a specific Nodal Center in UP for original document submission.",
      "CTS Bank Node: The security deposit must be paid via the specific CTS Bank Node provided on the portal. Bank limits often block the ₹2 Lakh transaction.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.group,
      title: "MINORITY SEATS",
      description: "If you belong to a minority, you can apply for minority private colleges in UP, which often have different cutoffs.",
      themeColor: Color(0xFFEAB308),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Seat Leaving Bond",
      content: "Government medical colleges in UP impose a heavy financial bond if a candidate leaves the course midway.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "UPDGME",
    address: "6th Floor, Jawahar Bhawan, Ashok Marg, Lucknow",
    phone: "Check upneet.gov.in",
    email: "upneet.gov.in@gmail.com",
    websiteUrl: "upneet.gov.in",
    feeStructureUrl: "",
  ),
);
