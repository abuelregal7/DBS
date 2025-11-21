//
//  ChooseProductsCollectionViewCell.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 02/04/2025.
//

import UIKit

class ChooseProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var checkBoxIcon: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: RoomItemsDataData?) {
        productImage.loadImage(item?.image)
        //productNameLabel.text = item.name
        productNumberLabel.text = item?.itemNumber
        
        if item?.isSelected == true {
            checkBoxIcon.image = UIImage(named: "CheckBox")
        }else {
            checkBoxIcon.image = UIImage(named: "unCheckBox")
        }
        
    }
    
}
