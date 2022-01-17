//
//  humBurgerViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 24/05/1443 AH.
//

import UIKit
import Firebase
protocol HamburgerViewControllerDelegate {
    func hideHamburgerMenu()
}
class HumburgerViewController: UIViewController {
    let activityIndicator = UIActivityIndicatorView()
    var delegate : HamburgerViewControllerDelegate?
    @IBOutlet weak var logoutBTN: UIButton!{
        didSet{
            
            logoutBTN.setTitle("Logout".localized, for: .normal)
        }
        
    }
    
    @IBOutlet weak var userProfileImageView: UIImageView!{
        didSet{
            userProfileImageView.layer.cornerRadius = 20
            userProfileImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var mainBackgroundView: UIView!{
        didSet{
            mainBackgroundView.layer.cornerRadius = 40
            mainBackgroundView.clipsToBounds = true
        }
        
    }
    
    @IBOutlet weak var langsegment: UISegmentedControl!{
        didSet {

            if let lang = UserDefaults.standard.string(forKey: "currentLanguage") {
                switch lang {
                case "ar":
                    langsegment.selectedSegmentIndex = 1
                case "en":
                    langsegment.selectedSegmentIndex = 0
                default:
                    let localLang =  Locale.current.languageCode
                     if localLang == "ar" {
                         langsegment.selectedSegmentIndex = 1
                     }else {
                         langsegment.selectedSegmentIndex = 0
                     }
                  
                }
            
            }else {
                let localLang =  Locale.current.languageCode
                 if localLang == "ar" {
                     langsegment.selectedSegmentIndex = 1
                 }else{
                     langsegment.selectedSegmentIndex = 0
                 }
            }
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImageView.image = nil
            gitList()
        // Do any additional setup after loading the view.
       
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//   
//    }
    func gitList(){
        let ref = Firestore.firestore()
        ref.collection("Lists").order(by: "createdAt", descending: true).addSnapshotListener { snapshot , error  in
            if let error = error {
                print("DB ERROR listss",error.localizedDescription)
            }
            if let snapshot = snapshot{
                print("liST CANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let listData = diff.document.data()
                    if let userId = listData["userId"] as? String{
                        ref.collection("users").document(userId).getDocument { userSnapshot, error in
                            if let error = error {
                                print("ERROR list Data",error.localizedDescription)
                            }
                            if let userSnapshot = userSnapshot,
                            let userData = userSnapshot.data(){
                                let user = User(dict:userData)
                               
                                    DispatchQueue.main.async {
                                        self.userProfileImageView.loadImageUsingCache(with: user.imageUrl)
                                        self.userNameLabel.text = user.name
                                        self.userEmailLabel.text = user.email
                                }
                                
                               
                                
                            }
                                  
                        }
                    }
               }
                 }
              }
            }
   
    @IBAction func handleLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeNavigationController") as? UINavigationController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } catch  {
            print("ERROR in signout",error.localizedDescription)
            let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        self.delegate?.hideHamburgerMenu()
    }
    
    
    
    @IBAction func changeLanguageSegment(_ sender: UISegmentedControl) {
        if let lang = sender.titleForSegment(at:sender.selectedSegmentIndex)?.lowercased() {
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
            UserDefaults.standard.set(lang, forKey: "currentLanguage")
            Bundle.setLanguage(lang)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar") as? UITabBarController{
                vc.modalPresentationStyle = .fullScreen
                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
      
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localization", bundle: .main, value: self, comment: self)
    }
}
