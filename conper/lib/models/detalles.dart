
class Detalles{

  late String nombreProducto;
  late String valorBase;
  late int valorTotal;

  Detalles({
    required this.nombreProducto,
    required this.valorBase,
    required this.valorTotal,
  });
  
  factory Detalles.fromJson(Map<String, dynamic> json) {
    return Detalles(
      nombreProducto: json['ItemNombre'] as String,
      valorBase: json['ValorBaseUni'] as String,
      valorTotal: json['ValorTotal'] as int,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'ItemNombre': nombreProducto,
      'ValorBaseUni': valorBase,
      'ValorTotal': valorTotal,
    };
  }



}