//
//  SevenDaysViewController.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 5/7/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealm
import RealmSwift
import Kingfisher
import GoogleMobileAds
import CoreLocation

class HourlyForecastViewController: BaseViewController, CLLocationManagerDelegate, GADBannerViewDelegate, GADFullScreenContentDelegate {

    var rootRouter: RootRouter? {
       return router as? RootRouter
     }
    var disposeBag = DisposeBag()
    var viewModel : HourlyForecastViewModel?
    var location : CLLocationManager?
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var scrollView: UIScrollView!
//  search bar
    @IBOutlet weak var searchBarIconImageView: UIImageView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBarTextField: UITextField!
    
////    Searchby Section
//    @IBOutlet weak var searchByView: UIView!
//
//    @IBOutlet weak var citynameView: UIView!
//    @IBOutlet weak var zipcodeView: UIView!
//
//    @IBOutlet weak var noRecordView: UIView!
    
    @IBOutlet weak var locateButton: UIButton!
    //    Weather Card
    @IBOutlet weak var weatherCardView: UIView!
    @IBOutlet weak var weatherCardTopSection: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var feelLikeTempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
 
    @IBOutlet weak var slideBar: UISlider!
    
    @IBOutlet weak var detailSectionStackView: UIStackView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    
    @IBOutlet weak var noRecordView: UIView!
    
    private var interstitial: GADInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HourlyForecastViewModel()
        //real banner view ad id:
//        bannerView.adUnitID = "ca-app-pub-6202076106469630/9230208945"
        //test banner view ad id:
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.delegate = self
        location = CLLocationManager()
        location?.delegate = self
        startLoading()
        viewModel?.fetchWeatherFromRealm()
        viewModel?.fetchForecastedWeatherFromRealm()
        uiBind()
        
        let adRequest = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                                        request: adRequest,
                              completionHandler: { [self] ad, error in
                                if let error = error {
                                  print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                  return
                                }
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self

                              }
            )

        
        location?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            location?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            location?.startUpdatingLocation()
        }
        
//        weatherCardViewBind(weather: <#T##OneCallWeather#>)
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(scrollViewTap)

        setupObservalblebinding()
        bannerView.load(GADRequest())
    }
    
    func determineDisplayNoRecordOrCardView(){
        if (viewModel?.forecastedWeather?.count == 0 ) ||  (self.viewModel?.currentWeatherString.value == ""){
            noRecordView.isHidden = false
            weatherCardView.isHidden = true
        }else{
            noRecordView.isHidden = true
            weatherCardView.isHidden = false
        }
    }
    
    func setupObservalblebinding(){
        
        Observable.changeset(from: ((viewModel?.forecastedWeather)!)).subscribe(onNext: { [self] results in
            determineDisplayNoRecordOrCardView()
            slideBar.setValue(0, animated: true)
            weatherCardViewBind(weather: viewModel?.forecastedWeather?.first?.current ?? OneCallWeather())
//            location?.stopUpdatingLocation()
        }).disposed(by: disposeBag)
        
        slideBar.rx.value.subscribe(onNext: { [self](value) in
            let updatedValue = Int(value)
//            print("updatedValue: \(updatedValue)")
            if updatedValue == 0 {
                weatherCardViewBind(weather: viewModel?.forecastedWeather?.first?.current ?? OneCallWeather())
            }else{
                weatherCardViewBind(weather:  (viewModel?.forecastedWeather?.first?.hourly[(updatedValue-1)] ?? OneCallWeather()))
            }
        }).disposed(by: disposeBag)
        
        locateButton.rx.tap.subscribe(onNext: { [self] _ in
            location?.requestWhenInUseAuthorization()
//            slideBar.setValue(0, animated: true)
            startLoading()
            if interstitial != nil {
                interstitial?.present(fromRootViewController: self)
            } else {
              print("Ad wasn't ready")
            }

            slideBar.rx.value.onNext(0)
            weatherCardViewBind(weather: viewModel?.forecastedWeather?.first?.current ?? OneCallWeather())
            if CLLocationManager.locationServicesEnabled() {
                location?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                location?.startUpdatingLocation()
            }
        }).disposed(by: disposeBag)
    }
    
    //uiBind
    
    func uiBind(){
//        navigationItem.title = NSLocalizedString("title_Name", comment: "")
//        navigationController?.navigationBar.backgroundColor = UIColor(named: "themeColor")
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "themeColor")
        weatherCardView.roundCorners(cornerRadius: 25)
        locateButton.roundCorners(cornerRadius: 5)
        locateButton.backgroundColor = UIColor(named: "themeColor")
        locateButton.setTitleColor(.white, for: .normal)
        weatherCardTopSection.roundCorners(cornerRadius: 25)
        weatherCardView.layer.applySketchShadow(
          color: .black,
          alpha: 0.4,
          x: 0,
            y: 0.5,
          blur: 6,
            spread: 0)
        noRecordView.roundCorners(cornerRadius: 15)
        noRecordView.layer.applySketchShadow(
          color: .black,
          alpha: 0.4,
          x: 0,
            y: 0.5,
          blur: 6,
            spread: 0)
        slideBar.tintColor = UIColor(named: "themeColor")

    }
    
    func weatherCardViewBind(weather: OneCallWeather){
        location?.stopUpdatingLocation()
        
        tempLabel.text = "\(String(format: "%.1f", (weather.temp )))°C"
        currentTempLabel.text = "\(String(format: "%.1f", (weather.temp )))°C"
        feelLikeTempLabel.text = "Feels like \(String(format: "%.1f", (weather.feels_like )))°C"
       
        humidityLabel.text = "\(weather.humidity )"
        windSpeedLabel.text = "\(weather.wind_speed )"
        windDegreeLabel.text = "\(weather.wind_degree )°"
        weatherIconImageView.kf.setImage(with: URL(string: "\(Api.imageLink)\(weather.weathers.first?.icon ?? "")@2x.png"))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        dateLabel.text = dateFormatter.string(from: weather.dt)
        timeLabel.text = "\(timeFormatter.string(from: weather.dt)):00"
        
        self.stopLoading()
    }
    
    //display keyboards when tapped other views
    @objc func scrollViewTapped() {
//        print("scrollViewTapped")
            view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        viewModel?.getCityNameByGps(lat: "\(locValue.latitude)", lon:  "\(locValue.longitude)"){[weak self] (failReason) in
//            print(failReason?.localizedDescription)
//        }
        SyncData().syncWeatherToGetNameByGps(lat: "\(locValue.latitude)", lon:  "\(locValue.longitude)").map{
            self.locationLabel.text = $0
            self.viewModel?.currentWeatherString.accept($0)
        }.subscribe(onNext:{
        
        }).disposed(by: disposeBag)
        
        self.location?.stopUpdatingLocation()
        viewModel?.getPredictedWeatherByGps(lat: "\(locValue.latitude)", lon:  "\(locValue.longitude)"){[weak self] (failReason) in
            
            
            if let tempWeather = try? Realm().objects(WeatherResponse.self){
                
                self?.view.endEditing(true)
            }else{
                self?.showErrorAlert(reason: failReason, showCache: true, okClicked: nil)

               }
//            print(failReason?.localizedDescription)
        }

        
    }


}


