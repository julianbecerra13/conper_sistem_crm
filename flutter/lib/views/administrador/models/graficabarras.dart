class ReporteMensual {
  final String mes;
  final String ventaEfectiva;
  final String ventaCancelada;
  final String totalVenta;

  ReporteMensual({
    required this.mes,
    required this.ventaEfectiva,
    required this.ventaCancelada,
    required this.totalVenta,
  });

  factory ReporteMensual.fromJson(Map<String, dynamic> json) {
    return ReporteMensual(
      mes: json['Mes'],
      ventaEfectiva: json['VentaEfectiva'],
      ventaCancelada: json['VentaCancelada'],
      totalVenta: json['TotalVenta'],
    );
  }
}
