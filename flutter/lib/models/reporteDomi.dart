class ReporteDomis {
  late String nombreMovil;
  late String nombrePunto;
  late int totalOP;
  late String valorFP;

  ReporteDomis({
    required this.nombreMovil,
    required this.nombrePunto,
    required this.totalOP,
    required this.valorFP,
  });

  factory ReporteDomis.fromJson(Map<String, dynamic> json) {
    return ReporteDomis(
      nombreMovil: json['NombreMovil'] as String,
      nombrePunto: json['NombrePunto'] as String,
      totalOP: json['TotalOP'] as int,
      valorFP: json['ValorFP'] as String,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'NombreMovil': nombreMovil,
      'NombrePunto': nombrePunto,
      'TotalOP': totalOP,
      'ValorFP': valorFP,
    };
  }
}
