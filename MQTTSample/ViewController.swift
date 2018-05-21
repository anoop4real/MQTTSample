//
//  ViewController.swift
//  MQTTSample
//
//  Created by anoop mohanan on 19/05/18.
//  Copyright © 2018 com.anoopm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var mqttManager:MQTTManager!
    @IBOutlet weak var ipAddressField: UITextField!
    @IBOutlet weak var topicField: UITextField!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var messageHistoryView: UITextView!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var setTopicBtn: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        resetUIWithConnection(status: false)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connect(){

        guard let ipAddr = ipAddressField.text, let topicVal = topicField.text  else {

            return
        }
        
        if (ipAddr.isEmpty && topicVal.isEmpty) {
            update(message: "Please fill the ip and topic fields")
            return
        }
        mqttManager = MQTTManager.shared(with: self.title!, host: ipAddr,topic: topicVal, presenter: self)
        mqttManager.connect()
        
    }
    @IBAction func send(){
        guard let msg = messageField.text else {
            return
        }
        send(message: msg)
        messageField.text = ""
    }
    func send(message: String){
        
        mqttManager.publish(with: message)
    }

}

extension ViewController: PresenterProtocol{
    
    func resetUIWithConnection(status: Bool){
        
        ipAddressField.isEnabled = !status
        topicField.isEnabled = !status
        messageField.isEnabled = status
        connectBtn.isEnabled = !status
        sendBtn.isEnabled = status
        
        if (status){
            updateStatusViewWith(status: "Connected")
        }else{
            updateStatusViewWith(status: "Disconnected")
        }
    }
    func updateStatusViewWith(status: String){
        
        statusLabl.text = status
    }
    
    func update(message: String){
        
        if let text = messageHistoryView.text{
            let newText = """
            \(text)
            \(message)
            """
            messageHistoryView.text = newText
        }else{
            let newText = """
            \(message)
            """
            messageHistoryView.text = newText
        }
        
        let myRange=NSMakeRange(messageHistoryView.text.count-1, 0);
        messageHistoryView.scrollRangeToVisible(myRange)
        
        
    }
    
    
}

