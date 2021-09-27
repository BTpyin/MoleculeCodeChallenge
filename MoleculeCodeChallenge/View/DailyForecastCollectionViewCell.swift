//
//  DailyForecastCollectionViewCell.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 14/7/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DailyForecastCollectionViewCell: UICollectionViewCell {
    
    var viewModel : DailyForecastCollectionViewCellViewModel?
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var dailyForecastMaxTemp: UILabel!
    @IBOutlet weak var dailyForecastMinTemp: UILabel!
    @IBOutlet weak var dailyCellBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel = DailyForecastCollectionViewCellViewModel()
//        viewModel?.cellSelectedState.subscribe(onNext:{ [self] _ in
//            if (self.viewModel?.cellSelectedState.value ?? false){
//                self.backgroundColor = UIColor(named: "btnSelectedColor")
//            }else{
//                self.backgroundColor = .white
//            }
//        }).disposed(by: disposeBag)
       // initialize what is needed
    }
    
    
    func uiBind(day: DailyForecastedWeather){
        viewModel?.dailyWeather = day
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dayLabel.text = dateFormatter.string(from: day.dt)
        dailyForecastMaxTemp.text = "\(String(format: "%.0f", (day.temp?.max ?? 0)))°C"
        dailyForecastMinTemp.text = "\(String(format: "%.0f", (day.temp?.min ?? 0)))°C"
        dailyImageView.kf.setImage(with: URL(string: "\(Api.imageLink)\(day.weathers.first?.icon ?? "")@2x.png"))
        if (day.selected){
            self.backgroundColor = UIColor(named: "btnSelectedColor")
        }else{
            self.backgroundColor = .white
        }
    }
}


class DailyForecastCollectionViewCellViewModel{
    var dailyWeather = DailyForecastedWeather()
    var cellSelectedState = BehaviorRelay<Bool>(value: false)
}
