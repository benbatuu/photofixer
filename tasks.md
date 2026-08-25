# PHOTO FIXER — Detaylı Task Breakdown

> Kaynak: [`project.md`](./project.md)  
> Hedef: 14 günde MVP → App Store + Google Play → ilk ücretli kullanıcı  
> Stack: Flutter · Firebase · Gemini · Native IAP (Stripe/RevenueCat yok)

Bu dosya `project.md` içeriğini **epik → task → kabul kriteri** yapısına böler. Her task bağımsız veya net bağımlılıkla ilerletilebilir olmalı.

---

## Nasıl kullanılır

| Sembol | Anlam |
|--------|--------|
| `[ ]` | Yapılacak |
| `[~]` | Devam ediyor |
| `[x]` | Tamam |
| `P0` | MVP blocker |
| `P1` | MVP güçlü öneri |
| `P2` | Launch sonrası / polish |

**Öncelik sırası (project.md §72):**  
1 Processing → 2 Before/After UX → 3 Native payments → 4 Credits → 5 Firebase security → 6 Crash/Analytics → 7 Notifications → 8 Store → 9 Polish → 10 Extra

---

## Epic 0 — Proje iskeleti & altyapı (Day 1)

### T0.1 Flutter projesi
- [x] `flutter create` ile Android + iOS hedefi
- [x] Package / Bundle ID belirle (`com.bennbatuu.photofixer`)
- [x] Dart SDK / Flutter channel pinle
- [x] Feature-first klasör yapısını oluştur (`lib/app`, `core`, `features`, `services`, `shared`)
- [x] Riverpod + go_router (veya seçilen router) ekle
- [x] `.gitignore` secrets kuralları (§62)

**Kabul:** `flutter analyze` temiz; boş Home route açılıyor.

### T0.2 Tema & design system
- [x] `AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`, `AppShadows`
- [x] Light (+ opsiyonel dark) theme
- [x] Primary CTA stili, büyük fotoğraf odaklı layout
- [x] Magic number / rastgele EdgeInsets yasak

**Kabul:** Theme dosyasından renk/spacing yönetiliyor; “AI template” görünümü yok.

### T0.3 Localization altyapısı
- [x] `flutter_localizations` + ARB (`l10n.en.arb`)
- [x] Placeholder ARB iskeleti: `tr`, `de`, `es`, `fr`, `pt`, `ja`, `ko`
- [x] UI’da hard-coded English string yok (hepsi l10n)

**Kabul:** İlk dil `en`; diğer locale dosyaları boş/iskelet olabilir.

### T0.4 App launch flow iskeleti
- [x] Splash → init pipeline stub (§47)
- [x] Minimum version check stub (Remote Config / Firestore config)
- [x] Router: `/`, `/onboarding`, `/editor`, `/result`, `/paywall`, `/settings`

**Kabul:** Init sırası kodda görünür; hata halinde kullanıcı dostu fallback.

---

## Epic 1 — Onboarding & Home (Day 1–2)

### T1.1 Onboarding (max 2–3 ekran)
- [x] Screen 1: “Make every photo look better.”
- [x] Screen 2: before/after animasyon + “One tap”
- [x] Screen 3: “3 free photo enhancements” + Start
- [x] Signup yok; `onboarding_completed` local + Firestore flag

**Kabul:** İlk açılışta onboarding; tekrar açılışta Home.

### T1.2 Home screen
- [x] Greeting + tek ana headline
- [x] Ana CTA: **Enhance a photo**
- [x] İkincil: Relight / Unblur / Restore (ikinci seviye)
- [x] Opsiyonel demo before/after
- [x] Recent (local metadata) — basit liste yeterli

**Kabul:** Ana akış tek CTA ile başlıyor; seçenek bombardımanı yok.

---

## Epic 2 — Image picker & client pipeline (Day 2)

### T2.1 Gallery / Camera
- [x] Native picker (mümkünse)
- [x] Gallery + Camera seçenekleri
- [x] iOS / Android permission metinleri (§23)
- [x] Permission reddedilirse graceful UX

**Kabul:** Kullanıcı fotoğraf seçebiliyor; crash yok.

### T2.2 Local image prep
- [x] EXIF orientation normalize
- [x] Uzun kenar resize (≤ 4096, pratikte daha düşük hedef)
- [x] JPEG ~85 compression
- [x] Max 12 MB input validation (client)
- [x] Format: JPEG, PNG, HEIC/WEBP (desteklenen)
- [x] Orijinal cihazda kalsın; API’ye optimize kopya

**Kabul:** Büyük fotoğrafta memory spike yok; upload boyutu makul.

### T2.3 Editor / işlem seçim ekranı
- [x] Seçilen fotoğraf preview
- [x] Operation enum: `enhance | unblur | relight | restore`
- [x] Processing başlat CTA
- [x] Double-tap / double-submit koruması

**Kabul:** State machine: `idle → selected → uploading → processing → completed | error`

---

## Epic 3 — Firebase Auth, Firestore, App Check (Day 3)

### T3.1 Firebase projesi
- [x] Android `google-services.json` / iOS `GoogleService-Info.plist` (git’e secret koyma disiplini)
- [x] Firebase Core, Auth, Firestore, Storage, Analytics, Crashlytics, FCM, App Check paketleri
- [ ] Dev vs Prod Firebase ortam ayrımı (mümkünse)

**Kabul:** Config dosyaları doğru yerde; `Firebase.initializeApp` bootstrap’ta çalışıyor.

### T3.2 Anonymous Auth
- [x] İlk açılışta anonymous sign-in
- [x] Email/signup yok
- [x] `users/{uid}` document create (server veya controlled client fields)

**Kabul:** Kullanıcı hesabı olmadan tüm flow ilerler.

### T3.3 Firestore schema
- [x] `users/{uid}` — credits, platform, locale, flags, lastActiveAt
- [x] `users/{uid}/purchases/{purchaseId}`
- [x] `users/{uid}/credit_ledger/{ledgerId}`
- [x] `users/{uid}/jobs/{jobId}`
- [x] `users/{uid}/devices/{tokenHash}`
- [x] `config/app` — freeCredits, limits, maintenance, min versions

**Kabul:** Schema dokümante; index’ler hazır.

### T3.4 Security Rules (P0)
- [x] Client: kendi user/job **read**
- [x] Client: sınırlı preferences **write**
- [x] Client **yazamaz**: credits, purchases, ledger, verification
- [x] Storage: sadece authenticated + path owner; public list yok
- [x] `allow read, write: if true` production’da yasak

**Kabul:** Emulator veya rules unit test ile credits write reddediliyor.

### T3.5 App Check
- [x] Android Play Integrity (prod)
- [x] iOS DeviceCheck / App Attest (prod)
- [x] Debug provider (dev only)
- [ ] Prod’da debug token bırakma

**Kabul:** Callable Functions App Check token bekliyor (en az enforce planı).

---

## Epic 4 — Cloud Functions iskeleti (Day 3–4)

### T4.1 Functions repo yapısı
```
functions/src/
  index.ts
  config/
  auth/
  gemini/
  payments/
  notifications/
  cleanup/
  analytics/
```
- [ ] TypeScript Functions bootstrap
- [ ] Secrets: Gemini key Secret Manager / Functions secrets
- [ ] Ortak error model (§41)

### T4.2 Standart API error codes
- [ ] `UNAUTHENTICATED`, `APP_CHECK_FAILED`, `INVALID_IMAGE`, `IMAGE_TOO_LARGE`
- [ ] `INSUFFICIENT_CREDITS`, `GEMINI_*`, `RATE_LIMITED`, `INTERNAL_ERROR`
- [ ] `PURCHASE_NOT_VERIFIED`
- [ ] Flutter mapping → kullanıcı dostu mesajlar

**Kabul:** Client asla raw Gemini/stacktrace göstermiyor.

### T4.3 Rate limit & maliyet kontrolleri
- [ ] Anonymous: 5 req/hour (config)
- [ ] Higher paid limit (config)
- [ ] Max image size, concurrent jobs, max 2 retries + backoff
- [ ] Job metadata: model, operation, latency, success, estimatedCost

---

## Epic 5 — Gemini photo processing (Day 4–6) — P0

### T5.1 `processPhoto()` callable
- [ ] Auth + App Check
- [ ] Input validation (size, type, operation)
- [ ] Credit reservation (atomic Firestore transaction)
- [ ] Gemini call (key sadece backend)
- [ ] Response validation
- [ ] Temp Storage write + signed/short URL
- [ ] Success → consume credit; failure → release
- [ ] Job document status lifecycle

**Input örneği:**
```json
{ "jobId": "...", "operation": "enhance", "imageBase64": "..." }
```
(Alternatif: Storage path upload + jobId — büyük payload için tercih edilebilir.)

### T5.2 Model config
- [ ] `GEMINI_IMAGE_MODEL` env/secret (client’a gömme)
- [ ] Model değişince app update gerekmesin

### T5.3 Prompt templates
- [ ] Enhance (§8)
- [ ] Relight
- [ ] Restore
- [ ] Unblur (aşırı vaat yok)

**Kabul:** Her operation ayrı template; identity/composition korunumu talimatı var.

### T5.4 Client `PhotoProcessingService`
- [ ] Abstract service + Riverpod controller
- [ ] Widget içinde Firestore/Gemini yok
- [ ] Loading sırasında ikinci job engeli

### T5.5 Privacy / TTL cleanup
- [ ] Original + processed temporary
- [ ] `cleanupTemporaryFiles()` scheduled
- [ ] UI copy: temporary + secure processing
- [ ] History: local metadata only (MVP)

**Kabul:** Storage’da sonsuz foto birikmiyor.

---

## Epic 6 — Result UX (Day 5) — P0

### T6.1 Result screen
- [ ] Interactive before/after slider
- [ ] “Enhanced successfully”
- [ ] Save to Photos
- [ ] Share
- [ ] Credits left
- [ ] Enhance another

### T6.2 Processing UX
- [ ] Boş spinner yok
- [ ] Deterministik adımlar (Step 1 of 3…)
- [ ] Sahte % progress yok

### T6.3 Free vs paid export
- [ ] Free: standard quality (+ opsiyonel subtle watermark)
- [ ] Paid: HD / full res CTA
- [ ] Sonucu gizleyip “PAY NOW” yapma — önce wow, sonra paywall

### T6.4 Error UX
- [ ] Friendly copy + Try again
- [ ] Reserved credit release on failure
- [ ] Offline banner (§40)

---

## Epic 7 — Credit sistemi (Day 7) — P0

### T7.1 Free allowance
- [ ] Yeni kullanıcı: **3 free photo fixes**
- [ ] Server-side grant + ledger (`type: free`)
- [ ] Client SharedPreferences tek kaynak değil

### T7.2 Ledger & atomic credits
- [ ] `credit_ledger`: free | purchase | usage | refund | adjustment
- [ ] Reserve → consume / release
- [ ] Race: iki cihaz aynı anda → transaction güvenli

### T7.3 Client credit display
- [ ] Read-only credits from Firestore / cloud function
- [ ] UI: “photos” dili; token/API cost gösterme

**Kabul:** Credits client write ile manipüle edilemiyor.

---

## Epic 8 — Native IAP (Day 8–9) — P0

### T8.1 Store ürünleri
| Product ID | Credits | Öneri fiyat |
|------------|---------|-------------|
| `photo_fixer_10_credits` | 10 | $2.99 |
| `photo_fixer_30_credits` | 30 | $5.99 |
| `photo_fixer_100_credits` | 100 | $12.99 |

- [ ] App Store Connect + Google Play Console ürünleri (consumable)
- [ ] Fiyatları kodda hard-code etme; mağaza bilgisinden al
- [ ] UI: “10 photos / 30 photos / 100 photos”

### T8.2 Flutter `in_app_purchase`
- [ ] Resmi paket; üçüncü parti ödeme SDK yok
- [ ] `PurchaseService` abstraction (§48)
- [ ] `purchaseStream` **app açılır açılmaz** dinle
- [ ] Buy / restore / pending / interrupted handling

### T8.3 `verifyPurchase()` backend
- [ ] Apple / Google server verification
- [ ] Unique transactionId → duplicate engeli
- [ ] Credit grant + purchase doc + ledger
- [ ] Client `completePurchase`
- [ ] Same tx → `already_processed`

### T8.4 IAP test matrix (§35)
- [ ] Success / cancel / pending
- [ ] Network lost / app killed mid-purchase
- [ ] Restore / duplicate callback
- [ ] Second device / already processed
- [ ] **Kritik:** purchase → kill → reopen → credit exactly once

### T8.5 Settings: Restore purchases
- [ ] Consumable + server ledger ile tutarlı davranış

---

## Epic 9 — Paywall (Day 10)

### T9.1 Paywall timing
- [ ] Açılışta paywall yok
- [ ] Flow: first photo → process → wow → paywall
- [ ] Preview göster; HD unlock CTA

### T9.2 Products UI
- [ ] 10 / 30 / 100 packs
- [ ] Store fiyatları
- [ ] Purchase start/complete/fail analytics

### T9.3 Feature flags / Remote Config (hafif)
- [ ] `enhanceEnabled` vb.
- [ ] `freeCredits`, `paywallVariant`, timeouts
- [ ] Fiyatı Remote Config ile belirleme (yasak)

---

## Epic 10 — Analytics & Crashlytics (Day 10)

### T10.1 AnalyticsService
- [ ] Widget’ta doğrudan Firebase Analytics yok
- [ ] Events (§26): app_open, onboarding_completed, photo_selected, processing_*, result_*, paywall_*, purchase_*, credit_consumed, …
- [ ] Params: operation, platform, size/time buckets, free_or_paid, product_id
- [ ] PII / fotoğraf içeriği gönderme

### T10.2 Crashlytics
- [ ] Init release build
- [ ] Image picker, memory, IAP, FCM, Firebase init alanları
- [ ] Production log yasakları (§61)

---

## Epic 11 — Push notifications (Day 11)

### T11.1 FCM setup
- [ ] Token → `users/{uid}/devices/{tokenHash}`
- [ ] Foreground / background / terminated
- [ ] `getInitialMessage` + `onMessageOpenedApp`

### T11.2 Permission UX
- [ ] Açılışta native popup yok
- [ ] Custom explainer → sonra sistem permission
- [ ] Reddetse app çalışmaya devam

### T11.3 Reengagement (hafif)
- [ ] day 3 / 7 / 14 optional (spam yok)
- [ ] Manual Console → topic `all_users`
- [ ] Deep link payload → home / paywall

### T11.4 Local notification
- [ ] MVP’de zorunlu değil; skip veya stub

---

## Epic 12 — Privacy, legal, account (Day 12)

### T12.1 Privacy Policy + Terms
- [ ] Web URL’ler hazır
- [ ] Store metadata’ya ekle
- [ ] AI disclaimer (kusursuz sonuç yok)
- [ ] Fotoğraf temporary; satılmaz; analytics içeriği kaydetmez

### T12.2 Delete my data
- [ ] Temp files sil
- [ ] Firestore user/job temizle
- [ ] Anonymous auth delete
- [ ] Purchase kayıtları policy’de açıkla (yasal tutma)

### T12.3 Settings minimum
- [ ] Restore, Privacy, Terms, Support (mailto + uid), Rate, Notifications, Delete Data

### T12.4 Accessibility minimum
- [ ] Dynamic text, contrast, 44pt targets, semantics, reduce motion

### T12.5 AI safety UX
- [ ] Blocked/harmful → “This image can't be processed.”
- [ ] Kullanıcı hakları disclaimer

---

## Epic 13 — Store listing & QA (Day 13–14)

### T13.1 iOS store prep
- [ ] Bundle ID, ASC app, Paid Apps Agreement
- [ ] IAP products, Privacy details, age rating
- [ ] Screenshots, icon, TestFlight, Sandbox IAP

### T13.2 Android store prep
- [ ] Package, merchant, Billing products, Play Integrity
- [ ] Data Safety, content rating, internal testing track

### T13.3 ASO assets
- [ ] Name/subtitle/keywords (§57)
- [ ] Screenshots: sonuç odaklı (özellik listesi değil)
- [ ] Icon: basit frame/sparkle/before-after hissi

### T13.4 Definition of Done checklist (§66)
- [ ] Install → no signup → pick → enhance → before/after → save
- [ ] Free credits bitince paywall → native purchase → credits
- [ ] Enhance again → notification → Crashlytics kayıt

### T13.5 Real device matrix
- [ ] Düşük RAM Android
- [ ] Eski iOS cihaz
- [ ] Offline UI
- [ ] Full IAP sandbox matrix

---

## Epic 14 — CI, test, kalite (paralel)

### T14.1 Unit tests
- [ ] Credit calculation / reservation logic
- [ ] Purchase mapping
- [ ] Operation mapping
- [ ] API error → UI message mapping

### T14.2 Widget tests
- [ ] Home, Paywall, Result, Error

### T14.3 Integration (mümkün olduğunca)
- [ ] select → process → purchase → restore → notification tap

### T14.4 CI (opsiyonel MVP)
- [ ] `flutter analyze` / `test` / APK / AAB / IPA pipeline
- [ ] Secrets yalnızca CI secrets

### T14.5 Kod kalitesi kuralları (sürekli)
- [ ] Services/repositories; business logic widget’ta değil
- [ ] Immutable models, sealed states, typed failures
- [ ] Kritik güvenlik/ödeme TODO bırakma

---

## 14 günlük sprint map

| Gün | Odak | Task ID’ler |
|-----|------|-------------|
| 1 | Project, Firebase, theme, home | T0.*, T1.2 |
| 2 | Picker, compression, editor | T2.*, T1.1 |
| 3 | Auth, schema, App Check, Functions skeleton | T3.*, T4.1–T4.2 |
| 4 | Gemini enhance + pipeline | T5.1–T5.4, T4.3 |
| 5 | Result, slider, save/share | T6.* |
| 6 | Unblur / Relight / Restore prompts | T5.3 (kalan), T5.5 |
| 7 | Credits + reservation | T7.* |
| 8 | IAP client + products | T8.1–T8.2 |
| 9 | Verify purchase + restore + dupe guard | T8.3–T8.5 |
| 10 | Paywall, Analytics, Crashlytics, RC | T9.*, T10.* |
| 11 | FCM, permission, deep link | T11.* |
| 12 | Privacy, delete data, a11y, errors | T12.* |
| 13 | Store assets, TestFlight, Play internal | T13.1–T13.3 |
| 14 | Device QA, launch DoD | T13.4–T13.5, T14.* |

---

## MVP dışına bırakılanlar (yapma listesi)

Aşağıdakiler **bilinçli olarak out of scope** — task açma:

- Email/social hesap, feed, follow, cloud library
- Batch edit, video, face swap, filtre mağazası, advanced editor
- Web/desktop, referral, karmaşık subscription tiers
- Admin dashboard, ağır A/B altyapısı
- Üçüncü parti payment (Stripe, RevenueCat, Adapty, …)
- Gemini key veya Admin credentials client’ta

---

## Agent çalışma kuralları (task yürütürken)

1. Önce repo’yu incele; çalışan kodu silme.
2. Küçük adımlarla ilerle; her kritik feature sonrası `flutter analyze`.
3. UI’ı mock IAP / mock process ile önce ayağa kaldır; sonra sandbox’a bağla.
4. Gemini’yi yalnızca Cloud Function üzerinden çağır.
5. Security Rules + server verification olmadan “payments/credits done” deme.
6. Loading’de double job / double credit consume engelle.
7. Purchase stream’i app start’ta dinle; interrupted purchase’i tolere et.
8. Broken build ile bir sonraki güne geçme.

---

## Hızlı DoD skoru (launch öncesi)

| Alan | Minimum |
|------|---------|
| Security | Key client’ta yok · credits client-write kapalı · App Check · verified purchase |
| Payments | iOS + Android consumable · dupe-safe · kill-app recover |
| AI | 4 operation · size limit · rate limit · retry≤2 · blocked UX |
| UX | No signup first value · before/after · free 3 · paywall after wow |
| Ops | Analytics + Crashlytics · privacy URL · delete data · store listings |

---

*Bu dosya `project.md` ile birlikte yaşar. Spec değişirse önce `project.md`, sonra bu task listesini güncelle.*
