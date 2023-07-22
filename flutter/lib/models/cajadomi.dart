class CajaDomis {
  late String nombreMovil;
  late String nombrePunto;
  late String nombreTipoPago;
  late int totalFP; // Cambiar el tipo de String a int
  late int totalOrdenes;
  late double valorFP; // Cambiar el tipo de String a double

  CajaDomis({
    required this.nombreMovil,
    required this.nombrePunto,
    required this.nombreTipoPago,
    required this.totalFP,
    required this.totalOrdenes,
    required this.valorFP,
  });

  factory CajaDomis.fromJson(Map<String, dynamic> json) {
    return CajaDomis(
      nombreMovil: json['NombreMovil'] as String,
      nombrePunto: json['NombrePunto'] as String,
      nombreTipoPago: json['NombreTipoPago'] as String,
      totalFP: int.parse(json['TotalFp'] as String), // Convertir a int
      totalOrdenes: json['TotalOrdenes'] as int,
      valorFP: double.parse(json['TotalVenta'].toString()), // Convertir a double
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'nombreMovil': nombreMovil,
      'nombrePunto': nombrePunto,
      'nombreTipoPago': nombreTipoPago,
      'totalFP': totalFP,
      'totalOrdenes': totalOrdenes,
      'valorFP': valorFP,
    };
  }
}
