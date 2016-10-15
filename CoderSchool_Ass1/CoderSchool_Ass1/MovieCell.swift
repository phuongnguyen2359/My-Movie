//
//  MovieCell.swift
//  CoderSchool_Ass1
//
//  Created by Pj on 10/11/16.
//  Copyright © 2016 Pj Nguyen. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbOverview: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
