//
//  ViewController.swift
//  Rick and Morty API
//
//  Created by 1234 on 18.01.2024.
//

import UIKit
import SwiftyGif

class ViewController: UIViewController {

    let logoAnimationView = LogoAnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
        setupHierarhy()
        setupLayout()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }


    private func setupHierarhy() {
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
           
        ])
    }
}

extension ViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}

