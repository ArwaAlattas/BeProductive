//
//  Record.swift
//  BeProductive
//
//  Created by Arwa Alattas on 23/05/1443 AH.
//

import Foundation
import Firebase
struct Record{
    var id = ""
    var name = ""
    var audioUrl = ""
    var createdAt:Timestamp?
   var userId:User
    var categoryId:Category
    init(dict:[String:Any],id:String,catogery:Category,user:User) {
        if let name = dict["name"] as? String,
           let audioUrl = dict["audioUrl"] as? String,
            let createdAt = dict["createdAt"] as? Timestamp{
            self.name = name
            self.audioUrl = audioUrl
            self.createdAt = createdAt
        }
        self.id = id
        self.categoryId = catogery
        self.userId = user
    }
    
    
    
    
    
    
    
}
