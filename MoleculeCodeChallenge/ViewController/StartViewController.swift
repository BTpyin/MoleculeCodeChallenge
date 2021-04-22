//
//  StartViewController.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 18/4/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealm
import RealmSwift
import Kingfisher
import CoreLocation

class StartViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{

    var rootRouter: RootRouter? {
       return router as? RootRouter
     }
    
    var viewModel: StartViewModel?
    var location : CLLocationManager?
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var scrollView: UIScrollView!
//  search bar
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var recentSearchTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
//    Searchby Section
    @IBOutlet weak var searchByView: UIView!
    
    @IBOutlet weak var citynameView: UIView!
    @IBOutlet weak var zipcodeView: UIView!
    
    @IBOutlet weak var noRecordView: UIView!
    
    //    Weather Card
    @IBOutlet weak var weatherCardView: UIView!
    @IBOutlet weak var weatherCardTopSection: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var feelLikeTempLabel: UILabel!
    
    @IBOutlet weak var detailSectionStackView: UIStackView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StartViewModel()
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        searchBarTextField.delegate = self
        location = CLLocationManager()
        location?.delegate = self
        uiBind()
//        scrollView.keyboardDismissMode = .onDrag
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(scrollViewTap)
        viewModel?.fetchWeatherFromRealm()
        viewModel?.fetchRecordFromRealm()
        
        viewModel?.cityNameOn.asObservable().subscribe(onNext:{ _ in
            self.updateSearchBarAndSearchByViews()
        }).disposed(by: disposeBag)
        

        Observable.changeset(from: (viewModel?.searchRecordFromRealm)!).subscribe(onNext: { results in
            self.determineDisplayNoRecordOrCardView()
            self.recentSearchTableView.reloadData()
            print(self.viewModel?.searchRecordFromRealm)
        }).disposed(by: disposeBag)
        
        Observable.changeset(from: (viewModel?.currentWeatherFromRealm)!).subscribe(onNext: { results, changes in
            if let changes = changes {
              // it's an update
//              print(results)
              print("deleted: \(changes.deleted)")
              print("inserted: \(changes.inserted)")
              print("updated: \(changes.updated)")
                if (results.first?.cod != 200 ){
                    self.showAlert(NSLocalizedString("not_valid_input", comment: ""))
                    self.stopLoading()
                }else{
                    self.weatherCardViewBind(weather: (results.first)!)
                    self.viewModel?.saveSearchRecord(searchRecord: (self.viewModel?.searchBarInput.value)!){[weak self] (failReason) in
                        print(failReason)
                    }
                }
            } else {
              // it's the initial data
//              print(results)
                if (results.first?.cod != 200 ){
                    self.showAlert(NSLocalizedString("not_valid_input", comment: ""))
                    self.stopLoading()
                }else{
                    self.weatherCardViewBind(weather: (results.first)!)
                    self.viewModel?.saveSearchRecord(searchRecord: (self.viewModel?.searchBarInput.value)!){[weak self] (failReason) in
                        print(failReason)
                    }
                }
            }
                    self.viewModel?.searchBarInput.value = ""
                    self.searchBarTextField.text = ""
            
        }).disposed(by: disposeBag)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.startLoading()
        viewModel?.searchBarInput.value = searchBarTextField.text ?? ""
        if ((viewModel?.cityNameOn.value)!){
            viewModel?.getWeatherByCityName(cityName: viewModel?.searchBarInput.value ?? ""){[weak self] (failReason) in
                if let tempWeather = try? Realm().objects(WeatherResponse.self){
                    

                }else{
                    self?.showErrorAlert(reason: failReason, showCache: true, okClicked: nil)

                   }
                  print(failReason)
            }
        }else{
            viewModel?.getWeatherByZipCode(zipCode: viewModel?.searchBarInput.value ?? ""){[weak self] (failReason) in
                if let tempWeather = try? Realm().objects(WeatherResponse.self){
                    

                }else{
                    self?.showErrorAlert(reason: failReason, showCache: true, okClicked: nil)

                   }
                  print(failReason)
            }
            
        }

        searchBarTextField.resignFirstResponder()
        return true

    }
    
    @IBAction func searchBarStartEditiing(_ sender: Any) {
        recentSearchTableView.isHidden = false
    }
    @IBAction func searchBarEndEditing(_ sender: Any) {
        recentSearchTableView.isHidden = true
    }
    
    @IBAction func cityNameClicked(_ sender: Any) {
        viewModel?.cityNameOn.value.toggle()
        viewModel?.zipCodeOn.value.toggle()
    }
    
    @IBAction func zipcodeClicked(_ sender: Any) {
        viewModel?.cityNameOn.value.toggle()
        viewModel?.zipCodeOn.value.toggle()
    }
    
    func determineDisplayNoRecordOrCardView(){
        let recordCount = self.viewModel?.searchRecordFromRealm?.count ?? 0
        let weatherCount = self.viewModel?.currentWeatherFromRealm?.count ?? 0
        print(self.viewModel?.currentWeatherFromRealm?.count)
        print(self.viewModel?.searchRecordFromRealm?.count)
        if (((recordCount) == 0) && (weatherCount) == 0){
            self.weatherCardView.isHidden = true
            self.noRecordView.isHidden = false
        }else{
            self.weatherCardView.isHidden = false
            self.noRecordView.isHidden = true
        }
    }
    
    //uiBind
    
    func uiBind(){
        navigationItem.title = NSLocalizedString("title_Name", comment: "")
        weatherCardView.roundCorners(cornerRadius: 25)
        weatherCardTopSection.roundCorners(cornerRadius: 25)
        noRecordView.roundCorners(cornerRadius: 15)
        noRecordView.layer.applySketchShadow(
          color: .black,
          alpha: 0.4,
          x: 0,
            y: 0.5,
          blur: 6,
            spread: 0)
        weatherCardView.layer.applySketchShadow(
          color: .black,
          alpha: 0.4,
          x: 0,
            y: 0.5,
          blur: 6,
            spread: 0)
        recentSearchTableView.layer.applySketchShadow(
            color: .black,
            alpha: 0.3,
            x: 0,
              y: 0.4,
            blur: 5,
              spread: 0)
        searchBarTextField.borderColor = UIColor.init(red: 128, green: 92, blue: 230)
        searchBarTextField.borderWidth = 1
        searchBarTextField.roundCorners(cornerRadius: 15)
        
    }
    
    func weatherCardViewBind(weather: WeatherResponse){
        locationLabel.text = weather.name
        descriptionLabel.text = weather.weathers.first?.desrcipe
        tempLabel.text = "\(String(format: "%.1f", (weather.weatherMain?.temp ?? 0)))°C"
        currentTempLabel.text = "\(String(format: "%.1f", (weather.weatherMain?.temp ?? 0)))°C"
        feelLikeTempLabel.text = "Feels like \(String(format: "%.1f", (weather.weatherMain?.feels_like ?? 0)))°C"
        minTempLabel.text = "\(String(format: "%.1f", (weather.weatherMain?.temp_min ?? 0)))°C"
        maxTempLabel.text = "\(String(format: "%.1f", (weather.weatherMain?.temp_max ?? 0)))°C"
        humidityLabel.text = "\(weather.weatherMain?.humidity ?? 0)"
        windSpeedLabel.text = "\(weather.wind?.speed ?? 0)"
        windDegreeLabel.text = "\(weather.wind?.degree ?? 0)°"
        weatherIconImageView.kf.setImage(with: URL(string: "\(Api.imageLink)\(weather.weathers.first?.icon ?? "")@2x.png"))
        location?.stopUpdatingLocation()
        self.stopLoading()
    }
    

    
    func updateSearchBarAndSearchByViews(){
        if ((viewModel?.cityNameOn.value)!){
            citynameView.backgroundColor = UIColor.init(red: 128, green: 92, blue: 230)
            zipcodeView.backgroundColor = UIColor.gray
            searchBarTextField.placeholder = NSLocalizedString("city_name_placeholder", comment: "")
        }else{
            citynameView.backgroundColor = UIColor.gray
            zipcodeView.backgroundColor = UIColor.init(red: 128, green: 92, blue: 230)
            searchBarTextField.placeholder = NSLocalizedString("zip_code_placeholder", comment: "")
        }
    }
    
    //load table View
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel?.searchBarInput.value = ""
        self.searchBarTextField.text = ""
        self.startLoading()
        if (indexPath.row < 1){
            //start getting current location
            location?.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                location?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                location?.startUpdatingLocation()
            }

        }else{
            //use past record to get weather information
            viewModel?.getWeatherByCityName(cityName:  (viewModel?.searchRecordFromRealm?[((viewModel?.searchRecordFromRealm?.count ?? 0)-indexPath.row)].searchString!)!){[weak self] (failReason) in
                if let tempWeather = try? Realm().objects(WeatherResponse.self){
                    
                    self?.view.endEditing(true)
                }else{
                    self?.showErrorAlert(reason: failReason, showCache: true, okClicked: nil)

                   }
                  print(failReason)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.searchRecordFromRealm?.count ?? 0)+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RecentSearchTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecentSearchTableViewCell else {
          fatalError("The dequeued cell is not an instance of RecentSearchTableViewCell.")
        }
        cell.rowNum = indexPath.row
        if indexPath.row == 0{
            cell.cancelButton.isHidden = true
            cell.locationLabel.text = NSLocalizedString("current_location", comment: "")
        }else{
            cell.cancelButton.isHidden = false
            cell.locationLabel.text = viewModel?.searchRecordFromRealm?[((viewModel?.searchRecordFromRealm?.count ?? 0)-indexPath.row)].searchString
        }
          return cell
    }
    
    //control the table view size
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if recentSearchTableView.contentSize.height.isLess(than: 150){
            tableViewHeightConstraint.constant = recentSearchTableView.contentSize.height
        }
    }
    
    //action when receive current location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        viewModel?.getWeatherByGps(lat: "\(locValue.latitude)", lon:  "\(locValue.longitude)"){[weak self] (failReason) in
            if let tempWeather = try? Realm().objects(WeatherResponse.self){
                
                self?.view.endEditing(true)
            }else{
                self?.showErrorAlert(reason: failReason, showCache: true, okClicked: nil)

               }
              print(failReason)
        }

        
    }
    
    //display keyboards when tapped other views
    @objc func scrollViewTapped() {
//        print("scrollViewTapped")
            view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

class StartViewModel{
    var cityNameOn = Variable<Bool>(true)
    var zipCodeOn = Variable<Bool>(false)
    var currentWeather = Variable<WeatherResponse?>(nil)
    var currentWeatherFromRealm: Results<WeatherResponse>?
    var searchRecordFromRealm: Results<SearchRecord>?
    var searchBarInput = Variable<String>("")
    
    func saveSearchRecord(searchRecord:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().addLocationRecordToRealm(record: searchRecord, completed: completed)
        fetchRecordFromRealm()
    }
    
    func getWeatherByGps(lat:String, lon:String,completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncWeatherByGps(lat: lat, lon: lon, completed: completed)
        fetchWeatherFromRealm()
    }
    
    func getWeatherByZipCode(zipCode:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncWeatherByZipcode(zipCode: zipCode, completed: completed)
        fetchWeatherFromRealm()
    }
    
    func getWeatherByCityName(cityName:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncWeatherByCityId(cityName: cityName, completed: completed)
        fetchWeatherFromRealm()
    }
    
    func fetchRecordFromRealm(){
        searchRecordFromRealm = try? Realm().objects(SearchRecord.self)
    }
    
    func fetchWeatherFromRealm(){
        currentWeatherFromRealm = try? Realm().objects(WeatherResponse.self)
        currentWeather.value = try? Realm().objects(WeatherResponse.self).first
//        print( try? Realm().objects(WeatherResponse.self).first)
    }
    
}
