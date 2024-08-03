part of 'student_bloc.dart';

sealed class StudentEvent {
  const StudentEvent();

  const factory StudentEvent.create(
    String name,
    int price,
  ) = StudentCreateEvent;

  const factory StudentEvent.read() = StudentReadEvent;

  const factory StudentEvent.update(
    int id,
    String name,
    int price,
  ) = StudentUpdateEvent;

  const factory StudentEvent.delete(
    int id,
  ) = StudentDeleteEvent;
}

class StudentCreateEvent extends StudentEvent {
  final String name;
  final int price;
  const StudentCreateEvent(this.name, this.price);
}

class StudentReadEvent extends StudentEvent {
  const StudentReadEvent();
}

class StudentUpdateEvent extends StudentEvent {
  final int id;
  final String name;
  final int price;
  const StudentUpdateEvent(this.id, this.name, this.price);
}

class StudentDeleteEvent extends StudentEvent {
  final int id;
  const StudentDeleteEvent(
    this.id,
  );
}
