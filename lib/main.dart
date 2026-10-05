import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_cubit.dart';
import 'shell.dart';
import 'theme.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => AppCubit(),
    child: BlocBuilder<AppCubit, AppState>(
      buildWhen: (a, b) => a.theme != b.theme,
      builder: (context, s) => MaterialApp(
        title: 'IAA Kempten',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: s.theme,
        home: const Shell(),
      ),
    ),
  );
}
