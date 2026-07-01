// import 'package:flutter/material.dart';
// import 'counselling_state_model.dart';

// class CounsellingStateParser {
//   static CounsellingStateData parse(Map<String, dynamic> json) {
//     return CounsellingStateData(
//       id: json['id']?.toString() ?? '',
//       name: json['name'] ?? '',
//       heroTitle: json['hero_title'] ?? '',
//       heroSubtitle: json['hero_subtitle'] ?? '',
//       totalRounds: json['total_rounds'] ?? 0,
//       icon: _parseIcon(json['icon_url']), // or pass icon_url directly if supported, or map it
//       rounds: (json['rounds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       documents: (json['documents'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       fees: _parseFees(json['fees']),
//       notes: (json['notes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       steps: (json['steps'] as List<dynamic>?)?.map((e) => _parseStep(e)).toList() ?? [],
//       introCards: (json['intro_cards'] as List<dynamic>?)?.map((e) => _parseIntroCard(e)).toList() ?? [],
//       processRounds: (json['process_rounds'] as List<dynamic>?)?.map((e) => _parseProcessRound(e)).toList() ?? [],
//       reRegistrationRules: (json['re_registration_rules'] as List<dynamic>?)?.map((e) => _parseReRegistration(e)).toList() ?? [],
//       seatDistributions: (json['seat_distributions'] as List<dynamic>?)?.map((e) => _parseSeatDistribution(e)).toList() ?? [],
//       eligibility: (json['eligibility'] as List<dynamic>?)?.map((e) => _parseEligibility(e)).toList() ?? [],
//       reservations: (json['reservations'] as List<dynamic>?)?.map((e) => _parseReservation(e)).toList() ?? [],
//       alerts: (json['alerts'] as List<dynamic>?)?.map((e) => _parseAlert(e)).toList() ?? [],
//       contactInfo: json['contact_info'] != null && json['contact_info'].isNotEmpty ? _parseContactInfo(json['contact_info']) : null,
//       percentiles: (json['percentiles'] as List<dynamic>?)?.map((e) => _parsePercentile(e)).toList() ?? [],
//       coreRequirements: (json['core_requirements'] as List<dynamic>?)?.map((e) => _parseCoreRequirement(e)).toList() ?? [],
//       eligibilityHighlights: (json['eligibility_highlights'] as List<dynamic>?)?.map((e) => _parseEligibilityHighlight(e)).toList() ?? [],
//       constitutionalReservation: json['constitutional_reservation'] != null && json['constitutional_reservation'].isNotEmpty ? _parseConstitutionalReservation(json['constitutional_reservation']) : null,
//       reservationRules: (json['reservation_rules'] as List<dynamic>?)?.map((e) => _parseRuleHighlight(e)).toList() ?? [],
//       detailedReservations: (json['detailed_reservations'] as List<dynamic>?)?.map((e) => _parseDetailedReservation(e)).toList() ?? [],
//       reservationCriticalAlert: json['reservation_critical_alert'] != null && json['reservation_critical_alert'].isNotEmpty ? _parseAlert(json['reservation_critical_alert']) : null,
//       applicationFees: (json['application_fees'] as List<dynamic>?)?.map((e) => _parseApplicationFee(e)).toList() ?? [],
//       feePreferenceAlert: json['fee_preference_alert'] != null && json['fee_preference_alert'].isNotEmpty ? _parseAlert(json['fee_preference_alert']) : null,
//       refundPolicies: (json['refund_policies'] as List<dynamic>?)?.map((e) => _parseFeeRefundPolicy(e)).toList() ?? [],
//       penalties: (json['penalties'] as List<dynamic>?)?.map((e) => _parsePenaltyCard(e)).toList() ?? [],
//       feeDisqualificationAlert: json['fee_disqualification_alert'] != null && json['fee_disqualification_alert'].isNotEmpty ? _parseAlert(json['fee_disqualification_alert']) : null,
//       numberedAlerts: (json['numbered_alerts'] as List<dynamic>?)?.map((e) => _parseNumberedAlert(e)).toList() ?? [],
//       detailedContactInfo: json['detailed_contact_info'] != null && json['detailed_contact_info'].isNotEmpty ? _parseDetailedContactInfo(json['detailed_contact_info']) : null,
//       documentChecklist: (json['document_checklist'] as List<dynamic>?)?.map((e) => _parseDocumentChecklist(e)).toList() ?? [],
//       abbreviations: (json['abbreviations'] as List<dynamic>?)?.map((e) => _parseAbbreviation(e)).toList() ?? [],
//       processPitfalls: json['process_pitfalls'] != null && json['process_pitfalls'].isNotEmpty ? _parseProcessPitfalls(json['process_pitfalls']) : null,
//       strategyCards: (json['strategy_cards'] as List<dynamic>?)?.map((e) => _parseStrategyCard(e)).toList() ?? [],
//     );
//   }

//   static IconData _parseIcon(dynamic code) {
//     if (code is String) {
//       if (code.startsWith('0x')) {
//         return IconData(int.tryParse(code) ?? 0xe800, fontFamily: 'MaterialIcons');
//       }
//     }
//     return Icons.medical_services_outlined;
//   }

//   static Color _parseColor(String? hexColor, {Color defaultColor = Colors.blue}) {
//     if (hexColor == null || hexColor.isEmpty) return defaultColor;
//     try {
//       hexColor = hexColor.toUpperCase().replaceAll("#", "");
//       if (hexColor.length == 6) {
//         hexColor = "FF" + hexColor;
//       }
//       return Color(int.parse(hexColor, radix: 16));
//     } catch (e) {
//       return defaultColor;
//     }
//   }

//   static CounsellingFees _parseFees(Map<String, dynamic>? json) {
//     if (json == null) return const CounsellingFees(applicationFee: '', registrationFee: '', securityDeposit: '', isSecurityRefundable: false);
//     return CounsellingFees(
//       applicationFee: json['application_fee']?.toString() ?? '',
//       registrationFee: json['registration_fee']?.toString() ?? '',
//       securityDeposit: json['security_deposit']?.toString() ?? '',
//       isSecurityRefundable: json['is_security_refundable'] ?? false,
//     );
//   }

//   static CounsellingStep _parseStep(Map<String, dynamic> json) {
//     return CounsellingStep(
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//     );
//   }

//   static IntroCardData _parseIntroCard(Map<String, dynamic> json) {
//     return IntroCardData(
//       icon: _parseIcon(json['icon_code']),
//       iconColor: _parseColor(json['icon_color_hex']),
//       prefix: json['prefix'] ?? '',
//       highlight: json['highlight'] ?? '',
//       highlightColor: _parseColor(json['highlight_color_hex']),
//       isHighlightBold: json['is_highlight_bold'] ?? false,
//       suffix: json['suffix'] ?? '',
//     );
//   }

//   static RoundProcessData _parseProcessRound(Map<String, dynamic> json) {
//     return RoundProcessData(
//       badgeText: json['badge_text'] ?? '',
//       title: json['title'] ?? '',
//       themeColor: _parseColor(json['theme_color_hex']),
//       steps: (json['steps'] as List<dynamic>?)?.map((e) => _parseRoundStep(e)).toList() ?? [],
//     );
//   }

//   static RoundStepData _parseRoundStep(Map<String, dynamic> json) {
//     return RoundStepData(
//       text: json['text'] ?? '',
//       type: json['type'] ?? 'normal',
//     );
//   }

//   static ReRegistrationInfo _parseReRegistration(Map<String, dynamic> json) {
//     return ReRegistrationInfo(
//       title: json['title'] ?? '',
//       themeColor: _parseColor(json['theme_color_hex']),
//       icon: _parseIcon(json['icon_code']),
//       points: (json['points'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//     );
//   }

//   static SeatDistributionInfo _parseSeatDistribution(Map<String, dynamic> json) {
//     return SeatDistributionInfo(
//       title: json['title'] ?? '',
//       themeColor: _parseColor(json['theme_color_hex']),
//       distributionPoints: (json['distribution_points'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       highlightBoxText: json['highlight_box_text'],
//     );
//   }

//   static EligibilityCriteria _parseEligibility(Map<String, dynamic> json) {
//     return EligibilityCriteria(
//       title: json['title'] ?? '',
//       subtitle: json['subtitle'] ?? '',
//       items: (json['items'] as List<dynamic>?)?.map((e) => _parseEligibilityItem(e as Map<String, dynamic>)).toList() ?? [],
//     );
//   }

//   static EligibilityItem _parseEligibilityItem(Map<String, dynamic> json) {
//     return EligibilityItem(
//       title: json['title'] ?? '',
//       subtitle: json['subtitle'] ?? '',
//       description: json['description'] ?? '',
//     );
//   }

//   static ReservationCategory _parseReservation(Map<String, dynamic> json) {
//     return ReservationCategory(
//       category: json['category'] ?? '',
//       percentage: json['percentage'] ?? '',
//       description: json['description'],
//     );
//   }

//   static AlertInfo _parseAlert(Map<String, dynamic> json) {
//     return AlertInfo(
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       type: json['type'] ?? 'info',
//     );
//   }

//   static ContactInfo _parseContactInfo(Map<String, dynamic> json) {
//     return ContactInfo(
//       officeName: json['office_name'] ?? '',
//       address: json['address'] ?? '',
//       phone: json['phone'] ?? '',
//       email: json['email'] ?? '',
//       website: json['website'] ?? '',
//     );
//   }

//   static PercentileData _parsePercentile(Map<String, dynamic> json) {
//     return PercentileData(
//       percentile: json['percentile'] ?? '',
//       category: json['category'] ?? '',
//       description: json['description'] ?? '',
//       themeColor: _parseColor(json['theme_color_hex']),
//     );
//   }

//   static CoreRequirementData _parseCoreRequirement(Map<String, dynamic> json) {
//     return CoreRequirementData(
//       title: json['title'] ?? '',
//       icon: _parseIcon(json['icon_code']),
//       themeColor: _parseColor(json['theme_color_hex']),
//       rows: (json['rows'] as List<dynamic>?)?.map((e) => _parseRequirementRow(e)).toList() ?? [],
//     );
//   }

//   static RequirementRow _parseRequirementRow(Map<String, dynamic> json) {
//     return RequirementRow(
//       label: json['label'] ?? '',
//       value: json['value'] ?? '',
//       isValueHighlight: json['is_value_highlight'] ?? false,
//       highlightColor: json['highlight_color_hex'] != null ? _parseColor(json['highlight_color_hex']) : null,
//     );
//   }

//   static EligibilityHighlightData _parseEligibilityHighlight(Map<String, dynamic> json) {
//     return EligibilityHighlightData(
//       title: json['title'] ?? '',
//       content: json['content'] ?? '',
//       themeColor: _parseColor(json['theme_color_hex']),
//       icon: _parseIcon(json['icon_code']),
//       tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//     );
//   }

//   static ConstitutionalReservationData _parseConstitutionalReservation(Map<String, dynamic> json) {
//     return ConstitutionalReservationData(
//       title: json['title'] ?? '',
//       subtitle: json['subtitle'] ?? '',
//       rows: (json['rows'] as List<dynamic>?)?.map((e) => _parseReservationBarRow(e)).toList() ?? [],
//     );
//   }

//   static ReservationBarRow _parseReservationBarRow(Map<String, dynamic> json) {
//     return ReservationBarRow(
//       label: json['label'] ?? '',
//       abbreviation: json['abbreviation'] ?? '',
//       percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
//       themeColor: _parseColor(json['theme_color_hex']),
//     );
//   }

//   static RuleHighlightData _parseRuleHighlight(Map<String, dynamic> json) {
//     return RuleHighlightData(
//       title: json['title'] ?? '',
//       content: json['content'] ?? '',
//       themeColor: _parseColor(json['theme_color_hex']),
//       icon: _parseIcon(json['icon_code']),
//     );
//   }

//   static DetailedReservationCategory _parseDetailedReservation(Map<String, dynamic> json) {
//     return DetailedReservationCategory(
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       themeColor: _parseColor(json['theme_color_hex']),
//     );
//   }

//   static ApplicationFeeData _parseApplicationFee(Map<String, dynamic> json) {
//     return ApplicationFeeData(
//       title: json['title'] ?? '',
//       themeColor: _parseColor(json['theme_color_hex']),
//       footnote: json['footnote'] ?? '',
//       rows: (json['rows'] as List<dynamic>?)?.map((e) => _parseFeeRow(e)).toList() ?? [],
//     );
//   }

//   static FeeRow _parseFeeRow(Map<String, dynamic> json) {
//     return FeeRow(
//       label: json['label'] ?? '',
//       amount: (json['amount'] as num?)?.toInt() ?? 0,
//       isTotal: json['is_total'] ?? false,
//     );
//   }

//   static FeeRefundPolicyData _parseFeeRefundPolicy(Map<String, dynamic> json) {
//     return FeeRefundPolicyData(
//       title: json['title'] ?? '',
//       points: (json['points'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       themeColor: _parseColor(json['theme_color_hex']),
//       icon: _parseIcon(json['icon_code']),
//     );
//   }

//   static PenaltyCardData _parsePenaltyCard(Map<String, dynamic> json) {
//     return PenaltyCardData(
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       penaltyAmount: json['penalty_amount'] ?? '',
//       themeColor: _parseColor(json['theme_color_hex']),
//     );
//   }

//   static NumberedAlertData _parseNumberedAlert(Map<String, dynamic> json) {
//     return NumberedAlertData(
//       number: (json['number'] as num?)?.toInt() ?? 1,
//       title: json['title'] ?? '',
//       content: json['content'] ?? '',
//       severity: json['severity'] ?? 'warning',
//     );
//   }

//   static DetailedContactInfo _parseDetailedContactInfo(Map<String, dynamic> json) {
//     return DetailedContactInfo(
//       officeName: json['office_name'] ?? '',
//       address: json['address'] ?? '',
//       phone: json['phone'] ?? '',
//       email: json['email'] ?? '',
//       websiteUrl: json['website_url'] ?? '',
//       feeStructureUrl: json['fee_structure_url'] ?? '',
//     );
//   }

//   static DocumentChecklistItem _parseDocumentChecklist(Map<String, dynamic> json) {
//     return DocumentChecklistItem(
//       name: json['name'] ?? '',
//       isMandatory: json['is_mandatory'] ?? false,
//     );
//   }

//   static AbbreviationData _parseAbbreviation(Map<String, dynamic> json) {
//     return AbbreviationData(
//       abbreviation: json['abbreviation'] ?? '',
//       fullForm: json['full_form'] ?? '',
//     );
//   }

//   static ProcessPitfallsData _parseProcessPitfalls(Map<String, dynamic> json) {
//     return ProcessPitfallsData(
//       title: json['title'] ?? '',
//       pitfalls: (json['pitfalls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//     );
//   }

//   static StrategyCardData _parseStrategyCard(Map<String, dynamic> json) {
//     return StrategyCardData(
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       themeColor: _parseColor(json['theme_color_hex']),
//       icon: _parseIcon(json['icon_code']),
//     );
//   }
// }
