import Foundation

class BusAPI {
    static func fetchETA(route: String, completion: @escaping (Int?) -> Void) {
        let routeEncoded = route.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? route
        let urlString = "https://ptx.transportdata.tw/MOTC/v2/Bus/EstimatedTimeOfArrival/City/NewTaipei?$filter=RouteName/Zh_tw eq '\(routeEncoded)'&$format=JSON"
        guard let url = URL(string: urlString) else { completion(nil); return }

        var req = URLRequest(url: url)
        req.timeoutInterval = 12

        URLSession.shared.dataTask(with: req) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [[String:Any]] else { completion(nil); return }

            for item in json {
                if let stop = item["StopName"] as? [String:String],
                   let zh = stop["Zh_tw"], zh.contains("淡江") {
                    if let sec = item["EstimateTime"] as? Int {
                        completion(sec / 60)
                        return
                    }
                }
            }
            completion(nil)
        }.resume()
    }
}
