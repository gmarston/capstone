//
//  Order.swift
//  EmployeeApp
//
//  Created by Briahna Santillana on 11/27/17.
//  Copyright © 2017 Briahna Santillana. All rights reserved.
//

import UIKit

class Order {
    
    //MARK: Properties
    
    var orderNumber: String
    var orderName: String
    
    //MARK: Initialization
    
    init?(orderNumber:String, orderName: String) {
        
        // The name must not be empty
        guard !orderName.isEmpty else {
            return nil
        }
        
        // Order Number must be greater than 1
        guard (orderNumber > "0") else {
            return nil
        }
        
        // Initialize stored properties.
        self.orderNumber = orderNumber
        self.orderName = orderName
      
    }
   
    
}
