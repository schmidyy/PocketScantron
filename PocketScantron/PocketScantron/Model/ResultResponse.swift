//
//  ResultResponse.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-11-04.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation

struct ResultResponse {
    struct Result {
        let number: Int
        let answer: String
    }
    
    let results: [Result]
}
