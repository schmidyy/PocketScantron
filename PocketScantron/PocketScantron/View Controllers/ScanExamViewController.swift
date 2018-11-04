//
//  ScanExamViewController.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-10-16.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit
import WeScan
import JGProgressHUD

class ScanExamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ImageScannerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var examTableView: UITableView!
    
    private var savedExams: [Exam] = []
    
    private var selectedExamID: String? {
        didSet {
            updateNavBarButton()
        }
    }
    
    private var examImage: UIImage? {
        didSet {
            updateNavBarButton()
        }
    }
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        examTableView.delegate = self
        examTableView.dataSource = self
        
        hud.textLabel.text = "Fetching..."
        hud.show(in: examTableView)
        
        FirestoreClient.savedExams(completion: { [weak self] exams in
            self?.hud.dismiss()
            guard let `self` = self else { return }
            
            if let exams = exams {
                self.savedExams = exams
            } else {
                self.examTableView.emptyMessageView(message: "There are no saved exams on this device. You can add one from the home screen")
            }
            self.examTableView.reloadData()
        })
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
        scanButton.layer.cornerRadius = 6;
    }

    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        guard let image = examImage?.noir else { return }
        FirestoreClient.uploadImage(increaseContrast(image)) { url in
            guard let urlString = url, let examID = self.selectedExamID else { return }
            print(urlString)
            
            FirestoreClient.saveImage(url: urlString, examID: examID, completion: {
                //
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func updateNavBarButton() {
        guard examImage != nil && selectedExamID != nil else { return }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        let scannerVC = ImageScannerController()
        scannerVC.imageScannerDelegate = self
        self.present(scannerVC, animated: true)
    }
    
    //MARK: - Table View Delegate Methods
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
        selectedExamID = savedExams[indexPath.row].id
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                resetChecks()
                cell.accessoryType = .checkmark
                //TODO: save selected exam
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
        DispatchQueue.main.async {
            self.imageView.image = results.scannedImage
        }
        
        examImage = results.scannedImage
        scanner.dismiss(animated: true)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // Your ViewController is responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
    
    func increaseContrast(_ image: UIImage) -> UIImage {
        let inputImage = CIImage(image: image)!
        let parameters = [
            "inputContrast": NSNumber(value: Int.max)
        ]
        let outputImage = inputImage.applyingFilter("CIColorControls", parameters: parameters)
        
        let context = CIContext(options: nil)
        let img = context.createCGImage(outputImage, from: outputImage.extent)!
        return UIImage(cgImage: img)
    }
}
