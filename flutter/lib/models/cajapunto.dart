class CajaPunto{

  late String nombrepunto;
  late String nombreTipoPago;
  late int totalordenes;
  late double totalventa;


  CajaPunto({
    required this.nombrepunto,
    required this.nombreTipoPago,
    required this.totalordenes,
    required this.totalventa,
  });

  factory CajaPunto.fromJson(Map<String, dynamic> json) {
    return CajaPunto(
      nombrepunto: json['NombrePunto'] as String,
      nombreTipoPago: json['NombreTipoPago'] as String,
      totalordenes: json['TotalOrdenes'] as int,
      totalventa: double.parse(json['TotalVenta'].toString()),
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'NombrePunto': nombrepunto,
      'NombreTipoPago': nombreTipoPago,
      'TotalOrdenes': totalordenes,
      'TotalVenta': totalventa,
    };
  }
}