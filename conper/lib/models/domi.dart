
class Domi{

  late String nombre;
  late String identificacion;
  late int idPunto;
  
  Domi({
    required this.nombre,
    required this.identificacion,
    required this.idPunto,
    
  });

  factory Domi.fromJson(Map<String, dynamic> json) {
    return Domi(
      nombre: json['Nombre'] as String,
      identificacion: json['Identificacion'] as String,
      idPunto: json['IdPunto'] as int,
      
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'Nombre': nombre,
      'Identificacion': identificacion,
      'IdPunto': idPunto,
     
    };
  }



}