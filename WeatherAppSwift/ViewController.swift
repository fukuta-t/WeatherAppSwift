//
//  ViewController.swift
//  WeatherAppSwift
//
//  Created by fukutappe on 2022/07/01.
//

import Foundation
import UIKit

class ViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("new ViewController didLoad")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherView = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
        self.present(weatherView! ,animated: true, completion: nil)
    }
    
}
