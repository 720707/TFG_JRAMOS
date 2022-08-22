import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../../configuracion/configuracion.dart';
import '../../../../datos/datos.dart';

///Autor: Javier Ramos Marco
/// * Listado de las listas de asistencia de una asignatura
/// * con la opcion de editar la lista de asistencia
///

class ListadoListasAsistencia extends StatelessWidget {
  final UsuarioAutenticado _usuario;
  final Asignatura _asignatura;
  const ListadoListasAsistencia({
    Key? key,
    required this.listasAsistencia,
    required UsuarioAutenticado usuario,
    required Asignatura asignatura,
  })  : _usuario = usuario,
        _asignatura = asignatura,
        super(key: key);

  final List<ListaAsistenciasMes> listasAsistencia;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: listasAsistencia.map((listaAsistenciasMes) {
      String mes = DateFormat.MMMM()
          .format(listaAsistenciasMes.listaAsistenciasDia.first.fecha);
      List<ListaAsistenciasDia> listaOrdenada =
          listaAsistenciasMes.listaAsistenciasDia;
      listaOrdenada.sort((a, b) => a.fecha.compareTo(b.fecha));
      return Card(
        key: Key(listaAsistenciasMes.idListaAsistenciasMes),
        child: ListTile(
          title: ExpansionTile(
            title: Text("${mes.toUpperCase()} - ${listaAsistenciasMes.anyo}"),
            children: [
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: listaOrdenada.map((listaAsistenciasDiaConcreto) {
                  return Card(
                    key: Key(listaAsistenciasDiaConcreto.idListaAsistenciasDia),
                    child: Slidable(
                      key: Key(
                          listaAsistenciasDiaConcreto.idListaAsistenciasDia),
                      endActionPane:
                          ActionPane(motion: const ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.of(context).pushNamed(
                              listaAsistenciasConcretaRuta,
                              arguments: ArgumentosPantalla(
                                  usuario: _usuario,
                                  listaAsistenciasDia:
                                      listaAsistenciasDiaConcreto,
                                  asignatura: _asignatura,
                                  editable: true,
                                  asignaturaSinEditar: _asignatura),
                            );
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Editar',
                        ),
                      ]),
                      child: ListTile(
                        title: Text(
                            "Dia: ${listaAsistenciasDiaConcreto.fecha.day.toString()}"),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              listaAsistenciasConcretaRuta,
                              arguments: ArgumentosPantalla(
                                  listaAsistenciasDia:
                                      listaAsistenciasDiaConcreto,
                                  usuario: _usuario,
                                  asignatura: _asignatura));
                        },
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      );
    }).toList());
  }
}
