//
//  Device.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-10-22.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation

struct Device {
    private static let kDeviceKey = "kDeviceKey"
    private static let defaults = UserDefaults.standard
    
    static func id() -> String {
        if let deviceID = defaults.value(forKey: kDeviceKey) {
            return deviceID as! String
        } else {
            let id = NSUUID().uuidString
            defaults.set(id, forKey: kDeviceKey)
            return id
        }
    }
}
