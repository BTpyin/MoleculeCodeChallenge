//
//  OneCallWeather.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 9/7/2021.
//

import Foundation
import RealmSwift
import ObjectMapper

class OneCallWeather: Object, Mappable {
    
    @objc dynamic var humidity = 0.0
    @objc dynamic var temp = 0.0
    @objc dynamic var feels_like = 0.0
    @objc dynamic var wind_speed = 0.0
    @objc dynamic var wind_degree = 0.0
    @objc dynamic var dt = Date()
    var weathers = List<Weather>()
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        humidity <- map["humidity"]
        temp <- map["temp"]
        feels_like  <- map["feels_like"]
        wind_speed <- map["wind_speed"]
        wind_degree  <- map["wind_deg"]
        
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
