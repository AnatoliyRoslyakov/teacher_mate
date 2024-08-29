part of 'student_bloc.dart';

sealed class StudentEvent {
  const StudentEvent();

  const factory StudentEvent.create(
    String name,
    int price,
    String tgName,
  ) = StudentCreateEvent;

  const factory StudentEvent.read() = StudentReadEvent;

  const factory StudentEvent.update(
    int id,
    String name,
    int price,
    String tgName,
  ) = StudentUpdateEvent;

  const factory StudentEvent.delete(
    int id,
  ) = StudentDeleteEvent;
}

class StudentCreateEvent extends StudentEvent {
  final String name;
  final int price;
  final String tgName;
  const StudentCreateEvent(this.name, this.price, this.tgName);
}

class StudentReadEvent extends StudentEvent {
  const StudentReadEvent();
}

class StudentUpdateEvent extends StudentEvent {
  final int id;
  final String name;
  final int price;
  final String tgName;
  const StudentUpdateEvent(this.id, this.name, this.price, this.tgName);
}

class StudentDeleteEvent extends StudentEvent {
  final int id;
  const StudentDeleteEvent(
    this.id,
  );
}
