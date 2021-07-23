//
//  OneCallWeather.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 9/7/2021.
//
import Foundation
import RealmSwift
import ObjectMapper

class OneCallWeatherResponse: Object, Mappable {
    
    @objc dynamic var current : OneCallWeather?
    var hourly = List<OneCallWeather>()
    var daily = List<DailyForecastedWeather>()
    @objc dynamic var timezone: String?
    
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        timezone <- map["timezone"]
        current <- map["current"]
        
        var hourlyWeathers: [OneCallWeather]?
        hourlyWeathers <- map["hourly"]
        
        if let hourly = hourlyWeathers {
          for hourlyWeather in hourly {
            self.hourly.append(hourlyWeather)
          }
        }
        
        var dailyWeathers: [DailyForecastedWeather]?
        dailyWeathers <- map["daily"]
        
        if let daily = dailyWeathers {
          for dailyWeather in daily {
            self.daily.append(dailyWeather)
          }
        }
    }
}
