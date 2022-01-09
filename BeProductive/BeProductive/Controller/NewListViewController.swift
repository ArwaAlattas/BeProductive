//
//  NewListViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 25/05/1443 AH.
//

import UIKit
import Firebase
class NewListViewController: UIViewController {
    var selectedList:Category?
    var selectedListImage:UIImage?
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var newListImageView: UIImageView!
    @IBOutlet weak var saveBTN: UIButton!{
        didSet{
            saveBTN.setTitle("save".localized, for: .normal)
        }
    }
    @IBOutlet weak var nameOfNewListTextField: UITextField!{
        didSet{
            nameOfNewListTextField.delegate = self
            nameOfNewListTextField.attributedPlaceholder = NSAttributedString(string: "newNameForYourList".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        }
    }
    @IBOutlet weak var exampleListCollectionView: UICollectionView!{
        didSet{
            exampleListCollectionView.delegate = self
            exampleListCollectionView.dataSource = self
        }
    }
    var namesOfLists = ["Today".localized,"Tomorrow".localized,"Studing".localized,"Someday".localized,"Comfortable task".localized,"Works".localized,"Cleaning".localized,"Communications".localized,"Shopping".localized,"Travlings".localized,"Workouts".localized,"Special days".localized,"Events".localized,"Any Tasks".localized]
    var imagesOfLists = ["sun","sunset","book","upcoming","praying","work","cleaning","communication","shopping","travel","workout","specialday","events","tasks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "back".localized, style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveListAction(_ sender: Any) {
        if let image = newListImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.25),
           let name = nameOfNewListTextField.text,
            let currentUser = Auth.auth().currentUser {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            var listId = ""
            if let selectedList = selectedList {
                listId = selectedList.id
            }else{
                listId = "\(Firebase.UUID())"
            }
            let storageRef = Storage.storage().reference(withPath: "lists/\(currentUser.uid)/\(listId)")
            let uploadMeta = StorageMetadata.init()
            uploadMeta.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: uploadMeta) { storageMeta, error in
                if let error = error {
                    print("Upload error",error.localizedDescription)
                }
                storageRef.downloadURL { url, error in
                    var listData = [String:Any]()
                    if let url = url{
                        let db = Firestore.firestore()
                        let ref = db.collection("Lists")
                        if let selectedList = self.selectedList {
                            listData = [
                                "id": listId,
                                "userId":selectedList.userId.id,
                                "name":name,
                                "imageUrl":url.absoluteString,
                                "createdAt":selectedList.createdAt ??
                                FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                        }else{
                            listData = [
                                "userId":currentUser.uid,
                                "name":name,
                                "imageUrl":url.absoluteString,
                                "createdAt":FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                                ]
                        }
                        ref.document(listId).setData(listData) { error in
                            if let error = error {
                                print("FireStore Error",error.localizedDescription)
                            }
                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}
extension NewListViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return namesOfLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListsCell", for: indexPath) as! ListsCollectionViewCell
        cell.setupLists(image: imagesOfLists[indexPath.row], name: namesOfLists[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.3, height: self.view.frame.width * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newListImageView.image = UIImage(named: imagesOfLists[indexPath.row])
        nameOfNewListTextField.text = namesOfLists[indexPath.row]
    }
    
    
}
extension NewListViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
