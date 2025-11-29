import Foundation
import UserNotifications

class ScheduleViewModel: ObservableObject {
    static let shared = ScheduleViewModel()
    @Published var schedules: [ClassSchedule] = []

    private init() { load() }

    func load() {
        if let data = UserDefaults.standard.data(forKey: "tkubus_schedule") {
            if let arr = try? JSONDecoder().decode([ClassSchedule].self, from: data) {
                schedules = arr
            }
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(schedules) {
            UserDefaults.standard.set(data, forKey: "tkubus_schedule")
        }
    }

    func todayLastClassEnd() -> Date? {
        let calWeekday = Calendar.current.component(.weekday, from: Date()) // 1=Sunday
        func isoToCal(_ iso: Int) -> Int { return iso % 7 + 1 }
        guard let target = schedules.first(where: { isoToCal($0.weekday) == calWeekday }),
              let last = target.periods.max(),
              let timeStr = PeriodTime.map[last]
        else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let datePrefix = String(formatter.string(from: Date()).prefix(10))
        return formatter.date(from: "\(datePrefix) \(timeStr)")
    }

    func scheduleLocalNotificationForLastClass() {
        guard let end = todayLastClassEnd() else { return }
        let content = UNMutableNotificationContent()
        content.title = "下課囉 — 查詢公車到站"
        content.body = "點此查看紅27 / 紅28 / 756 哪班最快到站。"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: end)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let req = UNNotificationRequest(identifier: "tkubus_lastclass", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(req) { _ in }
    }
}
