//
//  NewExamViewController.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-09-28.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class NewExamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var answerPerQuestionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var questionsOnExamSlider: UISlider!
    @IBOutlet weak var questionsOnExamValueLabel: UILabel!
    @IBOutlet weak var examNameTextField: UITextField!
    @IBOutlet weak var examQuestionsTableView: UITableView!
    
    var answersPerQuestion = 4 {
        didSet {
            examQuestionsTableView.reloadData()
        }
    }
    
    var questionsOnExam = 90 {
        didSet {
            questionsOnExamValueLabel.text = "\(questionsOnExam)"
            examQuestionsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.formatCell(questionNumber: indexPath.row + 1, numAnswers: answersPerQuestion)
        return cell
    }
    
    //MARK: - UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
}
