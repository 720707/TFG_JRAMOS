import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../control/bloc/autenticacion/autenticacion_bloc.dart';

///Autor: Javier Ramos Marco
/// * Boton que envia evento para crear una nueva contraseña
///

class NuevaPasswordBoton extends StatelessWidget {
  const NuevaPasswordBoton({
    Key? key,
    required GlobalKey<FormBuilderState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            context.read<AutenticacionBloc>().add(
                  NuevaPassword(
                    correo: _formKey.currentState!.fields['correo']?.value,
                  ),
                );
            _formKey.currentState!.reset();
          }
        },
        child: const Text(resetPassword));
  }
}
