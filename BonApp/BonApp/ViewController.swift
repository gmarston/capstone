//
//  ViewController.swift
//  BonApp
//
//  Created by Giselle Marston on 9/29/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit
import SearchTextField

class ViewController: UIViewController {
    
    // Creating list for saving user inputs
    var firstNames = [String]()
    var lastNames = [String]()
    var numbers = [String]()
    
    //Text Fields
    @IBOutlet weak var number: SearchTextField!
    @IBOutlet weak var last: SearchTextField!
    @IBOutlet weak var first: SearchTextField!
    
    // Button outlet
    @IBOutlet weak var enterButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reading saved values from user input lists
        let fnameDefaults = UserDefaults.standard
        let firstNameToken = fnameDefaults.stringArray(forKey: "firstNames")
        let lastNameToken = fnameDefaults.stringArray(forKey: "lastNames")
        let numToken = fnameDefaults.stringArray(forKey: "numbers")
        
        // Setting local lists to saved data
        firstNames = firstNameToken!
        lastNames = lastNameToken!
        numbers = numToken!
        
        // Calling autofill function
        configureSimpleInLineSearchTextField()
        
    }
    
    // Inline search text view for autofill
    fileprivate func configureSimpleInLineSearchTextField() {
        // Define the inline mode
        first.inlineMode = true
        last.inlineMode = true
        number.inlineMode = true
        
        // Set data source
        first.filterStrings(firstNames)
        last.filterStrings(lastNames)
        number.filterStrings(numbers)
    }
    
    @IBAction func enterButton(_ sender: UIButton) {
        //shows order controller
        //if func deleted, seems to create problems

        // Save last user input to local lists
        firstNames.append(first.text!)
        lastNames.append(last.text!)
        numbers.append(number.text!)
        
        // Saving local lists in UserDefaults for future uses
        let defaults = UserDefaults.standard
        defaults.set(firstNames, forKey: "firstNames")
        defaults.set(lastNames, forKey: "lastNames")
        defaults.set(numbers, forKey: "numbers")

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "segue1") {
            let carriedInfo = segue.destination as! OrderController;
            carriedInfo.firstName = first.text!
            carriedInfo.lastName = last.text!
            carriedInfo.phoneNum = number.text! //TODO: make type digits
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}




