//
//  NewExamViewController.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-09-28.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

protocol NewExamDelegate: AnyObject {
    func saveExam(exam: Exam)
}

class NewExamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var answerPerQuestionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var questionsOnExamSlider: UISlider!
    @IBOutlet weak var questionsOnExamValueLabel: UILabel!
    @IBOutlet weak var examNameTextField: UITextField!
    @IBOutlet weak var examQuestionsTableView: UITableView!
    
    weak var delegate: NewExamDelegate?
    
    private var questions: [Question] = Array(0..<180).map { Question(number: $0 + 1, selectedAnswer: .A) }
    var exam: Exam?
    
    var answersPerQuestion = 4 {
        didSet {
            exam?.answersPerQuestion = answersPerQuestion
            examQuestionsTableView.reloadData()
        }
    }
    
    var questionsOnExam = 100 {
        didSet {
            exam?.questions = Array(questions.prefix(questionsOnExam))
            questionsOnExamValueLabel.text = "\(questionsOnExam)"
            examQuestionsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let exam = exam {
            title = exam.name
            examNameTextField.text = exam.name
            questionsOnExam = exam.numQuestions
            answersPerQuestion = exam.answersPerQuestion
        } else {
            exam = Exam(name: "", questions: Array(questions.prefix(questionsOnExam)), answersPerQuestion: answersPerQuestion)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveExam))
        
        examQuestionsTableView.delegate = self
        examQuestionsTableView.dataSource = self
        examNameTextField.delegate = self
        
        setupViewElements()
    }
    
    private func setupViewElements() {
        answerPerQuestionSegmentedControl.selectedSegmentIndex = answersPerQuestion - 2
        questionsOnExamSlider.value = Float(questionsOnExam)
        questionsOnExamValueLabel.text = "\(questionsOnExam)"
    }
    
    @objc func saveExam() {
        guard let name = examNameTextField.text, !name.isEmpty, var exam = exam else {
            Alert.showBasicAlert(on: self, with: "Error", message: "Please enter an exam name.")
            return
        }
        
        exam.name = name
        delegate?.saveExam(exam: exam)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Event Handlers
    @IBAction func answersPerQuestionSegmentedControlValueDidChange(_ sender: UISegmentedControl) {
        answersPerQuestion = sender.selectedSegmentIndex + 2
    }
    
    @IBAction func questionsOnExamSliderValueDidChange(_ sender: UISlider) {
        questionsOnExam = Int(round(sender.value))
    }
    
    //MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsOnExam
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        cell.formatCell(questionNumber: indexPath.row + 1, exam: exam!)
        cell.segmentSelectAction = { sender in
            self.questions[indexPath.row].selectedAnswer = Answer.allValues[sender.selectedSegmentIndex]
        }
        return cell
    }
    
    //MARK: - UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
}
