//
//  CastomTableViewCell.swift
//  Rick and Morty API
//
//  Created by 1234 on 19.01.2024.
//

import UIKit

class CastomTableViewCell: UITableViewCell {

    let globalQueue =  DispatchQueue.global(qos: .utility)
    
    var character: Characters? {
        didSet {
            species.text = character?.species
            name.text = character?.name
            gender.text = character?.gender
            
            if  let imagePath = self.character?.image,
                let imageURL = URL(string: imagePath){
                
                globalQueue.async {
                    if let imageData = try? Data(contentsOf: imageURL){
                        DispatchQueue.main.async{
                            self.imagePhoto.image = UIImage(data: imageData )
                        }
                    }
                }
            } else {
                self.imagePhoto.image = UIImage(systemName: "person.fill")
                return
            }
        }
    }
    
    // MARK: - Outlets
    
    private lazy var imagePhoto: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var viewContainer: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var name: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "RubikBurned-Regular", size: 18)
        label.numberOfLines =  3
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var species: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines =  1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var gender: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines =  1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [name, species, gender])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.setCustomSpacing(3, after: name)
        stack.setCustomSpacing(2, after: species)
        stack.setCustomSpacing(2, after: gender)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarhy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePhoto.image = nil 
    }
    
    // MARK: - Setup
    
    private func setupHierarhy() {
        contentView.addSubview(viewContainer)
        viewContainer.addSubview(imagePhoto)
        contentView.addSubview(stack)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainer.heightAnchor.constraint(equalToConstant: 130),
            viewContainer.widthAnchor.constraint(equalToConstant: 140),
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 10),
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            imagePhoto.heightAnchor.constraint(equalToConstant: 130),
            imagePhoto.widthAnchor.constraint(equalToConstant: 140),
            
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.leftAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 15),
            stack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30)
        ])
    }
}

