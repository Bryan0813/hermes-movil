import 'package:flutter/material.dart';
import 'package:hermes/models/index.dart';
import 'package:hermes/presentation/values.dart';
import 'package:hermes/services/index.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  List<PackageModel> packages = [];
  List<ReservationModel> reservations = [];
  List<ProgrammingModel> programming = [];
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadPackages();
    _loadReservations();
    _loadCurrentUser();
  }

  Future<void> _loadPackages() async {
    try {
      final fetchedPackages = await getAllPackages();
      setState(() {
        packages = fetchedPackages;
      });
    } catch (e) {
      throw Exception('Error al cargar los paquetes: $e');
    }
  }

  Future<void> _loadReservations() async {
    try {
      final fetchedReservations = await getAllReservations();
      setState(() {
        reservations = fetchedReservations;
      });
    } catch (e) {
      throw Exception('Error al cargar las reservaciones: $e');
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final userMap = await getCurrentUser();
      final user = UserModel.fromJson(userMap as Map<String, dynamic>);
      setState(() {
        currentUser = user;
      });
      if (currentUser != null) {
        _loadProgrammingByResponsible(user.id);
      }
    } catch (e) {
      throw Exception('Error al cargar el usuario actual: $e');
    }
  }

  Future<void> _loadProgrammingByResponsible(int userId) async {
    try {
      final fetchedProgramming = await getAllByResponsible(userId);
      setState(() {
        programming = fetchedProgramming;
      });
    } catch (e) {
      throw Exception('Error al cargar la programación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalValue,
        vertical: verticalValue,
      ),
      child: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 7,
        dataSource: PackageDataSource(_convertProgrammingToAppointments()),
        onTap: (calendarTapDetails) {
          if (calendarTapDetails.targetElement == CalendarElement.appointment) {
            final appointment =
                calendarTapDetails.appointments!.first as Appointment;
            final package = packages.firstWhere(
              (pkg) =>
                  pkg.id ==
                  programming
                      .firstWhere((prog) => prog.id == appointment.id)
                      .idPackage,
            );
            Navigator.pushNamed(
              context,
              "/package",
              arguments: {'package': package, 'idDate': appointment.id},
            );
          }
        },
      ),
    );
  }

  List<Appointment> _convertProgrammingToAppointments() {
    return programming.map((program) {
      try {
        final package = packages.firstWhere(
          (pkg) => pkg.id == program.idPackage,
        );

        return Appointment(
          id: program.id,
          startTime: program.start,
          endTime: program.end,
          isAllDay: false,
          subject: package.name,
          notes: package.description,
          color: program.status
              ? (package.status ? Colors.lightBlue.shade400 : Colors.red)
              : Colors.grey,
        );
      } catch (e) {
        throw Exception('Error: $e');
      }
    }).toList();
  }
}

class PackageDataSource extends CalendarDataSource {
  PackageDataSource(List<Appointment> source) {
    appointments = source;
  }
}
