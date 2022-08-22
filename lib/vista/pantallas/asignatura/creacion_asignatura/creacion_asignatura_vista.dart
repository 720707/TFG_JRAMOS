import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../../../datos/datos.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../control/bloc/asignatura/asignatura_bloc.dart';
import '../../../widgets/widgets.dart';
import '../../pantallas.dart';

///Autor: Javier Ramos Marco
/// * Vista para crear la asignatura
///

class CreacionAsignaturaVista extends StatefulWidget {
  final UsuarioAutenticado _usuario;

  const CreacionAsignaturaVista({required UsuarioAutenticado usuario, Key? key})
      : _usuario = usuario,
        super(key: key);

  @override
  State<CreacionAsignaturaVista> createState() =>
      _CreacionAsignaturaVistaState();
}

class _CreacionAsignaturaVistaState extends State<CreacionAsignaturaVista> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<String> dias = [];
  List<Alumno> _alumnos = [];
  DateTime dActual = DateTime.now();

  @override
  void initState() {
    var diaActual = DateFormat('yyyy-MM-dd').format(dActual);
    dActual = DateTime.parse(diaActual);
    super.initState();
  }

  void cambiarEstado() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final altura =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final espacio = altura > 650 ? espacioM : espacioS;

    return BlocListener<AsignaturaBloc, EstadoAsignatura>(
      listener: (context, state) {
        if (state is AlumnosCargados) {
          MiSnackBar.informacionSnackBar(context, textoAlumnosAnyadidos);
          setState(() {
            _alumnos = state.alumnos;
          });
        } else if (state is AsignaturaCargada) {
          MiSnackBar.informacionSnackBar(context, textoAsignaturaAnyadida);
          context.read<AsignaturaBloc>().add(CrearClases(
                alumnos: state.alumnos,
                asignatura: state.asignatura,
              ));
        } else if (state is AsignaturaError) {
          MiSnackBar.informacionSnackBar(context, state.mensaje);
        }
      },
      child: GestureDetector(
        //Para que el teclado desparezca cuando pulsamos cualquier parte de la pantalla
        //que no es el campo de texto (se tiene que usar el Widget GestureDetector)
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: MiAppBar(
            titulo: tituloAnyadirAsignatura,
            ruta: calendarioRuta,
            argumentos: widget._usuario,
          ),
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    SizedBox(height: espacio / 2),
                    CampoTextoFormulario(
                        key: const Key("nombre_asignatura"),
                        nombreCampo: "nombre asignatura",
                        pista: textoNombreAsignatura,
                        validador: FormBuilderValidators.required()),
                    const Divider(),
                    CampoTextoFormulario(
                        key: const Key("grado_asignatura"),
                        nombreCampo: "grado asignatura",
                        pista: textoGradoAsignatura,
                        validador: FormBuilderValidators.required()),
                    SizedBox(height: espacio * 2),
                    const Text(textoSeleccionarFechaInicio),
                    FechaInicio(
                      dActual: dActual,
                    ),
                    SizedBox(height: espacio),
                    const Text(textoSeleccionarFechaFin),
                    FechaFin(
                      formKey: _formKey,
                      dActual: dActual,
                    ),
                    SizedBox(height: espacio),
                    const Text(
                        'Selecciona los dias en los que se imparte la asignatura'),
                    SizedBox(height: espacio),
                    FormBuilderCheckboxGroup<String>(
                      name: "dias",
                      options: const [
                        FormBuilderFieldOption(value: "lunes"),
                        FormBuilderFieldOption(value: "martes"),
                        FormBuilderFieldOption(value: "miércoles"),
                        FormBuilderFieldOption(value: "jueves"),
                        FormBuilderFieldOption(value: "viernes")
                      ],
                      onChanged: (values) {
                        dias.clear();
                        values?.forEach((e) => dias.add(e));
                        setState(() {});
                      },
                      validator: FormBuilderValidators.minLength(1,
                          errorText: comprobarDiasAsignatura),
                    ),
                    SizedBox(height: espacio * 2),
                    BotonGenerico(
                      texto: textoCargarListaAlumnos,
                      onPressed: () {
                        context.read<AsignaturaBloc>().add(
                              const CargarListaAlumnos(),
                            );
                      },
                    ),
                    SizedBox(height: espacio),
                    BotonCrearAsignatura(
                      formKey: _formKey,
                      alumnos: _alumnos,
                      widget: widget,
                      usuario: widget._usuario,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
