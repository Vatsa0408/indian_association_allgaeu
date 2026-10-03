import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_cubit.dart';
import '../data.dart';
import '../shell.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (a, b) => a.galleryFilter != b.galleryFilter,
      builder: (context, s) {
        final shown = galleryPhotos.where(
          (c) => s.galleryFilter == 'all' || c == s.galleryFilter,
        );
        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final f in ['all', ...categoryLabel.keys])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: chip(
                        context,
                        f == 'all'
                            ? context.t('galleryFilterAll')
                            : context.l(categoryLabel[f]!),
                        s.galleryFilter == f,
                        () => cubit.setGalleryFilter(f),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.count(
                crossAxisCount: context.gridCols,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                children: [
                  for (final c in shown)
                    Photo(
                      radius: 20,
                      label: '${context.l(categoryLabel[c]!)} photo',
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
