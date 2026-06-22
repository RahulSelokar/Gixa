class AddonContactModel {
  final String addonContact;
  final String addonWhatsappLink;

  AddonContactModel({
    required this.addonContact,
    required this.addonWhatsappLink,
  });

  factory AddonContactModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return AddonContactModel(
      addonContact: data['addon_contact'] ?? '',
      addonWhatsappLink: data['addon_whatsapp_link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addon_contact': addonContact,
      'addon_whatsapp_link': addonWhatsappLink,
    };
  }
}
