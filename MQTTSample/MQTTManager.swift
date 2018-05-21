//
//  MQTTManager.swift
//  MQTTSample
//
//  Created by anoop mohanan on 19/05/18.
//  Copyright © 2018 com.anoopm. All rights reserved.
//

import Foundation
import CocoaMQTT

class MQTTManager {
    
    private var mqtt:CocoaMQTT?
    private var identifier:String!
    private var host:String!
    private var topic:String!
    private weak var presenter:PresenterProtocol!
    // Private Init
    private init() {
        
    }
    
    // MARK: Shared Instance
    
    private static let _shared = MQTTManager()
    
    // MARK: - Accessors
    class func shared(with identifier:String, host:String, topic: String, presenter: PresenterProtocol) -> MQTTManager {
        _shared.identifier = identifier
        _shared.host = host
        _shared.topic = topic
        _shared.presenter = presenter
        _shared.setUpMQTT()
        return _shared
    }
    
    
    func setUpMQTT() {
        let clientID = "CocoaMQTT-\(identifier)-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: host, port: 1883)
        mqtt!.username = ""
        mqtt!.password = ""
        mqtt!.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
    }
    
    func connect(){
        
        mqtt?.connect()
    }
    
    func subscribe(){
        mqtt?.subscribe(topic, qos: .qos1)
    }
    func publish(with message:String){
        mqtt?.publish(topic, withString: message, qos: .qos1)
    }
}

extension MQTTManager: CocoaMQTTDelegate{
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck){
        TRACE("ack: \(ack)")
        
        if ack == .accept {
            presenter?.resetUIWithConnection(status: true)
            mqtt.subscribe(topic, qos: .qos1)
        }
    }
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16){
        TRACE("message: \(message.string.description), id: \(id)")
    }
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16){
        TRACE("id: \(id)")
    }
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ){
        TRACE("message: \(message.string.description), id: \(id)")
        
        presenter?.update(message: message.string.description)
    }
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String){
        TRACE("topic: \(topic)")
    }
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String){
        TRACE("topic: \(topic)")
    }
    func mqttDidPing(_ mqtt: CocoaMQTT){
        TRACE()
    }
    func mqttDidReceivePong(_ mqtt: CocoaMQTT){
        TRACE()
    }
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?){
        presenter?.resetUIWithConnection(status: false)
        TRACE("\(err.description)")
    }
    
}
extension MQTTManager{
    
    func TRACE(_ message: String = "", fun: String = #function) {
        let names = fun.components(separatedBy: ":")
        var prettyName: String
        if names.count == 1 {
            prettyName = names[0]
        } else {
            prettyName = names[1]
        }
        
        if fun == "mqttDidDisconnect(_:withError:)" {
            prettyName = "didDisconect"
        }
        
        print("[TRACE] [\(prettyName)]: \(message)")
    }
}

extension Optional {
    // Unwarp optional value for printing log only
    var description: String {
        if let warped = self {
            return "\(warped)"
        }
        return ""
    }
}
