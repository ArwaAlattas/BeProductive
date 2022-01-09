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
   var userId = ""
    var categoryId = ""
    var state = false
    init(dict:[String:Any],id:String) {
        if let name = dict["name"] as? String,
           let audioUrl = dict["audioUrl"] as? String,
           let userId = dict["userId"] as? String,
           let categoryId = dict["categoryId"] as? String,
           let state = dict["state"] as? Bool,
            let createdAt = dict["createdAt"] as? Timestamp{
            self.name = name
            self.audioUrl = audioUrl
            self.createdAt = createdAt
            self.userId = userId
            self.categoryId = categoryId
            self.state = state
        }
        self.id = id
    }   
}
