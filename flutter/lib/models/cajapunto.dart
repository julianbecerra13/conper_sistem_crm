class CajaPunto{

  late String idpunto;
  late String nombrepunto;
  late int totalordenes;
  late int totalventa;


  CajaPunto({
    required this.idpunto,
    required this.nombrepunto,
    required this.totalordenes,
    required this.totalventa,
  });

  factory CajaPunto.fromJson(Map<String, dynamic> json) {
    return CajaPunto(
      idpunto: json['IDPunto'] as String,
      nombrepunto: json['NombrePunto'] as String,
      totalordenes: json['TotalOrdenes'] as int,
      totalventa: json['TotalVenta'] as int,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'IDPunto': idpunto,
      'NombrePunto': nombrepunto,
      'TotalOrdenes': totalordenes,
      'TotalVenta': totalventa,
    };
  }
}