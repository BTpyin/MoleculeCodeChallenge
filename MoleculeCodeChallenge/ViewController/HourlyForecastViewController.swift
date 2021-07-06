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
import CoreLocation

class HourlyForecastViewController: BaseViewController {

    var rootRouter: RootRouter? {
       return router as? RootRouter
     }
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var scrollView: UIScrollView!
//  search bar
    @IBOutlet weak var searchBarIconImageView: UIImageView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var recentSearchTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
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
 
    @IBOutlet weak var detailSectionStackView: UIStackView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiBind()
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(scrollViewTap)
        // Do any additional setup after loading the view.
    }
    
    
    //uiBind
    
    func uiBind(){
//        navigationItem.title = NSLocalizedString("title_Name", comment: "")
        navigationController?.navigationBar.barTintColor = UIColor(named: "themeColor")
        weatherCardView.roundCorners(cornerRadius: 25)
        locateButton.roundCorners(cornerRadius: 5)
        locateButton.backgroundColor = UIColor(named: "themeColor")
        weatherCardTopSection.roundCorners(cornerRadius: 25)
        weatherCardView.layer.applySketchShadow(
          color: .black,
          alpha: 0.4,
          x: 0,
            y: 0.5,
          blur: 6,
            spread: 0)

        
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
