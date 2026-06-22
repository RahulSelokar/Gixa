import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData tamilNaduUg = CounsellingStateData(
  name: "Tamil Nadu",

  heroTitle: "Tamil Nadu NEET UG Counselling",
  heroSubtitle: "Selection Committee, Directorate of Medical Education (DME)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,

  rounds: const [
    "Round 1",
    "Round 2",
    "Mop-Up Round",
    "Stray Vacancy",
  ],

  documents: const [
    "NEET UG Admit Card",
    "NEET UG Scorecard",
    "Class 10 Marksheet",
    "Class 11 Marksheet",
    "Class 12 Marksheet",
    "Transfer Certificate (TC)",
    "Nativity Certificate (if applicable)",
    "Community Certificate",
    "Income Certificate (if applicable)",
    "First Graduate Certificate (if applicable)",
    "Bonafide Certificate (For 7.5% Govt School Quota)",
    "Aadhaar Card",
  ],

  fees: const CounsellingFees(
    applicationFee: "₹500 / ₹1,000",
    registrationFee: "Included",
    securityDeposit: "₹0 to ₹1,00,000",
    isSecurityRefundable: true,
  ),
  notes: const [],
  steps: const [],

  // 1. Overview (Intro & Process Rounds)
  introCards: const [
    IntroCardData(
      icon: Icons.language,
      iconColor: Colors.blue,
      prefix: "Register online only at ",
      highlight: "tnmedicalselection.net",
      highlightColor: Color(0xFF2563EB),
      isHighlightBold: true,
      suffix: "",
    ),
    IntroCardData(
      icon: Icons.school,
      iconColor: Colors.green,
      prefix: "Separate Application for ",
      highlight: "Govt Quota & Mgmt Quota",
      highlightColor: Color(0xFF059669),
      isHighlightBold: true,
      suffix: " — submit both if eligible.",
    ),
    IntroCardData(
      icon: Icons.assignment_ind,
      iconColor: Colors.orange,
      prefix: "Nativity Certificate is ",
      highlight: "Mandatory",
      highlightColor: Colors.red,
      isHighlightBold: true,
      suffix: " for claiming State Quota (if not studied in TN from Std 6-12).",
    ),
  ],

  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF), // Blue
      steps: [
        RoundStepData(text: "Online Registration & Application Fee Payment"),
        RoundStepData(text: "Certificate Verification (Online/Offline centres)"),
        RoundStepData(text: "Publication of State Rank/Merit List"),
        RoundStepData(text: "Choice Filling and Locking"),
        RoundStepData(text: "Provisional Allotment Publication"),
        RoundStepData(text: "Download Allotment Order & Report to College", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488), // Teal
      steps: [
        RoundStepData(text: "Fresh Choice Filling for eligible candidates"),
        RoundStepData(text: "Candidates allotted in R1 can participate for upgrade"),
        RoundStepData(text: "Publication of Selection List"),
        RoundStepData(text: "Report to newly allotted college and submit original documents", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "MOP",
      title: "Mop-Up Round",
      themeColor: Color(0xFFEA580C), // Orange
      steps: [
        RoundStepData(text: "Fresh Registration permitted for new candidates"),
        RoundStepData(text: "Candidates already joined in R1/R2 are NOT eligible", type: RoundStepType.error),
        RoundStepData(text: "Choice Filling & Seat Allotment"),
        RoundStepData(text: "Physical reporting is mandatory"),
      ],
    ),
    RoundProcessData(
      badgeText: "STRAY",
      title: "Stray Vacancy",
      themeColor: Color(0xFFB91C1C), // Red
      steps: [
        RoundStepData(text: "No Fresh Registration or Choice Filling"),
        RoundStepData(text: "Conducted for remaining vacant seats"),
        RoundStepData(text: "Allotment based on previously filled choices/merit"),
        RoundStepData(text: "Strict penalties apply if seat is allotted but not joined", type: RoundStepType.error),
      ],
    ),
  ],

  // 2. Eligibility
  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "164", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC / ST / OBC", percentile: "40th", description: "129", themeColor: Color(0xFFEAB308)),
    PercentileData(category: "Gen PwD", percentile: "45th", description: "146", themeColor: Color(0xFF10B981)),
  ],

  coreRequirements: const [
    CoreRequirementData(
      title: "Nativity Criteria",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Studied 6th-12th in TN", value: "Nativity Cert NOT required"),
        RequirementRow(label: "Studied outside TN (Native)", value: "Nativity Cert IS mandatory"),
        RequirementRow(label: "Other State Students", value: "Eligible for Open Category (OC) only"),
      ],
    ),
    CoreRequirementData(
      title: "7.5% Govt School Quota",
      icon: Icons.school,
      themeColor: Color(0xFF059669),
      rows: [
        RequirementRow(label: "Eligibility", value: "Studied continuously in TN Govt schools from 6th to 12th"),
        RequirementRow(label: "Proof", value: "Bonafide Certificate from Chief Educational Officer"),
        RequirementRow(label: "Benefits", value: "100% Tuition Fee Waiver"),
      ],
    ),
  ],

  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "NRI Quota",
      content: "NRI financially supporting the candidate must be a blood relative. Valid NRI status proofs, Passport, and Embassy certificates are required.",
      icon: Icons.flight_takeoff,
      themeColor: Color(0xFFD97706),
    ),
    EligibilityHighlightData(
      title: "Minority Institutions",
      content: "Christian and Telugu/Malayalam linguistic minority colleges exist. Respective minority certificates must be produced during verification.",
      icon: Icons.account_balance,
      themeColor: Color(0xFF7C3AED),
    ),
  ],

  // 3. Reservations
  constitutionalReservation: const ConstitutionalReservationData(
    title: "Communal Reservation (69% Policy)",
    subtitle: "Applicable to 85% State Quota Seats",
    rows: [
      ReservationBarRow(label: "Open Competition", abbreviation: "OC", percentage: 31.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "Backward Class", abbreviation: "BC", percentage: 26.5, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "BC (Muslim)", abbreviation: "BCM", percentage: 3.5, themeColor: Color(0xFF0EA5E9)),
      ReservationBarRow(label: "Most Backward / DNC", abbreviation: "MBC", percentage: 20.0, themeColor: Color(0xFF8B5CF6)),
      ReservationBarRow(label: "Scheduled Caste", abbreviation: "SC", percentage: 15.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "SC (Arunthathiyar)", abbreviation: "SCA", percentage: 3.0, themeColor: Color(0xFFF59E0B)),
      ReservationBarRow(label: "Scheduled Tribe", abbreviation: "ST", percentage: 1.0, themeColor: Color(0xFF10B981)),
    ],
  ),

  reservationRules: const [
    RuleHighlightData(
      title: "7.5% Horizontal Quota",
      content: "7.5% of seats are reserved horizontally across all categories for students who studied in Tamil Nadu Government schools from Class 6 to 12.",
      icon: Icons.school,
      themeColor: Color(0xFF059669),
    ),
    RuleHighlightData(
      title: "PwD Reservation",
      content: "5% horizontal reservation is provided for Persons with Benchmark Disabilities as per NMC guidelines.",
      icon: Icons.accessible,
      themeColor: Color(0xFF2563EB),
    ),
  ],

  detailedReservations: const [
    DetailedReservationCategory(
      title: "BC / BCM / MBC",
      description: "Only candidates native to Tamil Nadu are eligible. Candidates from other states belonging to these categories will be treated under Open Competition (OC).",
      themeColor: Color(0xFF3B82F6),
    ),
    DetailedReservationCategory(
      title: "SC / SCA / ST",
      description: "To claim reservation under SC (Arunthathiyar), candidates must possess a valid community certificate specific to SCA. SC/SCA/ST candidates are also exempt from application fees.",
      themeColor: Color(0xFFEAB308),
    ),
    DetailedReservationCategory(
      title: "Special Categories",
      description: "Includes horizontal quotas for Ex-Servicemen (Children) and Eminent Sports Persons. Specific annexures must be filled and verified offline.",
      themeColor: Color(0xFFEC4899),
    ),
  ],

  // 4. CAP Rounds & Fees
  applicationFees: const [
    ApplicationFeeData(
      title: "Government Quota",
      rows: [FeeRow(label: "Processing Fee", amount: 500)],
      footnote: "Non-refundable application processing fee.",
      themeColor: Color(0xFF3B82F6),
    ),
    ApplicationFeeData(
      title: "Management / NRI Quota",
      rows: [FeeRow(label: "Processing Fee", amount: 1000)],
      footnote: "Non-refundable application processing fee.",
      themeColor: Color(0xFF8B5CF6),
    ),
    ApplicationFeeData(
      title: "SC / SCA / ST",
      rows: [FeeRow(label: "Processing Fee", amount: 0)],
      footnote: "Candidates belonging to SC/SCA/ST of Tamil Nadu are exempted.",
      themeColor: Color(0xFF10B981),
    ),
  ],

  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit Amounts",
      themeColor: Color(0xFF059669), // Green
      icon: Icons.account_balance_wallet,
      points: [
        "Government Medical/Dental Colleges: ₹ 0",
        "Govt Quota in Self-Financing Colleges: ₹ 30,000",
        "Management Quota in Self-Financing Colleges: ₹ 1,00,000",
        "SC/SCA/ST with income < ₹ 2.5L: Exempted from Security Deposit",
      ],
    ),
    FeeRefundPolicyData(
      title: "Deposit is FORFEITED When...",
      themeColor: Color(0xFFDC2626), // Red
      icon: Icons.cancel,
      points: [
        "Allotted a seat in Round 2 / Mop-Up and did NOT join.",
        "Candidate discontinues the course after the stipulated cut-off date.",
        "Seat cancelled due to submission of false or forged documents.",
      ],
    ),
  ],

  penalties: const [
    PenaltyCardData(
      title: "DISCONTINUATION PENALTY",
      description: "Penalty for resigning from a joined seat after the final cut-off date.",
      penaltyAmount: "₹ 10 Lakhs",
      themeColor: Color(0xFFDC2626),
    ),
    PenaltyCardData(
      title: "BOND AMOUNT",
      description: "Varies depending on the Government / Private Institution guidelines.",
      penaltyAmount: "College Specific",
      themeColor: Color(0xFFD97706),
    ),
  ],

  feeDisqualificationAlert: const AlertInfo(
    title: "IMPORTANT NOTE",
    description: "Security deposit will only be refunded to the exact bank account used for payment. Keep the account active until counselling is fully concluded.",
    type: AlertType.warning,
  ),

  // 5. Alerts & Quick Ref
  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Failure to lock choices: If choices are not locked before the deadline, the system automatically locks the saved choices.",
      "Dual Application: If applying for both Govt and Management quotas, two separate applications must be filed.",
      "Fake Nativity: Providing a false Nativity Certificate is a criminal offence and will result in immediate cancellation of admission.",
      "First Graduate Certificate: Must be obtained from the appropriate authority BEFORE applying. It cannot be claimed later.",
    ],
  ),

  strategyCards: const [
    StrategyCardData(
      icon: Icons.description,
      title: "DOCUMENTS",
      description: "Keep original documents ready for physical verification. Mismatch will lead to disqualification.",
      themeColor: Color(0xFFF59E0B),
    ),
    StrategyCardData(
      icon: Icons.school,
      title: "7.5% QUOTA",
      description: "Ensure the Bonafide Certificate is strictly counter-signed by the Chief Educational Officer.",
      themeColor: Color(0xFF10B981),
    ),
    StrategyCardData(
      icon: Icons.account_balance,
      title: "FEE TIMELINES",
      description: "Download the allotment order only AFTER paying the tuition fee online via the portal.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],

  numberedAlerts: const [
    NumberedAlertData(
      title: "Round 2 Upgradation",
      content: "If upgraded in Round 2, the Round 1 seat is automatically cancelled. You cannot retain the R1 seat once upgraded.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
    NumberedAlertData(
      title: "Mop-Up Round Strictness",
      content: "Candidates who have already joined a college in R1 or R2 of State Quota or AIQ are NOT eligible to participate in the Mop-Up round.",
      severity: AlertSeverity.critical,
      number: 2,
    ),
  ],

  detailedContactInfo: const DetailedContactInfo(
    officeName: "Selection Committee, DME",
    address: "162, Periyar E.V.R. High Road, Kilpauk, Chennai - 600 010",
    phone: "044-28361674 / 044-28360674",
    email: "Notified on portal",
    websiteUrl: "www.tnmedicalselection.net",
    feeStructureUrl: "",
  ),
);
