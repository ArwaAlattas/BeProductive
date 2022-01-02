//
//  RecordingsTableViewCell.swift
//  BeProductive
//
//  Created by Arwa Alattas on 28/05/1443 AH.
//

import UIKit

class RecordingsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameOfRecord: UILabel!
   
    @IBOutlet weak var playRecordButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
