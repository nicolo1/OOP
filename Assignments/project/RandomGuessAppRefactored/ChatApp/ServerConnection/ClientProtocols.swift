
//
//  ClientDelegateProtocols.swift
//  ChatApp
//
//  Created by Sandy on 2019-04-05.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

// =====================================================
// Anyone who wants to use the Client, should also be
// a client delegate
// =====================================================
protocol ClientServerListenerDelegate:class {
    func clientReceivedError(errorString error:String)
    func clientReceived(rawData data:String)
    func clientDidConnect(asPlayer num:Int, andName name:String)
}

protocol ClientConnectionDelegate:class {
    func clientDisconnected()
    func clientConnectionInProgress(asPlayer num:Int, andName name:String)
    func clientDidConnect(asPlayer num:Int, andName name:String) 
    func clientReceived(errorString error:String)
}
