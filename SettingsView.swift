import SwiftUI

struct SettingsView: View {
    @State private var selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"

    var body: some View {
        VStack {
            Text(NSLocalizedString("settings_title", comment: ""))
                .font(.largeTitle)
                .padding()

            Picker(NSLocalizedString("select_language", comment: ""), selection: $selectedLanguage) {
                Text("English").tag("en")
                Text("Русский").tag("ru")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button(action: {
                changeLanguage()
            }) {
                Text(NSLocalizedString("save_language", comment: ""))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    private func changeLanguage() {
        UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        Bundle.setLanguage(selectedLanguage)
        // Re-load the root view or notify the system to update the UI with the new language
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: ContentView())
    }
}
