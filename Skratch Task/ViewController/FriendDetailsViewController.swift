//
//  FriendDetailsViewController.swift
//  Skratch Task
//
//  Created by Emin Emini on 3.4.21.
//

import UIKit

class FriendDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
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
    //User data
    var user: User? {
        didSet {
            //updateViews()
        }
    }
    
    //Gestures
    private var pan: UIPanGestureRecognizer!
    
    let darknessThreshold: CGFloat = 0.2
    let dismissThreshold: CGFloat = 60.0 * UIScreen.main.nativeScale
    var dismissFeedbackTriggered = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        updateViews()
        
        // Gestures
        self.pan = UIPanGestureRecognizer(target: self, action: #selector(self.panAction))
        self.pan.delegate = self
        self.pan.maximumNumberOfTouches = 1
        self.pan.cancelsTouchesInView = true

        cardView.addGestureRecognizer(self.pan)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        })
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
    
    /*
    This function updates Labels and Images from selected Table View Cell  */
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
        birthdateLabel.text = formatDate(date: user.dob.date, withTime: false)
        streetLabel.text = "\(user.location.street.number) \(user.location.street.name)"
        cityCountryLabel.text = "\(user.location.street.number) \(user.location.street.name)"
        phoneLabel.text = "\(user.phone)"
        emailLabel.text = "\(user.email)"
        registeredDateLabel.text = "Registered on \(formatDate(date: user.dob.date, withTime: true))"
    }
    
    /*
    This function formats date in the way you select.
    For instance:
    The received date is "1951-03-25T19:11:03.083Z",
    It will format it to "25 March 1951, 7:11pm"    */
    func formatDate(date: String, withTime: Bool) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        if withTime {
            dateFormatter.dateFormat = "dd MMMM yyyy, HH:mma"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            
        } else {
            dateFormatter.dateFormat = "dd MMMM yyyy"
        }
       let dateObj: Date? = dateFormatterGet.date(from: date)

       return dateFormatter.string(from: dateObj!)
    }
}


//MARK: - Gesture Recognizers Functions
extension FriendDetailsViewController {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.pan {
            return limitPanAngle(self.pan, degreesOfFreedom: 45.0, comparator: .greaterThan)
        }

        return true
    }
    
    private func updatePresentedViewForTranslation(_ yTranslation: CGFloat) {
        let translation: CGFloat = rubberBandDistance(yTranslation, dimension: cardView.frame.height, constant: 0.55)

        cardView.transform = CGAffineTransform(translationX: 0, y: max(translation, 0.0))
    }
    
    @objc private func panAction(gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.isEqual(self.pan) else {
            return
        }

        switch gestureRecognizer.state {
        case .began:
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: cardView)

        case .changed:
            let translation = gestureRecognizer.translation(in: cardView)

            self.updatePresentedViewForTranslation(translation.y)

            if translation.y > self.dismissThreshold, !self.dismissFeedbackTriggered {
                self.dismissFeedbackTriggered = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        case .ended, .failed:
            let translation = gestureRecognizer.translation(in: cardView)

            if translation.y > self.dismissThreshold {
                self.goBack()
                return
            }

            self.dismissFeedbackTriggered = false

            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 1.5,
                           options: .preferredFramesPerSecond60,
                           animations: {
                            self.cardView.transform = .identity
            })
            
        case .cancelled:
            UIView.animate(withDuration: 0.1, animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(1.0)
            })

        default: break
        }
    }
    
}
