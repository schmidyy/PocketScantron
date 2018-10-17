//
//  QuestionTableViewCell.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-09-28.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var answerSegmentedControl: UISegmentedControl!
    
    var segmentSelectAction: ((UISegmentedControl) -> Void)?
    
    func formatCell(questionNumber: Int, exam: Exam) {
        numberLabel.text = "\(questionNumber)"
        answerSegmentedControl.replaceSegments(numSegments: exam.answersPerQuestion)
        switch exam.questions[questionNumber - 1].selectedAnswer {
        case .A:
            answerSegmentedControl.selectedSegmentIndex = 0
        case .B:
            answerSegmentedControl.selectedSegmentIndex = 1
        case .C:
            answerSegmentedControl.selectedSegmentIndex = 2
        case .D:
            answerSegmentedControl.selectedSegmentIndex = 3
        case .E:
            answerSegmentedControl.selectedSegmentIndex = 4
        }
    }
    
    @IBAction func answerSegmentedControlValueDidChange(_ sender: UISegmentedControl) {
        segmentSelectAction?(sender)
    }
    
}

extension UISegmentedControl {
    func replaceSegments(numSegments: Int) {
        let segmentStrings = Answer.allValues
        self.removeAllSegments()
        for i in 0..<numSegments {
            self.insertSegment(withTitle: segmentStrings[i].rawValue, at: self.numberOfSegments, animated: false)
        }
    }
}
