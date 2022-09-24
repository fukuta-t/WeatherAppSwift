
import UIKit

class WeatherViewController: UIViewController {

    public var viewModel:WeatherModelImpl = WeatherModelImpl()
    
    var activityIndicatorView:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    var notificationFlag:Bool = false
    let wClass = weatherClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = WeatherModelImpl()
        wClass.delegate = self.viewModel
        
        // initialize
        indicatorInit()
        notificationInit()
    }

    func indicatorInit() {
        activityIndicatorView.center = view.center
        activityIndicatorView.style = UIActivityIndicatorView.Style.large
        activityIndicatorView.color = .purple
        view.addSubview(activityIndicatorView)
    }
    
    func notificationInit() {
        NotificationCenter.default.addObserver(self, selector:#selector(foregroundNotification(notification:)) , name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(backgroundNotification(notification:)) , name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    // VCが解放されたときに呼ばれる　画面閉じた時とか
    deinit {
        print("deinitLog")
    }

    // #session6
    @IBAction func pushClose() {
        // 画面を閉じるタイミングで開き直す。
        self.dismiss(animated: true, completion:{ [presentingViewController] () -> Void in
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController")
            presentingViewController?.present(viewController!, animated: true, completion: nil)
        })
    }

    @IBAction func pushReload() {
        activityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            // 非同期処理を実行
            wClass.delegate?.touchUpInside() { weatherResult in
                self.viewModel.responseData = weatherResult!
            }
            // 非同期処理などが終了したらメインスレッドでアニメーション終了
            DispatchQueue.main.sync {
                // アニメーション終了
                self.stopIndicator()
                // 画面情報の更新
                self.drawViewLayout()
            }
        }
    }
    
    @objc func stopIndicator() {
        self.activityIndicatorView.stopAnimating()
    }
    
    // 画面情報の更新
    func drawViewLayout() {
        // 全部取れてると仮定する。気温だけ取れてないとかの意地悪は一旦なし
        if self.viewModel.responseData.weather_condition.count == 0 {
            // Viewでもいいと思うけどこれもっとMVVMっぽくしたい
            let alert = UIAlertController(title: "エラー",message: "データ取得エラー", preferredStyle: .alert)
            let ok    = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated:true, completion:nil)
        } else {
            // imageView的には空白ではなくnilが正解
            self.imageView.image   = UIImage(named: self.viewModel.responseData.weather_condition)
            self.minTempLabel.text = String(self.viewModel.responseData.min_temperature)
            self.maxTempLabel.text = String(self.viewModel.responseData.max_temperature)
        }
    }
        
    // MARK: NotificationMethod　#session7
    @objc func foregroundNotification(notification:Notification) {
        self.notificationFlag.toggle()
        if self.notificationFlag == true {
            print("フォアグラウンド：データ更新")
            
            activityIndicatorView.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                // 非同期処理を実行
                wClass.great()
                // 非同期処理などが終了したらメインスレッドでアニメーション終了
                DispatchQueue.main.sync {
                    // アニメーション終了
                    self.stopIndicator()
                    // 画面情報の更新
                    self.drawViewLayout()
                }
            }
        } else {
            print("foreground: \(notificationFlag)")
        }
    }

    @objc func backgroundNotification(notification:Notification) {
        self.notificationFlag.toggle()
        print("background: \(notificationFlag)")
        
    }
}

