
class Detalles{
  late int cantidad;
  late String nombreProducto;
  late String valorBase;
  late int valorTotal;

  Detalles({
    required this.cantidad,
    required this.nombreProducto,
    required this.valorBase,
    required this.valorTotal,
  });
  
  factory Detalles.fromJson(Map<String, dynamic> json) {
    return Detalles(
      cantidad: json['Cantidad'] as int,
      nombreProducto: json['ItemNombre'] as String,
      valorBase: json['ValorBaseUni'] as String,
      valorTotal: json['ValorTotal'] as int,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'Cantidad': cantidad,
      'ItemNombre': nombreProducto,
      'ValorBaseUni': valorBase,
      'ValorTotal': valorTotal,
    };
  }



}