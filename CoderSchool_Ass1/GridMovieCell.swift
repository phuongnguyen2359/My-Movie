//
//  GridMovieCell.swift
//  CoderSchool_Ass1
//
//  Created by Pj on 10/15/16.
//  Copyright © 2016 Pj Nguyen. All rights reserved.
//

import UIKit

class GridMovieCell: UITableViewCell {

    
    @IBOutlet weak var imgGridLeft: UIImageView!
    @IBOutlet weak var imgGridRight: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
