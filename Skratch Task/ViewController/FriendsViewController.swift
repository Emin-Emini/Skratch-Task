//
//  FriendsViewController.swift
//  Skratch Task
//
//  Created by Emin Emini on 3.4.21.
//

import UIKit

class FriendsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var friendsTableView: UITableView!
    
    //MARK: - Properties
    let apiController = APIController()
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        apiController.getUsers { (error) in
            if let error = error {
                NSLog("Error performing data task: \(error)")
            }
            
            DispatchQueue.main.async {
                self.friendsTableView.reloadData()
            }
        }
    }

    

}

//MARK: - Functions
extension FriendsViewController {
    // This functions call the segue in storyboard and passes data from Table View to Details View through API Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetailsSegue" {
            guard let userDetailsVC = segue.destination as? FriendDetailsViewController else { return }
            guard let indexPath = friendsTableView.indexPathForSelectedRow else { return }
            
            let user = apiController.users[indexPath.row]
            userDetailsVC.user = user
        }
    }
}

//MARK: - Table View
extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiController.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell
        
        let user = apiController.users[indexPath.row]
        
        guard let imageData = try? Data(contentsOf: user.picture.thumbnail) else {
            fatalError()
        }
        cell.profilePicture.image = UIImage(data: imageData)
        cell.fullNameLabel.text = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
        cell.usernameLabel.text = "\(user.login.username)"
        
        return cell
    }
}
