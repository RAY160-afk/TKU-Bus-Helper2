import Foundation

class BusViewModel: ObservableObject {
    static let shared = BusViewModel()
    @Published var results: [String:Int] = [:]
    let routes = ["紅27","紅28","756"]

    func fetchAll() {
        results.removeAll()
        for r in routes {
            BusAPI.fetchETA(route: r) { eta in
                DispatchQueue.main.async {
                    if let eta = eta { self.results[r] = eta }
                }
            }
        }
    }

    func fetchAllSync() {
        let group = DispatchGroup()
        var tmp: [String:Int] = [:]
        for r in routes {
            group.enter()
            BusAPI.fetchETA(route: r) { eta in
                if let e = eta { tmp[r] = e }
                group.leave()
            }
        }
        group.wait()
        DispatchQueue.main.async { self.results = tmp }
    }

    func bestRoute() -> (String, Int)? {
        guard let minPair = results.min(by: { $0.value < $1.value }) else { return nil }
        return (minPair.key, minPair.value)
    }
}
