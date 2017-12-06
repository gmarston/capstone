//
//  ViewController.swift
//  TestEmpApp
//
//  Created by Giselle Marston on 12/5/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit
import AWSSQS

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let pets = ["dog", "cat", "fish"]
    let desc = ["1", "2", "3"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        cell.orderNum.text = desc[indexPath.row]
        cell.orderName.text = pets[indexPath.row]
        
        return cell
        
    }
    
    
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Receiving Orders
        //USING AWS HERE
        
        let queueName = "BonApp.fifo"
        let sqs = AWSSQS.default()
        
        // Get the queue's URL
        let getQueueUrlRequest = AWSSQSGetQueueUrlRequest()
        getQueueUrlRequest?.queueName = queueName
        sqs.getQueueUrl(getQueueUrlRequest!).continueWith { (task) -> AnyObject! in
            print("Getting queue URL")
            if let error = task.error {
                print(error)
            }
            
            if task.result != nil {
                if let queueUrl = task.result!.queueUrl {
                    // Got the queue's URL, try to recieve messages from the queue
                    
                    let getMsgsRequest = AWSSQSReceiveMessageRequest()
                    // Params:
                    getMsgsRequest?.queueUrl = queueUrl
                    getMsgsRequest?.attributeNames = ["MY_ATTRIBUTE_NAME"]
                    getMsgsRequest?.maxNumberOfMessages = 10
                    getMsgsRequest?.messageAttributeNames = ["MY_ATTRIBUTE_NAME"]
                    getMsgsRequest?.visibilityTimeout = 15
                    getMsgsRequest?.waitTimeSeconds = 15
                    getMsgsRequest?.receiveRequestAttemptId = "myAttempt"
                    
                    // Receive the message
                    sqs.receiveMessage(getMsgsRequest!).continueWith { (task) -> AnyObject! in
                        if let error = task.error {
                            print(error)
                        }
                        if let exception = task.error {
                            print(exception)
                        }
                        
                        if task.result != nil {
                            let messages = (task.result?.messages)
                            // loop through all messages
                            print("Sucess! MESSAGES:  ")
                            for message in messages! {
                                print (message.body ?? "FAILURE")
                            }
                        }
                        return nil
                    }
                } else {
                    // No URL found, do something?
                }
            }
            return nil
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

