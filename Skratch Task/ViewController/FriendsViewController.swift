//
//  FriendsViewController.swift
//  Skratch Task
//
//  Created by Emin Emini on 3.4.21.
//

import UIKit
import Mapbox
import BetterSegmentedControl

class FriendsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var mapBoxView: UIView!
    @IBOutlet weak var betterSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var betterSegmentedControlShadow: UIView!
    @IBOutlet weak var listSizeView: UIView!
    @IBOutlet weak var listSizeTextField: UITextField!
    @IBOutlet weak var listSizeTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var finishSelectingListSizeButtonConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    //let apiController = APIController()
    var apiController = APIController(listSize: 5)
    
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadSegmentedControl()
        loadListSizeView()
        
        fetchDataFromAPI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    //MARK: - Actions
    @IBAction func changeMapList(_ sender: BetterSegmentedControl) {
        //print("The selected index is \(sender.index)")
        switch sender.index {
        case 0:
            mapBoxView.isHidden = false
        case 1:
            mapBoxView.isHidden = true
        default:
            break
        }
    }
    
    @IBAction func finishSelectingFriendsSize(_ sender: Any) {
        let selectedNumber = Int(listSizeTextField.text ?? "0") ?? 0
        apiController = APIController(listSize: selectedNumber)
        listSizeTextFieldConstraint.constant = 42
        finishSelectingListSizeButtonConstraint.constant = 100
        fetchDataFromAPI()
        view.endEditing(true)
    }
    
}

//MARK: - Fetch Data From API
extension FriendsViewController {
    func fetchDataFromAPI() {
        apiController.getFriends(completion: { result in
            switch result {
            case .success(let listSize):
                DispatchQueue.main.async {
                    //print(listSize)
                    self.friendsTableView.reloadData()
                    self.loadMapBox()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        })
    }
}

//MARK: - Functions
extension FriendsViewController {
    
    /*This Functions loads Better Segmented Control.
     Assigns icons and tint color. Also adds shadow to background of segment control    */
    func loadSegmentedControl() {
        // Control 3: Many options
        betterSegmentedControl.segments = IconSegment.segments(withIcons: [UIImage(named: "map")!, UIImage(named: "list")!],
                                                               iconSize: CGSize(width: 20.0, height: 20.0),
                                                               normalIconTintColor: UIColor(red: 210/255, green: 212/255, blue: 227/255, alpha: 1.0),
                                                               selectedIconTintColor: UIColor(red: 86/255, green: 38/255, blue: 244/255, alpha: 1.0))
        
        betterSegmentedControlShadow.layer.shadowColor = UIColor.darkGray.cgColor
        betterSegmentedControlShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        betterSegmentedControlShadow.layer.shadowOpacity = 0.2
        betterSegmentedControlShadow.layer.shadowRadius = 8
    }
    
    func loadListSizeView() {
        listSizeView.layer.shadowColor = UIColor.darkGray.cgColor
        listSizeView.layer.shadowOffset = CGSize(width: 0, height: 0)
        listSizeView.layer.shadowOpacity = 0.2
        listSizeView.layer.shadowRadius = 8
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
        
        guard let imageData = try? Data(contentsOf: user.picture.medium) else {
            fatalError()
        }
        cell.profilePicture.image = UIImage(data: imageData)
        cell.fullNameLabel.text = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
        cell.usernameLabel.text = "\(user.login.username)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = apiController.users[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let friendDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "FriendDetailsVC") as! FriendDetailsViewController
        friendDetailsViewController.user = selectedUser
        self.present(friendDetailsViewController, animated: true, completion: nil)
    }
}


//MARK: - Mapbox

extension FriendsViewController: MGLMapViewDelegate {
    
    func loadMapBox() {
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self

        // Set the map’s center coordinate and zoom level.
        //mapView.setCenter(CLLocationCoordinate2D(latitude: 41.8864, longitude: -87.7135), zoomLevel: 13, animated: false)
        mapBoxView.addSubview(mapView)
        
        loadFriendsOnMapbox(mapView: mapView)
    }
    
    func loadFriendsOnMapbox(mapView: MGLMapView) {
        var pointAnnotations = [MGLPointAnnotation]()
        
        for user in apiController.users {
            guard let latitude = Double(user.location.coordinates.latitude) else { return }
            guard let longitude = Double(user.location.coordinates.longitude) else { return }
            
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            point.title = "\(user.name.first) \(user.name.last)"
            pointAnnotations.append(point)
        }
         
        mapView.addAnnotations(pointAnnotations)
    }
    
    // MARK: - Map Box Delegate methods
    
    // This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 154, height: 100)
            annotationView!.delegate = self
            
            guard let index = apiController.users.firstIndex(where: { Double($0.location.coordinates.longitude) == annotation.coordinate.longitude }) else { return nil }
            annotationView!.updateViews(withUser: apiController.users[index])
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

// MARK: - CustomAnnotationViewDelegate
extension FriendsViewController: CustomAnnotationViewDelegate {
    
    func didClickAnnonation(withUser user: User) {
        print("Cliked annonation with user: ", user.name.first)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let friendDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "FriendDetailsVC") as! FriendDetailsViewController
        friendDetailsViewController.user = user
        self.present(friendDetailsViewController, animated: true, completion: nil)
    }
}

// MARK:- Text Field

extension FriendsViewController: UITextFieldDelegate {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            listSizeTextFieldConstraint.constant = keyboardHeight - 20
            finishSelectingListSizeButtonConstraint.constant = 0
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        return true
    }

}
