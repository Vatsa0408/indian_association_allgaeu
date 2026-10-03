import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_cubit.dart';
import '../data.dart';
import '../shell.dart';
import '../theme.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final cubit = context.read<AppCubit>();

    Widget info(IconData icon, String label, String value) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: cs.primary),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, s) {
        final list = events.where((e) => e.status == s.eventFilter).toList();
        final sel = events.firstWhere((e) => e.id == s.selectedEventId);
        final compact = context.compact;
        final left = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                chip(
                  context,
                  context.t('filterUpcoming'),
                  s.eventFilter == 'upcoming',
                  () => cubit.setEventFilter('upcoming'),
                ),
                // TODO: Past events filter hidden for now; re-enable later.
                // const SizedBox(width: 8),
                // chip(
                //   context,
                //   context.t('filterPast'),
                //   s.eventFilter == 'past',
                //   () => cubit.setEventFilter('past'),
                // ),
              ],
            ),
            const SizedBox(height: 12),
            Builder(
              builder: (_) {
                final lv = ListView.separated(
                  // compact: list sits in the page scroll, so it sizes to its items
                  shrinkWrap: compact,
                  physics: compact
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final e = list[i];
                    return Box(
                      color: e.id == sel.id
                          ? cs.surfaceContainerHigh
                          : cs.surfaceContainer,
                      padding: const EdgeInsets.all(10),
                      onTap: () => cubit.selectEvent(e.id),
                      child: Row(
                        children: [
                          const Photo(width: 72, height: 72),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CategoryBadge(e.category),
                                const SizedBox(height: 4),
                                Text(
                                  tr(e.title, s.lang),
                                  style: qs(14, w: FontWeight.w600),
                                ),
                                Text(
                                  tr(e.date, s.lang),
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
                return compact ? lv : Expanded(child: lv);
              },
            ),
          ],
        );
        final detail = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  const Positioned.fill(child: Photo(radius: 24)),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: CategoryBadge(sel.category),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(context.l(sel.title), style: qs(22)),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: Box(
                color: cs.surfaceContainer,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  children: [
                    info(
                      Icons.calendar_month,
                      context.t('dateLabel'),
                      context.l(sel.date),
                    ),
                    info(
                      Icons.location_on,
                      context.t('locationLabel'),
                      sel.location,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(context.t('aboutEventHeading'), style: qs(15)),
            const SizedBox(height: 8),
            Text(
              context.l(sel.desc),
              style: TextStyle(
                fontSize: 14,
                height: 1.55,
                color: cs.onSurfaceVariant,
              ),
            ),
            if (sel.status == 'upcoming' && sel.registerUrl != null) ...[
              const SizedBox(height: 16),
              linkButton(
                context,
                context.t('registerCta'),
                sel.registerUrl!,
                bg: cs.primary,
                fg: cs.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ],
          ],
        );
        if (compact) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [left, const SizedBox(height: 24), detail],
            ),
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 42, child: left),
            const SizedBox(width: 24),
            Expanded(flex: 58, child: SingleChildScrollView(child: detail)),
          ],
        );
      },
    );
  }
}
