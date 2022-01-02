//
//  NewRecordViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 29/05/1443 AH.
//

import UIKit

class NewRecordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //    dissmis navigation bar
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }

}
