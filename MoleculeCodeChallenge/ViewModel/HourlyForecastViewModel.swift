//
//  HourlyForecastViewModel.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 9/7/2021.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class HourlyForecastViewModel{
    
    var forecastedWeather: Results<OneCallWeatherResponse>?
    var currentWeatherFromRealm: Results<WeatherResponse>?
    var currentWeather = BehaviorRelay<WeatherResponse?>(value: nil)
    var currentWeatherString = BehaviorRelay<String>(value: "")
    
    func fetchForecastedWeatherFromRealm(){
        forecastedWeather = try? Realm().objects(OneCallWeatherResponse.self)
    }
    
    func fetchWeatherFromRealm(){
        currentWeatherFromRealm = try? Realm().objects(WeatherResponse.self)
        currentWeather.accept(try? Realm().objects(WeatherResponse.self).first)
//        print( try? Realm().objects(WeatherResponse.self).first)
    }
    
    func getPredictedWeatherByGps(lat:String, lon:String,completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncPredictedWeatherByGps(lat: lat, lon: lon, completed: completed)
        fetchForecastedWeatherFromRealm()
    }
    
//    func getCityNameByGps(lat:String, lon:String){
//        SyncData().syncWeatherToGetNameByGps(lat: lat, lon: lon, completed: completed)
//        fetchForecastedWeatherFromRealm()
//    }
}
