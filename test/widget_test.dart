import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:indian_association_allgaeu/app_cubit.dart';

void main() {
  test('AppCubit changes screen, lang, theme and event filter', () {
    final c = AppCubit();
    expect(c.state.screen, Screen.home);

    c.setScreen(Screen.events);
    c.setLang('de');
    c.toggleTheme();
    c.setEventFilter('past');

    expect(c.state.screen, Screen.events);
    expect(c.state.lang, 'de');
    expect(c.state.theme, ThemeMode.light);
    // no past events, so the selection stays on the upcoming one
    expect(c.state.selectedEventId, 'diwali26');
    c.close();
  });
}
