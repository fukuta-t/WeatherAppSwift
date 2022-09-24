//
//  WeatherAppSwiftTests.swift
//  WeatherAppSwiftTests
//
//  Created by fukutappe on 2022/06/28.
//

import XCTest
@testable import WeatherAppSwift

class WeatherAppSwiftTests: XCTestCase {

    var viewController = WeatherViewController()
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = (storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController)!
    }
    
    // 関数の名前はなんでもOK
    // テストコードでAPIは見なくていいんじゃないか...?
//    func test足し算テストできるかどうかチェック() {
//        viewController.loadView()
//        let result = viewController.sumCalc(a: 7, b: 28)
//        XCTAssertEqual(result, 35)
//    }
    
    /* session 8
     天気予報がsunnyだったら、画面に晴れ画像が表示されること
     天気予報がcloudyだったら、画面に曇り画像が表示されること
     天気予報がrainyだったら、画面に雨画像が表示されること
     天気予報の最高気温がUILabelに反映されること
     天気予報の最低気温がUILabelに反映されること
     */
    // 取得データが正しいかをチェックする
    func testWeatherData() {
        viewController.loadView()

        let viewModel = WeatherModelImpl()
        var data = weatherResult.init(weather_condition: "", date: "", min_temperature: 0, max_temperature: 0)
        viewModel.getWeatherData()
        // 通信結果がnilでないかどうか
        XCTAssertNotNil(data, "success")
        
        if (data.weather_condition.count == 0) {
            viewModel.getWeatherData()
        }
        
        let viewImageView = viewController.imageView
        let viewMinLabel  = viewController.minTempLabel
        let viewMaxLabel  = viewController.maxTempLabel
        
        // 画像表示のテストのため、固定で文字をセットする
        // 晴
        data.weather_condition = "sunny"
        let sunnyImage = UIImage(named: "sunny")
        viewImageView!.image = UIImage(named:data.weather_condition)
        XCTAssertEqual(viewImageView!.image, sunnyImage)
        
        // 曇
        data.weather_condition = "cloudy"
        let cloudyImage = UIImage(named: "cloudy")
        viewImageView!.image = UIImage(named:data.weather_condition)
        XCTAssertEqual(viewImageView!.image, cloudyImage)

        // 雨
        data.weather_condition = "rainy"
        let rainyImage = UIImage(named: "rainy")
        viewImageView!.image = UIImage(named:data.weather_condition)
        XCTAssertEqual(viewImageView!.image, rainyImage)

        viewMinLabel?.text = String(data.min_temperature)
        viewMaxLabel?.text = String(data.max_temperature)
        XCTAssertNotNil(viewMinLabel?.text, "minTemp_OK")
        XCTAssertNotNil(viewMaxLabel?.text, "maxTemp_OK")
    }

}
