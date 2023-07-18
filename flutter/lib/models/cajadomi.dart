
class CajaDomis{
  late String nombreMovil;
  late String nombrePunto;
  late String nombreTipoPago;
  late int totalOrdenes;
  late int totalVenta;

  CajaDomis({
    required this.nombreMovil,
    required this.nombrePunto,
    required this.nombreTipoPago,
    required this.totalOrdenes,
    required this.totalVenta,
  });

  factory CajaDomis.fromJson(Map<String, dynamic> json) {
    return CajaDomis(
      nombreMovil: json['NombreMovil'] as String,
      nombrePunto: json['NombrePunto'] as String,
      nombreTipoPago: json['NombreTipoPago'] as String,
      totalOrdenes: json['TotalOrdenes'] as int,
      totalVenta: json['TotalVenta'] as int,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'NombreMovil': nombreMovil,
      'NombrePunto': nombrePunto,
      'NombreTipoPago': nombreTipoPago,
      'TotalOrdenes': totalOrdenes,
      'TotalVenta': totalVenta,
    };
  }
}