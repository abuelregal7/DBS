//
//  MyAddressesTableViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class MyAddressesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var defualtIcon: UIImageView!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var DeleteAddressAction: (() -> Void)?
    var MakeAddressDefualtAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        defualtIcon.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.MakeAddressDefualtAction?()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configuare(item: MyAddressesData?) {
        addressTitleLabel.text = item?.address
        if item?.isDefault == 0 {
            defualtIcon.image = UIImage(named: "unCheckboxbase")
        }else {
            defualtIcon.image = UIImage(named: "Checkboxbase")
        }
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        DeleteAddressAction?()
    }
    
}
