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
import Stripe

class ConfirmationController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    //carried vars
    var firstName = ""
    var lastName = ""
    var phoneNum = "" //TODO: make type digits
    var totalPrice = 0.00
    var numOrdersInQ = 0
    var paymentSucceeded = false
    
    private var merchantId = "merchant.edu.up.marston18.BonAppDeveloper"
    
    @IBOutlet weak var toPayTextView: UITextView!
    
    @IBOutlet weak var payButton: PKPaymentButton!
    var paymentRequest: PKPaymentRequest!
    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
//        completion(PKPaymentAuthorizationStatus.success)
//        print("PAVC COMPLETE")
//    }
//
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        controller.dismiss(animated: true, completion: nil)
//        print("DISMISS")
//    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                print("APPLE PAY ERROR1")
                return
            }
            
            submitTokenToBackend(token, completion: { (error: Error?) in
                if let error = error {
                    // Present error to user...
                    print("APPLE PAY ERROR2")
                    // Notify payment authorization view controller
                    completion(.failure)
                }
                else {
                    // Save payment success
                    paymentSucceeded = true
                    
                    // Notify payment authorization view controller
                    completion(.success)
                }
            })
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // Dismiss payment authorization view controller
        dismiss(animated: true, completion: {
            if (paymentSucceeded) {
                // Show a receipt page...
                print("Succesful Payment")
            }
        })
    }

    func itemToSell() -> [PKPaymentSummaryItem]{
        // use totalPrice
        let orderTotal = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: 0.01))
        return [orderTotal]
    }
    
    @IBAction func payAction(_ sender: Any) {
//        let paymentNetworks = [PKPaymentNetwork.amex, .visa, .masterCard, .discover]
       let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: "merchant.edu.up.marston18.BonAppDeveloper", country: "US", currency: "usd")

        paymentRequest.paymentSummaryItems = self.itemToSell()
        
        if Stripe.canSubmitPaymentRequest(paymentRequest) {
            // Setup payment authorization view controller
            let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentAuthorizationViewController.delegate = self
            
            // Present payment authorization view controller
            present(paymentAuthorizationViewController, animated: true)
        }
        else {
            print("Please set up Apple Pay")
        }
        
        
        
        //        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks){
//
//
//
//
//
////            paymentRequest.currencyCode = "USD"
////            paymentRequest.countryCode = "US"
////            paymentRequest.merchantIdentifier = "merchant.edu.up.marston18.BonAppDeveloper"
////            paymentRequest.supportedNetworks = paymentNetworks
////            paymentRequest.merchantCapabilities = .capability3DS

//            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
//            applePayVC?.delegate = self
//            self.present(applePayVC!, animated: true, completion: nil)
//        }
//        else{
//            print("Please set up Apple Pay")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payButton.enabled = Stripe.deviceSupportsApplePay()
        
        if ( numOrdersInQ > 15 ){   // TOO MANY ORDERS IN QUEUE --> DON'T LET ORDER GO THROUGH
            payButton.isEnabled = false
            payButton.isHidden = true
            toPayTextView.text = "Hi, \(firstName) \(lastName)! There are currently \(numOrdersInQ) slices to be picked up so we cannot take your order. Please try again later."
        }
    
        toPayTextView.text = "Hi, \(firstName) \(lastName)! Please continue paying for ORDER."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
