import 'package:equatable/equatable.dart';

class AlumnoPDF extends Equatable {
  final String nipAlumno;
  final String nombreCompleto;
  final Map<String, String> asistencias;

  const AlumnoPDF({
    required this.nipAlumno,
    required this.nombreCompleto,
    required this.asistencias,
  });

  @override
  List<Object?> get props => [nipAlumno, nombreCompleto];
}
