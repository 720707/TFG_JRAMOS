import '../../../configuracion/constantes/rutas.dart';
import '../../../datos/datos.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

///Autor: Javier Ramos Marco
/// * Vista con las distintas opciones que se pueden relizar con la asignatura
///

class OpcionesAsignaturaVista extends StatefulWidget {
  final Asignatura _asignatura;
  final UsuarioAutenticado _usuario;
  const OpcionesAsignaturaVista(
      {required Asignatura asignatura,
      required UsuarioAutenticado usuario,
      Key? key})
      : _usuario = usuario,
        _asignatura = asignatura,
        super(key: key);

  @override
  State<OpcionesAsignaturaVista> createState() =>
      _OpcionesAsignaturaVistaState();
}

class _OpcionesAsignaturaVistaState extends State<OpcionesAsignaturaVista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MiAppBar(
        titulo:
            "${widget._asignatura.nombreAsignatura} ${widget._asignatura.nombreGrado} ${widget._asignatura.fechaInicio.year}",
        ruta: listarAsignaturasRuta,
        argumentos: widget._usuario,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              children: <Widget>[
                Column(
                  children: [
                    ElevatedBotonIrARuta(
                      ruta: listasAsistenciasAsignaturaRuta,
                      texto: 'Consultar Listas Asistencia',
                      argumentos: ArgumentosPantalla(
                          asignatura: widget._asignatura,
                          usuario: widget._usuario),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    ElevatedBotonIrARuta(
                      ruta: listaMesesRuta,
                      texto: 'Generar PDF',
                      argumentos: ArgumentosPantalla(
                          asignatura: widget._asignatura,
                          usuario: widget._usuario),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
