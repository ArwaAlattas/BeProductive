//
//  TimerViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 11/06/1443 AH.
//

import UIKit

class TimerViewController: UIViewController {

    
    var timer = Timer()
    var secs = 59
    var mins = 25
    
    
    @IBOutlet weak var resetBTN: UIButton!{
        didSet{
            resetBTN.setTitle("RESET".localized, for: .normal)
        }
    }
    @IBOutlet weak var startBTN: UIButton!{
        didSet{
            startBTN.setTitle("START".localized, for: .normal)
        }
    }
    @IBOutlet weak var statrTimerLabel: UILabel!{
        didSet{
            statrTimerLabel.text = "take 25 ".localized
        }
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startTimer(_ sender: Any) {
        if startBTN.titleLabel?.text == "START".localized{
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                  if self.secs > 0 {
                      self.secs = self.secs - 1
                  }
                  else if self.mins > 0 && self.secs == 0 {
                      self.mins = self.mins - 1
                      self.secs = 59
                  }
   
                  self.updateLabel()
              })
            
            startBTN.setTitle("STOP".localized, for: .normal)
        }else{
            timer.invalidate()
            startBTN.setTitle("START".localized, for: .normal)
            
        }
        
    }
   
    @IBAction func resetTimer(_ sender: Any) {
        timer.invalidate()
         secs = 59
         mins = 25
        timerLabel.text = "25:00"
    }
    
    
    private func updateLabel() {

        timerLabel.text = "\(mins):\(secs)"
    }
    
}
