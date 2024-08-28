import SwiftUI

@main
struct YourAppNameApp: App {
    init() {
           // Load the selected language from UserDefaults or default to "en" (English)
           let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
           Bundle.setLanguage(selectedLanguage)
       }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


