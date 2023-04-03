
class Invoice {
  final int currentYear;
  final double totalDonation;
  final String name;
  final String address;

  Invoice({
    required this.name,
    required this.totalDonation,
    required this.currentYear,
    required this.address,
  });

  Invoice copyWith({
    int? currentYear,
    double? totalDonation,
    String? name,
    String? address,
  }) {
    return Invoice(
      currentYear: currentYear ?? this.currentYear,
      totalDonation: totalDonation ?? this.totalDonation,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }
}
