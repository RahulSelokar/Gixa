import 'package:flutter/material.dart';

class CounsellingStateData {
  final String id;
  final String name;
  final String heroTitle;
  final String heroSubtitle;
  final int totalRounds;
  final IconData icon;
  final List<String> rounds;
  final List<String> documents;
  final CounsellingFees fees;
  final List<String> notes;
  final List<CounsellingStep> steps;

  // New Fields
  final List<IntroCardData> introCards;
  final List<RoundProcessData> processRounds;
  final List<ReRegistrationInfo> reRegistrationRules;
  final List<SeatDistributionInfo> seatDistributions;
  final List<EligibilityCriteria> eligibility;
  final List<ReservationCategory> reservations;
  final List<AlertInfo> alerts;
  final ContactInfo? contactInfo;

  final List<PercentileData> percentiles;
  final List<CoreRequirementData> coreRequirements;
  final List<EligibilityHighlightData> eligibilityHighlights;

  final ConstitutionalReservationData? constitutionalReservation;
  final List<RuleHighlightData> reservationRules;
  final List<DetailedReservationCategory> detailedReservations;
  final AlertInfo? reservationCriticalAlert;

  final List<ApplicationFeeData> applicationFees;
  final AlertInfo? feePreferenceAlert;
  final List<FeeRefundPolicyData> refundPolicies;
  final List<PenaltyCardData> penalties;
  final AlertInfo? feeDisqualificationAlert;

  final List<NumberedAlertData> numberedAlerts;
  final DetailedContactInfo? detailedContactInfo;
  final List<DocumentChecklistItem> documentChecklist;
  final List<AbbreviationData> abbreviations;
  
  final ProcessPitfallsData? processPitfalls;
  final List<StrategyCardData> strategyCards;

  const CounsellingStateData({
    required this.id,
    required this.name,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.totalRounds,
    required this.icon,
    required this.rounds,
    required this.documents,
    required this.fees,
    required this.notes,
    required this.steps,
    this.introCards = const [],
    this.processRounds = const [],
    this.reRegistrationRules = const [],
    this.seatDistributions = const [],
    this.eligibility = const [],
    this.reservations = const [],
    this.alerts = const [],
    this.contactInfo,
    this.percentiles = const [],
    this.coreRequirements = const [],
    this.eligibilityHighlights = const [],
    this.constitutionalReservation,
    this.reservationRules = const [],
    this.detailedReservations = const [],
    this.reservationCriticalAlert,
    this.applicationFees = const [],
    this.feePreferenceAlert,
    this.refundPolicies = const [],
    this.penalties = const [],
    this.feeDisqualificationAlert,
    this.numberedAlerts = const [],
    this.detailedContactInfo,
    this.documentChecklist = const [],
    this.abbreviations = const [],
    this.processPitfalls,
    this.strategyCards = const [],
  });
}

class CounsellingFees {
  final String applicationFee;
  final String registrationFee;
  final String securityDeposit;
  final bool isSecurityRefundable;

  const CounsellingFees({
    required this.applicationFee,
    required this.registrationFee,
    required this.securityDeposit,
    required this.isSecurityRefundable,
  });
}

class CounsellingStep {
  final String title;
  final String description;

  const CounsellingStep({
    required this.title,
    required this.description,
  });
}

class EligibilityItem {
  final String title;
  final String subtitle;
  final String description;

  const EligibilityItem({
    required this.title,
    this.subtitle = '',
    this.description = '',
  });
}

class EligibilityCriteria {
  final String title;
  final String subtitle;
  final List<EligibilityItem> items;

  const EligibilityCriteria({
    required this.title,
    this.subtitle = '',
    this.items = const [],
  });
}

class ReservationCategory {
  final String category;
  final String percentage;
  final String description;

  const ReservationCategory({
    required this.category,
    required this.percentage,
    required this.description,
  });
}

class AlertInfo {
  final String title;
  final String description;
  final AlertType type;

  const AlertInfo({
    required this.title,
    required this.description,
    required this.type,
  });
}

enum AlertType {
  critical,
  warning,
  info,
}

class ContactInfo {
  final String officeName;
  final String address;
  final String phone;
  final String email;
  final String website;

  const ContactInfo({
    required this.officeName,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
  });
}

class IntroCardData {
  final IconData icon;
  final Color iconColor;
  final String prefix;
  final String highlight;
  final Color highlightColor;
  final bool isHighlightBold;
  final String suffix;

  const IntroCardData({
    required this.icon,
    this.iconColor = Colors.blue,
    this.prefix = '',
    this.highlight = '',
    this.highlightColor = Colors.orange,
    this.isHighlightBold = true,
    this.suffix = '',
  });
}

class RoundProcessData {
  final String badgeText;
  final String title;
  final Color themeColor;
  final List<RoundStepData> steps;

  const RoundProcessData({
    required this.badgeText,
    required this.title,
    required this.themeColor,
    required this.steps,
  });
}

class RoundStepData {
  final String text;
  final RoundStepType type;

  const RoundStepData({
    required this.text,
    this.type = RoundStepType.normal,
  });
}

enum RoundStepType {
  normal,
  warning,
  error,
}

class ReRegistrationInfo {
  final String title;
  final Color themeColor;
  final IconData? icon;
  final List<String> points;

  const ReRegistrationInfo({
    required this.title,
    required this.themeColor,
    this.icon,
    required this.points,
  });
}

class SeatDistributionInfo {
  final String title;
  final Color themeColor;
  final List<String> distributionPoints;
  final String highlightBoxText;

  const SeatDistributionInfo({
    required this.title,
    required this.themeColor,
    required this.distributionPoints,
    required this.highlightBoxText,
  });
}

class PercentileData {
  final String percentile;
  final String category;
  final String description;
  final Color themeColor;

  const PercentileData({
    required this.percentile,
    required this.category,
    required this.description,
    required this.themeColor,
  });
}

class CoreRequirementData {
  final String title;
  final IconData icon;
  final Color themeColor;
  final List<RequirementRow> rows;

  const CoreRequirementData({
    required this.title,
    required this.icon,
    required this.themeColor,
    required this.rows,
  });
}

class RequirementRow {
  final String label;
  final String value;
  final bool isValueHighlight;
  final Color? highlightColor;

  const RequirementRow({
    required this.label,
    required this.value,
    this.isValueHighlight = false,
    this.highlightColor,
  });
}

class EligibilityHighlightData {
  final String title;
  final String content;
  final Color themeColor;
  final IconData icon;
  final List<String>? tags;

  const EligibilityHighlightData({
    required this.title,
    required this.content,
    required this.themeColor,
    required this.icon,
    this.tags,
  });
}

class ConstitutionalReservationData {
  final String title;
  final String subtitle;
  final List<ReservationBarRow> rows;

  const ConstitutionalReservationData({
    required this.title,
    required this.subtitle,
    required this.rows,
  });
}

class ReservationBarRow {
  final String label;
  final String abbreviation;
  final double percentage;
  final Color themeColor;

  const ReservationBarRow({
    required this.label,
    required this.abbreviation,
    required this.percentage,
    required this.themeColor,
  });
}

class RuleHighlightData {
  final String title;
  final String content;
  final Color themeColor;
  final IconData icon;

  const RuleHighlightData({
    required this.title,
    required this.content,
    required this.themeColor,
    required this.icon,
  });
}

class DetailedReservationCategory {
  final String title;
  final String description;
  final Color themeColor;

  const DetailedReservationCategory({
    required this.title,
    required this.description,
    required this.themeColor,
  });
}

class ApplicationFeeData {
  final String title;
  final List<FeeRow> rows;
  final String? footnote;
  final Color themeColor;

  const ApplicationFeeData({
    required this.title,
    required this.rows,
    this.footnote,
    required this.themeColor,
  });
}

class FeeRow {
  final String label;
  final int amount;
  final bool isTotal;

  const FeeRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });
}

class FeeRefundPolicyData {
  final String title;
  final List<String> points;
  final Color themeColor;
  final IconData icon;

  const FeeRefundPolicyData({
    required this.title,
    required this.points,
    required this.themeColor,
    required this.icon,
  });
}

class PenaltyCardData {
  final String title;
  final String description;
  final String penaltyAmount;
  final Color themeColor;

  const PenaltyCardData({
    required this.title,
    required this.description,
    required this.penaltyAmount,
    required this.themeColor,
  });
}

enum AlertSeverity { critical, warning, note }

class NumberedAlertData {
  final String title;
  final String content;
  final AlertSeverity severity;
  final int number;

  const NumberedAlertData({
    required this.title,
    required this.content,
    required this.severity,
    required this.number,
  });

  Color get themeColor {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFEF4444); // Red
      case AlertSeverity.warning:
        return const Color(0xFFEAB308); // Yellow
      case AlertSeverity.note:
        return const Color(0xFF22C55E); // Green
    }
  }

  String get severityLabel {
    switch (severity) {
      case AlertSeverity.critical:
        return "CRITICAL";
      case AlertSeverity.warning:
        return "WARNING";
      case AlertSeverity.note:
        return "NOTE";
    }
  }
}

class DetailedContactInfo {
  final String officeName;
  final String address;
  final String phone;
  final String email;
  final String websiteUrl;
  final String feeStructureUrl;

  const DetailedContactInfo({
    required this.officeName,
    required this.address,
    required this.phone,
    required this.email,
    required this.websiteUrl,
    required this.feeStructureUrl,
  });
}

class DocumentChecklistItem {
  final String name;
  final bool isMandatory;

  const DocumentChecklistItem({
    required this.name,
    this.isMandatory = false,
  });
}

class AbbreviationData {
  final String abbreviation;
  final String fullForm;

  const AbbreviationData({
    required this.abbreviation,
    required this.fullForm,
  });
}

class ProcessPitfallsData {
  final String title;
  final List<String> pitfalls;

  const ProcessPitfallsData({
    required this.title,
    required this.pitfalls,
  });
}

class StrategyCardData {
  final IconData icon;
  final String title;
  final String description;
  final Color themeColor;

  const StrategyCardData({
    required this.icon,
    required this.title,
    required this.description,
    required this.themeColor,
  });
}