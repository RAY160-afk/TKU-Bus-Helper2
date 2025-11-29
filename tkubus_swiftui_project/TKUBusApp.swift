import SwiftUI

@main
struct TKUBusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ScheduleViewModel.shared)
                .environmentObject(BusViewModel.shared)
        }
    }
}
