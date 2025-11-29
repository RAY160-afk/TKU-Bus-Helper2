import Foundation
import BackgroundTasks

class ScheduleManager {
    static let shared = ScheduleManager()
    private init() {}

    func scheduleBackgroundRefresh() {
        let req = BGAppRefreshTaskRequest(identifier: "com.yourteam.tkubus.refresh")
        req.earliestBeginDate = Date(timeIntervalSinceNow: 60*60)
        do { try BGTaskScheduler.shared.submit(req) } catch { print("Could not schedule: \(error)") }
    }
}
