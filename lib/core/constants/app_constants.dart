/// App-wide constants. Keep [appName] in sync with platform labels:
/// - `android/app/src/main/AndroidManifest.xml` → `android:label`
/// - `ios/Runner/Info.plist` → `CFBundleDisplayName`
abstract final class AppConstants {
  static const String appName = 'Product Catalog';
}
