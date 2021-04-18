//
//  Api.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 17/4/2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

class Api {
  static let requestBasePath = "http://api.openweathermap.org/data/2.5/"
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
        Alamofire.request("\(Api.requestBasePath)weather?q=\(cityName)", parameters: ["units": "metric", "appid": Api.apiKey]).responseJSON{
            response in
            if let responseData = response.result.value{
              if response.result.isSuccess {
                let weatherJson = JSON(response.result.value!)
//                success(WeatherResponse(JSONString: responseData as! String)
              }
            }
        }
        
    }
    
}
