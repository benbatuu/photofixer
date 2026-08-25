import 'package:flutter/material.dart';
import 'package:photofixer/l10n/app_localizations.dart';
import 'package:photofixer/core/theme/app_spacing.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Text(l10n.resultPlaceholder),
      ),
    );
  }
}
