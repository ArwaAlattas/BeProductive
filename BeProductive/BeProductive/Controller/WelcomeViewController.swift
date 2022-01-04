//
//  WelcomeViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 23/05/1443 AH.
//

import UIKit

class WelcomeViewController: UIViewController {

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
    


}
