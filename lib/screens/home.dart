import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_cubit.dart';
import '../data.dart';
import '../shell.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final cubit = context.read<AppCubit>();
    final next = events.firstWhere((e) => e.status == 'upcoming');
    final sub = TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant);

    Widget iconText(IconData icon, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Flexible(child: Text(text, style: sub)),
      ],
    );

    // TODO: "Become a member" quick button hidden for now; re-enable later.
    // Widget quick(
    // Color bg,
    // Color fg,
    // IconData icon,
    // String label,
    // VoidCallback onTap,
    // ) => Expanded(
    // child: Box(
    // color: bg,
    // fg: fg,
    // radius: 22,
    // padding: const EdgeInsets.all(16),
    // onTap: onTap,
    // child: Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: [
    // Icon(icon, size: 24),
    // const SizedBox(height: 8),
    // Text(label, style: qs(13, w: FontWeight.w600)),
    // ],
    // ),
    // ),
    // );

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const Photo(radius: 0),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xB8000000)],
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  bottom: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.t('appName'),
                        style: qs(26).copyWith(color: Colors.white),
                      ),
                      Text(
                        context.t('heroTagline'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFF2E9DF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Portrait: WhatsApp lives in the shell's FAB instead.
        if (!context.compact) ...[
          const SizedBox(height: 16),
          whatsappBanner(context),
        ],
        // const SizedBox(height: 12),
        // Row(
        // children: [
        // quick(
        // cs.primaryContainer,
        // cs.onPrimaryContainer,
        // Icons.volunteer_activism,
        // context.t('quickBecomeMember'),
        // () => cubit.setScreen(Screen.more),
        // ),
        // ],
        // ),
      ],
    );

    final right = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.t('aboutHeading'), style: qs(17)),
        const SizedBox(height: 8),
        Text(
          context.t('aboutBody'),
          style: TextStyle(
            fontSize: 14.5,
            height: 1.6,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Text(context.t('upcomingHeading'), style: qs(17))),
            InkWell(
              onTap: () => cubit.setScreen(Screen.events),
              child: Text(
                context.t('seeAllEvents'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Box(
          color: cs.surfaceContainer,
          radius: 22,
          padding: const EdgeInsets.all(12),
          onTap: () => cubit.openEvent(next),
          child: Row(
            children: [
              SizedBox(
                width: 150,
                height: 110,
                child: Stack(
                  children: [
                    const Positioned.fill(child: Photo()),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: CategoryBadge(next.category),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l(next.title),
                      style: qs(16, w: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        iconText(Icons.calendar_month, context.l(next.date)),
                        iconText(Icons.location_on, next.location),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Portrait: social links live in the shell's FAB instead.
        if (!context.compact) ...[
          const SizedBox(height: 20),
          Text(context.t('quickLinksHeading'), style: qs(17)),
          const SizedBox(height: 10),
          socialRow(context),
        ],
      ],
    );

    if (context.compact) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 72), // clear FAB
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 300, child: left),
            const SizedBox(height: 20),
            right,
          ],
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 85, child: left),
        const SizedBox(width: 24),
        Expanded(flex: 115, child: SingleChildScrollView(child: right)),
      ],
    );
  }
}
