//
//  FriendTableViewCell.swift
//  Skratch Task
//
//  Created by Emin Emini on 3.4.21.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: UserViewModel) {
        guard let imageData = try? Data(contentsOf: viewModel.picture.medium) else {
            fatalError()
        }
        profilePicture.image = UIImage(data: imageData)
        fullNameLabel.text = "\(viewModel.name.first) \(viewModel.name.last)"
        usernameLabel.text = viewModel.login.username
    }

}
