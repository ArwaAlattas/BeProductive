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
    
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!{
        didSet{
            sliderCollectionView.delegate = self
            sliderCollectionView.dataSource = self
        }
    }
    var statments = ["        BE PRODUCTIVE","KEEP GOING","SUCCESS IS A DECISION","WORK ON YOU FOR YOU","IT'S GOOD DAY TO HAVE GOOD DAY ","DO IT FOR YOU NOT FOR THEM","DREAM. PLAN. DO.","IF NOT NOW , WHEN ?","NO RISK   NO STORY","IF YOU DREAM IT YOU CAN DO IT",""]
    var timer2 = Timer()
    var counter = 0
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.timer2 = Timer.scheduledTimer(timeInterval: 2.0 , target: self, selector: #selector(self.changeStatment), userInfo: nil, repeats: true)
        }
    }
    @objc func changeStatment(){
        if counter < statments.count{
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        }else{
          counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            counter = 1
        }
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
extension TimerViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MotivationStatmentsCollectionViewCell
        
        cell.motvationStatmentLabel.text = statments[indexPath.row]
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width , height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}