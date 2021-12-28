//
//  HomeViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 24/05/1443 AH.
//

import UIKit
import Firebase
class HomeViewController: UIViewController,HamburgerViewControllerDelegate {
    @IBOutlet weak var leadingConstraintForHumburgerView: NSLayoutConstraint!
    
    @IBOutlet weak var backViewForHumburger: UIView!
    @IBOutlet weak var humbergerView: UIView!
    
    
    
    
    var humbergerViewController:HumburgerViewController?
    private var isHamburgerMenuShown:Bool = false
    private var beginPoint:CGFloat = 0.0
    private var difference:CGFloat = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backViewForHumburger.isHidden = true
        // Do any additional setup after loading the view.
    }
    
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "humbergerSegue"){
            
            if let controller = segue.destination as? HumburgerViewController{
                
                humbergerViewController = controller
                humbergerViewController?.delegate = self
            }
            
        }
    }
    
    
    
    @IBAction func tabpedOnHumbergerBackView(_ sender: Any) {
        hideHamburgerView()
        
    }
    func hideHamburgerMenu() {
        hideHamburgerView()
    }
    private func hideHamburgerView()
    {
        UIView.animate(withDuration: 0.1) {
            self.leadingConstraintForHumburgerView.constant = 10
            self.view.layoutIfNeeded()
        } completion: { (status) in
            self.backViewForHumburger.alpha = 0.0
            UIView.animate(withDuration: 0.1) {
                self.leadingConstraintForHumburgerView.constant = -280
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.backViewForHumburger.isHidden = true
                self.isHamburgerMenuShown = false
            }
        }
    }
    @IBAction func showHumbergerMenue(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.leadingConstraintForHumburgerView.constant = 10
            self.view.layoutIfNeeded()
        } completion: { (status) in
            self.backViewForHumburger.alpha = 0.75
            self.backViewForHumburger.isHidden = false
            UIView.animate(withDuration: 0.1) {
                self.leadingConstraintForHumburgerView.constant = 0
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.isHamburgerMenuShown = true
            }

        }

        self.backViewForHumburger.isHidden = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHamburgerMenuShown)
        {
             if let touch = touches.first
            {
                let location = touch.location(in: backViewForHumburger)
                beginPoint = location.x
            }
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHamburgerMenuShown)
        {
            if let touch = touches.first
            {
                let location = touch.location(in: backViewForHumburger)
                
                let differenceFromBeginPoint = beginPoint - location.x
                
                if (differenceFromBeginPoint>0 || differenceFromBeginPoint<280)
                {
                    difference = differenceFromBeginPoint
                    self.leadingConstraintForHumburgerView.constant = -differenceFromBeginPoint
                    self.backViewForHumburger.alpha = 0.75-(0.75*differenceFromBeginPoint/280)
                }
            }
        }
        
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHamburgerMenuShown)
        {
            if (difference>140)
            {
                UIView.animate(withDuration: 0.1) {
                    self.leadingConstraintForHumburgerView.constant = -290
                } completion: { (status) in
                    self.backViewForHumburger.alpha = 0.0
                    self.isHamburgerMenuShown = false
                    self.backViewForHumburger.isHidden = true
                }
            }
            else{
                UIView.animate(withDuration: 0.1) {
                    self.leadingConstraintForHumburgerView.constant = -10
                } completion: { (status) in
                    self.backViewForHumburger.alpha = 0.75
                    self.isHamburgerMenuShown = true
                    self.backViewForHumburger.isHidden = false
                }
            }
        }
        
    }
}
