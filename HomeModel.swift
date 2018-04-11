

import Foundation
import UIKit
import ObjectMapper


// REQUEST MODEL
class HomeRequestModel: Mappable {
    
    lazy var homeID: Int? = 0
   
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
        homeID <- map["homeID"]
    }
    
}

// RESPONSE MODEL
class HomeGetModel<F: Mappable>: Mappable {
    
    lazy var FeatureProductListModel: [F]? = []

    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
        FeatureProductListModel <- map["FeatureProductListModel"]
    }
}


class FeatureProductListModel: Mappable {
    
    lazy var ProductID: Int? = 0
    lazy var ProductName: String? = ""
    lazy var ShortDescription: String? = ""
    lazy var PriceRange: Int? = 0
    lazy var Price1: Double? = 0
    lazy var Price2: Double? = 0
    lazy var StrikePrice1: Double? = 0
    lazy var StrikePrice2: Double? = 0
    lazy var DiscountPersentage: Double? = 0
    lazy var ImagePath: String? = ""
    lazy var Slug: String? = ""
    lazy var ProductUrl: String? = ""
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
        ProductID <- map["ProductID"]
        ProductName <- map["ProductName"]
        ShortDescription <- map["ShortDescription"]
        PriceRange <- map["PriceRange"]
        Price1 <- map["Price1"]
        Price2 <- map["Price2"]
        StrikePrice1 <- map["StrikePrice1"]
        StrikePrice2 <- map["StrikePrice2"]
        DiscountPersentage <- map["DiscountPersentage"]
        ImagePath <- map["FullImagePath"]
        Slug <- map["Slug"]
        ProductUrl <- map["ProductUrl"]
        
    }
    
}
