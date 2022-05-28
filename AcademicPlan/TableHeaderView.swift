//
//  TableHeaderView.swift
//  AcademicPlan
//
//  Created by Акбала Тлеугалиева on 5/27/22.
//  Copyright © 2022 Akbala Tleugaliyeva. All rights reserved.
//

import UIKit

class TableViewHeader: UIView {
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
