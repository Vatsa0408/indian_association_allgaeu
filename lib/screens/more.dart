import 'package:flutter/material.dart';

import '../data.dart';
import '../shell.dart';
import '../theme.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final body = TextStyle(fontSize: 13.5, color: cs.onSurfaceVariant);
    final sub = TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant);

    final compact = context.compact;

    Widget card(IconData icon, String headingKey, List<Widget> children) {
      final box = Box(
        color: cs.surfaceContainer,
        radius: 24,
        padding: EdgeInsets.all(compact ? 16 : 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 22, color: cs.primary),
                const SizedBox(width: 8),
                Flexible(child: Text(context.t(headingKey), style: qs(17))),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      );
      return compact ? box : Expanded(child: box);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // compact: stack the cards (Flex, so Expanded only applies when wide)
          Flex(
            direction: compact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: compact
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.start,
            children: [
              card(Icons.volunteer_activism, 'membershipHeading', [
                SizedBox(
                  width: double.infinity,
                  child: Box(
                    color: cs.primaryContainer,
                    fg: cs.onPrimaryContainer,
                    radius: 16,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.t('membershipFeeLabel'),
                          style: const TextStyle(fontSize: 13),
                        ),
                        Flexible(
                          child: Text(
                            context.l(fee),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.t('membershipBenefitsHeading'),
                  style: qs(14, w: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                for (final b in benefits)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: cs.secondary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(context.l(b), style: body)),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  context.t('membershipHowHeading'),
                  style: qs(14, w: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(context.t('membershipHowBody'), style: body),
              ]),
              const SizedBox(width: 20, height: 20),
              card(Icons.payments, 'donationsHeading', [
                Text(context.t('donationsBody'), style: body),
                const SizedBox(height: 16),
                Text(
                  context.t('bankTransferHeading'),
                  style: qs(13, w: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Box(
                    color: cs.surfaceContainerHigh,
                    radius: 16,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        for (final e in bank.entries)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.key, style: sub),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    e.value,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.t('paypalHeading'),
                  style: qs(13, w: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                linkButton(
                  context,
                  context.t('paypalCta'),
                  paypalUrl,
                  bg: cs.primary,
                  fg: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 11,
                  ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            context.t('imprintHeading'),
            style: qs(
              13,
              w: FontWeight.w600,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            context.t('imprintBody'),
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant.withValues(alpha: .85),
            ),
          ),
        ],
      ),
    );
  }
}
