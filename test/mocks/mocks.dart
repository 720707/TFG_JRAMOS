import 'package:bloc_test/bloc_test.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/asignatura/asignatura_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/autenticacion/autenticacion_state.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/calendario/calendario_bloc.dart';
import 'package:control_asistencia_tfg_jrm/control/bloc/listas_asistencia/listas_asistencia_bloc.dart';
import 'package:control_asistencia_tfg_jrm/recursos/recursos.dart';
import 'package:control_asistencia_tfg_jrm/utilidades/crear_clases.dart';
import 'package:control_asistencia_tfg_jrm/utilidades/generar_pdf.dart';
import 'package:control_asistencia_tfg_jrm/utilidades/procesamiento_excel.dart';
import 'package:mocktail/mocktail.dart';

class MockRepositorioAlumnos extends Mock implements RepositorioAlumnos {}

class MockGeneradorPDF extends Mock implements GeneradorPdf {}

class MockGeneradorClases extends Mock implements GeneradorClases {}

class MockRepositorioListasAsistencia extends Mock
    implements RepositorioListasAsistencia {}

class MockRepositorioClases extends Mock implements RepositorioClases {}

class MockProcesadorExcel extends Mock implements ProcesadorExcel {}

class MockRepositorioAsignaturas extends Mock
    implements RepositorioAsignaturas {}

class MockRepositorioAutenticacion extends Mock
    implements RepositorioAutenticacion {}

class MockAutenticacionBloc
    extends MockBloc<EventoAutenticacion, EstadoAutenticacion>
    implements AutenticacionBloc {}

class MockCalendarioBloc extends MockBloc<EventoCalendario, EstadoCalendario>
    implements CalendarioBloc {}

class MockAsignaturaBloc extends MockBloc<EventoAsignatura, EstadoAsignatura>
    implements AsignaturaBloc {}

class MockListasAsistenciaBloc
    extends MockBloc<EventoListasAsistencia, EstadoListasAsistencia>
    implements ListasAsistenciaBloc {}

class MockProveedorAutenticacion extends Mock
    implements ProveedorAutenticacion {}

class MockProveedorClases extends Mock implements ProveedorClases {}

class MockProveedorListasAsistencia extends Mock
    implements ProveedorListasAsistencia {}

class MockProveedorAlumnos extends Mock implements ProveedorAlumnos {}

class MockProveedorAsignaturas extends Mock implements ProveedorAsignaturas {}
