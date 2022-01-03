//
//  HomeViewController.swift
//  BeProductive
//
//  Created by Arwa Alattas on 24/05/1443 AH.
//

import UIKit
import Firebase
class HomeViewController: UIViewController,HamburgerViewControllerDelegate {
    var lists:[Category] = []
//    var lists = [Category]()
    var selectedList:Category?
    var selectedListImage:UIImage?
    @IBOutlet weak var leadingConstraintForHumburgerView: NSLayoutConstraint!
    @IBOutlet weak var backViewForHumburger: UIView!
    @IBOutlet weak var humbergerView: UIView!
    @IBOutlet weak var listsTableView: UITableView!{
        didSet{
            listsTableView.delegate = self
            listsTableView.dataSource = self
            
        }
    }
    //  -------------------------------------------------------Burger menu ---------------------------------------------- //
    var humbergerViewController:HumburgerViewController?
    private var isHamburgerMenuShown:Bool = false
    private var beginPoint:CGFloat = 0.0
    private var difference:CGFloat = 0.0
    //  -------------------------------------------------------Burger menu ---------------------------------------------- //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backViewForHumburger.isHidden = true
        gitList()
        // Do any additional setup after loading the view.
    }
    
    func gitList(){
        let ref = Firestore.firestore()
        ref.collection("Lists").order(by: "createdAt", descending: true).addSnapshotListener { snapshot , error  in
            if let error = error {
                print("DB ERROR listss",error.localizedDescription)
            }
            if let snapshot = snapshot{
                print("liST CANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let listData = diff.document.data()
                    switch diff.type{
                    case .added:
                        if let userId = listData["userId"] as? String{
                            print("jjjj",userId)
                            ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print("ERROR list Data",error.localizedDescription)
                                }
                                if let userSnapshot = userSnapshot,
                                let userData = userSnapshot.data(){
                                    let user = User(dict:userData)
                                    let list = Category(dict: listData, id: diff.document.documentID, user: user)
                                    if let currentUser = Auth.auth().currentUser ,
                                       user.id == currentUser.uid{
                                        self.listsTableView.beginUpdates()
                                                                            if snapshot.documentChanges.count != 1 {
                                                                                self.lists.append(list)
                                                                                self.listsTableView.insertRows(at: [IndexPath(row: self.lists.count-1, section: 0)], with: .automatic)
                                                                            }else{
                                                                                self.lists.insert(list, at: 0)
                                                                                self.listsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                                                            }
                                                                            
                                                                            self.listsTableView.endUpdates()
                                                                            }
                                }
                            }
                        }
                    case .modified:
                        let listId = diff.document.documentID
                        if let currentLest = self.lists.first(where: { $0.id == listId }),
                           let updateIndex = self.lists.firstIndex(where: { $0.id == listId }){
                            let newList = Category(dict: listData, id: listId, user: currentLest.userId)
                            self.lists[updateIndex] = newList
                            self.listsTableView.beginUpdates()
                            self.listsTableView.deleteRows(at: [IndexPath(row: updateIndex, section: 0)], with: .left)
                            self.listsTableView.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                            self.listsTableView.endUpdates()
                        }
                        
                    case .removed:
                        let listId = diff.document.documentID
                        if let deletIndex = self.lists.firstIndex(where: {$0.id == listId}){
                            self.lists.remove(at: deletIndex)
                            self.listsTableView.beginUpdates()
                            self.listsTableView.deleteRows(at: [IndexPath(row: deletIndex,section: 0)], with: .automatic)
                            self.listsTableView.endUpdates()
     }
    }
   }
  }
 }
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "humbergerSegue"){
            if let controller = segue.destination as? HumburgerViewController{
                humbergerViewController = controller
                humbergerViewController?.delegate = self
            }
        }
        if  let goToRecordingVC = segue.destination as? RecordingsViewController{
            goToRecordingVC.selectedList = selectedList
        }
    }
    
    
    //  -------------------------------------------------------Burger menu ---------------------------------------------- //
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
                    //  -------------------------------------------------------Burger menu ---------------------------------------------- //
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
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListTableViewCell
//        if let currentUser = Auth.auth().currentUser ,
//           lists[indexPath.row].userId.id == currentUser.uid{
        DispatchQueue.main.async {
            cell.nameOfList.text = self.lists[indexPath.row].name
            cell.imageOfList.loadImageUsingCache(with: self.lists[indexPath.row].imageUrl)
        }
        
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 119
//    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedList = lists[indexPath.row]
        performSegue(withIdentifier: "goToListOfRecordingsVC", sender: self)
    }
    
    
    
}
