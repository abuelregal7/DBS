//
//  SecondPaymentOperationTableViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class SecondPaymentOperationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var borderContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        //borderContainerView.addGradientBorder(colors: [UIColor().colorWithHexString(hexString: "FABB17").withAlphaComponent(0.5), UIColor().colorWithHexString(hexString: "45F882").withAlphaComponent(0.2)], borderWidth: 1, cornerRadius: 12, sides: .all)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
