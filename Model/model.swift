//
//  model.swift
//  Bumva
//
//  Created by Максим Белугин on 11.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire

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
    var company: String
    var user: String
    var cat: String
    var geo: [String: String]
    var description: String
    var photo: URL?
    var createdDate: String
    var startDate: String?
    var dueDate: String?
    
    init(id: String, company: String, user: String, cat: String, geo: [String:String], description: String, photo: URL?, createdDate: String, startDate: String?, dueDate: String?) {
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
    }
    
    /*func loadSelf() -> Sale {
        var id: String
        var company: String
        var user: String
        var cat: String
        var geo: [String: String]
        var description: String
        var photo: URL?
        var createdDate: String
        var startDate: String?
        var dueDate: String?
    }*/
}

extension String {
    
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.urlQueryAllowed
        
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
    
}


