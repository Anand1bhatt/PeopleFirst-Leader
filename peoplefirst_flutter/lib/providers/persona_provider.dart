import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/persona.dart';

class PersonaNotifier extends StateNotifier<Persona> {
  PersonaNotifier() : super(Persona.leader);

  void switchTo(PersonaType type) {
    state = type == PersonaType.leader ? Persona.leader : Persona.employee;
  }

  void togglePersona() {
    state = state.type == PersonaType.leader ? Persona.employee : Persona.leader;
  }
}

final personaProvider = StateNotifierProvider<PersonaNotifier, Persona>(
  (ref) => PersonaNotifier(),
);

final isLeaderProvider = Provider<bool>(
  (ref) => ref.watch(personaProvider).type == PersonaType.leader,
);
