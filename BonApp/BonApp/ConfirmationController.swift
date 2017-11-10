//
//  ConfirmationController.swift
//  BonApp
//
//  Created by Giselle Marston on 9/29/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit

class ConfirmationController: UIViewController {
    
    //carried vars
    var firstName = ""
    var lastName = ""
    var phoneNum = "" //TODO: make type digits
    
    @IBOutlet weak var thanksLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thanksLabel.text = "Thank you for your order, \(firstName) \(lastName)!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
