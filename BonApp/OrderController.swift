//
//  OrderController.swift
//  BonApp
//
//  Created by Giselle Marston on 11/1/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit

class OrderController: UIViewController {
    
    //carried vars
    var firstName = ""
    var lastName = ""
    var phoneNum = "" //TODO: make type digits
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var okOutlet: UIButton!
    
    @IBOutlet weak var orderLabel: UILabel!
    
    @IBAction func placeOrderButton(_ sender: UIButton) {
        message.isHidden = false
        cancelOutlet.isHidden = false
        cancelOutlet.isEnabled = true
        okOutlet.isHidden = false
        okOutlet.isEnabled = true
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        //TODO: ORDER GOES THROUGH
        //USE AWS HERE
        
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        message.isHidden = true
        cancelOutlet.isHidden = true
        cancelOutlet.isEnabled = false
        okOutlet.isHidden = true
        okOutlet.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //orderLabel.text = firstName
        
        message.isHidden = true
        cancelOutlet.isHidden = true
        cancelOutlet.isEnabled = false
        okOutlet.isHidden = true
        okOutlet.isEnabled = false
        print("\nFIRST NAME: \(firstName)")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "segue2") {
            let carriedInfo = segue.destination as! ConfirmationController;
            carriedInfo.firstName = firstName
            carriedInfo.lastName = lastName
            carriedInfo.phoneNum = phoneNum //TODO: make type digits
            
            
        }
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
}
