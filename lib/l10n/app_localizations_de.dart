// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Photo Fixer';

  @override
  String get homeGreeting => 'Good evening';

  @override
  String get homeHeadline => 'Make your photos look better.';

  @override
  String get homePrimaryCta => 'Enhance a photo';

  @override
  String get homeChooseImprovement => 'Choose an improvement';

  @override
  String get operationEnhance => 'Enhance';

  @override
  String get operationRelight => 'Relight';

  @override
  String get operationUnblur => 'Unblur';

  @override
  String get operationRestore => 'Restore';

  @override
  String get homeRecent => 'Recent';

  @override
  String get homeRecentEmpty => 'Your enhanced photos will appear here.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get splashLoading => 'Getting things ready…';

  @override
  String get bootstrapFailedTitle => 'Something went wrong';

  @override
  String get bootstrapFailedMessage =>
      'We couldn\'t start the app. Please try again.';

  @override
  String get bootstrapRetry => 'Try again';

  @override
  String get editorTitle => 'Editor';

  @override
  String get editorPlaceholder => 'Photo editor coming next.';

  @override
  String get resultTitle => 'Result';

  @override
  String get resultPlaceholder => 'Results will appear here.';

  @override
  String get paywallTitle => 'Get photo credits';

  @override
  String get paywallPlaceholder => 'Credits packs will appear here.';

  @override
  String get onboardingTitle => 'Welcome';

  @override
  String get onboardingPage1Title => 'Make every photo look better.';

  @override
  String get onboardingPage1Body =>
      'Turn blurry, dark, or old photos into clearer versions in seconds.';

  @override
  String get onboardingPage2Title => 'One tap. Professional-looking results.';

  @override
  String get onboardingPage2Body =>
      'Enhance, relight, unblur, or restore — then compare with a before/after slider.';

  @override
  String get onboardingPage3Title => '3 free photo enhancements.';

  @override
  String get onboardingPage3Body =>
      'Try Photo Fixer free. No account needed to get started.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Start';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get demoBefore => 'Before';

  @override
  String get demoAfter => 'After';

  @override
  String get editorPickTitle => 'Choose a photo';

  @override
  String get editorPickGallery => 'Gallery';

  @override
  String get editorPickCamera => 'Camera';

  @override
  String get editorChangePhoto => 'Change photo';

  @override
  String get editorStartProcessing => 'Enhance photo';

  @override
  String get editorPreparing => 'Preparing photo…';

  @override
  String get editorUploading => 'Uploading…';

  @override
  String get editorProcessing => 'Enhancing details…';

  @override
  String get editorCompletedStub => 'Processing ready (AI backend next).';

  @override
  String get editorErrorTitle => 'We couldn\'t use this photo.';

  @override
  String get editorErrorTooLarge => 'This photo is too large. Try another one.';

  @override
  String get editorErrorInvalid =>
      'This image can\'t be processed. Try another one.';

  @override
  String get editorTryAgain => 'Try again';

  @override
  String get editorPermissionHint =>
      'We only access the photos you choose to enhance.';
}
