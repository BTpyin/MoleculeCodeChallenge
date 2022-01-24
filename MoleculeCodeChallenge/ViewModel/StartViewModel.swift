//
//  StartViewModel.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 9/7/2021.
//

import Foundation
import RxSwift
import RealmSwift
import RxCocoa

class StartViewModel{
    var cityNameOn = BehaviorRelay<Bool>(value: true)
    var zipCodeOn = BehaviorRelay<Bool>(value: false)
    var currentWeather = BehaviorRelay<WeatherResponse?>(value: nil)
    var currentWeatherFromRealm: Results<WeatherResponse>?
    var searchRecordFromRealm: Results<SearchRecord>?
    var tableViewVisible = BehaviorRelay<Bool>(value: true)
    var searchRecords = BehaviorRelay<[SearchRecord]?>(value: [])
    var searchBarInput = BehaviorRelay<String>(value: "")
    
    func saveSearchRecord(searchRecord:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().addLocationRecordToRealm(record: searchRecord, completed: completed)
        fetchRecordFromRealm()
    }
    
    func getWeatherByGps(lat:String, lon:String,completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncWeatherByGps(lat: lat, lon: lon, completed: completed)
//        fetchWeatherFromRealm()
    }
    
    func getWeatherByZipCode(zipCode:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncWeatherByZipcode(zipCode: zipCode, completed: completed)
    }
    
    func getWeatherByCityName(cityName:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncWeatherByCityId(cityName: cityName, completed: completed)
    }
    
    func fetchRecordFromRealm(){
        searchRecordFromRealm = try? Realm().objects(SearchRecord.self)
        searchRecords.accept(searchRecordFromRealm?.toArray())
    }
    
    func fetchWeatherFromRealm(){
        currentWeatherFromRealm = try? Realm().objects(WeatherResponse.self)
        currentWeather.accept(try? Realm().objects(WeatherResponse.self).first)
//        print( try? Realm().objects(WeatherResponse.self).first)
    }
    
}
