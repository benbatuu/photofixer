PHOTO FIXER — Flutter Mobile App Project Specification

> **Amaç:** Bu dosya, bir AI coding agent'a verilerek Android + iOS için üretime yakın bir Photo Fixer uygulaması geliştirmesini sağlamak üzere hazırlanmıştır.
>
> **Hedef:** 14 gün içinde çalışan MVP, App Store + Google Play yayını ve ilk ücretli kullanıcı.
>
> **Platform:** Flutter / Android / iOS
>
> **Backend:** Firebase + Firebase Cloud Functions
>
> **AI:** Gemini API
>
> **Ödeme:** Apple App Store In-App Purchase + Google Play Billing; üçüncü parti ödeme sağlayıcısı kullanılmayacak.
>
> **Dil:** İlk sürüm UI İngilizce. Kod ve değişken isimleri İngilizce. Lokalizasyon altyapısı ilk günden hazır olsun.

---

# 1. ÜRÜNÜN TANIMI

Uygulamanın ana vaadi:

> **Turn bad photos into better photos.**

Kullanıcı kötü görünen bir fotoğraf yükler ve birkaç saniye içinde daha kullanılabilir bir versiyon alır.

İlk sürümde dört ana işlem:

1. **Enhance** — genel kalite/ışık/kontrast iyileştirme
2. **Unblur** — makul ölçüde bulanıklık azaltma
3. **Relight** — kötü ışığı düzeltme
4. **Restore** — eski/düşük kaliteli fotoğrafı iyileştirme

İlk sürümde şunları YAPMA:

- sosyal network
- profil sistemi
- takip/follow
- fotoğraf feed'i
- gelişmiş manuel editör
- video editing
- filtre mağazası
- desktop/web app
- karmaşık subscription sistemi
- 20 farklı AI özelliği

Ürün tek bir şeyi çok iyi yapmalı:

> **Fotoğraf yükle → iyileştir → sonucu göster → kaydet/paylaş → gerekiyorsa ödeme al.**

---

# 2. EN ÖNEMLİ ÜRÜN PRENSİBİ

Bu bir "AI demo" değildir.

Kullanıcı uygulamayı açtığında model, API, prompt veya teknik detay görmemeli.

İlk ekran:

- büyük örnek before/after
- kısa başlık
- tek CTA

Örnek:

**Make every photo look better.**

**Enhance your photos in seconds.**

[ Try for free ]

Kullanıcıyı kayıt ekranına sokmadan önce mümkün olduğunca hızlı şekilde ilk değer göster.

---

# 3. MONETIZATION

## Önerilen model

İlk sürümde **consumable credit** kullan.

Subscription'ı ilk versiyonda ana model yapma.

Sebep:

Kullanıcı Photo Fixer'ı her gün kullanmayabilir. "20 fotoğraf düzeltme" satın almak, ilk satın alma için "aylık abonelik"ten daha anlaşılırdır.

### Product IDs

Android:

```text
photo_fixer_10_credits
photo_fixer_30_credits
photo_fixer_100_credits

iOS:

photo_fixer_10_credits
photo_fixer_30_credits
photo_fixer_100_credits

Platform-specific product ID kullanmak yerine aynı ID'leri mümkün olduğunca iki mağazada da eşleştir.

Önerilen başlangıç fiyatları

Fiyatları kod içine hard-code etme. Mağaza ürün bilgisinden al.

Başlangıç önerisi:

10 credits  -> $2.99
30 credits  -> $5.99
100 credits -> $12.99

Fiyatları App Store Connect ve Google Play Console üzerinden ülkeye göre otomatik lokalize et.

Uygulama içinde:

10 photos
30 photos
100 photos

gibi göster.

Kullanıcıya "token", "API cost", "Gemini request" gibi teknik kavramlar gösterme.

Free allowance

Yeni kullanıcı:

3 free photo fixes

alsın.

Free credits local + server tarafında kontrol edilmeli.

Client-side yalnızca SharedPreferences ile "3 hakkım var" mantığı kurma. Kolayca silinip tekrar alınabilir.

4. ÖDEME MİMARİSİ
Zorunlu

Flutter'ın resmi in_app_purchase paketini kullan.

Üçüncü parti payment SDK:

Stripe
RevenueCat
Paddle
Adapty
Qonversion
başka bir ödeme aracı

KULLANILMAYACAK.

Apple tarafında StoreKit, Android tarafında Google Play Billing kullanılacak.

Flutter'ın resmi IAP dokümantasyonu:
https://docs.flutter.dev/resources/in-app-purchases-overview

Apple StoreKit:
https://developer.apple.com/documentation/storekit/in-app-purchase

Google Play Billing:
https://developer.android.com/google/play/billing/

Apple tarafında dijital içerik ve hizmetler için App Store In-App Purchase kullanılmalıdır. Google Play Billing de Android uygulamalarındaki dijital ürünleri destekler.

Satın alma akışı
User taps Buy
      ↓
Flutter in_app_purchase
      ↓
App Store / Google Play
      ↓
PurchaseUpdate
      ↓
Server verification
      ↓
Credit grant
      ↓
Transaction complete
      ↓
UI refresh
Kritik

purchaseStream uygulama açılır açılmaz dinlenmeye başlanmalı.

Satın alma sadece "button click" callback'inde ele alınmamalı.

Çünkü:

uygulama kapanabilir
network kesilebilir
satın alma pending olabilir
transaction daha sonra gelebilir
restore işlemi olabilir
Consumable purchase

Bir consumable ürün satın alındığında:

transaction alınır
server'a transaction bilgisi gönderilir
server doğrular
transaction ID'nin daha önce işlenip işlenmediği kontrol edilir
kredi eklenir
client'a başarı döner
Flutter tarafında completePurchase çağrılır

Aynı transaction iki kere kredi vermemeli.

Bu nedenle Firestore'da unique transaction kayıtları tutulmalı.

5. ÖDEME DOĞRULAMA

MVP'yi hızlı çıkarmak uğruna client'a güvenme.

Şu yanlış:

purchase success
→ local credits += 10

Bu kolayca manipüle edilebilir.

Doğru:

purchase
→ transaction data
→ Firebase Callable Function
→ Apple / Google verification
→ Firestore transaction
→ credit grant
Firestore
users/{uid}
users/{uid}/purchases/{purchaseId}
users/{uid}/credit_ledger/{ledgerId}

Purchase document örneği:

{
  "platform": "ios",
  "productId": "photo_fixer_10_credits",
  "transactionId": "...",
  "status": "verified",
  "creditsGranted": 10,
  "createdAt": "serverTimestamp"
}

transactionId veya platforma özgü benzersiz purchase identifier unique olarak işlenmeli.

Aynı satın alma tekrar gönderilirse:

already_processed

dön ve tekrar kredi verme.

6. GEMINI API
Kritik güvenlik kuralı

Gemini API key Flutter uygulamasına GÖMÜLMEYECEK.

Şunu yapma:

const geminiApiKey = "...";

Production mobil binary içindeki API key çıkarılabilir.

Google'ın resmi Gemini dokümanı da üretimde API anahtarlarının mobil/web client içine hard-code edilmemesini ve backend proxy kullanılmasını öneriyor.

Kaynak:
https://ai.google.dev/gemini-api/docs/api-key

Doğru mimari:

Flutter
  ↓
Firebase Callable Function / HTTPS Function
  ↓
Gemini API

API key:

Google Secret Manager

veya Firebase Functions secret configuration içinde tutulmalı.

7. GEMINI MODEL STRATEJİSİ

Photo Fixer için Gemini'nin image understanding ve image editing yetenekleri kullanılabilir.

Google'ın güncel Gemini API dokümantasyonunda image-to-image editing ve image editing desteklenmektedir.

Kaynak:
https://ai.google.dev/gemini-api/docs/image-generation

İlk MVP'de model adını Flutter koduna gömme.

Backend config:

GEMINI_IMAGE_MODEL=gemini-3.1-flash-image

gibi environment/secret config üzerinden yönet.

Model değişirse mobil uygulama güncellemesi gerekmemeli.

Önemli

Gemini image modelini her iş için körlemesine kullanma.

Backend'de işlem tipi belirle:

enhance
unblur
relight
restore

ve her işlem için ayrı prompt template kullan.

8. GEMINI PROMPT TASARIMI
Enhance

Amaç:

doğal renk
doğal kontrast
noise azaltma
yüzü değiştirmeme
fotoğrafın kimliğini koruma

Örnek sistem talimatı:

Enhance the provided photograph while preserving the identity, composition,
facial structure, skin texture, clothing, objects, and scene.

Improve exposure, contrast, white balance, sharpness and overall clarity.
Reduce noise and compression artifacts.

Do not invent or replace facial features.
Do not change the person's identity.
Do not add objects.
Do not change the composition.

The output should look like a professionally corrected version
of the original photograph, not an AI-generated reinterpretation.
Relight
Correct the lighting of the provided photograph.

Preserve the exact subject identity, facial structure, clothing,
objects and composition.

Improve exposure, shadows, highlights and white balance.
Create natural-looking illumination.

Do not over-smooth skin.
Do not alter facial features.
Do not add or remove objects.
Restore
Restore this old or degraded photograph.

Preserve the original people, identities, facial structure,
clothing and composition.

Reduce scratches, noise, compression artifacts and degradation.
Improve clarity while keeping the result faithful to the original.

Do not invent new facial features.
Do not modernize the scene.
Do not change the identity of any person.
Unblur

Burada kullanıcıya "perfectly recover lost information" gibi yanlış vaat verme.

Improve the apparent sharpness and clarity of this photograph
without inventing important visual details.

Preserve identity, facial structure, objects and composition.

Reduce motion blur and softness where possible.
Do not hallucinate facial details.
9. IMAGE PIPELINE

Önerilen pipeline:

Flutter
 ↓
Pick image
 ↓
Local compression / resize
 ↓
Preview
 ↓
Upload to backend
 ↓
Firebase App Check validation
 ↓
Credit check
 ↓
Gemini processing
 ↓
Validate response
 ↓
Store temporary result
 ↓
Return result URL
 ↓
Flutter displays before/after
 ↓
User downloads/shares
 ↓
Temporary files deleted
Input limits

İlk MVP:

max input: 12 MB
max dimension: 4096px
accepted:
JPEG
PNG
HEIC where supported
WEBP if supported

Mobile'de Gemini'ye gereksiz büyük dosya gönderme.

Client tarafında:

EXIF orientation normalize et
uzun kenarı makul boyuta indir
JPEG quality 85 civarı ile optimize et
original dosyayı kullanıcı cihazında koru
API'ye optimize edilmiş kopyayı gönder
10. IMAGE PRIVACY

Bu uygulama fotoğraf işlediği için gizlilik kritik.

Varsayılan davranış:

Original image:
temporary

Processed image:
temporary

Retention:
short-lived

Kullanıcıya açıkça söyle:

Photos are processed securely and temporary processing files are automatically deleted.

Backend'de mümkünse:

TTL / scheduled cleanup

kullan.

Kullanıcının fotoğraflarını Firebase Storage'da sonsuza kadar saklama.

History özelliği ilk MVP'de cihaz üzerinde local metadata ile tutulabilir.

11. FIREBASE MİMARİSİ

Kullanılacak Firebase servisleri:

Firebase Core
Firebase Auth
Firebase App Check
Firebase Analytics
Firebase Crashlytics
Firebase Cloud Messaging
Cloud Functions
Cloud Firestore
Cloud Storage

Hepsini ilk gün aktif etmek zorunda değilsin ama mimari bunları desteklemeli.

Authentication

İlk açılışta:

Anonymous Auth

kullan.

Kullanıcıdan email isteme.

Sonradan Apple/Google sign-in eklenebilir.

Ama MVP'de:

anonymous user

yeterli.

12. FIRESTORE SCHEMA
users/{uid}

  createdAt
  platform
  locale
  credits
  onboardingCompleted
  notificationsEnabled
  lastActiveAt
users/{uid}/purchases/{purchaseId}

  platform
  productId
  transactionId
  verificationStatus
  creditsGranted
  createdAt
users/{uid}/credit_ledger/{ledgerId}

  type: free | purchase | usage | refund | adjustment
  amount
  source
  referenceId
  createdAt
users/{uid}/jobs/{jobId}

  type
  status
  inputSize
  createdAt
  completedAt
  failureReason

Asıl kredi sayısını mümkünse ledger'dan güvenilir şekilde üret veya Firestore transaction ile atomik güncelle.

Client'ın doğrudan:

users/{uid}.credits

yazmasına izin verme.

13. FIREBASE SECURITY RULES

Client:

READ:

kendi user document'i
kendi job metadata'sı

WRITE:

sınırlı user preferences

Purchase:

client doğrudan purchase document oluşturamaz.

Credit:

client doğrudan credit değiştiremez.

Backend:

Admin SDK ile değiştirir.

Özellikle:

credits
purchase status
verification status
ledger

alanları client-write'a kapalı olmalı.

14. FIREBASE APP CHECK

Production'da Firebase App Check etkinleştir.

Android:

Play Integrity

iOS:

DeviceCheck / App Attest

Firebase'in Flutter App Check dokümantasyonu:
https://firebase.google.com/docs/app-check/flutter/default-providers

Ama App Check'i geliştirme sırasında debug provider ile yapılandır.

Production'da debug token bırakma.

15. CLOUD FUNCTIONS

Önerilen backend:

functions/
  src/
    index.ts
    config/
    auth/
    gemini/
    payments/
    notifications/
    cleanup/
    analytics/

Functions:

processPhoto()
verifyPurchase()
getProductsConfig()
sendManualNotification()
cleanupTemporaryFiles()
scheduleReengagement()
processPhoto

Input:

{
  "jobId": "...",
  "operation": "enhance",
  "imageBase64": "..."
}

Backend:

authenticated user
App Check
credit check
request size validation
image validation
Gemini request
response validation
temporary storage
credit deduction
response
Credit race condition

İki cihaz aynı anda işlem başlatabilir.

Şunu yapma:

read credits
if > 0
process
credits--

Bunun yerine Firestore transaction / reservation mekanizması kullan.

Örneğin:

available
→ reserve 1
→ processing
→ success = consume
→ failure = release
16. GEMINI MALİYET KONTROLÜ

En tehlikeli hata:

user uploads 20MB
→ Gemini
→ every request unlimited

Bunu yapma.

Server-side limits:

max requests / user / minute
max free requests / day
max image size
max concurrent jobs
max retry count

Gemini hata verirse otomatik sonsuz retry yapma.

Öneri:

max 2 retries
exponential backoff

API maliyetini Analytics/Firestore ile takip et.

Her job:

model
operation
latency
success
failure
estimatedCost

metadata'sı ile loglanabilir.

17. FLUTTER PROJE YAPISI

Önerilen:

lib/
  main.dart

  app/
    app.dart
    router.dart
    theme.dart
    localization.dart

  core/
    constants/
    errors/
    network/
    utils/
    widgets/

  features/
    onboarding/
      data/
      domain/
      presentation/

    home/
      data/
      domain/
      presentation/

    editor/
      data/
      domain/
      presentation/

    result/
      data/
      domain/
      presentation/

    paywall/
      data/
      domain/
      presentation/

    settings/
      presentation/

  services/
    firebase/
    purchases/
    notifications/
    analytics/
    storage/

  shared/
    models/

Feature-first architecture kullan.

Tüm Firebase/Gemini/IAP çağrılarını widget içine yazma.

Şu kötü:

onPressed: () async {
  final result = await FirebaseFirestore.instance...
}

Şu tercih edilmeli:

ref.read(photoProcessingControllerProvider.notifier).process(...)
18. STATE MANAGEMENT

Riverpod kullanılabilir.

Ama state management'ı gereksiz büyütme.

Önemli state'ler:

initial
selecting
uploading
processing
success
error

Photo processing state machine:

idle
  ↓
selected
  ↓
uploading
  ↓
processing
  ↓
completed

Hata:

uploading → error
processing → error

Retry mümkün olmalı.

19. UI TASARIMI
Genel prensip

Premium görünmeli.

Ama "AI app template" gibi görünmemeli.

Tasarım dili
minimal
çok fazla gradient kullanma
çok fazla glassmorphism kullanma
büyük whitespace
güçlü typography
büyük fotoğraf
tek primary CTA
subtle animations
Renk

Brand için:

Background: near-white / dark depending on theme
Primary: electric violet / indigo
Text: near-black
Secondary: neutral gray
Success: restrained green
Error: restrained red

Exact colors tema dosyasından yönetilmeli.

20. HOME SCREEN

Önerilen yapı:

Good evening

Make your photos look better.

[ Before / After demo ]

Choose an improvement

[ ✨ Enhance ]
[ 🔆 Relight ]
[ ✨ Unblur ]
[ 🕰 Restore ]

Recent

Ama ilk versiyonda kullanıcıyı seçenek bombardımanına tutma.

Ana CTA:

Enhance a photo

Diğer modlar ikinci seviyede olabilir.

21. DESIGN HACKS
Hack 1 — Before/After slider

Sonuç ekranında klasik iki image alt alta koyma.

Interactive slider:

BEFORE | AFTER

Kullanıcı parmağıyla sürükler.

Bu, ürünün değerini tek saniyede anlatır.

Hack 2 — Processing ekranı

Boş spinner gösterme.

Örneğin:

Analyzing photo...
Improving lighting...
Enhancing details...
Finalizing...

Ama sahte ilerleme yüzdesi verme.

Gerçek progress yoksa:

Step 1 of 3

gibi deterministik aşamalar kullan.

Hack 3 — Result sonrası paywall

İlk ücretsiz sonuçtan sonra:

Your enhanced photo is ready.

[ Preview ]

Unlock HD export

[ Get 10 Photo Credits — $2.99 ]

Önce sonucu göster.

Sonucu tamamen gizleyip:

PAY NOW

deme.

Kullanıcı değeri görmeden ödeme istemek dönüşümü düşürür.

Hack 4 — Watermark

İlk MVP'de ücretsiz export'a küçük watermark eklemek mümkün.

Ama aşırı agresif watermark kullanma.

Alternatif:

Free:
standard quality

Paid:
HD / full resolution

Daha premium görünür.

Hack 5 — Paywall timing

Uygulama açılır açılmaz paywall gösterme.

Doğru:

Install
→ first photo
→ processing
→ wow moment
→ paywall
22. ONBOARDING

Maksimum 2-3 ekran.

Screen 1
Make every photo look better.
Screen 2

Before/after animation.

One tap.
Professional-looking results.
Screen 3
3 free photo enhancements.

[ Start ]

Kullanıcıdan signup isteme.

23. IMAGE PICKER UX

Fotoğraf seçme ekranı:

Gallery
Camera

Mümkünse native picker kullan.

Kullanıcıdan geniş galeri izni istemeden önce neden gerektiğini açıkla.

iOS photo permission metinleri anlamlı olmalı.

Örneğin:

We only access the photos you choose to enhance.

Android/iOS privacy descriptions gerçek kullanım ile uyumlu olmalı.

24. RESULT SCREEN
[ Before / After Slider ]

Enhanced successfully.

[ Save to Photos ]
[ Share ]

Credits left: 2

[ Enhance another ]

Paid export gerekiyorsa:

HD export

CTA göster.

25. ERROR UX

Teknik hata kullanıcıya gösterilmez.

Kötü:

Exception: 503 GENERATION_FAILED

İyi:

We couldn't process this photo.

Try another image or try again.

Butona:

Try again

ekle.

Eğer kredi rezerve edilmişse failure durumunda krediyi geri bırak.

26. ANALYTICS

Firebase Analytics event'leri:

app_open
onboarding_completed
photo_selected
camera_opened
operation_selected
processing_started
processing_completed
processing_failed
result_viewed
result_saved
result_shared
paywall_viewed
purchase_started
purchase_completed
purchase_failed
restore_purchases
credit_consumed

Event parameters:

operation
platform
image_size_bucket
processing_time_bucket
free_or_paid
product_id

PII göndermeme.

Fotoğrafın kendisini Analytics'e gönderme.

27. CRASHLYTICS

Firebase Crashlytics ekle.

Özellikle:

native image picker crash
memory pressure
image decode
IAP
notification
Firebase initialization

takip edilmeli.

Release build'de test et.

Debug build'e güvenme.

28. PUSH NOTIFICATIONS

Firebase Cloud Messaging kullanılacak.

Kaynak:
https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages

İki tür notification
A. Otomatik

Örneğin kullanıcı fotoğraf işledi ama 3 gündür geri gelmedi:

Still have photos that need a little fixing? ✨

Ancak spam yapma.

Önerilen:

day 1: none
day 3: optional
day 7: optional
day 14: optional

Her kullanıcıya aynı mesajı sürekli gönderme.

B. Manuel

Firebase Console üzerinden manuel gönderim:

New feature
New photo model
Limited promotion
Maintenance

Topic:

all_users

ve ileride:

active_users
inactive_users
purchased_users

gibi segmentler.

29. NOTIFICATION PERMISSION

iOS ve Android 13+ için notification permission istenmesi gerekir.

Uygulama açılır açılmaz native permission popup gösterme.

Önce küçük bir custom explainer:

Want a reminder when we add new photo tools?

[ Enable notifications ]

Sonra sistem permission'ını aç.

Kullanıcı reddederse uygulama çalışmaya devam etmeli.

FCM dokümanına göre iOS ve Android 13+ notification permission gerektirir.

30. DEEP LINK

Notification'a tıklanınca:

photo fixer home

veya ilgili kampanya/paywall açılabilmeli.

Payload:

{
  "type": "promo",
  "route": "/paywall"
}

Flutter:

getInitialMessage()
onMessageOpenedApp

ikisini de ele al.

31. LOCAL NOTIFICATION

İlk MVP'de remote FCM yeterli.

Ancak gelecekte:

photo processing completed

gibi local event notification eklenebilir.

Ama kullanıcı uygulamayı zaten açık tutuyorsa notification spam üretme.

32. PRIVACY / DATA POLICY

Uygulama şu konularda açık olmalı:

Fotoğraflar işlenir.
API'ye gönderilebilir.
Geçici olarak tutulabilir.
İşleme sonrası silinir.
Analytics fotoğraf içeriğini kaydetmez.
Kullanıcı fotoğrafları reklam amacıyla satılmaz.

Privacy Policy URL App Store ve Google Play metadata'ya eklenmeli.

Terms of Use da hazırlanmalı.

AI çıktısının her zaman kusursuz olmadığı konusunda uygun disclaimer bulunmalı.

33. AI SAFETY

Gemini'nin image editing politikalarına uy.

Kullanıcının yüklediği görseller üzerinde gerekli haklara sahip olması gerektiği açıkça belirtilmeli.

Uygulama:

deepfake üretme amacı
kimlik taklidi
zararlı manipülasyon
yasaklı içerik

için güvenlik katmanlarına sahip olmalı.

Backend Gemini hata/blocked response dönerse kullanıcıya:

This image can't be processed.

gibi nötr mesaj göster.

34. APP STORE / GOOGLE PLAY
iOS

Gerekli:

Bundle ID
App Store Connect app
Paid Apps Agreement
In-App Purchase products
Privacy policy
Terms
screenshots
app icon
age rating
App Privacy details
StoreKit testing
Sandbox testing
TestFlight

Apple IAP ürünlerinin App Store Connect'te yapılandırılması gerekir.

Apple dokümanı:
https://developer.apple.com/help/app-store-connect/configure-in-app-purchase-settings/overview-for-configuring-in-app-purchase-settings

Android

Gerekli:

package name
Google Play Console
merchant profile
Billing products
Play Integrity
privacy policy
Data Safety
screenshots
content rating
internal testing
35. IAP TEST SENARYOLARI

Mutlaka test et:

successful purchase
cancelled purchase
pending purchase
network lost during purchase
app killed during purchase
restore
duplicate purchase callback
refund
already processed transaction
purchase from second device

En kritik test:

Purchase succeeds
→ kill app
→ reopen
→ purchase update arrives
→ credit exactly once
36. RESTORE PURCHASES

Settings ekranında:

Restore purchases

butonu olsun.

Consumables için platform davranışlarını dikkatle ele al.

Satın alınan consumable kredileri server-side ledger ile ilişkilendir.

37. SETTINGS

Minimum:

Restore Purchases
Manage Subscription / Purchases
Privacy Policy
Terms of Use
Contact Support
Rate App
Notifications
Delete Data

Subscription olmasa bile:

Purchase history
Restore purchases

eklenebilir.

38. ACCOUNT / DELETE DATA

Anonymous auth kullanılsa bile kullanıcı verisinin silinmesi için mekanizma oluştur.

Settings:

Delete my data

Fotoğraf processing dosyaları silinsin.

Firestore user/job metadata temizlensin.

Firebase Auth anonymous user silinsin.

Satın alma kayıtları yasal/mağaza gereklilikleri nedeniyle tamamen silinemeyecekse bunu privacy policy'de açıkla.

39. PERFORMANCE

Fotoğraf uygulamalarında memory kullanımı kritik.

Şunları yap:

full-resolution image'i gereksiz yere RAM'de tutma
thumbnails kullan
isolate/background processing düşün
image cache limitleri belirle
upload öncesi resize
result ekranında compressed preview kullan
full-resolution download'u yalnızca gerektiğinde al

Android'de düşük RAM cihazlarda test et.

iOS'ta eski cihazlarda test et.

40. OFFLINE

AI processing offline çalışmayacak.

Ama UI:

No internet connection

durumunu düzgün ele almalı.

Kullanıcıya:

You're offline. Connect to the internet to enhance a photo.

göster.

41. API ERROR MODEL

Backend'den standart hata formatı dön:

{
  "code": "INSUFFICIENT_CREDITS",
  "message": "Not enough credits",
  "retryable": false
}

Kodlar:

UNAUTHENTICATED
APP_CHECK_FAILED
INVALID_IMAGE
IMAGE_TOO_LARGE
INSUFFICIENT_CREDITS
GEMINI_TIMEOUT
GEMINI_BLOCKED
GEMINI_ERROR
RATE_LIMITED
INTERNAL_ERROR
PURCHASE_NOT_VERIFIED

Flutter bunları kullanıcı dostu mesajlara map eder.

42. RATE LIMIT

Backend:

anonymous:
5 processing requests / hour

authenticated:
10 / hour

paid:
higher configurable limit

İlk değerler config'ten değiştirilebilir olsun.

IP + uid + App Check kombinasyonunu kullan.

Rate limit yalnızca client'ta tutulmamalı.

43. ADMIN / OPERATIONS

MVP'de ayrı admin panel yapma.

Firebase Console yeterli.

Ancak Firestore'da:

config/app

gibi bir config document olabilir:

{
  "freeCredits": 3,
  "maxImageSizeMb": 12,
  "maintenanceMode": false,
  "minAppVersionAndroid": "1.0.0",
  "minAppVersionIos": "1.0.0"
}

Backend config kritik değerleri client'tan değiştirilemez.

44. FEATURE FLAGS

İlk günden feature flag altyapısı düşün.

Örnek:

enhanceEnabled
unblurEnabled
relightEnabled
restoreEnabled
newPaywallEnabled

Bu sayede yeni build çıkarmadan backend üzerinden özelliği kapatabilirsin.

45. REMOTE CONFIG

Firebase Remote Config kullanılabilir.

Özellikle:

freeCredits
paywallVariant
promoText
maxUploadSize
processingTimeout

için.

Ama ödeme fiyatlarını Remote Config ile belirleme.

Mağaza ürün fiyatı authoritative source olmalı.

46. A/B TEST

İlk sürümde karmaşık A/B sistemi kurma.

Sadece paywall variant:

A:
$2.99 / 10

B:
$5.99 / 30

gibi test edilebilir.

Analytics:

paywall_variant
purchase_completed

ile ölç.

47. APP LAUNCH FLOW
Splash
 ↓
Firebase initialize
 ↓
App Check initialize
 ↓
Auth initialize
 ↓
Analytics initialize
 ↓
FCM initialize
 ↓
IAP listener start
 ↓
Remote Config fetch
 ↓
Check minimum version
 ↓
Home

IAP listener mümkün olduğunca erken başlatılmalı.

48. PURCHASE SERVICE

Tek bir servis oluştur:

abstract class PurchaseService {
  Future<void> initialize();
  Future<List<ProductDetails>> loadProducts();
  Future<void> buy(ProductDetails product);
  Future<void> restorePurchases();
  Stream<PurchaseDetails> get purchaseStream;
}

UI doğrudan InAppPurchase.instance kullanmasın.

49. PHOTO PROCESSING SERVICE
abstract class PhotoProcessingService {
  Future<PhotoJob> process({
    required File image,
    required PhotoOperation operation,
  });
}

Model:

enum PhotoOperation {
  enhance,
  unblur,
  relight,
  restore,
}
50. ANALYTICS SERVICE
abstract class AnalyticsService {
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  });
}

Widget'larda doğrudan Firebase Analytics çağrısı yapma.

51. NOTIFICATION SERVICE
abstract class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<String?> getToken();
}

FCM token Firestore'a yazılacak:

users/{uid}/devices/{tokenHash}

Plain token gerektiğinde backend'de saklanabilir; erişim kurallarını sıkı tut.

52. LOCAL STORAGE

SharedPreferences / secure storage kullanımını sınırlı tut.

Local:

onboarding_completed
theme
last_selected_operation
notification_prompt_seen

gibi UX state'leri tutulabilir.

Credits için local storage authoritative source değildir.

53. DESIGN SYSTEM

Tekrarlanan değerleri:

AppSpacing
AppRadius
AppTypography
AppColors
AppShadows

olarak merkezi yönet.

Örneğin:

spacing4
spacing8
spacing12
spacing16
spacing24
spacing32

Rastgele EdgeInsets.all(17) kullanma.

54. ACCESSIBILITY

Minimum:

Dynamic Text destekle
contrast yeterli olsun
touch target minimum ~44x44
semantic labels
screen reader uyumu
animation azaltma ayarına saygı
sadece renk ile durum anlatma
55. LOCALIZATION

İlk dil:

en

Hazır altyapı:

tr
de
es
fr
pt
ja
ko

Ama MVP'de çeviri üretmek için kod içine string gömme.

Flutter localization kullan.

Örnek:

l10n.en.arb
l10n.tr.arb
56. APP ICON

Basit ve tanınabilir:

fotoğraf çerçevesi
sparkle
before/after hissi

Karmaşık AI robotu kullanma.

App icon küçük boyutta bile anlaşılmalı.

57. APP STORE ASO

App name örneği:

Photo Fixer - AI Enhancer

Subtitle:

Fix blurry & low-quality photos

Keywords:

photo enhancer
photo fixer
unblur
restore photo
AI photo editor
enhance image

Store screenshots:

Bad photo → good photo
One tap enhancement
Before/after slider
Old photo restoration
Fast processing

İlk screenshot'ta özellik listesi gösterme.

Sonucu göster.

58. MARKETING ASSET STRATEGY

İlk 20 video:

Before → After

formatında.

Örnek:

"This photo was taken in 2012."

before

"Watch what happens..."

after

veya:

"Can AI fix this blurry photo?"

Sonuç.

CTA:

Try Photo Fixer

Video 10–15 saniye.

59. VIRAL LOOP

Result screen:

Share

seçeneği.

Paylaşım görseline küçük watermark:

Enhanced with Photo Fixer

eklenebilir.

Ama watermark çok büyük olmamalı.

60. SUPPORT

Settings:

Contact Support

Teknik olarak:

mailto:support@yourdomain.com

kullanılabilir.

Kullanıcı ID'sini support request'e otomatik ekle.

Fotoğrafları support'a otomatik gönderme.

61. LOGGING

Production loglarında:

YASAK:

image base64
photo URL
Gemini API key
purchase token
personal user content

izin verilen:

jobId
uid hash
operation
duration
status
error code
model
62. SECURITY CHECKLIST

AI coding agent şunları ASLA yapmamalı:

Gemini key'i Flutter'a koyma
Firebase Admin credential'larını app'e koyma
Google service account JSON'u repo'ya koyma
App Store private key'i repo'ya koyma
purchase validation'ı yalnızca client'ta yapma
credits'ı client'ın yazmasına izin verme
Firestore'u test için allow read, write: if true bırakma
Storage'ı public bırakma
.env dosyasını git'e commit etme
kullanıcı fotoğraflarını kalıcı saklama

.gitignore:

.env
.env.*
*.pem
*.p8
*.p12
*.mobileprovision
google-services-secret.json
service-account*.json
63. CI/CD

MVP'de GitHub Actions eklenebilir.

Minimum:

flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
flutter build ipa

Secrets GitHub Secrets'ta tutulmalı.

App Store signing secret'larını local repo'ya koyma.

64. TESTLER

Minimum unit test:

credit calculation
purchase mapping
operation mapping
API error mapping

Widget tests:

Home
Paywall
Result
Error

Integration:

select image
process
purchase
restore
notification tap

Gerçek cihaz testi zorunlu.

65. 14 GÜNLÜK GELİŞTİRME PLANI
Day 1
Flutter project
Firebase project
Android/iOS setup
theme
routing
basic home
Day 2
image picker
camera/gallery
image compression
editor screen
Day 3
Firebase Auth anonymous
Firestore schema
App Check
backend skeleton
Day 4
Gemini backend integration
enhance operation
test image pipeline
Day 5
result screen
before/after slider
save/share
Day 6
unblur
relight
restore
prompt templates
Day 7
credit system
free credits
backend reservation/consume/release
Day 8
App Store IAP
Google Play Billing
products
purchase listener
Day 9
server-side purchase verification
restore
duplicate transaction protection
Day 10
paywall
analytics
Crashlytics
Remote Config
Day 11
FCM
notification permission
manual notification support
deep links
Day 12
privacy
terms
delete data
error states
accessibility
Day 13
App Store screenshots
Play Store listing
TestFlight
Play internal testing
Day 14
real-device testing
production build
launch
first acquisition tests
66. MVP DEFINITION OF DONE

Uygulama "done" sayılır ancak şu akış tamamen çalışıyorsa:

Install
 ↓
Open
 ↓
No signup
 ↓
Pick photo
 ↓
Enhance
 ↓
See before/after
 ↓
Save
 ↓
Use free credits
 ↓
Run out of credits
 ↓
Paywall
 ↓
Apple/Google native purchase
 ↓
Credits granted
 ↓
Enhance another photo
 ↓
Notification received
 ↓
Crashlytics event recorded

Bu akıştan herhangi biri çalışmıyorsa "ürün bitti" deme.

67. AI CODING AGENT İÇİN ÇALIŞMA KURALLARI

Bu dosyayı uygularken agent:

Önce mevcut repo yapısını incelemeli.
Mevcut çalışan kodu gereksiz yere silmemeli.
Büyük refactor yapmadan küçük commit'lerle ilerlemeli.
Her feature'dan sonra flutter analyze çalıştırmalı.
Her kritik feature için test yazmalı.
Mock backend kullanarak UI'ı önce çalıştırabilir.
Production secrets kod içine koymamalı.
Firebase Security Rules yazmadan Firebase entegrasyonunu "tamamlandı" kabul etmemeli.
IAP'i mock ederek UI geliştirmeli, sonra gerçek sandbox'a bağlamalı.
Gemini API'yi doğrudan Flutter'dan çağırmamalı.
UI'da hard-coded English string bırakmamalı.
Platform-specific kod gerekiyorsa adapter/service katmanında izole etmeli.
Kullanıcı fotoğraflarını loglamamalı.
Her API hatasını kullanıcı dostu bir state'e çevirmeli.
Loading state sırasında kullanıcıya tekrar tekrar işlem başlatma izni vermemeli.
Double-tap ile iki processing job oluşmasını engellemeli.
Purchase callback'in iki kez gelmesini tolere etmeli.
Network retry işlemlerinde duplicate credit tüketmemeli.
Firestore transaction kullanılması gereken yerlerde atomic update kullanmalı.
"TODO" bırakıp kritik güvenlik/ödeme işini geçiştirmemeli.
68. KOD KALİTESİ

Tercih:

final
immutable models
sealed states where appropriate
repository pattern
dependency injection
typed failures
small widgets
small services

Kaçın:

God classes
Global mutable state
Business logic in widgets
Firebase calls everywhere
Magic strings
Magic numbers
Duplicated API code
Duplicated purchase code
69. İLK SÜRÜMDE YAPILMAYACAKLAR

Kesinlikle sonraya bırak:

user accounts
social feed
cloud photo library
collaboration
batch editing
video
face swap
AI avatar
filters
manual curves
advanced crop
desktop
web
referral system
complex subscription tiers
admin dashboard
elaborate onboarding

Bunlar 14 günlük hedefi öldürür.

70. TEKNİK KABUL KRİTERLERİ
Security
 Gemini key client'ta yok
 Firebase Admin credentials client'ta yok
 Firestore credits client-write kapalı
 Purchase verification backend'de
 App Check production'da aktif
 Storage erişimi güvenli
 Secrets git'te yok
Payments
 iOS StoreKit / App Store IAP çalışıyor
 Android Google Play Billing çalışıyor
 consumable purchase çalışıyor
 restore davranışı test edildi
 duplicate transaction engellendi
 interrupted purchase test edildi
 purchase sonrası kredi doğru eklendi
AI
 enhance çalışıyor
 unblur çalışıyor
 relight çalışıyor
 restore çalışıyor
 timeout handling var
 retry var
 rate limit var
 image size validation var
Notifications
 iOS permission
 Android 13+ permission
 FCM token
 foreground handling
 background handling
 terminated handling
 notification tap routing
 manual Firebase notification
UX
 first photo without account
 free credits
 before/after
 save
 share
 paywall after value
 friendly errors
 loading state
 retry
71. REFERANSLAR

Flutter IAP:
https://docs.flutter.dev/resources/in-app-purchases-overview

Apple In-App Purchase:
https://developer.apple.com/documentation/storekit/in-app-purchase

Apple IAP configuration:
https://developer.apple.com/help/app-store-connect/configure-in-app-purchase-settings/overview-for-configuring-in-app-purchase-settings

Google Play Billing:
https://developer.android.com/google/play/billing/

Firebase Cloud Messaging Flutter:
https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages

Firebase App Check Flutter:
https://firebase.google.com/docs/app-check/flutter/default-providers

Gemini API key security:
https://ai.google.dev/gemini-api/docs/api-key

Gemini image understanding:
https://ai.google.dev/gemini-api/docs/image-understanding

Gemini image editing:
https://ai.google.dev/gemini-api/docs/image-generation

72. SON TALİMAT — AI CODING AGENT

Bu proje 14 günlük MVP'dir.

Öncelik sırası:

1. Working photo processing
2. Great before/after UX
3. Native payments
4. Credit system
5. Firebase security
6. Crash/analytics
7. Notifications
8. Store readiness
9. Visual polish
10. Extra features

Bir özellik bu sıradaki daha önemli bir özelliği geciktiriyorsa yapılmayacak.

Özellikle:

Kod yazmak ürün geliştirmek değildir.

14 gün sonunda hedef "çok özellikli uygulama" değil:

Gerçek cihazda çalışan, gerçek fotoğrafı işleyen, gerçek Apple/Google ödemesi alan ve gerçek kullanıcıdan para alabilecek kadar güvenilir bir MVP'dir.

Agent önce bu dokümandaki mimariyi çıkarıp dosya yapısını planlamalı, ardından feature'ları sırayla uygulamalıdır.

Her aşamada build/test çalıştırmalı ve bir sonraki aşamaya kırık build ile geçmemelidir.
