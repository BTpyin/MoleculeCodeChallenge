//
//  Api.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 17/4/2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RealmSwift
import SwiftyJSON
import ObjectMapper

class Api {
  static let requestBasePath = "https://api.openweathermap.org/data/2.5/"
    static let apiKey = "95d190a434083879a6398aafd54d9e73"
//    static let requestBasePath = "http://144.214.94.36:8000/catalog/api/"
//
//  static let ReceiveApiErrorNotification = NSNotification.Name.init("ReceiveApiErrorNotification")
//  static let ErrorCodeRemoteSignout = 214
//  static let ErrorCodeMaintanceMode = 1001

//  lazy var sessionManager = SessionManager.shared
  
  // MARK: - Common
  func stopAllRunningRequest() {
    Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
      tasks.forEach({ $0.cancel() })
    }
  }

    
    func getCurrentDatabyCityName(cityName: String, success: @escaping(_ payload: WeatherResponse?) -> Void,
                                  fail: @escaping(_ errr: Error?, _ response: WeatherResponse?) -> Void){
//        print("\(Api.requestBasePath)weather?q=\(cityName)&units＝metric&appid=\(Api.apiKey)")
        let urlString = "\(Api.requestBasePath)weather?q=\(cityName)&units＝metric&appid=\(Api.apiKey)"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded)
         {
//            Alamofire.request(url).validate().responseObject {(response: DataResponse<WeatherResponse>) in
//                if let responseData = response.result.value{
////                    print(responseData)
//                  if response.result.isSuccess {
//                    let weatherJson:JSON = JSON(responseData)
////                    try? Realm().create(WeatherResponse.Type)
//                    print(weatherJson)
//                    print(WeatherResponse(value: weatherJson))
//                    success(WeatherResponse(value: weatherJson))
////                    print(weatherJson)
//                  }
//                
//                }
//             }
        }
        
    }
    
}
