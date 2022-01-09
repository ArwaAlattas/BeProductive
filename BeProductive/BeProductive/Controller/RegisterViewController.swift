//
//  RegisterViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 23/05/1443 AH.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var signupLabel: UILabel!{
        didSet{
            signupLabel.text = "Sign up".localized
            
        }
    }
    
    @IBOutlet weak var registerBTN: UIButton!{
        didSet{
            
            registerBTN.setTitle("Register".localized, for: .normal)
        }
        
    }
    @IBOutlet weak var userImageView: UIImageView!{
    didSet{
        userImageView.layer.borderColor = UIColor.systemBackground.cgColor
        userImageView.layer.borderWidth = 3.0
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        userImageView.layer.masksToBounds = true
        userImageView.isUserInteractionEnabled = true
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        userImageView.addGestureRecognizer(tabGesture)
    }}
    @IBOutlet weak var userNameTextField: UITextField!{
        didSet{
//            userNameTextField.placeholder = "USERNAME".localized
            userNameTextField.attributedPlaceholder = NSAttributedString(string: "USERNAME".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
            userNameTextField.layer.cornerRadius = 25
            userNameTextField.delegate = self
        }
        
    }
    @IBOutlet weak var userEmailTextField: UITextField!{
        didSet{
//            userEmailTextField.placeholder = "E-MAIL".localized
            userEmailTextField.attributedPlaceholder = NSAttributedString(string: "E-MAIL".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
            userEmailTextField.layer.cornerRadius = 10
            userEmailTextField.delegate = self
        }
    }
    @IBOutlet weak var userPasswordTextField: UITextField!{
        didSet{
            userPasswordTextField.isSecureTextEntry = true
//            userPasswordTextField.placeholder = "PASSWORD".localized
            userPasswordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
            userPasswordTextField.layer.cornerRadius = 10
            userPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var confirmPasswordTextField: UITextField!{
        didSet{
            confirmPasswordTextField.isSecureTextEntry = true
//            confirmPasswordTextField.placeholder = "REPEAT PASSWORD".localized
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "REPEAT PASSWORD".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
            confirmPasswordTextField.layer.cornerRadius = 10
            confirmPasswordTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
    }
    
    
    @IBAction func handleRegister(_ sender: Any) {
        if let image = userImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.25),
           let name = userNameTextField.text,
           let email = userEmailTextField.text,
           let password = userPasswordTextField.text,
           let confirmPassword = confirmPasswordTextField.text,
           password == confirmPassword{
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error{
                    print("Registration Auth Error",error.localizedDescription)
                    let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .actionSheet)
                    let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                }
                if let authResult = authResult{
//                    for image
                    let storagRef = Storage.storage().reference(withPath: "user/\(authResult.user.uid)")
                    let  uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storagRef.putData(imageData, metadata: uploadMeta) { storagMeta, error in
                        if let error = error{
                            print("Registration Storage Error",error.localizedDescription)
                            let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .actionSheet)
                            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        }
                        storagRef.downloadURL { url, error in
                            if let error = error{
                                print("Registration Storage Download Url Error",error.localizedDescription)
                                let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .actionSheet)
                                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                                alert.addAction(ok)
                                self.present(alert, animated: true, completion: nil)
                                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                            }
                            if let url = url{
                                print("URL",url.absoluteString)
                                let db = Firestore.firestore()
                                let userData: [String:String] = [
                                    "id":authResult.user.uid,
                                    "name":name,
                                    "email":email,
                                    "imageUrl":url.absoluteString
                                ]
                                db.collection("users").document(authResult.user.uid).setData(userData) { error in
                                    if let error = error{
                                        print("Registration Database error",error.localizedDescription)
                                        let alert = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .actionSheet)
                                        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                                        alert.addAction(ok)
                                        self.present(alert, animated: true, completion: nil)
                                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                    }else{
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                                            vc.modalPresentationStyle = .fullScreen
                                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                            self.present(vc, animated: true, completion: nil)
                                        
                                    }
                                }
                        }
                    }
                }
              }
            }
          }
        }
    }
}
extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @objc func selectImage() {
        showAlert()
    }
    func showAlert(){
        let alert = UIAlertController(title: "choose Profile Picture", message: "where do you want to pick your image from?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { Action in
            self.getImage(from: .camera)
        }
        let galaryAction = UIAlertAction(title: "photo Album", style: .default) { Action in
            self.getImage(from: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "Cancle", style: .destructive) { Action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(galaryAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func getImage( from sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return}
        userImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension RegisterViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
