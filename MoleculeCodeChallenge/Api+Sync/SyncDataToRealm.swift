//
//  SyncDataToRealm.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 18/4/2021.
//


import Foundation
import RealmSwift
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

enum SyncDataFailReason: Error {
  case network
  case realmWrite
  case other
}


class SyncData {
    static var firstSync : Bool  = false
    
    static var realmBackgroundQueue = DispatchQueue(label: ".realm", qos: .background)
    
    static func writeRealmAsync(_ write: @escaping (_ realm: Realm) -> Void,
                                completed: (() -> Void)? = nil) {
      SyncData.realmBackgroundQueue.async {
        autoreleasepool {
          do {
            let realm = try Realm()
            realm.beginWrite()
            write(realm)
            try realm.commitWrite()

            if let completed = completed {
              DispatchQueue.main.async {
                let mainThreadRealm = try? Realm()
                mainThreadRealm?.refresh() // Get updateds from Background thread
                completed()
              }
            }
      } catch {
            print("writeRealmAsync Exception \(error)")
          }
        }
      }
    }
    
    func failReason(error: Error?, resposne: Any?) -> SyncDataFailReason {
      if let error = error as NSError?, error.domain == NSURLErrorDomain {
        return .network
      }
      return .other
    }
    
    func syncWeatherByCityId(cityName:String, completed:((SyncDataFailReason?) -> Void)?) {
//        Api().getCurrentDatabyCityName(cityName: cityName, success: {(response) in
//            guard let weather = response else {
//                completed?(nil)
//                return
//            }
//            SyncData.writeRealmAsync({ (realm) in
//                realm.delete(realm.objects(WeatherResponse.self))
//                realm.add(weather)
//            }, completed:{
//                completed?(nil)
//              })
//
//        }, fail: { (error, resposne) in
//            print("Reqeust Error: \(String(describing: error))")
//            let reason = self.failReason(error: error, resposne: resposne)
//        })
        
        let urlString = "\(Api.requestBasePath)weather?q=\(cityName)&units=metric&appid=\(Api.apiKey)"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded)
         {
            Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil).responseObject{ (response: DataResponse<WeatherResponse>)  in
//                print(response.value)
//                print(response.error.debugDescription)
                print(url)
                guard let weatherResponse = response.result.value else{
                    completed?(nil)
                    return
                }
//                print((weatherResponse).weatherMain?.feels_like)
                SyncData.writeRealmAsync({ (realm) in
                    realm.delete(realm.objects(WeatherResponse.self))
                    realm.add(weatherResponse)
                    print(realm.objects(WeatherResponse.self).first)
                }, completed:{
                    completed?(nil)
                  })
            }
        }
    }
    
    
}