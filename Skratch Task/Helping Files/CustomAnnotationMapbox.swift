//
//  CustomAnnotationMapbox.swift
//  Skratch Task
//
//  Created by Emin Emini on 4.4.21.
//

import Foundation
import UIKit
import Mapbox

protocol CustomAnnotationViewDelegate: class {
    func didClickAnnonation(withUser user: User)
}

class CustomAnnotationView: MGLAnnotationView {
    
    weak var delegate: CustomAnnotationViewDelegate?
    
    // MARK: Private properties
    private var user: User!
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.font = .systemFont(ofSize: 15)
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.systemBackground.cgColor
        imageView.layer.borderWidth = 3.0
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(userNameLabel)
        addSubview(userProfileImageView)
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topAnchor),
            userNameLabel.widthAnchor.constraint(equalToConstant: 90), //Calculate the width of the label based on the text size
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            userNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            userProfileImageView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 60),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 60),
            userProfileImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        
        [userNameLabel, userProfileImageView].forEach {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc
    private func handleTapGesture(_ sender: Any) {
        delegate?.didClickAnnonation(withUser: user)
    }
    
    func updateViews(withUser user: User) {
        self.user = user
        
        userNameLabel.text = "\(user.name.first)"
        guard let imageData = try? Data(contentsOf: user.picture.medium) else {
            fatalError()
        }
        userProfileImageView.image = UIImage(data: imageData)
        userProfileImageView.clipsToBounds = true
        
    }
}
