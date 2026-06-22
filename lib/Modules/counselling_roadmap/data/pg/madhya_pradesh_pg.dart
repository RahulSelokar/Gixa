import 'package:flutter/material.dart';
import '../../model/counselling_state_model.dart';

final CounsellingStateData madhyaPradeshPg = CounsellingStateData(
  name: "Madhya Pradesh PG",
  heroTitle: "MP NEET PG Counselling",
  heroSubtitle: "Department of Medical Education (DME MP)",
  totalRounds: 4,
  icon: Icons.account_balance_outlined,
  rounds: const ["Round 1", "Round 2", "Mop-Up Round", "College Level Admission (Stray)"],
  documents: const [
    "NEET PG Admit Card & Scorecard",
    "MBBS Marksheets & Degree Certificate",
    "NMC / MP Medical Council Registration",
    "Internship Completion Certificate",
    "MP Domicile Certificate (if applicable)",
    "Caste Certificate (SC/ST/OBC)",
    "NOC / Service Certificate for In-Service Candidates",
  ],
  fees: const CounsellingFees(
    applicationFee: "₹ 500 (Portal Fee)",
    registrationFee: "Included",
    securityDeposit: "₹ 10,000 to ₹ 1,00,000",
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
      icon: Icons.medical_services,
      iconColor: Colors.green,
      prefix: "Significant quotas for ",
      highlight: "In-Service Doctors",
      highlightColor: Color(0xFF059669),
    ),
  ],
  processRounds: const [
    RoundProcessData(
      badgeText: "R1",
      title: "Round 1",
      themeColor: Color(0xFF1E40AF),
      steps: [
        RoundStepData(text: "Create profile on DME MP portal"),
        RoundStepData(text: "Publication of State Merit List"),
        RoundStepData(text: "Choice Filling & Option Locking"),
        RoundStepData(text: "Seat Allotment Result"),
        RoundStepData(text: "Report to allotted college for admission", type: RoundStepType.warning),
      ],
    ),
    RoundProcessData(
      badgeText: "R2",
      title: "Round 2",
      themeColor: Color(0xFF0D9488),
      steps: [
        RoundStepData(text: "Fresh Choice Filling (Mandatory)"),
        RoundStepData(text: "Seat Allotment & Upgradation"),
        RoundStepData(text: "Report to allotted college"),
      ],
    ),
  ],

  percentiles: const [
    PercentileData(category: "General / EWS", percentile: "50th", description: "291", themeColor: Color(0xFF3B82F6)),
    PercentileData(category: "SC/ST/OBC", percentile: "40th", description: "257", themeColor: Color(0xFFEAB308)),
  ],
  coreRequirements: const [
    CoreRequirementData(
      title: "Eligibility Criteria",
      icon: Icons.location_on,
      themeColor: Color(0xFF3B82F6),
      rows: [
        RequirementRow(label: "MBBS from MP", value: "Eligible for State Quota"),
        RequirementRow(label: "MP Domicile (MBBS outside)", value: "Eligible for State Quota"),
        RequirementRow(label: "Other State Students", value: "Eligible for Private Management seats only"),
      ],
    ),
  ],
  eligibilityHighlights: const [
    EligibilityHighlightData(
      title: "In-Service Weightage",
      content: "Medical officers serving in rural/tribal areas of MP get incentive marks (10% per year, up to 30% max) added to their NEET PG score.",
      icon: Icons.stars,
      themeColor: Color(0xFF10B981),
    ),
  ],

  constitutionalReservation: const ConstitutionalReservationData(
    title: "Vertical Reservation",
    subtitle: "Applicable to MP State Quota",
    rows: [
      ReservationBarRow(label: "UR", abbreviation: "UR", percentage: 50.0, themeColor: Color(0xFF64748B)),
      ReservationBarRow(label: "ST", abbreviation: "ST", percentage: 20.0, themeColor: Color(0xFF10B981)),
      ReservationBarRow(label: "SC", abbreviation: "SC", percentage: 16.0, themeColor: Color(0xFFEAB308)),
      ReservationBarRow(label: "OBC", abbreviation: "OBC", percentage: 14.0, themeColor: Color(0xFF3B82F6)),
    ],
  ),
  reservationRules: const [
    RuleHighlightData(
      title: "In-Service Quota",
      content: "30% of degree seats are reserved exclusively for in-service medical officers of MP Govt.",
      icon: Icons.business,
      themeColor: Color(0xFFD97706),
    ),
  ],
  detailedReservations: const [
    DetailedReservationCategory(
      title: "EWS Reservation",
      description: "10% seats are reserved for Economically Weaker Sections.",
      themeColor: Color(0xFF8B5CF6),
    ),
  ],

  applicationFees: const [
    ApplicationFeeData(
      title: "Portal Fee",
      rows: [FeeRow(label: "Registration via MP Online", amount: 500)],
      footnote: "Non-refundable fee payable to MP Online.",
      themeColor: Color(0xFF3B82F6),
    ),
  ],
  refundPolicies: const [
    FeeRefundPolicyData(
      title: "Security Deposit (Choice Filling)",
      themeColor: Color(0xFF059669),
      icon: Icons.account_balance_wallet,
      points: [
        "Govt Medical Colleges: No huge deposit for registration initially.",
        "Private Medical Colleges (MD/MS): ₹ 1,00,000 security deposit.",
      ],
    ),
  ],
  penalties: const [
    PenaltyCardData(
      title: "BOND PENALTY",
      description: "Leaving a PG seat midway attracts a massive bond penalty.",
      penaltyAmount: "₹ 30 Lakhs",
      themeColor: Color(0xFFDC2626),
    ),
  ],

  processPitfalls: const ProcessPitfallsData(
    title: "PROCESS PITFALLS",
    pitfalls: [
      "Choice Locking: You MUST manually lock your choices on the portal. If you forget to lock, they might not be considered for allotment.",
      "Affidavits: Strict affidavits regarding domicile, seat leaving, and rural bond must be notarized and submitted physically.",
    ],
  ),
  strategyCards: const [
    StrategyCardData(
      icon: Icons.assignment_turned_in,
      title: "RURAL SERVICE",
      description: "Govt PG students must serve the state for 1 year post-PG. If they fail, the penalty is ₹10 Lakhs.",
      themeColor: Color(0xFFEAB308),
    ),
  ],
  numberedAlerts: const [
    NumberedAlertData(
      title: "In-Service Candidates",
      content: "In-service candidates must obtain an NOC from the Directorate of Health Services (DHS) / Directorate of Medical Services (DMS) MP before applying.",
      severity: AlertSeverity.critical,
      number: 1,
    ),
  ],
  detailedContactInfo: const DetailedContactInfo(
    officeName: "Directorate of Medical Education, MP",
    address: "Satpura Bhawan, Bhopal",
    phone: "Check MP Online",
    email: "mpdme@mp.gov.in",
    websiteUrl: "dme.mponline.gov.in",
    feeStructureUrl: "",
  ),
);
