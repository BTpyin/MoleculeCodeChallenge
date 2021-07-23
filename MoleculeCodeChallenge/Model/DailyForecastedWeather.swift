//
//  DailyForecastedWeather.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 14/7/2021.
//

import Foundation
import RealmSwift
import ObjectMapper

class DailyForecastedWeather: Object, Mappable {
    
    @objc dynamic var humidity = 0.0
    @objc dynamic var wind_speed = 0.0
    @objc dynamic var wind_degree = 0.0
    @objc dynamic var dt = Date()
    @objc dynamic var temp: ForecastedTemp?
    var weathers = List<Weather>()
    
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        humidity <- map["humidity"]
        wind_speed <- map["wind_speed"]
        wind_degree  <- map["wind_deg"]
        
        temp <- map["temp"]
        var tempstamp = 0
        tempstamp <- map["dt"]
        let timeInterval:TimeInterval = TimeInterval(tempstamp)
        dt = Date(timeIntervalSince1970: timeInterval)
        
        var weathers: [Weather]?
        weathers <- map["weather"]
        
        if let weathers = weathers {
          for weathers in weathers {
            self.weathers.append(weathers)
          }
        }
    }
}

class ForecastedTemp: Object, Mappable {
    
    @objc dynamic var day = 0.0
    @objc dynamic var min = 0.0
    @objc dynamic var max = 0.0
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        day <- map["day"]
        min <- map["min"]
        max  <- map["max"]
    }
}
