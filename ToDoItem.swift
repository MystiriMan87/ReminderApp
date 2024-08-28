import Foundation
import UIKit

struct ToDoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var body: String
    var imageData: Data? // Store image data instead of UIImage
    var reminderDate: Date?
    var daysOfWeek: [Int] // Store days of the week as integers (0 for Sunday, 1 for Monday, etc.)

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case imageData
        case reminderDate
        case daysOfWeek
    }
    
    // Custom initializer to handle decoding of image data
    init(title: String, body: String, imageData: Data?, reminderDate: Date?, daysOfWeek: [Int]) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.imageData = imageData
        self.reminderDate = reminderDate
        self.daysOfWeek = daysOfWeek
    }
    
    // Custom initializer to handle decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
        reminderDate = try container.decodeIfPresent(Date.self, forKey: .reminderDate)
        daysOfWeek = try container.decode([Int].self, forKey: .daysOfWeek)
    }
    
    // Custom method to handle encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
        try container.encodeIfPresent(imageData, forKey: .imageData)
        try container.encodeIfPresent(reminderDate, forKey: .reminderDate)
        try container.encode(daysOfWeek, forKey: .daysOfWeek)
    }

    // Convert UIImage to Data
    func imageToData(image: UIImage?) -> Data? {
        return image?.jpegData(compressionQuality: 1.0)
    }

    // Create UIImage from Data
    static func dataToImage(_ data: Data?) -> UIImage? {
        guard let data = data else { return nil }
        return UIImage(data: data)
    }
}


