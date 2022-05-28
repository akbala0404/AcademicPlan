//
//  PlanTableViewCell.swift
//  AcademicPlan
//
//  Created by Акбала Тлеугалиева on 5/28/22.
//  Copyright © 2022 Akbala Tleugaliyeva. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {

    @IBOutlet weak var lessonNameLabel: UILabel!
    
    @IBOutlet weak var lessonType1: UILabel!
    
    @IBOutlet weak var lessonType2: UILabel!
    
    @IBOutlet weak var lessonType3: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
