//
//  ListOfRecordingsViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 28/05/1443 AH.
//

import UIKit
import AVFoundation
import Firebase
class RecordingsViewController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    var records:[Record] = []
    var selectedRecord:Record?
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
    
    var selectedList:Category?
    var path = 0
    var selectedIndex = -1
    var isCollapes = false
    var recordings:[Record] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        if let selectedList = selectedList {
            nameOfListLabel.text = selectedList.name
        }
        recordsTabelView.estimatedRowHeight = 183
        recordsTabelView.rowHeight = UITableView.automaticDimension
        if let selectedRecord = selectedRecord {
            print("uygyggtgtygtyg")
            print("I can do it inshallah",selectedRecord.categoryId.id)
        }
          }
    func gitRecords(){
        
        
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
    func setupPlayer(){
        let audiofileName = gitDirec().appendingPathComponent(fileName)
        do{
          soundPlayer = try AVAudioPlayer(contentsOf: audiofileName)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
//            print("ygjgfuyg",soundPlayer.url!)
        } catch{
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        playBTN.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
      recordingBTN.isEnabled = true
//        playBTN.setTitle("Play", for: .normal)
       
    }
    
    
    
    @IBAction func startRecordAction(_ sender: Any) {
        if recordingBTN.titleLabel?.text == "Record"{
            soundRecorder.record()
            recordingBTN.setTitle("Stop", for: .normal)
            //playBTN.isEnabled = false
        }else{
            soundRecorder.stop()
            uploadSound(audieURL:soundRecorder.url)
            recordingBTN.setTitle("Record", for: .normal)
            print("ygjgfuyg",soundRecorder.url)
            //playBTN.isEnabled = false
        }
     
        
    }
    func uploadSound(audieURL:URL) {
        if let currentUser = Auth.auth().currentUser,
           let selectedList = selectedList?.id{
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
}

extension RecordingsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell") as! RecordingsTableViewCell
       
//        cell.playRecordButton.addTarget(self, action: #selector(playrecord), for: .touchUpInside)
        return cell
    }
    
//    @objc func playrecord(sender:UIButton){
//}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        path = indexPath.row + 1
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedIndex == indexPath.row
        {
            if isCollapes == false
            {
            isCollapes = true
        }else
            {
          isCollapes = false
        }
        }else{
          isCollapes = true
        }
        selectedIndex = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .automatic)
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndex == indexPath.row && isCollapes == true{

           return 183

        }else{

            return 60
        }
    }

}
















//}
//let metadata = StorageMetadata()
//    metadata.contentType = "audio/m4a"
//    let riversRef = Storage.storage().reference().child("message_voice").child("\(self.getDate()).m4a")
//    do {
//        let audioData = try Data(contentsOf: recorder.url)
//        riversRef.putData(audioData, metadata: metadata){ (data, error) in
//            if error == nil{
//                debugPrint("se guardo el audio")
//                riversRef.downloadURL {url, error in
//                    guard let downloadURL = url else { return }
//                    debugPrint("el url descargado", downloadURL)
//                }
//            }
//            else {
//                if let error = error?.localizedDescription{
//                    debugPrint("error al cargar imagen", error)
//                }
//                else {
//                    debugPrint("error de codigo")
//                }
//            }
//        }
//    } catch {
//        debugPrint(error.localizedDescription)
//    }
//        let storageRef = Storage.storage().reference()
//        let imagesRef = storageRef.child("upload")
//        let fileName = "/" + "new sound" + ".m4a"
//       let uploadTask = spaceRef.putFile(localFile, metadata: nil) { metadata, error in
//            if let error = error {
//                print(error)
//            } else {
//                // Metadata contains file metadata such as size, content-type, and download URL.
//                let downloadURL = metadata!.downloadURL()
//            }
//        }


//    func that gets path to directory
//        func getDirectory()-> URL{
//            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//            let documentDirectory = path[0]
//            return documentDirectory
//        }
//    //   func that display an alert
//        func displayAlert(title:String,message:String){
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
//            present(self, animated: true, completion: nil)
//        }
