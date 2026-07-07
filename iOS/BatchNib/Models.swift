import Foundation

struct PenEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var blank: String
    var kit: String
    var finish: String
    var notes: String
    var dateCreated: Date = Date()
}
