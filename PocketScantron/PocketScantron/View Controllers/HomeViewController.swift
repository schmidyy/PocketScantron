//
//  HomeViewController.swift
//  PocketScantron
//
//  Created by Mat Schmid on 2018-09-19.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
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
}
