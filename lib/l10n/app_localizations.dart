import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Photo Fixer'**
  String get appName;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreeting;

  /// No description provided for @homeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Make your photos look better.'**
  String get homeHeadline;

  /// No description provided for @homePrimaryCta.
  ///
  /// In en, this message translates to:
  /// **'Enhance a photo'**
  String get homePrimaryCta;

  /// No description provided for @homeChooseImprovement.
  ///
  /// In en, this message translates to:
  /// **'Choose an improvement'**
  String get homeChooseImprovement;

  /// No description provided for @operationEnhance.
  ///
  /// In en, this message translates to:
  /// **'Enhance'**
  String get operationEnhance;

  /// No description provided for @operationRelight.
  ///
  /// In en, this message translates to:
  /// **'Relight'**
  String get operationRelight;

  /// No description provided for @operationUnblur.
  ///
  /// In en, this message translates to:
  /// **'Unblur'**
  String get operationUnblur;

  /// No description provided for @operationRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get operationRestore;

  /// No description provided for @homeRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get homeRecent;

  /// No description provided for @homeRecentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your enhanced photos will appear here.'**
  String get homeRecentEmpty;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Getting things ready…'**
  String get splashLoading;

  /// No description provided for @bootstrapFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get bootstrapFailedTitle;

  /// No description provided for @bootstrapFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t start the app. Please try again.'**
  String get bootstrapFailedMessage;

  /// No description provided for @bootstrapRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get bootstrapRetry;

  /// No description provided for @editorTitle.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get editorTitle;

  /// No description provided for @editorPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Photo editor coming next.'**
  String get editorPlaceholder;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @resultPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Results will appear here.'**
  String get resultPlaceholder;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Get photo credits'**
  String get paywallTitle;

  /// No description provided for @paywallPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Credits packs will appear here.'**
  String get paywallPlaceholder;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingTitle;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Make every photo look better.'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Body.
  ///
  /// In en, this message translates to:
  /// **'Turn blurry, dark, or old photos into clearer versions in seconds.'**
  String get onboardingPage1Body;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'One tap. Professional-looking results.'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Body.
  ///
  /// In en, this message translates to:
  /// **'Enhance, relight, unblur, or restore — then compare with a before/after slider.'**
  String get onboardingPage2Body;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'3 free photo enhancements.'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Body.
  ///
  /// In en, this message translates to:
  /// **'Try Photo Fixer free. No account needed to get started.'**
  String get onboardingPage3Body;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingStart;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @demoBefore.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get demoBefore;

  /// No description provided for @demoAfter.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get demoAfter;

  /// No description provided for @editorPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo'**
  String get editorPickTitle;

  /// No description provided for @editorPickGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get editorPickGallery;

  /// No description provided for @editorPickCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get editorPickCamera;

  /// No description provided for @editorChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get editorChangePhoto;

  /// No description provided for @editorStartProcessing.
  ///
  /// In en, this message translates to:
  /// **'Enhance photo'**
  String get editorStartProcessing;

  /// No description provided for @editorPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing photo…'**
  String get editorPreparing;

  /// No description provided for @editorUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get editorUploading;

  /// No description provided for @editorProcessing.
  ///
  /// In en, this message translates to:
  /// **'Enhancing details…'**
  String get editorProcessing;

  /// No description provided for @editorCompletedStub.
  ///
  /// In en, this message translates to:
  /// **'Processing ready (AI backend next).'**
  String get editorCompletedStub;

  /// No description provided for @editorErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t use this photo.'**
  String get editorErrorTitle;

  /// No description provided for @editorErrorTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This photo is too large. Try another one.'**
  String get editorErrorTooLarge;

  /// No description provided for @editorErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'This image can\'t be processed. Try another one.'**
  String get editorErrorInvalid;

  /// No description provided for @editorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get editorTryAgain;

  /// No description provided for @editorPermissionHint.
  ///
  /// In en, this message translates to:
  /// **'We only access the photos you choose to enhance.'**
  String get editorPermissionHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
