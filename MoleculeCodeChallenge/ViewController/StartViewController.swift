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

class StartViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    var rootRouter: RootRouter? {
       return router as? RootRouter
     }
    
    var viewModel: StartViewModel?
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var scrollView: UIScrollView!
    //search bar
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var recentSearchTableView: UITableView!
    
//    Searchby Section
    @IBOutlet weak var searchByView: UIView!
    
    @IBOutlet weak var citynameView: UIView!
    @IBOutlet weak var zipcodeView: UIView!
    
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
        uiBind()
//        scrollView.keyboardDismissMode = .onDrag
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(scrollViewTap)
        viewModel?.fetchWeatherFromRealm()
        
        viewModel?.cityNameOn.asObservable().subscribe(onNext:{ _ in
            self.updateSearchByViews()
        }).disposed(by: disposeBag)
        
//        viewModel?.currentWeather.asObservable().subscribe(onNext: { weather in
//            if (self.viewModel?.currentWeather.value?.cod != 200 ){
//                self.showAlert("The input is not a valid value.")
//            }else{
//                self.weatherCardViewBind(weather: (self.viewModel?.currentWeather.value)!)
//            }
//        })
        
        Observable.changeset(from: (viewModel?.currentWeatherFromRealm)!).subscribe(onNext: { results, changes in
            if let changes = changes {
              // it's an update
              print(results)
              print("deleted: \(changes.deleted)")
              print("inserted: \(changes.inserted)")
              print("updated: \(changes.updated)")
            } else {
              // it's the initial data
              print(results)
                if (results.first?.cod != 200 ){
                    self.showAlert("The input is not a valid value.")
                }else{
                    self.weatherCardViewBind(weather: (results.first)!)
                }
            }
            
        })
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

            
            viewModel?.getWeatherByCityName(cityName: "London"){[weak self] (failReason) in
                if let tempWeather = try? Realm().objects(WeatherResponse.self){
                    

                }else{
                    self?.showErrorAlert(reason: failReason, showCache: true, okClicked: nil)

                   }
                  print(failReason)
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
    
    func uiBind(){
        weatherCardView.roundCorners(cornerRadius: 25)
        weatherCardTopSection.roundCorners(cornerRadius: 25)
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
        
    }
    
    func weatherCardViewBind(weather: WeatherResponse){
        locationLabel.text = weather.name
        descriptionLabel.text = weather.weathers.first?.desrcipe
        tempLabel.text = "\(weather.weatherMain?.temp ?? 0)°C"
        feelLikeTempLabel.text = "\(weather.weatherMain?.feels_like ?? 0)°C"
        minTempLabel.text = "\(weather.weatherMain?.temp_min ?? 0)°C"
        maxTempLabel.text = "\(weather.weatherMain?.temp_max ?? 0)°C"
        humidityLabel.text = "\(weather.weatherMain?.humidity ?? 0)"
        windSpeedLabel.text = "\(weather.wind?.speed ?? 0)"
        windDegreeLabel.text = "\(weather.wind?.degree ?? 0)°"
    }
    

    
    func updateSearchByViews(){
        if ((viewModel?.cityNameOn.value)!){
            citynameView.backgroundColor = UIColor.init(red: 128, green: 92, blue: 230)
            zipcodeView.backgroundColor = UIColor.gray
        }else{
            citynameView.backgroundColor = UIColor.gray
            zipcodeView.backgroundColor = UIColor.init(red: 128, green: 92, blue: 230)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RecentSearchTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecentSearchTableViewCell else {
          fatalError("The dequeued cell is not an instance of RecentSearchTableViewCell.")
        }
        if indexPath.row == 0{
            cell.cancelButton.isHidden = true
            cell.locationLabel.text = "Current Location"
        }else{
            cell.cancelButton.isHidden = false
            cell.locationLabel.text = "London"
        }
          return cell
    }
    
    @objc func scrollViewTapped() {
        print("scrollViewTapped")
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
    
    func getWeatherByCityName(cityName:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncWeatherByCityId(cityName: cityName, completed: completed)
        fetchWeatherFromRealm()
    }
    
    func fetchWeatherFromRealm(){
        currentWeatherFromRealm = try? Realm().objects(WeatherResponse.self)
        currentWeather.value = try? Realm().objects(WeatherResponse.self).first
        print( try? Realm().objects(WeatherResponse.self).first)
    }
    
}
