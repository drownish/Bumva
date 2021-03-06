//
//  MapViewController.swift
//  Bumva
//
//  Created by Максим Белугин on 04.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var company: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = company!.company
        
        let initialLocation = CLLocation(latitude: Double(company!.y)!, longitude: Double(company!.x)!)
        centerMapOnLocation(location: initialLocation)
        mapView.addAnnotation(Artwork(title: company!.company, locationName: company!.address, discipline: "", coordinate: CLLocationCoordinate2D(latitude: Double(company!.y)!, longitude: Double(company!.x)!)))
        // Do any additional setup after loading the view.
    }

    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}
