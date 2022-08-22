import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../control/bloc/calendario/calendario_bloc.dart';
import '../../../datos/entidades/clase.dart';
import '../../../datos/entidades/usuario_autenticado.dart';
import '../../widgets/widgets.dart';

///Autor: Javier Ramos Marco
/// * Vista del calendario
///

final kHoy = DateTime.now();
final kPrimerDia = DateTime(kHoy.year, kHoy.month - 1, kHoy.day);
final kUltimoDia = DateTime(kHoy.year, kHoy.month + 3, kHoy.day);

class CalendarioVista extends StatefulWidget {
  final UsuarioAutenticado _usuario;
  const CalendarioVista({required UsuarioAutenticado usuario, Key? key})
      : _usuario = usuario,
        super(key: key);

  @override
  State<CalendarioVista> createState() => _CalendarioVistaState();
}

class _CalendarioVistaState extends State<CalendarioVista> {
  CalendarFormat _formatoCalendario = CalendarFormat.month;
  //Esta propiedad permite activar/desactivar elegir varias fechas a la vez
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .disabled; // Can be toggled on/off by longpressing a date
  late LinkedHashMap<DateTime, List<Clase>> _todasClases;
  DateTime _diaEnFoco = DateTime.now(), _diaSeleccionado = DateTime.now();

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _groupEvents(Iterable<Clase> clases) {
    _todasClases = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    for (var clase in clases) {
      DateTime fecha = DateTime.utc(
          clase.diaClase.year, clase.diaClase.month, clase.diaClase.day, 12);
      if (_todasClases[fecha] == null) _todasClases[fecha] = [];
      _todasClases[fecha]?.add(clase);
    }
  }

  List<Clase> _obtenerClasesDia(DateTime fecha) {
    return _todasClases[fecha] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<CalendarioBloc>()
        .add(CargarClasesUsuario(idUsuario: widget._usuario.id));
    return SingleChildScrollView(
      child: BlocBuilder<CalendarioBloc, EstadoCalendario>(
          builder: (context, state) {
        if (state is ClasesCargadas) {
          return StreamBuilder(
            stream: state.clases,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final events = snapshot.data as Iterable<Clase>;
                _groupEvents(events);
                DateTime diaSeleccionado = _diaSeleccionado;
                final eventosSeleccionados =
                    _todasClases[diaSeleccionado] ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _crearCalendario(),
                    ClasesDia(
                      eventosSeleccionados: eventosSeleccionados,
                      usuario: widget._usuario,
                    ),
                  ],
                );
              } else {
                return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator());
              }
            },
          );
        }
        return const CircularProgressIndicator();
      }),
    );
  }

  Card _crearCalendario() {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(8.0),
      child: TableCalendar<Clase>(
        availableCalendarFormats: const {
          CalendarFormat.month: 'Mes',
          CalendarFormat.twoWeeks: '2 semanas',
          CalendarFormat.week: 'semana',
        },
        locale: 'es_ES',
        rowHeight: 60.0,
        weekendDays: const [DateTime.saturday, DateTime.sunday],
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.red),
        ),
        firstDay: kPrimerDia,
        lastDay: kUltimoDia,
        //Dia que se selecciona por defecto, esta puesto que sea el dia actual
        focusedDay: _diaEnFoco,
        //Interactividad para seleccionar un dia
        selectedDayPredicate: (dia) => isSameDay(_diaSeleccionado, dia),
        calendarFormat: _formatoCalendario,
        rangeSelectionMode: _rangeSelectionMode,
        eventLoader: _obtenerClasesDia,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: const CalendarStyle(
          weekendTextStyle: TextStyle(color: Colors.red),
          outsideDaysVisible: false,
        ),
        //Estilo de la cabezera (Donde esta el mes)
        headerStyle: const HeaderStyle(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 163, 193, 218),
            ),
            headerMargin: EdgeInsets.only(bottom: 8.0)),
        onDaySelected: (diaSeleccionado, diaEnFoco) {
          setState(() {
            _diaSeleccionado = diaSeleccionado;
            _diaEnFoco = diaEnFoco;
          });
        },

        onFormatChanged: (formato) {
          if (_formatoCalendario != formato) {
            setState(() {
              _formatoCalendario = formato;
            });
          }
        },
        onPageChanged: (diaEnFoco) {
          _diaEnFoco = diaEnFoco;
        },
      ),
    );
  }
}
