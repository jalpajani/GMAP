//
//  ServiceRequestResponse.swift
//  iOSProject
//
//  Created by Kaira NewMac on 12/12/16.
//  Copyright © 2016 Kaira NewMac. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import ObjectMapper


class ServiceRequestResponse: NSObject {
    
    class func servicecall(IsLoader:Bool? = true, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, viewController:UIViewController? = nil, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
    
        if IsLoader == true {
            if viewController != nil {
                ProgressHUD.startLoading(onView: (viewController?.view)!)
            } else {
                ProgressHUD.startLoading(onView: appDelegate.window!)
            }
        }
        HttpRequest.serviceResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            
            if IsLoader == true {
                if viewController != nil {
                    ProgressHUD.stopLoading(fromView: (viewController?.view)!)
                } else {
                    ProgressHUD.stopLoading(fromView: appDelegate.window!)
                }
            }
            print("URL: ",url)
            print("Request: ",InputParameter)
            if result != nil {
                ServiceCallBack(result, true)
            } else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    
    class func servicecallContentType(IsLoader:Bool? = true, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, viewController:UIViewController? = nil, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        if IsLoader == true {
            if viewController != nil {
                ProgressHUD.startLoading(onView: (viewController?.view)!)
            } else {
                ProgressHUD.startLoading(onView: appDelegate.window!)
            }
        }
        HttpRequest.serviceResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            
            if IsLoader == true {
                if viewController != nil {
                    ProgressHUD.stopLoading(fromView: (viewController?.view)!)
                } else {
                    ProgressHUD.stopLoading(fromView: appDelegate.window!)
                }
            }
            print("URL: ",url)
            print("Request: ",InputParameter)
            if result != nil {
                ServiceCallBack(result, true)
            } else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    
    class func servicecallEncode(IsLoader:Bool? = true, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, viewController:UIViewController? = nil, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        if IsLoader == true {
            if viewController != nil {
                ProgressHUD.startLoading(onView: (viewController?.view)!)
            } else {
                ProgressHUD.startLoading(onView: appDelegate.window!)
            }
        }
        HttpRequest.serviceWithEncodingResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            
            if IsLoader == true {
                if viewController != nil {
                    ProgressHUD.stopLoading(fromView: (viewController?.view)!)
                } else {
                    ProgressHUD.stopLoading(fromView: appDelegate.window!)
                }
            }
            print("URL: ",url)
            print("Request: ",InputParameter)
            if result != nil {
                ServiceCallBack(result, true)
            } else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    class func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    class func servicecallHeaderFinchCart(IsLoader:Bool? = true, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, viewController:UIViewController? = nil, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        
        
        if IsLoader == true {
            if viewController != nil {
                ProgressHUD.startLoading(onView: (viewController?.view)!)
            } else {
                ProgressHUD.startLoading(onView: appDelegate.window!)
            }
        }
        HttpRequest.serviceWithHeaderResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            if IsLoader == true {
                if viewController != nil {
                    ProgressHUD.stopLoading(fromView: (viewController?.view)!)
                } else {
                    ProgressHUD.stopLoading(fromView: appDelegate.window!)
                }
            }
            
            print("URL: ",url)
            print("Request: ",InputParameter)
            
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    class func servicecallNoHeaderFinchCart(IsLoader:Bool? = true, url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, viewController:UIViewController? = nil, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        
        
        if IsLoader == true {
            if viewController != nil {
                ProgressHUD.startLoading(onView: (viewController?.view)!)
            } else {
                ProgressHUD.startLoading(onView: appDelegate.window!)
            }
        }
        HttpRequest.serviceWithoutHeaderResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter) { (result) -> Void in
            if IsLoader == true {
                if viewController != nil {
                    ProgressHUD.stopLoading(fromView: (viewController?.view)!)
                } else {
                    ProgressHUD.stopLoading(fromView: appDelegate.window!)
                }
            }
            
            print("URL: ",url)
            print("Request: ",InputParameter)
            
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            }
            else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    // Single Image Upload
    class func servicecallImageUpload(IsLoader:Bool? = true, imageDataFile: Data? = nil, url: String, HttpMethod: HTTPMethod, InputParameter: [String:String]? = nil , viewController:UIViewController? = nil, ServiceCallBack: @escaping (_ result: String?, _ IsSuccess: Bool?)-> Void) {
        
        if IsLoader == true {
            if viewController != nil {
                ProgressHUD.startLoading(onView: (viewController?.view)!)
            } else {
                ProgressHUD.startLoading(onView: appDelegate.window!)
            }
        }
        // InputParameter as? [String:String]
        
        
        HttpRequest().serviceCallImageUpload(imageData: imageDataFile,url: url, HttpMethod: HttpMethod, parameter: InputParameter ) { (result) -> Void in
            
            if IsLoader == true {
                if viewController != nil {
                    ProgressHUD.stopLoading(fromView: (viewController?.view)!)
                } else {
                    ProgressHUD.stopLoading(fromView: appDelegate.window!)
                }
            }
            
            print("URL: ",url)
            print("Request: ",InputParameter!)
            if let strResult = result {
                let jsonDictionary:NSDictionary = convertToDictionary(text: strResult)!
                print("Response: ",jsonDictionary)
            }
            
            if result != nil {
                ServiceCallBack(result, true)
            } else {
                 ServiceCallBack(nil, false)
            }
        }
    }
    
}

