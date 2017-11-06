//
//  ViewController.swift
//  BonApp
//
//  Created by Giselle Marston on 9/29/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Text Fields
    @IBOutlet weak var fnameOutlet: UITextField!
    @IBOutlet weak var lnameOutlet: UITextField!
    @IBOutlet weak var phoneNumOutlet: UITextField!
    
    @IBOutlet weak var enterButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: start with enter disabled until they enter valid name and phone number
        //enterButtonOutlet.isEnabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func enterButton(_ sender: UIButton) {
        //shows order controller
        //if func deleted, seems to create problems
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "segue1") {
            let carriedInfo = segue.destination as! OrderController;
            carriedInfo.firstName = fnameOutlet.text!
            carriedInfo.lastName = lnameOutlet.text!
            carriedInfo.phoneNum = phoneNumOutlet.text! //TODO: make type digits
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

