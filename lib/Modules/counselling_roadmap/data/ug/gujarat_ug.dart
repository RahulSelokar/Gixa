import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData gujaratUg = CounsellingStateData(
  name: "Gujarat",
  heroTitle: "Gujarat NEET UG Counselling",
  heroSubtitle: "ACPUGMEC (Admission Committee for Professional Under Graduate Medical Educational Courses)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "Stray Vacancy"],
  documents: const [
    "NEET UG Admit Card & Scorecard",
    "Class 10 & 12 Marksheets",
    "Proof of Birth Place (School L.C. / Birth Cert)",
    "Domicile Certificate (if born outside Gujarat)",
    "Caste Certificate (SC/ST/SEBC) from Gujarat Govt.",
    "Non-Creamy Layer (NCL) for SEBC",
    "EWS Certificate (if applicable)",
    "PIN Purchase Receipt",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 1,000",
    registrationFee: "Included",
    securityDeposit: "₹ 10,000 to ₹ 1,00,000",
    isSecurityRefundable: true,
  ),
  notes: const [],
  steps: const [],

  introCards: const [
    IntroCardData(
      icon: Icons.language,
      prefix: "Purchase PIN & Register at ",
      highlight: "medadmgujarat.org",
      highlightColor: Color(0xFF2563EB),
    ),
    IntroCardData(
      icon: Icons.warning_amber,
      iconColor: Colors.orange,
      prefix: "Document Verification is ",
      highlight: "Mandatory at Help Centers",
      highlightColor: Colors.red,
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Purchase 14-digit PIN online"),
        RoundStepData(text: "Online Registration & Document Upload"),
        RoundStepData(text: "Physical Document Verification at Help Center"),
        RoundStepData(text: "Publication of Merit List"),
        RoundStepData(text: "Online Choice Filling & Locking"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Pay Tuition Fee & Report to Help Center", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Give Online Consent to participate in R2"),
        RoundStepData(text: "Fresh Choice Filling"),
        RoundStepData(text: "Seat Allotment & Upgradation"),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "164", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/SEBC", percentile: "40th", description: "129", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Domicile & Eligibility",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "Born in Gujarat + 10th/12th in Gujarat", value: "Domicile Cert NOT required"),
        RequirementRow(label: "Born outside Gujarat + 10th/12th in Gujarat", value: "Gujarat Domicile IS mandatory"),
        RequirementRow(label: "NRI Candidates", value: "Must apply for NRI Quota seats specifically"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "Closed State",
      content: "Gujarat is a 'Closed State'. Only domicile holders of Gujarat are eligible for state quota and private medical college management seats.",
      icon: Icons.lock,
      themeColor: Color(0xFFDC2626),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Vertical Reservation",
    subtitle: "Applicable to Govt. & GMERS Colleges",
    rows: [
      ReservationBarRow(label: "SEBC (OBC)", abbreviation: "SEBC", percentage: 27.0, themeColor: Color(0xFF3B82F6)),
      ReservationBarRow(label: "Scheduled Tribe", abbreviation: "ST", percentage: 15.0, themeColor: Color(0xFF10B981)),
      ReservationBarRow(label: "Scheduled Caste", abbreviation: "SC", percentage: 7.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "EWS", abbreviation: "EWS", percentage: 10.0, themeColor: Color(0xFF8B5CF6)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "NRI Quota",
      content: "15% seats in Self-Financing institutes and GMERS colleges are reserved for NRI candidates.",
      icon: Icons.flight,
      themeColor: Color(0xFFD97706),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "SEBC Category",
      description: "Candidates claiming SEBC must produce a Non-Creamy Layer (NCL) certificate issued by the competent authority of Gujarat State, valid for the current financial year.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "PIN Purchase & Deposit",
      rows: [
        FeeRow(label: "Non-Refundable PIN Fee", amount: 1000),
        FeeRow(label: "Refundable Security (Govt/GMERS)", amount: 10000),
      ],
      footnote: "Total ₹ 11,000 paid online to purchase the 14-digit PIN for Govt/GMERS. For Private/Management, deposit is ₹ 1,00,000.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit Refund",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Refunded if no seat is allotted.",
        "Refunded upon joining the allotted seat and completing the admission process.",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "DEPOSIT FORFEITURE",
      description: "If an allotted seat in Round 2 or later is not joined, the security deposit is completely forfeited.",
      penaltyAmount: "Full Deposit",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Missing Verification: Buying a PIN and registering online is NOT enough. You MUST physically verify documents at a Help Center to get on the Merit List.",
      "Round 2 Consent: If you want to upgrade or participate in R2, giving online consent is strictly mandatory.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.domain,
      title: "GMERS COLLEGES",
      description: "Gujarat Medical Education & Research Society runs semi-govt colleges. Fees are higher than Govt but lower than private.",
      themeColor: Color(0xFF10B981),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "Help Center Appointment",
      content: "After online registration, you must take a prior appointment online before visiting the Help Center for document verification.",
      severity: AlertSeverity.warning,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "ACPUGMEC Helpdesk",
    address: "GMERS Medical College, Gandhinagar",
    phone: "079-26560680",
    email: "medadmgujarat2018@gmail.com",
    websiteUrl: "medadmgujarat.org",
    feeStructureUrl: "",
  ),
);
