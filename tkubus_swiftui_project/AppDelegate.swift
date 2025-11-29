import UIKit
import BackgroundTasks
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourteam.tkubus.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            // handle
        }

        return true
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        ScheduleManager.shared.scheduleBackgroundRefresh()

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        let op = BlockOperation {
            BusViewModel.shared.fetchAllSync()
        }

        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        op.completionBlock = {
            task.setTaskCompleted(success: !op.isCancelled)
        }

        queue.addOperation(op)
    }
}
