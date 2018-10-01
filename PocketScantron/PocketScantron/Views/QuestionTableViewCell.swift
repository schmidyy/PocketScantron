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
    
    func formatCell(questionNumber: Int, numAnswers: Int) {
        numberLabel.text = "\(questionNumber)"
        answerSegmentedControl.replaceSegments(numSegments: numAnswers)
    }
    
    @IBAction func answerSegmentedControlValueDidChange(_ sender: UISegmentedControl) {
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
