//
//  ExamTableViewCell.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-09-19.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class ExamTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numQuestionsLabel: UILabel!
    @IBOutlet weak var numAnswersLabel: UILabel!
    
    func formatCell(for exam: Exam) {
        accessoryType = .disclosureIndicator
        
        nameLabel.text = exam.name
        numQuestionsLabel.text = "\(exam.numQuestions) questions"
        numAnswersLabel.text = "\(exam.answersPerQuestion) answer options"
    }
}
