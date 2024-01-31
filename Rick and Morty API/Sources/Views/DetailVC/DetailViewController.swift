//
//  DetailViewController.swift
//  Rick and Morty API
//
//  Created by 1234 on 26.01.2024.
//

import UIKit
class DetailViewController: UIViewController {
    
    let globalQueue =  DispatchQueue.global(qos: .background)
    
    var character: Characters? {
        didSet {
            name.text = "NAME:\n\(character?.name ?? "unknown")."
            species.text = "Species:\n \(character?.species ?? "unknown")."
            gender.text = "Gender:\n \(character?.gender ?? "unknown")."
            status.text = "Status:\n \(character?.status ?? "unknown")."
            episode.text = "Number of episodes in which this character was mentioned - \(character?.episode?.count ?? 0) "
            
            if  let imagePath = self.character?.image,
                let imageURL = URL(string: imagePath){
                
                globalQueue.async {
                    if let imageData = try? Data(contentsOf: imageURL){
                        let image = UIImage(data: imageData)
                        
                        
                        DispatchQueue.main.async{
                            if let image = image {
                                self.scroolView.addBlurredBackground(style: .light)
                                self.scroolView.backgroundColor = UIColor(patternImage: image)
                                self.iconNew.image = image
                            }
                        }
                    }
                }
            } else {
                self.iconNew.image = UIImage(systemName: "person.fill")
                return
            }
        }
    }
    
    var locations: Locations? {
        didSet{
            locationName.text = "Last known location: \(locations?.name ?? "unknown")."
        }
    }
    
    // MARK: - Outlets
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 50 )
    }
    
    private lazy var scroolView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.bounces = false
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var iconNew: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var viewContainerNew: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var species: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "RubikBurned-Regular", size: 19)
        label.numberOfLines =  2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var gender: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "RubikBurned-Regular", size: 19)
        label.numberOfLines =  2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var name: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "RubikBurned-Regular", size: 23)
        label.numberOfLines =  6
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var status: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "RubikBurned-Regular", size: 19)
        label.numberOfLines =  2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var locationName: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "RubikBurned-Regular", size: 19)
        label.numberOfLines =  8
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var episode: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "RubikBurned-Regular", size: 19)
        label.numberOfLines =  6
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [name,
                                                   status,
                                                   species,
                                                   episode,
                                                   gender,
                                                   locationName,
                                                  ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.setCustomSpacing(1, after: name)
        stack.setCustomSpacing(1, after: status)
        stack.setCustomSpacing(1, after: species)
        stack.setCustomSpacing(0, after: gender)
        stack.setCustomSpacing(0, after: episode)
        stack.setCustomSpacing(0, after: locationName)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarhy()
        setupLayout()
    }
    
    // MARK: - Setup
    private func setupHierarhy() {
        view.addSubview(scroolView)
        scroolView.addSubview(viewContainerNew)
        viewContainerNew.addSubview(iconNew)
        scroolView.addSubview(stack)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainerNew.centerXAnchor.constraint(equalTo: scroolView.centerXAnchor),
            viewContainerNew.topAnchor.constraint(equalTo: scroolView.topAnchor, constant: 40),
            viewContainerNew.widthAnchor.constraint(equalToConstant: 350),
            viewContainerNew.heightAnchor.constraint(equalToConstant: 300),
            
            iconNew.centerXAnchor.constraint(equalTo: viewContainerNew.centerXAnchor),
            iconNew.centerYAnchor.constraint(equalTo: viewContainerNew.centerYAnchor),
            iconNew.topAnchor.constraint(equalTo: viewContainerNew.topAnchor, constant: 1),
            iconNew.leftAnchor.constraint(equalTo: viewContainerNew.leftAnchor, constant: 1),
            
            stack.topAnchor.constraint(equalTo: viewContainerNew.bottomAnchor, constant: 30),
            stack.centerXAnchor.constraint(equalTo: scroolView.centerXAnchor),
            stack.widthAnchor.constraint(equalToConstant: 300),
            stack.heightAnchor.constraint(equalToConstant: 450),
        ])
    }
}

