import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [PenEntry] = []
    @Published var isPro: Bool = false

    static let freeLimit = 23

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("batchnib_entries.json")
    }()

    init() {
        load()
        if entries.isEmpty {
            seed()
        }
    }

    func seed() {
        entries = [
        PenEntry(name: "Walnut Slimline", blank: "Black walnut", kit: "Slimline chrome", finish: "CA gloss", notes: "Gift for Dad"),
        PenEntry(name: "Acrylic Swirl Sierra", blank: "Blue acrylic swirl", kit: "Sierra gunmetal", finish: "Buffed acrylic", notes: "Craft show stock"),
        PenEntry(name: "Resin Cast Jr Gent", blank: "Turquoise resin cast", kit: "Jr Gent II gold", finish: "Micromesh polish", notes: "Custom order")
        ]
        save()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(blank: String, kit: String, finish: String, notes: String) {
        guard canAddMore else { return }
        let entry = PenEntry(name: name, blank: blank, kit: kit, finish: finish, notes: notes)
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: PenEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[idx] = entry
            save()
        }
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: PenEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([PenEntry].self, from: data) {
            entries = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
