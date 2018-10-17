//
//  ScanExamViewController.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-10-16.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit
import WeScan

class ScanExamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ImageScannerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var examTableView: UITableView!
    
    private var savedExams: [Exam] = [Exam(name: "BIOL1902", questions: [Question(number: 1, selectedAnswer: .A)], answersPerQuestion: 3)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        examTableView.delegate = self
        examTableView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissButtonTapped))
        scanButton.layer.cornerRadius = 6;
    }

    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        let scannerVC = ImageScannerController()
        scannerVC.imageScannerDelegate = self
        self.present(scannerVC, animated: true)
    }
    
    //MARK: - Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        guard !savedExams.isEmpty else {
            tableView.emptyMessageView(message: "There are no saved exams on this device. You can add one by selecting the + on the top right of this screen.")
            return 0
        }
        tableView.restore()
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedExams.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "examCell", for: indexPath) as! ExamTableViewCell
        cell.formatCell(for: savedExams[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                resetChecks()
                cell.accessoryType = .checkmark
            }
        }
    }
    
    func resetChecks() {
        for j in 0..<examTableView.numberOfRows(inSection: 0) {
            if let cell = examTableView.cellForRow(at: NSIndexPath(row: j, section: 0) as IndexPath) {
                cell.accessoryType = .none
            }
        }
    }
    
    //MARK: - Image Scanner Controller Delegate Methods
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        imageView.image = results.scannedImage
        scanner.dismiss(animated: true)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // Your ViewController is responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
}
