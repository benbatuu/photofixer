import 'package:flutter/material.dart';
import 'package:photofixer/l10n/app_localizations.dart';
import 'package:photofixer/core/theme/app_spacing.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.paywallTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Text(l10n.paywallPlaceholder),
      ),
    );
  }
}
