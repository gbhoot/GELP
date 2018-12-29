//
//  FavoriteCell.swift
//  UBottomSheet
//
//  Created by Gurpal Bhoot on 11/9/18.
//  Copyright © 2018 otw. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var placeNameLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(index: Int, name: String) {
        indexLbl.text = "\(index)"
        placeNameLbl.text = name
    }
}
