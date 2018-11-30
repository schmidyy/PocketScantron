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
    private static let kExamsKey = "kExamsKey"
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

    static func saveExams(exams: [Exam]) {
        print("Saving \(exams.count) exams")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(exams) {
            defaults.set(encoded, forKey: kExamsKey)
        }
    }

    static func localExams() -> [Exam]? {
        if let savedExamData = defaults.object(forKey: kExamsKey) as? Data {
            let decoder = JSONDecoder()
            if let exams = try? decoder.decode([Exam].self, from: savedExamData) {
                print("Found \(exams.count) exams on the device")
                return exams
            }
        }
        print("No exams on the device")
        return nil
    }
}
