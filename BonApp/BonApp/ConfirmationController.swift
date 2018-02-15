//
//  ConfirmationController.swift
//  BonApp
//
//  Created by Giselle Marston on 9/29/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//


// order -> confirmation -> apple pay -> queue

import UIKit
import PassKit

class ConfirmationController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem])->Void ) {
        completion(PKPaymentAuthorizationStatus.success, itemToSell(shipping: 0.00))
    }

    private var merchantId = "merchant.edu.up.marston18.BonAppDeveloper"
    
    
    @IBOutlet weak var payButton: PKPaymentButton!
    var paymentRequest: PKPaymentRequest!
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(PKPaymentAuthorizationStatus.success)
        
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func itemToSell(shipping: Float) -> [PKPaymentSummaryItem]{
        let cheesePizza = PKPaymentSummaryItem(label: "Cheese Pizza", amount: 3.50)
        return [cheesePizza]
    }
    
    @IBAction func payAction(_ sender: Any) {
        let paymentNetworks = [PKPaymentNetwork.amex, .visa, .masterCard, .discover]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks){
            paymentRequest = PKPaymentRequest()
            paymentRequest.currencyCode = "USD"
            paymentRequest.countryCode = "US"
            paymentRequest.merchantIdentifier = "merchant.edu.up.marston18.BonAppDeveloper"
            paymentRequest.supportedNetworks = paymentNetworks
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.paymentSummaryItems = self.itemToSell(shipping: 0.00)
            
            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            applePayVC?.delegate = self
            self.present(applePayVC!, animated: true, completion: nil)
        }
        else{
            print("Please set up Apple Pay")
        }
    }
    
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
