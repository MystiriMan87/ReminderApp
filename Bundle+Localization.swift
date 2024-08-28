import Foundation

extension Bundle {
    private static var bundle: Bundle!

    public static func setLanguage(_ language: String) {
        // Set the new language as the default for the app
        defer {
            object_setClass(Bundle.main, BundleEx.self)
        }
        // Load the appropriate .lproj bundle for the selected language
        Bundle.bundle = Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj")!)
    }

    private class BundleEx: Bundle {
        override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
            // Use the new bundle for localization
            return Bundle.bundle.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
