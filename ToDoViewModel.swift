import Foundation
import UserNotifications
import SwiftUI

class ToDoViewModel: ObservableObject {
    @Published var items: [ToDoItem] = []

    func addItem(title: String, body: String, image: UIImage?, reminderDate: Date, daysOfWeek: [Int]) {
        let imageData = image?.jpegData(compressionQuality: 1.0) // Convert UIImage to Data
        let newItem = ToDoItem(title: title, body: body, imageData: imageData, reminderDate: reminderDate, daysOfWeek: daysOfWeek)
        items.append(newItem)
        scheduleNotifications(for: newItem)
    }
    
    private func scheduleNotifications(for item: ToDoItem) {
        guard let reminderDate = item.reminderDate else { return }

        // Remove any existing notifications for this item
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])

        let notificationCenter = UNUserNotificationCenter.current()

        for dayIndex in item.daysOfWeek {
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderDate)
            dateComponents.weekday = dayIndex + 1 // Weekday component needs to be 1-based (1 = Sunday, 2 = Monday, etc.)
            
            let content = UNMutableNotificationContent()
            content.title = item.title
            content.body = item.body
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error adding notification: \(error.localizedDescription)")
                }
            }
        }
    }
}


