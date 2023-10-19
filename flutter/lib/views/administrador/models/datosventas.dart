class Datosventas {
  late int totalOrdenes;
  late String totalVenta;

  Datosventas({
    required this.totalOrdenes,
    required this.totalVenta,
  });

  factory Datosventas.fromJson(Map<String, dynamic> json) {
    return Datosventas(
      totalOrdenes: json['TotalOrdenes'] as int,
      totalVenta: json['TotalVenta'] as String,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'TotalOrdenes': totalOrdenes,
      'Totalventa': totalVenta,
    };
  }
}