import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../control/bloc/asignatura/asignatura_bloc.dart';
import '../../../../datos/datos.dart';
import '../../../widgets/widgets.dart';
import 'creacion_asignatura_vista.dart';

///Autor: Javier Ramos Marco
/// * Boton para crear asignatura
///

class BotonCrearAsignatura extends StatelessWidget {
  final UsuarioAutenticado _usuario;
  const BotonCrearAsignatura({
    Key? key,
    required GlobalKey<FormBuilderState> formKey,
    required List<Alumno> alumnos,
    required UsuarioAutenticado usuario,
    required this.widget,
  })  : _formKey = formKey,
        _alumnos = alumnos,
        _usuario = usuario,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;
  final List<Alumno> _alumnos;
  final CreacionAsignaturaVista widget;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _formKey.currentState!.save();
        if (_alumnos.isNotEmpty) {
          if (_formKey.currentState!.validate()) {
            String fechaInicio = DateFormat('yyyy-MM-dd')
                .format(_formKey.currentState!.fields['fecha inicio']!.value);
            String idAsignatura =
                _formKey.currentState!.fields['nombre asignatura']?.value +
                    _usuario.id +
                    fechaInicio;
            List<String> idAlumnos = [];

            for (Alumno alumno in _alumnos) {
              idAlumnos.add(alumno.nipAlumno);
            }
            Asignatura asignatura = Asignatura(
                idAsignatura: idAsignatura,
                idProfesor: _usuario.id,
                nombreAsignatura:
                    _formKey.currentState!.fields['nombre asignatura']?.value,
                fechaInicio:
                    _formKey.currentState!.fields['fecha inicio']!.value,
                fechaFin: _formKey.currentState!.fields['fecha fin']!.value,
                dias: _formKey.currentState!.fields['dias']?.value,
                nombreGrado:
                    _formKey.currentState!.fields['grado asignatura']?.value,
                idAlumnos: idAlumnos,
                listasAsistenciasMes: const []);

            context.read<AsignaturaBloc>().add(AnyadirAsignatura(
                  asignatura: asignatura,
                  alumnos: _alumnos,
                ));
            _formKey.currentState!.reset();
          }
        } else {
          MiSnackBar.informacionSnackBar(context, comprobarAlumnos);
        }
      },
      child: const Text(textoAnyadirAsignatura),
    );
  }
}
