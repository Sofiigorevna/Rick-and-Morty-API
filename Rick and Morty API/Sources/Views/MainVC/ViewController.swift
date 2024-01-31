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
    
    var viewModel = ViewModel()
    let logoAnimationView = LogoAnimationView()
    private var mainView = MainView()
    var cellDataSource = [Characters]()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "RubikBurned-Regular", size: 34)
        label.text = "Rick and Morty"
        label.numberOfLines =  1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    //  MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfiguration()
        setupHierarhy()
        setupLayout()
        setupLogoAnimation()
        bindViewModel()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = titleLabel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
        viewModel.getData()
    }
    
    // MARK: - Setup
    
    private func setupLogoAnimation() {
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
    }
    
    private func setupHierarhy() {
        view.addSubview(logoAnimationView)
        view.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func viewConfiguration() {
        mainView.tableView.register(CastomTableViewCell.self, forCellReuseIdentifier: "cell")
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.prefetchDataSource = self
    }
    
    private func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self, let isLoading else {return}
            DispatchQueue.main.async {
                isLoading ? self.activityIndicator.startAnimating() :  self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.cellDataSource.bind({ [weak self] users in
            guard let self, let users else {return}
            self.cellDataSource = users
            DispatchQueue.main.async{
                self.mainView.tableView.reloadData()
            }
        })
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print("Prefetching \(indexPath.row)")
            let _ = viewModel.dataSource[indexPath.row]
            APIFetchHandler.sharedInstance.fetchAPIData(queryItemValue: nil, handlerMain: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CastomTableViewCell
        cell?.character = viewModel.dataSource[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = DetailViewController()
        viewController.character = viewModel.dataSource[indexPath.row]
        viewController.locations = viewModel.dataSource[indexPath.row].location
        present(viewController, animated: true)
    }
}

extension ViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}

