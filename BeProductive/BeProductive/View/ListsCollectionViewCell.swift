//
//  ListsCollectionViewCell.swift
//  BeProductive
//
//  Created by Arwa Alattas on 25/05/1443 AH.
//

import UIKit

class ListsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageOfListImageView: UIImageView!
    @IBOutlet weak var nameOfListLabel: UILabel!
    func setupLists(image:String,name:String){
        
        imageOfListImageView.image = UIImage(named: image)
        nameOfListLabel.text = name
    }
    
}
