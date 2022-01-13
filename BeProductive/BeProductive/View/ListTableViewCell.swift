//
//  ListTableViewCell.swift
//  BeProductive
//
//  Created by Arwa Alattas on 25/05/1443 AH.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var imageOfList: UIImageView!
    @IBOutlet weak var nameOfList: UILabel!
    @IBOutlet weak var ListView: UIView!{
        didSet{
            ListView.layer.shadowColor = UIColor.gray.cgColor
            ListView.layer.shadowOpacity = 2
            ListView.layer.shadowOffset = .zero
            ListView.layer.shadowPath = UIBezierPath(rect: ListView.bounds).cgPath
            ListView.layer.shouldRasterize = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
