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
    var delegate : HamburgerViewControllerDelegate?
    @IBOutlet weak var userProfileImageView: UIImageView!{
        didSet{
            userProfileImageView.layer.cornerRadius = 40
            userProfileImageView.clipsToBounds = true
            
            
        }
    }
    @IBOutlet weak var mainBackgroundView: UIView!{
        didSet{
            mainBackgroundView.layer.cornerRadius = 40
            mainBackgroundView.clipsToBounds = true
        }
        
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImageView.image = nil
            gitList()
        // Do any additional setup after loading the view.
       
    }
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
    
}
