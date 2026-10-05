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
        final infoBox = Box(
          color: cs.surfaceContainer,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              info(
                Icons.calendar_month,
                context.t('dateLabel'),
                context.l(sel.date),
              ),
              info(Icons.location_on, context.t('locationLabel'), sel.location),
            ],
          ),
        );
        final register = sel.status == 'upcoming' && sel.registerUrl != null
            ? linkButton(
                context,
                context.t('registerCta'),
                sel.registerUrl!,
                bg: cs.primary,
                fg: cs.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                expand: compact,
              )
            : null;
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
            if (register == null)
              SizedBox(width: double.infinity, child: infoBox)
            else if (compact) ...[
              SizedBox(width: double.infinity, child: infoBox),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: register),
            ] else
              Row(
                children: [
                  Expanded(child: infoBox),
                  const SizedBox(width: 16),
                  register,
                ],
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
            if (sel.timeline.isNotEmpty) ...[
              const SizedBox(height: 22),
              Text(context.t('timelineHeading'), style: qs(15)),
              const SizedBox(height: 12),
              EventTimeline(sel.timeline),
            ],
          ],
        );
        if (compact) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [const SizedBox(height: 24), detail],
              // children: [left, const SizedBox(height: 24), detail],
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

// Vertical programme: time column | dot + connector line | title card.
class EventTimeline extends StatelessWidget {
  final List<TimelineSlot> slots;
  const EventTimeline(this.slots, {super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    return Column(
      children: [
        for (var i = 0; i < slots.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 56,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      '${slots[i].start}\n${slots[i].end}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (i < slots.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: cs.primary.withValues(alpha: 0.35),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: i < slots.length - 1 ? 10 : 0,
                    ),
                    child: Box(
                      color: cs.surfaceContainer,
                      radius: 16,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final item in slots[i].items)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: item == slots[i].items.first ? 0 : 6,
                                ),
                                child: Text(
                                  context.l(item),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
