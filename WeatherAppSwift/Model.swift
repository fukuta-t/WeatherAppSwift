
import Foundation
import UIKit

struct requestParam: Encodable {
    var area:String
    var date:String
}

struct weatherResult: Codable {
    // ファイル名になるので天気名だけはnilを適用。
    var weather_condition:String!
    let date:String
    let min_temperature:Int
    let max_temperature:Int
    
    init(weather_condition:String, date:String, min_temperature:Int, max_temperature:Int) {
        self.weather_condition = weather_condition
        self.date    = date
        self.min_temperature = min_temperature
        self.max_temperature = max_temperature
    }

}
