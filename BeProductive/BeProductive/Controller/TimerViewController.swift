//
//  TimerViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 11/06/1443 AH.
//

import UIKit

class TimerViewController: UIViewController {

    
    var timer = Timer()
    var hours = 0
    var secs = 59
    var mins = 30
    var row = 0
    
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
    
    @IBOutlet weak var timerPicker: UIPickerView!{
        didSet{
            timerPicker.dataSource = self
            timerPicker.delegate = self
        }
    }
    
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!{
        didSet{
            sliderCollectionView.delegate = self
            sliderCollectionView.dataSource = self
        }
    }
    var statments = ["        BE PRODUCTIVE".localized,"KEEP GOING".localized,"SUCCESS IS A DECISION".localized,"WORK ON YOU FOR YOU".localized,"IT'S GOOD DAY TO HAVE GOOD DAY ".localized,"DO IT FOR YOU NOT FOR THEM".localized,"DREAM. PLAN. DO.".localized,"IF NOT NOW , WHEN ?".localized,"NO RISK   NO STORY".localized,"IF YOU DREAM IT YOU CAN DO IT".localized,""]
    var timer2 = Timer()
    var counter = 0
    
    
    var times = ["30:00 minutes","1:00:00 hour"]
    var namOfTime = ["minutes","hour"]
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
                  }  else if self.hours > 0 && self.mins == 0 && self.secs == 0 {
                                      self.hours = self.hours - 1
                                      self.mins = 59
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
        if row == 0 {
            timer.invalidate()
             secs = 59
             mins = 30
            hours = 0
            timerLabel.text = "30:00"
        }else{
            timer.invalidate()
             secs = 59
             mins = 59
            hours = 1
            timerLabel.text = "1:00:00"
        }
       
    }
    
    private func updateLabel() {
        timerLabel.text = "\(hours):\(mins):\(secs)"
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
extension TimerViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return 2
    
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return times[row]
      
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0{
            self.row = 0
            hours = 0
            mins = 30
            secs = 59
            timerLabel.text = "\(30):\(00)"
        }else{
            self.row = 1
            hours = 1
            mins = 59
            secs = 59
            timerLabel.text = "\(1):\(00):\(00)"
            
        }
    }
}
