//
//  WelcomeViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 23/05/1443 AH.
//

import UIKit

class WelcomeViewController: UIViewController {
    let activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var languageSegment: UISegmentedControl!{
        didSet {

            if let lang = UserDefaults.standard.string(forKey: "currentLanguage") {
                switch lang {
                case "en":
                    languageSegment.selectedSegmentIndex = 0
                case "ar":
                    languageSegment.selectedSegmentIndex = 1
                default:
                    let localLang =  Locale.current.languageCode
                     if localLang == "en" {
                         languageSegment.selectedSegmentIndex = 0
                     }else {
                         languageSegment.selectedSegmentIndex = 1
                     }
                  
                }
            
            }else {
                let localLang =  Locale.current.languageCode
                 if localLang == "en" {
                     languageSegment.selectedSegmentIndex = 0
                 }else{
                     languageSegment.selectedSegmentIndex = 1
                 }
            }
        }
    }
    
    
    @IBOutlet weak var registerBTN: UIButton!{
        didSet{
            registerBTN.setTitle("Get Started".localized, for: .normal)
            
        }
    }
    
    
    @IBOutlet weak var loginBTN: UIButton!{
        didSet{
            
            loginBTN.setTitle("Login".localized, for: .normal)
            
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
            }
//            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar") as? UITabBarController{
//                vc.modalPresentationStyle = .fullScreen
//                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
//                self.present(vc, animated: true, completion: nil)
//            }
        }
    }
    
}
