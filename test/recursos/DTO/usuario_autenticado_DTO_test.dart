import 'package:control_asistencia_tfg_jrm/datos/datos.dart';
import 'package:control_asistencia_tfg_jrm/recursos/DTO/DTO.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const usuarioAutenticadoDTO = UsuarioAutenticadoDTO(
      id: '434', email: 'prueba@gmail.com', emailVerificado: true);
  const usuarioAutenticadoEntidad = UsuarioAutenticado(
      email: 'prueba@gmail.com', emailVerificado: true, id: '434');
  group('usuario autenticado DTO ...', () {
    test('UsuarioAutenticadoDTO es un subtipo de UsuarioAutenticado', () {
      expect(usuarioAutenticadoDTO, isA<UsuarioAutenticado>());
    });

    test('toEntity', () {
      final resultado = usuarioAutenticadoDTO.toEntity();
      expect(resultado, usuarioAutenticadoEntidad);
    });

    test('formEntity', () {
      final resultado =
          UsuarioAutenticadoDTO.fromEntity(usuarioAutenticadoEntidad);
      expect(resultado, usuarioAutenticadoDTO);
    });
  });
}
