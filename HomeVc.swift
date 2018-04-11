//
//  HomeVc.swift
//  GoogleMapDemo
//
//  Created by vivek versatile on 13/03/18.
//  Copyright © 2018 Jalpa Jani. All rights reserved.
//

import UIKit
import MapKit

class HomeVc: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    var objResponse : ServiceResponseArray<MapModel<Geometry<Location>>> = ServiceResponseArray()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .standard
        // Do any additional setup after loading the view.
        self.fetchLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLocationPins()
    {
//        let algorithm = CKNonHierarchicalDistanceBasedAlgorithm()
//        algorithm.cellSize = 400
//
//        mapView.clusterManager.algorithm = algorithm
//        mapView.clusterManager.marginFactor = 1
         for i in 0..<(self.objResponse.Data?.count)! {
            let coordinate = CLLocationCoordinate2D(latitude: (self.objResponse.Data?[i].Geometry?.Location?.lat)!, longitude: (self.objResponse.Data?[i].Geometry?.Location?.lng)!)
            mapView.setCenter(coordinate, animated: false)
        }
        
        //        let paris = CLLocationCoordinate2D(latitude: 48.853, longitude: 2.35)
        //        mapView.setCenter(paris, animated: false)
        
//        self.mapView.clusterManager.annotations = getLocationsWithCount() as! [CKAnnotation]
        //mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation")
        annotationView?.canShowCallout = false
        annotationView?.image = UIImage(named: "icon_location_pin")
        return annotationView;
    }
    
}

extension HomeVc {
    func fetchLocations()
    {
        let objDataProvider : HomeDataProvider =  HomeDataProvider()
        objDataProvider.getMapData(IsLoader: true, viewController: self) {
            (response, IsSuccess) -> Void in
            if IsSuccess! {
                self.objResponse = response!
                if (self.objResponse.Data?.count)! > 0 {
                    //self.setGoogleMap()
                    self.setLocationPins()
                }
            }
        }
    }
}
