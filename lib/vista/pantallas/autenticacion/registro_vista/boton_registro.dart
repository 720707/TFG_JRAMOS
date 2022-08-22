import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../control/bloc/autenticacion/autenticacion_bloc.dart';

class RegistroBoton extends StatelessWidget {
  const RegistroBoton({
    Key? key,
    required GlobalKey<FormBuilderState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        key: const Key("registro_boton"),
        onPressed: () {
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            context.read<AutenticacionBloc>().add(
                  RegistrarUsuario(
                    correo: _formKey.currentState!.fields['correo']?.value,
                    password: _formKey.currentState!.fields['password']?.value,
                  ),
                );
            _formKey.currentState!.reset();
          }
        },
        child: const Text(registrarUsuario));
  }
}
