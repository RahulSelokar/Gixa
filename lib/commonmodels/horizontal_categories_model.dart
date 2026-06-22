class HorizontalReservationModel {
  final String reservationName;
  final String reservationCode;
  final String? description;

  HorizontalReservationModel({
    required this.reservationName,
    required this.reservationCode,
    this.description,
  });

  factory HorizontalReservationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizontalReservationModel(
      reservationName: json['reservation_name'] ?? '',
      reservationCode: json['reservation_code'] ?? '',
      description: json['description'],
    );
  }
}