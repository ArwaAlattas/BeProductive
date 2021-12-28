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

        // Do any additional setup after loading the view.
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
