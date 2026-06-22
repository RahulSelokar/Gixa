import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData uttarPradeshUg = CounsellingStateData(
  name: "Uttar Pradesh",
  heroTitle: "UP NEET UG Counselling",
  heroSubtitle: "Directorate General of Medical Education (UPDGME)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "Stray Vacancy"],
  documents: const [
    "NEET UG Admit Card",
    "NEET UG Scorecard",
    "Class 10 & 12 Marksheets",
    "Domicile Certificate (if applicable)",
    "Category Certificate (OBC/SC/ST/EWS)",
    "Sub-Category Certificate (FF/EA/PH/NCC)",
    "Aadhaar Card",
    "Passport Size Photographs",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 2,000",
    registrationFee: "Included",
    securityDeposit: "₹30,000 to ₹2,00,000",
    isSecurityRefundable: true,
  ),
  notes: const [],
  steps: const [],

  // 1. Overview
  introCards: const [
    IntroCardData(
      icon: Icons.language,
      prefix: "Register online at ",
      highlight: "upneet.gov.in",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.account_balance_wallet,
      iconColor: Colors.orange,
      prefix: "High Security Deposit for ",
      highlight: "Private Colleges (₹ 2 Lakhs)",
      highlightColor: Colors.red,
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Online Registration & Document Upload"),
        RoundStepData(text: "Payment of Registration Fee & Security Deposit"),
        RoundStepData(text: "Online Document Verification"),
        RoundStepData(text: "Publication of State Merit List"),
        RoundStepData(text: "Online Choice Filling & Locking"),
        RoundStepData(text: "Seat Allotment & Download Allotment Letter"),
        RoundStepData(text: "Physical Reporting to Nodal Centre", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Fresh Registration for unregistered candidates"),
        RoundStepData(text: "Fresh Choice Filling (Mandatory for all)"),
        RoundStepData(text: "Seat Allotment & Reporting"),
      ],
    ),
  ],

  // 2. Eligibility
  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "164", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/OBC", percentile: "40th", description: "129", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Domicile Rules",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Passed 10th & 12th from UP", value: "Domicile Cert NOT required"),
        RequirementRow(label: "Passed 10th/12th outside UP", value: "UP Domicile Cert IS mandatory"),
        RequirementRow(label: "Private Colleges", value: "Open to Non-UP residents (No Domicile needed)"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "Private Medical Colleges",
      content: "UP is an 'Open State'. Students from any state in India can apply for Private MBBS/BDS colleges without a UP domicile certificate.",
      icon: Icons.public,
      themeColor: Color(0xFF10B981),
    ),
  ],

  // 3. Reservations
  constitutionalReservation: const ConstitutionalReservationData(
    title: "Vertical Reservation",
    subtitle: "Applicable to Govt. Colleges",
    rows: [
      ReservationBarRow(label: "Unreserved (UR)", abbreviation: "UR", percentage: 50.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "OBC", abbreviation: "OBC", percentage: 27.0, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "Scheduled Caste", abbreviation: "SC", percentage: 21.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "Scheduled Tribe", abbreviation: "ST", percentage: 2.0, themeColor: Color(0xFF10B981)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "Horizontal Quotas",
      content: "Women (20%), NCC (1%), Ex-Servicemen (2%), Freedom Fighters (2%), and PwD (5%).",
      icon: Icons.info_outline,
      themeColor: Color(0xFFD97706),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "EWS Quota",
      description: "10% reservation is applicable for Economically Weaker Sections (EWS) in Government institutions.",
      themeColor: Color(0xFF8B5CF6),
    ),
  ],

  // 4. Fees
  applicationFees: const [
    ApplicationFeeData(
      title: "Registration Fee",
      rows: [FeeRow(label: "All Candidates", amount: 2000)],
      footnote: "Non-refundable. Must be paid online.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit (Refundable)",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Govt. Medical/Dental Colleges: ₹ 30,000",
        "Private Medical Colleges (MBBS): ₹ 2,00,000",
        "Private Dental Colleges (BDS): ₹ 1,00,000",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "SECURITY FORFEITURE",
      description: "If a seat is allotted in Round 2 or Mop-Up and the candidate fails to join.",
      penaltyAmount: "Full Deposit",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  // 5. Alerts & Quick Ref
  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "CTS Bank Node: Security deposit is strictly paid online. Ensure your bank account has a high enough transaction limit (especially for ₹2 Lakhs).",
      "Nodal Centres: Physical reporting for document verification and admission is done at designated Nodal Centres in UP, not directly at the college initially.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.account_balance,
      title: "PRIVATE MBBS",
      description: "UP is a highly sought-after open state. Be prepared for high cutoffs in top private colleges.",
      themeColor: Color(0xFF10B981),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Resignation Rules",
      content: "Resigning from a joined Round 1 seat is only permitted within the specified window before Round 2 begins. Otherwise, the security deposit is forfeited.",
      severity: AlertSeverity.warning,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "UPDGME",
    address: "6th Floor, Jawahar Bhawan, Ashok Marg, Lucknow",
    phone: "upneet.gov.in Helpdesk",
    email: "upneet.gov.in@gmail.com",
    websiteUrl: "upneet.gov.in",
    feeStructureUrl: "",
  ),
);
