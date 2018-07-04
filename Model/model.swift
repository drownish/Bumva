//
//  model.swift
//  Bumva
//
//  Created by Максим Белугин on 11.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}




class NetworkManager {
    static let shared = NetworkManager()
    
    var manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "https://www.bumva.com/v1/register": .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
}





class Sale {
    var id: String
    var company: Company
    var user: User
    var cat: Cat
    var geo: Geo
    var description: String
    var photo: String?
    var createdDate: String
    var startDate: String?
    var dueDate: String?
    var status: String
    
    init(id: String, company: Company, user: User, cat: Cat, geo: Geo, description: String, photo: String?, createdDate: String, startDate: String?, dueDate: String?, status: String) {
        self.id = id
        self.company = company
        self.user = user
        self.cat = cat
        self.geo = geo
        self.description = description
        self.photo = photo
        self.createdDate = createdDate
        self.startDate = startDate
        self.dueDate = dueDate
        self.status = status
    }
    
}

class Company {
    var id: String
    var company: String
    var geoId: String
    var city: String
    var address: String
    var phone: String
    var email: String?
    var site: String?
    var x: String
    var y: String
    var time: String
    
    init(id: String, company: String, geoId: String, city: String, address: String, phone: String, email: String?, site: String?, x: String, y: String, time: String) {
        self.id = id
        self.company = company
        self.geoId = geoId
        self.city = city
        self.address = address
        self.phone = phone
        self.email = email
        self.site = site
        self.x = x
        self.y = y
        self.time = time
    }
}

class User {
    
    var id: String
    var name: String
    var email: String
    var geo: Geo
    var status: String
    var registerDate: String
    
    init(id: String, name: String, email: String, geo: Geo, status: String, registerDate: String) {
        self.id = id
        self.name = name
        self.email = email
        self.geo = geo
        self.status = status
        self.registerDate = registerDate
    }
    
}

class Cat {
    var id: String
    var parentId: String
    var parentCat: String
    var cat: String
    
    init(id: String, parentId: String, parentCat: String, cat: String) {
        self.id = id
        self.parentId = parentId
        self.parentCat = parentCat
        self.cat = cat
    }
    
}

class Geo {
    var cId: String
    var rId: String?
    var oId: String?
    var region: String
    var city: String
    var rayon: String?
    var id: String
    
    init(cId: String, rId: String?, oId: String?, region: String, city: String, rayon: String?, id: String) {
        self.cId = cId
        self.rId = rId
        self.oId = oId
        self.region = region
        self.city = city
        self.rayon = rayon
        self.id = id
    }
    
}

extension String {
    
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.urlQueryAllowed
        
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
    
}


extension Date {
    
    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }
    
    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }
    
    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }
    
    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }
    
    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }
    
    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
    
}


