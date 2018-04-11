//
//  serviceURL.swift
//  iOSProject
//
//  Created by Kaira NewMac on 12/8/16.
//  Copyright © 2016 Kaira NewMac. All rights reserved.
//

import Foundation

class ServiceUrl
{

    static let Base = "http://192.168.1.202:1992" //Local URL
    
    // HOME
    static let Home = Base + "/security/login"
    
    static let MapData = "https://maps.googleapis.com/maps/api/place/search/json?location=23.0225,72.5714&radius=500&types=atm&sensor=false&key=AIzaSyBzFtkdyDUYTMZV2ewXT54NphxqzcN1OIk"
    
}
