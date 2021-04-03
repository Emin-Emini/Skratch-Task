//
//  FriendDetailsViewController.swift
//  Skratch Task
//
//  Created by Emin Emini on 3.4.21.
//

import UIKit

class FriendDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var genderAgeLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var registeredDateLabel: UILabel!
    
    //MARK: - Properties
    var user: User? {
        didSet {
            //updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateViews()
    }
    

    //MARK: - Actions
    @IBAction func goBack() {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
        }
    }

}

//MARK: - Functions
extension FriendDetailsViewController {
    
    //Update Labels and Images from selected Table View Cell
    func updateViews() {
        //guard isViewLoaded, let user = user else { return }
        guard let user = user else { return }
        
        guard let imageData = try? Data(contentsOf: user.picture.large) else {
            fatalError()
        }
        profilePicture.image = UIImage(data: imageData)
        nameLabel.text = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
        usernameLabel.text = "\(user.login.username)"
        
        genderAgeLabel.text = "\(user.gender.capitalized) \(user.dob.age)"
        birthdateLabel.text = "\(user.dob.date)"
        streetLabel.text = "\(user.location.street.number) \(user.location.street.name)"
        cityCountryLabel.text = "\(user.location.street.number) \(user.location.street.name)"
        phoneLabel.text = "\(user.phone)"
        emailLabel.text = "\(user.email)"
        registeredDateLabel.text = "Registered on \(user.registered.date)"
        
        
        
    }
}
