import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_cubit.dart';
import 'data.dart';
import 'screens/contact.dart';
import 'screens/events.dart';
import 'screens/gallery.dart';
import 'screens/home.dart';
import 'screens/more.dart';
import 'theme.dart';

// ---- helpers shared by all screens ----

extension Ctx on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;

  // Narrow or portrait = single-column layout + bottom nav.
  bool get compact {
    final s = MediaQuery.sizeOf(this);
    return s.width < 720 || s.height > s.width;
  }

  int get gridCols => !compact
      ? 4
      : MediaQuery.sizeOf(this).width >= 560
      ? 3
      : 2;

  // Watch-style: call from build() only.
  String get lang => select((AppCubit c) => c.state.lang);
  String t(String key) => tr(strings[key]!, lang);
  String l(List<String> pair) => tr(pair, lang);
}

Future<void> open(String url) =>
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

// Rounded, optionally tappable, coloured box. [fg] sets default text/icon colour.
class Box extends StatelessWidget {
  final Color color;
  final Color? fg;
  final double radius;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Widget child;

  const Box({
    super.key,
    required this.color,
    this.fg,
    this.radius = 20,
    this.padding = EdgeInsets.zero,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget c = Padding(padding: padding, child: child);
    if (fg != null) {
      c = IconTheme.merge(
        data: IconThemeData(color: fg),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: fg),
          child: c,
        ),
      );
    }
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? c : InkWell(onTap: onTap, child: c),
    );
  }
}

// Stand-in for photos (no assets yet).
class Photo extends StatelessWidget {
  final double? width, height;
  final double radius;
  final String? label;
  const Photo({
    super.key,
    this.width,
    this.height,
    this.radius = 16,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image_outlined, color: cs.onSurfaceVariant),
          if (label != null)
            Text(
              label!,
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}

class CategoryBadge extends StatelessWidget {
  final String category;
  const CategoryBadge(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    return Box(
      color: cs.tertiaryContainer,
      fg: cs.onTertiaryContainer,
      radius: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Text(
        context.l(categoryLabel[category]!),
        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// Filter / segment pill.
Widget chip(
  BuildContext context,
  String label,
  bool active,
  VoidCallback onTap, {
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
}) {
  final cs = context.cs;
  return Box(
    color: active ? cs.primary : cs.surfaceContainerHigh,
    fg: active ? cs.onPrimary : cs.onSurfaceVariant,
    radius: 100,
    padding: padding,
    onTap: onTap,
    child: Text(
      label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  );
}

// Pill button that opens [url].
Widget linkButton(
  BuildContext context,
  String label,
  String url, {
  required Color bg,
  required Color fg,
  required EdgeInsets padding,
  bool expand = false,
}) => Box(
  color: bg,
  fg: fg,
  radius: 100,
  padding: padding,
  onTap: () => open(url),
  child: Row(
    mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.open_in_new, size: 18),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    ],
  ),
);

// "Join our WhatsApp" banner, shared by Home and Contact.
Widget whatsappBanner(BuildContext context) {
  final cs = context.cs;
  final text = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(context.t('whatsappBannerTitle'), style: qs(17)),
      const SizedBox(height: 4),
      Text(
        context.t('whatsappBannerBody'),
        style: const TextStyle(fontSize: 13),
      ),
    ],
  );
  final cta = linkButton(
    context,
    context.t('whatsappCta'),
    whatsappUrl,
    bg: cs.secondary,
    fg: cs.onSecondary,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );
  return SizedBox(
    width: double.infinity,
    child: Box(
      color: cs.secondaryContainer,
      fg: cs.onSecondaryContainer,
      radius: 26,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: context.compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [text, const SizedBox(height: 14), cta],
            )
          : Row(
              children: [
                const Icon(Icons.chat, size: 32),
                const SizedBox(width: 20),
                Expanded(child: text),
                const SizedBox(width: 20),
                cta,
              ],
            ),
    ),
  );
}

Widget socialRow(BuildContext context) {
  final cs = context.cs;
  return Wrap(
    spacing: 12,
    children: [
      for (final (icon, url) in social)
        IconButton(
          onPressed: () => open(url),
          icon: Icon(icon, size: 21),
          style: IconButton.styleFrom(
            backgroundColor: cs.surfaceContainerHigh,
            foregroundColor: cs.onSurfaceVariant,
            fixedSize: const Size.square(46),
          ),
        ),
    ],
  );
}

// Portrait speed-dial: WhatsApp + social links stacked above the main FAB.
class SocialFab extends StatefulWidget {
  const SocialFab({super.key});

  @override
  State<SocialFab> createState() => _SocialFabState();
}

class _SocialFabState extends State<SocialFab> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    Widget mini(IconData icon, String url, {bool whatsapp = false}) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FloatingActionButton.small(
        heroTag: null,
        tooltip: whatsapp ? context.t('whatsappCta') : null,
        backgroundColor: whatsapp ? cs.secondary : cs.surfaceContainerHigh,
        foregroundColor: whatsapp ? cs.onSecondary : cs.onSurfaceVariant,
        onPressed: () => open(url),
        child: Icon(icon),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_open) ...[
          for (final (icon, url) in social) mini(icon, url),
          mini(Icons.chat, whatsappUrl, whatsapp: true),
        ],
        FloatingActionButton(
          heroTag: null,
          onPressed: () => setState(() => _open = !_open),
          child: Icon(_open ? Icons.close : Icons.chat),
        ),
      ],
    );
  }
}

// ---- shell ----

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = context.select((AppCubit c) => c.state.screen);
    final compact = context.compact;
    final pad = compact ? 16.0 : 28.0;
    // Contact is redundant in the bottom bar (SocialFab covers it).
    final bottomItems = [
      for (final n in _navItems)
        if (n.$1 != Screen.contact) n,
    ];
    return Scaffold(
      floatingActionButton: compact ? const SocialFab() : null,
      bottomNavigationBar: compact
          ? NavigationBar(
              // Falls back to Home if the current screen has no destination.
              selectedIndex: bottomItems
                  .indexWhere((n) => n.$1 == screen)
                  .clamp(0, bottomItems.length - 1),
              onDestinationSelected: (i) =>
                  context.read<AppCubit>().setScreen(bottomItems[i].$1),
              destinations: [
                for (final (_, icon, key) in bottomItems)
                  NavigationDestination(
                    icon: Icon(icon),
                    label: context.t(key),
                  ),
              ],
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (!compact) const _NavRail(),
            Expanded(
              child: Column(
                children: [
                  _TopBar(screen),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        pad,
                        0,
                        pad,
                        compact ? 0 : 28,
                      ),
                      child: switch (screen) {
                        Screen.home => const HomeScreen(),
                        Screen.events => const EventsScreen(),
                        Screen.gallery => const GalleryScreen(),
                        Screen.contact => const ContactScreen(),
                        Screen.more => const MoreScreen(),
                      },
                    ),
                  ),
                  const _Footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Always-visible credit line, pinned under the screen content.
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 11, color: context.cs.onSurfaceVariant);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              style: style,
              children: const [
                TextSpan(text: 'Made with '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(Icons.favorite, size: 12, color: Colors.red),
                ),
                TextSpan(text: ' using Flutter'),
              ],
            ),
          ),
          Text('Developed by Sri', style: style),
        ],
      ),
    );
  }
}

const _navItems = [
  (Screen.home, Icons.home, 'navHome'),
  (Screen.events, Icons.event, 'navEvents'),
  // TODO: Gallery hidden for now; re-enable later.
  // (Screen.gallery, Icons.photo_library, 'navGallery'),
  (Screen.contact, Icons.groups, 'navContact'),
  // Hidden for now: (Screen.more, Icons.more_horiz, 'navMore'),
];

Widget _themeButton(BuildContext context) {
  final cs = context.cs;
  final dark = context.select((AppCubit c) => c.state.theme) == ThemeMode.dark;
  return IconButton(
    tooltip: dark ? 'Light' : 'Dark',
    onPressed: () => context.read<AppCubit>().toggleTheme(),
    icon: Icon(dark ? Icons.light_mode : Icons.dark_mode, size: 19),
    style: IconButton.styleFrom(
      backgroundColor: cs.surfaceContainerHigh,
      foregroundColor: cs.onSurfaceVariant,
      fixedSize: const Size.square(40),
    ),
  );
}

Widget _logo(BuildContext context) {
  final cs = context.cs;
  return CircleAvatar(
    radius: 22,
    backgroundColor: cs.primary,
    child: Text('IA', style: qs(15).copyWith(color: cs.onPrimary)),
  );
}

// Keep in sync with `version:` in pubspec.yaml (no package_info_plus dependency).
const _appVersion = '1.1.0';

// Opens Flutter's built-in about dialog (includes "View licenses").
Widget _infoButton(BuildContext context) {
  final cs = context.cs;
  // context.t() watches the cubit, so resolve it here in build, not in onPressed.
  final name = context.t('appName');
  final body = context.t('aboutAppBody');
  return IconButton(
    tooltip: name,
    onPressed: () => showAboutDialog(
      context: context,
      applicationName: name,
      applicationVersion: _appVersion,
      applicationIcon: _logo(context),
      children: [Text(body)],
    ),
    icon: const Icon(Icons.info_outline, size: 19),
    style: IconButton.styleFrom(
      backgroundColor: cs.surfaceContainerHigh,
      foregroundColor: cs.onSurfaceVariant,
      fixedSize: const Size.square(40),
    ),
  );
}

class _NavRail extends StatelessWidget {
  const _NavRail();

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final screen = context.select((AppCubit c) => c.state.screen);
    return Material(
      color: cs.surfaceContainer,
      child: SizedBox(
        width: 96,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              _logo(context),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final (s, icon, key) in _navItems)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: _NavItem(
                              icon: icon,
                              label: context.t(key),
                              active: s == screen,
                              onTap: () =>
                                  context.read<AppCubit>().setScreen(s),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              _themeButton(context),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 32,
              decoration: BoxDecoration(
                color: active ? cs.primaryContainer : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 22,
                color: active ? cs.onPrimaryContainer : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? cs.onSurface : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final Screen screen;
  const _TopBar(this.screen);

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final lang = context.lang;
    final cubit = context.read<AppCubit>();
    const seg = EdgeInsets.symmetric(horizontal: 14, vertical: 6);
    final compact = context.compact;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 16 : 28,
        vertical: compact ? 10 : 18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.t(
                screen == Screen.home ? 'appName' : '${screen.name}Heading',
              ),
              style: qs(22),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                chip(
                  context,
                  'EN',
                  lang == 'en',
                  () => cubit.setLang('en'),
                  padding: seg,
                ),
                chip(
                  context,
                  'DE',
                  lang == 'de',
                  () => cubit.setLang('de'),
                  padding: seg,
                ),
              ],
            ),
          ),
          if (compact) ...[const SizedBox(width: 8), _themeButton(context)],
          const SizedBox(width: 8),
          _infoButton(context),
        ],
      ),
    );
  }
}
