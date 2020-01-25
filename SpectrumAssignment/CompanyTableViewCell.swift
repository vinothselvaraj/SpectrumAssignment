//
//  CompanyTableViewCell.swift
//  SpectrumAssignment
//
//  Created by C02VM0S0HV2D on 25/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyWebsite: UILabel!
    @IBOutlet weak var companyDescription: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followButton.layer.masksToBounds = true
        followButton.layer.cornerRadius = 3
        followButton.layer.borderWidth = 1.0
        followButton.layer.borderColor = (UIColor.green).cgColor

        companyImage.layer.masksToBounds = true
        companyImage.layer.cornerRadius = companyImage.frame.size.width/2        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
