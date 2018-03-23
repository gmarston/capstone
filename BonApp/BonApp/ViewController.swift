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
    @IBOutlet weak var errorOutlet: UITextView!
    @IBOutlet weak var number: SearchTextField!
    @IBOutlet weak var last: SearchTextField!
    @IBOutlet weak var first: SearchTextField!
    
    // Button outlet
    @IBOutlet weak var enterButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    func dismissKeyboard(){
//        view.endEditing(true)
//    }
    
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
        var error = ""
        var valid = true
        
        if number.text?.count == 10 && Int(number.text!) != nil {}
        else {
            valid = false
            error += "Please enter a valid 10 digit number without spaces, parentheses, or dashes. Ex: 5039876768 "
        }
        
        let firstStr = first.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastStr = last.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(firstStr.count < 1 || lastStr.count < 1){
            valid = false
            error += "Names must have at least one character."
        } else {
            let names = firstStr + lastStr
            for chr in names {
                if (chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z") {}
                else {
                    valid = false
                    error += "Please enter a name with only letters. "
                    break
                }
            }
        }
        
  
        if(!valid) {
            errorOutlet.text = error
            errorOutlet.isHidden = false
        } else{
            
            // Save last user input to local lists
            firstNames.append(first.text!)
            lastNames.append(last.text!)
            numbers.append(number.text!)
            
            // Saving local lists in UserDefaults for future uses
            let defaults = UserDefaults.standard
            defaults.set(firstNames, forKey: "firstNames")
            defaults.set(lastNames, forKey: "lastNames")
            defaults.set(numbers, forKey: "numbers")
            errorOutlet.isHidden = true
            
            //shows order controller
            self.performSegue(withIdentifier: "segue1", sender: nil)
        }


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




