//
//  ViewController.swift
//  Rick and Morty API
//
//  Created by 1234 on 18.01.2024.
//

import UIKit
import SwiftyGif

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    private var mainView = MainView()
    
    private var dataHandler: [Characters] = []

    var viewModel = ViewModel()

    let logoAnimationView = LogoAnimationView()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "RubikBurned-Regular", size: 34)
        label.text = "Rick and Morty"
        label.numberOfLines =  1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //  MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       

        setupView()
        viewConfiguration()

        setupHierarhy()
        setupLogoAnimation()
        setupLayout()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = titleLabel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }
    
    // MARK: - Setup

    private func setupView() {
        
        APIFetchHandler.sharedInstance.fetchAPIData(queryItemValue: nil ){ apiData in
            self.dataHandler = apiData
            
            DispatchQueue.main.async{
                self.mainView.tableView.reloadData()
            }
        }
    }

    private func setupLogoAnimation() {
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
    }
    
    private func setupHierarhy() {
        view.addSubview(logoAnimationView)

    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
           
        ])
    }
    
    private func viewConfiguration() {
        mainView.tableView.register(CastomTableViewCell.self, forCellReuseIdentifier: "cell")
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataHandler.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CastomTableViewCell
        cell?.character = dataHandler[indexPath.row]
        cell?.contentView.backgroundColor = .systemGray6
        return cell ?? UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let viewController = DetailViewController()
//        present(viewController, animated: true)
//        viewController.character = dataHandler[indexPath.row]
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}

extension ViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}

