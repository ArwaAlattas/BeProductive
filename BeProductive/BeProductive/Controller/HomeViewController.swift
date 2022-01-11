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
    var searchController = UISearchController(searchResultsController: nil)
    var filteredList :[Category] = []
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
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Lists"
        definesPresentationContext = true
     searchController.searchResultsUpdater = self
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
            self.backViewForHumburger.alpha = 0.90
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
                    self.backViewForHumburger.alpha = 1
                    self.isHamburgerMenuShown = true
                    self.backViewForHumburger.isHidden = false
                }
            }
        }
        
    }
}
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return searchController.isActive ? filteredList.count : lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListTableViewCell
        let list = searchController.isActive ? filteredList[indexPath.row] : lists[indexPath.row]
        DispatchQueue.main.async {
            cell.nameOfList.text = list.name
            cell.imageOfList.loadImageUsingCache(with: list.imageUrl)
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
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete".localized){(action,view,comlectionHandler) in
            let ref = Firestore.firestore().collection("Lists")
            //**********
             Firestore.firestore().collection("records").whereField("categoryId", isEqualTo: self.lists[indexPath.row].id).addSnapshotListener {snapShot  , error in
                if let error = error {
                    print("Error in db delete",error)
                }else {
                    snapShot?.documents.forEach({ diff in
                        diff.reference.delete()
                        if let currentUser = Auth.auth().currentUser{
                            Storage.storage().reference(withPath: "records/\(currentUser.uid)/\(self.lists[indexPath.row].id)/\(diff.documentID)").delete { error in
                                if let error = error {
                                    print("Error in storage delete",error)
                                }
                            }}
                    })
                }}
            //*******
            if let currentUser = Auth.auth().currentUser{
                let listId = self.lists[indexPath.row].id
                ref.document(self.lists[indexPath.row].id).delete { error in
                    if let error = error {
                        print("Error in db delete",error)
                    }else {
                        // Create a reference to the file to delete
                        let storageRef = Storage.storage().reference(withPath: "lists/\(currentUser.uid)/\(listId)")
                        
                        // Delete the file
                        storageRef.delete { error in
                            if let error = error {
                                print("Error in storage delete",error)
                            }
                        }
                        
                    }
                }
            }
            
        }
        
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
    
}
extension HomeViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredList = lists.filter({ list in
            return list.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        listsTableView.reloadData()
    }
    
    
}
