class CajaDomi{
  late String nombremovil;
  late String nombrepunto;
  late String nombretipopago;
  late int totalordenes;
  late int totalventa;

  CajaDomi({
    required this.nombremovil,
    required this.nombrepunto,
    required this.nombretipopago,
    required this.totalordenes,
    required this.totalventa,
  });

  factory CajaDomi.fromJson(Map<String, dynamic> json) {
    return CajaDomi(
      nombremovil: json['NombreMovil'] as String,
      nombrepunto: json['NombrePunto'] as String,
      nombretipopago: json['NombreTipoPago'] as String,
      totalordenes: json['TotalOrdenes'] as int,
      totalventa: json['TotalVenta'] as int,
    );
  }
  

}