//
//  ListTableViewCell.swift
//  Thiyagarajan
//
//  Created by Vj Ay on 02/11/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet var imageDisplay: UIImageView!
    @IBOutlet var heading: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var YearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
