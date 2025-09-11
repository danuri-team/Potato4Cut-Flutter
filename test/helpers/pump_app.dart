import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato4cut/l10n/arb/app_localizations.dart';
import 'package:potato4cut/l10n/l10n.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}
