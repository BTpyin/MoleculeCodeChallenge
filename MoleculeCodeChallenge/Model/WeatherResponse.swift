//
//  WeatherResponse.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 17/4/2021.
//

import Foundation
import RealmSwift
import ObjectMapper

class WeatherResponse:Object, Mappable {
    
    @objc dynamic var cod: Int = 0
    @objc dynamic var message: String?
//    var value: T?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        cod <- map["cod"]
        message  <- map["message"]
//        value   <- map["Value"]
    }
}
