 //
//  ViewController.swift
//  GoogleMapDemo
//
//  Created by vivek versatile on 13/03/18.
//  Copyright © 2018 Jalpa Jani. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    var lat : Double = 0.0
    var long : Double = 0.0
    
    var objResponse : ServiceResponseArray<MapModel<Geometry<Location>>> = ServiceResponseArray()!
    
     var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetchLocations()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func btnClicked(_ sender: UIButton) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "HomeVc") as! HomeVc
        navigationController?.pushViewController(vc, animated: true)
    }
 }
//MARK:- GMSMapViewDelegate

extension ViewController: GMSMapViewDelegate {
    
     /*func setGoogleMap() {
        let state_marker = PlaceMarker()
        
        state_marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
//        if let strName = self.objResponse.Data?.varName {
//            state_marker.title = strName
//        }
        state_marker.title = "strName"
        let markerView = UIImageView(image: UIImage(named: "icon_location_pin"))
        state_marker.iconView = markerView
        state_marker.map = self.mapView
        
        self.mapView.delegate = self
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.long, zoom: 15.0)
        self.mapView.isMyLocationEnabled = true
        
    }*/
    
    func setGoogleMap() {
        
        for i in 0..<(self.objResponse.Data?.count)! {
            
            let state_marker = GMSMarker()
            state_marker.position = CLLocationCoordinate2D(latitude: (self.objResponse.Data?[i].Geometry?.Location?.lat)!, longitude: (self.objResponse.Data?[i].Geometry?.Location?.lng)!)
            state_marker.title = self.objResponse.Data?[i].name
            state_marker.snippet = "Hey, this is \(String(describing: self.objResponse.Data?[i].name))"
            state_marker.map = mapView
            
            if let imgUrl = self.objResponse.Data?[i].icon {
                let url = URL(string: imgUrl)
                let data = try? Data(contentsOf: url!)
                
                let markerView = UIImageView(image: UIImage(data: data!))
                state_marker.iconView = markerView
                state_marker.map = self.mapView
            }
            self.mapView.delegate = self
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.long, zoom: 15.0)
            self.mapView.isMyLocationEnabled = true
            
//            if let lat = self.objResponse.Data?[i].Geometry?.Location?.lat {
//                self.lat = lat
//            }
//            if let lng = self.objResponse.Data?[i].Geometry?.Location?.lng {
//                self.long = lng
//            }
//             state_marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
//            if let imgUrl = self.objResponse.Data?[i].icon {
//                let url = URL(string: imgUrl)
//                let data = try? Data(contentsOf: url!)
//
//                let markerView = UIImageView(image: UIImage(data: data!))
//                state_marker.iconView = markerView
//                state_marker.map = self.mapView
//
//                self.self.mapView.delegate = self
//                self.self.mapView.camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.long, zoom: 15.0)
//                self.self.mapView.isMyLocationEnabled = true
            
        }
       
//        if let strName = self.objResponse.Data?. {
//            state_marker.title = strName
//        }
        
        
    }
    
    /*func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
     
     let url = "http://maps.apple.com/maps?saddr=\(String(describing: locationManager.location?.coordinate.latitude)),\(String(describing: locationManager.location?.coordinate.longitude))&daddr=\((self.lat)),\((self.long))"
     
     if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
     UIApplication.shared.openURL(NSURL(string:
     "comgooglemaps://?saddr=&daddr=\(self.lat),\(self.lat)&directionsmode=driving")! as URL as URL)
     
     } else {
     NSLog("Can't use comgooglemaps://");
     UIApplication.shared.openURL(NSURL(string: url)! as URL)
     }
     return true
     }*/
}


//MARK: - Google Map Marker Class
class PlaceMarker: GMSMarker {
    var strImageURL: String = ""
    var strDistance: String = ""
    var strAddress: String = ""
    var strMobile: Int = 0
}


//MARK: - Location methods
extension ViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.long =  locValue.longitude
        self.lat = locValue.latitude
        
    }
}


extension ViewController {
    func fetchLocations()
    {
        let objDataProvider : HomeDataProvider =  HomeDataProvider()
        objDataProvider.getMapData(IsLoader: true, viewController: self) {
            (response, IsSuccess) -> Void in
             if IsSuccess! {
                self.objResponse = response!
                if (self.objResponse.Data?.count)! > 0 {
                    self.setGoogleMap()
                }
            }
        }
    }
}
