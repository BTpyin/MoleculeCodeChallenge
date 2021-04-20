//
//  WeatherResponse.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 17/4/2021.
//

import Foundation
import RealmSwift
import ObjectMapper

class WeatherResponse: Object, Mappable {
    
    @objc dynamic var cod: Int = 0
    @objc dynamic var message: String?
    @objc dynamic var name: String?

    @objc dynamic var wind: Wind?
    @objc dynamic var weatherMain : WeatherMain?
    var weathers = List<Weather>()

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        cod <- map["cod"]
        message  <- map["message"]
        weatherMain <- map["main"]
        name  <- map["name"]
        wind <- map["wind"]

        var weathers: [Weather]?
        weathers <- map["weather"]
        if let weathers = weathers {
          for weathers in weathers {
            self.weathers.append(weathers)
          }
        }

    }
}

class WeatherMain: Object, Mappable {
    
    @objc dynamic var humidity = 0.0
    @objc dynamic var temp = 0.0
    @objc dynamic var feels_like = 0.0
    @objc dynamic var temp_min = 0.0
    @objc dynamic var temp_max = 0.0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        humidity <- map["humidity"]
        temp <- map["temp"]
        feels_like  <- map["feels_like"]
        temp_min <- map["temp_min"]
        temp_max  <- map["temp_max"]
    }
}

class Wind: Object, Mappable {
    @objc dynamic var speed = 0.0
    @objc dynamic var degree = 0.0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        speed <- map["speed"]
        degree  <- map["deg"]
    }
}

class Weather: Object, Mappable {
    @objc dynamic var desrcipe: String?
    @objc dynamic var icon: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        desrcipe <- map["description"]
        icon  <- map["icon"]
    }
}
