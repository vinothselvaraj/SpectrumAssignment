//
//  MemberTableViewCell.swift
//  SpectrumAssignment
//
//  Created by C02VM0S0HV2D on 25/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var PhoneText: UITextView!
    @IBOutlet weak var emailText: UITextView!
    @IBOutlet weak var favImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
