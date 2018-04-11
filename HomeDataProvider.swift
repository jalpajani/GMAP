

import Foundation

import ObjectMapper

class HomeDataProvider: NSObject {
 
    //get HOME screen
    func getHomeCall (objRequestModel : HomeRequestModel, IsLoader:Bool? = true, viewController:UIViewController? = nil, ServiceCallBack: @escaping (_ response:HomeGetModel<FeatureProductListModel>?, _ IsSuccess:Bool?)-> Void) {
        
        let JSONString = Mapper().toJSON(objRequestModel)
        ServiceRequestResponse.servicecall(IsLoader:IsLoader, url: ServiceUrl.Home, HttpMethod: .post, InputParameter: JSONString, viewController: viewController) { (result:String?, IsSuccess:Bool?) -> Void in
            
            if IsSuccess == true {
                let serviceResponse = Mapper<HomeGetModel<FeatureProductListModel>>().map(JSONString: result!)
                print(serviceResponse!)
                ServiceCallBack(serviceResponse!, true)
            } else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
    func getMapData (IsLoader:Bool? = true, viewController:UIViewController? = nil, ServiceCallBack: @escaping (_ response:ServiceResponseArray<MapModel<Geometry<Location>>>?, _ IsSuccess:Bool?)-> Void) {
        
        let objBlankModel = blankModel()
        let JSONString = Mapper().toJSON(objBlankModel)
        ServiceRequestResponse.servicecall(IsLoader:IsLoader, url: ServiceUrl.MapData, HttpMethod: .get, InputParameter: JSONString, viewController: viewController) { (result:String?, IsSuccess:Bool?) -> Void in
            
            if IsSuccess == true {
                let serviceResponse = Mapper<ServiceResponseArray<MapModel<Geometry<Location>>>>().map(JSONString: result!)
                if (serviceResponse?.IsSuccess) == "OK" {
                    ServiceCallBack(serviceResponse!, true)
                } else {
                    viewController?.view.makeToast(message: (serviceResponse?.Message!)!)
                }
                print(serviceResponse!)
                ServiceCallBack(serviceResponse!, true)
            } else {
                ServiceCallBack(nil, false)
            }
        }
    }
    
}
