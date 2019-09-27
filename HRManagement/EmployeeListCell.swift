//
//  EmployeeListCell.swift
//  HRManagement
//
//  Created by Tri Nguyen on 14/09/2019.
//  Copyright © 2019 Tri Nguyen. All rights reserved.
//

import UIKit

class EmployeeListCell: UITableViewCell {
    
    @IBOutlet weak var txtNameAge: UILabel!
    @IBOutlet weak var txtDOBCountry: UILabel!
    @IBOutlet weak var txtPayroll: UILabel!
    @IBOutlet weak var txtVehicle: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
