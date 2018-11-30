//
//  ResultResponse.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-11-04.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ResultResponse {
    struct Result {
        let number: Int
        let answer: String
    }
    
    let results: [Result]

    init(withDictionary json: JSON) {
        var response: [Result] = []
        for subJson in json {
            let number = subJson.1["current_question"].intValue
            let answer = subJson.1["letter_guess"].stringValue
            response.append(Result(number: number, answer: answer))
        }
        self.results = response
    }

    init(results: [Result]) {
        self.results = results
    }
}
