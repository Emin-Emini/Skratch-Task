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

    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpCardView()
        setUpPanGesture()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        guard let user = user else { return }
        configureUserDetailsView(with: UserViewModel(with: user))
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
    This function adds shadow to Card View  */
    func setUpCardView() {
        cardView.layer.shadowColor = UIColor.darkGray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 8
    }
    
    /*
    This function updates Labels and Images from selected Table View Cell  */
    func configureUserDetailsView(with viewModel: UserViewModel) {
        guard let imageData = try? Data(contentsOf: viewModel.picture.large) else {
            fatalError()
        }
        profilePicture.image = UIImage(data: imageData)
        nameLabel.text = "\(viewModel.name.first.capitalized) \(viewModel.name.last.capitalized)"
        usernameLabel.text = "\(viewModel.login.username)"
        
        genderAgeLabel.text = "\(viewModel.gender.capitalized) \(viewModel.dob.age)"
        birthdateLabel.text = formatDate(date: viewModel.dob.date, withTime: false)
        streetLabel.text = "\(viewModel.location.street.number) \(viewModel.location.street.name)"
        cityCountryLabel.text = "\(viewModel.location.city), \(viewModel.location.state), \(viewModel.location.country)"
        phoneLabel.text = "\(viewModel.phone)"
        emailLabel.text = "\(viewModel.email)"
        registeredDateLabel.text = "Registered on \(formatDate(date: viewModel.registered.date, withTime: true))"
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
    
    func setUpPanGesture() {
        self.pan = UIPanGestureRecognizer(target: self, action: #selector(self.panAction))
        self.pan.delegate = self
        self.pan.maximumNumberOfTouches = 1
        self.pan.cancelsTouchesInView = true

        cardView.addGestureRecognizer(self.pan)
    }
    
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
