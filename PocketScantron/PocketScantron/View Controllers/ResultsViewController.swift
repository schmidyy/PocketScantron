//
//  ResultsViewController.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-11-07.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

struct ComputedResults {
    var baseExam: Exam!
    var results: ResultResponse!
    
    var totalQuestions: Int {
        return baseExam.numQuestions
    }
    
    var incorrectAnswerNumbers: [Int] {
        var questions: [Int] = []
        for i in 0..<totalQuestions {
            if let examQuestion = baseExam.questions.first(where: { $0.number == results.results[i].number }) {
                if examQuestion.selectedAnswer.rawValue != results.results[i].answer {
                    questions.append(examQuestion.number)
                }
            }
        }
        return questions
    }
    
    var correctAnswers: Int {
        return totalQuestions - incorrectAnswerNumbers.count
    }
    
    var percentage: Double {
        return (Double(correctAnswers) / Double(totalQuestions)) * 100
    }
    
    var percentageString: String {
        return String(format: "%.1f", percentage) + "%"
    }
}

class ResultsViewController: UIViewController {

    @IBOutlet weak var fractionLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet var emojiLabels: [UILabel]!
    
    @IBOutlet weak var incorrectAnswersTableView: UITableView!
    
    var results: ComputedResults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incorrectAnswersTableView.delegate = self
        incorrectAnswersTableView.dataSource = self
        
        layoutResultsView()
    }
    
    private func layoutResultsView() {
        fractionLabel.text = "\(results.correctAnswers)/\(results.totalQuestions)"
        percentageLabel.text = results.percentageString
        
        switch results.percentage {
        case 0..<50:
            emojiLabels.forEach { $0.text = "😵" }
        case 50..<65:
            emojiLabels.forEach { $0.text = "😕" }
        case 65..<80:
            emojiLabels.forEach { $0.text = "😃" }
        case 80..<101:
            emojiLabels.forEach { $0.text = "🎉" }
        default:
            emojiLabels.forEach { $0.text = "🚀" }
        }
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.results.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let question = results.results.results[indexPath.row]
        cell.textLabel?.text = "\(question.number): \(question.answer)"
        if (results.incorrectAnswerNumbers.contains(question.number)) {
            cell.textLabel?.textColor = .red
            cell.textLabel?.text = cell.textLabel?.text ?? "" + " - Correct answer: \(results.baseExam.questions.first(where: { $0.number == question.number })!.selectedAnswer.rawValue)"
        } else {
            cell.textLabel?.textColor = .black
        }
        return cell
    }
}
