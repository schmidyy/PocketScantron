//
//  SavedSolutionsTableViewController.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-09-19.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit
import JGProgressHUD

class SavedSolutionsTableViewController: UITableViewController {
    private var savedExams: [Exam] = []
    let hud = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExamButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchExams()
    }
    
    private func fetchExams() {
        hud.textLabel.text = "Fetching..."
        hud.show(in: tableView)

        if let exams = Device.localExams() {
            savedExams = exams
        } else {
            tableView.emptyMessageView(message: "There are no saved exams on this device. You can add one by selecting the + on the top right of this screen.")
        }
        hud.dismiss()
        tableView.reloadData()
    }
    
    @objc func addExamButtonTapped() {
        let newExamViewController = storyboard?.instantiateViewController(withIdentifier: "newExamVC") as! NewExamViewController
        newExamViewController.delegate = self
        navigationController?.pushViewController(newExamViewController, animated: true)
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard !savedExams.isEmpty else {
            
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
        return cell
    }
}

extension SavedSolutionsTableViewController: NewExamDelegate {
    func didAddNewExam(exam: Exam) {
        savedExams.append(exam)
        Device.saveExams(exams: savedExams)
        fetchExams()
    }
}
