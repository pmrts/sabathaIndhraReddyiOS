//
//  SabithaNetworkAdapter.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 29/06 /18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Moya
import SwiftyJSON
import SVProgressHUD

struct SabithaNetworkAdapter {
    
    static let networkActivityClosure: NetworkActivityPlugin.NetworkActivityClosure = { type, change in
        UIApplication.shared.isNetworkActivityIndicatorVisible = type == .began ? true : false
    }
    
    static let networkActivity = NetworkActivityPlugin(networkActivityClosure: networkActivityClosure)
    static let networkLogger = NetworkLoggerPlugin(verbose:true)
    
    static let plugins : [PluginType] = [networkActivity,networkLogger]
    
    static let provider = MoyaProvider<SabithaAPI>(plugins:plugins)
    
    static func request(target: SabithaAPI, success successCallback: @escaping (JSON) -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        showSVProgressHUD()
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                // 1:
                if response.statusCode >= 1 {
                    
                    let json = JSON(response.data)
                    if let status = json["status"].int, let message = json["message"].string, status == 0 {
                        let error = customError(with:message)
                        DispatchQueue.main.async {
                            errorCallback(error)
                        }
                    } else {
                        DispatchQueue.main.async {
                            successCallback(json)
                        }
                    }
                    SVProgressHUD.dismiss()
                } else {
                    // 2:
                    DispatchQueue.main.async {
                        let error = customError(with:"Unexpected Error occured")
                        errorCallback(error)
                        SVProgressHUD.dismiss()
                    }
                }
            case .failure(let error):
                // 3:
                DispatchQueue.main.async {
                    failureCallback(error)
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    static func customError(with message:String) -> Swift.Error {
        let error = NSError(domain:"com.Sabitha.user.networkLayer", code:0, userInfo:[NSLocalizedDescriptionKey: message])
        return error
    }
}
