//
//  ListOfRecordingsViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 28/05/1443 AH.
//

import UIKit
import AVFoundation
import Firebase
class RecordingsViewController: UIViewController {
    let activityIndicator = UIActivityIndicatorView()
    var records:[Record] = []
   var selectedRecord:Record?
    var selectedList:Category?
    @IBOutlet weak var nameOfListLabel: UILabel!
    @IBOutlet weak var recordsTabelView: UITableView!{
        didSet{
            recordsTabelView.delegate = self
            recordsTabelView.dataSource = self
        }
    }
    @IBOutlet weak var recordingBTN: UIButton!
    
    
    var soundRecorder:AVAudioRecorder!
    var soundPlayer:AVAudioPlayer!
    var fileName:String = "audioFile.m4a"
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        if let selectedList = selectedList {
            nameOfListLabel.text = selectedList.name
                  }
        recordsTabelView.estimatedRowHeight = 183
        recordsTabelView.rowHeight = UITableView.automaticDimension
        getRecording()
        
      }
    
    
    func getRecording(){
        let ref = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid,
        let categoryId = selectedList?.id else {return}
        ref.collection("records").order(by: "createdAt", descending: true).whereField("categoryId", isEqualTo: categoryId).whereField("userId", isEqualTo: userId).addSnapshotListener { snapshot , error  in
            if let error = error {
                print("DB ERROR listss",error.localizedDescription)
            }
            if let snapshot = snapshot{
                print("liST CANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let listData = diff.document.data()
                    switch diff.type{
                    case .added:
                        let record = Record(dict: listData, id: diff.document.documentID)
                        self.recordsTabelView.beginUpdates()
      if snapshot.documentChanges.count != 1 {
           self.records.append(record)
         self.recordsTabelView.insertRows(at: [IndexPath(row: self.records.count-1, section: 0)], with: .automatic)
             }else{
                self.records.insert(record, at: 0)
                    self.recordsTabelView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                     }
          self.recordsTabelView.endUpdates()
                        print("ADD",listData["audioUrl"]!)
                    case .modified:
                        let recordId = diff.document.documentID
                        if let currentRecord = self.records.first(where: { $0.id == recordId
                        }),let updateIndex = self.records.firstIndex(where: { $0.id == recordId }){
                          let newRecord = Record(dict: listData, id: diff.document.documentID)
                            self.records[updateIndex] = newRecord
                            self.recordsTabelView.beginUpdates()
                            self.recordsTabelView.deleteRows(at: [IndexPath(row: updateIndex, section: 0)], with: .left)
                            self.recordsTabelView.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                            self.recordsTabelView.endUpdates()
                        }
                    case .removed:
                        let recordId = diff.document.documentID
                        if let deletIndex = self.records.firstIndex(where: {$0.id == recordId}){
                            self.records.remove(at: deletIndex)
                            self.recordsTabelView.beginUpdates()
                            self.recordsTabelView.deleteRows(at: [IndexPath(row: deletIndex,section: 0)], with: .automatic)
                            self.recordsTabelView.endUpdates()
     }
     }
    }
   }
  }
 }

    
}

extension RecordingsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell") as! RecordingsTableViewCell
        cell.nameOfRecord.text = records[indexPath.row].name
        cell.playRecordButton.addTarget(self, action: #selector(playrecord), for: .touchUpInside)
        cell.playRecordButton.tag = indexPath.row
        return cell
    }
    
    @objc func playrecord(sender:UIButton){
        if let url = URL(string:records[sender.tag].audioUrl){
            let data = try! Data(contentsOf: url)
            soundPlayer = try! AVAudioPlayer(data: data)
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
            soundPlayer.play()
           
        }}
    
//
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        }
     
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete"){(action,view,comlectionHandler) in
            let ref = Firestore.firestore().collection("records")
            if let selectedList = self.selectedList?.id,
            let currentUser = Auth.auth().currentUser{
                Activity.showIndicator(parentView: self.view, childView: self.activityIndicator)
                ref.document(self.records[indexPath.row].id).delete { error in
                    if let error = error {
                        print("Error in db delete",error)
                    }else {
                        // Create a reference to the file to delete
                        let storageRef = Storage.storage().reference(withPath: "records/\(currentUser.uid)/\(selectedList)/\(self.records[indexPath.row].id)")
                        
                        // Delete the file
                        storageRef.delete { error in
                            if let error = error {
                                print("Error in storage delete",error)
                            } else {
                                self.activityIndicator.stopAnimating()
                            }
                        }
                        
                    }
                }
            }
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit"){(action,view,comlectionHandler) in
            let alert = UIAlertController(title: "Update", message: "Write new title for record ", preferredStyle: .alert)
            let textFeild = alert.textFields![0] as UITextField
            alert.addTextField { (textFeild)  in
                textFeild.text = self.records[indexPath.row].name
                textFeild.placeholder = "add new name for record"
            }
            alert.addAction(UIAlertAction(title: "Save", style:.destructive, handler: {(action: UIAlertAction) in
               print("hhh+++++++++++++++++++++++++")
                    var recordData = [String:Any]()
                                    let db = Firestore.firestore()
                                    let ref = db.collection("records")
                    recordData = ["userId":self.records[indexPath.row].userId ,
                                  "name":textFeild.text!,
                                  "audioUrl": self.records[indexPath.row].audioUrl,
                                  "categoryId":self.records[indexPath.row].categoryId,
                                  "createdAt":self.records[indexPath.row].createdAt ?? FieldValue.serverTimestamp() ,
                                                          "updatedAt": FieldValue.serverTimestamp()
                                            ]
                                            let recordId = self.records[indexPath.row].id
                                        ref.document(recordId).setData(recordData) { error in
                                            if let error = error {
                                                print("FireStore Error",error.localizedDescription)
                                            }
                                        }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        deleteAction.backgroundColor = .systemRed
        editAction.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }
  
    //    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        <#code#>
    //    }
   
    }
   

extension RecordingsViewController:AVAudioRecorderDelegate,AVAudioPlayerDelegate{
    
    @IBAction func startRecordAction(_ sender: Any) {
        if recordingBTN.titleLabel?.text == "Record"{
            soundRecorder.record()
            recordingBTN.setTitle("Stop", for: .normal)
           
        }else{
            soundRecorder.stop()
            uploadSound(audieURL:soundRecorder.url)
            recordingBTN.setTitle("Record", for: .normal)
            print("ygjgfuyg_____________________________________",soundRecorder.url)
        }
     
    }
    
    func uploadSound(audieURL:URL) {
        if let currentUser = Auth.auth().currentUser,
           let selectedList = selectedList?.id
           {
            var recordId = ""
            if let selectedRecord = selectedRecord {
                recordId = selectedRecord.id
            }else{
                recordId = "\(Firebase.UUID())"
            }
            let metadata = StorageMetadata.init()
            metadata.contentType = "audio/m4a"
            let storageRef = Storage.storage().reference(withPath: "records/\(currentUser.uid)/\(selectedList)/\(recordId)")
            do {
                let audioData =  try Data(contentsOf:audieURL)
                storageRef.putData(audioData, metadata:metadata) { data, error in
                    if let error = error {
                        print("Upload error",error.localizedDescription)
                    }
                    storageRef.downloadURL { url, error in
                        var recordData = [String:Any]()
                        if let url = url{
                            let db = Firestore.firestore()
                            let ref = db.collection("records")
                            if let selectedList = self.selectedList {
                                recordData = ["userId": selectedList.userId.id,
                                              "name":"new record",
                                              "audioUrl": url.absoluteString,
                                              "categoryId":selectedList.id,
                                              "createdAt":selectedList.createdAt ?? FieldValue.serverTimestamp() ,
                                              "updatedAt": FieldValue.serverTimestamp()
                                ]
                            }
                            ref.document(recordId).setData(recordData) { error in
                                if let error = error {
                                    print("FireStore Error",error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    func gitDirec()-> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       return path[0]
    }
    func setupRecorder(){
        let audiofileName = gitDirec().appendingPathComponent(fileName)
        let recordSetting = [AVFormatIDKey:kAudioFormatAppleLossless,
                  AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue,
                       AVEncoderBitRateKey:320000,
                           AVSampleRateKey:44100.2] as [String:Any]
        do{
            soundRecorder = try AVAudioRecorder(url: audiofileName, settings: recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        }catch{
           print(error)
        }
    }

    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        playBTN.isEnabled = true
//        recordsTabelView.reloadData()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
      recordingBTN.isEnabled = true
       
    }
}
    
    
