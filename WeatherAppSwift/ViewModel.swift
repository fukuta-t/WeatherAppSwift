
import Foundation
import YumemiWeather
import UIKit
import Combine

struct WeatherContents: Codable {
    let item:weatherResult
}

// MARK: WeatherDelegate
protocol weatherDelegate {
    func touchUpInside(completion:@escaping (weatherResult?) -> Void)
}

extension weatherDelegate {
    // mファイルで処理を書いてる感じ
    
    func touchUpInside(completion:@escaping (weatherResult?) -> Void){
        let requestParam = requestParam(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
        
        // encoder
        let encoder = JSONEncoder()
        let data = try! encoder.encode(requestParam)
        let json = String(data: data, encoding: .utf8)!
//        var _error: Error!
        
        guard let result = try? YumemiWeather.syncFetchWeather(json) else {
            print("通信処理失敗")
            return
        }
        
        let decoder = JSONDecoder()
        // ここでdecode引数にセットする型と completionで返却する型は合わせる必要がある
        guard let responseData = try? decoder.decode(weatherResult.self, from: result.data(using: .utf8)!) else {
            print("パース失敗")
            completion(nil)
//            print("パース失敗 : \(error.localizedDescription)")
            return
        }
        completion(responseData)
    }
}

final class weatherClass {
    var delegate: weatherDelegate?
    
    func great() {
        delegate?.touchUpInside(completion: { _ in
            // 画面に渡すデータをどこかでセットしないといけない
        })
    }
}

// ここまでがセット
class WeatherModelImpl:weatherDelegate {
    var responseData: weatherResult
        
    init() {
        self.responseData = weatherResult(weather_condition: "", date: "", min_temperature: 0, max_temperature: 0)
    }
}
