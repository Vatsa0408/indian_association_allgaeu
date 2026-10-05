import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indian_association_allgaeu/app_cubit.dart';
import 'package:indian_association_allgaeu/data.dart';
import 'package:indian_association_allgaeu/screens/events.dart';

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

  testWidgets('EventTimeline shows Diwali slots in EN and DE', (tester) async {
    final cubit = AppCubit();
    final timeline = events.first.timeline;
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: EventTimeline(timeline)),
          ),
        ),
      ),
    );
    expect(find.text('Diwali Puja'), findsOneWidget);
    expect(find.text('Tea & refreshments'), findsOneWidget);
    expect(find.text('15:00\n16:00'), findsOneWidget);

    cubit.setLang('de');
    await tester.pump();
    expect(find.text('Diwali-Puja'), findsOneWidget);
    expect(find.text('Festliches Abendessen'), findsOneWidget);
    await cubit.close();
  });
}
