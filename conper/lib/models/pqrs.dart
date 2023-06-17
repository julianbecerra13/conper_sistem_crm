class Pqr{

  late int idcaso;
  late String fechaCaso;
  late String responsableEncargado;
  late String tipo;
  late String requerimientoCliente;
  late String gestionaRealizar;
  late String respuestaResponsable;

  Pqr({
    required this.idcaso,
    required this.fechaCaso,
    required this.responsableEncargado,
    required this.tipo,
    required this.requerimientoCliente,
    required this.gestionaRealizar,
    required this.respuestaResponsable,
  });

  factory Pqr.fromJson(Map<String,dynamic> json){
    return Pqr(
      idcaso: json['IDcaso'] as int,
      fechaCaso: json['FechaCaso'] as String,
      responsableEncargado: json['ResponsableEncargado'],
      tipo: json['Tipo'] as String,
      requerimientoCliente: json['RequerimientoCliente'] as String,
      gestionaRealizar: json['GestionaRealizar'] as String,
      respuestaResponsable: json['RespuestaResponsable'] as String,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IDcaso' : idcaso,
      'FechaCaso' : fechaCaso,
      'ResponsableEncargado' : responsableEncargado,
      'Tipo' : tipo,
      'RequerimientoCliente' : requerimientoCliente,
      'GestionaRealizar' : gestionaRealizar,
      'RespuestaResponsable' : respuestaResponsable,
    };
  }

}