//
//  GridTableViewCell.swift
//  Thiyagarajan
//
//  Created by Vj Ay on 02/11/21.
//

import UIKit

class GridTableViewCell: UITableViewCell {

    @IBOutlet var gridImage: UIImageView!
    @IBOutlet var gridLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
