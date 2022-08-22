import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

///Autor: Javier Ramos Marco
/// * Widget para insertar texto a un formulario
///

class CampoTextoFormulario extends StatelessWidget {
  final String _nombreCampo;
  final String _pista;
  final Icon? icono;
  final TextInputType? tipoTeclado;
  final bool? esPassword;
  final String? Function(String?)? _validador;
  const CampoTextoFormulario({
    required String nombreCampo,
    required String pista,
    this.icono,
    this.tipoTeclado = TextInputType.text,
    this.esPassword = false,
    required String? Function(String?)? validador,
    Key? key,
  })  : _nombreCampo = nombreCampo,
        _pista = pista,
        _validador = validador,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: _nombreCampo,
      decoration: InputDecoration(hintText: _pista, prefixIcon: icono),
      keyboardType: tipoTeclado,
      obscureText: esPassword!,
      validator: _validador,
    );
  }
}
