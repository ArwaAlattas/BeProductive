//
//  LoginViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 23/05/1443 AH.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var signinLabel: UILabel!{
        didSet{
            signinLabel.text = "Sign in".localized
        }
    }
    
    @IBOutlet weak var loginBTN: UIButton!{
        didSet{
            loginBTN.setTitle("Login".localized, for: .normal)
        }
    }
    @IBOutlet weak var userEmailTextField: UITextField!{
        didSet{
            userEmailTextField.attributedPlaceholder = NSAttributedString(string: "E-MAIL".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
            userEmailTextField.delegate = self
        }
    }
    @IBOutlet weak var userPasswordTextField: UITextField!{
        didSet{
            userPasswordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
            userPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var eyePass: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        userPasswordTextField.rightView = eyePass
        userPasswordTextField.rightViewMode = .whileEditing
        userPasswordTextField.isSecureTextEntry = true
    }
    @IBAction func eyePass(_ sender: UIButton) {
        userPasswordTextField.isSecureTextEntry.toggle()
               if  userPasswordTextField.isSecureTextEntry {
                   if let image = UIImage(systemName: "eye.slash.fill") {
                       sender.setImage(image, for: .normal)
                   }
               } else {
                   if let image = UIImage(systemName: "eye.fill"){
                       sender.setImage(image, for: .normal)
                   }
    }
    }
    @IBAction func handleLoginBTN(_ sender: Any) {
        
        if let email = userEmailTextField.text,
           let passowrd = userPasswordTextField.text{
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: passowrd) { authResult, error in
                if let error = error{
                    print("ERROR IN SIGNIN")
                    let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .actionSheet)
                    let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                if let _ = authResult{
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar") as? UITabBarController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        
        
        
        
    }
    


}
extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
