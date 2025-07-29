import 'package:flutter/material.dart';

import '../models/campaign_model.dart';

typedef PlatformCallback = void Function(ReviewPlatform);

class PlatformSelector extends StatelessWidget {
  final ReviewPlatform selectedPlatform;
  final PlatformCallback onPlatformChanged;

  const PlatformSelector({
    required this.selectedPlatform,
    required this.onPlatformChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: ReviewPlatform.values.map((platform) {
        return ChoiceChip(
          label: Text(platform.name),
          selected: selectedPlatform == platform,
          onSelected: (_) => onPlatformChanged(platform),
        );
      }).toList(),
    );
  }
}
