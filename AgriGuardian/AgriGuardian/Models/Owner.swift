//
//  Owner.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 2/17/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation

class Owner {
    var uid: String
    var name: String
    var email: String
    var orderHistory: [String]
    
   // Default constructor
    init() {
        self.uid = "00000000"
        self.name = "Buyer Name"
        self.email = "buyer@gmail.com"
        self.orderHistory = []
    }
    
    // Custom constructor
    init(uid: String, name: String, email: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.orderHistory = []
    }
    
    
//    // Parsing
//    init(data: [String: Any]) {
//        if let res = data["orderHistory"] as? [String] {
//            self.orderHistory = res
//        } else {
//            self.orderHistory = []
//        }
//        self.uid = data["uid"] as! String
//        self.name = data["name"] as! String
//        self.email = data["email"] as! String
//    }
//
//    func printOrder() {
//        print("=======================")
//        print("uid: \(self.uid)")
//        print("name: \(self.name)")
//        print("email: \(self.email)")
//        print("orderHistory: \(self.orderHistory)")
//        print("=======================")
//    }
}
