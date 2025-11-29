import Foundation

struct ClassSchedule: Codable, Identifiable {
    let id = UUID()
    var weekday: Int // 1=Monday .. 7=Sunday (ISO-style for easier input)
    var periods: [Int]
}
