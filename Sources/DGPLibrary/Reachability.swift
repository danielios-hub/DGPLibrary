//
//  Reachability.swift
//  SocialGaming
//
//  Created by Daniel Gallego Peralta on 01/07/2020.
//  Copyright © 2020 Daniel Gallego Peralta. All rights reserved.
//

import Foundation
import SystemConfiguration


public enum ReachabilityType {
    case wwan
    case wiFi
    
    public var description: CustomStringConvertible {
        switch self {
        case .wwan: return "WWAN"
        case .wiFi: return "WiFi"
        }
    }
}

public enum ReachabilityStatus : CustomStringConvertible {
    case offline
    case online(ReachabilityType)
    case unknown
    
    public var description: String {
        switch self {
        case .offline: return "Offline"
        case .online(let type): return "Online (\(type))"
        case .unknown: return "Unknown"
        }
    }
}


open class Reachability {
    
    open class func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return .unknown
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
    open class func isConnected() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let status = Reachability.connectionStatus()
        switch status {
        case .unknown, .offline:
            return false
        case .online(.wwan):
            return true
        case .online(.wiFi):
            return true
        }
        
    }
    
}

extension ReachabilityStatus {
    fileprivate init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .online(.wwan)
            } else {
                self = .online(.wiFi)
            }
        } else {
            self =  .offline
        }
    }
}
