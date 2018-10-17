//
//  SavedSolutionsTableViewController.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-09-19.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class SavedSolutionsTableViewController: UITableViewController, NewExamDelegate {
    private var savedExams: [Exam] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExamButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissButtonTapped))
    }
    
    @objc func addExamButtonTapped() {
        let newExamViewController = storyboard?.instantiateViewController(withIdentifier: "newExamVC") as! NewExamViewController
        newExamViewController.delegate = self
        navigationController?.pushViewController(newExamViewController, animated: true)
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - New Exam Delegate
    func saveExam(exam: Exam) {
        let examNames = savedExams.map { $0.name }
        for (i, name) in examNames.enumerated() {
            if name == exam.name {
                savedExams[i] = exam
                return
            }
        }
        savedExams.append(exam)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard !savedExams.isEmpty else {
            tableView.emptyMessageView(message: "There are no saved exams on this device. You can add one by selecting the + on the top right of this screen.")
            return 0
        }
        tableView.restore()
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedExams.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "examCell", for: indexPath) as! ExamTableViewCell
        cell.formatCell(for: savedExams[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newExamViewController = storyboard?.instantiateViewController(withIdentifier: "newExamVC") as! NewExamViewController
        newExamViewController.exam = savedExams[indexPath.row]
        newExamViewController.delegate = self
        navigationController?.pushViewController(newExamViewController, animated: true)
    }
}
