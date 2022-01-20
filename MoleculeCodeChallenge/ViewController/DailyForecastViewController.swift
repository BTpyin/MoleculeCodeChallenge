//
//  DailyForecastViewController.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 13/7/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealm
import RealmSwift
import Kingfisher
import CoreLocation

class DailyForecastViewController: BaseViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var rootRouter: RootRouter? {
       return router as? RootRouter
     }
    var disposeBag = DisposeBag()
    var location : CLLocationManager?
    var viewModel: DailyForecastViewModel?
    
    @IBOutlet weak var scrollView: UIScrollView!
//  search bar
    @IBOutlet weak var searchBarIconImageView: UIImageView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var locateButton: UIButton!
    //    Weather Card
    @IBOutlet weak var weatherCardView: UIView!
    @IBOutlet weak var weatherCardTopSection: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var weekDayCollectionView: UICollectionView!
    
    @IBOutlet weak var noRecordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DailyForecastViewModel()
        location = CLLocationManager()
        location?.delegate = self
        weekDayCollectionView.delegate = self
        weekDayCollectionView.dataSource = self
        startLoading()
        viewModel?.fetchWeatherFromRealm()
        viewModel?.fetchForecastedWeatherFromRealm()
        uiBind()
        weekDayCollectionView.reloadData()
        
        
        location?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            location?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            location?.startUpdatingLocation()
        }
        
        locateButton.rx.tap.subscribe(onNext: { [self] _ in
            location?.requestWhenInUseAuthorization()
            startLoading()
            weatherCardViewBind(weather: viewModel?.dailyForecastWeather.value.first ?? DailyForecastedWeather())
            if CLLocationManager.locationServicesEnabled() {
                location?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                location?.startUpdatingLocation()
            }
        }).disposed(by: disposeBag)
        
//
        Observable.changeset(from: ((viewModel?.forecastedWeather)!)).subscribe(onNext: { [self] results in
//        viewModel?.dailyForecastWeather.subscribe(onNext: { [self] results in
            determineDisplayNoRecordOrCardView()
            weatherCardViewBind(weather: viewModel?.dailyForecastWeather.value.first ?? DailyForecastedWeather())
            self.weekDayCollectionView.reloadData()
//            location?.stopUpdatingLocation()
        }).disposed(by: disposeBag)
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(scrollViewTap)
    }
    
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

    }
    
    func weatherCardViewBind(weather: DailyForecastedWeather){
        location?.stopUpdatingLocation()
        tempLabel.text = "\(String(format: "%.1f", (weather.temp?.day ?? 0)))°C"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy (EEE)"
        dateLabel.text = dateFormatter.string(from: weather.dt)
        self.updateViewConstraints()
        self.stopLoading()
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
    
    //display keyboards when tapped other views
    @objc func scrollViewTapped() {
//        print("scrollViewTapped")
            view.endEditing(true)
    }
    
    @objc func didMenuSelected() {
//        self.weekDayCollectionView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        weatherCardViewBind(weather: viewModel?.dailyForecastWeather.value[indexPath.row] ?? DailyForecastedWeather())
        var i = 0
        guard  let weatherList = viewModel?.dailyForecastWeather.value else {
            return
        }
        for _ in weatherList{
            viewModel?.dailyForecastWeather.value[i].selected = false
            i += 1
        }
        viewModel?.dailyForecastWeather.value[indexPath.row].selected.toggle()
        weekDayCollectionView.reloadDataWithoutScroll()
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//
//            return CGSize(width: (UIScreen.main.bounds.size.width)/7, height: 150)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.dailyForecastWeather.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "DailyForecastCollectionViewCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? DailyForecastCollectionViewCell else {
          fatalError("The dequeued cell is not an instance of DailyForecastCollectionViewCell.")
        }

        cell.uiBind(day: viewModel?.dailyForecastWeather.value[indexPath.row] ?? DailyForecastedWeather())
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.location?.stopUpdatingLocation()
        SyncData().syncWeatherToGetNameByGps(lat: "\(locValue.latitude)", lon:  "\(locValue.longitude)").map{
            self.locationLabel.text = $0
            self.viewModel?.currentWeatherString.accept($0)
        }.subscribe(onNext:{
        
        }).disposed(by: disposeBag)
            
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

extension UICollectionView {

    func reloadDataWithoutScroll() {
        let offset = contentOffset
        reloadData()
        layoutIfNeeded()
        setContentOffset(offset, animated: false)
    }
}
