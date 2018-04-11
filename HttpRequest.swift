//
//  HttpRequest.swift
//  iOSProject
//
//  Created by Kaira NewMac on 12/9/16.
//  Copyright © 2016 Kaira NewMac. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class HttpRequest: NSObject {
    
    class func serviceResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void!) {
        
        if Reachability.isConnectedToNetwork(){
            request(url, method:HttpMethod,parameters:InputParameter).responseJSON { response in
                
                if(response.result.isSuccess) {
                    let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                    let jsonDictionary =  JSONData().onvertToDictionary(text: datastring!) as NSDictionary!
                    print("Response : ", jsonDictionary as Any)
                    ServiceCallBack(datastring!)
                } else {
                    ServiceCallBack(nil)
                }
            }
        }
        else {
            NoInternetVC.showNoInternetVC(completion: { (completionHandler) in
                switch completionHandler {
                case .Retry:
                    self.serviceResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter, ServiceCallBack: ServiceCallBack)
                    break
                default: break
                }
            })
        }
    }
    
    
    class func serviceWithEncodingResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void!) {
        
        if Reachability.isConnectedToNetwork(){
        request(url, method:HttpMethod, parameters:InputParameter,
                    encoding: JSONEncoding.default).responseJSON { response in
                        if(response.result.isSuccess){
                            let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                            let jsonDictionary =  JSONData().onvertToDictionary(text: datastring!) as NSDictionary!
                            print("Response : ", jsonDictionary as Any)
                            ServiceCallBack(datastring)
                        }else{
                            ServiceCallBack(nil)
                        }
            }
        } else {
            NoInternetVC.showNoInternetVC(completion: { (completionHandler) in
                switch completionHandler {
                case .Retry:
                    self.serviceWithEncodingResponse(url: url, HttpMethod: HttpMethod, InputParameter: InputParameter, ServiceCallBack: ServiceCallBack)
                    break
                default: break
                }
            })
        }
    }
    
    class func serviceResponsePHP(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void!) {
        
        if Reachability.isConnectedToNetwork(){
            Alamofire.request(url, method:HttpMethod, parameters: InputParameter).validate().responseJSON {
                response in
                if(response.result.isSuccess){
                    
                    let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                    ServiceCallBack(datastring)
                }else{
                   ServiceCallBack(nil)
                }
            }
        } else {
            NoInternetVC.showNoInternetVC(completion: { (completionHandler) in
                switch completionHandler {
                case .Retry:
                    self.serviceResponsePHP(url: url, HttpMethod: HttpMethod, InputParameter:InputParameter,ServiceCallBack:ServiceCallBack)
                    break
                default: break
                }
            })
        }
    }
    
    func serviceCallMultipleImageUploadHTTP(imageData: [Data] = [],url: String,HttpMethod: HTTPMethod , parameter: [String:String]? = nil ,viewController:UIViewController? = nil, ServiceCallBack: @escaping (_ result: String?)-> Void!)
    {
        if(Reachability.isConnectedToNetwork())
        {
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                
                for i in 0..<(imageData.count){
                    multipartFormData.append(imageData[i] as Data, withName: "photo_path", fileName: "uploaded_file.jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in parameter! {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                }
                
                //  print("mutlipart 2st \(multipartFormData)")
            }, to:url)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        //                        if let view = viewController as? CreateProductImageVC {
                        //
                        //                            view.IBimgProgress.isHidden = false
                        ////                            print("Progress : \(Float(Progress.fractionCompleted))")
                        //                            view.IBimgProgress.setProgress(Float(Progress.fractionCompleted), animated: true)
                        //                        }
                        
                    })
                    upload.responseJSON { response in
                        
                        //                        if let view = viewController as? CreateProductImageVC {
                        //                            view.IBimgProgress.isHidden = true
                        //                            view.IBConstProgress.constant = 0
                        //                            view.IBimgProgress.progress = 0.0
                        //                        }
                        
                        
                        if(response.result.isSuccess){
                            let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                            ServiceCallBack(datastring)
                        }else{
                            //                            print(response.result.error?.localizedDescription as Any)
                            ServiceCallBack(nil)
                        }
                    }
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print(encodingError)
                }
            }
        } else {
            NoInternetVC.showNoInternetVC(completion: { (completionHandler) in
                switch completionHandler {
                case .Retry:
                    self.serviceCallMultipleImageUploadHTTP(imageData: imageData, url: url, HttpMethod: HttpMethod, parameter:parameter,viewController:viewController,ServiceCallBack: ServiceCallBack)
                    break
                default: break
                }
            })
        }
    }
    
    //mehul
    func serviceCallMultipleCategoryImageUploadHTTP(imageData: NSData,url: String,HttpMethod: HTTPMethod , parameter: [String:String]? = nil ,viewController:UIViewController? = nil,imageKey:String?="", ServiceCallBack: @escaping (_ result: String?)-> Void!)
    {
        if(Reachability.isConnectedToNetwork())
        {
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                //                for i in 0..<(imageData.CategoryImagesNSDataList?.count)!{
                //                    //multipartFormData.append(imageData[i] as Data, withName: imageKey!, fileName: "uploaded_file.jpeg", mimeType: "image/jpeg")
                //                    multipartFormData.append((imageData.Data as! Data), withName: (imageData.CategoryImagesNSDataList?[i].Key)!, fileName: "uploaded_file.jpeg", mimeType: "image/jpeg")
                //                }
                
                multipartFormData.append((imageData as! Data), withName: "imgName", fileName: "uploaded_file.jpeg", mimeType: "image/jpeg")
                
                for (key, value) in parameter! {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                }
                
                //  print("mutlipart 2st \(multipartFormData)")
            }, to:url)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        //                        if let view = viewController as? CreateProductImageVC {
                        //
                        //                            view.IBimgProgress.isHidden = false
                        //                            //                            print("Progress : \(Float(Progress.fractionCompleted))")
                        //                            view.IBimgProgress.setProgress(Float(Progress.fractionCompleted), animated: true)
                        //                        }
                        
                    })
                    upload.responseJSON { response in
                        
                        //                        if let view = viewController as? CreateProductImageVC {
                        //                            view.IBimgProgress.isHidden = true
                        //                            view.IBConstProgress.constant = 0
                        //                            view.IBimgProgress.progress = 0.0
                        //                        }
                       
                        if(response.result.isSuccess){
                            let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                           ServiceCallBack(datastring)
                        }else{
                            ServiceCallBack(nil)
                        }
                    }
                case .failure(let encodingError):
                     ServiceCallBack(nil)
                }
            }
        } else {
            NoInternetVC.showNoInternetVC(completion: { (completionHandler) in
                switch completionHandler {
                case .Retry:
                    self.serviceCallMultipleCategoryImageUploadHTTP(imageData: imageData, url: url, HttpMethod: HttpMethod, parameter:parameter,viewController:viewController,imageKey:imageKey,ServiceCallBack: ServiceCallBack)
                    break
                default: break
                }
            })
        }
    }
    
    func serviceCallImageUpload(imageData: Data? = nil ,url: String,HttpMethod: HTTPMethod , parameter: [String:String]? = nil , ServiceCallBack: @escaping (_ result: String?)-> Void!)
    {
        if(Reachability.isConnectedToNetwork())
        {
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if imageData != nil {
                    multipartFormData.append(imageData! as Data, withName: "varImage", fileName: "uploaded_file.jpeg", mimeType: "image/jpeg")
                }
                //                    print("mutlipart 1st \(multipartFormData)")
                //                    print("Parameters : \(parameter)")
                
                //                    for (key, value) in parameter! {
                //                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                //                    }
                
                for (key, value) in parameter! {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                }
                
                //  print("mutlipart 2st \(multipartFormData)")
            }, to:url)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        //                            if let view = uiviewController as? RegistrationVC {
                        //                                view.imgProgress.isHidden = false
                        //                                view.imgProgress.setProgress(Float(Progress.fractionCompleted), animated: true)
                        //                            }
                        
                    })
                    upload.responseJSON { response in
                        //self.delegate?.showSuccessAlert()
                        
                        //                            if let view = uiviewController as? RegistrationVC {
                        //                                view.imgProfile.alpha = 1
                        //                                view.imgProgress.isHidden = true
                        //                                view.imgProgress.progress = 0.0
                        //                            }
                        
                        
                        if(response.result.isSuccess){
                            let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                            ServiceCallBack(datastring)
                        }else{
                            ServiceCallBack(nil)
                        }
                    }
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print(encodingError)
                }
            }
        } else {
            ServiceCallBack(nil)
        }
    }
    
    
    
    
    class func serviceResponseFinch(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void!) {
        
        if Reachability.isConnectedToNetwork(){
            request(url, method:HttpMethod,parameters:InputParameter).responseJSON { response in
                if(response.result.isSuccess){
                    let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                    ServiceCallBack(datastring)
                }else{
                    ServiceCallBack(nil)
                }
            }
        }
        else {
            ServiceCallBack(nil)
        }
    }
    
    
    class func serviceWithHeaderResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void!) {
        
        if Reachability.isConnectedToNetwork(){
            
            let token :String = ""
//            if let strToken = Preference.GetString(key: UserDefaultsKey.Token) {
//                token = strToken
//                print("token ==>>> \(token)")
//            }
            
            // headers: HTTPHeaders?
            request(url, method:HttpMethod,parameters:InputParameter,headers:["authToken" : token]).responseJSON { response in
                if(response.result.isSuccess){
                    let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                    let jsonDictionary =  JSONData().onvertToDictionary(text: datastring!) as NSDictionary!
                    print("Response : ", jsonDictionary as Any)
                    ServiceCallBack(datastring)
                }else{
                    ServiceCallBack(nil)
                }
            }
        } else {
            ServiceCallBack(nil)
        }
    }
    
    class func serviceWithoutHeaderResponse(url: String, HttpMethod: HTTPMethod, InputParameter: Parameters, ServiceCallBack: @escaping (_ result: String?)-> Void!) {
        
        if Reachability.isConnectedToNetwork(){
            request(url, method:HttpMethod,parameters:InputParameter,headers: nil).responseJSON { response in
                if(response.result.isSuccess){
                    let datastring = NSString(data:response.data!, encoding:String.Encoding.utf8.rawValue) as String?
                    let jsonDictionary =  JSONData().onvertToDictionary(text: datastring!) as NSDictionary!
                    print("Response : ", jsonDictionary as Any)
                    ServiceCallBack(datastring)
                }else{
                    ServiceCallBack(nil)
                }
            }
        } else {
            ServiceCallBack(nil)
        }
    }
    
    
}

class JSONData {
    
    func onvertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
