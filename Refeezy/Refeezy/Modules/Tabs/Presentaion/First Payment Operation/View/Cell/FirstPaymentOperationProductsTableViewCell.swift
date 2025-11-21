//
//  FirstPaymentOperationProductsTableViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 02/04/2025.
//

import UIKit

class FirstPaymentOperationProductsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNumberLabel: UILabel!
    @IBOutlet weak var deleteImage: UIImageView!
    
    var DeleteAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        deleteImage.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.DeleteAction?()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(item: RoomItemsDataData?) {
        productImage.loadImage(item?.image)
        productNumberLabel.text = item?.itemNumber
    }
    
}
