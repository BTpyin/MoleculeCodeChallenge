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
    var cityNameOn = Variable<Bool>(true)
    var zipCodeOn = Variable<Bool>(false)
    var currentWeather = Variable<WeatherResponse?>(nil)
    var currentWeatherFromRealm: Results<WeatherResponse>?
    var searchRecordFromRealm: Results<SearchRecord>?
    var tableViewVisible = BehaviorRelay<Bool>(value: true)
    var searchRecords = BehaviorRelay<[SearchRecord]?>(value: [])
    var searchBarInput = Variable<String>("")
    
    func saveSearchRecord(searchRecord:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().addLocationRecordToRealm(record: searchRecord, completed: completed)
        fetchRecordFromRealm()
    }
    
    func getWeatherByGps(lat:String, lon:String,completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncWeatherByGps(lat: lat, lon: lon, completed: completed)
        fetchWeatherFromRealm()
    }
    
    func getWeatherByZipCode(zipCode:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncWeatherByZipcode(zipCode: zipCode, completed: completed)
        fetchWeatherFromRealm()
    }
    
    func getWeatherByCityName(cityName:String, completed: ((SyncDataFailReason?) -> Void)?){
        SyncData().syncWeatherByCityId(cityName: cityName, completed: completed)
        fetchWeatherFromRealm()
    }
    
    func fetchRecordFromRealm(){
        searchRecordFromRealm = try? Realm().objects(SearchRecord.self)
        searchRecords.accept(searchRecordFromRealm?.toArray())
    }
    
    func fetchWeatherFromRealm(){
        currentWeatherFromRealm = try? Realm().objects(WeatherResponse.self)
        currentWeather.value = try? Realm().objects(WeatherResponse.self).first
//        print( try? Realm().objects(WeatherResponse.self).first)
    }
    
}
