//
//  Exam.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-09-19.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation

struct Exam: Codable {
    var id: String
    var name: String
    var questions: [Question]
    var answersPerQuestion: Int
    var numQuestions: Int {
        return questions.count
    }
}

enum Answer: String, Codable {
    case A, B, C, D, E
    static let allValues = [A, B, C, D, E]
}

struct Question: Codable {
    let number: Int
    var selectedAnswer: Answer = .A
}
