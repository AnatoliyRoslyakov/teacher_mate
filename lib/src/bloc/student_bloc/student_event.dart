part of 'student_bloc.dart';

sealed class StudentEvent {
  const StudentEvent();

  const factory StudentEvent.create() = StudentCreateEvent;

  const factory StudentEvent.read() = StudentReadEvent;

  const factory StudentEvent.update() = StudentUpdateEvent;

  const factory StudentEvent.delete() = StudentDeleteEvent;
}

class StudentCreateEvent extends StudentEvent {
  const StudentCreateEvent();
}

class StudentReadEvent extends StudentEvent {
  const StudentReadEvent();
}

class StudentUpdateEvent extends StudentEvent {
  const StudentUpdateEvent();
}

class StudentDeleteEvent extends StudentEvent {
  const StudentDeleteEvent();
}
