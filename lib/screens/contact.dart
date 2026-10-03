import 'package:flutter/material.dart';

import '../shell.dart';
import '../theme.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final lang = context.lang;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Portrait: WhatsApp and social links live in the shell's FAB.
          if (!context.compact) ...[
            whatsappBanner(context),
            const SizedBox(height: 22),
          ],
          // TODO: Committee section hidden for now; re-enable later.
          // Text(context.t('committeeHeading'), style: qs(17)),
          // const SizedBox(height: 12),
          // GridView.builder(
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // crossAxisCount: context.gridCols,
          // mainAxisSpacing: 14,
          // crossAxisSpacing: 14,
          // mainAxisExtent: context.compact ? 210 : 150,
          // ),
          // itemCount: committee.length,
          // itemBuilder: (_, i) {
          // final (name, role) = committee[i];
          // return Box(
          // color: cs.surfaceContainer,
          // padding: const EdgeInsets.symmetric(
          // horizontal: 10,
          // vertical: 16,
          // ),
          // child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          // const Photo(width: 56, height: 56, radius: 28),
          // const SizedBox(height: 8),
          // Text(
          // name,
          // style: qs(13, w: FontWeight.w600),
          // textAlign: TextAlign.center,
          // ),
          // const SizedBox(height: 8),
          // Text(
          // tr(role, lang),
          // textAlign: TextAlign.center,
          // style: TextStyle(
          // fontSize: 11,
          // color: cs.onSurfaceVariant,
          // ),
          // ),
          // ],
          // ),
          // );
          // },
          // ),
          if (!context.compact) ...[
            const SizedBox(height: 22),
            Text(context.t('socialHeading'), style: qs(17)),
            const SizedBox(height: 12),
            socialRow(context),
          ],
        ],
      ),
    );
  }
}
