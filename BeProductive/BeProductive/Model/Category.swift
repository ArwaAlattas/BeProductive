//
//  Category.swift
//  BeProductive
//
//  Created by Arwa Alattas on 23/05/1443 AH.
//

import Foundation
import Firebase
struct Category {
    var id = ""
    var name = ""
    var imageUrl = ""
    var createdAt:Timestamp?
    var userId:User
    init(dict:[String:Any],id:String,user:User) {
        if let name = dict["name"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
            let createdAt = dict["createdAt"] as? Timestamp{
            self.name = name
            self.imageUrl = imageUrl
            self.createdAt = createdAt
        }
        self.id = id
        self.userId = user
    }

}
