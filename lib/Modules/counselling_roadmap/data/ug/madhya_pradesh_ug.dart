import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData madhyaPradeshUg = CounsellingStateData(
  name: "Madhya Pradesh",
  heroTitle: "MP NEET UG Counselling",
  heroSubtitle: "Department of Medical Education (DME MP)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "College Level Admission (Stray)"],
  documents: const [
    "NEET UG Admit Card & Scorecard",
    "Class 10 & 12 Marksheets",
    "MP Domicile Certificate",
    "Caste/Category Certificate (if applicable)",
    "Income Certificate (For MMVY/Scholarships)",
    "Affidavit for Domicile/Gap (if required)",
    "Aadhaar Card",
    "Passport Size Photographs",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 1,000",
    registrationFee: "Included",
    securityDeposit: "₹ 1,00,000 (For Private)",
    isSecurityRefundable: true,
  ),
  notes: const [],
  steps: const [],

  introCards: const [
    IntroCardData(
      icon: Icons.language,
      prefix: "Register online via ",
      highlight: "dme.mponline.gov.in",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.card_giftcard,
      iconColor: Colors.green,
      prefix: "MMVY Scheme: ",
      highlight: "Full Govt Funding for eligible students",
      highlightColor: Color(0xFF059669),
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Create profile & pay Registration Fee"),
        RoundStepData(text: "Publication of State Merit List"),
        RoundStepData(text: "Choice Filling & Option Locking"),
        RoundStepData(text: "First Round Seat Allotment"),
        RoundStepData(text: "Report to allotted college for document verification & admission", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Fresh Registration for candidates not registered in R1"),
        RoundStepData(text: "Fresh Choice Filling for all participating candidates"),
        RoundStepData(text: "Seat Allotment & Reporting"),
      ],
    ),
  ],

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
        RequirementRow(label: "MP Domicile", value: "Eligible for Govt Colleges & State Quota in Private"),
        RequirementRow(label: "Non-MP Domicile", value: "Eligible for NRI/Management seats only"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "Mukhyamantri Medhavi Vidyarthi Yojana (MMVY)",
      content: "If a student's family income is < ₹ 6 Lakhs/year and they score 70%+ in MP Board (or 85%+ in CBSE/ICSE), the MP Govt pays the entire tuition fee for both Govt and Private medical colleges.",
      icon: Icons.star,
      themeColor: Color(0xFFEAB308),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Vertical Reservation",
    subtitle: "Applicable to MP State Quota Seats",
    rows: [
      ReservationBarRow(label: "Unreserved (UR)", abbreviation: "UR", percentage: 50.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "Scheduled Tribe", abbreviation: "ST", percentage: 20.0, themeColor: Color(0xFF10B981)),
      ReservationBarRow(label: "Scheduled Caste", abbreviation: "SC", percentage: 16.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "OBC", abbreviation: "OBC", percentage: 14.0, themeColor: Color(0xFF3B82F6)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "EWS & Women Quota",
      content: "10% seats are reserved for EWS. There is also a 30% horizontal reservation for Women across all categories.",
      icon: Icons.group,
      themeColor: Color(0xFF059669),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "Freedom Fighter & Sainik",
      description: "3% horizontal reservation for dependents of Freedom Fighters, and 3% for Sainik (Military personnel) quota.",
      themeColor: Color(0xFFD97706),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "Registration Fee",
      rows: [FeeRow(label: "MP Online Portal Fee", amount: 1000)],
      footnote: "Non-refundable. Must be paid to register on the DME portal.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit rules",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Government Colleges: Typically No/Minimal upfront deposit for registration.",
        "Private Colleges (MBBS): ₹ 1,00,000 security deposit required before choice filling.",
        "Private Dental (BDS): ₹ 50,000 security deposit.",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "SEAT LEAVING PENALTY",
      description: "Bond penalty if a student resigns from a joined seat after the stipulated time.",
      penaltyAmount: "₹ 30 Lakhs (Govt)",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Rural Service Bond: Joining a Govt Medical College in MP requires signing a mandatory rural service bond (usually 1 year) or paying the bond amount.",
      "Profile Locking: Ensure you hit 'Lock Options' during choice filling. Unlocked choices might not be considered.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.description,
      title: "MMVY SCHOLARS",
      description: "If claiming MMVY, register on the MMVY portal separately. You must serve a 5-year rural bond in MP after MBBS.",
      themeColor: Color(0xFFEAB308),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Domicile Strictness",
      content: "If you have claimed domicile of any other state, you cannot claim MP domicile. Doing so will lead to cancellation of admission.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "Directorate of Medical Education, MP",
    address: "Satpura Bhawan, Bhopal, Madhya Pradesh",
    phone: "Notified on DME portal",
    email: "mpdme@mp.gov.in",
    websiteUrl: "dme.mponline.gov.in",
    feeStructureUrl: "",
  ),
);
