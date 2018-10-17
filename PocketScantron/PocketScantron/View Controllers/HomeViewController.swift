//
//  HomeViewController.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-09-19.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit
import WeScan

class HomeViewController: UIViewController, ImageScannerControllerDelegate {
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewElements()
    }
    
    private func setupViewElements() {
        for view in buttonsStackView.arrangedSubviews {
            view.layer.cornerRadius = 6
        }
    }
    @IBAction func scanExamButtonTapped(_ sender: UIButton) {
        let scannerVC = ImageScannerController()
        scannerVC.imageScannerDelegate = self
        self.present(scannerVC, animated: true, completion: nil)
    }
    
    // Somewhere on your ViewController that conforms to ImageScannerControllerDelegate
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // Your ViewController is responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true, completion: nil)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // Your ViewController is responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true, completion: nil)
    }
}
