import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data.dart';

enum Screen { home, events, gallery, contact, more }

class AppState {
  final Screen screen;
  final ThemeMode theme;
  final String lang; // 'en' | 'de'
  final String eventFilter; // 'upcoming' | 'past'
  final String selectedEventId;
  final String galleryFilter; // 'all' or a category key

  const AppState({
    this.screen = Screen.home,
    this.theme = ThemeMode.dark,
    this.lang = 'en',
    this.eventFilter = 'upcoming',
    this.selectedEventId = 'diwali26',
    this.galleryFilter = 'all',
  });

  AppState copyWith({
    Screen? screen,
    ThemeMode? theme,
    String? lang,
    String? eventFilter,
    String? selectedEventId,
    String? galleryFilter,
  }) => AppState(
    screen: screen ?? this.screen,
    theme: theme ?? this.theme,
    lang: lang ?? this.lang,
    eventFilter: eventFilter ?? this.eventFilter,
    selectedEventId: selectedEventId ?? this.selectedEventId,
    galleryFilter: galleryFilter ?? this.galleryFilter,
  );
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void setScreen(Screen s) => emit(state.copyWith(screen: s));

  void toggleTheme() => emit(
    state.copyWith(
      theme: state.theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    ),
  );

  void setLang(String lang) => emit(state.copyWith(lang: lang));

  // Also selects the first event of that filter so the detail pane matches the list.
  void setEventFilter(String filter) => emit(
    state.copyWith(
      eventFilter: filter,
      selectedEventId:
          events.where((e) => e.status == filter).firstOrNull?.id ??
          state.selectedEventId,
    ),
  );

  void selectEvent(String id) => emit(state.copyWith(selectedEventId: id));

  void setGalleryFilter(String f) => emit(state.copyWith(galleryFilter: f));

  // Jump to the Events screen with [e] selected.
  void openEvent(Event e) => emit(
    state.copyWith(
      screen: Screen.events,
      eventFilter: e.status,
      selectedEventId: e.id,
    ),
  );
}
